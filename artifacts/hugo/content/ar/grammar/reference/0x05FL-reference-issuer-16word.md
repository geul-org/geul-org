---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD هو صيغة Reference يعرّفها Issuer."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD هو صيغة Reference يعرّفها Issuer. هو إحدى الخانات الثلاث الأخيرة في نطاق Reference، وعرض Issuer فيه 16 WORD. تخطيط ISSUER في الأنواع (Kind) الثلاثة واحد ([السجل وTAG WORD](../record.md#issuer-형식-레코드)).

| البند | القيمة |
|---|---|
| الاسم | `REFERENCE-ISSUER-16WORD` (BIND `REFERENCE-ISSUER-16WORD` في مستند المواصفة) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| مستند المواصفة | `0x00000000/codecs/0x000005F0/` (هدف DECLARE `05F0`) |
| القسم | 2 `0010` (Reference أخرى)، الإزاحة داخل القسم C = 31 |
| Kind | Reference · التصنيف: صيغة Issuer |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | Issuer بـ16 WORD ورقم Codec بـ2 WORD. تحدد صيغتَه مستندُ Codec الخاص بالـIssuer |
| جهة Hugo | `reference/reference-issuer.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[TAG الامتداد Length]
Issuer            16 WORD
رقم Codec         2 WORD. يعرّفه الـIssuer
Payload           يحدده مستند Codec الذي أصدره الـIssuer
```

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام 16 WORD |  |  |
| 2 | `codec` | #3 | قيمة خام 2 WORD |  |  |
| 3 | `payload` | #4 | قيمة خام متبقية (`0xFFFF`) |  |  |

يحدد مستند Codec الخاص بذلك الـIssuer تركيب `payload`.

## التفسير والصلاحية {#해석과-유효성}

- لا يعرف GEUL من Payload إلا حدوده بـLength. المفكّك الذي لا يعرف الصيغة يعرف Kind وLength وIssuer ورقم Codec ثم يتخطى بـLength.
- معنى رقم Codec والتكميم وما يُشار إليه يحدده مستند Codec الذي أصدره الـIssuer. لا تُطبَّق قواعد Reference المشتركة مثل أقصر عرض لمعرّف الهدف وقراءة التكميم ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- يُكتب Issuer بأقصر عرض تتسع له القيمة ([Issuer والنشر](../issuer.md#issuer-등급)). إذا كان أعلى 12 WORD من قيمة Issuer صفرًا فهو invalid. وتُكتب تلك القيمة بـCodec ذات عرض أضيق.
- رقم Codec بعرض 2 WORD. يخصصه الـIssuer دون تداخل داخل `codecs/` الخاص به بصرف النظر عن Kind. وإذا لم تكفِ الأرقام يُطلب Issuer آخر.
- يوضع مستند Codec تحت `<Issuer>/codecs/<رقم Codec>/` لذلك الـIssuer ([عنوان النشر وقائمة الإصدارات](../publishing.md#id-표기)).
- يحدد الـIssuer ترخيص صيغته ([Issuer والنشر](../issuer.md#라이선스)).

## صفحات ذات صلة {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer)، [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)، [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [السجل وTAG WORD](../record.md#issuer-형식-레코드)، [Issuer والنشر](../issuer.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000005F0/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
