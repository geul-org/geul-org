---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge سجل يجمع Reference وValue وEdge آخر ويصفها. أول مكوّن فيه دائماً Edge Id، وأعلى بتّين في Codec هما العائلة (وصف ودليل وتنفيذ وTOULMIN)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge سجل يجمع سجلات أخرى كمكوّنات ويصفها. عبارات مثل "Q42 إنسان" و"الاسم الإنجليزي لـ Q42 هو Douglas Adams" كل منها Edge واحد.

## التخطيط

```
TAG WORD          0001 0LLL LCCC CCCC
[Length ممتد TAG]
[Codec ممتد TAG]  في صيغة Issuer
Edge Id           سجل Reference من نوع LOCAL
المكوّنات         بالترتيب الذي يحدده Codec
```

- `LLLL` هو العدد الكلي لـ WORD شاملاً TAG WORD ناقص 1. يتخطى المفكك إلى السجل التالي بـ Length وحده دون معرفة Codec.
- **أول مكوّن دائماً هو Edge Id (Reference من نوع LOCAL).** وبما أنه LOCAL Reference (`0088` + المعرّف، وQuantifier `000`) يمكن قراءة Edge Id دون معرفة الـ codec.
- يجد كل مكوّن حدوده بـ Length الخاص به. ويجب أن يتطابق موضع القراءة بعد آخر مكوّن مع نهاية Edge تماماً.
- بنية المكوّنات (Payload) يحددها مستند كل Edge Codec.
- الـ Codec ذات الصيغ الفرعية (WORLD وTIMELINE وSCENE) يحدد فيها TAG من 1 WORD لكل Codec الصيغة الفرعية.
- ترتيب سجلات Edge لا معنى له (ما لم يحدده Codec على حدة. مثال: مستند [TOULMIN](/ar/grammar/edge/toulmin/)).
- يُشار إلى Edge آخر بـ Edge Id. فيُشار إلى Edge في هذا المستند بـ LOCAL، وإلى Edge في مستند آخر بـ Reference إشارة (`EXTERNAL-POINTER-*` و`EXTERNAL-ISSUER-*`).

## العائلات

| أعلى بتّين | العائلة | الرمز المباشر | وظيفتها |
|---|---|---|---|
| `00` | وصف | `0x00`~`0x1F` | تبني المحتوى عن العالم والأحداث |
| `01` | دليل | `0x20`~`0x3F` | من أين جاءت السجلات والمستندات ([SOURCE](/ar/grammar/edge/source/)) |
| `10` | تنفيذ | `0x40`~`0x5F` | بنية برنامج قابلة للتنفيذ (AST) |
| `11` | [TOULMIN](/ar/grammar/edge/toulmin/) | `0x60`~`0x7B` | رسم الحجج: الدعاوى والدحض والاستثناءات وعلاقات الهجوم والتنفيذ ونتائج الحكم |

## Edge الوصف

| Codec | الاسم | المكوّنات |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/ar/grammar/edge/reference-node/) | ربط اتجاهي: Subject (Reference) يشير إلى Object |
| `0x01` | [SAME-NODE](/ar/grammar/edge/same-node/) | سجلا Reference يشيران إلى الهدف نفسه |
| `0x02` | [DIFFERENT-NODE](/ar/grammar/edge/different-node/) | سجلا Reference يشيران إلى هدفين مختلفين |
| `0x03` | [BIND](/ar/grammar/edge/bind/) | يربط Subject باسم للآلة (UTF8-TEXT) |
| `0x04` | [LABEL](/ar/grammar/edge/label/) | اسم Subject بحسب اللغة (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/ar/grammar/edge/alias/) | اسم آخر لـ Subject. تخطيطه مثل LABEL |
| `0x06` | [DESCRIPTION](/ar/grammar/edge/description/) | وصف Subject بحسب اللغة. تخطيطه مثل LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | وصف الفعل |
| `0x0A` | [TRIPLE](/ar/grammar/edge/triple/) | قضية واحدة (Predicate وSubject وObject) وrank |
| `0x0B` | [QUALIFIER](/ar/grammar/edge/qualifier/) | شرط واحد يقيّد قضية Edge آخر |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | العالم الروائي وترتيب الأحداث وبنية المشهد |
| `0x18`~`0x1A` | [PUBLICATION](/ar/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | نشر إصدار المستند وتوصية بإهماله وحذفه ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#قائمة-الإصدارات)) |
| `0x1B`~`0x1E` | [DECLARE](/ar/grammar/edge/declare/) / [FIELD](/ar/grammar/edge/field/) / [ENUM](/ar/grammar/edge/enum/) / [CODEC](/ar/grammar/edge/codec/) | مفردات كتابة مواصفة Codec ([مواصفة Codec](/ar/grammar/codec-spec/)) |

- الصيغة `-SHORT` والصيغة العامة توضعان في زوج زوجي/فردي (VERB-SHORT `0x08`/VERB `0x09`). وLABEL يستقبل اللغة داخل سجل اللغة في Object (UTF8-LANGUAGE-TEXT) فيُستخدم له `0x04` وحده.
- PUBLICATION وDEPRECATION وTOMBSTONE يكتبها مستند قائمة الإصدارات. ولأن قائمة الإصدارات يجب أن تُقرأ دون كتاب رموز فهي مدمجة في المفكك (الطبقة 0 في [عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#الطبقات)).
- DECLARE وFIELD وENUM وCODEC مفردات تكتب مواصفة Codec. ولأن مستند المواصفة يجب أن يُقرأ دون كتاب رموز فتخطيطها مدمج في المفكك (الطبقة 0). أما كل مستند مواصفة Codec مكتوب بتلك المفردات فهو مستند عادي.

### TRIPLE

التفاصيل: [TRIPLE](/ar/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length ممتد TAG]
Edge Id           LOCAL Reference
Predicate         Reference (خاصية ويكي بيانات وغيرها)
Subject           Reference
Object            Reference أو Value
Rank              1 WORD
```

| Rank | الاسم | المعنى |
|---|---|---|
| `0` | normal | افتراضي |
| `1` | preferred | القيمة الحالية، الأكثر موثوقية |
| `2` | deprecated | قيمة حُكم بأنها خاطئة أو قديمة لكنها بقيت مسجلة |

- Rank هو نفسه statement rank في ويكي بيانات. والمصدر الذي لا يمنح rank يستخدم `0`.
- **معنى TRIPLE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص بها.** وتجمع جهة القراءة QUALIFIER قبل تفسير TRIPLE.

مثال: Q42 — P31 (instance of) — Q5 (إنسان)، normal، وEdge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

التفاصيل: [QUALIFIER](/ar/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length ممتد TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id الخاص بالـ Edge الذي يقيّده)
Value             Reference أو Value
```

- QUALIFIER جزء من القضية. ليس دعوى مستقلة عن القضية بل يقيّد الشروط التي تصح بها القضية (وقت البداية والنهاية ونطاق التطبيق وغيرها).
- الدعاوى المستقلة عن القضية (من ادّعاها وغيره) تُكتب بـ TRIPLE.
- Target هو Edge في المستند نفسه. وترتيب QUALIFIER ذات Target واحد هو ترتيبها في المستند.

مثال: Q42 — P69 (educated at) — Q691283، والبداية (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL وALIAS وDESCRIPTION

التفاصيل: [LABEL](/ar/grammar/edge/label/)، [ALIAS](/ar/grammar/edge/alias/)، [DESCRIPTION](/ar/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length ممتد TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- يُحمل الاسم واللغة في Object واحد (UTF8-LANGUAGE-TEXT).
- لا يكون لـ Subject واللغة نفسيهما أكثر من LABEL واحد. والأسماء الأخرى تُكتب بـ ALIAS.
- الاسم بلا لغة للآلة يُكتب بـ BIND. أما LABEL فيجب أن تكون له لغة.

### BIND

التفاصيل: [BIND](/ar/grammar/edge/bind/)

- يربط Subject باسم تطابقه الآلة (UTF8-TEXT). لا لغة له ولا يُطبَّع. يجب أن تتطابق البايتات ليكون الاسم نفسه.
- نطاق الاسم هو المستند الذي يحمل BIND. ولا يُربط الاسم نفسه بـ Subject مختلفين في مستند واحد.
- لا تشير السجلات الأخرى بالاسم بل بمعرّف LOCAL. ويُستخدم الاسم للمطابقة مع الخارج (دالة المضيف وإدخال العنوان والإنسان).

### SAME-NODE وDIFFERENT-NODE وREFERENCE-NODE

التفاصيل: [SAME-NODE](/ar/grammar/edge/same-node/)، [DIFFERENT-NODE](/ar/grammar/edge/different-node/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)

- SAME-NODE تطابق يعني أن سجلَّي Reference يشيران إلى الهدف نفسه. وهو انعكاسي ومتناظر ومتعدٍّ.
- DIFFERENT-NODE عدم تطابق يعني أن سجلَّي Reference يشيران إلى هدفين مختلفين.
- REFERENCE-NODE ربط اتجاهي يعرّف بـ Object ما هو Subject (Reference). وليس دعوى تطابق. مثال: يعرّف URI الذي تشير إليه عقدة LOCAL.

## Edge الدليل

يُلحق دليلاً بسجل مفرد في BODY أو بالمستند كله (HEAD). والرمز المباشر الوحيد في عائلة الدليل هو [SOURCE](/ar/grammar/edge/source/) (`0x20`).

| Codec | الاسم | المكوّنات |
|---|---|---|
| `0x20` | [SOURCE](/ar/grammar/edge/source/) | Target (Edge Id الخاص بـ Edge في BODY يُلحق به الدليل، وفي HEAD `0` = المستند كله)، وOrigin (Reference المصدر، أو ABSENT أو UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- خصائص المصدر نفسه (URL والعنوان والمؤلف وتاريخ النشر …) تُكتب بـ TRIPLE يكون المصدر فيه Subject، وخصائص الاقتباس (تاريخ الاطلاع والموضع داخل المصدر …) تُكتب بـ QUALIFIER يكون Target فيه هو Edge Id الخاص بـ SOURCE.
- مصدر المستند كله يُكتب في HEAD بـ SOURCE ذي Target `0`، وتوضع في HEAD أيضاً QUALIFIER التي تجعله Target. والـ Edge التي تأتي في HEAD هاتان فقط، ويشترك HEAD وBODY في فضاء أرقام واحد لـ Edge Id ([مصدر المستند كله](/ar/grammar/edge/source/#مصدر-المستند-كله)).
- الأدلة الأخرى (نطاق النص الأصلي والجهة المنتِجة والموثوقية وفترة سريان كل مادة والسجلات القديمة) تُكتب بـ QUALIFIER، ويُحسب الإصدار الذي دخلت فيه أول مرة من سجل الإصدارات ([SOURCE](/ar/grammar/edge/source/#تمثيل-الأدلة-الأخرى)).
- نتيجة الحكم على مستوى السجل من شأن `VERDICT` في TOULMIN.

### SOURCE

التفاصيل: [SOURCE](/ar/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length ممتد TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id الخاص بـ Edge في BODY يُلحق به الدليل، وفي HEAD يكون 0 = المستند كله)
Origin            Reference أو علامة موضع 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

مثال: مصدر TRIPLE `#178` لـ Q42 P19 هو بريتانيكا (Q5375741)، والمعرّف داخله P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge التنفيذ

بنية برنامج غير مقيدة بلغة برمجة بعينها. تُشار مكوّناتها بمعرّفات LOCAL في هذا المستند.

| الحزمة | Codec |
|---|---|
| التصريح | FUNCTION-DECLARE, TYPE-DECLARE |
| التعبيرات | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| العبارات | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| الأخطاء | RAISE, TRY |

- ليست صيغة تحمل كود لغة خارجية كما هو. وكود اللغات الخارجية يوضع في صيغة Issuer.
- تُشار المكوّنات بمعرّف LOCAL في هذا المستند (REF). وفي موضع التعبير يوضع Edge تعبير أو رمز. وREF `0` تعني لا شيء.
- التعبير ينتج قيمة والعبارة لا تنتج. ويمكن وضع التعبير في موضع العبارة في BLOCK (وتُهمل القيمة).
- حلقة `for` على نمط C تُكتب بـ BLOCK (التهيئة، WHILE)، و`else if` بـ IF في موضع الخطأ (false).
- الرمز هو معرّف LOCAL، ويُربط اسمه بـ BIND. والسجلات الأخرى تشير إلى الرمز بمعرّف LOCAL لا بالاسم. وإذا تطابق الاسم واختلف معرّف LOCAL فهما رمزان مختلفان.
- ما هو الرمز (متغير أو معامل أو دالة أو نوع) يحدده السجل الذي يشير إليه. والرمز الذي لا تعريف له في المستند يوفره الخارج (المضيف)، وإذا كان هدف CALL فهو دالة المضيف.

مسائل مفتوحة: رموز العمليات وتمثيل الأنواع وتخطيط Payload لكل Codec.

## Edge الخاص بـ TOULMIN

التفاصيل: [TOULMIN](/ar/grammar/edge/toulmin/)

يكتب رسم الأحكام والتنفيذ بنموذج الحجة عند Toulmin. وهي العائلة الجوهرية التي يصف بها GEUL قواعده بنفسه ويصحح نفسه.

| الحزمة | Codec |
|---|---|
| التصريح | CASE-DECLARE (القضية) وPREDICATE-DECLARE ([PREDICATE-DECLARE](/ar/grammar/edge/toulmin/expr/)) (المحمول) وSPEC-DECLARE (معيار الحكم) وRULE-DECLARE (الدعوى) وCOUNTER-DECLARE (الدحض) وEXCEPT-DECLARE (الاستثناء) — [NODE](/ar/grammar/edge/toulmin/node/) |
| العلاقات | ATTACKS (الهجوم) وSUPERSEDES (الإقصاء) — [LINK](/ar/grammar/edge/toulmin/link/)، وSUPERSEDE-CHAIN (سلسلة الأولوية، التخطيط غير محدد) |
| التنفيذ | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/ar/grammar/edge/toulmin/link/)، وENTRY, TRIGGER — [NODE](/ar/grammar/edge/toulmin/node/) |
| النتيجة | VERDICT (نتيجة الحكم: Pass وReview وFail) وEVIDENCE (دليل الحكم) — التخطيط غير محدد |

- النص الأصلي والأقسام والعقد المساعدة والعلاقات هي صيغة ISSUER (`0xC000`~`0xC029`) في GEUL Issuer ([SOURCE والأقسام](/ar/grammar/edge/toulmin/source/)).
- نتيجة الحكم توضع في مستند مختلف عن مستند موضوع الحكم. يستورد مستند النتيجة مستند الموضوع ويشير إليه. لذلك لا يتغير تجزئة محتوى مستند الموضوع بالحكم.

## Edge صيغة Issuer

يمكن لـ Issuer أن يعرّف صيغ Edge خاصة به ويستخدمها (Codec `0x7C`~`0x7F`). الرموز المباشرة `0x7C`~`0x7F` داخل نطاق TOULMIN لكنها رموز ISSUER عامة، وتتحدد العائلة بأعلى بتّين من رقم الصيغة.

| Issuer | رقم الصيغة | الاسم | العائلة |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/ar/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/ar/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/ar/grammar/edge/toulmin/link/) | TOULMIN |
