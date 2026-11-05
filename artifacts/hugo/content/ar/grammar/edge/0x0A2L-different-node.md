---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE هو Edge عبارة عدم تطابق يفيد أن سجلَّي Reference يشيران إلى referent مختلفين."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DIFFERENT-NODE` (BIND مستند المواصفة `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| مستند المواصفة | `0x00000000/codecs/0x00000A20/` (هدف DECLARE `0A20`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 2 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عدم تطابق يشير فيه سجلا Reference إلى هدفين مختلفين |
| جانب Hugo | `edge/different-node.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | أي سجل (عدا علامة الموضع) |  |

DIFFERENT-NODE هو Edge عبارة عدم تطابق يفيد أن سجلَّي Reference يشيران إلى referent مختلفين. Codec `0x0A2L`.

لا يعني أن ترميز byte وCodec وID لسجلَّي Reference مختلفة. ويُميَّز عن الربط الموجَّه في [REFERENCE-NODE](0x0A0L-reference-node.md) وعن التطابق في [SAME-NODE](0x0A1L-same-node.md).

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            سجل Reference واحد
```

## التفسير والصلاحية {#해석과-유효성}

- يجب أن يكون كل من Subject وObject سجل [Reference](../reference/_index.md) واحداً كاملاً تماماً. تُعرف الحدود بـ Length الخاص بكل سجل، وإن كان Value أو Edge أو ناقصاً فهو invalid.
- يشير Subject وObject إلى referent مختلفين. لا يُستنتج اختلاف referent من اختلاف سلسلة byte أو Codec أو ID لسجلَّي Reference وحده.
- وبخاصة، معرِّفا [LOCAL](../reference/0x005L-local.md) مختلفان هما مجرد سجلَّي Reference مختلفين، ولا يعنيان أن referent في الواقع مختلف أيضاً. لا يُستخلص DIFFERENT من اختلاف LOCAL ID وحده.
- عدم التطابق متماثل وغير انعكاسي وغير متعدٍّ. `DIFFERENT(A, B)` علاقة مثل `DIFFERENT(B, A)`. لكن لا يُستنتج `DIFFERENT(A, C)` من `DIFFERENT(A, B)` و`DIFFERENT(B, C)`.
- ترتيب Subject/Object في wire مجرد ترتيب تسلسل لأجل framing ولا ينشئ اتجاهاً دلالياً. يجب أن تستطيع التطبيقات الاستكشاف في الاتجاهين.
- يجب أن يطابق المؤشر بعد قراءة المكوّنين نهاية Edge تماماً.

العلاقة نفسها غير انعكاسية، لكن لا يجوز حذف ادعاء `DIFFERENT(A, A)` الصالح بنيوياً، أو الادعاءات التي يتصادم فيها SAME وDIFFERENT، بوصفها خطأ في قواعد wire. تحفظ هذه الادعاءات سياقها ونسبها وتُعالَج تناقضاً في طبقة الحكم. وعند تفسير DIFFERENT أو استخلاصه يُحفَظ المصدر والزمن وworld ونطاق policy للوثيقة التي تحوي ذلك Edge، ولا يُوسَّع إلى نتيجة عامة تتجاهل ذلك.

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_object WORD
```

## مثال (غير معياري) {#예시-비규범}

Edge Id هو `000A`، وSubject هو LOCAL 1، وObject هو LOCAL 2.

- Edge هو TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD، و`LLLL=0110`. وTAG هو `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

اختلاف LOCAL ID في هذا المثال لإظهار الترميز فقط. لا يصير هذا sequence هو DIFFERENT-NODE إلا إذا وُجد ادعاء مستقل بأن ID 1 وID 2 يشيران إلى referent مختلفين.

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)، [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md)، [LOCAL](../reference/0x005L-local.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A20/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
