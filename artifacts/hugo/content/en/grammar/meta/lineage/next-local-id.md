---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID is a lineage Meta that writes, in the version list, the LOCAL ID the next version of the document will assign to new statements (auto increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the LOCAL ID that the next version of the document will assign to a new statement (a DBMS auto increment, MySQL `AUTO_INCREMENT`). Every LOCAL ID assigned in any version of the document is smaller than this value.

## Layout

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           the next LOCAL ID to assign, an unsigned integer in the shortest width
```

- Codec: Meta `0x3C`, lineage class (`011`)
- Payload: raw value (an unsigned integer in the shortest width)
- Count: at most one
- Where it goes: the HEAD of the version list document `versions.geul` ([PUBLICATION](/grammar/edge/publication/))

## Interpretation and Validity

- A LOCAL ID (including an Edge Id) is an identity that persists across versions ([Revisions](/grammar/document/#revisions)). A new statement takes this value and the value grows by 1. A deleted LOCAL ID is not reused. So even if the statement holding the maximum is deleted, this value does not shrink.
- LOCAL ID `0` is not assigned, so the first value is `1`. If there is no version yet, this Meta is not placed and the next number is `1`.
- When the publisher publishes a version, it updates this in the new list document. It must be greater than any LOCAL ID used in a published version. If it is less than or equal, it is invalid.
- The value only grows. If it is smaller than the value in the previous list document ([PARENT](/grammar/meta/lineage/parent/)), it is invalid.
- It is absent in documents that do no version management (documents without `versions.geul`, unnamed documents). Such documents also have no diff ([DELTA-BASE](/grammar/meta/lineage/delta-base/)).
- It is not placed in the document body (the version document). Remembering the number is not document content but the state of the publisher that continues the document (the refs side of git, not a commit).

## Example

The next number to assign is 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORDs), Payload `020C`.
