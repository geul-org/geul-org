---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION قيمة Value للكسر تحمل البسط (عدد صحيح أو عشري) والمقام (عدد صحيح أو عشري بلا إشارة) كما كُتبا في الأصل دون اختزال."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION قيمة Value تمثل كسراً مكتوباً في نص أصلي مع حفظ كتابته. الرمز المباشر في Value هو `0x07` والعائلة NUMERIC. كل من البسط والمقام سجل Value كامل. لا يُختزل الكسر. يحمل الكسور التي تكون كتابتها نفسها هي السجل، مثل "الثلثين" و"خمسة في المئة" في القوانين، والحصة العشرية `23.45/1256.1` في السجل العقاري.

## التخطيط

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
numerator         سجل Value واحد: SIGNED-INTEGER أو SIGNED-DECIMAL
denominator       سجل Value واحد: UNSIGNED-INTEGER أو UNSIGNED-DECIMAL
```

## التفسير والصلاحية

- numerator سجل واحد بالضبط من [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/) (`0x01`) أو [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/) (`0x10`).
- denominator سجل واحد بالضبط من [UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/) (`0x02`) أو [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- القائمة مغلقة. لا تُقبل أي Value أخرى ولا FRACTION نفسها (لا تداخل) ولا علامات الموضع (`0x0000` وما شابه).
- لكل من السجلين طوله الخاص، فلا يُكتب حد فاصل بينهما. يجب أن يطابق المؤشر بعد قراءة السجلين نهاية Payload تماماً.
- السجلات الداخلية أيضاً تتبع الصيغة القانونية لكل Codec (أقل عدد من WORD للأعداد الصحيحة وcoefficient). إذا كان سجل داخلي غير قانوني فالـ FRACTION كلها invalid.
- القيمة هي `numerator / denominator`.

### حفظ الكتابة

- **الصحيح والعشري**: إذا كان مكوّن الأصل عدداً صحيحاً (بلا فاصلة عشرية) استُخدم سجل INTEGER، وإن كانت فيه فاصلة عشرية استُخدم سجل DECIMAL. كتابة المكوّن DECIMAL بأس `E = 0` invalid. لذلك للكتابة الواحدة تسلسل بايتات واحد.
- يحمل C وE في مكوّن DECIMAL خانات الأصل كما هي. `23.450` هو `23450×10^-3` وهو Value مختلفة عن `23.45`.
- **لا اختزال.** يُكتب `2/4` و"خمسة في المئة" (`5/100`) كما هما. إذا تطابقت البايتات تطابقت الكتابة الأصلية.
- الكسر الذي مقامه 1 (`3/1`) يُكتب أيضاً كما هو إن كتبه الأصل كذلك. وإذا كان الأصل عدداً صحيحاً استُخدم Codec العدد الصحيح لا FRACTION. وإذا كان الأصل عدداً عشرياً (`0.5` و`5%`) استُخدم DECIMAL.
- الإشارة في البسط وحده. المقام Codec بلا إشارة.
- المقام الذي قيمته 0 invalid (`0` و`0.0` كلاهما).

### المقارنة

- تحسب طبقة المقارنة FRACTION بوصفها العدد النسبي الدقيق `(C1 × 10^E1) / (C2 × 10^E2)` (مع `E = 0` لمكوّن INTEGER). لا تقرّبها بالفاصلة العائمة.
- المقارنة والترتيب وكشف التكرار تجري بهذه القيمة، أما التخزين والتوقيع وتجزئة المحتوى فتجري بالكتابة (البايتات). `2/4` و`1/2` و`0.5` قيمتها واحدة وبايتاتها مختلفة.
- يُحكم على النصاب ("ثلثا حقوق التصويت للمساهمين الحاضرين على الأقل") بهذه القيمة الدقيقة.

## الطول

- المجموع هو TAG (1 WORD) + (Length ممتد TAG) + السجلان. سجل العدد الصحيح هو TAG (1) + Payload (1 WORD فأكثر)، وسجل العدد العشري هو TAG (1) + الأس (2) + coefficient (1 WORD فأكثر).
- الكسر الصحيح الصغير يأخذ 5 WORD، والكسر العشري الصغير 9 WORD. وإذا بلغ 15 WORD فأكثر استُخدم الطول الممتد ([السجل وTAG WORD](/ar/grammar/record/)).

| الأصل | المكوّنات | المجموع |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## أمثلة

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`، 5 WORD)، وnumerator `0881 0002` (SIGNED-INTEGER 2)، وdenominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD)، وnumerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2، C = 2345)، وdenominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1، C = 12561).

## العلاقة بالصيغ الأخرى

- تقبل amount وlower وupper في [QUANTITY](/ar/grammar/value/numeric/quantity/) الصيغة FRACTION. يمكن كتابة "ثلثي حقوق التصويت الحاضرة" QUANTITY بلا وحدة قيمة amount فيها `2/3`.
- وثيقة المواصفة في geul.org `0x0000/0x0000000000000807` تكتبها بحقلي سجل: numerator (`0801` و`0810`) وdenominator (`0802` و`0811`) ([وثيقة مواصفة Codec](/ar/grammar/codec-spec/)).
- إذا احتيج إلى كسر int64 ثابت مع اختزال إلزامي فاستخدم صيغة Issuer [RATIONAL-I64](/ar/grammar/value/etc/rational-i64/).

## مسائل مفتوحة

1. حفظ كتابة الأعداد الكسرية المختلطة (`1 و2/3`).
2. صيغة تحمل كسراً لمكوّناته وحدات (مساحة/مساحة) في QUANTITY اثنتين. FRACTION لا تحمل وحدة.
3. معيار كتابة النسبة المئوية والألفية (`5%` و`5‰`): DECIMAL مع وحدة أم FRACTION (`5/100`).
4. الكسور المركبة (FRACTION في البسط أو المقام). ممنوعة حالياً.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [QUANTITY](/ar/grammar/value/numeric/quantity/)، [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/)، [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/)، [RATIONAL-I64](/ar/grammar/value/etc/rational-i64/)
