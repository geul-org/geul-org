---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS היא Edge של היגד שמחברת ל-Subject שם נוסף (כינוי) אחד בתור Object."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `ALIAS` (BIND במסמך המפרט `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| מסמך מפרט | `0x00000000/codecs/0x00000A50/` (יעד DECLARE‏ `0A50`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 5 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | חיבור של שם נוסף (כינוי) ל-Subject. הפריסה זהה ל-LABEL |
| בצד Hugo | `edge/alias.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | `0780` UTF8-LANGUAGE-TEXT, ‏`0790` UTF8-LANGUAGE-TEXT, ‏`0050` LOCAL |  |

ALIAS היא Edge של היגד שמחברת ל-Subject שם נוסף (כינוי) אחד בתור Object. Codec‏ `0x0A5L`.

[LABEL](0x0A4L-label.md) הוא השם המייצג בשפה (לכל היותר אחד לכל שפה), ו-ALIAS הוא שם נוסף של אותו יעד (כמה לכל שפה, ב-Wikidata: “also known as”). משמש בעיקר לחיפוש. הפריסה והתוקף זהים ל-LABEL.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותוקף {#해석과-유효성}

- הכללים של ה-Subject וה-Object זהים ל-[LABEL](0x0A4L-label.md) (ה-Object הוא [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) או LOCAL שנפתר אליו).
- אפשר להציב כמה ALIAS לאותו Subject ואותה שפה. הסדר הוא הסדר במסמך.
- אין להציב כ-ALIAS טקסט זהה ל-LABEL של אותו Subject ואותה שפה (LABEL אחד מספיק כשם מייצג). כלל זה הוא המלצה.
- מסמך המפרט של geul.org מגביל את ה-Object באמצעות [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, כמו ב-LABEL).

## דוגמה (לא נורמטיבית) {#예시-비규범}

Edge Id הוא `0003`, ה-Subject הוא Q42 (‏`0141 002A`), וה-Object הוא `DNA` (en): השפה `0761 656E` (BCP47 ‏`en`) + טקסט של 3 בתים (אי-זוגי) ← `UTF8-LANGUAGE-TEXT-ODD` ‏(`0x079L`), ‏`0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, ‏`LLLL=1001`. ה-TAG הוא `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A50/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
