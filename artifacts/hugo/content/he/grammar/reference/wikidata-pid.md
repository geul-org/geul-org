---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID הוא Reference מסוג הצהרה שמצביע על מאפיין (Property) של Wikidata לפי המספר של ה-ID שלו, P."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID הוא Reference מסוג הצהרה שמצביע על מאפיין (Property) של Wikidata. כותבים את החלק המספרי של ה-ID של P, בלי ה-`P`, כמספר שלם unsigned.

## פריסה

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length extension TAG]
PID               unsigned big-endian ברוחב הקצר ביותר
```

- ה-PID נכתב ברוחב הקצר ביותר. מספרי המאפיינים כיום נכנסים ב-WORD אחד, כלומר 2 WORD בסך הכול, ומעל 65535 הם גדלים באופן טבעי ל-3 WORD.
- משמש בעיקר במקום של Predicate ב-[TRIPLE](/he/grammar/edge/triple/) ובמקום של Property ב-[QUALIFIER](/he/grammar/edge/qualifier/).

## דוגמה

| מאפיין | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/), [TRIPLE](/he/grammar/edge/triple/), [QUALIFIER](/he/grammar/edge/qualifier/)
