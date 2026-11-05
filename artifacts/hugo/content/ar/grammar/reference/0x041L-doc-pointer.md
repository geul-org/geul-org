---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER هو Reference إشاري تصريحي يشير إلى إصدار واحد من مستند نشره Issuer."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DOC-POINTER` (BIND `DOC-POINTER` في مستند المواصفة) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| مستند المواصفة | `0x00000000/codecs/0x00000410/` (هدف DECLARE `0410`) |
| القسم | 2 `0010` (Reference أخرى)، الإزاحة داخل القسم C = 1 |
| Kind | Reference · التصنيف: إشاري تصريحي |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| جهة Hugo | `reference/doc-pointer.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | قيمة خام 4 WORD |  |  |
| 3 | `version` | #4 | قيمة خام 2 WORD |  |  |

DOC-POINTER هو Reference إشاري تصريحي يشير إلى إصدار واحد من مستند نشره Issuer. يكون هدفًا لنشر المستند وdeprecate وحذفه، وللإصدار المقتبَس، ولما يُكتب عن المستند.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[TAG الامتداد Length]
Issuer            2/4/16 WORD
معرّف المستند     4 WORD
معرّف الإصدار     2 WORD
```

## التفسير والصلاحية {#해석과-유효성}

- عرض Issuer هو ما يتبقى من Payload بعد طرح 6 WORD لمعرّف المستند ومعرّف الإصدار. لا تقسم الـCodec العرض. يكون invalid إذا لم يكن العرض 2 أو 4 أو 16 WORD، أو إذا كانت قيمة Issuer تتسع في عرض أضيق (الصيغة المعيارية للـIssuer).
- لا يُحذف معرّف الإصدار. فلو سُمح بحذفه لما أمكن تحديد عرض Issuer من طول Payload وحده (Issuer 4 WORD بلا إصدار وIssuer 2 WORD مع إصدار كلاهما 8 WORD).
- معرّف الإصدار `0` هو الإصدار الأحدث. يرتبط بالإصدار الجاري وقت التفسير. وسائر القيم تثبّت على ذلك الإصدار ([PUBLICATION](../edge/0x0B8L-publication.md)).
- معرّف المستند `0` هو مستند فهرس تعريف مصطلحات الـIssuer. يُشار إلى الـIssuer نفسه بـ[ISSUER-POINTER](0x040L-issuer-pointer.md).
- يحجز كل Issuer معرّفي المستند `0x0000000000000000` و`0xFFFFFFFFFFFFFFFF` ([Issuer والنشر](../issuer.md#용어-정의-문서)). يُستخدم `0xFFFFFFFFFFFFFFFF` في قائمة الـIssuer `issuers/` الخاصة بالـIssuer `0x00000000`، ولا يستخدمه Issuer آخر. وتشير PUBLICATION وDEPRECATION وTOMBSTONE في `issuers/versions.geul` بهذه القيمة إلى إصدارات القائمة ([عنوان النشر وقائمة الإصدارات](../publishing.md#목록-문서)).
- هو خانة واحدة في Codec `0x041L`. لا يوجد تكميم (Identified).
- الصيغة التي تشير إلى مستند Issuer هي DOC-POINTER وحدها. الإشارة إلى مستند بـ`EXTERNAL-ISSUER-*` (Issuer ومعرّف المستند ومعرّف الهدف `0`) أو بـ`EXTERNAL-POINTER-*` (IMPORT ID ومعرّف الهدف `0`) هي invalid.
- مواضع الاستخدام: [DOC-ID](../meta/0x1C7L-doc-id.md) و[IMPORT-DOC](../meta/0x1E4L-import-doc.md) من Meta، وPUBLICATION وDEPRECATION وTOMBSTONE في قائمة الإصدارات.
- مستند Codec لا معرّف مستند له. يُشار إلى مستند Codec وإصداره بـ[CODEC-POINTER](0x042L-codec-pointer.md).

## مثال {#예시}

المستند `0xFFFF000000000001` للـIssuer GEUL `0x00000000`.

| الإصدار | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| الأحدث (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + معرّف المستند 4 + معرّف الإصدار 2 = 9 WORD، و`LLLL=1000`. وTAG هو `0000 0100 0001 1000` = `0418`.

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [ISSUER-POINTER](0x040L-issuer-pointer.md)، [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)، [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer والنشر](../issuer.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000410/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
