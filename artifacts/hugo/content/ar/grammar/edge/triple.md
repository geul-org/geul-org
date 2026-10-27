---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE هو Edge وصف يحمل قضية واحدة (Predicate وSubject وObject) ودرجتها (rank) (Codec 0x0A). يمكن أن يُكتب في Object بدل القيمة علامة غير معروف (UNKNOWN-VALUE) أو لا شيء (NO-VALUE)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE هو Edge وصف يحمل قضية واحدة (Predicate وSubject وObject) ودرجتها (rank). Codec `0x0A`.

شروط التقييد على القضية (وقت البداية والنهاية ونطاق التطبيق وغيرها) تُلحق بـ [QUALIFIER](/ar/grammar/edge/qualifier/) يشير إلى Edge Id الخاص بـ TRIPLE. والمصدر (references في ويكي بيانات) يُلحق بـ Edge الدليل [SOURCE](/ar/grammar/edge/source/) الذي يشير إلى Edge Id الخاص بـ TRIPLE.

## التخطيط

```
TAG WORD          0001 0LLL L000 1010
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Predicate         سجل Reference (WIKIDATA-PID وغيره)
Subject           سجل Reference
Object            سجل Reference أو Value، أو علامة الموضع 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| الرمز | الاسم | المعنى |
|---|---|---|
| `0` | normal | افتراضي |
| `1` | preferred | القيمة الحالية، الأكثر موثوقية |
| `2` | deprecated | قيمة حُكم بأنها خاطئة أو قديمة لكنها بقيت مسجلة |

- هو نفسه statement rank في ويكي بيانات. القيمة الممثلة (truthy في ويكي بيانات) هي preferred إن وُجد بين ما له Subject وPredicate نفسيهما، وإلا فهي normal.
- المصدر الذي لا يمنح rank يستخدم `0` (normal).
- أي رمز آخر invalid.

## التفسير والصلاحية

- Predicate وSubject كل منهما سجل Reference كامل واحد بالضبط.
- Object هو سجل Reference أو Value كامل واحد بالضبط، أو [علامة موضع](/ar/grammar/reference/slot-marker/) من 1 WORD هي `0x0001` (UNKNOWN-VALUE) أو `0x0002` (NO-VALUE). ولا يقبل ABSENT (`0x0000`). فـ Object ليس حقلاً اختيارياً.
- بعد قراءة Object يجب أن تبقى 1 WORD بالضبط (Rank).
- تضع مواصفة geul.org في حقل القيمة الخام Rank [CODEC](/ar/grammar/edge/codec/) من UNSIGNED-INTEGER (`0802`) و[ENUM](/ar/grammar/edge/enum/) من 0 و1 و2. وتضع في حقل Object CODEC `0780` (أي Reference) و`0F80` (أي Value) و`0001` (UNKNOWN-VALUE) و`0002` (NO-VALUE). ولا يقبل Predicate وSubject علامات الموضع.
- **معنى TRIPLE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به في المستند نفسه.** وتجمع جهة القراءة QUALIFIER قبل تفسير TRIPLE. وTRIPLE المقروء بلا QUALIFIER قد يكون قضية سقط منها التقييد (مثل "رئيس الحكومة" بلا تقييد زمني).

## غير معروف ولا شيء

علامة الموضع في موضع Object ليست قيمة بل تقريراً عن القضية.

| Object | المعنى | المنطق |
|---|---|---|
| قيمة v | إحدى قيم Predicate لـ Subject هي v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | القيمة موجودة. لا يُعرف ما هي (`somevalue` في ويكي بيانات) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | لا قيمة (`novalue` في ويكي بيانات) | `¬∃x. P(s, x)` |
| لا يوجد TRIPLE | لا يقرر شيئاً (عالم مفتوح) | |

- **تُقرأ ضمن شرط التقييد.** نطاق `∃` و`¬∃` تحدده QUALIFIER التي تشير إلى تلك TRIPLE. فإذا أُلحقت QUALIFIER فهي مغلقة في ذلك النطاق فقط. و"لم يكن هناك بنك مركزي في 1811~1816" تُكتب بإلحاق QUALIFIER P580 وP582 بـ TRIPLE من نوع NO-VALUE. ولا تتعارض مع TRIPLE قيمة في فترة أخرى للـ Predicate نفسه.
- **يُطبَّق rank بالطريقة نفسها.** عند اختيار القيمة الممثلة (truthy) تدخل TRIPLE ذات UNKNOWN-VALUE وNO-VALUE في المرشحين. وإذا وُجد preferred بقي preferred وحده.
- **لا يتساوى UNKNOWN-VALUE مع UNKNOWN-VALUE.** UNKNOWN-VALUE لا يساوي أي قيمة ولا يخالفها (نتيجة المقارنة غير محددة)، وUNKNOWN-VALUE واحد لا يُعدّ قيمة تساوي UNKNOWN-VALUE آخر. هو تكميم وجودي مستقل في كل ظهور. لذلك فإن TRIPLE اثنتين من نوع UNKNOWN-VALUE متطابقتي البايتات ليستا تكراراً ولا تُدمجان (قد يكون للشخص ولدان وقد يكون له ولد واحد).
- إذا اجتمعت NO-VALUE وTRIPLE بقيمة (أو UNKNOWN-VALUE) لـ Subject وPredicate وrank نفسها وشرطا التقييد غير متمايزين فهذا تعارض. ويُصدر المدقق تحذيراً. ولا يرفض (فهذه حالة موجودة في ويكي بيانات أيضاً).
- لا تُكتب بـ UNKNOWN-VALUE قيمة تعذّر نقلها (والقيمة موجودة في المصدر).

## أمثلة (غير معيارية)

Q42 (Douglas Adams) P31 (instance of) Q5 (human)، normal. وEdge Id `0005`.

- TAG (1) + Edge Id (2) + Predicate (2) + Subject (2) + Object (2) + Rank (1) = 10 WORD و`LLLL=1001`. وTAG هو `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (الولايات المتحدة) P1304 (البنك المركزي) NO-VALUE، normal. لم يكن هناك بنك مركزي في 1811~1816 (QUALIFIER P580 وP582 في مثال [QUALIFIER](/ar/grammar/edge/qualifier/)). وEdge Id `3161`.

- TAG (1) + Edge Id (2) + Predicate (2) + Subject (2) + Object (1) + Rank (1) = 9 WORD و`LLLL=1000`. وTAG هو `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "لا أبناء (P40)" هي `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## مسائل مفتوحة

- scope (سياق الدعوى: العالم والمنظور): يُحدد عند ظهور حاجة إليه.
- الصيغة المختصرة التي تطوي TRIPLE وQUALIFIER في سجل واحد: بعد وجود التصريح بالحقول المتكررة (مسألة مفتوحة في [DECLARE](/ar/grammar/edge/declare/)).

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [QUALIFIER](/ar/grammar/edge/qualifier/)، [SOURCE](/ar/grammar/edge/source/)، [LABEL](/ar/grammar/edge/label/)، [ALIAS](/ar/grammar/edge/alias/)، [علامة موضع](/ar/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/ar/grammar/reference/wikidata-pid/)، [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/)
