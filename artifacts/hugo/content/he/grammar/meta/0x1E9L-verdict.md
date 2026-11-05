---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "רושם את תוצאת פסק הדין של המסמך כולו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `VERDICT` (BIND של מסמך מפרט: `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| מסמך מפרט | `0x00000000/codecs/0x00001E90/` (יעד DECLARE: `1E90`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 9 |
| Kind | Meta · מחלקה: אימות |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תוצאת פסק דין של המסמך כולו. Pass, Review, Fail. ברמת צומת או רשומה: [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| בצד Hugo | `meta/verification/verdict.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | ערך גולמי, 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

רושם את תוצאת פסק הדין של המסמך כולו. פסק דין ברמת צומת או רשומה הוא תפקידו של [TOULMIN](../toulmin/_index.md) ‏`VERDICT` (Edge ‏`0x118L`).

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[TAG הרחבה של Length]
פסק דין          WORD אחד (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, מחלקת אימות
- Payload: ערך גולמי (פסק דין, WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מכיוון שזו מחלקת אימות, היא אינה נכללת ב-hash התוכן.
- פסק דין על מסמך אחר מוצב ב-BODY של מסמך שאינו מושא פסק הדין.

## בעיות פתוחות {#열린-문제}

- האם לרשום יחד את הגורם שנתן את פסק הדין ואת עילתו.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E90/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
