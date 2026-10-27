---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE قيمة Value لرمز لغة في GEUL تضغط primary language subtag فقط في 1 WORD (Codec 0x48)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE رمز لغة مضغوط في GEUL يحمل primary language subtag فقط لا وسم BCP 47 كاملاً. Payload هو 1 WORD تماماً.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x48`. العائلة TEXT.
- Payload هو رمز unsigned من 16 بت في 1 WORD بالضبط.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  المجموع 2 WORD
Payload WORD 1st (16 بت)            GEUL language code (uint16)
```

## التفسير والصلاحية

- تُقرأ WORD الـ Payload الواحدة كعدد صحيح unsigned من 16 بت.
- هذه القيمة رمز مضغوط لـ primary language subtag. لا تحمل script ولا region ولا variant ولا extension ولا private-use. وإذا لزمت هذه المعلومات يُستخدم [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`).
- `0x0000..0xfffe` هو نطاق التخصيص في GEUL Language Registry. وفي هذا النطاق تكون القيمة التي لم تُخصَّص فعلاً في إصدار ذلك السجل invalid.
- هدف التخصيص الأولي هو السجلات العامة من `Type: language` في snapshot معين من IANA Language Subtag Registry بعد استبعاد `Scope: private-use`. ولا تُستبعد collections وmacrolanguage وspecial.
- في التخصيص الأولي تُرتب تلك السجلات العامة بترتيب ASCII لـ subtag ثم تُعطى معرّفاتها. والترتيب الفيزيائي لملف IANA ليس قاعدة للمعرّفات.
- لاحقاً تُلحق subtag جديدة من `Type: language` في النهاية دون تغيير الأرقام الحالية (append-only).
- معرّف deprecated language subtag لا يُمحى ولا يُعاد استخدامه. وتُحفظ علاقة Preferred-Value وحالة deprecated في بيانات السجل الوصفية.
- `0xffff` محجوز كـ escape للتوسعة. وإلى أن تُعرَّف صيغة التوسعة بصورة مستقلة يكون invalid في قيمة LANGUAGE-SHORT-CODE المستقلة. ولا يُستخدم بمعنى `null` أو `unknown` أو `und` وما شابه.
- يمكن مستقبلاً لـ schema مستقل مثل Lemma Edge أن يعرّف قواعد تفسير ما بعد `0xffff`. لكن ذلك لا يعني أن تلك القواعد تزيد طول Payload في هذه الصيغة أو تسمح بـ Payload لاحق.
- بعض schemas في Lemma Edge يمكنها تضمين رمز الـ WORD الواحدة نفسه بلا TAG كحقل compact. وهذه قاعدة في Edge schema، أما الصيغة السلكية لقيمة Value المستقلة فهي دائماً TAG (1 WORD) + Payload (1 WORD).
- لتحديد معنى القيمة يجب حفظ إصدار GEUL Language Registry المستخدم مع تاريخ snapshot الخاص بـ IANA registry الذي ثبّته ذلك الإصدار.

## السند المعياري

- السجل الأصلي لـ primary language subtag وبيانات deprecated/Preferred-Value الوصفية تتبع [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- المعنى الأساسي لنظام language subtag في BCP 47 يتبع [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- تخصيص المعرّفات بترتيب ASCII وبصيغة append-only وحجز `0xffff` والتمييز عن التضمين المضغوط لـ Lemma بلا TAG هي قواعد GEUL.

## الطول

- المجموع هو TAG (1 WORD) وPayload (1 WORD)، أي 2 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0001`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 1 WORD تماماً.

## أمثلة

- لم يتقرر بعد registry snapshot ولا جدول الرموز الفعلي، فلا يُذكر مثال لمعرّف رقمي للغة بعينها.

## مسائل مفتوحة

- تاريخ snapshot الأولي لـ IANA، واسم إصدار GEUL Language Registry، وجدول المقابلة الكامل. وإلى أن تتحدد لا تُثبَّت أمثلة رقمية محددة ولا جدول رموز.
