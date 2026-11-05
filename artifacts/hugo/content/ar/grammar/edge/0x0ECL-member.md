---
title: "MEMBER (0x0ECL)"
weight: 236
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "MEMBER هو Codec لحزمة التعبير في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MEMBER هو Codec لحزمة التعبير في Edge التنفيذ. المعنى: الوصول إلى عضو.

| البند | القيمة |
|---|---|
| الاسم | `MEMBER` (مستند المواصفة BIND `MEMBER`) |
| TAG ID | `0x0ECL` |
| Codec ID | `0x00000EC0` |
| مستند المواصفة | `0x00000000/codecs/0x00000EC0/` (هدف DECLARE `0EC0`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 12 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: التعبير |
| TAG WORD | `0000 1110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | الوصول إلى عضو. الهدف، رمز الحقل |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

الهدف، رمز الحقل.

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0EC0`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [CONST](0x0E8L-const.md)، [UNARY](0x0E9L-unary.md)، [BINARY](0x0EAL-binary.md)، [CALL](0x0EBL-call.md)، [INDEX](0x0EDL-index.md)، [CONSTRUCT](0x0EEL-construct.md)، [CONDITIONAL](0x0EFL-conditional.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000EC0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EC000000000
BODY
#1 DECLARE 0x0EC0
#2 BIND #1 "MEMBER"
```
