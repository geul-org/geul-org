---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את סיבת השינוי (git commit message)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `MESSAGE` (BIND של מסמך מפרט: `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| מסמך מפרט | `0x00000000/codecs/0x00001D90/` (יעד DECLARE: `1D90`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 25 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | סיבת השינוי. Value מסוג UTF8-LANGUAGE-TEXT, אחד לכל שפה (git commit message) |
| בצד Hugo | `meta/lineage/message.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | רשומה | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

רושם את סיבת השינוי (git commit message).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[TAG הרחבה של Length]
הודעה             Value אחד מסוג UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x1D9L`, מחלקת שושלת
- Payload: Value מובנה ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- מספר: לכל היותר אחד לכל שפה

## פירוש ותוקף {#해석과-유효성}

- ההודעה והשפה נכנסות יחד ב-UTF8-LANGUAGE-TEXT אחד. לאותה שפה יש MESSAGE אחד.
- מסמך המפרט של geul.org נכתב ב-[CODEC](../edge/0x0BEL-codec.md) `0780` ו-`0790`.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D90/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
