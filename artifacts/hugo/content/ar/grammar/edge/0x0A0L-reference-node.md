---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE هو Edge عبارة موجَّه يربط Reference واحداً بسجل Object واحد ليعرِّف ما هو ذلك Reference أو يربطه به."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `REFERENCE-NODE` (BIND مستند المواصفة `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| مستند المواصفة | `0x00000000/codecs/0x00000A00/` (هدف DECLARE `0A00`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 0 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ربط موجَّه يشير فيه Subject، وهو Reference، إلى Object |
| جانب Hugo | `edge/reference-node.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `060F` القسم 3 كله (حرف بدل، Value)، `080F` القسم 4 كله (حرف بدل، Value) |  |

REFERENCE-NODE هو Edge عبارة موجَّه يربط Reference واحداً بسجل Object واحد ليعرِّف ما هو ذلك Reference أو يربطه به. Codec `0x0A0L`.

Subject يشير إلى Object. وهذا الربط ليس [SAME-NODE](0x0A1L-same-node.md) الذي يدّعي التطابق الدلالي، ولا يعني أن بايتات السجلين متطابقة.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            سجل Reference أو Value واحد
```

## التفسير والصلاحية {#해석과-유효성}

- يجب أن يكون Subject سجل [Reference](../reference/_index.md) واحداً كاملاً تماماً. تُعرف حدوده بـ Length الخاص بـ Subject نفسه، وإن لم يكن Reference أو كان ناقصاً فهو invalid.
- يجب أن يكون Object سجل Reference أو Value واحداً كاملاً تماماً. تُعرف حدوده بـ Length الخاص بـ Object نفسه، وإن كان Edge أو Meta أو ناقصاً فهو invalid.
- إذا كان Object هو Reference، فيجب ألا تكون سلسلة Reference التي تُتتبَّع عبر ربط REFERENCE-NODE دائرية، وأن يُحلَّ LOCAL في النهاية. الدورة في الحل وLOCAL المعلَّق (dangling) invalid.
- إذا رُبط LOCAL ID واحد في وثيقة واحدة بـ Object متعارضة فهو invalid. يتبع نطاق LOCAL وID والعرض الأدنى وقواعد الدمج ما في [LOCAL](../reference/0x005L-local.md).
- ليس كل Reference ملزماً بأن يُربط بـ REFERENCE-NODE.
- الاستخدام النموذجي هو `LOCAL → UTF8-LANGUAGE-TEXT`. فإذا وُضع LOCAL في Object الخاص بـ [LABEL](0x0A4L-label.md) حُلَّ النص بهذا الربط في الوثيقة نفسها.

يجب ألا يُفسَّر اتجاه إشارة Subject إلى Object بالعكس. أما معنى SAME وDIFFERENT وقواعدهما التفصيلية فتحددها كل صيغة على حدة.

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` هو عدد WORD لـ Length TAG الممتد، و`N_id` عدد WORD في سجل Edge Id من نوع LOCAL، و`N_subject` و`N_object` هما العدد الكلي لـ WORD في كل سجل. يجب أن يطابق المؤشر بعد قراءة Subject وObject معاً نهاية Edge تماماً.

## مثال (غير معياري) {#예시-비규범}

Edge Id هو `0008`، وSubject هو LOCAL 1، وObject هو [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) للنص `Donald Trump` (en).

- Edge Id هو `0051 0008`، أي 2 WORD.
- Subject هو `0051 0001`، أي 2 WORD.
- Object: اللغة `0761 656E` (BCP47 `en`) + نص من 12 byte (زوجي)، فهو `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`)، والكل 9 WORD. وTAG هو `0788`.
- Edge هو TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD، و`LLLL=1101`. وTAG هو `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [SAME-NODE](0x0A1L-same-node.md)، [DIFFERENT-NODE](0x0A2L-different-node.md)، [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md)، [LOCAL](../reference/0x005L-local.md)، [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A00/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
