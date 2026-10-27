---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH قيمة Value تحمل نقطة على الأرض (WGS 84) بخط العرض وخط الطول binary64 وعدم اليقين binary32 وReference لوحدة عدم اليقين."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH قيمة Value إحداثية تمثل نقطة على الأرض بخط العرض وخط الطول وعدم اليقين. الرمز المباشر في Value هو `0x04` والعائلة NUMERIC. معناها هو معنى `geo:خط العرض,خط الطول;u=عدم اليقين` (نظام الإحداثيات WGS 84) في [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI)، لكنها تُحمل كأعداد ثابتة العرض لا كسلسلة نصية. يُكتب عدم اليقين مع وحدته. إحداثيات الأجرام خارج الأرض تُكتب بـ [COORDINATE-GEO](/ar/grammar/value/numeric/coordinate-geo/) (`0x05`).

## التخطيط

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Longitude         4 WORD قيمة خام، IEEE 754 binary64 (بالدرجات)
Uncertainty       2 WORD قيمة خام، IEEE 754 binary32 (بوحدة Unit)
Unit              سجل Reference واحد، أو علامة الموضع 0x0000 ABSENT
```

## التفسير والصلاحية

- Payload هو Latitude (4 WORD) وLongitude (4 WORD) وUncertainty (2 WORD) ثم سجل Unit واحد بالضبط. يجب أن يتطابق المؤشر بعد قراءة Unit مع نهاية السجل.
- نظام الإحداثيات هو WGS 84 (القيمة الافتراضية `crs=wgs84` في RFC 5870).
- Latitude وLongitude هما IEEE 754 binary64 يتكوّن من وصل WORD الـ Payload بترتيب big-endian (التوزيع نفسه لبتات binary64 في [BINARY-FLOAT](/ar/grammar/value/numeric/binary-float/)). الوحدة هي الدرجة (°).
  - يجب أن تكون القيمة منتهية. NaN و±Infinity هما invalid.
  - Latitude هو `-90 ≤ φ ≤ 90` (الشمال موجب)، وLongitude هو `-180 ≤ λ ≤ 180` (الشرق موجب).
  - ترتيب المحاور هو خط العرض ثم خط الطول (كما في RFC 5870 وISO 6709). وليس ترتيب x (خط الطول) وy (خط العرض) في WKB وGeoJSON.
- Uncertainty هو IEEE 754 binary32 يتكوّن من وصل 2 WORD بترتيب big-endian (التوزيع نفسه لبتات binary32 في BINARY-FLOAT). يعني أن الموضع الفعلي داخل هذا نصف القطر، وتُقرأ القيمة بوحدة Unit.
  - يجب أن تكون منتهية وأكبر من أو تساوي `+0`. السالبة و`-0` (`8000 0000`) وNaN و±Infinity هي invalid.
  - `0` (عند وجود Unit): إحداثية دقيقة. ويستوي ذلك مهما كانت الوحدة.
- Unit هو Reference يشير إلى وحدة Uncertainty. لا يقبل Value. Quantifier هو Identified (`000`).
  - يُوصى باستخدام عناصر الوحدات في ويكي بيانات [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/): الدرجة Q28390، والدقيقة القوسية Q209426، والثانية القوسية Q829073، والمتر Q11573، والمليمتر Q174789، وغيرها. الوحدة التي لا QID لها يُشار إليها بـ Reference آخر (LOCAL أو GEUL وغيرهما). إذا وُجد أكثر من Reference يشير إلى الوحدة نفسها فـ QID هو الصورة القياسية.
  - إذا كانت Unit هي المتر (Q11573) فـ Uncertainty يساوي `u` في RFC 5870.
- **مجهول**: تُكتب [ABSENT](/ar/grammar/reference/slot-marker/) (`0x0000`) في موضع Unit، ويُترك Uncertainty عند `+0` (`0000 0000`). وهذا مثل حذف `u` في RFC 5870. إذا كانت Unit هي ABSENT وUncertainty ليس `+0` فهو invalid (لتثبيت تمثيل واحد).
- لا يُحمل الارتفاع. إن لزم يُحدد بصيغة مستقلة. لم يُستخدم altitude في ويكي بيانات في العينة (0/23,066)، وإن وُجدت قيمة فلا تُحوَّل بل يُحفظ نصها الأصلي كـ UTF8-TEXT.
- يُوصى باستخدام هذه الصيغة لإحداثيات الأرض. وإحداثية كُتبت في COORDINATE-GEO بالأرض (Q2) ليست invalid أيضاً، وتطابقها جهة المقارنة على أنها الإحداثية نفسها.
- تضع مواصفة geul.org `0x0000/0x0000000000000804` في حقول القيم الخام Latitude وLongitude وUncertainty [CODEC](/ar/grammar/edge/codec/) من BINARY-FLOAT (`0803`) (4 WORD = binary64، 2 WORD = binary32)، وفي حقل سجل Unit CODEC `0780` (أي Reference) و`0000` (ABSENT).

## الطول

- المجموع هو TAG (1 WORD) + 10 WORD + سجل Unit.

| Unit | المجموع | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| عندما يتسع QID في 1 WORD (2 WORD، مثل الدرجة Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| عندما يكون QID من 2 WORD (3 WORD، مثل الدقيقة القوسية Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| سجل Unit من 4 WORD فأكثر | 15 WORD فأكثر | طول ممتد ([السجل وTAG WORD](/ar/grammar/record/)) |

- لا يوجد زوج Codec زوجي/فردي.

## المقابل في ويكي بيانات

globecoordinate في ويكي بيانات: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| ويكي بيانات | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | هذه الصيغة (الأرض). الأجرام الأخرى بـ COORDINATE-GEO |
| latitude, longitude | binary64 كما هي (قيم ويكي بيانات أصلاً binary64 فلا فقد) |
| precision (بالدرجات) | Uncertainty وUnit. انظر "الدقة" أدناه |
| precision فارغة (null) أو غائبة | Unit = ABSENT، وUncertainty = `+0` (مجهول) |
| altitude | يُهمل (دائماً null) |

- precision في ويكي بيانات ليست خطأ قياس بل **دقة التسجيل** (بأي درجة/دقيقة/ثانية كُتبت الإحداثية). ينقل Uncertainty في GEUL تلك القيمة دون تغيير. وليس نصف قطر يضيف أخطاء القياس ونظام الإحداثيات.

### الدقة

تُنقل precision دون تحويل. تُختار أول وحدة من الدرجة والدقيقة القوسية والثانية القوسية تعيد الكتابة الأصلية.

| precision الأصلية (مثال) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k درجة) | الدرجة Q28390 | binary32 لتلك القيمة |
| كتابة عشرية قصيرة مثل `0.0166667` | الدرجة Q28390 | binary32 لتلك القيمة |
| `0.016666666666667` (1/60°) | الدقيقة القوسية Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | الثانية القوسية Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | الثانية القوسية Q829073 | `0.1` |

- التحويل الأمامي: بترتيب الدرجة ثم الدقيقة القوسية (×60) ثم الثانية القوسية (×3600)، يُجعل Uncertainty هو أقرب binary32 إلى حاصل ضرب precision في عدد الوحدات، وتُستخدم أول وحدة يعيد التحويل العكسي أدناه precision الأصلية بها كما هي.
- التحويل العكسي: تُقسم أقصر كتابة عشرية لـ Uncertainty (أقصر عدد يُقرأ من جديد على أنه ذلك binary32) على عدد الوحدات لتصير درجات، وتُكتب بالطريقة التي يكتب بها Wikibase في الـ dump (14 رقماً معنوياً، وما دون `1e-4` بصيغة الأس `1.0e-6` و`2.7777777777778e-5`). وتحفظ قاعدة البيانات المحمَّلة (jsonb) هذا بالكتابة العشرية `0.0000010` و`0.000027777777777778`.
- إذا لم تعد أي وحدة الكتابة الأصلية (كتابة بـ 17 رقماً معنوياً `0.0002777777777777778`، أو قيمة شاذة تبدو محسوبة وما شابه) فلا تُحوَّل الإحداثية كلها بل يُحفظ نصها الأصلي كـ UTF8-TEXT. وكذلك precision السالبة والقيم التي جرمها فارغ.
- عينة ويكي بيانات Q1–Q10000 (7,026 claim إحداثي، منها 6,824 بها precision): أُعيدت الكتابة الأصلية في 5,933 (86.9%؛ الدرجة 4,104 والثانية القوسية 1,370 والدقيقة القوسية 459). ومن 891 لم تُعَد، 753 من سلسلة 1/3600 و1/60 بكتابة 17 رقماً معنوياً.

## أمثلة

برلين 52.516666666667، 13.383333333333، وprecision 1/60° (دقيقة قوسية 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD)، وLatitude `404A 4222 2222 2251`، وLongitude `402A C444 4444 4389`، وUncertainty `3F80 0000` (binary32 1.0)، وUnit `0120 0003 3212` (WIKIDATA-QID Q209426، الدقيقة القوسية).
- الكتابة النصية: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

النقطة نفسها مع عدم يقين مجهول: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD، Unit بـ ABSENT).

## السند المعياري

- المعنى: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — ترتيب خط العرض وخط الطول، وعدم اليقين `u` (بالمتر)، ونظام الإحداثيات الافتراضي WGS 84. إذا كانت Unit هي المتر فـ Uncertainty = `u`.
- الأعداد: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (خط العرض والطول) وbinary32 (عدم اليقين).
- ترتيب المحاور والنطاق: ISO 6709 (Standard representation of geographic point location by coordinates).
- الوحدة: عناصر الوحدات في ويكي بيانات (QID). أما التخطيط ثابت العرض وحقل Unit وتمثيل المجهول فهي قواعد GEUL.

## مسائل مفتوحة

1. الارتفاع.
2. الصيغة التي تحفظ سلسلة ISO 6709 الأصلية (COORDINATE-ISO6709) تُحدد عند ظهور حاجة إليها.
3. طريقة نقل كتابة precision في ويكي بيانات بـ 17 رقماً معنوياً (نحو 11% من العينة) دون فقد.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [COORDINATE-GEO](/ar/grammar/value/numeric/coordinate-geo/)، [BINARY-FLOAT](/ar/grammar/value/numeric/binary-float/)، [علامة موضع](/ar/grammar/reference/slot-marker/)
- صيغة Issuer [POINT2-BINARY64](/ar/grammar/value/vector/point2-binary64/) نقطة ثنائية الأبعاد عامة تترك نظام الإحداثيات والوحدة ومعنى المحاور للسياق الخارجي، أما هذه الصيغة فإحداثية جغرافية على الأرض.
