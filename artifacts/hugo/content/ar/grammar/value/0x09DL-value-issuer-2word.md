---
title: "VALUE-ISSUER-2WORD (0x09DL)"
weight: 157
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-2WORD هو صيغة Value يعرّفها Issuer."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-2WORD هو صيغة Value يعرّفها Issuer. وهو إحدى الخانات الثلاث الأخيرة في منطقة Value، وعرض Issuer فيه 2 WORD. تخطيط ISSUER في الـ Kind الثلاثة واحد ([السجل وTAG WORD](../record.md#issuer-형식-레코드)).

| البند | القيمة |
|---|---|
| الاسم | `VALUE-ISSUER-2WORD` (BIND في مستند المواصفة `VALUE-ISSUER-2WORD`) |
| TAG ID | `0x09DL` |
| Codec ID | `0x000009D0` |
| مستند المواصفة | `0x00000000/codecs/0x000009D0/` (هدف DECLARE `09D0`) |
| القسم | 4 `0100` (Value)، الإزاحة C داخل القسم = 29 |
| Kind | Value · التصنيف: صيغة Issuer |
| TAG WORD | `0000 1001 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | Issuer بـ 2 WORD ورقم Codec بـ 2 WORD. تحدد صيغتَه مستندات Codec عند Issuer |
| جهة Hugo | `value/_index.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length ممتد TAG]
Issuer            2 WORD
رقم Codec         2 WORD. يعرّفه Issuer
Payload           يحدده مستند Codec الذي أصدره Issuer
```

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام بـ 2 WORD |  |  |
| 2 | `codec` | #3 | قيمة خام بـ 2 WORD |  |  |
| 3 | `payload` | #4 | قيمة خام للباقي (`0xFFFF`) |  |  |

يحدد مستند Codec عند ذلك Issuer تكوين `payload`.

## التفسير والصلاحية {#해석과-유효성}

- لا تعرف GEUL إلا حدود Payload من Length. أما المفكّك الذي لا يعرف الصيغة فيعرف Kind وLength وIssuer ورقم Codec ويتخطى الباقي بـ Length.
- يحدد مستند Codec عند Issuer تفسير Payload. وصيغ Value من Issuer المسجَّلة حالياً في [فهرس Codec](../codec-index.md#value-issuer-형식).
- يُكتب Issuer بأقصر عرض تتسع له القيمة ([Issuer والنشر](../issuer.md#issuer-등급)). وIssuer بـ 2 WORD يتسع لكل القيم.
- رقم Codec هو 2 WORD. يخصصه Issuer داخل `codecs/` الخاص به دون تكرار وبغض النظر عن Kind. وإن نفدت الأرقام يُطلب Issuer آخر.
- يوضع مستند Codec تحت `<Issuer>/codecs/<رقم Codec>/` عند ذلك Issuer ([عناوين النشر وقائمة الإصدارات](../publishing.md#id-표기)).
- يحدد ذلك Issuer ترخيص صيغة Issuer ([Issuer والنشر](../issuer.md#라이선스)).

## صفحات ذات صلة {#관련-페이지}

- [Value — صيغ Issuer](_index.md#issuer-형식)، [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md)، [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [السجل وTAG WORD](../record.md#issuer-형식-레코드)، [Issuer والنشر](../issuer.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000009D0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009D000000000
BODY
#1 DECLARE 0x09D0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
