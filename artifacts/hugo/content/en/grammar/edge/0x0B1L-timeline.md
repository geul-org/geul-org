---
title: "TIMELINE (0x0B1L)"
weight: 177
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TIMELINE is a statement Edge that writes the order of events."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIMELINE is a statement Edge that writes the order of events. Meaning: a structure for expressing the order of the world and events.

| Item | Value |
|---|---|
| Name | `TIMELINE` (specification document BIND `TIMELINE`) |
| TAG ID | `0x0B1L` |
| Codec ID | `0x00000B10` |
| Specification document | `0x00000000/codecs/0x00000B10/` (DECLARE target `0B10`) |
| Section | 5 `0101` (Edge statement), offset within section C = 17 |
| Kind | Edge · family: statement, group: structure |
| TAG WORD | `0000 1011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A structure for expressing the order of the world and events |
| Hugo side | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0001 LLLL      Codec 0x0B1L
[Length extension TAG]
Per-Codec TAG     1 WORD. Subform
Edge Id           LOCAL Reference record
Components        set by the subform
```

- This is a Codec with subforms. One Codec-specific TAG WORD specifies the subform ([Record and TAG WORD](../record.md#레코드-레이아웃)).
- The subforms and components are not yet defined.

## Codec document {#코덱-문서}

The layout is not yet defined. The codec document holds only DECLARE (target `0B10`). FIELDs will be added once the layout is defined.

## Related pages {#관련-페이지}

- [WORLD](0x0B0L-world.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (how to declare a Codec that has subforms)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000B10/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B1000000000
BODY
#1 DECLARE 0x0B10
#2 BIND #1 "TIMELINE"
```
