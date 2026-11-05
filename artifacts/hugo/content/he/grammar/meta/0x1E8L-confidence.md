---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "רושם את מידת האמינות של המסמך כולו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `CONFIDENCE` (BIND של מסמך מפרט: `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| מסמך מפרט | `0x00000000/codecs/0x00001E80/` (יעד DECLARE: `1E80`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 8 |
| Kind | Meta · מחלקה: אימות |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מידת אמינות |
| בצד Hugo | `meta/verification/confidence.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | רשומה | `0690` UNSIGNED-DECIMAL |  |

רושם את מידת האמינות של המסמך כולו. אמינות ברמת רשומה נכתבת כ-QUALIFIER שמוצמד ל-Edge היעד (המאפיין טרם נקבע, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[TAG הרחבה של Length]
Payload           Value מסוג UNSIGNED-DECIMAL, מ-0 עד 1 כולל
```

- Codec: Meta `0x1E8L`, מחלקת אימות
- Payload: Value מובנה ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מי קבע את הערך נרשם יחד איתו, למשל ב-[GENERATED-BY](0x1D3L-generated-by.md).

## בעיות פתוחות {#열린-문제}

- הסקאלה (0 עד 1) והקשר לפסק הדין של TOULMIN.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E80/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
