#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"
import json
import os
import requests
import sys

def parse_packages(text):
    res = []
    for package in resp.text.split("\n\n"):
        if not package: continue
        pkg = {}
        for field in package.split("\n"):
            if field.startswith(" "): # multiline string
                pkg[k] += "\n" + field[1:]
            else:
                [k, v] = field.split(": ", 1)
                pkg[k] = v
        res.append(pkg)
    return res

def generate_sources(packages):
    return {
        pkg['Package']: {
            "url": "https://labs.picotech.com/rc/picoscope7/debian/"
            + pkg["Filename"],
            "sha256": pkg["SHA256"],
            "version": pkg["Version"],
        }
        for pkg in pkgs
    }

out = {}
for nix_system, release in {"x86_64-linux": "amd64"}.items():
    resp = requests.get(
        f"https://labs.picotech.com/rc/picoscope7/debian//dists/picoscope/main/binary-{release}/Packages"
    )
    if resp.status_code != 200:
        print(
            f"error: could not fetch data for release {release} (code {resp.code})",
            file=sys.stderr,
        )
        sys.exit(1)
    pkgs = parse_packages(resp.text)
    out[nix_system] = generate_sources(pkgs)

with open(f"{os.path.dirname(__file__)}/sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
    f.write('\n')

