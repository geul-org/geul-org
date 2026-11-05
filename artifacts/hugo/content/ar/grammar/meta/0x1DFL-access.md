---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "يكتب نطاق إتاحة المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `ACCESS` (BIND مستند المواصفة `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| مستند المواصفة | `0x00000000/codecs/0x00001DF0/` (هدف DECLARE `1DF0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 31 |
| Kind | Meta · الفئة: السياسة |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نطاق الإتاحة |
| جهة Hugo | `meta/policy/access.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | قيمة خام 1 WORD |  | `0x0000` public، `0x0001` internal، `0x0002` confidential |

يكتب نطاق الإتاحة للمستند.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length TAG ممتد]
الدرجة            1 WORD (0 عام، 1 داخلي، 2 سري، وما عداها Reserved)
```

- Codec: Meta `0x1DFL`، فئة السياسة
- Payload: قيمة خام (درجة من 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لا يُنشر المستند السري ([Issuer](../issuer.md)).
- لا يغيّر التفسير. بل يحدد التعامل فقط.

## مسائل مفتوحة {#열린-문제}

- جدول رموز الدرجات.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001DF0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
