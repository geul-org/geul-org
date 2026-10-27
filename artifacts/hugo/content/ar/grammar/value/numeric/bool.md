---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL قيمة Value ثابتة من 2 WORD تحمل القيمتين المنطقيتين false وtrue."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL قيمة Value تمثل القيمتين المنطقيتين false وtrue. الرمز المباشر في Value هو `0x00` والعائلة NUMERIC. وهو نوع مختلف عن SIGNED-INTEGER وUNSIGNED-INTEGER اللذين يحملان الرقمين 0 و1.

## التخطيط

```
TAG WORD          0x0880 (0000 1000 1000 0000)  المجموع 2 WORD
Payload           1 WORD  Boolean Code
```

## التفسير والصلاحية

- Payload `0000` هو false و`0001` هو true.
- لا يوجد padding ولا descriptor.
- Payload هو بالضبط `0000` أو `0001`. أي قيمة أخرى من 16 بت تُرفض لأنها invalid.
- أي تمثيل آخر لـ Length يُرفض لأنه invalid.

## الطول

- المجموع هو TAG (1 WORD) وPayload (1 WORD)، أي 2 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0001`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 1 WORD تماماً.

## أمثلة

| السجل الكامل (TAG + Payload) | Payload | الحكم |
|---|---|---|
| `0880 0000` | `0000` | false، قياسي |
| `0880 0001` | `0001` | true، قياسي |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG لا يكون Length فيه `0001` + `0000` أو `0001` | `0000` أو `0001` | invalid |

## وضع الصيغة

- هذا التمثيل الذي يجمع code word ذات 16 بت (`0000`/`0001`) مع TAG في GEUL هو scalar profile خاص بـ GEUL.
- القيمة المنطقية نفسها عامة، لكن لا يُدّعى وجود معيار صناعي واحد يقابل هذا التمثيل في WORD واحدة.
