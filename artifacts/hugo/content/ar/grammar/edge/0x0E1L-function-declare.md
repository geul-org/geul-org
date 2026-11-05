---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE هو Codec لحزمة التصريح في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE هو Codec لحزمة التصريح في Edge التنفيذ. المعنى: تصريح دالة.

| البند | القيمة |
|---|---|
| الاسم | `FUNCTION-DECLARE` (مستند المواصفة BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| مستند المواصفة | `0x00000000/codecs/0x00000E10/` (هدف DECLARE `0E10`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 1 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: التصريح |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تصريح دالة. الرمز، قائمة رموز المعاملات، نوع الإرجاع، الجسم (BLOCK) |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

الرمز، قائمة رموز المعاملات، نوع الإرجاع، الجسم (BLOCK).

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0E10`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [TYPE-DECLARE](0x0E2L-type-declare.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000E10/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
