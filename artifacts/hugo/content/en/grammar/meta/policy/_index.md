---
title: "Meta — Policy"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "The Meta policy class (upper 3 bits `101`, `0x50`-`0x5F`) sets how a document is handled (license, scope of disclosure, privacy, retention, consent, usage restrictions)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta policy class (upper 3 bits `101`, Codec `0x50`-`0x5F`) sets how a document is handled: license, scope of disclosure, privacy level, retention period, consent, and usage restrictions.

- A policy does not change interpretation; it sets how to handle the document.
- The original license of a work inside a byte sequence is recorded with `LICENSE`.
