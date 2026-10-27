---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC هو Meta من فئة IMPORT يشير إلى مستند خارجي بـ DOC-POINTER ويخصص له IMPORT ID."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يستورد مستنداً خارجياً بـ IMPORT ID. يشير [DOC-POINTER](/ar/grammar/reference/doc-pointer/) إلى المستند المراد استيراده، ويحمل DOC-POINTER أيضاً عرض Issuer.

## التخطيط

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length ممتد TAG]
المستند           سجل Reference من نوع DOC-POINTER (Issuer ومعرّف المستند ومعرّف الإصدار. الإصدار 0 هو الأحدث)
IMPORT ID         كل الباقي. unsigned بأقصر عرض
```

- Codec: Meta `0x60`، فئة IMPORT (`110`)
- Payload: Reference مضمّن `DOC-POINTER` (Issuer ومعرّف المستند ومعرّف الإصدار) + قيمة خام IMPORT ID
- العدد: يمكن أكثر من واحد (واحد لكل IMPORT ID)

## التفسير والصلاحية

- المستند هو سجل DOC-POINTER واحد بالضبط. وينتهي بـ Length الخاص به، والباقي هو IMPORT ID.
- IMPORT ID من 1 WORD فأكثر بأقصر عرض. وعرض IMPORT ID هنا يحدده طول السجل، وفي [EXTERNAL-POINTER-*](/ar/grammar/reference/external-pointer/) يحدده Codec. وIMPORT ID صالح داخل ذلك المستند فقط.
- لا يُخصَّص IMPORT ID نفسه مرتين في مستند واحد.
- إذا كُتب معرّف الإصدار ارتبط بذلك الإصدار، وإذا كان `0` ارتبط بأحدث إصدار وقت التفسير (أو بالإصدار الساري في الوقت المحدد) ([المراجعة](/ar/grammar/document/#المراجعة)).
- [EXTERNAL-POINTER-*](/ar/grammar/reference/external-pointer/) في BODY يشير إلى LOCAL في المستند الذي استُورد بـ IMPORT ID. ويُشار إلى المستند المستورد نفسه بـ DOC-POINTER.
- لا يُستورد HEAD المستند المستورد. ويُفسَّر هدف ذلك المستند بتصريحات ذلك المستند.
- لا يمكن البحث عبر المستندات بـ IMPORT ID. والمستودع الذي يحمّل عدة مستندات يفكّ IMPORT ID إلى المسار الكامل (Issuer ومعرّف المستند ومعرّف الإصدار وLOCAL ID) ويخزّنه.

## أمثلة

- IMPORT ID 1، وIssuer `0x0001`، والمستند `0x…0002`، والأحدث: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG الـ Meta (1) + DOC-POINTER (8) + IMPORT ID (1) = 10 WORD)
