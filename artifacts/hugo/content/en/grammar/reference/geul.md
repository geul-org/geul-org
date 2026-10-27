---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL is a declaration Reference that points to a target with an entity ID issued by geul.org under CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL is a declaration Reference that points to an entity issued by geul.org under CC0. It is a serial ID whose number carries no meaning. An identifier that carries meaning in its bits is handled by the separate Codec [GEUL-SIDX](/grammar/reference/geul-sidx/) (`0011`).

## Layout

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length extension TAG]
GEUL ID           unsigned big-endian in the shortest width
```

- Small numbers are assigned to high-frequency entities. An ID that fits in 1 WORD makes 2 WORD in total.
- ID assignment and the registry are managed by geul.org. Only items derived from CC0 sources go into the registry.
- A Variable is an anonymous variable of that kind ([Reference](/grammar/reference/), Variable).

## Examples

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Open Questions

- The GEUL ID assignment rules and the public format of the registry.

## Related Pages

- [Reference](/grammar/reference/), [GEUL-SIDX](/grammar/reference/geul-sidx/)
