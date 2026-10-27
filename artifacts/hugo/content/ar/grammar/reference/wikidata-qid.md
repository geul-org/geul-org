---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID هو Reference تصريح يشير إلى عنصر (Item) في ويكي بيانات بالرقم في معرّف Q."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID هو Reference تصريح يشير إلى عنصر (Item) في ويكي بيانات. يُكتب الجزء الرقمي من معرّف Q بعد حذف `Q` كعدد صحيح بلا إشارة.

## التخطيط

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length ممتد TAG]
QID               unsigned big-endian بأقصر عرض
```

- يُكتب QID بأقصر عرض. من `Q1` إلى `Q65535` المجموع 2 WORD، وما فوق ذلك 3 WORD.
- بيانات ويكي بيانات بترخيص CC0.
- إذا كان Variable فهو متغير مجهول من النوع الذي يشير إليه ذلك العنصر ([Reference](/ar/grammar/reference/) Variable).

## أمثلة

| العنصر | تسلسل WORD |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president)، Variable | `00A4 76FD` |

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [WIKIDATA-PID](/ar/grammar/reference/wikidata-pid/)، [TRIPLE](/ar/grammar/edge/triple/)
