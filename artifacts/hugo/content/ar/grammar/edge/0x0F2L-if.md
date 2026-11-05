---
title: "IF (0x0F2L)"
weight: 242
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "IF هو Codec لحزمة الجملة في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IF هو Codec لحزمة الجملة في Edge التنفيذ. المعنى: تفرّع شرطي.

| البند | القيمة |
|---|---|
| الاسم | `IF` (مستند المواصفة BIND `IF`) |
| TAG ID | `0x0F2L` |
| Codec ID | `0x00000F20` |
| مستند المواصفة | `0x00000000/codecs/0x00000F20/` (هدف DECLARE `0F20`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 18 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: الجملة |
| TAG WORD | `0000 1111 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تفرّع شرطي. الشرط، BLOCK عند التحقق، البديل (BLOCK أو IF، وإن لم يوجد فـ 0) |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

الشرط، BLOCK عند التحقق، البديل (BLOCK أو IF، وإن لم يوجد فـ 0).

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0F20`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [BLOCK](0x0F0L-block.md)، [ASSIGN](0x0F1L-assign.md)، [SWITCH](0x0F3L-switch.md)، [WHILE](0x0F4L-while.md)، [FOREACH](0x0F5L-foreach.md)، [JUMP](0x0F6L-jump.md)، [RETURN](0x0F7L-return.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000F20/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F2000000000
BODY
#1 DECLARE 0x0F20
#2 BIND #1 "IF"
```
