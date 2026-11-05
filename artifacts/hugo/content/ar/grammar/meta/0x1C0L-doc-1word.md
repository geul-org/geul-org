---
title: "DOC-1WORD (0x1C0L)"
weight: 448
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD وDOC-2WORD وDOC-4WORD هي Meta بنية تفتح المستند بتحديد العدد الكلي لـ WORD فيه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD وDOC-2WORD وDOC-4WORD هي Meta بنية تفتح المستند بتحديد العدد الكلي لـ WORD فيه.

| البند | القيمة |
|---|---|
| الاسم | `DOC-1WORD` (BIND مستند المواصفة `DOC-1WORD`) |
| TAG ID | `0x1C0L` |
| Codec ID | `0x00001C00` |
| مستند المواصفة | `0x00000000/codecs/0x00001C00/` (هدف DECLARE `1C00`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 0 |
| Kind | Meta · الفئة: البنية |
| TAG WORD | `0001 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | بداية مستند يحدد الطول الكلي في Payload من 1 WORD |
| جهة Hugo | `meta/structure/doc.md` (تعالج تلك الصفحة أيضاً [DOC-2WORD](0x1C1L-doc-2word.md) و[DOC-4WORD](0x1C2L-doc-4word.md)) |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | قيمة خام 1 WORD |  |  |

هو السجل الذي يفتح المستند. ويحدد في Payload العدد الكلي لـ WORD في المستند. تُعالج هذه الصفحة معاً `DOC-1WORD` (`0x1C0L`) و`DOC-2WORD` (`0x1C1L`) و`DOC-4WORD` (`0x1C2L`).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length TAG ممتد]
Payload           العدد الكلي لـ WORD. يحدد Codec العرض: DOC-1WORD 1، DOC-2WORD 2، DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`، فئة البنية
- Payload: قيمة خام (العدد الكلي لـ WORD في المستند، unsigned)
- العدد: واحد لكل مستند، في المقدمة

## التفسير والصلاحية {#해석과-유효성}

- الطول من بداية السجل الفاتح إلى نهاية [END](0x1C4L-end.md).
- يُستخدم أضيق عرض تتسع له القيمة. والترميز بعرض أوسع يُرفض بوصفه ترميزاً غير قياسي.
- يجب أن يساوي الطول المدخل كله. المستند الواحد مدخل واحد.
- يستطيع المفكك بهذا الطول أن يتخطى المستند كله. ولا يوجد Codec يفتح دون معرفة الطول.
- عند حساب تجزئة المحتوى يُعاد كتابته بالطول بعد طرح Meta فئة التحقق وبالعرض المناسب له ([تجزئة المحتوى](../document.md#내용-해시)).

## مثال {#예시}

- `0x1C01 0x0017`: DOC-1WORD، والطول الكلي 23 WORD

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C00/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C0000000000
BODY
#1 DECLARE 0x1C00
#2 FIELD #1 0x0001
#3 BIND #1 "DOC-1WORD"
#4 BIND #2 "count"
```
