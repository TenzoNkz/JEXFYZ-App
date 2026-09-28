#!/usr/bin/env python3
from __future__ import annotations
import difflib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "firmware" / "JEXFYZ-V1.6.ino"
MASTER = ROOT / "firmware" / "OTA_GOLD_MASTER_LOCK.json"

def load_master() -> dict:
    return json.loads(MASTER.read_text(encoding="utf-8"))

def locate(source: str, start: str, end: str) -> tuple[int, int]:
    starts = [i for i in range(len(source)) if source.startswith(start, i)]
    ends = [i for i in range(len(source)) if source.startswith(end, i)]
    if len(starts) != 1:
        raise ValueError(f"start marker count={len(starts)}")
    if len(ends) != 1:
        raise ValueError(f"end marker count={len(ends)}")
    a, b = starts[0], ends[0]
    if b <= a:
        raise ValueError("marker order invalid")
    return a, b + len(end)

def verify(source: str, master: dict) -> bool:
    failures = []
    positions = []
    for seg in master["segments"]:
        try:
            a, b = locate(source, seg["start_marker"], seg["end_marker"])
        except ValueError as exc:
            failures.append(f'{seg["name"]}: STRUCTURE {exc}')
            continue
        positions.append((a, seg["name"]))
        current = source[a:b]
        if current != seg["content"]:
            failures.append(f'{seg["name"]}: EXACT_CONTENT_MISMATCH')
            diff = difflib.unified_diff(
                seg["content"].splitlines(keepends=True),
                current.splitlines(keepends=True),
                fromfile=f'{seg["name"]}: GOLD_MASTER',
                tofile=f'{seg["name"]}: CURRENT',
                n=3,
            )
            print("".join(diff))
    expected = [x["name"] for x in master["segments"]]
    actual = [name for _, name in sorted(positions)]
    if actual != expected:
        failures.append(
            "OTA_BLOCK_ORDER_MISMATCH: expected "
            + " -> ".join(expected)
            + " ; actual "
            + " -> ".join(actual)
        )
    for required in master.get("critical_text", []):
        if required not in source:
            failures.append(f"CRITICAL_TEXT_MISSING: {required!r}")
    for forbidden in master.get("forbidden_text", []):
        if forbidden in source:
            failures.append(f"FORBIDDEN_TEXT_PRESENT: {forbidden!r}")
    versions = re.findall(r'FW_VERSION\[\]\s*=\s*"([^"]+)"', source)
    if len(versions) != 1:
        failures.append(f"FW_VERSION_DECLARATION_COUNT={len(versions)}")
    elif not re.fullmatch(r"V\d+(?:\.\d+)?", versions[0].strip().upper()):
        failures.append(f"FW_VERSION_INVALID={versions[0]!r}")
    if failures:
        print("🛡️ OTA SATPAM: FAIL")
        for item in failures:
            print(" - " + item)
        return False
    print("🛡️ OTA SATPAM: PASS")
    return True

def repair(source: str, master: dict) -> str:
    replacements = []
    for seg in master["segments"]:
        a, b = locate(source, seg["start_marker"], seg["end_marker"])
        replacements.append((a, b, seg["content"]))
    for a, b, content in sorted(replacements, reverse=True):
        source = source[:a] + content + source[b:]
    return source

def main() -> int:
    if not SOURCE.is_file() or not MASTER.is_file():
        print("🛡️ OTA SATPAM: FAIL — source/master missing")
        return 2
    source = SOURCE.read_text(encoding="utf-8")
    master = load_master()
    if "--repair" in sys.argv:
        print("📋 OTA SEKRETARIS: restoring protected OTA blocks...")
        try:
            source = repair(source, master)
        except ValueError as exc:
            print(f"📋 OTA SEKRETARIS: STOP — unsafe repair boundary: {exc}")
            return 3
        SOURCE.write_text(source, encoding="utf-8")
        print("📋 OTA SEKRETARIS: restore complete.")
    return 0 if verify(source, master) else 1

if __name__ == "__main__":
    raise SystemExit(main())
