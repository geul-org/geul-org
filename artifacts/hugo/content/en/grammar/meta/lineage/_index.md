---
title: "Meta — Lineage"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "The Meta lineage class (upper 3 bits `011`, `0x30`-`0x3F`) records what the document came from and how, using git's commit model."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta lineage class (upper 3 bits `011`, Codec `0x30`-`0x3F`) records what the document came from and how. Lineage follows git's commit model, and the unit that corresponds to a commit is the document.

- The **content hash** points to the content of one copy of a document (git commit id). It is the SHA-256 from the opening record (`DOC-*`) up to just before `END`, and verification-class (`100`) records are left out of the calculation.
- The **version ID** is a 2 WORD integer assigned within a named document, starting at 1 in the order of publication. `0` means the version is not written.
- Lineage Meta points to a version by its content hash. A `PARENT` inside the document is also part of the hash, so the content hash becomes a hash chain linking the whole history.
- History is not erased. A correction is issued as a new version. Pointers that change, like a branch, are not placed in the document.
- `DELTA-BASE` and `DELTA-REMOVE` are a format for storing a version as a diff against a base version. A version is always defined as a snapshot.

The revision rules are in [Document](/grammar/document/).
