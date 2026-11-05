---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب سبب التغيير (git commit message)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `MESSAGE` (BIND مستند المواصفة `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| مستند المواصفة | `0x00000000/codecs/0x00001D90/` (هدف DECLARE `1D90`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 25 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | سبب التغيير. قيمة UTF8-LANGUAGE-TEXT، واحدة لكل لغة (git commit message) |
| جهة Hugo | `meta/lineage/message.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | سجل | `0780` UTF8-LANGUAGE-TEXT، `0790` UTF8-LANGUAGE-TEXT |  |

يكتب سبب التغيير (git commit message).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length TAG ممتد]
الرسالة           قيمة UTF8-LANGUAGE-TEXT واحدة
```

- Codec: Meta `0x1D9L`، فئة النسب
- Payload: Value مضمّنة ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- العدد: واحد على الأكثر لكل لغة

## التفسير والصلاحية {#해석과-유효성}

- تُوضع الرسالة واللغة في UTF8-LANGUAGE-TEXT واحد. ولا يوجد إلا MESSAGE واحد للغة الواحدة.
- تكتب مواصفة geul.org ذلك بـ [CODEC](../edge/0x0BEL-codec.md) `0780` و`0790`.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D90/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
