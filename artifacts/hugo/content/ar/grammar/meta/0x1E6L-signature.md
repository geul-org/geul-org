---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "توقيع على تجزئة محتوى المستند (التزام git موقَّع أو tag)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SIGNATURE` (BIND مستند المواصفة `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| مستند المواصفة | `0x00000000/codecs/0x00001E60/` (هدف DECLARE `1E60`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 6 |
| Kind | Meta · الفئة: التحقق |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | توقيع على الهدف. وتوقيع المستند هو توقيع على تجزئة المحتوى (التزام git موقَّع أو tag) |
| جهة Hugo | `meta/verification/signature.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | قيمة خام 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | سجل | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | قيمة خام للباقي (`0xFFFF`) |  |  |

توقيع على تجزئة محتوى المستند (التزام git موقَّع أو tag).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length TAG ممتد]
معرّف الخوارزمية  1 WORD (0x0001 = Ed25519)
الموقِّع          سجل Reference من ISSUER-POINTER (Issuer)
التوقيع           كل الباقي. ويحدد العرضَ الخوارزمية (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`، فئة التحقق
- Payload: معرّف الخوارزمية (قيمة خام 1 WORD) + الموقِّع (Reference مضمّن) + التوقيع (قيمة خام، الباقي)
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- هدف التوقيع هو تجزئة المحتوى. ولا يُوقَّع BODY وحده ([التوقيع](../issuer.md#서명)).
- لأنه من فئة التحقق فهو مستثنى من تجزئة المحتوى. فإضافة توقيع لا تغيّر التجزئة.
- يُتحقق بمعيار «يجب أن يوجد توقيع بالمفتاح المحدد» لا «إذا وُجد توقيع فيُتحقق منه».
- يوقّع جهةُ النشر مستندَ قائمة الإصدارات.
- الموقِّع هو [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) الذي يشير إلى Issuer نفسه. ولأنه سجل Reference ينتهي بـ Length الخاص به، فإن التخطيط واحد مهما اختلف عرض التوقيع بين الخوارزميات ([DECLARE](../edge/0x0BBL-declare.md) الحقل الأخير الباقي).
- إذا اختلف عدد WORD في التوقيع عن العرض الذي تحدده الخوارزمية فهو غير صالح.

## مسائل مفتوحة {#열린-문제}

- هل يُوقَّع وقت التوقيع معه.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E60/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
