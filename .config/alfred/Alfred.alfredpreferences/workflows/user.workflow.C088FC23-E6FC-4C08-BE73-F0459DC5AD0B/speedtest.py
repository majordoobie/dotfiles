#!/usr/bin/python3
"""Run macOS's built-in network speed test (networkQuality) and print a one-line summary.

Replaces Raycast's Speedtest extension. Alfred runs it for the "speedtest" keyword
and shows whatever this prints as a notification.
"""
import json
import subprocess

NETWORK_QUALITY = "/usr/bin/networkQuality"


def mbps(bits_per_second):
    return bits_per_second / 1_000_000


def main():
    # -c = computer-readable (JSON) output; a full run takes roughly 15-20 seconds
    result = subprocess.run(
        [NETWORK_QUALITY, "-c"],
        capture_output=True,
        text=True,
        timeout=120,
    )
    if result.returncode != 0:
        print(f"Speed test failed: {result.stderr.strip() or f'exit code {result.returncode}'}")
        return
    data = json.loads(result.stdout)
    print(
        f"Down {mbps(data['dl_throughput']):.1f} Mbps | "
        f"Up {mbps(data['ul_throughput']):.1f} Mbps | "
        f"Ping {data['base_rtt']:.0f} ms"
    )


if __name__ == "__main__":
    try:
        main()
    except Exception as err:  # anything else: still print so Alfred's notification says it failed
        print(f"Speed test failed: {err}")
