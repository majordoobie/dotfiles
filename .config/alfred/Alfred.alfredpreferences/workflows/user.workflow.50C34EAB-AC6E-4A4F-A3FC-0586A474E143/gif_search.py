#!/usr/bin/python3
"""Open a GIPHY search in the default browser.

Replaces Raycast's GIF Search extension (browser version, no API key needed).
Alfred runs it for "gif <words>", e.g. "gif happy dance" -> giphy.com/search/happy-dance
"""
import subprocess
import sys
import urllib.parse


def main():
    query = " ".join(sys.argv[1:]).strip()
    # GIPHY search URLs use dashes between words
    slug = urllib.parse.quote("-".join(query.split()))
    url = f"https://giphy.com/search/{slug}" if slug else "https://giphy.com/"
    subprocess.run(["/usr/bin/open", url], check=False)


if __name__ == "__main__":
    main()
