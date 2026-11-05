---
title: "BLOCK (0x0F0L)"
weight: 240
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BLOCK هو Codec لحزمة الجملة في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLOCK هو Codec لحزمة الجملة في Edge التنفيذ. المعنى: حزمة جمل مرتّبة.

| البند | القيمة |
|---|---|
| الاسم | `BLOCK` (مستند المواصفة BIND `BLOCK`) |
| TAG ID | `0x0F0L` |
| Codec ID | `0x00000F00` |
| مستند المواصفة | `0x00000000/codecs/0x00000F00/` (هدف DECLARE `0F00`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 16 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: الجملة |
| TAG WORD | `0000 1111 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | حزمة جمل مرتّبة. عدد الجمل، الجملة × عدد الجمل |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

عدد الجمل، الجملة × عدد الجمل.

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0F00`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [ASSIGN](0x0F1L-assign.md)، [IF](0x0F2L-if.md)، [SWITCH](0x0F3L-switch.md)، [WHILE](0x0F4L-while.md)، [FOREACH](0x0F5L-foreach.md)، [JUMP](0x0F6L-jump.md)، [RETURN](0x0F7L-return.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000F00/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F0000000000
BODY
#1 DECLARE 0x0F00
#2 BIND #1 "BLOCK"
```
