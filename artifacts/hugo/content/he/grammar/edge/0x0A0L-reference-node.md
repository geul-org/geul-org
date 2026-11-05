---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE היא Edge של היגד מכוון שמחברת Reference אחד לרשומת Object אחת, ומגדירה או קושרת מהו אותו Reference."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `REFERENCE-NODE` (BIND במסמך המפרט `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| מסמך מפרט | `0x00000000/codecs/0x00000A00/` (יעד DECLARE‏ `0A00`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 0 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קשירה מכוונת שבה ה-Subject, שהוא Reference, מצביע על ה-Object |
| בצד Hugo | `edge/reference-node.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference), `060F` קטע 3 כולו (תו כללי, Value), `080F` קטע 4 כולו (תו כללי, Value) |  |

REFERENCE-NODE היא Edge של היגד מכוון שמחברת Reference אחד לרשומת Object אחת, ומגדירה או קושרת מהו אותו Reference. Codec‏ `0x0A0L`.

ה-Subject מצביע על ה-Object. קשירה זו אינה [SAME-NODE](0x0A1L-same-node.md), שטוענת זהות מבחינת המשמעות, ואינה אומרת שהבתים של שתי הרשומות זהים.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference או Value אחת
```

## פירוש ותוקף {#해석과-유효성}

- ה-Subject חייב להיות רשומת [Reference](../reference/_index.md) שלמה אחת בדיוק. גבולותיו נקבעים לפי ה-Length של ה-Subject עצמו, ואם אינו Reference או שאינו שלם, הוא invalid.
- ה-Object חייב להיות רשומת Reference או Value שלמה אחת בדיוק. גבולותיו נקבעים לפי ה-Length של ה-Object עצמו, ואם הוא Edge או Meta או שאינו שלם, הוא invalid.
- אם ה-Object הוא Reference, שרשרת ה-Reference שעוקבים אחריה דרך קשירות REFERENCE-NODE אסור שתהיה מעגלית, ו-LOCAL חייב להיפתר בסופו של דבר. מעגל בפתרון ו-LOCAL תלוי באוויר (dangling) הם invalid.
- אם LOCAL ID אחד במסמך אחד נקשר ל-Object-ים סותרים, הוא invalid. תחום ה-LOCAL, ה-ID, הרוחב המינימלי וכללי המיזוג נקבעים לפי [LOCAL](../reference/0x005L-local.md).
- לא כל Reference חייב להיקשר באמצעות REFERENCE-NODE.
- השימוש הטיפוסי הוא `LOCAL → UTF8-LANGUAGE-TEXT`. כאשר ה-Object של [LABEL](0x0A4L-label.md) הוא LOCAL, הטקסט נפתר באמצעות קשירה זו באותו מסמך.

אסור לפרש הפוך את הכיוון שבו ה-Subject מצביע על ה-Object. המשמעות והכללים המפורטים של SAME ושל DIFFERENT נקבעים בנפרד בכל אחד מהפורמטים שלהם.

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` הוא מספר ה-WORD של ה-Length extension TAG, `N_id` הוא מספר ה-WORD של רשומת ה-LOCAL של Edge Id, ו-`N_subject` ו-`N_object` הם מספר ה-WORD הכולל של כל רשומה. הסמן אחרי קריאת ה-Subject וה-Object חייב להתלכד בדיוק עם סוף ה-Edge.

## דוגמה (לא נורמטיבית) {#예시-비규범}

Edge Id הוא `0008`, ה-Subject הוא LOCAL 1, וה-Object הוא [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) של `Donald Trump` (en).

- ה-Edge Id הוא `0051 0008`, כלומר 2 WORD.
- ה-Subject הוא `0051 0001`, כלומר 2 WORD.
- ה-Object: השפה `0761 656E` (BCP47 ‏`en`) + טקסט של 12 בתים (זוגי), לכן `UTF8-LANGUAGE-TEXT-EVEN` ‏(`0x078L`), בסך הכול 9 WORD. ה-TAG הוא `0788`.
- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, ‏`LLLL=1101`. ה-TAG הוא `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A00/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
