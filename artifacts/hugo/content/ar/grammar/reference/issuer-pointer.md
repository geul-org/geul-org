---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER هو Reference إشارة وتصريح يشير إلى Issuer نفسه. Payload هو Issuer واحد فقط."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER هو Reference إشارة وتصريح يشير إلى Issuer نفسه. يكون هدفاً لاسم Issuer `BIND` و`LABEL` وEdge الأحكام.

## التخطيط

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length ممتد TAG]
Issuer            1/2/4/16 WORD
```

- عرض Issuer هو Payload كله. لا يقسّم Codec العرض. وإذا لم يكن العرض 1 أو 2 أو 4 أو 16 WORD، أو كانت قيمة Issuer تتسع في عرض أضيق، فهو invalid (الصيغة القياسية لـ Issuer).
- إذا كان Issuer من 16 WORD فالمجموع 17 WORD فيُضاف Length ممتد من 1 WORD.
- Quantifier هو `000` (Identified) فقط. أي قيمة أخرى invalid.
- قيمة Issuer تتبع تخصيصات [Issuer](/ar/grammar/issuer/).
- موضع الاستخدام: Subject في BIND في فهرس أسماء Issuer `issuers.geul` ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#اسم-issuer))، وLABEL لاسم عرض Issuer، والأحكام على Issuer، والموقِّع، وغيرها من المواضع التي يكون فيها Issuer نفسه هو الهدف.
- الصيغة التي تشير إلى Issuer نفسه هي ISSUER-POINTER وحده. الإشارة إلى Issuer بـ `EXTERNAL-ISSUER-*` مع معرّف مستند `0` ومعرّف هدف `0` هي invalid.

## أمثلة

| Issuer | تسلسل WORD |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [DOC-POINTER](/ar/grammar/reference/doc-pointer/)، [EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/)، [Issuer والنشر](/ar/grammar/issuer/)
