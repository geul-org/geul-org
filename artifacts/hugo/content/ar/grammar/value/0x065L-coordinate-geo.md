---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO قيمة Value إحداثية تمثل نقطة على جرم سماوي محدد (كوكب أو قمر أو كويكب وغيرها) بخط العرض وخط الطول وعدم اليقين."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `COORDINATE-GEO` (مستند المواصفة BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| مستند المواصفة | `0x00000000/codecs/0x00000650/` (هدف DECLARE هو `0650`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 5 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | Reference للجرم السماوي، وخط العرض وخط الطول بصيغة binary64، وعدم اليقين بصيغة binary32 مع Reference لوحدته |
| جهة Hugo | `value/numeric/coordinate-geo.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | سجل | `0050` LOCAL، `00A0` GEUL، `00F0` GEUL-SIDX، `0140` WIKIDATA-QID، `0200` EXTERNAL-POINTER-1WORD، `0250` EXTERNAL-POINTER-2WORD، `02A0` EXTERNAL-POINTER-4WORD، `02F0` EXTERNAL-ISSUER-2WORD، `0340` EXTERNAL-ISSUER-4WORD، `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | قيمة خام 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | قيمة خام 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | قيمة خام 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `0000` ABSENT (حقل اختياري) |  |

COORDINATE-GEO قيمة Value إحداثية تمثل نقطة على جرم سماوي محدد (كوكب أو قمر أو كويكب وغيرها) بخط العرض وخط الطول وعدم اليقين. الرمز المباشر في Value هو `0x065L` والعائلة NUMERIC. هي صيغة [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) مضافاً إليها Reference للجرم السماوي (Globe) في المقدمة، وقواعد خط العرض وخط الطول وعدم اليقين والوحدة هي نفسها في COORDINATE-EARTH.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
Globe             سجل Reference واحد (Reference يشير إلى الجرم السماوي، Quantifier هو Identified)
Latitude          4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Longitude         4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Uncertainty       2 WORD قيمة خام، IEEE 754 binary32 (بوحدة Unit)
Unit              سجل Reference واحد، أو علامة الموضع 0x0000 ABSENT
```

## التفسير والصلاحية {#해석과-유효성}

- يبدأ Payload بسجل Globe. Globe هو سجل Reference كامل واحد بالضبط وQuantifier فيه هو Identified. يمكن استخدام أي Reference يشير إلى جرم سماوي: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (جرم له اسم)، [GEUL](../reference/0x00AL-geul.md)، [LOCAL](../reference/0x005L-local.md) في المستند نفسه (جرم عُرّف داخل المستند)، أو جرم في مستند آخر ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) وغيرها. الأجرام السماوية لا تُحصى، والتي لها QID جزء منها.
- بعد Globe تأتي 10 WORD (Latitude 4 وLongitude 4 وUncertainty 2) ثم سجل Unit واحد. يجب أن يطابق المؤشر بعد قراءة Unit نهاية السجل.
- Latitude في المدى `-90 ≤ φ ≤ 90`، وLongitude في المدى `-360 ≤ λ ≤ 360`. يُسمح بمدى أوسع من الأرض لتُحفظ دون تغيير قيم أنظمة إحداثيات الأجرام التي تعد خط الطول من 0 إلى 360° (شرقاً أو غرباً) وقيم السالب المكتوبة في الاتجاه المعاكس. والمدى هو نفسه في نموذج بيانات globecoordinate في ويكي بيانات (Wikibase `LatLongValue`). `λ` و`λ ± 360` هما خط الزوال نفسه ولا تطبّعهما GEUL. أما سائر القواعد (binary64، والقيمة المنتهية، وترتيب المحاور، ومعنى Uncertainty وUnit، وتمثيل المجهول) فهي نفسها في COORDINATE-EARTH.
- يتبع نظام الإحداثيات لكل جرم عُرف ذلك الجرم (خط عرض مركزي الكوكب، وخط طول شرقي أو غربي من 0 إلى 360° وغيرها). ويُحدَّد نظام إحداثيات كل جرم في مستند GEUL منفصل.
- عدم اليقين بوحدة المسافة (المتر وغيره) هو مسافة على سطح الجرم. أما وحدات الزاوية (الدرجة والدقيقة القوسية والثانية القوسية) فهي نصف قطر زاوي في خط العرض وخط الطول بصرف النظر عن حجم الجرم.
- يُوصى باستخدام COORDINATE-EARTH لإحداثيات الأرض (Q2). وكتابة الأرض في هذه الصيغة ليست invalid أيضاً، وعلى الجهة المقارِنة أن تطابقها مع الإحداثية نفسها.
- يضع مستند المواصفة `0x00000000/codecs/0x00000650` في geul.org على حقول القيم الخام Latitude وLongitude وUncertainty [CODEC](../edge/0x0BEL-codec.md) من النوع BINARY-FLOAT (`0630`)، وعلى حقل سجل Unit قيم CODEC هي `000F` و`020F` و`040F` (أي Reference) و`0000` (ABSENT).

## الطول {#길이}

- المجموع هو TAG (1 WORD) + (TAG ممتد لـ Length) + سجل Globe + 10 WORD + سجل Unit.
- إذا كان Globe من 2 WORD (عندما تتسع QID في 1 WORD) وكانت Unit هي ABSENT فالمجموع 14 WORD و`LLLL=1101` وTAG هي `065D`. وإذا كانت Unit هي Reference (2 WORD فأكثر) يتجاوز المجموع 15 WORD ويُستخدم الطول الممتد: TAG `065E`، وفي WORD التالية عدد WORD الكلي ([السجل وTAG WORD](../record.md)).

## المقابل في ويكي بيانات {#위키데이터-대응}

- تُكتب globecoordinate التي لا يكون globe فيها هو الأرض (Q2) بهذه الصيغة. Globe = WIKIDATA-QID (عنصر globe). أما مقابلة خط العرض وخط الطول وprecision → Uncertainty وUnit فهي نفسها في COORDINATE-EARTH (precision دقة تسجيل بالدرجات، فتُنقل كما هي بصرف النظر عن حجم الجرم).
- الأجرام خارج الأرض في عينة ويكي بيانات (نحو 24 ألف ادعاء إحداثي): 23 حالة منها المريخ (Q111) وسيريس (Q596) والقمر (Q405) وعطارد (Q308) والزهرة (Q313). أما الحالات الـ 41 التي يكون فيها globe فارغاً فلا تُحوَّل بل يُحفظ النص الأصلي بصيغة UTF8-TEXT.

## مثال {#예시}

المريخ (Q111) 4.5، 137.4، عدم اليقين مجهول:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`، `LLLL=1101`، 14 WORD)، Globe `0141 006F` (WIKIDATA-QID Q111)، Latitude `4012 0000 0000 0000`، Longitude `4061 2CCC CCCC CCCD`، Uncertainty `0000 0000` (+0)، Unit `0000` (ABSENT، مجهول).
- الكتابة النصية: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

النقطة نفسها مع precision تساوي 0.1° (Unit هي الدرجة Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`، طول ممتد)، المجموع `0010` (16 WORD)، Uncertainty `3DCC CCCD` (binary32 يساوي 0.1)، Unit `0141 6EE6` (Q28390).

## الأساس المعياري {#표준-근거}

- المعنى: خط العرض وخط الطول و`u` (عندما تكون Unit هي المتر) في [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). نظام الإحداثيات المسجَّل في `crs` في RFC 5870 هو `wgs84` فقط، لذا تُحدَّد الأجرام خارج الأرض بـ Reference الجرم Globe في GEUL.
- القيم العددية: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) صيغة binary64 (خط العرض والطول) وbinary32 (عدم اليقين).
- مدى خط الطول: `-360 ≤ λ ≤ 360` في نموذج بيانات globecoordinate في ويكي بيانات [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## مسائل مفتوحة {#열린-문제}

1. مستند نظام الإحداثيات لكل جرم: تعريف خط العرض (مركزي الكوكب أو على سطح الكوكب) واتجاه خط الطول ومداه لكل جرم.

## صفحات ذات صلة {#관련-페이지}

- [Value](_index.md)، [COORDINATE-EARTH](0x064L-coordinate-earth.md)، [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)، [GEUL](../reference/0x00AL-geul.md)، [LOCAL](../reference/0x005L-local.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000650/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
