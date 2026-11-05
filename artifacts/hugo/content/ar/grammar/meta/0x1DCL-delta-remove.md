---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب في diff (DELTA-BASE) قائمة LOCAL ID (Edge Id) للسجلات التي تُحذف من BODY الـ snapshot الأساس (“حذف المادة X”)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DELTA-REMOVE` (BIND مستند المواصفة `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| مستند المواصفة | `0x00000000/codecs/0x00001DC0/` (هدف DECLARE `1DC0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 28 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | قائمة LOCAL ID (Edge Id) التي تُحذف من BODY الأساس في الـ diff |
| جهة Hugo | `meta/lineage/delta-remove.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | قيمة خام للباقي (`0xFFFF`) |  |  |

يكتب في diff ([DELTA-BASE](0x1DBL-delta-base.md)) LOCAL ID (Edge Id) للسجلات التي تُحذف من BODY الـ snapshot الأساس (“حذف المادة X”).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length TAG ممتد]
LOCAL ID للحذف     سجلات LOCAL Reference × 1 فأكثر
```

- Codec: Meta `0x1DCL`، فئة النسب
- Payload: سجل [LOCAL](../reference/0x005L-local.md) Reference واحد فأكثر
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لا يوضع إلا في مستند فيه `DELTA-BASE`.
- يجب أن يكون كل LOCAL ID هو Edge Id موجوداً في BODY الـ snapshot الأساس. وإلا فهو غير صالح. ووضع المعرّف نفسه مرتين غير صالح.
- وضع Edge Id نفسه مرة أخرى في BODY الـ diff نفسه غير صالح (لا يمكن الحذف والتعديل معاً).
- لا يُعاد تعيين LOCAL ID المحذوف لهدف آخر في الإصدارات اللاحقة ([التعديل](../document.md#개정)).
- خلو BODY الـ diff من سجل معناه «لم يتغير». ولذلك يُعبَّر عن الحذف بهذا Meta وحده.
- لا يُكتب HEAD Edge ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) للمستند كله مع QUALIFIER الخاص به). فـ HEAD يُستبدل كله بـ HEAD الخاص بالـ diff ([حفظ diff](../document.md#diff-저장)).

## مثال {#예시}

حذف LOCAL `#7` و`#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`، `LLLL=0100`، 5 WORD)، وLOCAL Reference هما `0051 0007` و`0051 000C`.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001DC0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
