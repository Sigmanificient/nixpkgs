#!/usr/bin/env python

import sys

import toml


def quote(s: str) -> str:
    escaped = s.replace('"', r"\"").replace("\n", r"\n").replace("\\", "\\\\")
    return f'"{escaped}"'


def main() -> None:
    data = toml.load(sys.stdin)

    # There is no dependency to vendor in this project.
    if list(data.keys()) != ["source"]:
        return

    # this value is non deterministic
    data["source"]["vendored-sources"]["directory"] = "@vendor@"

    lines = []
    inner = data["source"]
    for source, attrs in sorted(inner.items()):
        lines.append(f"[source.{quote(source)}]")
        if source == "vendored-sources":
            lines.append('"directory" = "@vendor@"\n')
        else:
            for key, value in sorted(attrs.items()):
                attr = f"{quote(key)} = {quote(value)}"
                lines.append(attr)
        lines.append("")

    result = "\n".join(lines)
    real = toml.loads(result)
    assert real == data, f"output = {real} while input = {data}"

    print(result)


if __name__ == "__main__":
    main()
