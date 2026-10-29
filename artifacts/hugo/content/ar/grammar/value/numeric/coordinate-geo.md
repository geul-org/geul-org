---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO قيمة Value تحمل نقطة على جرم سماوي كالكوكب أو القمر بـ Reference للجرم وخط العرض وخط الطول binary64 وعدم اليقين binary32 وReference لوحدته."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO قيمة Value إحداثية تمثل نقطة على جرم سماوي محدد (كوكب أو قمر أو كويكب وغيرها) بخط العرض وخط الطول وعدم اليقين. الرمز المباشر في Value هو `0x05` والعائلة NUMERIC. هي صيغة [COORDINATE-EARTH](/ar/grammar/value/numeric/coordinate-earth/) (`0x04`) مع إضافة Reference الجرم السماوي (Globe) في المقدمة، وقواعد خط العرض وخط الطول وعدم اليقين والوحدة هي نفسها في COORDINATE-EARTH.

## التخطيط

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Globe             سجل Reference واحد (Reference يشير إلى الجرم السماوي، Quantifier من نوع Identified)
Latitude          4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Longitude         4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Uncertainty       2 WORD قيمة خام، IEEE 754 binary32 (بوحدة Unit)
Unit              سجل Reference واحد، أو علامة الموضع 0x0000 ABSENT
```

## التفسير والصلاحية

- يبدأ Payload بسجل Globe. Globe هو سجل Reference كامل واحد بالضبط وQuantifier فيه هو Identified (`000`). يمكن استخدام أي Reference يشير إلى جرم سماوي: [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) (للأجرام المسماة)، و[GEUL](/ar/grammar/reference/geul/)، و[LOCAL](/ar/grammar/reference/local/) في المستند نفسه (جرم عُرّف داخل المستند)، وجرم في مستند آخر ([EXTERNAL-POINTER](/ar/grammar/reference/external-pointer/) و[EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/)) وغيرها. الأجرام لا تُحصى والأجرام التي لها QID جزء منها.
- بعد Globe يأتي 10 WORD (Latitude 4 وLongitude 4 وUncertainty 2) وسجل Unit واحد. يجب أن يتطابق المؤشر بعد قراءة Unit مع نهاية السجل.
- Latitude هو `-90 ≤ φ ≤ 90`، وLongitude هو `-360 ≤ λ ≤ 360`. النطاق أوسع منه على الأرض لحمل قيم أنظمة إحداثيات الأجرام التي تعدّ خط الطول من 0 إلى 360° (شرقًا أو غربًا)، والقيم السالبة المكتوبة في الاتجاه المعاكس، دون تغيير. وهو النطاق نفسه في نموذج بيانات globecoordinate في ويكي بيانات (Wikibase `LatLongValue`). `λ` و`λ ± 360` خط زوال واحد، ولا يطبّعهما GEUL. أما بقية القواعد (binary64 والقيمة المنتهية وترتيب المحاور ومعنى Uncertainty وUnit وتمثيل المجهول) فهي نفسها في COORDINATE-EARTH.
- يتبع نظام الإحداثيات عُرف كل جرم (خط العرض المركزي للكوكب، وخط الطول الشرقي أو الغربي 0~360° وغيرها). نظام الإحداثيات لكل جرم يُحدد في مستند GEUL مستقل.
- Uncertainty بوحدة مسافة (المتر وغيره) هو مسافة على سطح الجرم. أما وحدة الزاوية (الدرجة والدقيقة القوسية والثانية القوسية) فهي نصف قطر زاوي لخط العرض وخط الطول مهما كان حجم الجرم.
- يُوصى باستخدام COORDINATE-EARTH لإحداثيات الأرض (Q2). وكتابة الأرض في هذه الصيغة ليست invalid أيضاً، وتطابقها جهة المقارنة على أنها الإحداثية نفسها.
- تضع مواصفة geul.org `0x0000/0x0000000000000805` في حقول القيم الخام Latitude وLongitude وUncertainty [CODEC](/ar/grammar/edge/codec/) من BINARY-FLOAT (`0803`)، وفي حقل سجل Unit CODEC `0780` (أي Reference) و`0000` (ABSENT).

## الطول

- المجموع هو TAG (1 WORD) + (Length ممتد TAG) + سجل Globe + 10 WORD + سجل Unit.
- إذا كان Globe من 2 WORD (عندما يتسع QID في 1 WORD) وUnit هي ABSENT فالمجموع 14 WORD و`LLLL=1101` وTAG `0E85`. وإذا كانت Unit هي Reference (2 WORD فأكثر) فالمجموع يتجاوز 15 WORD ويُستخدم الطول الممتد: TAG `0F05` وتحمل WORD التالية العدد الكلي لـ WORD ([السجل وTAG WORD](/ar/grammar/record/)).

## المقابل في ويكي بيانات

- يُكتب globecoordinate الذي ليس جرمه الأرض (Q2) بهذه الصيغة. Globe = WIKIDATA-QID (عنصر globe). تطابق خط العرض والطول وprecision ← Uncertainty وUnit هو نفسه في COORDINATE-EARTH (precision هي دقة تسجيل بالدرجات فتُنقل كما هي مهما كان حجم الجرم).
- الأجرام خارج الأرض في عينة ويكي بيانات (نحو 24 ألف claim إحداثي): المريخ (Q111) وسيريس (Q596) والقمر (Q405) وعطارد (Q308) والزهرة (Q313) وغيرها، 23 حالة. أما الحالات الـ 41 التي جرمها فارغ فلا تُحوَّل بل يُحفظ نصها الأصلي كـ UTF8-TEXT.

## أمثلة

المريخ (Q111) 4.5 و137.4، وعدم اليقين مجهول:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05` و`LLLL=1101` و14 WORD)، وGlobe `00A0 006F` (WIKIDATA-QID Q111)، وLatitude `4012 0000 0000 0000`، وLongitude `4061 2CCC CCCC CCCD`، وUncertainty `0000 0000` (+0)، وUnit `0000` (ABSENT، مجهول).
- الكتابة النصية: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

النقطة نفسها مع precision 0.1° (Unit هي الدرجة Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110` وطول ممتد)، والمجموع `0010` (16 WORD)، وUncertainty `3DCC CCCD` (binary32 0.1)، وUnit `00A0 6EE6` (Q28390).

## السند المعياري

- المعنى: خط العرض وخط الطول و`u` (عندما تكون Unit هي المتر) في [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). نظام الإحداثيات الوحيد المسجل في `crs` في RFC 5870 هو `wgs84`، لذلك تُحدَّد الأجرام خارج الأرض بـ Reference الجرم Globe في GEUL.
- الأعداد: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (خط العرض والطول) وbinary32 (عدم اليقين).
- نطاق خط الطول: `-360 ≤ λ ≤ 360` في نموذج بيانات globecoordinate في ويكي بيانات، [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## مسائل مفتوحة

1. مستندات نظام الإحداثيات لكل جرم: تعريف خط العرض (المركزي أو على سطح الكوكب) واتجاه خط الطول ونطاقه لكل جرم.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [COORDINATE-EARTH](/ar/grammar/value/numeric/coordinate-earth/)، [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/)، [GEUL](/ar/grammar/reference/geul/)، [LOCAL](/ar/grammar/reference/local/)
