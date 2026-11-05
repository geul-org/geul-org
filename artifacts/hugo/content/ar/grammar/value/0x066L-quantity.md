---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY قيمة Value تمثل كمية واحدة بالعدد والوحدة والحد الأدنى والحد الأعلى."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `QUANTITY` (مستند المواصفة BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| مستند المواصفة | `0x00000000/codecs/0x00000660/` (هدف DECLARE هو `0660`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 6 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | amount عددية من نوع Value (عدد صحيح أو BINARY-FLOAT أو عدد عشري أو كسر)، وReference للوحدة، وحد أدنى وحد أعلى. يجوز حذف الوحدة والحدين (ABSENT `0x0000`) |
| جهة Hugo | `value/numeric/quantity.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | سجل | `0680` SIGNED-DECIMAL، `0610` SIGNED-INTEGER، `0620` UNSIGNED-INTEGER، `0630` BINARY-FLOAT، `0670` FRACTION، `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `0000` ABSENT (حقل اختياري) |  |
| 3 | `lower` | #4 | سجل | `0680` SIGNED-DECIMAL، `0000` ABSENT (حقل اختياري)، `0610` SIGNED-INTEGER، `0620` UNSIGNED-INTEGER، `0630` BINARY-FLOAT، `0670` FRACTION، `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | سجل | `0680` SIGNED-DECIMAL، `0000` ABSENT (حقل اختياري)، `0610` SIGNED-INTEGER، `0620` UNSIGNED-INTEGER، `0630` BINARY-FLOAT، `0670` FRACTION، `0690` UNSIGNED-DECIMAL |  |

QUANTITY قيمة Value تمثل كمية واحدة بالعدد والوحدة والحد الأدنى والحد الأعلى. الرمز المباشر في Value هو `0x066L` والعائلة NUMERIC. كل جزء من الأجزاء الأربعة سجل كامل. الوحدة والحدان [حقول اختيارية](../codec-spec.md)، فإذا حُذفت استُخدمت ABSENT (`0x0000`).

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
amount            سجل Value عددي (عدد صحيح أو BINARY-FLOAT أو عدد عشري أو كسر)
unit              سجل Reference (عنصر الوحدة)، و0x0000 إذا لم تكن هناك وحدة
lower             سجل Value عددي، وإذا حُذف فـ 0x0000 ABSENT
upper             سجل Value عددي، وإذا حُذف فـ 0x0000 ABSENT
```

## التفسير والصلاحية {#해석과-유효성}

- amount هو سجل Value عددي كامل واحد. الصيغ المقبولة ست: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`)، [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`)، [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`)، [FRACTION](0x067L-fraction.md) (`0x067L`)، [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`)، [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). القائمة مغلقة وليست حرف بدل. لا تُقبل BOOL ولا COORDINATE-EARTH·COORDINATE-GEO ولا QUANTITY نفسها (التداخل ممنوع، والعمق ثابت) ولا أي Value آخر. لا يجوز استخدام علامة الموضع (`0x0000` وغيرها) في amount.
- تتبع السجلات الداخلية الصيغة القياسية لكل Codec (العدد الصحيح وcoefficient بأقل عدد من WORD، وBINARY-FLOAT بـ 1/2/4/8 WORD، وFRACTION بقواعدها). إذا وُجد سجل داخلي غير قياسي فـ QUANTITY كلها invalid.
- إذا كانت amount أو lower أو upper من نوع BINARY-FLOAT فيجب أن تكون القيمة منتهية. NaN وقيمة ±Infinity غير صالحتين (invalid) (القاعدة نفسها لخط العرض وخط الطول في [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- تتبع صيغة العدد التدوين الأصلي كما هو. فالنص الأصلي للعدد الصحيح يُحفظ بـ INTEGER، والعشري بـ DECIMAL، والكسر بـ FRACTION، وقيمة IEEE 754 binary بـ BINARY-FLOAT، ولا يغيّر المرمِّز الصيغة بالتطبيع. يحفظ C وE في DECIMAL عدد خانات التدوين الأصلي كما هو: `1.20` = `120×10^-2`، `1.2` = `12×10^-1`. القيمتان العدد نفسه لكن أرقامهما المعنوية مختلفة، فهما Value مختلفتان. لا حد أعلى لعدد خانات العدد الصحيح وcoefficient (أقل عدد من WORD، طول متغير).
- unit هو سجل Reference كامل واحد بالضبط أو `0x0000`. يمكن استخدام أي Reference يشير إلى عنصر وحدة (وحدة ويكي بيانات تكون WIKIDATA-QID). `0x0000` تعني بلا وحدة (العدد والنسبة والسكان وغيرها).
- كل من lower وupper إما سجل من إحدى الصيغ الست نفسها التي تقبلها amount، أو `0x0000` ABSENT. لا تقبل علامة الموضع إلا حذف ABSENT. يجوز وجود أحدهما فقط. ولا يلزم أن تتطابق Codec الأعداد الثلاثة.
- تُقارَن lower ≤ amount ≤ upper بالقيمة العددية لا بالبايتات ولا بـ Codec. وتُقارَن كأعداد حتى مع اختلاف النوع (مثل SIGNED-INTEGER `652` وSIGNED-DECIMAL `651.5`). وتُقارَن FRACTION كعدد نسبي دقيق. ويُكتب المدى المتماثل (`652 ± 1`) أيضاً بحد أدنى وحد أعلى (`651` و`653`). ولأن هناك مدى غير متماثل يلزم فيه قيمتان على أي حال، فلا توجد صيغة تختزلهما في ± واحدة.
- الوحدة جزء من القيمة. لا تُفصل الوحدة بـ QUALIFIER وغيره (إذا فُصلت لم يُعرف أن `652` بالكيلومتر أم بالمتر).
- إذا استُخرج سجل amount فهو سجل Value مستقل كما هو. وإذا لزم العدد دون وحدته فيُستخدم ذلك السجل دون إعادة ترميز.
- لا تُحفظ القيمة المحوَّلة إلى وحدة SI. فهي قيمة مشتقة يمكن حسابها من الوحدة وجدول التحويل.
- يجب أن يطابق المؤشر بعد قراءة السجلات الأربعة نهاية Payload تماماً. وأي شكل آخر invalid.
- يكتب مستند المواصفة في geul.org أربعة حقول سجلات: amount (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`)، وunit (`000F`·`020F`·`040F`·`0000`)، وlower وupper (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`) ([مستند مواصفة Codec](../codec-spec.md)).

## الطول {#길이}

- المجموع هو TAG (1 WORD) + (TAG ممتد لـ Length) + أربعة سجلات. سجل العدد الصحيح هو TAG (1) + Payload (1 WORD فأكثر)، وسجل BINARY-FLOAT هو 2 أو 3 أو 5 أو 9 WORD، وسجل العدد العشري هو TAG (1) + الأس (2) + coefficient (1 WORD فأكثر)، وسجل FRACTION هو 5 WORD فأكثر.
- العدد الصحيح الصغير بلا وحدة ولا حدود هو 6 WORD، والعدد العشري الصغير 8 WORD. ومن 15 WORD فأكثر يُستخدم الطول الممتد ([السجل وTAG WORD](../record.md)).

## مثال {#예시}

`1.20` بلا وحدة:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`، 8 WORD)، amount `0683 FFFF FFFE 0078` (E = -2، C = 120)، وunit وlower وupper هي `0000`.

عدد صحيح `42` بلا وحدة:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD)، amount `0611 002A` (SIGNED-INTEGER 42)، وunit وlower وupper هي `0000`.

كسر `2/3` بلا وحدة (ثلثا الأصوات الحاضرة):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD)، amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3)، وunit وlower وupper هي `0000`.

`652 km`، المدى `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- المجموع 17 WORD فـ `LLLL=1110`، وTAG الممتدة `0011`.

## المقابل في ويكي بيانات {#위키데이터-대응}

- datavalue من نوع `quantity` وهو `{"amount","unit","lowerBound","upperBound"}` → amount وunit وlower وupper. تُنقل سلسلتا amount والحدود (`+1.20`، بما فيها الصيغة الأسية) إلى C وE بعدد الخانات كما هو.
- amount والحدود في ويكي بيانات سلاسل عشرية، فتُنقل إلى SIGNED-DECIMAL حتى لو بدت أعداداً صحيحة (`+652`). ولا يستخدم تحويل ويكي بيانات Codec عددية أخرى.
- unit `"1"` تعني بلا وحدة (`0x0000`)، و`http://www.wikidata.org/entity/Qn` هي WIKIDATA-QID. أما الوحدات الأخرى والأعداد والحدود غير الصحيحة الصيغة فلا تُحوَّل بل يُحفظ النص الأصلي بصيغة UTF8-TEXT.
- عينة ويكي بيانات (نحو 42 ألف quantity في بداية الـ dump): بلا وحدة 61%، وفيها حدود 13% (منها متماثلة 93%)، وأطول amount 31 حرفاً.

## الأساس المعياري {#표준-근거}

- التدوين العشري وحفظ عدد الخانات: مفاهيم coefficient وexponent وquantum في decimal ضمن [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL في GEUL).
- نموذج الكمية في ويكي بيانات: Wikibase DataModel `QuantityValue`.

## صفحات ذات صلة {#관련-페이지}

- [Value](_index.md)، [SIGNED-DECIMAL](0x068L-signed-decimal.md)، [COORDINATE-GEO](0x065L-coordinate-geo.md)، [CODEC](../edge/0x0BEL-codec.md)، [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000660/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
