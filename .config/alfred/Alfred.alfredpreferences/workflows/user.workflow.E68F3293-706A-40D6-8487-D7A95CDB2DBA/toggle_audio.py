#!/usr/bin/python3
"""Toggle audio output between the MacBook speakers and the FiiO K7 DAC.

Ported from the Raycast script command (toggle_audio.sh). Alfred runs it on F12
and shows whatever this prints as a notification.
"""
import subprocess

# Alfred runs scripts with a minimal PATH (no Homebrew), so use the full path
SWITCH_AUDIO = "/opt/homebrew/bin/SwitchAudioSource"

BUILTIN = "MacBook Pro Speakers"
# The DAC's device name ends with a trailing space ("FiiO K7 "), so match by prefix
DAC_PREFIX = "FiiO K7"


def switch_audio(*args):
    """Run SwitchAudioSource against output devices and return its stdout."""
    result = subprocess.run(
        [SWITCH_AUDIO, "-t", "output", *args],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout


def main():
    # Keep device names exactly as reported (trailing spaces included) so -s matches
    devices = [name for name in switch_audio("-a").splitlines() if name.strip()]
    current = switch_audio("-c").rstrip("\n")
    dac = next((name for name in devices if name.startswith(DAC_PREFIX)), None)

    # BUILTIN -> DAC, DAC -> BUILTIN, anything else -> BUILTIN
    if current == BUILTIN:
        if dac is None:
            print(f"{DAC_PREFIX} not connected, staying on {BUILTIN}")
            return
        target = dac
    else:
        target = BUILTIN

    switch_audio("-s", target)
    print(f"Switched to {target.strip()}")


if __name__ == "__main__":
    try:
        main()
    except FileNotFoundError:
        print("SwitchAudioSource not found. Install with: brew install switchaudio-osx")
    except subprocess.CalledProcessError as err:
        print(f"SwitchAudioSource failed: {(err.stderr or err.stdout).strip()}")
    except Exception as err:  # anything else: still print so Alfred's notification says it failed
        print(f"Audio toggle failed: {err}")
