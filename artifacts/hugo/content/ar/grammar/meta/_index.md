---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta سجلات عن المستند لا عن العالم. تنقسم إلى سبع فئات: البنية والتعريف والمصدر والنسب والتحقق والسياسة وIMPORT، وتوضع في HEAD المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta سجلات عن المستند لا عن محتوى العالم. ما عدا سجلات بنية المستند (DOC وBODY وEND) توضع كلها في HEAD المستند. ويأتي في HEAD إلى جانب Meta أيضاً Edge الدليل [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) للمستند كله وQUALIFIER الخاصة به.

## التخطيط

```
TAG WORD          0001 1LLL LCCC CCCC
[Length ممتد TAG]
Payload           قيمة خام أو سجل Value أو Reference مضمّن
```

- لا توجد صيغ Issuer في Meta. فـ Meta مواصفة مشتركة يتبعها كل Issuer ولا يعرّفها إلا GEUL.
- `LLLL` هو العدد الكلي لـ WORD شاملاً TAG WORD ناقص 1. وCodec غير المذكور في الجدول محجوز.

## صيغة Payload

| الصيغة | متى | مثال |
|---|---|---|
| قيمة خام | عندما تتحدد صيغة واحدة. ولا تعتمد على Codec سجل آخر | الطول في `DOC-*` و`SPEC-VERSION` و`ISSUER-KEY` |
| Value مضمّنة | عند الاختيار بين عدة صيغ. يدل TAG الخاص بـ Value على الصيغة | `PROFILE` و`EFFECTIVE-*` والوقت وتجزئة المحتوى |
| Reference مضمّن | عند الإشارة إلى هدف مثل شخص أو منظمة أو أداة أو مستند | `DOC-ID` و`AUTHOR` و`CO-AUTHOR` و`RECORDED-BY` و`SIGNED-OFF` وموقِّع `SIGNATURE` |
| لا شيء | علامة من 1 WORD | `BODY` و`END` |

- السجلات المضمّنة ليست سجلات مستقلة بل تتبع ذلك Meta. يجد كل منها حدوده بـ Length الخاص به، ويجب أن يتطابق الموضع بعد قراءة آخر سجل مع نهاية Meta تماماً.
- كون Meta يوضع منه واحد فقط في المستند أو عدة يحدده "العدد" في وثيقة كل Codec.

## الفئات

أعلى 3 بتات في Codec هي الفئة.

| أعلى 3 بتات | الفئة | الرمز المباشر | ما تتناوله |
|---|---|---|---|
| `000` | البنية | `0x00`~`0x0F` | حدود المستند وطوله |
| `001` | التعريف | `0x10`~`0x1F` | تصريحات التفسير |
| `010` | المصدر | `0x20`~`0x2F` | من ومتى وأين |
| `011` | النسب | `0x30`~`0x3F` | مم جاء وكيف |
| `100` | التحقق | `0x40`~`0x4F` | هل يمكن الوثوق به |
| `101` | السياسة | `0x50`~`0x5F` | كيف يُعامَل |
| `110` | IMPORT | `0x60`~`0x6F` | استيراد مستند خارجي |
| `111` | محجوز | `0x70`~`0x7F` | |

- **Meta اللازم للتفسير**: البنية والتعريف وIMPORT. إذا حُذفت تعذّرت قراءة السجلات أو تغيّر تفسيرها. ويجب أن يعالجها كل مفكك. وهذه الـ Codec من **codebook النواة في GEUL**.
- **Meta الذي لا يغيّر التفسير**: المصدر والنسب والتحقق والسياسة. إذا حُذفت بقي محتوى الوصف كما هو. ولا تضيع إلا مواد الحكم على الثقة وعلى المعاملة.
- الأدلة لا تُكتب بـ Meta بل بـ Edge الدليل [SOURCE](/ar/grammar/edge/source/) وQUALIFIER. ودليل السجلات المفردة في BODY، ومصدر المستند كله يوضع في HEAD بـ SOURCE ذي Target `0` ([المستند](/ar/grammar/document/#head-وbody)).

## البنية

وثيقة الحزمة: [Meta — البنية](/ar/grammar/meta/structure/)

| Codec | الاسم | المعنى |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/ar/grammar/meta/structure/doc/) | يفتح المستند بتحديد الطول الكلي |
| `0x0E` | [BODY](/ar/grammar/meta/structure/body/) | ينهي HEAD ويفتح BODY |
| `0x0F` | [END](/ar/grammar/meta/structure/end/) | يغلق المستند |

القواعد التفصيلية في [المستند](/ar/grammar/document/).

## التعريف

وثيقة الحزمة: [Meta — التعريف](/ar/grammar/meta/declaration/)

| Codec | الاسم | المعنى |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ar/grammar/meta/declaration/spec-version/) | إصدار المواصفة المتبع. عدد صحيح واحد |
| `0x11` | [PROFILE](/ar/grammar/meta/declaration/profile/) | الـ profile المطبَّق |
| `0x12` | [DOC-ID](/ar/grammar/meta/declaration/doc-id/) | معرّف هذا المستند. DOC-POINTER يشير إلى نفسه (الإصدار 0) |
| `0x13` | [EFFECTIVE-FROM](/ar/grammar/meta/declaration/effective-from/) | تاريخ سريان هذا الإصدار. فإن غاب فوقت النشر |
| `0x14` | [EFFECTIVE-UNTIL](/ar/grammar/meta/declaration/effective-until/) | نهاية مدة سريان هذا الإصدار (قانون مؤقت). فإن غاب فحتى سريان الإصدار التالي |
| `0x16` | [DEFAULT-LANGUAGE](/ar/grammar/meta/declaration/default-language/) | اللغة الافتراضية |

- الاسم المستخدم في عنوان المستند لا يوضع في Meta. بل يربطه فهرس أسماء Issuer `documents.geul` بـ BIND ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#اسم-المستند)). والعنوان الذي يقرؤه الإنسان يُربط بـ LABEL في BODY.

## المصدر

وثيقة الحزمة: [Meta — المصدر](/ar/grammar/meta/provenance/)

| Codec | الاسم | المعنى |
|---|---|---|
| `0x20` | [AUTHOR](/ar/grammar/meta/provenance/author/) | المؤلف (Reference) |
| `0x21` | [CO-AUTHOR](/ar/grammar/meta/provenance/co-author/) | مؤلف مشارك |
| `0x22` | [CREATED-AT](/ar/grammar/meta/provenance/created-at/) | وقت التأليف |
| `0x23` | [MODIFIED-AT](/ar/grammar/meta/provenance/modified-at/) | وقت التعديل |
| `0x24` | [RECORDED-BY](/ar/grammar/meta/provenance/recorded-by/) | الجهة التي سجّلت |
| `0x25` | [RECORDED-AT](/ar/grammar/meta/provenance/recorded-at/) | وقت التسجيل |
| `0x26`~`0x2F` | Reserved | |

- المادة المصدرية لا تُكتب بـ Meta بل بـ Edge الدليل [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) في HEAD (Target `0`)، ونطاق النص الأصلي ووقت الحصول وتجزئة النص الأصلي تُكتب بـ QUALIFIER تُلحق بذلك SOURCE.

## النسب

وثيقة الحزمة: [Meta — النسب](/ar/grammar/meta/lineage/)

النسب يتبع نموذج commit في git. والوحدة المقابلة لـ commit هي المستند.

| Codec | الاسم | المعنى |
|---|---|---|
| `0x30` | [PARENT](/ar/grammar/meta/lineage/parent/) | تجزئة محتوى الإصدار السابق. إن كانت عدة فهو دمج |
| `0x31` | [DERIVED-FROM](/ar/grammar/meta/lineage/derived-from/) | مشتق من مادة في نسب آخر |
| `0x32` | [GENERATED-BY](/ar/grammar/meta/lineage/generated-by/) | الجهة المولِّدة (إنسان أو نموذج أو محرك قواعد) |
| `0x33` | [TRANSFORMED-BY](/ar/grammar/meta/lineage/transformed-by/) | أداة التحويل وإصدار مصدرها (digest الـ commit) |
| `0x34` | [CHERRY-PICKED-FROM](/ar/grammar/meta/lineage/cherry-picked-from/) | الإصدار الأصلي للتغيير المنقول |
| `0x35` | [REVERTS](/ar/grammar/meta/lineage/reverts/) | الإصدار الهدف الذي جرى التراجع عنه |
| `0x36` | [REPLACES](/ar/grammar/meta/lineage/replaces/) | الإصدار الهدف الذي أُعيدت كتابته. ولا يُحذف الإصدار الأصلي |
| `0x37` | [SQUASHED-FROM](/ar/grammar/meta/lineage/squashed-from/) | الإصدارات الأصلية التي دُمجت في واحد |
| `0x38` | [MESSAGE](/ar/grammar/meta/lineage/message/) | سبب التغيير. واحد لكل لغة |
| `0x39` | [TAG](/ar/grammar/meta/lineage/tag/) | اسم ثابت يُلحق بإصدار |
| `0x3A` | [DELTA-BASE](/ar/grammar/meta/lineage/delta-base/) | هذا الملف diff بالنسبة إلى إصدار أساس |
| `0x3B` | [DELTA-REMOVE](/ar/grammar/meta/lineage/delta-remove/) | قائمة LOCAL ID التي تُحذف في diff |
| `0x3C` | [NEXT-LOCAL-ID](/ar/grammar/meta/lineage/next-local-id/) | LOCAL ID التالي الذي سيُخصَّص. يوضع في مستند قائمة الإصدارات |

- لا يُمحى السجل التاريخي. وما صُحح يصدر في إصدار جديد.
- المؤشرات المتغيرة مثل branch لا توضع في المستند. بل يديرها المستودع والفهرس.

## التحقق

وثيقة الحزمة: [Meta — التحقق](/ar/grammar/meta/verification/)

| Codec | الاسم | المعنى |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ar/grammar/meta/verification/issuer-key/) | خوارزمية التوقيع والمفتاح العام لـ Issuer ذاتي الإصدار |
| `0x41` | [SIGNATURE](/ar/grammar/meta/verification/signature/) | توقيع على تجزئة المحتوى. الخوارزمية والموقِّع والتوقيع |
| `0x42` | [SIGNED-OFF](/ar/grammar/meta/verification/signed-off/) | إقرار بحق المساهمة |
| `0x43` | [CONFIDENCE](/ar/grammar/meta/verification/confidence/) | الموثوقية |
| `0x44` | [VERDICT](/ar/grammar/meta/verification/verdict/) | نتيجة الحكم على المستند كله (Pass وReview وFail) |

- تُستثنى فئة التحقق من حساب تجزئة المحتوى. لذلك لا تتغير تجزئة المحتوى بوضع التوقيع داخل المستند ولا بإضافة عدة توقيعات.

## السياسة

وثيقة الحزمة: [Meta — السياسة](/ar/grammar/meta/policy/)

| Codec | الاسم | المعنى |
|---|---|---|
| `0x50` | [LICENSE](/ar/grammar/meta/policy/license/) | الترخيص |
| `0x51` | [ACCESS](/ar/grammar/meta/policy/access/) | نطاق الإتاحة |
| `0x52` | [PRIVACY](/ar/grammar/meta/policy/privacy/) | درجة الخصوصية |
| `0x53` | [RETENTION](/ar/grammar/meta/policy/retention/) | مدة الاحتفاظ |
| `0x54` | [CONSENT](/ar/grammar/meta/policy/consent/) | نطاق الموافقة وأساسها |
| `0x55` | [USAGE](/ar/grammar/meta/policy/usage/) | قيود الاستخدام |

- السياسة لا تغيّر التفسير بل تحدد طريقة المعاملة.

## IMPORT

وثيقة الحزمة: [Meta — IMPORT](/ar/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length ممتد TAG]
المستند           سجل DOC-POINTER (Issuer ومعرّف المستند ومعرّف الإصدار)
IMPORT ID         الباقي. عدد صحيح بأقصر عرض
```

- لا يُستخدم إلا [IMPORT-DOC](/ar/grammar/meta/import/import-doc/) (`0x60`). فـ IMPORT يستورد المستندات فقط. ويُشار إلى الهدف داخل المستند المستورد في BODY بـ `EXTERNAL-POINTER-*` (IMPORT ID وLOCAL ID).
- إذا كُتب معرّف الإصدار ارتبط بذلك الإصدار، وإذا كان `0` ارتبط بأحدث إصدار وقت التفسير. والمستند المنشور يكتب الإصدار.
- لا يُخصَّص IMPORT ID نفسه مرتين في مستند واحد.
- لا يُستورد HEAD المستند المستورد. ويُفسَّر هدف ذلك المستند بتصريحات ذلك المستند.

مثال: استيراد أحدث إصدار من مستند Issuer `0x0001` ورقمه `0x0000000000000002` بـ IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
