---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE היא Edge של היגד זהות, בלי כיוון, שמצהירה ששני Reference מצביעים על אותו referent."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SAME-NODE` (BIND במסמך המפרט `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| מסמך מפרט | `0x00000000/codecs/0x00000A10/` (יעד DECLARE‏ `0A10`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 1 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | זהות: שני Reference מצביעים על אותו יעד |
| בצד Hugo | `edge/same-node.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | כל רשומה (פרט לסמן מקום) |  |

SAME-NODE היא Edge של היגד זהות, בלי כיוון, שמצהירה ששני Reference מצביעים על אותו referent. Codec‏ `0x0A1L`.

אין פירושו שקידוד הבתים, ה-Codec וה-ID של שתי רשומות ה-Reference זהים. בעוד ש-[REFERENCE-NODE](0x0A0L-reference-node.md) היא קשירה מכוונת מסוג `Reference → רשומה`, SAME-NODE מבטאת זהות (referential identity) בין שני Reference.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference אחת
```

## פירוש ותוקף {#해석과-유효성}

- ה-Subject וה-Object מסודרים בסדר זה, וכל אחד מהם חייב להיות רשומת [Reference](../reference/_index.md) שלמה אחת בדיוק. הגבולות נקבעים לפי ה-Length של כל רשומה.
- אם ה-Subject או ה-Object הוא Value, Edge או רשומה לא שלמה, הוא invalid.
- היחס SAME-NODE הוא רפלקסיבי, סימטרי וטרנזיטיבי. סדר ה-Subject/Object ב-wire נועד ל-framing ואינו יוצר כיוון של משמעות. המימוש חייב להיות מסוגל לעבור על היחס בשני הכיוונים.
- [LOCAL](../reference/0x005L-local.md) ID-ים שונים הם רק Reference-ים שונים, ואינם הוכחה לכך שה-referent זהה או שונה. הדרך לקבוע ששני Reference מצביעים על אותו referent היא SAME-NODE.
- פירוש והסקה חייבים לשמר את המקור, הזמן, ה-world וה-policy scope של המסמך שמכיל את ה-Edge ושל גרף פסק הדין. אין להשתמש ב-SAME-NODE כבסיס למיזוג גלובלי שאינו תלוי בהקשר.
- גם כאשר יש SAME-NODE, אין למחוק או לדרוס את רשומת ה-Reference המקורית או את השושלת.
- אם לאותו זוג יש גם SAME-NODE וגם [DIFFERENT-NODE](0x0A2L-different-node.md), ה-wire אינו invalid. מעריכים זאת כסתירה תוך שימור ההקשר של כל טענה.
- מחברים Variable Reference ל-Identified Reference באמצעות SAME-NODE כדי לפתור את המשתנה ([Reference](../reference/_index.md) Variable).

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

## דוגמה (לא נורמטיבית) {#예시-비규범}

Edge Id הוא `0009`, ה-Subject הוא LOCAL 1, וה-Object הוא LOCAL 2.

- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, ‏`LLLL=0110`. ה-TAG הוא `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A10/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
