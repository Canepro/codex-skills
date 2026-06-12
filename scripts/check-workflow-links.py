#!/usr/bin/env python3
"""Check changed skills for workflow coordination links.

This intentionally checks only changed or untracked SKILL.md files by default.
That keeps the gate useful for new work without turning old unrelated skills
into mandatory churn.
"""

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path


CONCEPTS = {
    "decision": ("decision", "decisions", "waiver", "approval"),
    "handoff": ("handoff", "handoffs", "resume"),
    "blocker": ("blocker", "blockers", "blocked"),
    "closeout": ("closeout", "cleanup", "commit", "push"),
    "report": ("report", "artifact", "proof"),
    "memory": ("memory", "second brain", "local brain"),
}

EXPECTED_LINKS = {
    "decision": ("vincent-workflow",),
    "handoff": ("vincent-workflow",),
    "blocker": ("vincent-workflow",),
    "closeout": ("codex-closeout", "vincent-workflow"),
    "report": ("codex-html-report",),
    "memory": ("second-brain-context", "vincent-workflow"),
}


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def git_changed_skill_files(root: Path) -> list[Path]:
    result = subprocess.run(
        ["git", "-C", str(root), "status", "--porcelain", "--", "skills"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    )
    files: set[Path] = set()
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        # Porcelain v1 status uses two status chars, a space, then the path.
        path_text = line[3:]
        if " -> " in path_text:
            path_text = path_text.split(" -> ", 1)[1]
        path = root / path_text
        if path.name == "SKILL.md" and path.exists():
            files.add(path)
        elif path.is_dir():
            skill_file = path / "SKILL.md"
            if skill_file.exists():
                files.add(skill_file)
    return sorted(files)


def all_skill_files(root: Path) -> list[Path]:
    return sorted((root / "skills").glob("*/SKILL.md"))


def detect_concepts(text: str) -> list[str]:
    lower = text.lower()
    return [
        concept
        for concept, needles in CONCEPTS.items()
        if any(needle in lower for needle in needles)
    ]


def missing_links(text: str, concepts: list[str]) -> dict[str, list[str]]:
    lower = text.lower()
    missing: dict[str, list[str]] = {}
    for concept in concepts:
        absent = [name for name in EXPECTED_LINKS[concept] if name not in lower]
        if absent:
            missing[concept] = absent
    return missing


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail changed skills that mention workflow concepts without linking their owners."
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Check every repo skill instead of only changed or untracked skills.",
    )
    args = parser.parse_args()

    root = repo_root()
    skill_files = all_skill_files(root) if args.all else git_changed_skill_files(root)

    failures: list[tuple[Path, dict[str, list[str]]]] = []
    for skill_file in skill_files:
        text = skill_file.read_text(encoding="utf-8")
        concepts = detect_concepts(text)
        if not concepts:
            continue
        missing = missing_links(text, concepts)
        if missing:
            failures.append((skill_file, missing))

    print("[workflow-links]")
    if not skill_files:
        print("  status: no changed skills to check")
        return 0

    if not failures:
        print("  status: changed skills have expected workflow links")
        return 0

    print("  status: missing expected workflow links")
    for skill_file, missing in failures:
        rel = skill_file.relative_to(root)
        print(f"  - {rel}")
        for concept, links in missing.items():
            print(f"    {concept}: add {', '.join(links)} or remove the workflow concept")

    print("")
    print("Add a Workflow Coordination section when the skill owns domain work but")
    print("creates durable decisions, blockers, handoffs, closeouts, reports, or memory.")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
