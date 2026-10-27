---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE is a policy Meta that records usage restrictions such as no training and no commercial use."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records usage restrictions (for example, no training, no commercial use).

## Layout

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length extension TAG]
Payload           text or a Reference that expresses the usage restriction
```

- Codec: Meta `0x55`, policy class (`101`)
- Payload: embedded Value or Reference
- Count: several allowed

## Open Questions

- The code table of restriction kinds.
