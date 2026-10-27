---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "The Meta IMPORT class (upper 3 bits `110`, `0x60`-`0x6F`) imports an external document under an IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta IMPORT class (upper 3 bits `110`, Codec `0x60`-`0x6F`) imports an external document under an IMPORT ID. The only Codec is `IMPORT-DOC` (`0x60`).

- IMPORT imports documents only. A target inside the imported document is pointed to with the Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) in the BODY ([Reference](/grammar/reference/)).
- If a version ID is written, it is bound to that edition; if `0`, to the latest edition at the time of interpretation. A published document writes the version.
- The HEAD of the imported document is not imported. Reference and Value records are copied, not imported.
