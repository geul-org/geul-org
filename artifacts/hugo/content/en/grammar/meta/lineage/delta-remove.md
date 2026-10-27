---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE is a lineage Meta that lists, in a diff, the LOCAL IDs (Edge Ids) to remove from the BODY of the base snapshot."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

In a diff ([DELTA-BASE](/grammar/meta/lineage/delta-base/)), records the LOCAL IDs (Edge Ids) of the records to remove from the BODY of the base snapshot ("Article X deleted").

## Layout

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length extension TAG]
LOCAL IDs to delete    LOCAL Reference record × 1 or more
```

- Codec: Meta `0x3B`, lineage class (`011`)
- Payload: one or more [LOCAL](/grammar/reference/local/) Reference records
- Count: at most one

## Interpretation and Validity

- Placed only in a document that has `DELTA-BASE`.
- Each LOCAL ID must be an Edge Id in the BODY of the base snapshot. If not, it is invalid. Listing the same ID twice is invalid.
- Placing the same Edge Id again in the BODY of the same diff is invalid (deletion and amendment cannot be done together).
- A deleted LOCAL ID is not reassigned to another target in later versions ([Revisions](/grammar/document/#revisions)).
- A diff BODY having no record means "unchanged". So deletion is expressed only with this Meta.
- HEAD Edges (the [SOURCE](/grammar/edge/source/#source-of-the-whole-document) for the whole document and its QUALIFIERs) are not listed. The HEAD is replaced wholesale by the diff's HEAD ([Diff Storage](/grammar/document/#diff-storage)).

## Example

Delete LOCAL `#7` and `#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORDs), LOCAL References `0088 0007`, `0088 000C`.
