---
title: "MODIFIED-AT (0x1CEL)"
weight: 462
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "يكتب وقت تعديل المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `MODIFIED-AT` (BIND مستند المواصفة `MODIFIED-AT`) |
| TAG ID | `0x1CEL` |
| Codec ID | `0x00001CE0` |
| مستند المواصفة | `0x00000000/codecs/0x00001CE0/` (هدف DECLARE `1CE0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 14 |
| Kind | Meta · الفئة: المصدر |
| TAG WORD | `0001 1100 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | وقت التعديل. قيمة TIME |
| جهة Hugo | `meta/provenance/modified-at.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | سجل | `06A0` GREGORIAN-DATE، `06C0` POSIX-TIMESTAMP-SECONDS، `06E0` EDTF، `06F0` EDTF، `0700` GEDCOM-DATE، `0710` GEDCOM-DATE |  |

يكتب وقت تعديل المستند.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 1110 LLLL      Codec 0x1CEL
[Length TAG ممتد]
Payload           قيمة TIME واحدة (GREGORIAN-DATE وPOSIX-TIMESTAMP-SECONDS وغيرهما)
```

- Codec: Meta `0x1CEL`، فئة المصدر
- Payload: Value مضمّنة (من عائلة TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) و[POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) وغيرهما)
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- تُختار الصيغة من Value عائلة TIME. وإذا لزمت الدقة فتُستخدم صيغة النانوثانية التي عرّفها Issuer (مثلاً: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001CE0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CE000000000
BODY
#1 DECLARE 0x1CE0
#2 FIELD #1 record
#3 BIND #1 "MODIFIED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
