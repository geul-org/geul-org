---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER هو Reference إشاري تصريحي يشير إلى الـIssuer نفسه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `ISSUER-POINTER` (BIND `ISSUER-POINTER` في مستند المواصفة) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| مستند المواصفة | `0x00000000/codecs/0x00000400/` (هدف DECLARE `0400`) |
| القسم | 2 `0010` (Reference أخرى)، الإزاحة داخل القسم C = 0 |
| Kind | Reference · التصنيف: إشاري تصريحي |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| جهة Hugo | `reference/issuer-pointer.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |

ISSUER-POINTER هو Reference إشاري تصريحي يشير إلى الـIssuer نفسه. يكون هدفًا لـ`BIND` اسم الـIssuer، و`LABEL`، وEdge الحكم.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[TAG الامتداد Length]
Issuer            2/4/16 WORD
```

- عرض Issuer هو Payload كله. لا تقسم الـCodec العرض. يكون invalid إذا لم يكن العرض 2 أو 4 أو 16 WORD، أو إذا كانت قيمة Issuer تتسع في عرض أضيق (الصيغة المعيارية للـIssuer).
- إذا كان Issuer 16 WORD فالإجمالي 17 WORD فيُضاف WORD واحد من امتداد Length.
- هو خانة واحدة في Codec `0x040L`. لا يوجد تكميم (Identified).
- تتبع قيمة Issuer تخصيص [Issuer](../issuer.md).
- الاستخدام: BIND Subject في قائمة الـIssuer `issuers/` ([عنوان النشر وقائمة الإصدارات](../publishing.md#issuer-목록))، وLABEL اسم عرض الـIssuer، والحكم على الـIssuer، والموقِّع، وسائر المواضع التي يكون الـIssuer نفسه هدفها.
- الصيغة التي تشير إلى الـIssuer نفسه هي ISSUER-POINTER وحدها. الإشارة إلى الـIssuer بـ`EXTERNAL-ISSUER-*` بكتابة معرّف المستند `0` ومعرّف الهدف `0` هي invalid.

## مثال {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [DOC-POINTER](0x041L-doc-pointer.md)، [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)، [Issuer والنشر](../issuer.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000400/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
