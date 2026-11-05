---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND هو Edge عبارة يربط بـ Subject اسماً تطابقه الآلة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `BIND` (BIND مستند المواصفة `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| مستند المواصفة | `0x00000000/codecs/0x00000A30/` (هدف DECLARE `0A30`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 3 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | يربط بـ Subject اسماً تطابقه الآلة (`UTF8-TEXT-*`). فريد داخل النطاق ويجب أن يتطابق تماماً ولا لغة له |
| جانب Hugo | `edge/bind.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `name` | #3 | سجل | `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD |  |

BIND هو Edge عبارة يربط بـ Subject اسماً تطابقه الآلة. Codec `0x0A3L`.

إنه تسمية. أما الاسم الذي يقرؤه الإنسان (العنوان بحسب اللغة) فيتولاه [LABEL](0x0A4L-label.md). ويُستخدم السجل نفسه لاسم رمز البرنامج ولاسم النطاق في قائمة Issuer.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد، أو TAG WORD الخاص بـ Codec وهو 1 WORD
الاسم             Value من نوع UTF8-TEXT-* واحد
```

## التفسير والصلاحية {#해석과-유효성}

- Subject هو سجل [Reference](../reference/_index.md) واحد كامل تماماً. إن كان LOCAL فهو هدف في هذه الوثيقة (رمز ونحوه)، وإن كان Reference إشارياً فهو هدف في وثيقة أخرى. الوثيقة نفسها هي [DOC-POINTER](../reference/0x041L-doc-pointer.md)، وIssuer نفسه هو [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- أو يكون Subject هو TAG WORD واحداً لـ Codec (Kind وCodec فقط، `LLLL = 0`، بلا Payload). وهذا لا يشير إلى سجل Payload فيه فارغ، بل إلى الرمز المباشر نفسه، أي مستند مواصفته (Codec الخاص بـ Issuer GEUL `0x0000<TAG>`) ([مستند مواصفة Codec](../codec-spec.md)، [DECLARE](0x0BBL-declare.md)). مثال: `0B80` هو PUBLICATION. ولا يُشار إلى Codec بصيغة Issuer بهذا الشكل.
- لا يجوز لسجل آخر (Value ونحوه) أن يكون Subject. ولأن FIELD في مستند مواصفة BIND يصرِّح بـ Subject بعرض `0` (سجل) فقط، فهذا القيد من قواعد نص BIND.
- الاسم هو Value واحد تماماً من [UTF8-TEXT](../value/0x072L-utf8-text.md). لا لغة له ولا يُطبَّع. لا يكون الاسمان متماثلين إلا إذا تطابقت البايتات.
- نطاق الاسم هو الوثيقة التي تحوي BIND. لا يُربط الاسم نفسه بـ Subject مختلفين في وثيقة واحدة.
- يمكن ربط عدة أسماء بـ Subject واحد (اسم مستعار، اسم قديم). وما لم تحدد الوثيقة غير ذلك فآخر BIND هو الاسم الممثِّل.
- تشير السجلات الأخرى إلى الهدف بـ LOCAL ID لا بالاسم. يُستخدم الاسم للمطابقة مع الخارج (دوال المضيف، ومدخلات العناوين، والبشر).
- تحدد وجوه الاستخدام الأحرف الجائزة في الاسم. ويتبع اسم النطاق في قائمة Issuer قواعد النطاق (أحرف صغيرة، IDNA) ([عنوان النشر وقائمة الإصدارات](../publishing.md#issuer-목록)).
- لا يوضع BIND في قائمة الإصدارات. لا يوجد عنوان باسم الوثيقة ([عنوان النشر وقائمة الإصدارات](../publishing.md#문서-이름)).

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_name WORD
```

## مثال (غير معياري) {#예시-비규범}

رمز برنامج: Edge Id هو `0003`، وSubject هو LOCAL 7، والاسم `main`.

- الاسم `main` من 4 byte (زوجي) فهو `0722 6D61 696E`، أي 3 WORD.
- Edge هو TAG 1 + Edge Id 2 + Subject 2 + الاسم 3 = 8 WORD، وTAG هو `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [LABEL](0x0A4L-label.md)، [عنوان النشر وقائمة الإصدارات](../publishing.md#issuer-목록) (اسم النطاق في قائمة Issuer)
- [LOCAL](../reference/0x005L-local.md)، [DOC-POINTER](../reference/0x041L-doc-pointer.md)، [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A30/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
