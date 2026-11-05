---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION قيمة Value تمثل الكسر المكتوب في النص الأصلي بتدوينه نفسه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `FRACTION` (مستند المواصفة BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| مستند المواصفة | `0x00000000/codecs/0x00000670/` (هدف DECLARE هو `0670`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 7 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | كسر يحفظ تدوين النص الأصلي: بسط عدد صحيح أو عشري، ومقام عدد صحيح أو عشري بلا إشارة. لا يُختزل |
| جهة Hugo | `value/numeric/fraction.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | سجل | `0610` SIGNED-INTEGER، `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | سجل | `0620` UNSIGNED-INTEGER، `0690` UNSIGNED-DECIMAL |  |

FRACTION قيمة Value تمثل الكسر المكتوب في النص الأصلي بتدوينه نفسه. الرمز المباشر في Value هو `0x067L` والعائلة NUMERIC. البسط والمقام كل منهما سجل Value كامل. ولا يُختزل الكسر. وتحفظ هذه الصيغة الكسور التي يكون المكتوب بعينه هو السجل، مثل «ثلثين» و«خمسة من مئة» في القوانين، والحصة العشرية في السجل العقاري `23.45/1256.1`.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
numerator         سجل Value واحد: SIGNED-INTEGER أو SIGNED-DECIMAL
denominator       سجل Value واحد: UNSIGNED-INTEGER أو UNSIGNED-DECIMAL
```

## التفسير والصلاحية {#해석과-유효성}

- numerator هو سجل [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) أو [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`) واحد بالضبط.
- denominator هو سجل [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) أو [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`) واحد بالضبط.
- القائمة مغلقة. لا يُقبل أي Value آخر ولا FRACTION نفسها (التداخل ممنوع) ولا علامة الموضع (`0x0000` وغيرها).
- لكل من السجلين طوله الخاص، فلا تُكتب حدودهما على حدة. يجب أن يطابق المؤشر بعد قراءة السجلين نهاية Payload تماماً.
- تتبع السجلات الداخلية الصيغة القياسية لكل Codec (العدد الصحيح وcoefficient بأقل عدد من WORD). إذا وُجد سجل داخلي غير قياسي فـ FRACTION كلها invalid.
- القيمة هي `numerator / denominator`.

### حفظ التدوين {#표기-보존}

- **العدد الصحيح والعشري**: إذا كان مكوّن النص الأصلي عدداً صحيحاً (بلا فاصلة عشرية) فيُستخدم سجل INTEGER، وإذا كانت فيه فاصلة عشرية فيُستخدم سجل DECIMAL. كتابة المكوّن بـ DECIMAL أسّه `E = 0` هي invalid. ولهذا يكون للتدوين الواحد تسلسل بايتات واحد.
- C وE في مكوّن DECIMAL يطابقان عدد خانات النص الأصلي. `23.450` هو `23450×10^-3` وهو Value مختلفة عن `23.45`.
- **لا يُختزل الكسر.** يُكتب `2/4` و«خمسة من مئة» (`5/100`) كما هما. وتطابق البايتات يعني تطابق تدوين النص الأصلي.
- الكسر الذي مقامه 1 (`3/1`) يُكتب كما هو إذا كان النص الأصلي كذلك. وإذا كان النص الأصلي عدداً صحيحاً فتُستخدم Codec العدد الصحيح لا FRACTION. وإذا كان النص الأصلي عشرياً (`0.5` أو `5%`) فيُستخدم DECIMAL.
- توضع الإشارة في البسط وحده. المقام من Codec بلا إشارة.
- إذا كانت قيمة المقام 0 فهي invalid (`0` و`0.0` كلاهما).

### المقارنة {#비교}

- تحسب طبقة المقارنة FRACTION عدداً نسبياً دقيقاً `(C1 × 10^E1) / (C2 × 10^E2)` (مكوّن INTEGER له `E = 0`). ولا يُقرَّب بالفاصلة العائمة.
- تتم المقارنة والفرز وتحديد التكرار بهذه القيمة، ويتم الحفظ والتوقيع وتجزئة المحتوى بالتدوين (البايتات). `2/4` و`1/2` و`0.5` قيمتها واحدة وبايتاتها مختلفة.
- يُقارَن الحكم بالنصاب («ثلثان أو أكثر من أصوات المساهمين الحاضرين») بهذه القيمة الدقيقة.

## الطول {#길이}

- المجموع هو TAG (1 WORD) + (TAG ممتد لـ Length) + سجلان. سجل العدد الصحيح هو TAG (1) + Payload (1 WORD فأكثر)، وسجل العدد العشري هو TAG (1) + الأس (2) + coefficient (1 WORD فأكثر).
- الكسر الصحيح الصغير 5 WORD، والكسر العشري الصغير 9 WORD. ومن 15 WORD فأكثر يُستخدم الطول الممتد ([السجل وTAG WORD](../record.md)).

| النص الأصلي | المكوّنات | المجموع |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## مثال {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`، 5 WORD)، numerator `0611 0002` (SIGNED-INTEGER 2)، denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD)، numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2، C = 2345)، denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1، C = 12561).

## العلاقة بالصيغ الأخرى {#다른-형식과의-관계}

- تقبل amount وlower وupper في [QUANTITY](0x066L-quantity.md) صيغة FRACTION. فـ«ثلثا الأصوات الحاضرة» يمكن كتابتها بـ amount تساوي `2/3` في QUANTITY بلا وحدة.
- يكتب مستند المواصفة `0x00000000/codecs/0x00000670` في geul.org حقلي سجلات: numerator (`0610`·`0680`) وdenominator (`0620`·`0690`) ([مستند مواصفة Codec](../codec-spec.md)).
- إذا لزم كسر ثابت int64 يفرض الاختزال فتُستخدم صيغة Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## مسائل مفتوحة {#열린-문제}

1. حفظ تدوين العدد الكسري المختلط (`1 و2/3`).
2. صيغة تحمل كسراً لمكوّنيه وحدة (مساحة/مساحة) في QUANTITY اثنتين. FRACTION لا تحمل وحدة.
3. معيار التدوين لتمثيل النسبة المئوية والألفية (`5%` و`5‰`) بـ DECIMAL مع وحدة أم بـ FRACTION (`5/100`).
4. الكسر المركب (FRACTION في البسط والمقام). ممنوع حالياً.

## صفحات ذات صلة {#관련-페이지}

- [Value](_index.md)، [QUANTITY](0x066L-quantity.md)، [SIGNED-INTEGER](0x061L-signed-integer.md)، [SIGNED-DECIMAL](0x068L-signed-decimal.md)، [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000670/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
