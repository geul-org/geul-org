---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE هو Codec لحزمة الخطأ في Edge التنفيذ."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE هو Codec لحزمة الخطأ في Edge التنفيذ. المعنى: إطلاق خطأ.

| البند | القيمة |
|---|---|
| الاسم | `RAISE` (مستند المواصفة BIND `RAISE`) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| مستند المواصفة | `0x00000000/codecs/0x00000F80/` (هدف DECLARE `0F80`) |
| القسم | 7 `0111` (Edge التنفيذ)، الإزاحة داخل القسم C = 24 |
| Kind | Edge · العائلة: التنفيذ، الحزمة: الخطأ |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إطلاق خطأ. قيمة الخطأ |
| جانب Hugo | `edge/_index.md` |

## المكوّنات {#구성요소}

قيمة الخطأ.

- تُشار إلى المكوّنات بمعرّف LOCAL في هذا المستند (REF). REF `0` تعني لا شيء. وفي موضع التعبير يوضع Edge تعبير أو رمز ([Edge](_index.md#실행-edge)).
- لم تُحدَّد بعد رموز العوامل وتمثيل الأنواع وتخطيط Payload ([Edge](_index.md#실행-edge)، المسائل المفتوحة).

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0F80`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge التنفيذ](_index.md#실행-edge)، [TRY](0x0F9L-try.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000F80/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
