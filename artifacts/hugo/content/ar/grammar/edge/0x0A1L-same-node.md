---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE هو Edge عبارة تطابق بلا اتجاه يعلن أن سجلَّي Reference يشيران إلى referent نفسه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SAME-NODE` (BIND مستند المواصفة `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| مستند المواصفة | `0x00000000/codecs/0x00000A10/` (هدف DECLARE `0A10`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 1 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تطابق يشير فيه Reference إلى الهدف نفسه |
| جانب Hugo | `edge/same-node.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | أي سجل (عدا علامة الموضع) |  |

SAME-NODE هو Edge عبارة تطابق بلا اتجاه يعلن أن سجلَّي Reference يشيران إلى referent نفسه. Codec `0x0A1L`.

لا يعني أن ترميز byte وCodec وID لسجلَّي Reference متطابقة. فبينما [REFERENCE-NODE](0x0A0L-reference-node.md) ربط موجَّه من `Reference → سجل`، يعبّر SAME-NODE عن التطابق (referential identity) بين سجلَّي Reference.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            سجل Reference واحد
```

## التفسير والصلاحية {#해석과-유효성}

- يُسلسَل Subject وObject بهذا الترتيب، ويجب أن يكون كل منهما سجل [Reference](../reference/_index.md) واحداً كاملاً تماماً. تُعرف الحدود بـ Length الخاص بكل سجل.
- إن كان Subject أو Object هو Value أو Edge أو سجلاً ناقصاً فهو invalid.
- علاقة SAME-NODE انعكاسية ومتماثلة ومتعدّية. ترتيب Subject/Object في wire هو لأجل framing ولا ينشئ اتجاهاً دلالياً. يجب أن تستطيع التطبيقات استكشاف هذه العلاقة في الاتجاهين.
- معرِّفا [LOCAL](../reference/0x005L-local.md) مختلفان هما مجرد سجلَّي Reference مختلفين، وليسا دليلاً على أن referent واحد أو مختلف. يُعلن أن سجلَّي Reference يشيران إلى referent نفسه بـ SAME-NODE.
- يجب أن يحفظ التفسير والاستدلال المصدر والزمن وworld ونطاق policy للوثيقة التي تحوي ذلك Edge ولرسم الحكم. لا يُستخدم SAME-NODE أساساً لدمج عام بغض النظر عن السياق.
- لا يُحذف سجل Reference الأصلي أو نسبه ولا يُستبدل حتى مع وجود SAME-NODE.
- وجود SAME-NODE و[DIFFERENT-NODE](0x0A2L-different-node.md) معاً لزوج واحد لا يجعل wire invalid. يُحفظ سياق كل ادعاء ويُقيَّم بوصفه تعارضاً.
- يُحلّ المتغير بربط Variable Reference بـ Identified Reference عبر SAME-NODE ([Reference](../reference/_index.md) Variable).

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_object WORD
```

## مثال (غير معياري) {#예시-비규범}

Edge Id هو `0009`، وSubject هو LOCAL 1، وObject هو LOCAL 2.

- Edge هو TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD، و`LLLL=0110`. وTAG هو `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)، [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md)، [LOCAL](../reference/0x005L-local.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A10/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
