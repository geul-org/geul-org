---
title: "SCENE (0x0B2L)"
weight: 178
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SCENE is a statement Edge that writes scene structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SCENE is a statement Edge that writes scene structure. Meaning: a scene structure for statements with screenplay-like characteristics.

| Item | Value |
|---|---|
| Name | `SCENE` (specification document BIND `SCENE`) |
| TAG ID | `0x0B2L` |
| Codec ID | `0x00000B20` |
| Specification document | `0x00000000/codecs/0x00000B20/` (DECLARE target `0B20`) |
| Section | 5 `0101` (Edge statement), offset within section C = 18 |
| Kind | Edge · family: statement, group: structure |
| TAG WORD | `0000 1011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A scene structure for statements with screenplay-like characteristics |
| Hugo side | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0010 LLLL      Codec 0x0B2L
[Length extension TAG]
Per-Codec TAG     1 WORD. Subform
Edge Id           LOCAL Reference record
Components        set by the subform
```

- This is a Codec with subforms. One Codec-specific TAG WORD specifies the subform ([Record and TAG WORD](../record.md#레코드-레이아웃)).
- The subforms and components are not yet defined.

## Codec document {#코덱-문서}

The layout is not yet defined. The codec document holds only DECLARE (target `0B20`). FIELDs will be added once the layout is defined.

## Related pages {#관련-페이지}

- [WORLD](0x0B0L-world.md), [TIMELINE](0x0B1L-timeline.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (how to declare a Codec that has subforms)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000B20/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B2000000000
BODY
#1 DECLARE 0x0B20
#2 BIND #1 "SCENE"
```
