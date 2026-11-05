---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب اسماً ثابتاً يُلحق بإصدار (git annotated tag)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `TAG` (BIND مستند المواصفة `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| مستند المواصفة | `0x00000000/codecs/0x00001DA0/` (هدف DECLARE `1DA0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 26 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | اسم ثابت يُلحق بإصدار. قيمة TEXT وتجزئة محتوى (git annotated tag) |
| جهة Hugo | `meta/lineage/tag.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | سجل | `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | سجل | `07C0` SHA-256-DIGEST، `0000` ABSENT (حقل اختياري) |  |

يكتب اسماً ثابتاً يُلحق بإصدار (git annotated tag).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length TAG ممتد]
الاسم             قيمة UTF8-TEXT-*
الهدف             قيمة SHA-256-DIGEST، أو علامة الحذف 0x0000 (حقل اختياري). وإذا حُذف فهو هذا الإصدار
```

- Codec: Meta `0x1DAL`، فئة النسب
- Payload: Value مضمّنة (نص + تجزئة محتوى اختيارية)
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- الاسم هو [UTF8-TEXT](../value/0x072L-utf8-text.md)، والهدف هو [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- إذا حُذف الهدف (ABSENT `0x0000`، حقل اختياري في [CODEC](../edge/0x0BEL-codec.md)) فالاسم ملحق بهذا المستند نفسه. فلا يمكن كتابة تجزئة المحتوى الخاصة بالمستند داخله. ومواصفة geul.org `0x1DA0` هي سجلان: name (`0720` و`0730`) وtarget (`07C0` و`0000`).
- لا يُعاد استخدام الاسم نفسه لإصدار آخر.

## مثال {#예시}

- الاسم `v1`، وهذا الإصدار: `1DA3 0721 7631 0000`

## مسائل مفتوحة {#열린-문제}

- هل يلزم TAG مع وجود معرّف الإصدار (الرقم التسلسلي).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001DA0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
