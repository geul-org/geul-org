---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER هو Reference إشارة يشير إلى معرّف LOCAL في مستند استُورد بـ IMPORT-DOC في HEAD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER هو Reference إشارة يشير إلى معرّف LOCAL في مستند استُورد بـ [IMPORT-DOC](/ar/grammar/meta/import/import-doc/) في HEAD.

## التخطيط

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length ممتد TAG]
IMPORT ID         العرض الذي يحدده WW (00=1 و01=2 و10=4 و11=8 WORD)
معرّف الهدف       كل الباقي. معرّف LOCAL في المستند المستورد، بأقصر عرض
```

| CCCC | الاسم | عرض IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- يُستخدم أضيق Codec تتسع له قيمة IMPORT ID.
- IMPORT ID قيمة خصصها `IMPORT-DOC` في هذا المستند وهي صالحة داخل هذا المستند فقط. لا يُكتب Issuer في EXTERNAL-POINTER. فيُؤخذ Issuer ومعرّف المستند من ذلك `IMPORT-DOC`. والإصدار أيضاً يحدده ذلك `IMPORT-DOC` (مثبَّت أو الأحدث).
- إذا كان معرّف LOCAL في المستند المستورد هو نفسه، فهو الهدف نفسه سواء كُتب في ذلك المستند بـ LOCAL أو هنا بـ EXTERNAL-POINTER.
- إذا كان Variable فهو متغير LOCAL في المستند المستورد.

## الصلاحية

- يكون invalid إذا لم يوجد في هذا المستند `IMPORT-DOC` يخصص IMPORT ID ذاك.
- يُرفض بوصفه non-minimal إذا كان IMPORT ID يتسع في Codec أضيق واستُخدم Codec أوسع.
- يكون invalid إذا كان معرّف الهدف `0`. ويُشار إلى المستند المستورد نفسه بـ [DOC-POINTER](/ar/grammar/reference/doc-pointer/).
- تُحظر `0x0000` WORD في بداية معرّف الهدف.

## أمثلة

| الهدف | تسلسل WORD |
|---|---|
| LOCAL 5 في IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 في IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 في IMPORT ID 70000 | `01C8 0001 1170 0005` |

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [LOCAL](/ar/grammar/reference/local/)، [EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/)، [DOC-POINTER](/ar/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/ar/grammar/meta/import/import-doc/)
