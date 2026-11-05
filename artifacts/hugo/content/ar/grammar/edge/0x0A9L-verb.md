---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB هو Edge العبارة الفعلية."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB هو Edge العبارة الفعلية. صيغته المختصرة هي [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| البند | القيمة |
|---|---|
| الاسم | `VERB` (BIND مستند المواصفة `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| مستند المواصفة | `0x00000000/codecs/0x00000A90/` (هدف DECLARE `0A90`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 9 |
| Kind | Edge · العائلة: العبارة، الحزمة: القضية |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | العبارة الفعلية |
| جانب Hugo | `edge/_index.md` |

## التخطيط {#레이아웃}

لم يُحدَّد التخطيط بعد. يتبع التخطيط المشترك لـ Edge (TAG، [Length TAG ممتد]، Edge Id، المكوّنات) ([Edge](_index.md#레이아웃)).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0A90`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md)، [Edge](_index.md)، [TRIPLE](0x0AAL-triple.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A90/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
