---
title: "فهرس الرموز"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "هذه الصفحة فهرس لكل Codec."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هذه الصفحة فهرس لكل Codec. النقر على الاسم ينقل إلى مستنده التفصيلي. الرمز المباشر غير المذكور في الجداول هو Reserved.

## Kind {#kind}

TAG WORD هي `000K KKKC CCCC LLLL`. البتات الأربع العليا `KKKK` هي القسم، و`C` هي الإزاحة ذات 5 بتات داخل القسم، و`LLLL` هي Length. والبتات التسع الناتجة من القسم مع `C` هي موضع Codec. يُكتب TAG ID على صورة `0x000L`. الخانات الثلاث الأولى هي هذه البتات التسع (`w >> 4`)، و`L` هي خانة Length ([السجل وTAG WORD](record.md)).

| القسم | TAG ID | التصنيف | الوصف |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | سجلات تشير إلى هدف |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | سجلات القيم |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | سجلات التركيب |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | سجلات عن المستند والسجلات |

- القسم هو `S = w >> 9` (4 بتات)، ويحوي كل قسم 32 خانة.
- يُحدَّد Kind بنطاق القسم وحده: `w < 0x0600` هو Reference، و`w < 0x0A00` هو Value، و`w < 0x1C00` هو Edge، والباقي Meta. لا استثناء.
- الخانات الثلاث الأخيرة في نطاقات Reference وValue وEdge هي ISSUER (`..DL` بـ 2 WORD، و`..EL` بـ 4 WORD، و`..FL` بـ 16 WORD). لا يوجد ISSUER في Meta.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | الاسم | التصنيف | معرّف الهدف |
|---|---|---|---|
| `0x000L~0x002L` | [علامة الموضع](slot-marker.md) | علامة الموضع | حزمة علامات من 1 WORD لا تشير إلى هدف (الجدول أدناه) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | تعريف | ID يُصدره هذا المستند |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | تعريف | كيان يُصدره geul.org بترخيص CC0. تُخصَّص الأرقام الصغيرة للكيانات الأعلى تكرارًا |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | تعريف | GEUL SIDX (Semantic-aligned Index). معرّف تحمل بتاته المعنى |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | تعريف | عنصر في ويكي بيانات. العدد الصحيح بعد `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | تعريف | خاصية في ويكي بيانات. العدد الصحيح بعد `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | إشارة | LOCAL ID في مستند جُلب بـ `IMPORT-DOC`. IMPORT ID بـ 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | إشارة | كما سبق. IMPORT ID بـ 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | إشارة | كما سبق. IMPORT ID بـ 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | إشارة وتعريف | LOCAL ID في مستند Issuer بـ 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | إشارة وتعريف | LOCAL ID في مستند Issuer بـ 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | إشارة وتعريف | LOCAL ID في مستند Issuer بـ 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | إشارة وتعريف | Issuer نفسه. الـ Payload هو Issuer (2/4/16 WORD) فقط، ولا يوجد معرّف هدف |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | إشارة وتعريف | إصدار واحد من مستند Issuer. Issuer + معرّف المستند 4 WORD + معرّف الإصدار 2 WORD، ولا يوجد معرّف هدف |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | إشارة وتعريف | إصدار واحد من Codec لدى Issuer. Issuer + معرّف Codec 2 WORD + معرّف الإصدار 2 WORD، ولا يوجد معرّف هدف |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | تعريف | مدخل من مفردات رموز GEUL (معرّف الرمز 0~65,535). Payload بـ 1 WORD، والمجموع 2 WORD |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | تعريف | كما سبق. معرّف الرمز 65,536~131,071 (65,536 + Payload) |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | صيغة Issuer | Issuer بـ 2 WORD ورقم Codec بـ 2 WORD. يحدد مستند Issuer التصنيف والهدف |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | صيغة Issuer | Issuer بـ 4 WORD ورقم Codec بـ 2 WORD. كما سبق |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | صيغة Issuer | Issuer بـ 16 WORD ورقم Codec بـ 2 WORD. كما سبق |

- يتألف Reference من ثلاثة أقسام. القسم 0 كيانات `0x000L~0x01FL` (علامات الموضع، ونظام 5Q)، والقسم 1 EXTERNAL `0x020L~0x03FL`، والقسم 2 متفرقات `0x040L~0x05FL` (المؤشرات، وREFERENCE-ISSUER). وReserved هو `0x003L~0x004L` و`0x01EL~0x01FL` و`0x03EL~0x03FL` و`0x045L~0x05CL`.
- حزمة الخانات الخمس (من LOCAL إلى EXTERNAL-ISSUER-16WORD) تأخذ خانة لكل عنصر بترتيب Quantifier أدناه. مثال: WIKIDATA-QID من نوع Identified هو `0x014L`، ومن نوع Generic هو `0x015L`.

### علامة الموضع (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000` و`0x0010` و`0x0020` — [علامة الموضع](slot-marker.md). لا تأتي في موضع ما إلا إذا كانت قائمة CODEC للحقل تحوي تلك الـ WORD بعينها.

| WORD | الاسم | المعنى | ويكي بيانات |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | غير مكتوب. حُذف حقل اختياري. لا يُقرَّر شيء عن العالم | لا snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | غير معروف. القيمة موجودة لكن لا يُعرف ما هي | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | لا شيء. لا توجد قيمة | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | الاسم | المعنى | مثال |
|---|---|---|---|
| `0` | Identified | كيان محدد | إيلون ماسك، كوريا الجنوبية |
| `1` | Generic | قول عام تعريفي عن النوع كله. يسمح باستثناءات. | الجندي يطيع الأوامر |
| `2` | Free-choice | أي هدف يحقق الشرط | أي جندي |
| `3` | Universal | كل هدف ينتمي إلى النطاق المعطى | كل الجنود |
| `4` | Variable | متغير الخطاب | ذلك الرجل، هذه المرأة |

- يُقرأ التكميم من الإزاحة `C` داخل القسم. في القسم 0 إذا كان `5 <= C < 30` فالتكميم هو `C % 5` والنظام هو `C / 5` (من 1 إلى 5). وفي القسم 1 إذا كان `C < 30` فالتكميم هو `C % 5` والنظام هو `6 + C / 5` (من 6 إلى 11). لا يُستخدم مع العلامات (القسم 0، `C < 3`) ولا مع القسم 2 (المؤشرات، REFERENCE-ISSUER).
- ISSUER-POINTER وDOC-POINTER وCODEC-POINTER خانة واحدة بلا تكميم. أما تكميم REFERENCE-ISSUER فيحدده مستند Codec الذي أصدره Issuer.

## Issuer {#issuer}

Issuer هو الجهة التي تعرّف المستندات والصيغ — [Issuer والنشر](issuer.md)

| الموضع | المعنى |
|---|---|
| رموز ISSUER في Reference وValue وEdge (الخانات الثلاث الأخيرة في كل نطاق) | صيغة عرّفها ذلك Issuer |
| Meta `DOC-ID` | Issuer الذي أصدر هذا المستند |
| Meta `IMPORT-DOC` | Issuer الذي أصدر المستند المجلوب |
| Reference `EXTERNAL-ISSUER-*` و`DOC-POINTER` و`CODEC-POINTER` | Issuer الذي أصدر المستند أو Codec المشار إليه (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Issuer المشار إليه نفسه (2/4/16 WORD) |

| عرض Issuer | الإصدار |
|---|---|
| 2 WORD | تسجيل لدى geul.org. Issuer اجتاز إثبات ملكية النطاق (مثل company.com). والأرقام التي يخصصها geul.org لهيئات المعايير والمؤسسات الكبرى بهذا العرض أيضًا ([جدول تخصيص 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | تسجيل لدى geul.org. Issuer سُجّل دون إثبات ملكية |
| 16 WORD | إصدار ذاتي. يُحسب من المفتاح العام دون تسجيل. ويتبع قاعدة التوليد أدناه. |

### خوارزمية توقيع Issuer ذي 16 WORD {#16-word-issuer-서명-알고리즘}

| معرّف خوارزمية التوقيع | الخوارزمية |
|---|---|
| `0x0001` | Ed25519 |
| غير ذلك | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

عائلة الرمز المباشر هي `(الرمز − 0xA0) >> 5` (الرمز هو الخانات الثلاث الأولى من TAG ID). تضم كل عائلة 32 خانة، وتساوي القسم `w >> 9` مطروحًا منه 5. الرموز المباشرة المخصصة في العائلات الخمس أدناه. و`0x135L~0x1BCL` هي Reserved (الأقسام من 10 إلى 12 هي Reserved بالكامل). لا توجد قاعدة عائلات في صيغة Issuer.

| القسم | العائلة | الرمز المباشر |
|---|---|---|
| 5 | العبارة | `0x0A0L~0x0BFL` |
| 6 | الدليل | `0x0C0L~0x0DFL` |
| 7 | التنفيذ | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | صيغة [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` هي Reserved.
- `0x1BDL~0x1BFL` (الخانات الثلاث الأخيرة في القسم 13) هي EDGE-ISSUER (انظر صيغة Edge ISSUER أدناه).

### العبارة (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | الاسم | صيغة فرعية | الوصف |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | ربط موجَّه يشير فيه Subject، وهو Reference، إلى Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | تطابق: سجلا Reference يشيران إلى الهدف نفسه |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | عدم تطابق: سجلا Reference يشيران إلى هدفين مختلفين |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | يربط Subject باسم تطابقه الآلة (`UTF8-TEXT-*`). يجب أن يكون فريدًا داخل النطاق ومطابقًا تمامًا، ولا لغة له |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | ربط اسم لغوي (label) بـ Subject. Object هو UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | ربط اسم آخر (alias) بـ Subject. التخطيط كما في LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | ربط وصف لغوي (description) بـ Subject. التخطيط كما في LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | عبارة فعلية مختصرة |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | عبارة فعلية |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | قضية بترتيب Predicate وSubject وObject مع rank. Object قيمة أو علامة UNKNOWN-VALUE أو NO-VALUE. ومعناها مجموع كل QUALIFIER يشير إلى Edge Id الخاص بها |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | شرط واحد يقيّد قضية Edge آخر. Property وTarget (Edge Id) وValue (قيمة أو علامة UNKNOWN-VALUE أو NO-VALUE). وهو جزء من القضية |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | موجودة | بنية لتمثيل رؤية العالم |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | موجودة | بنية تمثّل ترتيب العوالم والأحداث |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | موجودة | بنية المشهد لوصف خصائص السيناريو |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | نشر مستند. DOC-POINTER وتجزئة المحتوى |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | إهمال (deprecate) إصدار منشور. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | حذف إصدار منشور (شاهد قبر). DOC-POINTER وفئة السبب |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | إعلان تركيب Payload لـ Codec واحد. Kind وCodec المستهدفان |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | حقل واحد من Payload. الـ DECLARE الذي ينتمي إليه، والعرض: سجل (Length في TAG) أو قيمة خام n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | قيمة رمز واحدة لحقل القيمة الخام. الحقل وقيمة الرمز |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | Kind وCodec واحد يقبله الحقل. الحقل، وWORD الهدف (`000K KKKC CCCC LLLL`، وLLLL يعني `0000` مطابقة تامة، و`1111` حرف بدل wildcard (الخانات الـ 32 كلها في ذلك القسم)، وعلامة الموضع لا تكون إلا بهدف دقيق `0000` أو `0010` أو `0020`). حقل السجل يقبل عدة CODEC (قائمة مغلقة)، وحقل القيمة الخام يقبل واحدًا (ذلك Value بلا TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | الحزمة |
|---|---|
| `0x0A0L~0x0A7L` | الإشارة والأسماء |
| `0x0A8L~0x0AFL` | القضايا |
| `0x0B0L~0x0B7L` | البنية |
| `0x0B8L~0x0BFL` | متفرقات |

### الدليل (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | الاسم | صيغة فرعية | الوصف |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | يصل سجلًا واحدًا أو المستند كله بمصدره. Target (Edge Id في BODY، وفي HEAD يعني `0` المستند كله) وOrigin (Reference، أو ABSENT أو UNKNOWN-VALUE). تُكتب خصائص المصدر بـ TRIPLE يكون المصدر فيها Subject، وخصائص الاقتباس (تاريخ الاطلاع، الموضع، تجزئة النص الأصلي) بـ QUALIFIER يلحق بـ SOURCE. يوضع SOURCE المستند كله مع QUALIFIER الخاص به في HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- نطاق النص الأصلي، والجهة المنشئة، ودرجة الثقة، وفترة السريان لكل مادة، والسجلات القديمة، تُكتب بـ QUALIFIER، أما الإصدار الذي دخل فيه السجل أول مرة فيُحسب من سجل الإصدارات ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### التنفيذ (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | إعلان دالة. الرمز، وقائمة رموز المعاملات، ونوع الإرجاع، والجسم (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | إعلان نوع. الرمز والتركيب (قائمة رموز الحقول، وقيم التعداد، وهدف الاسم المستعار) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | تعبير ثابت. Value مضمَّن واحد |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | تعبير أحادي. عامل العملية بـ 1 WORD، والمعامَل |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | تعبير ثنائي. عامل العملية بـ 1 WORD، والمعامَل الأيسر، والمعامَل الأيمن |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | استدعاء. الدالة المستهدفة، وعدد الوسائط، والوسائط × عددها |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | الوصول إلى عضو. الهدف، ورمز الحقل |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | الوصول بالفهرس. الهدف والفهرس |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | إنشاء قيمة مركبة (قائمة، سجل). النوع، وعدد العناصر، والعناصر × عددها |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | تعبير شرطي. الشرط، والقيمة عند تحقق الشرط، والقيمة عند عدم تحققه |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | حزمة مرتبة من العبارات. عدد العبارات، والعبارات × عددها |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | إسناد. الهدف (رمز، أو MEMBER، أو INDEX)، والقيمة |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | تفرع شرطي. الشرط، وBLOCK عند تحقق الشرط، وBLOCK عند عدم تحققه (BLOCK أو IF، و0 إن لم يوجد) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | تفرع متعدد. الهدف، وعدد الفروع، و(القيمة، BLOCK) × عدد الفروع، وBLOCK الافتراضي (0 إن لم يوجد) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | تكرار شرطي. الشرط، وBLOCK الجسم |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | تكرار بالمرور. رمز العنصر، والهدف، وBLOCK الجسم |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | تحكم في التكرار. النوع بـ 1 WORD (break وcontinue)، والتكرار المستهدف |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | إرجاع. القيمة (0 إن لم توجد) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | إطلاق خطأ. قيمة الخطأ |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | معالجة الأخطاء. BLOCK الجسم، ورمز الخطأ، وBLOCK المعالجة، وBLOCK الختام (0 إن لم يوجد) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | الحزمة |
|---|---|
| `0x0E0L~0x0E7L` | الإعلان |
| `0x0E8L~0x0EFL` | التعبير |
| `0x0F0L~0x0F7L` | العبارة البرمجية |
| `0x0F8L~0x0FFL` | الخطأ |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

للتفصيل: [TOULMIN](toulmin/_index.md)

| Codec | الاسم | الوصف |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | إعلان قضية. رسم حكم بياني يحوي العقد والعلاقات |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | إعلان محمول. دالة الحكم أو صيغته، ومعيار الحكم (Spec)، وعقد الوقائع (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | إعلان معيار حكم. ثوابت وقوائم (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | إعلان ادعاء. يجعل المحمول قاعدة عامة (Warrant) داخل القضية. يمكن مهاجمته. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | إعلان دحض. يهاجم وله نتيجته الخاصة. المستوى الافتراضي Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | إعلان استثناء. يهاجم دون نتيجة خاصة به. المستوى الافتراضي Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | علاقة هجوم. حكم المهاجِم يُنقص حكم الهدف تدريجيًا. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | علاقة إقصاء. إذا كان المهاجِم Active أُخرج الهدف من التجميع حتمًا. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الثنائية. التخطيط لم يُحدَّد |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | تركيب التنفيذ. إذا كانت العقدة Active نُفّذت القضية الفرعية (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | إجراء يُنفَّذ إذا كانت العقدة Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | إجراء يُنفَّذ مرة واحدة ولو أُعيدت المحاولة |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | إجراء تعويضي لـ DO (saga). يُنفَّذ بترتيب عكسي إذا فشلت خطوة لاحقة. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | وصلة تحكم فقط دون آثار جانبية |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | نقطة دخول خارجية. تنفّذ قضية أو تحكم فيها |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | نقطة دخول بحدث أو دورية دون استدعاء خارجي |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | نتيجة الحكم لعقدة أو سجل. النتيجة (Pass وReview وFail)، وقيمة الحكم، وActivated، وExcluded، وLevel. التخطيط لم يُحدَّد. وحكم المستند كله هو Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | دليل الحكم. الموضع، والقيمة المتوقعة، والقيمة الفعلية (Fact). التخطيط لم يُحدَّد |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | الحزمة |
|---|---|
| `0x100L~0x107L` | الإعلان |
| `0x108L~0x10FL` | العلاقة |
| `0x110L~0x117L` | التنفيذ |
| `0x118L~0x11FL` | النتيجة (`0x11CL~0x11FL` هي Reserved) |

### صيغة TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

النص الأصلي والمقاطع والعقد والعلاقات المساعدة لمستند [TOULMIN](toulmin/_index.md).

| Codec | الاسم | الوصف |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | النص الأصلي المكتوب. عرض SPAN وValue من نوع UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | اسم أو سلسلة نصية |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | بداية قسم. رمز القسم |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | بداية نطاق القضية |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | نهاية نطاق القضية |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | فقرة وصفية (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. مرجع دالة |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. حزمة تنفيذ مرتبة |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. قضية ← حقل |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. عنصر التعريف ← قيمة أو نوع |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. عنصر التعريف ← حقل |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. نقطة الدخول ← قضية، تنفيذ |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. نقطة الدخول ← قضية، حكم |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. المُحفِّز ← قضية |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. المُحفِّز ← قضية (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. عقدة ← معرّف عام |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. اسم مستعار ← مسار (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. عقدة ← TEXT، كتابة الاسم |

- `0x135L~0x1BCL` هي Reserved.

### صيغة Edge ISSUER {#edge-issuer-형식}

بعد `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md) و[-4WORD](edge/0x1BEL-edge-issuer-4word.md) و[-16WORD](edge/0x1BFL-edge-issuer-16word.md)) يوضع في TAG الممتد للـ Codec كل من Issuer ورقم Codec بـ 2 WORD. لا توجد الآن صيغة Edge ISSUER مدرجة.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

رقم Value لا يدل على عائلة. تقع الرموز المباشرة في `0x060L~0x081L` دون Reserved. أما `0x082L~0x09CL` فهي Reserved، و`0x09DL~0x09FL` هي VALUE-ISSUER. أسماء العائلات (NUMERIC وDECIMAL وTIME وTEXT وBINARY) حزم موضوعية. يبدأ الزوج الزوجي/الفردي من الرمز الزوجي.

| العائلة | الرمز المباشر |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`، `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### الرموز المباشرة {#직접-코드}

| Codec | الاسم | العائلة | الوصف |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false أو true بـ 1 WORD ثابتة |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | عدد صحيح بإشارة بمتمم الاثنين بأقل عدد من WORD |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | عدد صحيح unsigned magnitude بترتيب big-endian بأقل عدد من WORD |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | scalar من نوع IEEE 754 binary16/32/64/128 بـ Payload من 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | خط عرض وخط طول للأرض (WGS 84) بـ binary64، وعدم اليقين بـ binary32 مع Reference وحدته (ABSENT = مجهول) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference جرم سماوي مع خط عرض وخط طول بـ binary64، وعدم يقين بـ binary32 مع Reference وحدته |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | amount من Value عددي (عدد صحيح، أو BINARY-FLOAT، أو عدد عشري، أو كسر)، وReference الوحدة، والحد الأدنى والأعلى. يجوز حذف الوحدة والحدود (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | كسر يحفظ الكتابة الأصلية: بسط عدد صحيح أو عشري، ومقام عدد صحيح بلا إشارة أو عشري. لا يُختصر |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` من signed exponent `E` وcoefficient `C` بمتمم الاثنين بأقل عدد من WORD |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` من signed exponent `E` وunsigned coefficient `C` بأقل عدد من WORD |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | عدد الأيام signed بالنسبة إلى `1970-01-01` في proleptic Gregorian |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | عدد unsigned من النانوثانية بعد منتصف ليل اليوم المدني |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | عدد الثواني signed منذ Unix/POSIX epoch |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | مدة منقضية بالثانية SI من نوع signed بلا epoch |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | سلسلة تاريخ EDTF (ISO 8601-2). عدد بايتات زوجي/فردي. لا تُستخدم لتاريخ يمكن كتابته بـ GREGORIAN-DATE |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | سلسلة قيمة تاريخ GEDCOM 7. تحفظ الكتابة الأصلية لتقويم آخر (مثل التقويم اليولياني). عدد بايتات زوجي/فردي |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | سلسلة بايتات UTF-8 صالحة دون الإيحاء بتطبيع. عدد بايتات زوجي |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | كما سبق. عدد بايتات فردي |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | سلسلة بايتات ASCII وفق production باسم `URI` في RFC 3986. عدد بايتات زوجي |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | كما سبق. عدد بايتات فردي |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | سلسلة بايتات ASCII لوسم لغة BCP 47 كامل بحالة أحرف canonical. عدد بايتات زوجي |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | كما سبق. عدد بايتات فردي |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | نص مرتبط بلغة. سجل Value للغة (LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE) مع بايتات UTF-8. زوجي/فردي بحسب بايتات النص |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | وسم BCP 47 مكتوبًا برقم GEUL Language Registry (Payload بـ 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID بحسب RFC 9562 ذو 128 بت بـ Payload ثابت من 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | ناتج SHA-256 بـ Payload ثابت من 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | ناتج SHA-1 بـ Payload ثابت من 10 WORD. لأغراض التعريف فقط مثل معرّف كائن git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | سلسلة بايتات مجهولة المعنى والصيغة. عدد بايتات زوجي |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | كما سبق. عدد بايتات فردي |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N بت مخزَّنة بترتيب MSB-first بعد bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | مدة منقضية بالنانوثانية من نوع signed بلا epoch |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md) و[-4WORD](value/0x09EL-value-issuer-4word.md) و[-16WORD](value/0x09FL-value-issuer-16word.md) |  | صيغة عرّفها Issuer. انظر صيغة Value ISSUER أدناه |

### صيغة Value ISSUER {#value-issuer-형식}

بعد `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md) و[-4WORD](value/0x09EL-value-issuer-4word.md) و[-16WORD](value/0x09FL-value-issuer-16word.md)) يوضع في TAG الممتد للـ Codec كل من Issuer ورقم Codec بـ 2 WORD. يوضع مستند الـ Codec تحت `codecs/` الخاص بذلك Issuer، برقم Codec الخاص بالسجل. مثال: CRC32C من IETF هو `0x00000007/codecs/0x0000C000/` ([عنوان النشر وقائمة الإصدارات](publishing.md)).

| Issuer | رقم Codec | الاسم | الوصف |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | بتات تبادل BF16 بـ Payload ثابت من 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | vector متصل من int16 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | vector متصل من uint16 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | vector متصل من int32 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | vector متصل من uint32 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | vector متصل من int64 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | vector متصل من uint64 بترتيب big-endian |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | vector متصل من IEEE 754 binary16 |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | vector متصل من BF16 |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | vector متصل من IEEE 754 binary32 |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | vector متصل من IEEE 754 binary64 |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | vector ثنائي الأبعاد من IEEE binary64 بترتيب `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | vector ثلاثي الأبعاد من IEEE binary64 بترتيب `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | vector من IEEE binary64 بترتيب `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format وrank وshape مع payload كثيف C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format وrank وshape مع payload مرزوم بترتيب low-bit-first داخل octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | قيمتان binary32 بترتيب `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | قيمتان binary64 بترتيب `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | numerator من int64 مُطبَّع وdenominator موجب من int64 |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | فترة مغلقة من binary64 حيث `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | أربع قيم binary32 بترتيب `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | ناتج BLAKE3 الافتراضي بـ Payload ثابت من 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | سلسلة بايتات ASCII من relative-ref في RFC 3986. عدد بايتات زوجي |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | كما سبق. عدد بايتات فردي |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | ناتج Castagnoli CRC-32C بـ Payload ثابت من 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | عنوان IPv4 ذو 32 بت بـ Payload ثابت من 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | عنوان IPv6 ذو 128 بت بـ Payload ثابت من 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD بـ Payload ثابت من 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD بـ Payload ثابت من 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD بـ Payload ثابت من 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID بـ Payload ثابت من 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID بـ Payload ثابت من 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID بـ Payload ثابت من 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | عدد النانوثانية signed منذ Unix/POSIX epoch |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | عنوان IEEE 802 MAC ذو 48 بت بـ Payload ثابت من 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | packed vector ثابت من 4×UNORM8 بترتيب R وG وB وA |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | packed vector ثابت من 4×UNORM8 بترتيب B وG وR وA |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | scalar من ONNX E4M3FN في octet العلوي من Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | scalar من ONNX E4M3FNUZ في octet العلوي من Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | scalar من ONNX E5M2 في octet العلوي من Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | scalar من ONNX E5M2FNUZ في octet العلوي من Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | scalar من E8M0FNU بأس unsigned فقط في octet العلوي من Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | scalar من ONNX/DLPack E2M1FN في nibble العلوي من Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | عدد ثواني SI من نوع signed منذ `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | عدد النانوثانية signed منذ TAI epoch نفسه |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | ناتج SHA-512 بـ Payload ثابت من 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | ناتج SHA3-256 بـ Payload ثابت من 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | عدد الثواني signed منذ GPS epoch |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | عدد النانوثانية signed منذ GPS epoch |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

رقم Meta لا يدل بالبتات على الفئة. تُعرف الفئة من جدول النطاقات أدناه. وفئة التحقق هي السجلات ذات `C >= 5` في القسم 15، أي `w >= 0x1E50`، وتُعرف دون كتاب الرموز. لا يوجد رمز ISSUER في Meta.

| الفئة | الرمز المباشر | ما تتناوله |
|---|---|---|
| [البنية](meta/_index.md#구조) | `0x1C0L~0x1C4L` | حدود المستند وطوله |
| [التعريف](meta/_index.md#정의) | `0x1C5L~0x1CAL` | إعلانات التفسير |
| [المصدر](meta/_index.md#출처) | `0x1CBL~0x1D0L` | من، ومتى، وأين |
| [النسب](meta/_index.md#계보) | `0x1D1L~0x1DDL` | مما نشأ وكيف |
| [السياسة](meta/_index.md#정책) | `0x1DEL~0x1E3L` | كيف يُعامَل |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | جلب مستند خارجي بـ IMPORT ID (`IMPORT-DOC`) |
| [التحقق](meta/_index.md#검증) | `0x1E5L~0x1E9L` | هل يُوثَق به |
| Reserved (للتحقق فقط) | `0x1EAL~0x1FFL` |  |

- تتصل الأرقام من `0x1C0L` دون Reserved. لا يجوز وضع Meta جديد من خارج التحقق قبل التحقق. وReserved اللاحق `0x1EAL~0x1FFL` للتحقق فقط. وإذا وُضع هنا Meta من خارج التحقق خرج من تجزئة المحتوى.

### البنية (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | بداية مستند يحدد الطول الكامل في Payload بـ 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | بداية مستند يحدد الطول الكامل في Payload بـ 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | بداية مستند يحدد الطول الكامل في Payload بـ 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. ينهي HEAD في المستند ويبدأ BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. يغلق المستند. |

### التعريف (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | إصدار مواصفة GEUL المتّبَع. الـ Payload نفسه عدد صحيح unsigned بأقصر عرض. v1 هو `0x0001` (السجل `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | الملف التعريفي المطبَّق |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | معرّف هذا المستند. Reference مضمَّن من نوع `DOC-POINTER` (Issuer، ومعرّف المستند، والإصدار 0). ومستند Codec يستخدم `CODEC-POINTER` (Issuer، ومعرّف Codec، والإصدار 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | تاريخ سريان هذا الإصدار. Value من نوع GREGORIAN-DATE أو POSIX-TIMESTAMP. وإن لم يوجد فوقت النشر |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | نهاية صلاحية هذا الإصدار (قانون مؤقت). وإن لم يوجد ففترة سريانه حتى يسري الإصدار التالي |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | اللغة الافتراضية |

### المصدر (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | المؤلف. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | مؤلف مشارك. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | وقت الإنشاء. Value من نوع TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | وقت التعديل. Value من نوع TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | الجهة المسجِّلة. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | وقت التسجيل. Value من نوع TIME (git commit date) |

- المواد الأصلية ونطاقها ووقت الحصول عليها وتجزئتها لا تُكتب في Meta بل بـ Edge الدليل [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) في HEAD (Target `0`) مع QUALIFIER الخاص به.

### النسب (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | تجزئة المحتوى للإصدار السابق مباشرة (git parent). إن لم يوجد فهو الإصدار الأول، وإن تعدد ففيه دمج (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | مشتق من سجلات أو مواد في نسب آخر. عند التثبيت على إصدار معيّن من مادة خارجية يُلحق QUALIFIER لتجزئة النص الأصلي (P4092) بـ [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) في HEAD (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | الجهة المولِّدة. إنسان، أو نموذج، أو محرك قواعد |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | طريقة التحويل. الأداة والقاعدة والإصدار |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | تجزئة المحتوى للإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | تجزئة المحتوى للإصدار المستهدف الذي أُلغي تغييره (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | تجزئة المحتوى للإصدار المستهدف الذي أُعيدت كتابته (git amend وrebase). لا يُمحى الإصدار الأصلي. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | تجزئات المحتوى للإصدارات الأصلية التي دُمجت في واحد (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | سبب التغيير. Value من نوع UTF8-LANGUAGE-TEXT، واحد لكل لغة (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | اسم ثابت يُلحق بإصدار. Value من نوع TEXT وتجزئة المحتوى (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | ملف هذا الإصدار هو diff بالنسبة إلى إصدار أساس للمستند نفسه (معرّف إصدار بـ 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | قائمة LOCAL ID (Edge Id) التي تُحذف من BODY الأساس في diff |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | LOCAL ID التالي الذي سيُخصَّص (auto increment). يوضع في HEAD لقائمة الإصدارات `versions.geul` |

### السياسة (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | الترخيص. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | نطاق الإتاحة |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | درجة الخصوصية |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | مدة الاحتفاظ |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | نطاق الموافقة وأساسها |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | قيود الاستخدام |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | يجلب مستندًا خارجيًا بـ IMPORT ID. Reference مضمَّن من نوع `DOC-POINTER` (ومستند Codec يستخدم `CODEC-POINTER`) + IMPORT ID |

### التحقق (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | الاسم | الوصف |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | إعلان معرّف خوارزمية التوقيع والمفتاح العام لـ Issuer ذاتي الإصدار |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | توقيع على هدف. التوقيع على مستند هو توقيع على تجزئة المحتوى (git signed commit وtag) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | إقرار بحق المساهمة. Reference (git `Signed-off-by`، وDCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | درجة الثقة |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | نتيجة الحكم للمستند كله. Pass وReview وFail. وعلى مستوى العقدة والسجل [TOULMIN](toulmin/_index.md) `VERDICT` (Edge `0x118L`) |

## جدول التخصيص الكامل {#전체-배정표}

227 خانة مخصصة و176 ملف md. لكل عضو في نظام 5Q وفي الأزواج الزوجية/الفردية صف واحد، وملف md هو md رأس الحزمة.

| TAG ID | معرّف Codec | الاسم | Kind | القسم | md | الحزمة |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | زوج `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | زوج `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | زوجي-فردي `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | زوجي-فردي `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | زوجي-فردي `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | زوجي-فردي `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | زوجي-فردي `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | زوجي-فردي `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | زوجي-فردي `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | زوجي-فردي `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | زوجي-فردي `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | زوجي-فردي `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | زوجي-فردي `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | زوجي-فردي `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | زوجي-فردي `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | زوجي-فردي `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
