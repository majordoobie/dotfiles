#!/usr/bin/python3
"""Play/pause the Apple Music app.

Replaces Raycast's Music extension "Toggle Play/Pause". Alfred runs it on F10
and shows whatever this prints as a notification.
"""
import subprocess

# Check the state first, then explicitly pause or play. (Reading the state right
# after "playpause" returns the old state, which made the notification backwards.)
APPLESCRIPT = """
tell application "Music"
    if player state is playing then
        pause
        return "Paused"
    else
        play
        try
            return "Playing: " & name of current track & " - " & artist of current track
        on error
            return "Playing"
        end try
    end if
end tell
"""


def main():
    result = subprocess.run(
        ["/usr/bin/osascript", "-e", APPLESCRIPT],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"Music play/pause failed: {result.stderr.strip()}")
        return
    print(result.stdout.strip())


if __name__ == "__main__":
    try:
        main()
    except Exception as err:  # anything else: still print so Alfred's notification says it failed
        print(f"Music play/pause failed: {err}")
