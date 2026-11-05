---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge سجلّ يربط سجلات أخرى بوصفها مكوّنات له ليعبّر عن عبارة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge سجلّ يربط سجلات أخرى بوصفها مكوّنات له ليعبّر عن عبارة. عبارات مثل «Q42 إنسان» و«الاسم الإنجليزي لـ Q42 هو Douglas Adams» كلٌّ منها Edge واحد.

## التخطيط {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      القسم 5~13 (0x0A0L~0x1BFL)
[Length TAG ممتد]
[Codec TAG ممتد]  عند صيغة Issuer
Edge Id           سجل LOCAL Reference
المكوّنات          بالترتيب الذي يحدده Codec
```

- `LLLL` هو عدد WORD الكلي شاملاً TAG WORD ناقص 1. يتخطى المفكِّك إلى السجل التالي بالاعتماد على Length وحده دون معرفة Codec.
- **أول مكوّن هو دائماً Edge Id (LOCAL Reference).** وبما أنه LOCAL Reference (`0051` + ID، Identified `0x005L`) فيمكن قراءة Edge Id دون معرفة الـ Codec.
- يجد كل مكوّن حدوده بـ Length الخاص به. ويجب أن يطابق موضع انتهاء قراءة آخر مكوّن نهاية Edge تماماً.
- تحدد وثيقة كل Codec لـ Edge تركيب المكوّنات (Payload).
- يحدد TAG واحد من WORD واحد خاص بكل Codec الصيغةَ الفرعية في الـ Codec ذات الصيغ الفرعية (WORLD وTIMELINE وSCENE).
- لا معنى للترتيب بين سجلات Edge (باستثناء ما يحدده Codec على حدة. مثال: وثيقة [TOULMIN](../toulmin/_index.md)).
- يُشار إلى Edge آخر بـ Edge Id. يُشار إلى Edge هذه الوثيقة بـ LOCAL، وإلى Edge وثيقة أخرى بـ Reference الإشاري (`EXTERNAL-POINTER-*` و`EXTERNAL-ISSUER-*`).

## العائلة {#계열}

نطاق Edge هو `0x0A0L~0x1BFL`. عائلة الرمز المباشر هي `(الرمز − 0xA0) >> 5` (الرمز هو الأرقام الثلاثة الأولى من TAG ID). كل عائلة 32 خانة، وتساوي القسم `w >> 9` مطروحاً منه 5. Edge هي الأقسام 5~13.

| القسم | العائلة | الرمز المباشر | وظيفتها |
|---|---|---|---|
| 5 | العبارة | `0x0A0L~0x0BFL` | تبني المحتوى المتعلق بالعالم والأحداث |
| 6 | الدليل | `0x0C0L~0x0DFL` | من أين جاءت السجلات والوثائق ([SOURCE](0x0C0L-source.md)) |
| 7 | التنفيذ | `0x0E0L~0x0FFL` | بنية البرنامج القابلة للتنفيذ (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | رسم الحجة: الادعاء والدحض والاستثناء وعلاقات الهجوم والتنفيذ ونتيجة الحكم |
| 9 | صيغة [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | النص الأصلي لوثيقة TOULMIN وأجزاؤها وعقدها المساعدة وعلاقاتها |

- الرموز المباشرة المخصصة هي هذه العائلات الخمس. `0x11CL~0x11FL` Reserved، و`0x135L~0x1BCL` Reserved (الأقسام 10~12 Reserved بكاملها).
- `0x1BDL~0x1BFL` (الخانات الثلاث الأخيرة من القسم 13) هي EDGE-ISSUER (انظر Edge بصيغة Issuer أدناه). لا قاعدة للعائلة في صيغة Issuer.

## Edge العبارة {#서술-edge}

| Codec | الاسم | المكوّنات |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | ربط موجَّه: Subject (Reference) يشير إلى Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | سجلا Reference يشيران إلى الهدف نفسه |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | سجلا Reference يشيران إلى هدفين مختلفين |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | يربط اسماً للآلة (UTF8-TEXT) بـ Subject |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | اسم Subject بحسب اللغة (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | اسم آخر لـ Subject. تخطيطه مثل LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | وصف Subject بحسب اللغة. تخطيطه مثل LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | عبارة فعلية |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | قضية واحدة (Predicate وSubject وObject) وrank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | شرط واحد يحدِّد قضية Edge آخر |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | رؤية العالم، وترتيب الأحداث، وبنية المشهد |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | نشر إصدار الوثيقة، والتوصية بإهماله، وحذفه ([عنوان النشر وقائمة الإصدارات](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | مفردات لكتابة مواصفة Codec ([مستند مواصفة Codec](../codec-spec.md)) |

- يوضع `-SHORT` والصيغة العادية زوجاً زوجياً/فردياً (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). يتلقى LABEL اللغةَ بوصفها سجل لغة داخل Object (UTF8-LANGUAGE-TEXT)، فيُستخدم `0x0A4L` وحده.
- تستخدم وثيقة قائمة الإصدارات PUBLICATION وDEPRECATION وTOMBSTONE. ولأن قائمة الإصدارات يجب أن تُقرأ دون codebook فهي مضمَّنة في المفكِّك (الطبقة 0 في [عنوان النشر وقائمة الإصدارات](../publishing.md#층)).
- DECLARE وFIELD وENUM وCODEC مفردات تكتب مواصفة Codec. ولأن مستند المواصفة يجب أن يُقرأ دون codebook فتخطيطها مضمَّن في المفكِّك (الطبقة 0). أما مستند مواصفة كل Codec المكتوب بهذه المفردات فهو وثيقة عادية.

### TRIPLE {#triple}

التفاصيل: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length TAG ممتد]
Edge Id           LOCAL Reference
Predicate         Reference (خاصية ويكيداتا ونحوها)
Subject           Reference
Object            Reference أو Value
Rank              1 WORD
```

| Rank | الاسم | المعنى |
|---|---|---|
| `0` | normal | الافتراضي |
| `1` | preferred | القيمة الحالية، الأكثر حجية |
| `2` | deprecated | قيمة حُكم بأنها خاطئة أو قديمة لكنها بقيت مسجَّلة |

- Rank مثل statement rank في ويكيداتا. المصدر الذي لا يمنح rank يستخدم `0`.
- **معنى TRIPLE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به.** يجمع القارئ QUALIFIER قبل أن يفسّر TRIPLE.

مثال: Q42 — P31 (instance of) — Q5 (إنسان)، normal، Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

التفاصيل: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length TAG ممتد]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id للـ Edge المحدَّد)
Value             Reference أو Value
```

- QUALIFIER جزء من القضية. وهو ليس ادعاءً منفصلاً عن القضية، بل يحدِّد الشروط التي تصير بها القضية صحيحة (وقت البدء والانتهاء، ونطاق التطبيق، ونحوها).
- يُكتب الادعاء المنفصل عن القضية (من ادّعى ذلك، ونحوه) بـ TRIPLE.
- Target هو Edge في الوثيقة نفسها. ترتيب QUALIFIER ذات Target نفسه هو ترتيبها في الوثيقة.

مثال: Q42 — P69 (educated at) — Q691283، البدء (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

التفاصيل: [LABEL](0x0A4L-label.md)، [ALIAS](0x0A5L-alias.md)، [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length TAG ممتد]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- يوضع الاسم واللغة في Object واحد (UTF8-LANGUAGE-TEXT).
- لا يزيد LABEL لـ Subject واللغة نفسيهما على واحد. تُكتب الأسماء الأخرى بـ ALIAS.
- يُكتب الاسم الآلي بلا لغة بـ BIND. أما LABEL فلا بد أن تكون له لغة.

### BIND {#bind}

التفاصيل: [BIND](0x0A3L-bind.md)

- يربط بـ Subject اسماً تطابقه الآلة (UTF8-TEXT). لا لغة له ولا يُطبَّع. لا يكون الاسمان متماثلين إلا إذا تطابقت البايتات.
- نطاق الاسم هو الوثيقة التي تحوي BIND. لا يُربط الاسم نفسه بـ Subject مختلفين في وثيقة واحدة.
- تُشير السجلات الأخرى بـ LOCAL ID لا بالاسم. يُستخدم الاسم للمطابقة مع الخارج (دوال المضيف، ومدخلات العناوين، والبشر).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

التفاصيل: [SAME-NODE](0x0A1L-same-node.md)، [DIFFERENT-NODE](0x0A2L-different-node.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE هو تطابق يفيد أن سجلَّي Reference يشيران إلى الهدف نفسه. وهو انعكاسي ومتماثل ومتعدٍّ.
- DIFFERENT-NODE هو عدم تطابق يفيد أن Reference هدفان مختلفان.
- REFERENCE-NODE ربط موجَّه يعرِّف بـ Object ما هو Subject (Reference). وليس ادعاء تطابق. مثال: يعرِّف URI الذي تشير إليه عقدة LOCAL.

## Edge الدليل {#근거-edge}

يُلحق دليلاً بسجل مفرد داخل BODY، أو بالوثيقة كلها (HEAD). الرمز المباشر الوحيد لعائلة الدليل هو [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | الاسم | المكوّنات |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id للـ Edge في BODY الذي يُلحق به الدليل، وفي HEAD يعني `0` الوثيقة كلها)، Origin (Reference الأصل، أو ABSENT أو UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- تُكتب خصائص الأصل نفسه (URL والعنوان والمؤلف وتاريخ النشر …) بـ TRIPLE يكون الأصل Subject فيه، وخصائص الاقتباس (تاريخ الاطلاع، والموضع داخل الأصل …) بـ QUALIFIER يكون Target فيه هو Edge Id لـ SOURCE.
- يُكتب أصل الوثيقة كلها في HEAD بـ SOURCE ذي Target `0`، ويوضع في HEAD أيضاً QUALIFIER الذي هو Target له. وهذان فقط ما يرد من Edge في HEAD، ويشترك HEAD وBODY في فضاء ترقيم واحد لـ Edge Id ([مصدر الوثيقة كلها](0x0C0L-source.md#문서-전체의-출처)).
- تُكتب الأدلة الأخرى (نطاق النص الأصلي، والجهة المنشئة، والموثوقية، وفترة سريان كل مادة، والسجلات القديمة) بـ QUALIFIER، ويُحسب الإصدار الذي دخلت فيه أول مرة من تاريخ الإصدارات ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- نتيجة الحكم على مستوى السجل مسؤولية `VERDICT` في TOULMIN.

### SOURCE {#source}

التفاصيل: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length TAG ممتد]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id للـ Edge في BODY الذي يُلحق به الدليل، وفي HEAD يعني 0 الوثيقة كلها)
Origin            Reference أو علامة الموضع 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

مثال: مصدر TRIPLE `#178` لـ Q42 P19 هو Britannica (Q5375741)، والمعرِّف داخله P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge التنفيذ {#실행-edge}

بنية برنامج غير مرتبطة بلغة برمجة بعينها. تُشار المكوّنات بـ LOCAL ID لهذه الوثيقة.

| الحزمة | Codec |
|---|---|
| التصريح | [FUNCTION-DECLARE](0x0E1L-function-declare.md)، [TYPE-DECLARE](0x0E2L-type-declare.md) |
| التعبير | [CONST](0x0E8L-const.md)، [UNARY](0x0E9L-unary.md)، [BINARY](0x0EAL-binary.md)، [CALL](0x0EBL-call.md)، [MEMBER](0x0ECL-member.md)، [INDEX](0x0EDL-index.md)، [CONSTRUCT](0x0EEL-construct.md)، [CONDITIONAL](0x0EFL-conditional.md) |
| الجملة | [BLOCK](0x0F0L-block.md)، [ASSIGN](0x0F1L-assign.md)، [IF](0x0F2L-if.md)، [SWITCH](0x0F3L-switch.md)، [WHILE](0x0F4L-while.md)، [FOREACH](0x0F5L-foreach.md)، [JUMP](0x0F6L-jump.md)، [RETURN](0x0F7L-return.md) |
| الخطأ | [RAISE](0x0F8L-raise.md)، [TRY](0x0F9L-try.md) |

- ليست صيغة تحمل شيفرة لغة خارجية كما هي. تُوضع شيفرة اللغات الخارجية بصيغة Issuer.
- تُشار المكوّنات بـ LOCAL ID (REF) لهذه الوثيقة. يوضع في موضع التعبير Edge تعبير أو رمز. REF `0` يعني لا شيء.
- التعبير يُنتج قيمة، والجملة لا تُنتج قيمة. يمكن وضع تعبير في موضع جملة داخل BLOCK (تُهمل قيمته).
- تُكتب حلقة `for` بأسلوب C بـ BLOCK (تهيئة، WHILE)، و`else if` بـ IF في موضع الفرع الخاطئ.
- الرمز هو LOCAL ID، ويُربط اسمه بـ BIND. تشير السجلات الأخرى إلى الرمز بـ LOCAL ID لا بالاسم. وإن تطابق الاسمان فإن اختلاف LOCAL ID يعني رمزين مختلفين.
- ما هو الرمز (متغير، معامل، دالة، نوع) يحدده السجل الذي يشير إليه. الرمز الذي لا تعريف له داخل الوثيقة يوفره الخارج (المضيف)، وإن كان هدفاً لـ CALL فهو دالة مضيف.

مسائل مفتوحة: رموز العوامل، وتمثيل الأنواع، وتخطيط Payload لكل Codec.

## Edge TOULMIN {#toulmin-edge}

يكتب رسم الحكم والتنفيذ بنموذج تولمين للحجة. الرمز المباشر `0x100L~0x11BL`، والسجلات المساعدة هي عائلة صيغة TOULMIN `0x120L~0x134L`. التفاصيل: [TOULMIN](../toulmin/_index.md)

## Edge بصيغة Issuer {#issuer-형식-edge}

يستطيع Issuer تعريف صيغة Edge خاصة به واستخدامها ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md) و[4WORD](0x1BEL-edge-issuer-4word.md) و[16WORD](0x1BFL-edge-issuer-16word.md)، Codec `0x1BDL`~`0x1BFL`). وهي الخانات الثلاث الأخيرة من نطاق Edge. يوضع في Codec TAG الممتد Issuer ورقم Codec في 2 WORD. Edge Id هو أول عنصر في Payload بعدها (TAG وIssuer ورقم Codec وEdge Id وبقية Payload). يحدد Issuer رقم Codec ولا قاعدة عائلة له. ولا يتكرر الرقم داخل `codecs/` لذلك Issuer مهما كان Kind. توضع وثيقة Codec تحت `codecs/` لذلك Issuer برقم Codec للسجل ([عنوان النشر وقائمة الإصدارات](../publishing.md)).

- لا توجد حالياً صيغة Edge ISSUER مسجَّلة.
