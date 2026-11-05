---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION היא Edge של היגד שמחברת ל-Subject תיאור אחד בשפה מסוימת בתור Object."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DESCRIPTION` (BIND במסמך המפרט `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| מסמך מפרט | `0x00000000/codecs/0x00000A60/` (יעד DECLARE‏ `0A60`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 6 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | חיבור של תיאור (description) בשפה ל-Subject. הפריסה זהה ל-LABEL |
| בצד Hugo | `edge/description.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | `0780` UTF8-LANGUAGE-TEXT, ‏`0790` UTF8-LANGUAGE-TEXT, ‏`0050` LOCAL |  |

DESCRIPTION היא Edge של היגד שמחברת ל-Subject תיאור אחד בשפה מסוימת בתור Object. Codec‏ `0x0A6L`.

התיאור הוא ביטוי קצר שמבחין את היעד (description של Wikidata, למשל: “בירת גרמניה והעיר הגדולה בה”). הוא אינו הגדרה של היעד ואינו טענה. טענה על היעד נכתבת כ-[TRIPLE](0x0AAL-triple.md). הפריסה זהה ל-[LABEL](0x0A4L-label.md). התיאור והשפה שלו נכנסים ל-Object אחד, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). אין שדה של ערך גולמי.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותוקף {#해석과-유효성}

- הכללים של ה-Subject וה-Object זהים ל-[LABEL](0x0A4L-label.md). ה-Subject הוא רשומת Reference שלמה אחת בדיוק. ה-Object הוא רשומת UTF8-LANGUAGE-TEXT ‏(`0x078L`·`0x079L`) שלמה אחת בדיוק, או LOCAL Reference שנפתר ל-UTF8-LANGUAGE-TEXT באמצעות קשירת [REFERENCE-NODE](0x0A0L-reference-node.md) באותו מסמך.
- טקסט בלי שפה (UTF8-TEXT) אינו יכול להיות DESCRIPTION. התיאור הוא אחד לכל שפה, ולכן הכלל הזה מתקיים רק כשיש שפה. תיאור משותף לכמה שפות נכתב עם השפה `mul`.
- לאותו Subject ואותה שפה יש לכל היותר DESCRIPTION אחד.
- התיאור משמש להבחנה בין יעדים בעלי אותו שם. רצוי שזוג LABEL ו-DESCRIPTION באותה שפה לא יחזור בשני יעדים, אך המפרט אינו בודק זאת (גם ב-Wikidata זו רק המלצה ולא אכיפה).
- מסמך המפרט של geul.org מגביל את ה-Object באמצעות [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, כמו ב-LABEL).

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

- מספר בתי השפה והטקסט של ה-Object הוא באחריות רשומת ה-Object. הסמן אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Edge.
- תיאור ארוך מ-label, ולכן קל לחרוג מ-15 WORD גם ב-Object וגם ב-Edge. אז משתמשים ב-Length extension ([רשומה](../record.md)).

## דוגמה (לא נורמטיבית) {#예시-비규범}

Edge Id הוא `0009`, ה-Subject הוא Q64 (‏`0141 0040`), וה-Object הוא `capital and largest city of Germany` (en). השפה היא דוגמה בפורמט LANGUAGE-BCP47-CODE (ל-`en` יש מספר רישום `0x0784`, ולכן אפשר להשתמש גם ב-SHORT-CODE).

- ה-Object: השפה `0761 656E` (BCP47 ‏`en`, ‏2 WORD) + טקסט של 35 בתים (אי-זוגי, 18 WORD), לכן `0x079L`, ‏TAG 1 + extension TAG 1 + 20 = 22 WORD, ‏`079E 0016 …`.
- ה-Edge הוא TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, לכן `LLLL=1110`, ה-TAG הוא `0A6E` וה-extension TAG הוא `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## התאמה ל-Wikidata {#위키데이터-대응}

- ה-`descriptions` של פריט (אחד לכל שפה) ← DESCRIPTION אחד לכל שפה. קוד השפה מומר לפי אותה טבלת התאמה של קודי שפה כמו ב-LABEL.

## בעיות פתוחות {#열린-문제}

- האם יש מקרים שבהם כדאי לאפשר תיאור UTF8-TEXT בלי שפה (כרגע אינו מותר).

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A60/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
