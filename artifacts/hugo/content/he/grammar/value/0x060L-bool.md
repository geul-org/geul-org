---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL הוא Value המייצג את הערכים הלוגיים false ו-true."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `BOOL` (מסמך מפרט BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| מסמך מפרט | `0x00000000/codecs/0x00000600/` (יעד DECLARE `0600`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 0 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | false או true ב-WORD קבוע אחד |
| בצד Hugo | `value/numeric/bool.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | ערך גולמי, WORD אחד |  | `0x0000` false, `0x0001` true |

BOOL הוא Value המייצג את הערכים הלוגיים false ו-true. קוד ישיר של Value הוא `0x060L`, משפחה NUMERIC. זהו טיפוס שונה מ-SIGNED-INTEGER ומ-UNSIGNED-INTEGER, המכילים את המספרים 0 ו-1.

## פריסה {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  סך הכול 2 WORD
Payload           1 WORD  Boolean Code
```

## פירוש ותוקף {#해석과-유효성}

- Payload `0000` הוא false, ו-`0001` הוא true.
- אין padding ואין descriptor.
- ה-Payload הוא בדיוק `0000` או `0001`. כל ערך אחר של 16 סיביות נדחה כ-invalid.
- כל ייצוג Length אחר נדחה כ-invalid.

## אורך {#길이}

- הסך הכול הוא בדיוק 2 WORD, TAG אחד ו-Payload אחד, ונעשה שימוש באורך הישיר `LLLL=0001`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו WORD אחד בדיוק, הוא נדחה.

## דוגמה {#예시}

| רשומה שלמה (TAG + Payload) | Payload | קביעה |
|---|---|---|
| `0601 0000` | `0000` | false, קנוני |
| `0601 0001` | `0001` | true, קנוני |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG ש-Length שלו אינו `0001` + `0000` או `0001` | `0000` או `0001` | invalid |

## מעמד הפורמט {#형식-지위}

- ייצוג זה, המצמיד מילת code של 16 סיביות (`0000`/`0001`) ל-TAG של GEUL, הוא scalar profile ייחודי ל-GEUL.
- הערך הלוגי עצמו אוניברסלי, אך אין טענה לתקן תעשייתי יחיד התואם לייצוג של WORD אחד זה.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000600/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
