---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "سجل ينهي HEAD ويبدأ BODY."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `BODY` (BIND مستند المواصفة `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| مستند المواصفة | `0x00000000/codecs/0x00001C30/` (هدف DECLARE `1C30`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 3 |
| Kind | Meta · الفئة: البنية |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | 1 WORD. ينهي HEAD في المستند ويبدأ BODY. |
| جهة Hugo | `meta/structure/body.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

لا يوجد FIELD في مستند المواصفة. لا يُعلن أي حقل في Payload.

سجل ينهي HEAD ويبدأ BODY.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length TAG ممتد]
```

- Codec: Meta `0x1C3L`، فئة البنية
- Payload: لا يوجد (1 WORD)
- العدد: واحد على الأكثر لكل مستند

## التفسير والصلاحية {#해석과-유효성}

- إذا كان HEAD فارغاً يُحذف. المستند الذي لا يحتوي `BODY` كله BODY. وإذا وُجدت في HEAD سجلات Meta أو Edge من HEAD (أي [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) للمستند كله مع QUALIFIER الخاص به) فيوضع.
- لا يوجد Payload. الطول الكلي 1 WORD.

## مثال {#예시}

- `0x1C30`

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C30/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
