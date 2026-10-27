---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT is a verification Meta that records the judgment result for the whole document (Pass, Review, Fail) in 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the judgment result for the whole document. Judgments at the level of a node or record are handled by [TOULMIN](/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`).

## Layout

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length extension TAG]
Judgment          1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, verification class (`100`)
- Payload: raw value (judgment, 1 WORD)
- Count: at most one

## Interpretation and Validity

- It is a verification class, so it is left out of the content hash.
- A judgment about another document is placed in the BODY of a document different from the one being judged.

## Open Questions

- Whether to write the judging party and the grounds together.
