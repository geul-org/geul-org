---
title: "SCENE (0x0B2L)"
weight: 178
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SCENE هو Edge العبارة الذي يكتب بنية المشهد."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SCENE هو Edge العبارة الذي يكتب بنية المشهد. المعنى: بنية مشهد لوصف ذي طابع سيناريو.

| البند | القيمة |
|---|---|
| الاسم | `SCENE` (BIND مستند المواصفة `SCENE`) |
| TAG ID | `0x0B2L` |
| Codec ID | `0x00000B20` |
| مستند المواصفة | `0x00000000/codecs/0x00000B20/` (هدف DECLARE `0B20`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 18 |
| Kind | Edge · العائلة: العبارة، الحزمة: البنية |
| TAG WORD | `0000 1011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | بنية مشهد لوصف ذي طابع سيناريو |
| جانب Hugo | `edge/_index.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0000 1011 0010 LLLL      Codec 0x0B2L
[Length TAG ممتد]
TAG الـ Codec     1 WORD. صيغة فرعية
Edge Id           سجل LOCAL Reference
المكوّنات          تحددها الصيغة الفرعية
```

- هذا Codec ذو صيغ فرعية. يحدد TAG واحد من 1 WORD خاص بالـ Codec الصيغةَ الفرعية ([السجل وTAG WORD](../record.md#레코드-레이아웃)).
- لم تُحدَّد الصيغ الفرعية والمكوّنات بعد.

## مستند Codec {#코덱-문서}

لم يُحدَّد التخطيط بعد. لا يوضع في مستند Codec إلا DECLARE (الهدف `0B20`). يوضع FIELD عند تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [WORLD](0x0B0L-world.md)، [TIMELINE](0x0B1L-timeline.md)، [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (طريقة التصريح بـ Codec ذي صيغ فرعية)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000B20/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B2000000000
BODY
#1 DECLARE 0x0B20
#2 BIND #1 "SCENE"
```
