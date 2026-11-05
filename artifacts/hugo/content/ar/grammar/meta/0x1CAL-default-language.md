---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن اللغة الافتراضية لنص المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DEFAULT-LANGUAGE` (BIND مستند المواصفة `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| مستند المواصفة | `0x00000000/codecs/0x00001CA0/` (هدف DECLARE `1CA0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 10 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | اللغة الافتراضية |
| جهة Hugo | `meta/declaration/default-language.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | سجل | `07A0` LANGUAGE-SHORT-CODE، `0760` LANGUAGE-BCP47-CODE-EVEN، `0770` LANGUAGE-BCP47-CODE-ODD |  |

يعلن اللغة الافتراضية لنص المستند. والنص الذي لم تُكتب لغته منفصلة هو بهذه اللغة.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length TAG ممتد]
Payload           قيمة لغة واحدة
```

- Codec: Meta `0x1CAL`، فئة التعريف
- Payload: Value مضمّنة ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) أو [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- يسجّل مستند TANGEUL اللغة المحلية (locale) التي كُتب بها (مثلاً: `en` و`ko`).

## مثال {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001CA0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
