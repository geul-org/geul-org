---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER هو Reference إشاري تصريحي يشير إلى إصدار واحد من مستند Codec نشره Issuer."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER هو Reference إشاري تصريحي يشير إلى إصدار واحد من مستند Codec نشره Issuer. مستند Codec لا معرّف مستند له، ويشير إلى نفسه وإلى إصداره بـCODEC-POINTER.

| البند | القيمة |
|---|---|
| الاسم | `CODEC-POINTER` (BIND `CODEC-POINTER` في مستند المواصفة) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| مستند المواصفة | `0x00000000/codecs/0x00000420/` (هدف DECLARE `0420`) |
| القسم | 2 `0010` (Reference أخرى)، الإزاحة داخل القسم C = 2 |
| Kind | Reference · التصنيف: إشاري تصريحي |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إصدار واحد من Codec خاصة بـIssuer. Issuer + Codec ID بـ2 WORD + معرّف الإصدار بـ2 WORD، ولا معرّف هدف |
| جهة Hugo | `reference/codec-pointer.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | قيمة خام 2 WORD |  |  |
| 3 | `version` | #4 | قيمة خام 2 WORD |  |  |

## التخطيط {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[TAG الامتداد Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
معرّف الإصدار     2 WORD
```

## التفسير والصلاحية {#해석과-유효성}

- عرض Issuer هو ما يتبقى من Payload بعد طرح 4 WORD لـCodec ID ومعرّف الإصدار. يكون Payload واحدًا من 6 أو 8 أو 20 WORD، وأي طول آخر invalid. ويكون invalid إذا كانت قيمة Issuer تتسع في عرض أضيق (الصيغة المعيارية للـIssuer).
- إذا كان Issuer 16 WORD فالإجمالي 21 WORD فيُضاف WORD واحد من امتداد Length.
- Codec ID بطول 32 بتًا. وCodec ID لرمز GEUL المباشر هو TAG WORD ذلك الرمز (L=0) مكتوبًا في 32 بتًا (TRIPLE `0x0AAL` → `0x00000AA0`). أما Codec ID لـCodec خاصة بـIssuer فهو رقم Codec في السجل، ويحدده الـIssuer دون تداخل داخل `codecs/` الخاص به بصرف النظر عن Kind ([عنوان النشر وقائمة الإصدارات](../publishing.md#id-표기)).
- معرّف الإصدار `0` هو الإصدار الأحدث. وسائر القيم تثبّت على ذلك الإصدار.
- هو خانة واحدة في Codec `0x042L`. لا يوجد تكميم (Identified). ولأنه في القسم 2 فلا يُقرأ على أنه تكميم أو منظومة.
- مواضع الاستخدام: [DOC-ID](../meta/0x1C7L-doc-id.md) من Meta في مستند Codec، و[PUBLICATION](../edge/0x0B8L-publication.md) وDEPRECATION وTOMBSTONE في قائمة إصدارات Codec، و[IMPORT-DOC](../meta/0x1E4L-import-doc.md) الذي يستورد مستند Codec. يحل في هذه المواضع محل DOC-POINTER.
- عنوان النشر هو `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<معرّف الإصدار>.geul` ([عنوان النشر وقائمة الإصدارات](../publishing.md#공표-주소)).

## مثال {#예시}

Codec TRIPLE للـIssuer GEUL `0x00000000` (Codec ID `0x00000AA0`).

| الإصدار | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| الأحدث (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + معرّف الإصدار 2 = 7 WORD، و`LLLL=0110`. وTAG هو `0000 0100 0010 0110` = `0426`.

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [DOC-POINTER](0x041L-doc-pointer.md)، [ISSUER-POINTER](0x040L-issuer-pointer.md)، [مستند Codec](../codec-spec.md)
- [عنوان النشر وقائمة الإصدارات](../publishing.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000420/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
