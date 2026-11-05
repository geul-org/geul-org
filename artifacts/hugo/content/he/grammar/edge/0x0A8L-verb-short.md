---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT היא הצורה המקוצרת של VERB, ה-Edge של היגד פועלי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT היא הצורה המקוצרת של [VERB](0x0A9L-verb.md), ה-Edge של היגד פועלי. `-SHORT` והצורה הרגילה מוצבים כזוג זוגי-אי-זוגי ([Edge](_index.md#서술-edge)).

| פריט | ערך |
|---|---|
| שם | `VERB-SHORT` (BIND במסמך המפרט `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| מסמך מפרט | `0x00000000/codecs/0x00000A80/` (יעד DECLARE‏ `0A80`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 8 |
| Kind | Edge · משפחה: היגד, קבוצה: טענה |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קיצור של היגד פועלי |
| בצד Hugo | `edge/_index.md` |

## פריסה {#레이아웃}

הפריסה טרם נקבעה. היא נשענת על הפריסה המשותפת של Edge (TAG, [Length extension TAG], Edge Id, רכיבים) ([Edge](_index.md#레이아웃)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. במסמך ה-Codec יש רק DECLARE (יעד `0A80`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A80/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
