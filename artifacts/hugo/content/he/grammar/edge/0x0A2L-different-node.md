---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE היא Edge של היגד אי-זהות שמצהירה ששני Reference מצביעים על referent-ים שונים."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DIFFERENT-NODE` (BIND במסמך המפרט `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| מסמך מפרט | `0x00000000/codecs/0x00000A20/` (יעד DECLARE‏ `0A20`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 2 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | אי-זהות: שני Reference מצביעים על יעדים שונים זה מזה |
| בצד Hugo | `edge/different-node.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `object` | #3 | רשומה | כל רשומה (פרט לסמן מקום) |  |

DIFFERENT-NODE היא Edge של היגד אי-זהות שמצהירה ששני Reference מצביעים על referent-ים שונים. Codec‏ `0x0A2L`.

אין פירושו שקידוד הבתים, ה-Codec וה-ID של שתי רשומות ה-Reference שונים. יש להבדיל בינה לבין הקשירה המכוונת של [REFERENCE-NODE](0x0A0L-reference-node.md) ולבין הזהות של [SAME-NODE](0x0A1L-same-node.md).

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            רשומת Reference אחת
```

## פירוש ותוקף {#해석과-유효성}

- ה-Subject וה-Object חייבים להיות כל אחד רשומת [Reference](../reference/_index.md) שלמה אחת בדיוק. הגבולות נקבעים לפי ה-Length של כל רשומה, ואם הוא Value או Edge או שאינו שלם, הוא invalid.
- ה-Subject וה-Object מצביעים על referent-ים שונים. אין להסיק שה-referent שונה רק מהבדל ברצף הבתים, ב-Codec או ב-ID של רשומות ה-Reference.
- בפרט, LOCAL ID-ים שונים ([LOCAL](../reference/0x005L-local.md)) הם רק Reference-ים שונים, ואין פירושם שה-referent במציאות שונה. אין להסיק DIFFERENT מהבדל ב-LOCAL ID בלבד.
- אי-זהות היא סימטרית, אנטי-רפלקסיבית ואינה טרנזיטיבית. `DIFFERENT(A, B)` הוא אותו יחס כמו `DIFFERENT(B, A)`. אולם מתוך `DIFFERENT(A, B)` ו-`DIFFERENT(B, C)` אין להסיק `DIFFERENT(A, C)`.
- סדר ה-Subject/Object ב-wire הוא רק סדר סידרוּת (serialization) ל-framing ואינו יוצר כיוון של משמעות. המימוש חייב להיות מסוגל לעבור על היחס בשני הכיוונים.
- הסמן אחרי קריאת שני הרכיבים חייב להתלכד בדיוק עם סוף ה-Edge.

היחס עצמו אנטי-רפלקסיבי, אך אין למחוק כשגיאת דקדוק של wire טענת `DIFFERENT(A, A)` שתקינה מבחינה מבנית, או טענות שבהן SAME ו-DIFFERENT מתנגשים. טענות כאלה משמרות את ההקשר והשושלת ומטופלות כסתירה בשכבת פסק הדין. כשמפרשים או מסיקים DIFFERENT, משמרים את המקור, הזמן, ה-world וה-policy scope של המסמך שמכיל את ה-Edge, ולא מרחיבים למסקנה גלובלית שמתעלמת מהם.

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_object WORD
```

## דוגמה (לא נורמטיבית) {#예시-비규범}

Edge Id הוא `000A`, ה-Subject הוא LOCAL 1, וה-Object הוא LOCAL 2.

- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, ‏`LLLL=0110`. ה-TAG הוא `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

ההבדל ב-LOCAL ID בדוגמה זו נועד רק להראות את הקידוד. הרצף הזה הופך ל-DIFFERENT-NODE רק כשיש טענה נפרדת ש-ID 1 ו-ID 2 מצביעים על referent-ים שונים.

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A20/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
