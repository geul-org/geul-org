---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "يعلن المفتاح العام لـ Issuer ذاتي الإصدار (16 WORD)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `ISSUER-KEY` (BIND مستند المواصفة `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| مستند المواصفة | `0x00000000/codecs/0x00001E50/` (هدف DECLARE `1E50`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 5 |
| Kind | Meta · الفئة: التحقق |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إعلان معرّف خوارزمية التوقيع والمفتاح العام لـ Issuer ذاتي الإصدار |
| جهة Hugo | `meta/verification/issuer-key.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | قيمة خام 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | قيمة خام للباقي (`0xFFFF`) |  |  |

يعلن المفتاح العام لـ Issuer ذاتي الإصدار (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ معرّف الخوارزمية ‖ المفتاح العام) ([Issuer من 16 WORD](../issuer.md#16-word-issuer)).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[Length TAG ممتد]
معرّف الخوارزمية  1 WORD (0x0001 = Ed25519)
المفتاح العام     العرض الذي تحدده الخوارزمية (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`، فئة التحقق
- Payload: قيمة خام (معرّف الخوارزمية + المفتاح العام)
- العدد: يجوز تعدده (تبديل المفاتيح)

## التفسير والصلاحية {#해석과-유효성}

- لأنه من فئة التحقق فهو مستثنى من تجزئة المحتوى.
- لا يلزم Issuer من 2 و4 WORD لأنه يستخدم مفتاحاً مسجلاً في geul.org.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E50/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
