---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL هو Edge عبارة يربط بـ Object اسماً واحداً (label) بلغة معينة لهدف Subject."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `LABEL` (BIND مستند المواصفة `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| مستند المواصفة | `0x00000000/codecs/0x00000A40/` (هدف DECLARE `0A40`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 4 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ربط الاسم (label) بلغة معينة لـ Subject. Object هو UTF8-LANGUAGE-TEXT |
| جانب Hugo | `edge/label.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | `0780` UTF8-LANGUAGE-TEXT، `0790` UTF8-LANGUAGE-TEXT، `0050` LOCAL |  |

LABEL هو Edge عبارة يربط بـ Object اسماً واحداً (label) بلغة معينة لهدف Subject. Codec `0x0A4L`. وليس Edge يمثل lemma بالمعنى المعجمي العام.

يوضع الاسم ولغته في Object واحد هو [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). فلا يوجد حقل قيمة خام.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            Value من نوع UTF8-LANGUAGE-TEXT أو سجل LOCAL Reference واحد
```

## التفسير والصلاحية {#해석과-유효성}

- Subject هو سجل Reference واحد كامل تماماً. تُعرف حدوده بـ Length الخاص بـ Subject نفسه، وإن لم يكن Reference أو كان ناقصاً فهو invalid.
- Object هو سجل [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`) واحد كامل تماماً. تتبع قواعد اللغة والنص (جواز صيغتي اللغة كلتيهما، ومقارنة اللغة نفسها) تلك الصيغة.
- يجوز أن يأتي في Object أيضاً LOCAL Reference. وعندئذ يجب أن يُحلَّ إلى UTF8-LANGUAGE-TEXT بربط [REFERENCE-NODE](0x0A0L-reference-node.md) في الوثيقة نفسها. فإن لم يُحلَّ أو حُلَّ إلى هدف من نوع آخر فهو invalid.
- يكتب مستند مواصفة geul.org هذا القيد بـ [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). ولا يُعبَّر عن هدف حل LOCAL بـ CODEC.
- إذا لم يكن Object أياً من الصيغتين أعلاه أو كان السجل ناقصاً فهو invalid. لا يصلح النص بلا لغة (UTF8-TEXT) أن يكون LABEL. يُكتب الاسم الآلي بلا لغة بـ [BIND](0x0A3L-bind.md). ويُكتب الاسم المشترك بين عدة لغات بلغة `mul`.
- لا يزيد LABEL لـ Subject واللغة نفسيهما على واحد. تُكتب الأسماء الأخرى بـ [ALIAS](0x0A5L-alias.md).

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_object WORD
```

- سجل اللغة وعدد بايتات النص في Object من مسؤولية سجل Object لا Edge. يجب أن يطابق المؤشر بعد قراءة السجل الأخير نهاية Edge تماماً.

## مثال (غير معياري) {#예시-비규범}

رمز اللغة `0784` لـ `en` هو رقم في GEUL Language Registry v2 (مستند المواصفة `0x00000000/codecs/0x000007A0` الإصدار 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id هو `0007`، وSubject هو Q22686 (`0141 589E`)، وObject هو `Donald Trump` (en).

- Object: اللغة `07A1 0784` (SHORT-CODE، 2 WORD) + نص من 12 byte (زوجي، 6 WORD)، فهو `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`)، والكل 9 WORD `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- Edge هو TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD، و`LLLL=1101`. وTAG هو `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id هو `0008`، وSubject هو Q155 (`0141 009B`)، وObject هو `Brasil` (pt-BR).

- Object: اللغة `0773 7074 2D42 5200` (BCP47 `pt-BR`، 4 WORD) + نص من 6 byte (زوجي، 3 WORD)، والكل 8 WORD `0787 0773 7074 2D42 5200 4272 6173 696C`.
- Edge هو TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD، و`LLLL=1100`. وTAG هو `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [ALIAS](0x0A5L-alias.md)، [DESCRIPTION](0x0A6L-description.md)، [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)، [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)، [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A40/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
