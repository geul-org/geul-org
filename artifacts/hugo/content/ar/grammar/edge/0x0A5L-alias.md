---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS هو Edge عبارة يربط بـ Object اسماً آخر (اسماً مستعاراً) واحداً لهدف Subject."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `ALIAS` (BIND مستند المواصفة `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| مستند المواصفة | `0x00000000/codecs/0x00000A50/` (هدف DECLARE `0A50`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 5 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ربط اسم آخر (اسم مستعار) لـ Subject. تخطيطه مثل LABEL |
| جانب Hugo | `edge/alias.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | `0780` UTF8-LANGUAGE-TEXT، `0790` UTF8-LANGUAGE-TEXT، `0050` LOCAL |  |

ALIAS هو Edge عبارة يربط بـ Object اسماً آخر (اسماً مستعاراً) واحداً لهدف Subject. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) هو الاسم الممثِّل بتلك اللغة (واحد على الأكثر لكل لغة)، أما ALIAS فهو اسم آخر للهدف نفسه (عدة أسماء لكل لغة، «also known as» في ويكيداتا). يُستخدم أساساً في البحث. التخطيط والصلاحية مثل LABEL.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            Value من نوع UTF8-LANGUAGE-TEXT أو سجل LOCAL Reference واحد
```

## التفسير والصلاحية {#해석과-유효성}

- قواعد Subject وObject مثل [LABEL](0x0A4L-label.md) (Object هو [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) أو LOCAL يُحلّ إليه).
- يمكن وضع عدة ALIAS لـ Subject واللغة نفسيهما. ترتيبها هو ترتيبها في الوثيقة.
- لا يُوضع ALIAS بالنص نفسه الذي في LABEL لـ Subject واللغة نفسيهما (يكفي LABEL واحد للاسم الممثِّل). هذه القاعدة توصية.
- يقيِّد مستند مواصفة geul.org الـ Object بـ [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`، مثل LABEL).

## مثال (غير معياري) {#예시-비규범}

Edge Id هو `0003`، وSubject هو Q42 (`0141 002A`)، وObject هو `DNA` (en): اللغة `0761 656E` (BCP47 `en`) + نص من 3 byte (فردي) ← `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`)، `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD، و`LLLL=1001`. وTAG هو `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [LABEL](0x0A4L-label.md)، [DESCRIPTION](0x0A6L-description.md)، [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A50/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
