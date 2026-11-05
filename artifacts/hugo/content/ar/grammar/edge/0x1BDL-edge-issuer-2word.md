---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD هو صيغة Edge يعرّفها Issuer."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD هو صيغة Edge يعرّفها Issuer. وهو إحدى الخانات الثلاث الأخيرة في نطاق Edge، وعرض Issuer فيه 2 WORD. تخطيط ISSUER في الـ Kind الثلاثة واحد ([السجل وTAG WORD](../record.md#issuer-형식-레코드)).

| البند | القيمة |
|---|---|
| الاسم | `EDGE-ISSUER-2WORD` (مستند المواصفة BIND `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| مستند المواصفة | `0x00000000/codecs/0x00001BD0/` (هدف DECLARE `1BD0`) |
| القسم | 13 `1101` (Edge (آخر 3 خانات ISSUER))، الإزاحة داخل القسم C = 29 |
| Kind | Edge · التصنيف: صيغة Issuer |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | Issuer 2 WORD ورقم Codec 2 WORD. الصيغة يحددها مستند Codec الخاص بـ Issuer |
| جانب Hugo | `edge/_index.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[Length TAG ممتد]
Issuer            2 WORD
رقم Codec         2 WORD. يعرّفه Issuer
Edge Id           سجل LOCAL Reference. أول عنصر بعد Issuer ورقم Codec
Payload المتبقي   يحدده مستند Codec الذي نشره Issuer
```

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD. ويأتي Edge Id الخاص بـ EDGE-ISSUER بعد رقم Codec وقبل الحقل `payload` ([التخطيط](#레이아웃)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام 2 WORD |  |  |
| 2 | `codec` | #3 | قيمة خام 2 WORD |  |  |
| 3 | `payload` | #4 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

تركيب `payload` يحدده مستند Codec الخاص بذلك Issuer.

## التفسير والصلاحية {#해석과-유효성}

- لا يعرف GEUL من Payload إلا حدودها بواسطة Length. والمفكك الذي لا يعرف الصيغة يعرف Kind وLength وIssuer ورقم Codec، ثم يتخطى بواسطة Length.
- تبدأ Payload بـ Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). والمكوّنات بعد Edge Id يحددها مستند Codec الخاص بـ Issuer.
- يُكتب Issuer بأقصر عرض تتسع له قيمته ([Issuer والنشر](../issuer.md#issuer-등급)). يستطيع Issuer 2 WORD كتابة أي قيمة.
- رقم Codec هو 2 WORD. يخصصه Issuer دون تكرار داخل `codecs/` الخاص به أياً كان Kind. وإذا لم تكفِ الأرقام يُصدَر Issuer آخر.
- يوضع مستند Codec تحت `<Issuer>/codecs/<رقم Codec>/` الخاص بذلك Issuer ([عنوان النشر وقائمة الإصدارات](../publishing.md#id-표기)).
- ترخيص صيغة Issuer يحدده ذلك Issuer ([Issuer والنشر](../issuer.md#라이선스)).

## صفحات ذات صلة {#관련-페이지}

- [Edge — Edge صيغة Issuer](_index.md#issuer-형식-edge)، [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md)، [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [السجل وTAG WORD](../record.md#issuer-형식-레코드)، [Issuer والنشر](../issuer.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00001BD0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
