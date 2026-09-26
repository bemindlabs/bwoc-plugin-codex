#!/usr/bin/env python3
"""Check every `bwoc …` command the plugin tells Claude to run against a real CLI.

Scans fenced code blocks and inline code spans in skills/ and hooks/
for lines that start with `bwoc `, turns placeholders into dummy values, and runs
`<bwoc> <argv> --help`. clap parses every subcommand and flag before printing
help — an unknown one exits non-zero — but nothing executes, so mutating
commands are checked safely.

Usage: scripts/cli-contract.py [path/to/bwoc]   (default: `bwoc` on PATH)
Exit 1 when any command is rejected.
"""

import pathlib
import re
import shlex
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
BWOC = sys.argv[1] if len(sys.argv) > 1 else "bwoc"
DIRS = ("skills", "hooks")
# Stands in for `<agent>`-style placeholders. When clap rejects the placeholder
# itself — as a subcommand (`bwoc <verb> --help`, a generic pattern) or as a
# typed value (`--current <n>` wants a number) — that is not a contract break.
PLACEHOLDER = "x-placeholder"
# `--help` only parses; a CLI that hangs here is broken, and must not stall CI.
TIMEOUT_S = 30


def snippets(text):
    """Yield (line_no, command) for each `bwoc …` in code blocks or inline code."""
    fenced = False
    for no, line in enumerate(text.splitlines(), 1):
        if line.lstrip().startswith("```"):
            fenced = not fenced
            continue
        if fenced:
            cmd = line.strip().removeprefix("$ ")
            if cmd.startswith("bwoc "):
                yield no, cmd
        else:
            for span in re.findall(r"`(bwoc [^`]+)`", line):
                yield no, span


def argvs(cmd):
    """The argv lists one documented command stands for (alternatives expanded)."""
    # Drop [optional …] groups first: one may hold ` | ` alternatives, which
    # the shell-operator split below would otherwise cut through.
    cmd = re.sub(r"\[[^\]]*\]", "", cmd)
    cmd = re.split(r"\s+#|\s*(?:\|\||&&|;|\s\|\s)", cmd)[0]
    cmd = re.sub(r"<[^>]*>", PLACEHOLDER, cmd)  # <agent>, "<title>"
    cmd = cmd.replace("$ARGUMENTS", "").replace("…", "").replace("...", "")
    try:
        tokens = shlex.split(cmd)[1:]
    except ValueError:
        tokens = cmd.split()[1:]
    variants = [[]]
    for tok in tokens:
        alts = re.split(r"[|/]", tok)
        if len(alts) > 1 and all(re.fullmatch(r"[a-z][a-z0-9-]*", a) for a in alts):
            variants = [v + [a] for v in variants for a in alts]
        else:
            variants = [v + [tok] for v in variants]
    return variants


def main():
    checked, rejected = set(), []
    for d in DIRS:
        for path in sorted((ROOT / d).rglob("*.md")):
            for no, cmd in snippets(path.read_text(encoding="utf-8")):
                for argv in argvs(cmd):
                    key = tuple(argv)
                    if not argv or key in checked:
                        continue
                    checked.add(key)
                    try:
                        r = subprocess.run(
                            [BWOC, *argv, "--help"],
                            capture_output=True,
                            text=True,
                            timeout=TIMEOUT_S,
                        )
                    except subprocess.TimeoutExpired:
                        rel = path.relative_to(ROOT)
                        rejected.append(
                            f"{rel}:{no}: bwoc {' '.join(argv)} → hung past {TIMEOUT_S}s"
                        )
                        continue
                    generic = any(
                        f"{what} '{PLACEHOLDER}'" in r.stderr
                        for what in ("unrecognized subcommand", "invalid value")
                    )
                    if r.returncode != 0 and not generic:
                        why = (r.stderr or r.stdout).strip().splitlines()[:1]
                        rel = path.relative_to(ROOT)
                        rejected.append(f"{rel}:{no}: bwoc {' '.join(argv)} → {why}")
    try:
        version = subprocess.run(
            [BWOC, "--version"], capture_output=True, text=True, timeout=TIMEOUT_S
        ).stdout.strip()
    except subprocess.TimeoutExpired:
        version = f"{BWOC} (--version hung)"
        rejected.append(f"bwoc --version → hung past {TIMEOUT_S}s")
    print(f"cli contract: {len(checked)} commands checked against {version}")
    for line in rejected:
        print(f"  ✗ {line}")
    return 1 if rejected else 0


if __name__ == "__main__":
    sys.exit(main())
