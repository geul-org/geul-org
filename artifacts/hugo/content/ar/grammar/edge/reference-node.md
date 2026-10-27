---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE هو Edge وصف اتجاهي يربط Reference واحداً بسجل Object واحد ليعرّف ما هو ذلك Reference (Codec 0x00)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE هو Edge وصف اتجاهي يصل Reference واحداً بسجل Object واحد فيعرّف ما هو ذلك Reference أو يربطه. Codec `0x00`.

يشير Subject إلى Object. وهذا الربط ليس [SAME-NODE](/ar/grammar/edge/same-node/) الذي يدّعي التطابق في المعنى، ولا يعني أن byte السجلين متطابقان.

## التخطيط

```
TAG WORD          0001 0LLL L000 0000
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            سجل Reference أو Value واحد
```

## التفسير والصلاحية

- يجب أن يكون Subject سجل [Reference](/ar/grammar/reference/) كاملاً واحداً بالضبط. تُعرف حدوده بـ Length الخاص به، ويكون invalid إن لم يكن Reference أو كان ناقصاً.
- يجب أن يكون Object سجل Reference أو Value كاملاً واحداً بالضبط. تُعرف حدوده بـ Length الخاص به، ويكون invalid إن كان Edge أو Meta أو ناقصاً.
- إذا كان Object هو Reference فيجب ألا تدور سلسلة Reference التي تُتبع بربط REFERENCE-NODE، ويجب أن يُحل LOCAL في النهاية. والدوران في الحل وLOCAL المعلّق (dangling) كلاهما invalid.
- يكون invalid إذا رُبط معرّف LOCAL واحد في المستند نفسه بـ Object متعارضة. ونطاق LOCAL ومعرّفه وأصغر عرض له وقاعدة الدمج تتبع [LOCAL](/ar/grammar/reference/local/).
- ليس من اللازم أن يُربط كل Reference بـ REFERENCE-NODE.
- الاستخدام النموذجي هو `LOCAL → UTF8-LANGUAGE-TEXT`. فإذا وُضع LOCAL في Object في [LABEL](/ar/grammar/edge/label/) يُحل النص بهذا الربط في المستند نفسه.

لا يجوز تفسير اتجاه إشارة Subject إلى Object معكوساً. ومعنى SAME وDIFFERENT وقواعدهما التفصيلية تحددها كل صيغة على حدة.

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` هو عدد WORD في Length ممتد TAG، و`N_id` هو عدد WORD في سجل LOCAL الخاص بـ Edge Id، و`N_subject` و`N_object` هما العدد الكلي لـ WORD في كل سجل. ويجب أن يتطابق المؤشر بعد قراءة Subject وObject مع نهاية Edge تماماً.

## أمثلة (غير معيارية)

Edge Id `0008`، وSubject هو LOCAL 1، وObject هو [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/) لـ `Donald Trump` (en).

- Edge Id هو `0088 0008` أي 2 WORD.
- Subject هو `0088 0001` أي 2 WORD.
- Object هو اللغة `08C6 656e` (BCP47 `en`) + نص من 12 byte (زوجي) فهو `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`) ومجموعه 9 WORD. وTAG هو `0C4A`.
- Edge هو TAG (1) + Edge Id (2) + Subject (2) + Object (9) = 14 WORD و`LLLL=1101`. وTAG هو `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [SAME-NODE](/ar/grammar/edge/same-node/)، [DIFFERENT-NODE](/ar/grammar/edge/different-node/)، [LABEL](/ar/grammar/edge/label/)
- [Reference](/ar/grammar/reference/)، [LOCAL](/ar/grammar/reference/local/)، [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/)
