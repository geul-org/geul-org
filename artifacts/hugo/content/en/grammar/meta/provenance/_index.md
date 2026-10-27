---
title: "Meta — Provenance"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "The Meta provenance class (upper 3 bits `010`, `0x20`-`0x2F`) records who made and recorded the document, and when. The source material is written with the evidence Edge SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta provenance class (upper 3 bits `010`, Codec `0x20`-`0x2F`) records who made and recorded the document, and when.

- The author, the recorder, and their times follow git's author and committer model (`AUTHOR` and `CREATED-AT`, `RECORDED-BY` and `RECORDED-AT`).
- Removing provenance does not change the content of the statements. Only the material for judging trust is lost.
- Source material is not in this class. The source of the whole document is written in the HEAD, and the source of an individual record in the BODY, with the evidence Edge [SOURCE](/grammar/edge/source/). The corresponding range within the source, the time it was obtained, and the source hash are QUALIFIERs attached to that SOURCE (page P304 and section P958, retrieved P813, checksum P4092).
- If properties that belong to a source (range within the source, time obtained) were placed as Meta, it could not be decided which source they belong to when there are several sources. So they are written as QUALIFIERs whose Target is the SOURCE. Codecs `0x26`-`0x2F` are reserved.
