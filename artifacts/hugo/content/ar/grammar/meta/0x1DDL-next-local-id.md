---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب LOCAL ID الذي سيخصصه الإصدار التالي من المستند للعبارات الجديدة (auto increment في DBMS، وAUTO_INCREMENT في MySQL)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `NEXT-LOCAL-ID` (BIND مستند المواصفة `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| مستند المواصفة | `0x00000000/codecs/0x00001DD0/` (هدف DECLARE `1DD0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 29 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | LOCAL ID التالي الذي سيُخصَّص (auto increment). ويوضع في HEAD لقائمة الإصدارات `versions.geul` |
| جهة Hugo | `meta/lineage/next-local-id.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | قيمة خام للباقي (`0xFFFF`) |  |  |

يكتب LOCAL ID الذي سيخصصه الإصدار التالي من المستند للعبارات الجديدة (auto increment في DBMS، وMySQL `AUTO_INCREMENT`). وكل LOCAL ID خُصِّص في أي إصدار من المستند أصغر من هذه القيمة.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           LOCAL ID التالي الذي سيُخصَّص، عدد صحيح unsigned بأقصر عرض
```

- Codec: Meta `0x1DDL`، فئة النسب
- Payload: قيمة خام (عدد صحيح unsigned بأقصر عرض)
- العدد: واحد على الأكثر
- موضعه: HEAD في مستند قائمة الإصدارات `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## التفسير والصلاحية {#해석과-유효성}

- LOCAL ID (ومنه Edge Id) هو هوية تتجاوز الإصدارات ([التعديل](../document.md#개정)). تأخذ العبارة الجديدة هذه القيمة ثم تزيد القيمة 1. ولا يُعاد استخدام LOCAL ID المحذوف. ولذلك لا تنقص هذه القيمة حتى لو حُذفت العبارة ذات القيمة العظمى.
- لا يُخصَّص LOCAL ID `0` فالقيمة الأولى هي `1`. وإذا لم يكن هناك إصدار بعد فلا يوضع هذا Meta ويكون الرقم التالي `1`.
- تحدّثه جهة النشر وتكتبه في مستند القائمة الجديد عند نشر إصدار. ويجب أن يكون أكبر من أي LOCAL ID استُخدم في الإصدارات المنشورة. وإذا كان أصغر أو مساوياً فهو غير صالح.
- القيمة تزيد فقط. وإذا كانت أصغر من قيمة مستند القائمة السابق ([PARENT](0x1D1L-parent.md)) فهو غير صالح.
- لا يوجد في مستند لا يُدار بالإصدارات (مستند بلا `versions.geul`، ومستند بلا اسم). ومثل هذا المستند لا يوضع فيه diff ([DELTA-BASE](0x1DBL-delta-base.md)) أيضاً.
- لا يوضع في متن المستند (مستند الإصدار). فحفظ الرقم ليس من محتوى المستند بل من حالة جهة النشر التي تواصل كتابة المستند (في git هو جانب refs لا الـ commit).

## مثال {#예시}

رقم التخصيص التالي 524:

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`، `LLLL=0001`، 2 WORD)، وPayload هو `020C`.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001DD0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
