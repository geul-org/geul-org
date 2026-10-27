---
title: "Meta — Declaration"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "The Meta declaration class (upper 3 bits `001`, `0x10`-`0x1F`) holds interpretation declarations. It sets the spec version, profile, document ID, period in force, and default language."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta declaration class (upper 3 bits `001`, Codec `0x10`-`0x1F`) holds interpretation declarations. A declaration changes the rules of interpretation, so every decoder must handle it. The scope of a declaration is that document.

- `SPEC-VERSION` decides how the remaining records are read, so it holds just an integer with no embedded Value. GEUL v1 is `0x0001` (record `1890 0001`).
- `DOC-ID` is a `DOC-POINTER` (Issuer, document ID, version `0`) that points to the document itself. Without it the document is unnamed and can be pointed to only by its content hash.
- A name for addressing a document is not placed as Meta. The Issuer's name index `documents.geul` attaches it with the statement `BIND`, and a human-readable title is attached with `LABEL` ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)).
