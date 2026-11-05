---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "يكتب نتيجة الحكم على المستند كله."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `VERDICT` (BIND مستند المواصفة `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| مستند المواصفة | `0x00000000/codecs/0x00001E90/` (هدف DECLARE `1E90`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 9 |
| Kind | Meta · الفئة: التحقق |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نتيجة الحكم على المستند كله. Pass وReview وFail. وعلى مستوى العقدة والسجل [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| جهة Hugo | `meta/verification/verdict.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | قيمة خام 1 WORD |  | `0x0000` pass، `0x0001` review، `0x0002` fail |

يكتب نتيجة الحكم على المستند كله. أما الحكم على مستوى العقدة والسجل فيتولاه [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length TAG ممتد]
الحكم             1 WORD (0 Pass، 1 Review، 2 Fail)
```

- Codec: Meta `0x1E9L`، فئة التحقق
- Payload: قيمة خام (حكم من 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لأنه من فئة التحقق فهو مستثنى من تجزئة المحتوى.
- الحكم على مستند آخر يوضع في BODY مستند غير المستند المحكوم عليه.

## مسائل مفتوحة {#열린-문제}

- هل تُكتب معه جهة الحكم وأساسه.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E90/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
