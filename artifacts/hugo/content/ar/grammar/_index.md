---
title: "نحو GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "مواصفة نحو GEUL v1. تعرّف السجلات فوق الكلمات ذات 16 بت وأنواع Kind الأربعة وكل Codec وبنية المستند وقواعد Issuer والنشر."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

هذه مواصفة نحو GEUL v1. إذا كنت تقرؤها أول مرة فاقرأ بالترتيب الآتي.

1. [نظرة عامة](/ar/grammar/overview/) — ما هو GEUL وبأي مبادئ صُمم
2. [السجل وTAG WORD](/ar/grammar/record/) — TAG WORD ذات 16 بت وKind وLength وCodec
3. [المستند](/ar/grammar/document/) — HEAD وBODY وتجزئة المحتوى والإصدار والمراجعة
4. [Reference](/ar/grammar/reference/) و[Value](/ar/grammar/value/) و[Edge](/ar/grammar/edge/) و[Meta](/ar/grammar/meta/) — أنواع Kind الأربعة
5. [Issuer والنشر](/ar/grammar/issuer/) — الجهة التي تصدر المستندات والصيغ، وجدول تخصيص 1 WORD، وطرق الإتاحة، والتوقيع ومفاتيح التحقق
6. [عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/) — كتابة المعرّف وعنوان النشر وتحديد الصيغة وفهرس الأسماء وقائمة الإصدارات وطبقات الثقة
7. [مواصفة Codec](/ar/grammar/codec-spec/) — كيف يُكتب تخطيط Codec كمستند GEUL
8. [مثال: عنصر ويكيداتا](/ar/grammar/example/) — مستند واحد حقيقي

هذه الصفحة فهرس لكل Codec. والنقر على الاسم يفتح الوثيقة التفصيلية لذلك Codec. والاسم بلا رابط ليس له وثيقة تفصيلية بعد. والرموز المباشرة غير المذكورة في الجداول محجوزة.

## Kind

TAG WORD هي `000K KLLL LCCC CCCC`. و`KK` هي Kind و`LLLL` هي Length و`CCC CCCC` هي 7 بتات Codec. أما Reference ففيها 4 بتات Codec و3 بتات Quantifier.

| القيمة | التصنيف | الوصف |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/ar/grammar/reference/) | سجل يشير إلى هدف. `QQQ` هو Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/ar/grammar/value/) | سجل قيمة |
| `0001 0LLL LCCC CCCC` | [Edge](/ar/grammar/edge/) | سجل تركيب |
| `0001 1LLL LCCC CCCC` | [Meta](/ar/grammar/meta/) | سجل عن المستند والسجلات |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/ar/grammar/reference/)

### Codec (`CCCC`)

| CCCC | الاسم | التصنيف | معرّف الهدف |
|---|---|---|---|
| `0000` | [علامة موضع](/ar/grammar/reference/slot-marker/) | محجوز | حزمة علامات من 1 WORD لا تشير إلى هدف. أدنى 3 بتات هي رقم العلامة (الجدول أدناه) |
| `0001` | [LOCAL](/ar/grammar/reference/local/) | تصريح | معرّف أصدره هذا المستند |
| `0010` | [GEUL](/ar/grammar/reference/geul/) | تصريح | كيان يصدره geul.org بترخيص CC0. تُخصَّص الأرقام الصغيرة للكيانات الكثيرة التكرار |
| `0011` | [GEUL-SIDX](/ar/grammar/reference/geul-sidx/) | تصريح | GEUL SIDX (Semantic-aligned Index). معرّف تحمل بتاته المعنى |
| `0100` | [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) | تصريح | عنصر ويكي بيانات. العدد الصحيح بعد `Q` |
| `0101` | [WIKIDATA-PID](/ar/grammar/reference/wikidata-pid/) | تصريح | خاصية ويكي بيانات. العدد الصحيح بعد `P` |
| `0110` | [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/) | إشارة وتصريح | Issuer نفسه. Payload هو Issuer (1/2/4/16 WORD) فقط ولا يوجد معرّف هدف |
| `0111` | [DOC-POINTER](/ar/grammar/reference/doc-pointer/) | إشارة وتصريح | إصدار واحد من مستند Issuer. Issuer + معرّف المستند 4 WORD + معرّف الإصدار 2 WORD، ولا يوجد معرّف هدف |
| `1000` | [EXTERNAL-POINTER-1WORD](/ar/grammar/reference/external-pointer/) | إشارة | معرّف LOCAL في مستند استُورد بـ `IMPORT-DOC`. IMPORT ID من 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/ar/grammar/reference/external-pointer/) | إشارة | مثل ما سبق. IMPORT ID من 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/ar/grammar/reference/external-pointer/) | إشارة | مثل ما سبق. IMPORT ID من 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/ar/grammar/reference/external-pointer/) | إشارة | مثل ما سبق. IMPORT ID من 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/ar/grammar/reference/external-issuer/) | إشارة وتصريح | معرّف LOCAL في مستند Issuer من 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/ar/grammar/reference/external-issuer/) | إشارة وتصريح | معرّف LOCAL في مستند Issuer من 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/ar/grammar/reference/external-issuer/) | إشارة وتصريح | معرّف LOCAL في مستند Issuer من 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/ar/grammar/reference/external-issuer/) | إشارة وتصريح | معرّف LOCAL في مستند Issuer من 16 WORD |

### علامة موضع (Codec `0000`)

`0000 0000 0000 0MMM` — [علامة موضع](/ar/grammar/reference/slot-marker/). لا تأتي في الموضع إلا إذا وضعت قائمة CODEC للحقل تلك WORD بالضبط.

| WORD | الاسم | المعنى | ويكي بيانات |
|---|---|---|---|
| `0x0000` | [ABSENT](/ar/grammar/reference/slot-marker/) | غير مكتوب. حُذف حقل اختياري. لا يقرر شيئاً عن العالم | لا snak |
| `0x0001` | [UNKNOWN-VALUE](/ar/grammar/reference/slot-marker/) | غير معروف. القيمة موجودة لكن لا يُعرف ما هي | `somevalue` |
| `0x0002` | [NO-VALUE](/ar/grammar/reference/slot-marker/) | لا شيء. لا قيمة | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | الاسم | المعنى | مثال |
|---|---|---|---|
| `000` | Identified | كائن معرَّف | إيلون ماسك، كوريا الجنوبية |
| `001` | Generic | قول عام وتعريفي عن النوع كله. يسمح بالاستثناء. | الجندي يطيع الأوامر |
| `010` | Free-choice | أي هدف يحقق الشرط | أي جندي |
| `011` | Universal | كل الأهداف التي تنتمي إلى النطاق المعطى | كل جندي |
| `100` | Variable | متغير خطابي | ذلك الشخص، هذه المرأة |
| `101`~`111` | Reserved |  |  |

- في Codec `0000` (علامة موضع) أدنى 3 بتات هي رقم العلامة لا Quantifier.

## Issuer

Issuer هو الجهة التي تعرّف المستندات والصيغ — [Issuer والنشر](/ar/grammar/issuer/)

| الموضع | المعنى |
|---|---|
| رمز ISSUER في Value وEdge (`0x7C`~`0x7F`) | الصيغة التي عرّفها ذلك Issuer |
| Meta `DOC-ID` | Issuer الذي أصدر هذا المستند |
| Meta `IMPORT-DOC` | Issuer الذي أصدر المستند المستورد |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER` | Issuer الذي أصدر المستند المشار إليه (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Issuer المشار إليه نفسه (1/2/4/16 WORD) |

| عرض Issuer | الإصدار |
|---|---|
| 1 WORD | يخصصه geul.org لجهات وضع المعايير والمؤسسات الرئيسية ([جدول تخصيص 1 WORD](/ar/grammar/issuer/#جدول-تخصيص-1-word)). |
| 2 WORD | تسجيل لدى geul.org. Issuer اجتاز إثبات ملكية النطاق (مثل company.com) |
| 4 WORD | تسجيل لدى geul.org. Issuer سُجّل بلا إثبات ملكية |
| 16 WORD | إصدار ذاتي. يُحسب من المفتاح العام بلا تسجيل. ويتبع قاعدة التوليد أدناه. |

### خوارزمية توقيع Issuer من 16 WORD

| معرّف خوارزمية التوقيع | الخوارزمية |
|---|---|
| `0x0001` | Ed25519 |
| غير ذلك | محجوز |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/ar/grammar/edge/)

أعلى بتّين في Codec هما العائلة. والرمز المباشر (7 بتات) ورقم صيغة ISSUER (16 بت) كلاهما يتبع القاعدة نفسها.

| أعلى بتّين | العائلة | الرمز المباشر | رقم الصيغة |
|---|---|---|---|
| `00` | وصف | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | دليل | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | تنفيذ | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/ar/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### الوصف (`00`)

| CCCCC | Codec | الاسم | صيغة فرعية | الوصف |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/ar/grammar/edge/reference-node/) |  | ربط اتجاهي يشير فيه Subject (وهو Reference) إلى Object |
| `00001` | `0x01` | [SAME-NODE](/ar/grammar/edge/same-node/) |  | تطابق: سجلا Reference يشيران إلى الهدف نفسه |
| `00010` | `0x02` | [DIFFERENT-NODE](/ar/grammar/edge/different-node/) |  | عدم تطابق: سجلا Reference يشيران إلى هدفين مختلفين |
| `00011` | `0x03` | [BIND](/ar/grammar/edge/bind/) |  | يربط Subject باسم تطابقه الآلة (`UTF8-TEXT-*`). فريد داخل النطاق ويجب أن يتطابق تماماً ولا لغة له |
| `00100` | `0x04` | [LABEL](/ar/grammar/edge/label/) |  | يربط اسماً (label) بلغة معينة لـ Subject. Object هو UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/ar/grammar/edge/alias/) |  | يربط اسماً آخر (كنية) لـ Subject. تخطيطه مثل LABEL |
| `00110` | `0x06` | [DESCRIPTION](/ar/grammar/edge/description/) |  | يربط وصفاً (description) بلغة معينة لـ Subject. تخطيطه مثل LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | وصف الفعل المختصر |
| `01001` | `0x09` | VERB |  | وصف الفعل |
| `01010` | `0x0A` | [TRIPLE](/ar/grammar/edge/triple/) |  | قضية بترتيب Predicate وSubject وObject مع rank. Object قيمة أو علامة UNKNOWN-VALUE·NO-VALUE. ومعناه مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به |
| `01011` | `0x0B` | [QUALIFIER](/ar/grammar/edge/qualifier/) |  | شرط واحد يقيّد قضية Edge آخر. Property وTarget (Edge Id) وValue (قيمة أو علامة UNKNOWN-VALUE·NO-VALUE). جزء من القضية |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | يوجد | بنية للتعبير عن العالم الروائي |
| `10001` | `0x11` | TIMELINE | يوجد | بنية للتعبير عن ترتيب العوالم والأحداث |
| `10010` | `0x12` | SCENE | يوجد | بنية المشهد لوصف خصائص السيناريو |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/ar/grammar/edge/publication/) |  | نشر المستند. DOC-POINTER وتجزئة المحتوى |
| `11001` | `0x19` | DEPRECATION |  | إهمال (deprecate) إصدار منشور. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | حذف إصدار منشور (شاهدة). DOC-POINTER وفئة السبب |
| `11011` | `0x1B` | [DECLARE](/ar/grammar/edge/declare/) |  | التصريح ببنية Payload لـ Codec واحد. Kind وCodec الهدف |
| `11100` | `0x1C` | [FIELD](/ar/grammar/edge/field/) |  | حقل واحد في Payload. DECLARE الذي ينتمي إليه، والعرض: سجل (Length الخاص بـ TAG) أو قيمة خام بعدد n من WORD |
| `11101` | `0x1D` | [ENUM](/ar/grammar/edge/enum/) |  | قيمة رمز واحدة في حقل القيمة الخام. الحقل وقيمة الرمز |
| `11110` | `0x1E` | [CODEC](/ar/grammar/edge/codec/) |  | Kind وCodec واحد يقبله الحقل. الحقل وWORD الهدف (`000K KLLL LCCC CCCC`، وLLLL 0000 دقيق و1111 رمز شامل، وعلامة الموضع بهدف دقيق `0000`~`0002` فقط). حقل السجل قد يكون له عدة (قائمة مغلقة)، وحقل القيمة الخام له واحد (تلك Value بلا TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| أعلى بتّين من CCCCC | الحزمة |
|---|---|
| `00` | الإشارة والأسماء |
| `01` | القضايا |
| `10` | البنية |
| `11` | أخرى |

### الدليل (`01`)

| Codec | الاسم | صيغة فرعية | الوصف |
|---|---|---|---|
| `0x20` | [SOURCE](/ar/grammar/edge/source/) |  | يصل سجلاً واحداً أو المستند كله بمصدره. Target (Edge Id في BODY، وفي HEAD `0` = المستند كله) وOrigin (Reference، أو ABSENT أو UNKNOWN-VALUE). خصائص المصدر تُكتب بـ TRIPLE يكون المصدر فيه Subject، وخصائص الاقتباس (تاريخ الاطلاع والموضع وتجزئة النص الأصلي) بـ QUALIFIER تُلحق بـ SOURCE. وSOURCE للمستند كله وQUALIFIER الخاصة به يوضعان في HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- نطاق النص الأصلي والجهة المنتِجة والموثوقية وفترة سريان كل مادة والسجل القديم تُكتب بـ QUALIFIER، ويُحسب الإصدار الذي دخلت فيه أول مرة من سجل الإصدارات ([SOURCE](/ar/grammar/edge/source/#تمثيل-الأدلة-الأخرى)).

### التنفيذ (`10`)

| CCCCC | Codec | الاسم | الوصف |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | تصريح بدالة. الرمز وقائمة رموز المعاملات ونوع الإرجاع والمتن (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | تصريح بنوع. الرمز والتركيب (قائمة رموز الحقول وقيم التعداد وهدف الكنية) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | تعبير ثابت. Value مضمّنة واحدة |
| `01001` | `0x49` | UNARY | تعبير أحادي. مُعامل (1 WORD) والمعامل |
| `01010` | `0x4A` | BINARY | تعبير ثنائي. مُعامل (1 WORD) والأيسر والأيمن |
| `01011` | `0x4B` | CALL | استدعاء. الدالة الهدف وعدد المعاملات ومعاملات × العدد |
| `01100` | `0x4C` | MEMBER | وصول إلى عضو. الهدف ورمز الحقل |
| `01101` | `0x4D` | INDEX | وصول بالفهرس. الهدف والفهرس |
| `01110` | `0x4E` | CONSTRUCT | إنشاء قيمة مركبة (قائمة وسجل). النوع وعدد العناصر وعناصر × العدد |
| `01111` | `0x4F` | CONDITIONAL | تعبير شرطي. الشرط وقيمة الصحيح وقيمة الخطأ |
| `10000` | `0x50` | BLOCK | حزمة عبارات مرتبة. عدد العبارات وعبارات × العدد |
| `10001` | `0x51` | ASSIGN | إسناد. الهدف (رمز أو MEMBER أو INDEX) والقيمة |
| `10010` | `0x52` | IF | تفرع شرطي. الشرط وBLOCK للصحيح والخطأ (BLOCK·IF، وإن لم يوجد 0) |
| `10011` | `0x53` | SWITCH | تفرع متعدد. الهدف وعدد الفروع و(القيمة، BLOCK) × عدد الفروع وBLOCK الافتراضي (وإن لم يوجد 0) |
| `10100` | `0x54` | WHILE | تكرار شرطي. الشرط وBLOCK المتن |
| `10101` | `0x55` | FOREACH | تكرار بالمرور. رمز العنصر والهدف وBLOCK المتن |
| `10110` | `0x56` | JUMP | تحكم في التكرار. النوع (1 WORD: break وcontinue) والتكرار الهدف |
| `10111` | `0x57` | RETURN | إرجاع. القيمة (وإن لم توجد 0) |
| `11000` | `0x58` | RAISE | إثارة خطأ. قيمة الخطأ |
| `11001` | `0x59` | TRY | معالجة خطأ. BLOCK المتن ورمز الخطأ وBLOCK المعالجة وBLOCK الختام (وإن لم يوجد 0) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| أعلى بتّين من CCCCC | الحزمة |
|---|---|
| `00` | التصريح |
| `01` | التعبير |
| `10` | العبارة |
| `11` | الخطأ |

### TOULMIN (`11`)

التفاصيل: [TOULMIN](/ar/grammar/edge/toulmin/)

| CCCCC | Codec | الاسم | الوصف |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/ar/grammar/edge/toulmin/node/) | تصريح بقضية. رسم حكم يحمل العقد والعلاقات |
| `00001` | `0x61` | [PREDICATE-DECLARE](/ar/grammar/edge/toulmin/expr/) | تصريح بمحمول. دالة الحكم وتعبيره، ومعيار الحكم (Spec)، وعقد الوقائع (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/ar/grammar/edge/toulmin/node/) | تصريح بمعيار الحكم. الثوابت والقوائم (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/ar/grammar/edge/toulmin/node/) | تصريح بدعوى. يضع المحمول داخل القضية قاعدة عامة (Warrant). يمكن مهاجمتها. |
| `00100` | `0x64` | [COUNTER-DECLARE](/ar/grammar/edge/toulmin/node/) | تصريح بدحض. يهاجم بنتيجة خاصة به. المستوى الافتراضي Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/ar/grammar/edge/toulmin/node/) | تصريح باستثناء. يهاجم بلا نتيجة خاصة به. المستوى الافتراضي Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/ar/grammar/edge/toulmin/link/) | علاقة هجوم. حكم المهاجم ينقص حكم الهدف تدريجياً. |
| `01001` | `0x69` | [SUPERSEDES](/ar/grammar/edge/toulmin/link/) | علاقة إقصاء. إذا كان المهاجم Active أخرج الهدف من التجميع حتماً. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الثنائية. التخطيط غير محدد |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/ar/grammar/edge/toulmin/link/) | تركيب التنفيذ. إذا كانت العقدة Active نُفِّذت القضية الفرعية (DAG). |
| `10001` | `0x71` | [DO](/ar/grammar/edge/toulmin/link/) | عمل يُنفَّذ إذا كانت العقدة Active |
| `10010` | `0x72` | [DO-ONCE](/ar/grammar/edge/toulmin/link/) | عمل يُنفَّذ مرة واحدة ولو أُعيدت المحاولة |
| `10011` | `0x73` | [UNDO](/ar/grammar/edge/toulmin/link/) | عمل تعويضي لـ DO (saga). إذا فشلت مرحلة لاحقة نُفِّذ بترتيب عكسي. |
| `10100` | `0x74` | [CHECKING](/ar/grammar/edge/toulmin/link/) | ربط يحكم فقط بلا آثار جانبية |
| `10101` | `0x75` | [ENTRY](/ar/grammar/edge/toulmin/node/) | نقطة دخول خارجية. تنفّذ القضية أو تحكم فيها |
| `10110` | `0x76` | [TRIGGER](/ar/grammar/edge/toulmin/node/) | نقطة دخول لحدث أو دورة بلا استدعاء خارجي |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | نتيجة حكم العقدة أو السجل. النتيجة (Pass وReview وFail) وقيمة الحكم وActivated وExcluded وLevel. التخطيط غير محدد. وحكم المستند كله هو Meta [VERDICT](/ar/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | دليل الحكم. الموضع والقيمة المتوقعة والقيمة الفعلية (Fact). التخطيط غير محدد |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | صيغة عرّفها Issuer |

| أعلى بتّين من CCCCC | الحزمة |
|---|---|
| `00` | التصريح |
| `01` | العلاقة |
| `10` | التنفيذ |
| `11` | النتيجة (`0x7C`~`0x7F` هي ISSUER) |

### صيغة Edge ISSUER

بعد `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) يوضع في Codec ممتد TAG كل من Issuer ورقم الصيغة. وأعلى بتّين من رقم الصيغة هما العائلة. وفضاء أرقام الصيغ منفصل عن Value.

| Issuer | رقم الصيغة | الاسم | العائلة | الوصف |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/ar/grammar/edge/toulmin/source/) | TOULMIN | النص الأصلي المؤلَّف. عرض SPAN وقيمة UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/ar/grammar/edge/toulmin/source/) | TOULMIN | اسم أو سلسلة |
| `0x0000` GEUL | `0xC002` | [SECTION](/ar/grammar/edge/toulmin/source/) | TOULMIN | بداية قسم. رمز القسم |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/ar/grammar/edge/toulmin/source/) | TOULMIN | بداية نطاق قضية |
| `0x0000` GEUL | `0xC004` | [CASE-END](/ar/grammar/edge/toulmin/source/) | TOULMIN | نهاية نطاق قضية |
| `0x0000` GEUL | `0xC005` | [PROSE](/ar/grammar/edge/toulmin/source/) | TOULMIN | فقرة وصفية (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/ar/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/ar/grammar/edge/toulmin/node/) | TOULMIN | NODE. إشارة إلى دالة |
| `0x0000` GEUL | `0xC012` | [FIELD](/ar/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/ar/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/ar/grammar/edge/toulmin/node/) | TOULMIN | NODE. حزمة تنفيذ مرتبة |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. قضية → حقل |
| `0x0000` GEUL | `0xC021` | [MEANS](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. بند تعريف → قيمة أو نوع |
| `0x0000` GEUL | `0xC022` | [HAS](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. بند تعريف → حقل |
| `0x0000` GEUL | `0xC023` | [RUNS](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. نقطة دخول → قضية، تنفيذ |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. نقطة دخول → قضية، حكم |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. محفّز → قضية |
| `0x0000` GEUL | `0xC026` | [UNTIL](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. محفّز → قضية (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. عقدة → معرّف عام |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. كنية → مسار (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/ar/grammar/edge/toulmin/link/) | TOULMIN | LINK. عقدة → TEXT، كتابة الاسم |

## Value

`0000 1LLL LCCC CCCC` — [Value](/ar/grammar/value/)

أعلى بتّين في Codec هما العائلة. وتنقسم NUMERIC/DECIMAL مرة أخرى بالبت الثالث من الأعلى (`000` NUMERIC و`001` DECIMAL).

| أعلى بتّين | العائلة | الرمز المباشر | رقم الصيغة |
|---|---|---|---|
| `00` | [NUMERIC](/ar/grammar/value/numeric/)/[DECIMAL](/ar/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/ar/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/ar/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/ar/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### الرموز المباشرة

| Codec | الاسم | العائلة | الوصف |
|---|---|---|---|
| `0x00` | [BOOL](/ar/grammar/value/numeric/bool/) | NUMERIC | false أو true في 1 WORD ثابتة |
| `0x01` | [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/) | NUMERIC | عدد صحيح بإشارة بمتمم اثنين بأقل عدد من WORD |
| `0x02` | [UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/) | NUMERIC | عدد صحيح magnitude بلا إشارة بترتيب big-endian بأقل عدد من WORD |
| `0x03` | [BINARY-FLOAT](/ar/grammar/value/numeric/binary-float/) | NUMERIC | scalar من IEEE 754 binary16/32/64/128 بـ Payload من 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/ar/grammar/value/numeric/coordinate-earth/) | NUMERIC | خط العرض وخط الطول على الأرض (WGS 84) binary64 وعدم اليقين binary32 وReference لوحدته (ABSENT = مجهول) |
| `0x05` | [COORDINATE-GEO](/ar/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference الجرم السماوي وخط العرض وخط الطول binary64 وعدم اليقين binary32 وReference لوحدته |
| `0x06` | [QUANTITY](/ar/grammar/value/numeric/quantity/) | NUMERIC | amount من Value رقمي (عدد صحيح، BINARY-FLOAT، عدد عشري، كسر) وReference الوحدة والحد الأدنى والأعلى. يمكن حذف الوحدة والحدود (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/ar/grammar/value/numeric/fraction/) | NUMERIC | كسر يحفظ الكتابة الأصلية: بسط صحيح أو عشري، ومقام صحيح أو عشري بلا إشارة. لا يُختزل |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` من exponent `E` موقّع وcoefficient `C` بمتمم اثنين بأقل عدد من WORD |
| `0x11` | [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` من exponent `E` موقّع وcoefficient `C` بلا إشارة بأقل عدد من WORD |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) | TIME | عدد الأيام signed بالنسبة إلى proleptic Gregorian `1970-01-01` |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ar/grammar/value/time/civil-time-nanoseconds/) | TIME | عدد النانوثانية unsigned بعد منتصف ليل اليوم المدني |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/) | TIME | عدد الثواني signed منذ Unix/POSIX epoch |
| `0x23` | [DURATION-SECONDS](/ar/grammar/value/time/duration-seconds/) | TIME | زمن منقضٍ بثواني SI signed بلا epoch |
| `0x24`/`0x25` | [EDTF](/ar/grammar/value/time/edtf/) | TIME | سلسلة تاريخ EDTF (ISO 8601-2). عدد بايتات زوجي/فردي. لا تُستخدم لتاريخ يمكن كتابته بـ GREGORIAN-DATE |
| `0x26`/`0x27` | [GEDCOM-DATE](/ar/grammar/value/time/gedcom-date/) | TIME | سلسلة قيمة تاريخ GEDCOM 7. تحفظ الكتابة الأصلية لتقاويم أخرى (اليولياني وغيره). عدد بايتات زوجي/فردي |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/ar/grammar/value/text/utf8-text/) | TEXT | سلسلة بايتات UTF-8 صالحة بلا تلميح إلى التطبيع. عدد بايتات زوجي |
| `0x41` | [UTF8-TEXT-ODD](/ar/grammar/value/text/utf8-text/) | TEXT | مثل ما سبق. عدد بايتات فردي |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/ar/grammar/value/text/uri/) | TEXT | سلسلة بايتات ASCII وفق production الـ `URI` في RFC 3986. عدد بايتات زوجي |
| `0x45` | [URI-ODD](/ar/grammar/value/text/uri/) | TEXT | مثل ما سبق. عدد بايتات فردي |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/ar/grammar/value/text/language-bcp47-code/) | TEXT | سلسلة بايتات ASCII لوسم لغة BCP 47 كامل بحالة الأحرف القياسية. عدد بايتات زوجي |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/ar/grammar/value/text/language-bcp47-code/) | TEXT | مثل ما سبق. عدد بايتات فردي |
| `0x48` | [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/) | TEXT | وسم BCP 47 مكتوب برقمه في GEUL Language Registry ‏(Payload ‏1 WORD) |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/) | TEXT | نص مرفق بلغة. سجل Value للغة (LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE) وبايتات UTF-8. زوجية/فردية بايتات النص |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/ar/grammar/value/binary/uuid/) | BINARY | UUID وفق RFC 9562 بـ 128bit في Payload ثابت من 8 WORD |
| `0x61` | [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/) | BINARY | ناتج SHA-256 في Payload ثابت من 16 WORD |
| `0x62` | [SHA1-DIGEST](/ar/grammar/value/binary/sha1-digest/) | BINARY | ناتج SHA-1 في Payload ثابت من 10 WORD. لأغراض التعريف فقط مثل معرّف كائن git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | صيغة عرّفها Issuer. انظر صيغة Value ISSUER أدناه |

### صيغة Value ISSUER

بعد `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) يوضع في Codec ممتد TAG كل من Issuer ورقم الصيغة. وأعلى بتّين من رقم الصيغة هما العائلة.

| Issuer | رقم الصيغة | الاسم | العائلة | الوصف |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/ar/grammar/value/time/duration-nanoseconds/) | TIME | زمن منقضٍ بالنانوثانية signed بلا epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/ar/grammar/value/binary/opaque-bytes/) | BINARY | سلسلة بايتات مبهمة المعنى والصيغة. عدد بايتات زوجي |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/ar/grammar/value/binary/opaque-bytes/) | BINARY | مثل ما سبق. عدد بايتات فردي |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/ar/grammar/value/binary/bit-vector/) | BINARY | N بت مخزنة بترتيب MSB-first بعد bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | بتات تبادل BF16 في Payload ثابت من 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/ar/grammar/value/vector/dense-i16-vector/) | NUMERIC | متجه int16 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/ar/grammar/value/vector/dense-u16-vector/) | NUMERIC | متجه uint16 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/ar/grammar/value/vector/dense-i32-vector/) | NUMERIC | متجه int32 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/ar/grammar/value/vector/dense-u32-vector/) | NUMERIC | متجه uint32 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/ar/grammar/value/vector/dense-i64-vector/) | NUMERIC | متجه int64 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/ar/grammar/value/vector/dense-u64-vector/) | NUMERIC | متجه uint64 متصل بترتيب big-endian |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/ar/grammar/value/vector/dense-binary16-vector/) | NUMERIC | متجه IEEE 754 binary16 متصل |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/ar/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | متجه BF16 متصل |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/ar/grammar/value/vector/dense-binary32-vector/) | NUMERIC | متجه IEEE 754 binary32 متصل |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/ar/grammar/value/vector/dense-binary64-vector/) | NUMERIC | متجه IEEE 754 binary64 متصل |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/ar/grammar/value/vector/point2-binary64/) | NUMERIC | متجه ثنائي الأبعاد IEEE binary64 بترتيب `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/ar/grammar/value/vector/point3-binary64/) | NUMERIC | متجه ثلاثي الأبعاد IEEE binary64 بترتيب `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/ar/grammar/value/vector/bbox2-binary64/) | NUMERIC | متجه IEEE binary64 بترتيب `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/ar/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format وrank وshape وpayload من نوع dense بترتيب C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/ar/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format وrank وshape وpayload من نوع packed بترتيب low-bit-first داخل octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/ar/grammar/value/etc/complex64/) | NUMERIC | binary32 اثنان بترتيب `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/ar/grammar/value/etc/complex128/) | NUMERIC | binary64 اثنان بترتيب `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/ar/grammar/value/etc/rational-i64/) | NUMERIC | numerator من int64 مطبَّع وdenominator موجب من int64 |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/ar/grammar/value/etc/closed-interval-binary64/) | NUMERIC | فترة مغلقة من binary64 فيها `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/ar/grammar/value/etc/quaternion-binary32/) | NUMERIC | binary32 أربعة بترتيب `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/ar/grammar/value/binary/blake3-256-digest/) | BINARY | ناتج BLAKE3 الافتراضي في Payload ثابت من 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/ar/grammar/value/text/uri-relative-ref/) | TEXT | سلسلة بايتات ASCII لـ relative-ref في RFC 3986. عدد بايتات زوجي |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/ar/grammar/value/text/uri-relative-ref/) | TEXT | مثل ما سبق. عدد بايتات فردي |
| `0x0020` IETF | `0xC000` | [CRC32C](/ar/grammar/value/binary/crc32c/) | BINARY | ناتج Castagnoli CRC-32C في Payload ثابت من 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/ar/grammar/value/binary/ipv4-address/) | BINARY | 32bit لعنوان IPv4 في Payload ثابت من 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/ar/grammar/value/binary/ipv6-address/) | BINARY | 128bit لعنوان IPv6 في Payload ثابت من 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/ar/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD في Payload ثابت من 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/ar/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD في Payload ثابت من 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/ar/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD في Payload ثابت من 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/ar/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID في Payload ثابت من 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/ar/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID في Payload ثابت من 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/ar/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID في Payload ثابت من 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | عدد النانوثانية signed منذ Unix/POSIX epoch |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/ar/grammar/value/binary/mac-48-address/) | BINARY | 48bit لعنوان IEEE 802 MAC في Payload ثابت من 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/ar/grammar/value/vector/rgba8-unorm/) | NUMERIC | متجه packed ثابت من 4×UNORM8 بترتيب R وG وB وA |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/ar/grammar/value/vector/bgra8-unorm/) | NUMERIC | متجه packed ثابت من 4×UNORM8 بترتيب B وG وR وA |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | scalar من ONNX E4M3FN في octet الأعلى من Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | scalar من ONNX E4M3FNUZ في octet الأعلى من Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | scalar من ONNX E5M2 في octet الأعلى من Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | scalar من ONNX E5M2FNUZ في octet الأعلى من Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | scalar من E8M0FNU بلا إشارة وexponent فقط في octet الأعلى من Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | scalar من ONNX/DLPack E2M1FN في nibble الأعلى من Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/ar/grammar/value/time/tai-timestamp-seconds/) | TIME | عدد ثواني SI signed منذ `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | عدد النانوثانية signed منذ TAI epoch نفسه |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/ar/grammar/value/binary/sha-512-digest/) | BINARY | ناتج SHA-512 في Payload ثابت من 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/ar/grammar/value/binary/sha3-256-digest/) | BINARY | ناتج SHA3-256 في Payload ثابت من 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/ar/grammar/value/time/gps-timestamp-seconds/) | TIME | عدد الثواني signed منذ GPS epoch |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | عدد النانوثانية signed منذ GPS epoch |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/ar/grammar/meta/)

أعلى 3 بتات في Codec هي الفئة. ولا يوجد رمز ISSUER في Meta.

| أعلى 3 بتات | الفئة | الرمز المباشر | ما تتناوله |
|---|---|---|---|
| `000` | [البنية](/ar/grammar/meta/structure/) | `0x00`~`0x0F` | حدود المستند وطوله |
| `001` | [التعريف](/ar/grammar/meta/declaration/) | `0x10`~`0x1F` | تصريحات التفسير |
| `010` | [المصدر](/ar/grammar/meta/provenance/) | `0x20`~`0x2F` | من ومتى وأين |
| `011` | [النسب](/ar/grammar/meta/lineage/) | `0x30`~`0x3F` | مم جاء وكيف |
| `100` | [التحقق](/ar/grammar/meta/verification/) | `0x40`~`0x4F` | هل يمكن الوثوق به |
| `101` | [السياسة](/ar/grammar/meta/policy/) | `0x50`~`0x5F` | كيف يُعامَل |
| `110` | [IMPORT](/ar/grammar/meta/import/) | `0x60`~`0x6F` | استيراد مستند خارجي بـ IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### البنية (`000`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x00` | [DOC-1WORD](/ar/grammar/meta/structure/doc/) | بداية مستند حُدد طوله الكلي في Payload من 1 WORD |
| `0x01` | [DOC-2WORD](/ar/grammar/meta/structure/doc/) | بداية مستند حُدد طوله الكلي في Payload من 2 WORD |
| `0x02` | [DOC-4WORD](/ar/grammar/meta/structure/doc/) | بداية مستند حُدد طوله الكلي في Payload من 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/ar/grammar/meta/structure/body/) | 1 WORD. ينهي HEAD المستند ويبدأ BODY. |
| `0x0F` | [END](/ar/grammar/meta/structure/end/) | 1 WORD. يغلق المستند. |

### التعريف (`001`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ar/grammar/meta/declaration/spec-version/) | إصدار مواصفة GEUL المتّبع. Payload هو نفسه عدد صحيح unsigned بأقصر عرض. v1 هو `0x0001` (السجل `0x1890 0x0001`) |
| `0x11` | [PROFILE](/ar/grammar/meta/declaration/profile/) | الـ profile المطبَّق |
| `0x12` | [DOC-ID](/ar/grammar/meta/declaration/doc-id/) | معرّف هذا المستند. Reference مضمّن من نوع `DOC-POINTER` (Issuer ومعرّف المستند والإصدار 0) |
| `0x13` | [EFFECTIVE-FROM](/ar/grammar/meta/declaration/effective-from/) | تاريخ سريان هذا الإصدار. قيمة GREGORIAN-DATE أو POSIX-TIMESTAMP. فإن غاب فوقت النشر |
| `0x14` | [EFFECTIVE-UNTIL](/ar/grammar/meta/declaration/effective-until/) | نهاية مدة سريان هذا الإصدار (قانون مؤقت). فإن غاب فحتى سريان الإصدار التالي |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/ar/grammar/meta/declaration/default-language/) | اللغة الافتراضية |
| `0x17`~`0x1F` | Reserved |  |

### المصدر (`010`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x20` | [AUTHOR](/ar/grammar/meta/provenance/author/) | المؤلف. Reference (git author) |
| `0x21` | [CO-AUTHOR](/ar/grammar/meta/provenance/co-author/) | مؤلف مشارك. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/ar/grammar/meta/provenance/created-at/) | وقت التأليف. قيمة TIME (git author date) |
| `0x23` | [MODIFIED-AT](/ar/grammar/meta/provenance/modified-at/) | وقت التعديل. قيمة TIME |
| `0x24` | [RECORDED-BY](/ar/grammar/meta/provenance/recorded-by/) | الجهة التي سجّلت. Reference (git committer) |
| `0x25` | [RECORDED-AT](/ar/grammar/meta/provenance/recorded-at/) | وقت التسجيل. قيمة TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- المادة المصدرية ونطاقها ووقت الحصول عليها وتجزئتها لا تُكتب بـ Meta بل بـ Edge الدليل [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) في HEAD (Target `0`) وQUALIFIER الخاصة به.

### النسب (`011`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x30` | [PARENT](/ar/grammar/meta/lineage/parent/) | تجزئة محتوى الإصدار السابق (git parent). وإن غاب فهو الإصدار الأول، وإن كانت عدة فهو دمج (git merge commit). |
| `0x31` | [DERIVED-FROM](/ar/grammar/meta/lineage/derived-from/) | مشتق من سجلات أو مادة في نسب آخر. ولتثبيت إصدار معين من مادة خارجية تُلحق QUALIFIER لتجزئة النص الأصلي (P4092) بـ [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) في HEAD (git submodule). |
| `0x32` | [GENERATED-BY](/ar/grammar/meta/lineage/generated-by/) | الجهة المولِّدة. إنسان أو نموذج أو محرك قواعد |
| `0x33` | [TRANSFORMED-BY](/ar/grammar/meta/lineage/transformed-by/) | طريقة التحويل. الأداة والقواعد والإصدار |
| `0x34` | [CHERRY-PICKED-FROM](/ar/grammar/meta/lineage/cherry-picked-from/) | تجزئة محتوى الإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/ar/grammar/meta/lineage/reverts/) | تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert) |
| `0x36` | [REPLACES](/ar/grammar/meta/lineage/replaces/) | تجزئة محتوى الإصدار الهدف الذي أُعيدت كتابته (git amend·rebase). ولا يُحذف الإصدار الأصلي. |
| `0x37` | [SQUASHED-FROM](/ar/grammar/meta/lineage/squashed-from/) | تجزئة محتوى الإصدارات الأصلية التي دُمجت في واحد (git squash) |
| `0x38` | [MESSAGE](/ar/grammar/meta/lineage/message/) | سبب التغيير. قيمة UTF8-LANGUAGE-TEXT، واحدة لكل لغة (git commit message) |
| `0x39` | [TAG](/ar/grammar/meta/lineage/tag/) | اسم ثابت يُلحق بإصدار. قيمة TEXT وتجزئة محتوى (git annotated tag) |
| `0x3A` | [DELTA-BASE](/ar/grammar/meta/lineage/delta-base/) | ملف هذا الإصدار هو diff بالنسبة إلى إصدار أساس من المستند نفسه (معرّف إصدار من 2 WORD) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/ar/grammar/meta/lineage/delta-remove/) | قائمة LOCAL ID (Edge Id) التي تُحذف من BODY الأساس في diff |
| `0x3C` | [NEXT-LOCAL-ID](/ar/grammar/meta/lineage/next-local-id/) | LOCAL ID التالي الذي سيُخصَّص (auto increment). يوضع في HEAD ملف قائمة الإصدارات `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### التحقق (`100`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ar/grammar/meta/verification/issuer-key/) | تصريح بمعرّف خوارزمية التوقيع والمفتاح العام لـ Issuer ذاتي الإصدار |
| `0x41` | [SIGNATURE](/ar/grammar/meta/verification/signature/) | توقيع على الهدف. والتوقيع على المستند يكون على تجزئة المحتوى (commit وtag موقَّعان في git) |
| `0x42` | [SIGNED-OFF](/ar/grammar/meta/verification/signed-off/) | إقرار بحق المساهمة. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/ar/grammar/meta/verification/confidence/) | الموثوقية |
| `0x44` | [VERDICT](/ar/grammar/meta/verification/verdict/) | نتيجة الحكم على المستند كله. Pass وReview وFail. وعلى مستوى العقدة والسجل [TOULMIN](/ar/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### السياسة (`101`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x50` | [LICENSE](/ar/grammar/meta/policy/license/) | الترخيص. Reference |
| `0x51` | [ACCESS](/ar/grammar/meta/policy/access/) | نطاق الإتاحة |
| `0x52` | [PRIVACY](/ar/grammar/meta/policy/privacy/) | درجة الخصوصية |
| `0x53` | [RETENTION](/ar/grammar/meta/policy/retention/) | مدة الاحتفاظ |
| `0x54` | [CONSENT](/ar/grammar/meta/policy/consent/) | نطاق الموافقة وأساسها |
| `0x55` | [USAGE](/ar/grammar/meta/policy/usage/) | قيود الاستخدام |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x60` | [IMPORT-DOC](/ar/grammar/meta/import/import-doc/) | يستورد مستنداً خارجياً بـ IMPORT ID. Reference مضمّن `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
