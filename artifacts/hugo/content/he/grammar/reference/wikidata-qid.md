---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID הוא Reference מסוג הצהרה שמצביע על פריט (Item) של Wikidata לפי המספר של ה-ID שלו, Q."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID הוא Reference מסוג הצהרה שמצביע על פריט (Item) של Wikidata. כותבים את החלק המספרי של ה-ID של Q, בלי ה-`Q`, כמספר שלם unsigned.

## פריסה

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length extension TAG]
QID               unsigned big-endian ברוחב הקצר ביותר
```

- ה-QID נכתב ברוחב הקצר ביותר. `Q1`~`Q65535` הם 2 WORD בסך הכול, ומעל זה 3 WORD.
- הנתונים של Wikidata הם CC0.
- אם זה Variable, זהו משתנה אנונימי מהסוג שהפריט מייצג (Variable ב-[Reference](/he/grammar/reference/)).

## דוגמה

| פריט | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [WIKIDATA-PID](/he/grammar/reference/wikidata-pid/), [TRIPLE](/he/grammar/edge/triple/)
