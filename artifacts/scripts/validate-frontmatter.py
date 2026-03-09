#!/usr/bin/env python3
"""Validate Hugo front matter for required fields.

Usage:
  python3 scripts/validate-frontmatter.py          # validate only
  python3 scripts/validate-frontmatter.py --fix    # fix author names in place
"""
import sys
import os
import re
import yaml
from pathlib import Path

REQUIRED_PAGE = ["title", "weight", "date", "lastmod", "tags", "summary", "author", "authorLink", "image"]
REQUIRED_INDEX = ["title", "summary", "image"]
SKIP_DIRS = {"languages"}

AUTHOR_MAP = {
    "en": "Junwoo Park", "es": "Junwoo Park", "pt": "Junwoo Park",
    "id": "Junwoo Park", "fr": "Junwoo Park", "de": "Junwoo Park",
    "ko": "박준우", "zh": "朴俊宇", "ja": "朴俊宇",
    "ar": "جونو بارك", "ru": "Джунву Пак", "he": "ג'ונו פארק",
}

def parse_frontmatter(path):
    with open(path, encoding="utf-8") as f:
        text = f.read()
    if not text.startswith("---"):
        return None, text
    parts = text.split("---", 2)
    if len(parts) < 3:
        return None, text
    return yaml.safe_load(parts[1]), text

def fix_author(path, text, lang):
    expected = AUTHOR_MAP.get(lang)
    if not expected:
        return False
    # Replace author line in front matter
    new_text = re.sub(
        r'^(author:\s*)"[^"]*"',
        rf'\1"{expected}"',
        text,
        count=1,
        flags=re.MULTILINE,
    )
    if new_text != text:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_text)
        return True
    return False

def validate(content_dir, do_fix=False):
    errors = []
    fixed = 0
    for md in sorted(Path(content_dir).rglob("*.md")):
        rel = md.relative_to(content_dir)
        parts = rel.parts
        if len(parts) < 2:
            continue

        lang = parts[0]
        section_parts = parts[1:]

        if any(d in SKIP_DIRS for d in section_parts):
            continue

        fm, text = parse_frontmatter(md)
        if fm is None:
            errors.append((rel, "no front matter found"))
            continue

        is_index = md.name == "_index.md"
        required = REQUIRED_INDEX if is_index else REQUIRED_PAGE

        for field in required:
            if field not in fm or fm[field] is None:
                errors.append((rel, f"missing '{field}'"))
            elif field == "summary" and isinstance(fm[field], str) and len(fm[field].strip()) == 0:
                errors.append((rel, "empty 'summary'"))

        if not is_index and "author" in fm and fm["author"]:
            expected = AUTHOR_MAP.get(lang)
            if expected and fm["author"] != expected:
                if do_fix:
                    if fix_author(md, text, lang):
                        fixed += 1
                        continue
                errors.append((rel, f"author should be '{expected}', got '{fm['author']}'"))

    return errors, fixed

if __name__ == "__main__":
    content_dir = os.path.join(os.path.dirname(__file__), "..", "hugo", "content")
    content_dir = os.path.abspath(content_dir)
    do_fix = "--fix" in sys.argv

    errors, fixed = validate(content_dir, do_fix)

    if fixed:
        print(f"FIXED: {fixed} author name(s) corrected\n")

    if errors:
        print(f"FAIL: {len(errors)} error(s)\n")
        for path, msg in errors:
            print(f"  {path}: {msg}")
        sys.exit(1)
    else:
        print("OK: all front matter valid")
        sys.exit(0)
