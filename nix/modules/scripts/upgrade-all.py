#!/usr/bin/python3
"""upgrade-all: update everything on this Mac in one go.

  1. nix   nh darwin switch ~/dotfiles/nix/ --hostname <this host> --update
  2. brew  brew upgrade --yes
  3. mas   sudo mas update   (App Store apps; mas needs root)

Afterwards it lists apps that were updated while they were running, so you know
what to quit (⌘Q) and reopen. A browser updated underneath itself can't open pages.

Usage: upgrade-all [--skip nix,brew,mas]
"""
import argparse
import os
import plistlib
import shutil
import subprocess
import sys

FLAKE = os.path.expanduser("~/dotfiles/nix/")
STEP_NAMES = ("nix", "brew", "mas")


def find(tool, fallback):
    """Locate a tool on PATH, falling back to its usual install location."""
    path = shutil.which(tool)
    if path:
        return path
    return fallback if os.path.exists(fallback) else None


def hostname():
    result = subprocess.run(["/usr/sbin/scutil", "--get", "LocalHostName"], capture_output=True, text=True)
    return result.stdout.strip()


def bundle_version(bundle):
    try:
        with open(os.path.join(bundle, "Contents", "Info.plist"), "rb") as fh:
            info = plistlib.load(fh)
    except (OSError, plistlib.InvalidFileException):  # removed or mid-update
        return None
    return info.get("CFBundleShortVersionString") or info.get("CFBundleVersion") or "?"


def running_app_versions():
    """Map each running app under /Applications to the version currently on disk."""
    out = subprocess.run(["/bin/ps", "-axo", "comm="], capture_output=True, text=True).stdout
    bundles = {
        line.split(".app/", 1)[0] + ".app"
        for line in out.splitlines()
        if line.startswith("/Applications/") and ".app/Contents/MacOS/" in line
    }
    return {bundle: bundle_version(bundle) for bundle in bundles}


def build_steps(host):
    nh = find("nh", "/run/current-system/sw/bin/nh")
    brew = find("brew", "/opt/homebrew/bin/brew")
    mas = find("mas", "/opt/homebrew/bin/mas")
    return [
        ("nix", "flake update + rebuild", nh and [nh, "darwin", "switch", FLAKE, "--hostname", host, "--update"]),
        # Homebrew 7 asks "proceed with the upgrade? [y/n]" by default; --yes skips it
        ("brew", "formulae and casks", brew and [brew, "upgrade", "--yes"]),
        # sudo resets PATH, so mas is passed by full path
        ("mas", "App Store apps", mas and ["/usr/bin/sudo", mas, "update"]),
    ]


def main():
    parser = argparse.ArgumentParser(description="Update nix, Homebrew and App Store apps in one go.")
    parser.add_argument("--skip", default="", help="comma-separated steps to skip: nix,brew,mas")
    args = parser.parse_args()
    skip = {name.strip() for name in args.skip.split(",") if name.strip()}
    unknown = skip - set(STEP_NAMES)
    if unknown:
        parser.error(f"unknown step(s): {', '.join(sorted(unknown))}")

    host = hostname()
    before = running_app_versions()
    results = []

    # One sudo prompt (Touch ID) up front; nh and mas reuse it
    if skip != set(STEP_NAMES):
        subprocess.run(["/usr/bin/sudo", "-v"])

    interrupted = False
    for name, desc, cmd in build_steps(host):
        if interrupted or name in skip:
            results.append((name, "skipped"))
            continue
        if not cmd:
            results.append((name, "not installed"))
            continue
        print(f"\n==> {name}: {desc}", flush=True)
        try:
            code = subprocess.run(cmd).returncode
        except KeyboardInterrupt:
            interrupted = True
            results.append((name, "interrupted"))
            continue
        results.append((name, "ok" if code == 0 else f"failed (exit {code})"))

    # Apps whose version on disk changed while they kept running
    after = running_app_versions()
    restart = [
        f"{os.path.basename(bundle)[:-4]} ({old} -> {after[bundle]})"
        for bundle, old in sorted(before.items())
        if bundle in after and after[bundle] and old and after[bundle] != old
    ]

    print(f"\nupgrade-all ({host})")
    for name, status in results:
        print(f"├── {name:<5} {status}")
    if restart:
        print("└── quit (⌘Q) and reopen, updated while running:")
        for i, app in enumerate(restart):
            print(f"    {'└──' if i == len(restart) - 1 else '├──'} {app}")
    else:
        print("└── no running apps were updated")

    return 1 if any(s.startswith(("failed", "interrupted")) for _, s in results) else 0


if __name__ == "__main__":
    sys.exit(main())
