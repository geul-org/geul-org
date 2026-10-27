---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER هو Reference إشارة وتصريح يشير إلى إصدار واحد من مستند نشره Issuer. معرّف الإصدار 0 هو الإصدار الأحدث."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER هو Reference إشارة وتصريح يشير إلى إصدار واحد من مستند نشره Issuer. يكون موضوع نشر المستند وإهماله (deprecate) وحذفه والإصدار المقتبس والكلام عن المستند.

## التخطيط

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length ممتد TAG]
Issuer            1/2/4/16 WORD
معرّف المستند     4 WORD
معرّف الإصدار     2 WORD
```

## التفسير والصلاحية

- عرض Issuer هو ما بقي من Payload بعد طرح معرّف المستند ومعرّف الإصدار (6 WORD). لا يقسّم Codec العرض. وإذا لم يكن العرض 1 أو 2 أو 4 أو 16 WORD، أو كانت قيمة Issuer تتسع في عرض أضيق، فهو invalid (الصيغة القياسية لـ Issuer).
- لا يُحذف معرّف الإصدار. فلو سُمح بحذفه لما أمكن تحديد عرض Issuer من طول Payload وحده (Issuer من 4 WORD بلا إصدار وIssuer من 2 WORD مع إصدار كلاهما 8 WORD).
- معرّف الإصدار `0` هو الإصدار الأحدث. يرتبط بالإصدار الحالي وقت التفسير. وبقية القيم تثبَّت على ذلك الإصدار ([PUBLICATION](/ar/grammar/edge/publication/)).
- معرّف المستند `0` هو مستند فهرس تعريف مصطلحات Issuer. ويُشار إلى Issuer نفسه بـ [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/).
- Quantifier هو `000` (Identified) فقط. أي قيمة أخرى invalid.
- الصيغة التي تشير إلى مستند Issuer هي DOC-POINTER وحده. الإشارة إلى مستند بـ `EXTERNAL-ISSUER-*` (Issuer، ومعرّف المستند، ومعرّف الهدف `0`) أو `EXTERNAL-POINTER-*` (IMPORT ID، ومعرّف الهدف `0`) هي invalid.
- موضع الاستخدام: Meta [DOC-ID](/ar/grammar/meta/declaration/doc-id/) و[IMPORT-DOC](/ar/grammar/meta/import/import-doc/)، وPUBLICATION وDEPRECATION وTOMBSTONE في قائمة الإصدارات، وSubject في BIND، وSubject في BIND في فهرس الأسماء `documents.geul`.

## أمثلة

مستند GEUL Issuer `0x0000` ورقمه `0xffff000000000001`.

| الإصدار | تسلسل WORD |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| الأحدث (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG (1) + Issuer (1) + معرّف المستند (4) + معرّف الإصدار (2) = 8 WORD و`LLLL=0111`. وTAG هو `0000 0 0111 0111 000` = `03B8`.

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/)، [EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/)، [PUBLICATION](/ar/grammar/edge/publication/)
- [Issuer والنشر](/ar/grammar/issuer/)
