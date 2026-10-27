---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Die Meta-Klasse IMPORT (obere 3 Bit `110`, `0x60`~`0x6F`) importiert externe Dokumente über eine IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Klasse IMPORT (obere 3 Bit `110`, Codec `0x60`~`0x6F`) importiert externe Dokumente über eine IMPORT ID. Es gibt nur einen Codec: `IMPORT-DOC` (`0x60`).

- IMPORT importiert nur Dokumente. Ziele innerhalb des importierten Dokuments werden im BODY über die Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) angesprochen ([Reference](/de/grammar/reference/)).
- Mit angegebener Versions-ID bindet es an diese Fassung, bei `0` an die zum Zeitpunkt der Interpretation neueste Fassung. Veröffentlichte Dokumente geben die Version an.
- Der HEAD des importierten Dokuments wird nicht importiert. Reference- und Value-Records werden nicht importiert, sondern kopiert.
