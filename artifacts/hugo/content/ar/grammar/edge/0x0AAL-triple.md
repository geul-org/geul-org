---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE هو Edge عبارة يحمل قضية واحدة (Predicate وSubject وObject) ودرجتها (rank)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `TRIPLE` (BIND مستند المواصفة `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| مستند المواصفة | `0x00000000/codecs/0x00000AA0/` (هدف DECLARE `0AA0`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 10 |
| Kind | Edge · العائلة: العبارة، الحزمة: القضية |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | قضية بترتيب Predicate وSubject وObject مع rank. Object قيمة أو علامة UNKNOWN-VALUE·NO-VALUE. معناها هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص بها |
| جانب Hugo | `edge/triple.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference) |  |
| 2 | `subject` | #3 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference) |  |
| 3 | `object` | #4 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `060F` القسم 3 كله (حرف بدل، Value)، `080F` القسم 4 كله (حرف بدل، Value)، `0010` UNKNOWN-VALUE، `0020` NO-VALUE |  |
| 4 | `rank` | #5 | قيمة خام 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal، `0x0001` preferred، `0x0002` deprecated |

TRIPLE هو Edge عبارة يحمل قضية واحدة (Predicate وSubject وObject) ودرجتها (rank). Codec `0x0AAL`.

تُلحق الشروط التي تحدِّد القضية (وقت البدء والانتهاء، ونطاق التطبيق، ونحوها) بـ [QUALIFIER](0x0ABL-qualifier.md) الذي يشير إلى Edge Id الخاص بـ TRIPLE. ويُلحق المصدر (references في ويكيداتا) بـ Edge الدليل [SOURCE](0x0C0L-source.md) الذي يشير إلى Edge Id الخاص بـ TRIPLE.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Predicate         سجل Reference (WIKIDATA-PID ونحوه)
Subject           سجل Reference
Object            سجل Reference أو Value، أو علامة الموضع 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| الرمز | الاسم | المعنى |
|---|---|---|
| `0` | normal | الافتراضي |
| `1` | preferred | القيمة الحالية، الأكثر حجية |
| `2` | deprecated | قيمة حُكم بأنها خاطئة أو قديمة لكنها بقيت مسجَّلة |

- مثل statement rank في ويكيداتا. القيمة الممثِّلة (truthy في ويكيداتا) من بين Subject وPredicate نفسيهما هي preferred إن وُجدت، وإلا normal.
- المصدر الذي لا يمنح rank يستخدم `0` (normal).
- أي رمز آخر invalid.

## التفسير والصلاحية {#해석과-유효성}

- Predicate وSubject سجل Reference واحد كامل تماماً لكل منهما.
- Object هو سجل Reference أو Value واحد كامل تماماً، أو [علامة الموضع](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) أو `0x0020` (NO-VALUE) من 1 WORD. لا يقبل ABSENT (`0x0000`). Object ليس حقلاً اختيارياً.
- بعد قراءة Object يجب أن يتبقى 1 WORD (Rank) تماماً.
- يضع مستند مواصفة geul.org في حقل Rank الخام [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) و[ENUM](0x0BDL-enum.md) 0·1·2. ويضع في حقل Object الـ CODEC `000F`·`020F`·`040F` (أي Reference) و`060F`·`080F` (أي Value) و`0010` (UNKNOWN-VALUE) و`0020` (NO-VALUE). ويضع في حقلي Predicate وSubject الـ CODEC `000F`·`020F`·`040F` (أي Reference). ولأنها حروف بدل فلا تقبل علامة الموضع.
- **معنى TRIPLE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به في الوثيقة نفسها.** يجمع القارئ QUALIFIER قبل أن يفسّر TRIPLE. وقد يكون TRIPLE المقروء بلا QUALIFIER قضية ينقصها التحديد (مثل «رئيس السلطة التنفيذية» دون تحديد زمني).

## غير معروف ولا شيء {#알-수-없음과-없음}

علامة الموضع في موضع Object ليست قيمة بل تأكيد يتعلق بالقضية.

| Object | المعنى | المنطق |
|---|---|---|
| قيمة v | إحدى قيم Predicate لـ Subject هي v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | توجد قيمة. لا يُعرف ما هي (`somevalue` في ويكيداتا) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | لا توجد قيمة (`novalue` في ويكيداتا) | `¬∃x. P(s, x)` |
| لا TRIPLE | لا يُؤكَّد شيء (العالم المفتوح) | |

- **تُقرأ ضمن شروط التحديد.** نطاق `∃` و`¬∃` يحدده QUALIFIER الذي يشير إلى ذلك TRIPLE. فإذا أُلحق QUALIFIER انغلق النطاق في ذلك المدى فقط. «لم يكن هناك بنك مركزي في 1811~1816» يُكتب بإلحاق QUALIFIER لـ P580 وP582 بـ TRIPLE من نوع NO-VALUE. ولا يتناقض مع TRIPLE لقيمة في فترة أخرى لـ Predicate نفسه.
- **يُطبَّق rank بالمثل.** عند اختيار القيمة الممثِّلة (truthy) تدخل TRIPLE من نوع UNKNOWN-VALUE·NO-VALUE في المرشحين أيضاً. وإن وُجد preferred بقي preferred وحده.
- **UNKNOWN-VALUE لا يساوي UNKNOWN-VALUE آخر.** UNKNOWN-VALUE لا يساوي أي قيمة ولا يخالفها (نتيجة المقارنة غير محددة)، ولا يُعدّ UNKNOWN-VALUE آخران قيمةً واحدة. كل ظهور تكميم وجودي مستقل. لذلك فإن TRIPLE اثنان من نوع UNKNOWN-VALUE متطابقي البايتات ليسا تكراراً ولا يُدمجان (قد يكون الأبناء اثنين أو واحداً).
- إذا وُجد TRIPLE من نوع NO-VALUE وTRIPLE بقيمة (أو UNKNOWN-VALUE) معاً لـ Subject وPredicate وrank نفسها دون أن تتمايز شروط التحديد فهو تناقض. يحذِّر المدقق ولا يرفض (وهي حالة موجودة في ويكيداتا أيضاً).
- لا تُكتب بـ UNKNOWN-VALUE قيمةٌ لم تُنقل (وللمصدر قيمة).

## مثال (غير معياري) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human)، normal. Edge Id هو `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD، و`LLLL=1001`. وTAG هو `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (الولايات المتحدة) P1304 (البنك المركزي) NO-VALUE، normal. لم يكن هناك بنك مركزي في 1811~1816 (QUALIFIER لـ P580·P582 في مثال [QUALIFIER](0x0ABL-qualifier.md)). Edge Id هو `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD، و`LLLL=1000`. وTAG هو `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- «لا أبناء (P40)» هو `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## مسائل مفتوحة {#열린-문제}

- scope (سياق الادعاء: العالم، المنظور): يُحدَّد عند ظهور وجوه الاستخدام.
- صيغة مختصرة تطوي TRIPLE وQUALIFIER في سجل واحد: بعد ظهور تصريح الحقل المتكرر (مسائل [DECLARE](0x0BBL-declare.md) المفتوحة).

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [QUALIFIER](0x0ABL-qualifier.md)، [SOURCE](0x0C0L-source.md)، [LABEL](0x0A4L-label.md)، [ALIAS](0x0A5L-alias.md)، [علامة الموضع](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md)، [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000AA0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
