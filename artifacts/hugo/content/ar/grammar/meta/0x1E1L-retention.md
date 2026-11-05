---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "يكتب أجل احتفاظ المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `RETENTION` (BIND مستند المواصفة `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| مستند المواصفة | `0x00000000/codecs/0x00001E10/` (هدف DECLARE `1E10`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 1 |
| Kind | Meta · الفئة: السياسة |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | أجل الاحتفاظ |
| جهة Hugo | `meta/policy/retention.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | سجل | `06A0` GREGORIAN-DATE، `06C0` POSIX-TIMESTAMP-SECONDS، `06E0` EDTF، `06F0` EDTF، `0700` GEDCOM-DATE، `0710` GEDCOM-DATE، `06D0` DURATION-SECONDS |  |

يكتب أجل احتفاظ المستند.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[Length TAG ممتد]
Payload           وقت الانتهاء (GREGORIAN-DATE وغيره) أو المدة (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`، فئة السياسة
- Payload: Value مضمّنة (من عائلة TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) وغيرها، أو [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- إذا كانت مدة فتُحسب من [RECORDED-AT](0x1D0L-recorded-at.md).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E10/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
