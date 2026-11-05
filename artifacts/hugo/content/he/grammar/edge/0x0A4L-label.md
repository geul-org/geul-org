---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL היא Edge של היגד שמחברת ל-Subject שם (label) אחד בשפה מסוימת בתור Object."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `LABEL` (BIND במסמך המפרט `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| מסמך מפרט | `0x00000000/codecs/0x00000A40/` (יעד DECLARE‏ `0A40`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 4 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | חיבור של שם (label) בשפה ל-Subject. ה-Object הוא UTF8-LANGUAGE-TEXT |
| בצד Hugo | `edge/label.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | `0780` UTF8-LANGUAGE-TEXT, ‏`0790` UTF8-LANGUAGE-TEXT, ‏`0050` LOCAL |  |

LABEL היא Edge של היגד שמחברת ל-Subject שם (label) אחד בשפה מסוימת בתור Object. Codec‏ `0x0A4L`. זו אינה Edge שמבטאת lemma במובן של לקסיקוגרפיה כללית.

השם והשפה שלו נכנסים ל-Object אחד, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). אין שדה של ערך גולמי.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותוקף {#해석과-유효성}

- ה-Subject הוא רשומת Reference שלמה אחת בדיוק. גבולותיו נקבעים לפי ה-Length של ה-Subject עצמו, ואם אינו Reference או שאינו שלם, הוא invalid.
- ה-Object הוא רשומת [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`) שלמה אחת בדיוק. כללי השפה והטקסט (שני פורמטי השפה מותרים, השוואת שפות זהות) נקבעים לפי אותו פורמט.
- ב-Object יכול לבוא גם LOCAL Reference. במקרה זה הוא חייב להיפתר ל-UTF8-LANGUAGE-TEXT באמצעות קשירת [REFERENCE-NODE](0x0A0L-reference-node.md) באותו מסמך. אם אינו נפתר, או נפתר ליעד מסוג אחר, הוא invalid.
- מסמך המפרט של geul.org כותב אילוץ זה באמצעות [CODEC](0x0BEL-codec.md) (Object = ‏`0780`·`0790`·`0050`). היעד שאליו LOCAL נפתר אינו מובע באמצעות CODEC.
- אם ה-Object אינו אחד משני הפורמטים הנ"ל, או שהרשומה אינה שלמה, הוא invalid. טקסט בלי שפה (UTF8-TEXT) אינו יכול להיות LABEL. שם למכונה בלי שפה נכתב באמצעות [BIND](0x0A3L-bind.md). שם משותף לכמה שפות נכתב עם השפה `mul`.
- לאותו Subject ואותה שפה יש לכל היותר LABEL אחת. שמות נוספים נכתבים כ-[ALIAS](0x0A5L-alias.md).

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

- מספר בתי השפה והטקסט של ה-Object אינו באחריות ה-Edge אלא באחריות רשומת ה-Object. הסמן אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Edge.

## דוגמה (לא נורמטיבית) {#예시-비규범}

קוד השפה `0784` של `en` הוא מספר ב-GEUL Language Registry v2 (מסמך מפרט `0x00000000/codecs/0x000007A0`, גרסה 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id הוא `0007`, ה-Subject הוא Q22686 (‏`0141 589E`), וה-Object הוא `Donald Trump` (en).

- ה-Object: השפה `07A1 0784` (SHORT-CODE, ‏2 WORD) + טקסט של 12 בתים (זוגי, 6 WORD), לכן `UTF8-LANGUAGE-TEXT-EVEN` ‏(`0x078L`), בסך הכול 9 WORD: ‏`0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, ‏`LLLL=1101`. ה-TAG הוא `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id הוא `0008`, ה-Subject הוא Q155 (‏`0141 009B`), וה-Object הוא `Brasil` (pt-BR).

- ה-Object: השפה `0773 7074 2D42 5200` (BCP47 ‏`pt-BR`, ‏4 WORD) + טקסט של 6 בתים (זוגי, 3 WORD), בסך הכול 8 WORD: ‏`0787 0773 7074 2D42 5200 4272 6173 696C`.
- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, ‏`LLLL=1100`. ה-TAG הוא `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A40/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
