---
title: "DEPRECATION (0x0B9L)"
weight: 185
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION وDEPRECATION وTOMBSTONE هي Edge عبارة تسجّل نشر إصدار الوثيقة والتوصية بإيقاف استخدامه وحذفه، وتحدد هذه الصفحة أيضاً مواصفة وثيقة قائمة الإصدارات المكتوبة بهذه الـ Edge (Codec 0x0B8L~0x0BAL)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION وDEPRECATION وTOMBSTONE هي Edge عبارة تسجّل نشر إصدار الوثيقة والتوصية بإيقاف استخدامه وحذفه، وتحدد هذه الصفحة أيضاً مواصفة وثيقة قائمة الإصدارات المكتوبة بهذه الـ Edge (Codec 0x0B8L~0x0BAL).

| البند | القيمة |
|---|---|
| الاسم | `DEPRECATION` (BIND مستند المواصفة `DEPRECATION`) |
| TAG ID | `0x0B9L` |
| Codec ID | `0x00000B90` |
| مستند المواصفة | `0x00000000/codecs/0x00000B90/` (هدف DECLARE `0B90`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 25 |
| Kind | Edge · العائلة: العبارة، الحزمة: أخرى |
| TAG WORD | `0000 1011 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | deprecate لإصدار منشور. DOC-POINTER |
| جانب Hugo | `edge/publication.md` (وهو يتناول أيضاً [PUBLICATION](0x0B8L-publication.md) و[TOMBSTONE](0x0BAL-tombstone.md)) |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | سجل | `0410` DOC-POINTER، `0420` CODEC-POINTER |  |

هذه Edge عبارة تسجّل نشر الوثيقة وإهمالها (deprecate) وحذفها، وهي مواصفة وثيقة قائمة الإصدارات المكتوبة بتلك الـ Edge. تحدد صيغة قائمة الإصدارات في [عنوان النشر وقائمة الإصدارات](../publishing.md#버전-목록).

## الرموز {#코드}

| Codec | الاسم | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id وDOC-POINTER وتجزئة المحتوى |
| `0x0B9L` | DEPRECATION | Edge Id وDOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id وDOC-POINTER وفئة السبب |

- الرموز الثلاثة مضمَّنة في المفكِّك ([الطبقة 0](../publishing.md#층)). تُفسَّر قائمة الإصدارات دون الرجوع إلى codebook.
- لا توجد صيغة فرعية (TAG خاص بالـ Codec). تُحفظ قاعدة [Edge](_index.md) كما هي: أول عنصر في Payload هو Edge Id.

## التخطيط {#레이아웃}

```
TAG WORD          Edge، Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
الوثيقة            سجل DOC-POINTER Reference (Issuer، ID الوثيقة، ID الإصدار). وفي قائمة إصدارات Codec يكون CODEC-POINTER
تجزئة المحتوى      16 WORD   (PUBLICATION)
فئة السبب          1 WORD    (TOMBSTONE)
```

| الحقل | العرض | الوصف |
|---|---|---|
| Edge Id | سجل LOCAL Reference | الرقم التسلسلي في القائمة. يُرقَّم من 1 ويُلحق تباعاً |
| الوثيقة | سجل DOC-POINTER | إصدار واحد من الوثيقة المنشورة ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). Issuer وID الوثيقة هما نفسا الوثيقة التي تتناولها القائمة. فتبيّن وثيقة القائمة ما هي قائمته حتى دون مسار. ID الإصدار هو الرقم التسلسلي داخل تلك الوثيقة (إصدار [الوثيقة](../document.md)) ولا يُستخدم `0` (الأحدث). وتستخدم قائمة إصدارات Codec [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer، Codec ID، ID الإصدار) |
| تجزئة المحتوى | 16 WORD | تجزئة محتوى ذلك الإصدار (SHA-256، تجزئة محتوى [الوثيقة](../document.md)) |
| فئة السبب | 1 WORD | رمز فئة سبب الحذف. جدول الرموز مسألة مفتوحة |

- الطول بعد DOC-POINTER ثابت لكل رمز (16 و0 و1 WORD). وإن اختلف رُفض.
- لا يوضع الزمن في السجل. فـ `RECORDED-AT` في وثيقة القائمة التي نُشر فيها السجل أول مرة هو زمن النشر والإهمال والحذف.

## وثيقة قائمة الإصدارات {#버전-목록-문서}

تواصل جهة النشر كتابة وثيقة قائمة إصدارات واحدة لكل وثيقة: `/<Issuer>/docs/<ID الوثيقة>/versions.geul` (وللـ Codec `/<Issuer>/codecs/<Codec ID>/versions.geul`، وقائمة Issuer في [الأسفل](#목록-문서의-버전-목록)). تدخل كل الإصدارات التي نشرتها تلك الجهة لتلك الوثيقة في قائمة واحدة.

```
DOC-1WORD/2WORD/4WORD     الطول الكلي
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value من نوع SHA-256-DIGEST. تجزئة محتوى وثيقة القائمة السابقة (لا يوجد إن كانت أول قائمة)
  RECORDED-AT             Value من نوع POSIX-TIMESTAMP-SECONDS. وقت إصدار هذه القائمة
  NEXT-LOCAL-ID           LOCAL ID التالي الذي سيُعيَّن (إن وُجدت إصدارات)
  SIGNATURE               توقيع جهة النشر. الهدف تجزئة محتوى وثيقة القائمة هذه
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta: [SPEC-VERSION](../meta/0x1C5L-spec-version.md) و[PARENT](../meta/0x1D1L-parent.md) و[RECORDED-AT](../meta/0x1D0L-recorded-at.md) و[NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) و[SIGNATURE](../meta/0x1E6L-signature.md).
- لا يوضع `DOC-ID` في وثيقة قائمة الإصدارات (استثناء لوثيقة القائمة، [DOC-ID](../meta/0x1C7L-doc-id.md)). فالقائمة ليست وثيقة منشورة بل سجل تابع للوثيقة. وما هي قائمته يبيّنه DOC-POINTER (ID الوثيقة) في السجل. لذلك يُعرف ما هي قائمته حتى لو استُلمت دون مسار (`hashes/`، dump).
- يجب أن تكون ID الوثيقة في السجلات كلها هي الوثيقة التي تتناولها القائمة. ويُرفض سجل وثيقة أخرى.
- لا تضع وثيقة قائمة الإصدارات IMPORT وتستخدم Codec الطبقة 0 فقط. ولا يوضع في BODY إلا PUBLICATION·DEPRECATION·TOMBSTONE. ولا يوضع BIND لاسم الوثيقة ([عنوان النشر وقائمة الإصدارات](../publishing.md#문서-이름)).
- تضع وثيقة القائمة الجديدة BODY وثيقة القائمة السابقة كما هو في المقدمة وتُلحق السجلات. لا تُعدَّل ولا تُحذف ولا يُغيَّر ترتيبها.
- توقّع جهة النشر القائمة. فنشر geul.org يوقّعه geul.org (GEUL Issuer)، والنشر الخاص يوقّعه ذلك Issuer.
- ID الوثيقة `0x0000000000000000` هي وثيقة فهرس تعريف مصطلحات Issuer ([Issuer والنشر](../issuer.md)). ويُشار إلى Issuer نفسه بـ [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## قائمة إصدارات وثيقة القائمة {#목록-문서의-버전-목록}

وثيقة القائمة هي قائمة Issuer `issuers/` واحدة ([عنوان النشر وقائمة الإصدارات](../publishing.md#목록-문서)). وقائمة Issuer أيضاً تبدأ من الإصدار 1 وتضع قائمة الإصدارات `issuers/versions.geul`. يشير السجل إلى إصدار القائمة بـ DOC-POINTER لـ ID وثيقة محجوزة (`0x00000000` و`0xFFFFFFFFFFFFFFFF` وID الإصدار).

- صيغة السجل كما سبق. لذلك يُعرف ما هي قائمته حتى لو استُلمت بـ `hashes/`.
- لا تضع وثيقة القائمة نفسها (`<ID الإصدار>.geul`) `DOC-ID` أيضاً.
- ID الوثيقة `0xFFFFFFFFFFFFFFFF` لا تُستلم في أي Issuer بعنوان `<Issuer>/docs/<ID الوثيقة>/` (404).
- `latest.geul` للقائمة اسم مستعار لا يُخزَّن. يُبحث في قائمة الإصدارات هذه عن أحدث إصدار ويُخرَج بايتاته.

## القواعد {#규칙}

- ID الإصدار في PUBLICATION تصاعدي بلا فجوات من 1. تعيّن جهة النشر ID الإصدار.
- لا تُنشر تجزئة المحتوى نفسها مرة أخرى. وإن وُجدت أُعيد ID الإصدار ذاك.
- يشير DEPRECATION·TOMBSTONE إلى ID إصدار PUBLICATION سبق ظهوره فقط. ويُرفض ما يشير إلى إصدار غير موجود.
- تُحسب حالة الإصدار بتطبيق السجلات بالتتابع. منشور ← deprecated ← محذوف. لا يُنشر الإصدار المحذوف مرة أخرى ولا يُقدَّم.
- أحدث إصدار هو أعلى ID إصدار ليس deprecated ولا محذوفاً.
- إذا بلغ ID الإصدار نهاية 2 WORD فلا تُنشر الوثيقة أكثر وتُصدر بـ ID وثيقة جديدة.

## العنوان {#주소}

```
/.well-known/geul/<Issuer>/docs/<ID الوثيقة>/versions.geul        أحدث وثيقة قائمة (متغيرة)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul        أحدث وثيقة قائمة للـ Codec (متغيرة)
/.well-known/geul/issuers/versions.geul                           أحدث قائمة إصدارات لقائمة Issuer (متغيرة)
/.well-known/geul/<Issuer>/hashes/<تجزئة المحتوى>.geul             وثيقة قائمة سابقة (ثابتة)
```

- المتغير هو عنوان أحدث قائمة. يُتحقَّق من القائمة المستلمة بالتوقيع و`RECORDED-AT` وسلسلة `PARENT`.
- تبقى وثائق القوائم السابقة كلها في `<Issuer>/hashes/`. وبتتبع سلسلة `PARENT` يمكن استرجاع القائمة في أي وقت.

## التحقق {#검증}

- يجب أن يكون في وثيقة القائمة `SIGNATURE` بمفتاح جهة النشر المحدد.
- يجب أن تكون ID الوثيقة في السجلات مساوية لـ ID الوثيقة المطلوبة.
- يجب أن تكون تجزئة محتوى القائمة السابقة المسجلة في سجل القفل ضمن سلسلة `PARENT` للقائمة الجديدة. ويجب أن يساوي BODY تلك القائمة مقدمة BODY القائمة الجديدة.
- يجب أن تساوي تجزئة محتوى الوثيقة المستلمة القيمةَ التي دوّنها PUBLICATION لـ ID الإصدار ذاك، وأن يساوي `DOC-ID` للوثيقة Issuer وID الوثيقة المطلوبين. وليس لوثيقة القائمة `DOC-ID`.

## مسائل مفتوحة {#열린-문제}

- جدول رموز فئة السبب.
- القيمة الافتراضية لخوارزمية التوقيع وتخطيط Payload الخاص بـ `SIGNATURE`.
- وقت الانتقال إلى سجل Merkle (إثبات التضمين والاتساق) وصيغته عندما تكبر القائمة.
- منع الإرجاع إلى الوراء على مستوى Issuer. ولأن القوائم تشكّل سلسلة منفصلة لكل وثيقة، فإن هجوم تقديم قائمة قديمة لوثيقة واحدة لا يُمنع إلا بسلسلة تلك الوثيقة.

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [BIND](0x0A3L-bind.md)، [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer والنشر](../issuer.md)، [عنوان النشر وقائمة الإصدارات](../publishing.md)، [الوثيقة](../document.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000B90/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B9000000000
BODY
#1 DECLARE 0x0B90
#2 FIELD #1 record
#6 CODEC #2 0x0410
#4 BIND #1 "DEPRECATION"
#5 BIND #2 "doc"
#7 CODEC #2 0x0420
```
