---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE هو Codec لحزمة التصريح في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE هو Codec لحزمة التصريح في Edge التنفيذ. المعنى: تصريح نوع.

| البند | القيمة |
|---|---|
| الاسم | `TYPE-DECLARE` (مستند المواصفة BIND `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| مستند المواصفة | `0x00000000/codecs/0x00000E20/` (هدف DECLARE `0E20`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 2 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: التصريح |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تصريح نوع. الرمز والتركيب (قائمة رموز الحقول، قيم التعداد، هدف الاسم المستعار) |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

الرمز والتركيب (قائمة رموز الحقول، قيم التعداد، هدف الاسم المستعار).

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0E20`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000E20/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
