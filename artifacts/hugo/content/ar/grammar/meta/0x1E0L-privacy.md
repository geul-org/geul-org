---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "يكتب درجة خصوصية المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `PRIVACY` (BIND مستند المواصفة `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| مستند المواصفة | `0x00000000/codecs/0x00001E00/` (هدف DECLARE `1E00`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 0 |
| Kind | Meta · الفئة: السياسة |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | درجة الخصوصية |
| جهة Hugo | `meta/policy/privacy.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | قيمة خام 1 WORD |  |  |

يكتب درجة خصوصية المستند.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length TAG ممتد]
الدرجة            1 WORD
```

- Codec: Meta `0x1E0L`، فئة السياسة
- Payload: قيمة خام (درجة من 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لا يغيّر التفسير. بل يحدد التعامل فقط.

## مسائل مفتوحة {#열린-문제}

- جدول رموز الدرجات (التقابل مع تصنيفات قانون حماية المعلومات الشخصية).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E00/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
