---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference هو سجل يشير إلى هدف."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference هو سجل يشير إلى هدف. قد يكون الهدف كيانًا أو مفهومًا أو مستندًا أو Edge آخر. يُشار إليه بمعرّف لا باسم.

## التخطيط {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      الأقسام 0~2 (0x000L~0x05FL)
[TAG الامتداد Length]
[IMPORT ID]       عند EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          عند EXTERNAL-ISSUER (2/4/16 WORD)
[معرّف المستند]   عند EXTERNAL-ISSUER (4 WORD)
معرّف الهدف       كل ما تبقى
```

- `LLLL` هو عدد WORD الكلي شاملًا TAG WORD ناقص 1 ([السجل وTAG WORD](../record.md)).
- Reference هو 96 خانة في الأقسام 0~2 (`w < 0x0600`). القسم 0 كيانات `0x000L~0x01FL`، والقسم 1 EXTERNAL `0x020L~0x03FL`، والقسم 2 أخرى `0x040L~0x05FL`.
- تُكتب الـCodec جدول رموز (الجدول أدناه). في منظومة 5Q يجمع الرمز الواحد منظومة التعريف والتكميم. وتكميم REFERENCE-ISSUER يحدده مستند الـIssuer.
- معرّف الهدف عدد صحيح بلا إشارة big-endian ويُكتب **بأقصر عرض**. العرض هو ما يتبقى من Length بعد طرح الحقول السابقة.
- يُكتب معرّف الهدف `0` بـWORD واحد `0x0000`. وفيما عدا ذلك لا يُسبق بـWORD `0x0000`.
- إذا تساوت القيمة الصحيحة فالمعرّف واحد. والعرض ليس جزءًا من المعرّف.
- تستخدم كل الـCodec أقصر عرض. ولا تثبّت Codec عرض معرّف الهدف.
- [ISSUER-POINTER](0x040L-issuer-pointer.md) و[DOC-POINTER](0x041L-doc-pointer.md) و[CODEC-POINTER](0x042L-codec-pointer.md) لا تتبع هذا التخطيط. لا معرّف هدف فيها، وفيها Issuer (ومعرّف المستند وCodec ID ومعرّف الإصدار) فقط.
- [REFERENCE-ISSUER](#reference-issuer) أيضًا لا يتبع هذا التخطيط. هو TAG وIssuer ورقم Codec بـ2 WORD وPayload. ويحدد Payload مستندُ Codec الذي أصدره الـIssuer.

## Codec {#codec}

| TAG ID | الاسم | التصنيف | الهدف |
|---|---|---|---|
| `0x000L~0x002L` | [علامة موضع](../slot-marker.md) | علامة موضع | لا يشير إلى هدف. تُستخدم علامة WORD واحد فقط: `0x0000` ABSENT (عدم الكتابة)، `0x0010` UNKNOWN-VALUE (غير معروف)، `0x0020` NO-VALUE (لا شيء) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | تصريح | معرّف أصدره هذا المستند |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | تصريح | كيان يصدره geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | تصريح | معرّف محاذى دلاليًا تحمل بتاته المعنى |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | تصريح | عنصر في ويكي بيانات. العدد الصحيح بعد `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | تصريح | خاصية في ويكي بيانات. العدد الصحيح بعد `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | إشاري | LOCAL ID في مستند استُورد بـIMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | إشاري تصريحي | LOCAL ID في مستند نشره Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | إشاري تصريحي | الـIssuer نفسه |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | إشاري تصريحي | إصدار واحد من مستند نشره Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | إشاري تصريحي | إصدار واحد من Codec نشره Issuer |
| `0x043L~0x044L` | [TOKEN-0·TOKEN-1](0x043L-token.md) | تصريح | مدخل من مفردات رموز GEUL. معرّف الرمز 1 WORD، والمجموع 2 WORD |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | صيغة Issuer | يعرّفها الـIssuer. ويحدد مستند الـIssuer التصنيف وخانة معرّف الهدف |

- الـReserved هي `0x003L~0x004L` و`0x01EL~0x01FL` (القسم 0) و`0x03EL~0x03FL` (القسم 1) و`0x045L~0x05CL` (القسم 2، موضع منظومات تعريف جديدة).
- يُقرأ رقم المنظومة من الإزاحة داخل القسم `C`. في القسم 0 إذا كان `5 <= C < 30` فالمنظومة `C / 5` (1~5)، وفي القسم 1 إذا كان `C < 30` فالمنظومة `6 + C / 5` (6~11).

| المنظومة | الاسم | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **التصريح** يحدد الهدف مباشرة بمعرّف تحدده الجهة المُصدِرة.
- **الإشاري** يشير إلى LOCAL داخل مستند استُورد بـIMPORT ID. ويتحدد عرض IMPORT ID بالمنظومة: إذا كان (المنظومة − 6) يساوي 0 أو 1 أو 2 فالعرض 1 أو 2 أو 4 WORD.
- **الإشاري التصريحي** يشير بسجل واحد دون IMPORT إلى مستند آخر وإلى هدف فيه. وعرض Issuer في EXTERNAL-ISSUER هو 2 أو 4 أو 16 WORD إذا كان (المنظومة − 9) يساوي 0 أو 1 أو 2.
- `0x020L~0x03DL` (القسم 1، المنظومات 6~11) تشير إلى LOCAL في مستند آخر. أما منظومات التصريح الأخرى فتحدد الهدف مباشرة (LOCAL هذا المستند، والمعرّفات المصدَرة). والمؤشرات (القسم 2، `0x040L~0x042L`) تشير إلى الـIssuer والمستند والـCodec أنفسها. REFERENCE-ISSUER خارج هذا التقسيم.
- `0x000L~0x002L` رموز مخصصة لعلامات الموضع ولا تُستخدم بوصفها Reference يشير إلى هدف. WORD `0x0000` و`0x0010` و`0x0020` (L يساوي 0، أي WORD واحد) هي [علامة موضع](../slot-marker.md) (`0x0000` ABSENT، `0x0010` UNKNOWN-VALUE، `0x0020` NO-VALUE). لا تصح العلامة إلا في موضع حقل سجل جعل ذلك الـWORD هدف CODEC بالضبط. لا يقبلها المحرف الشامل ولا الحقل بلا CODEC، وتكون invalid في موضع سجل HEAD وBODY وموضع Edge Id. وصيغة TAG التي فيها Payload (L ≥ 1) عند C من 0 إلى 2 هي Reserved.
- الرموز المباشرة والمنشورات التي يقدمها geul.org وحدها بترخيص CC0. ولا تُجعل منظومة تعريف غير CC0 (مثل WordNet) رمزًا مباشرًا. وترخيص صيغ Issuer يحدده ذلك الـIssuer.

### TAG الشائعة {#자주-쓰는-tag}

| السجل | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| ويكي بيانات Q5 (إنسان) | `0141 0005` |
| ويكي بيانات Q691283 | `0142 000A 8C53` |
| ويكي بيانات P31 (instance of) | `0191 001F` |
| علامة الموضع ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL هو معرّف أصدره هذا المستند.

- **فريد.** في المستند الواحد لا يشير LOCAL ID واحد إلا إلى هدف واحد.
- **لا يُخصَّص 0.** تُخصَّص معرّفات الأهداف من 1.
- **يوصى بالتخصيص بالتزايد** (auto increment). ولا معنى لكبر المعرّف أو صغره.
- يشير إلى الهدف نفسه عبر الإصدارات. ولا يُعاد استخدام معرّف محذوف (تنقيح [المستند](../document.md)).
- ولكي يمكن الإشارة إليه من خارج المستند يجب أن يكون في المستند `DOC-ID`.
- LOCAL ID مختلفان لا يعنيان هدفين مختلفين في الواقع. إذا كانا واحدًا يُوصَلان بـEdge `SAME-NODE`، وإذا كانا مختلفين فبـEdge `DIFFERENT-NODE`.

### Edge Id {#edge-id}

يضع كل Edge في Payload الخاص به Reference من نوع LOCAL عنصرًا أول. ذلك LOCAL ID هو **Edge Id**.

- يمكن قراءة Edge Id دون معرفة الكتاب الرمزي (codebook) للـCodec.
- LOCAL في موضع Edge Id هو تصريح، وLOCAL في سائر مواضع الـEdge هو ذِكر.
- لا يُستخدم لتصريح Edge Id إلا Identified (`0x005L`).
- يُشار إلى Edge آخر بـEdge Id. ويُشار إلى Edge هذا المستند بـLOCAL، وإلى Edge مستند آخر بـReference إشاري.

## الإشارة إلى مستند آخر {#다른-문서-가리키기}

| ماذا | كيف |
|---|---|
| الـIssuer نفسه | `ISSUER-POINTER` (Issuer) |
| إصدار واحد من مستند | `DOC-POINTER` (Issuer، معرّف المستند 4 WORD، معرّف الإصدار 2 WORD). الإصدار `0` هو الأحدث |
| إصدار واحد من Codec | `CODEC-POINTER` (Issuer، Codec ID بـ2 WORD، معرّف الإصدار 2 WORD). الإصدار `0` هو الأحدث |
| هدف داخل مستند منشور (الأحدث) | `EXTERNAL-ISSUER-*` (Issuer، معرّف المستند، LOCAL ID) |
| هدف داخل مستند مستورد (إصدار مثبَّت) | يُخصَّص IMPORT ID بـ`IMPORT-DOC` من Meta ثم `EXTERNAL-POINTER-*` (IMPORT ID، LOCAL ID) |

- يُشار إلى المستند نفسه، داخل المستند أو خارجه، بـDOC-POINTER وحده. ويشير المستند إلى نفسه بـDOC-POINTER لـ`DOC-ID` الخاص به. ومستند Codec استثناء فيُشار إليه بـCODEC-POINTER (و`DOC-ID` أيضًا هو CODEC-POINTER).
- يتبع EXTERNAL-ISSUER أحدث إصدار. ولتثبيت الإصدار يُستخدم IMPORT.
- يُكتب Issuer بأقصر عرض تتسع له القيمة (2/4/16 WORD) وتُختار Codec بذلك العرض. وكذلك في EXTERNAL-ISSUER وREFERENCE-ISSUER.
- يُحجز معرّف المستند `0` في كل Issuer لمستند فهرس المصطلحات التي عرّفها ذلك الـIssuer (الأدوات والأدوار وغيرها). ويُوصى بمستند الفهرس لكل Issuer وليس إلزاميًا ([Issuer والنشر](../issuer.md#용어-정의-문서)).

مثال: LOCAL 7 داخل المستند `0x0000000000000002` للـIssuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | الاسم | المعنى | مثال |
|---|---|---|---|
| `0` | Identified | كائن محدَّد الهوية | إيلون ماسك، كوريا الجنوبية |
| `1` | Generic | تقرير عام عن النوع كله. يسمح بالاستثناءات | الجندي يطيع الأوامر |
| `2` | Free-choice | أي هدف يحقق الشرط | أي جندي |
| `3` | Universal | كل الأهداف داخل النطاق | كل الجنود |
| `4` | Variable | متغير خطابي | ذلك الشخص، هذه المرأة |

- **لا يُقرأ التكميم إلا في منظومات 5Q (المنظومات 1~11).** يكون التكميم `C % 5` بالإزاحة داخل القسم `C`، حيث `5 <= C < 30` في القسم 0 و`C < 30` في القسم 1. ولأن القسم 32 خانة فإن قسمة موضع الـCodec ذي 9 بتات (`w >> 4`) على 5 تُخلّ بالقسم 1. وليس للعلامات (القسم 0، `C < 3`) ولا للقسم 2 (المؤشرات وREFERENCE-ISSUER) تكميم. والعلامة `0x0010` UNKNOWN-VALUE ليست Generic. وتكميم REFERENCE-ISSUER يحدده مستند Codec الذي أصدره الـIssuer.
- Generic لا يعني، خلافًا لـUniversal، أنه ينطبق بلا استثناء على كل هدف فرد. يمكن كتابة العبارات التعريفية مثل «ما الجندي» بـGeneric. وإذا لزم تعريف صارم للمفهوم أو التصنيف يُفصَّل بعلاقة مستقلة.
- نطاق التكميم ونفيه لا يحددهما Reference بل الـEdge الذي يستخدمه.
- **Variable** هو هدف في الخطاب معروف نوعه لكنه لم يُحدَّد بعد.
  - المتغير المسمّى يُلحَق فيه Variable بـLOCAL. إذا كان LOCAL ID واحدًا فهو المتغير نفسه. ويُوصل النوع بـEdge.
  - المتغير المجهول يُلحَق فيه Variable بـCodec التصريح الذي يشير إلى النوع (GEUL وWIKIDATA-*) (مثل «رئيس» في ويكي بيانات + Variable). لا تُتتبَّع الإحالة المشتركة ولا يمكن الإشارة إليه ثانية. والمتغيران المجهولان لا يُعدّان متغيرًا واحدًا.
  - إذا تأكد الهدف لاحقًا يُوصل المتغير بذلك الهدف بـ`SAME-NODE`. فتُفسَّر كل العبارات التي تشير إلى المتغير نفسه معًا بذلك الهدف.
  - المتغيران المختلفان لا يعنيان هدفين مختلفين في الواقع. إذا كانا واحدًا يُوصَلان بـ`SAME-NODE`، وإذا كانا مختلفين فبـ`DIFFERENT-NODE`.
  - Variable في Codec الإشارة الخارجية (EXTERNAL-POINTER-* وEXTERNAL-ISSUER-*) هو متغير LOCAL في المستند المُشار إليه.
  - مثال: في «ألقى الرئيس خطابًا» إذا لم تتحدد الشخصية يُستخدم Variable «رئيس». ولكي يُذكر ثانية يُوضع LOCAL Variable ويُوصل النوع «رئيس» بـEdge. وإذا تأكد لاحقًا أنه أوباما يُوصل ذلك المتغير بأوباما Identified بـ`SAME-NODE`. فتُفسَّر كل العبارات التي تشير إلى المتغير نفسه معًا بأوباما.
- مثال: استخدام Q5 (إنسان) من ويكي بيانات بـGeneric هو `0151 0005` («الإنسان …»).

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER هو صيغة Reference يعرّفها Issuer. وهو الخانات الثلاث الأخيرة في نطاق Reference. تخطيطه كتخطيط ISSUER في Value وEdge ([السجل وTAG WORD](../record.md#issuer-형식-레코드)).

### التخطيط {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = عرض Issuer: 01 2, 10 4, 11 16 WORD)
[TAG الامتداد Length]
Issuer            2/4/16 WORD (تحدد الـCodec العرض)
رقم Codec         2 WORD. يعرّفه الـIssuer
Payload           يحدده مستند Codec الذي أصدره الـIssuer
```

| Codec | الاسم | عرض Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- لكل رمز صفحة: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)، [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)، [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- مستند Codec الخاص بالـIssuer GEUL واحد لكل رمز ويحتوي ثلاثة FIELD: Issuer (2·4·16 WORD) ورقم Codec (2 WORD) وPayload (تحدده Codec الـIssuer).

### التفسير والصلاحية {#해석과-유효성}

- لا يعرف GEUL من Payload إلا حدوده بـLength. ولا يُفسَّر Payload دون الكتاب الرمزي (codebook) للـCodec.
- معنى رقم Codec وتكميمه يحددهما الـIssuer. وما يُشار إليه يحدده كذلك مستند Codec الذي أصدره الـIssuer.
- لا تُطبَّق قواعد Reference المشتركة: أقصر عرض لمعرّف الهدف، وكتابة معرّف الهدف `0` بـWORD واحد، وQuantifier، وقراءة التكميم والمنظومة من الإزاحة داخل القسم، وتقسيم التصريح والإشارة، وما يُشار إليه.
- رقم Codec بـ2 WORD كما في ISSUER في Value وEdge. وإذا لم تكفِ الأرقام يُطلب Issuer آخر.
- المفكّك الذي لا يعرف الصيغة يعرف Kind وLength وIssuer ورقم Codec ثم يتخطى بـLength.
- ترخيص صيغ Issuer يحدده ذلك الـIssuer ([Issuer والنشر](../issuer.md#라이선스)).

### صفحات ذات صلة {#관련-페이지}

- [السجل وTAG WORD](../record.md)، [Issuer والنشر](../issuer.md)
