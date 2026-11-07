#!/usr/bin/env bash
#
# @raycast.schemaVersion 1
# @raycast.title Toggle Audio Output by ID
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🎧
# Toggle between two output device IDs: BUILTIN ↔ CALDIGIT.

BUILTIN="MacBook Pro Speakers"
CALDIGIT="FiiO K7 "

# 1) Ensure SwitchAudioSource is installed
if ! command -v SwitchAudioSource &>/dev/null; then
    echo "Error: SwitchAudioSource not found. Install with: brew install switchaudio-osx"
    exit 1
fi

# 1b) Ensure jq is installed (for JSON parsing)
if ! command -v jq &>/dev/null; then
    echo "Error: jq not found. Install with: brew install jq"
    exit 1
fi

# 2) Read the current output device’s ID (via JSON)
CURRENT=$(SwitchAudioSource -c -f json | jq -r .name)

# 3) Pick the “other” ID
if [[ "${CURRENT}" == "${BUILTIN}" ]]; then
    NEXT=${CALDIGIT}
elif [[ "${CURRENT}" == "${CALDIGIT}" ]]; then
    NEXT=${BUILTIN}
else
    echo "current is something else"
    NEXT=${BUILTIN} # if it’s something else, default → BUILTIN
fi

# 4) Switch to it
SwitchAudioSource -s "${NEXT}"
