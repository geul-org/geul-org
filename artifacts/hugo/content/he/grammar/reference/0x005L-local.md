---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL הוא Reference מצהיר המצביע על יעד באמצעות ID שהמסמך הזה הנפיק."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `LOCAL` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x005L~0x009L` |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 5~9 |
| Kind | Reference · סיווג: הצהרה |
| צד Hugo | `reference/local.md` |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

LOCAL הוא Reference מצהיר המצביע על יעד באמצעות ID שהמסמך הזה הנפיק. הוא מפנה ליעד בתוך המסמך בלי Issuer חיצוני. כדי להצביע מחוץ למסמך, מציבים במסמך את Meta [DOC-ID](../meta/0x1C7L-doc-id.md), ומסמך אחר מצביע עליו ב-Reference מכוון.

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length TAG הרחבה]
LOCAL ID          unsigned big-endian ברוחב הקצר ביותר
```

| LOCAL ID | סך הכול | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- ה-Codec הם `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal) ו-`0x009L` (Variable). ה-TAG WORD של Identified הוא `0000 0000 0101 LLLL`.
- הוא פועל לפי הכלל המשותף של Reference: כותבים את ID היעד במספר ה-WORD הקטן ביותר.

## Edge Id {#edge-id}

- ה-LOCAL שהוא האיבר הראשון ב-Payload של Edge הוא הצהרת ה-Edge Id של אותו Edge ([Edge](../edge/_index.md)). ההצהרה על Edge Id משתמשת רק ב-LOCAL מסוג Identified (`0x005L`).
- LOCAL בכל מקום אחר ב-Payload של Edge הוא אזכור. יעד המסמך הזה נכתב כ-LOCAL בכל אזכור. אין קוד מכוון נפרד להצבעה על יעד של המסמך הזה.

## הקצאת מזהים {#식별자-할당}

- ה-ID הוא מספר שלם והמקודד מקצה אותו. לגודל המספר ולסדר ההקצאה אין שום משמעות מלבד זהות.
- **UNIQUE (חובה).** במסמך אחד, LOCAL ID אחד מצביע על יעד אחד בלבד. Edge Id מוצהר פעם אחת בלבד לכל מסמך (HEAD Edge ו-BODY Edge חולקים מרחב מספרים אחד). אם יותר מ-Edge אחד מצהיר על אותו Edge Id, המסמך invalid.
- **AUTO INCREMENT (המלצה).** מקצים ID חדש כערך המרבי של ה-ID שהוקצו עד כה במסמך + 1, כך שיגדלו לפי סדר המסמך. כך גם בין גרסאות (יוצרים חדש בערך הגדול מ-ID שנמחק). זו המלצה בלבד ולא תנאי תקפות, ומסמך שה-ID שלו אינם עולים הוא valid. המפענח אינו נשען על גודל ה-ID או על רציפותו.
- ID `0` אינו מוקצה. הוא אינו מצביע על שום יעד ואינו משמש כ-Edge Id. ID של יעד מוקצים החל מ-`1`.
- מסמך מצביעים עליו, בתוך המסמך או מחוצה לו, רק באמצעות [DOC-POINTER](0x041L-doc-pointer.md) אחד (המסמך מצביע על עצמו ב-DOC-POINTER של `DOC-ID` שלו). אפשר לצרף גם למסמך `BIND`, `LABEL` ו-Edge של פסק דין.
- ה-Issuer עצמו מצביעים עליו ב-[ISSUER-POINTER](0x040L-issuer-pointer.md). מסמך ID `0` הוא מסמך האינדקס של הגדרות המונחים של ה-Issuer.
- Codec שנותן משמעות ל-`0` במקום של רכיב (ה«אין» של REF ושל Edge ביצוע ב-[TOULMIN](../toulmin/_index.md), ה«כל המסמך» של Target ב-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) של HEAD) פועל לפי כללי אותו Codec. זו הסכמה בתוך אותו Codec, שונה מ[סמן מקום](../slot-marker.md).
- ID שהוקצה פעם אחת אינו נעשה בו שימוש חוזר באותו מסמך.
- תמיד משתמשים ברוחב המינימלי שמסוגל לייצג את הערך.

## זהות והיקף {#동일성과-범위}

- באותו מסמך, ערכים שלמים שווים של LOCAL ID הם אותו יעד. רוחב הקידוד אינו חלק מהזהות.
- LOCAL מסוג Identified מייצג יעד מזוהה. אין משתמשים בו כאנונימי, כלא-מוגדר, כ-null או כ-sentinel. הדברים «יש ערך אך לא ידוע» (UNKNOWN-VALUE) ו«אין ערך» (NO-VALUE) נכתבים כ[סמן מקום](../slot-marker.md) בשדה שמקבל את הסמן.
- LOCAL ID שונים הם רק Reference שונים, ואין פירושו שגם היעדים במציאות שונים.
- אין מרחיבים את זהות ה-LOCAL אל מחוץ למסמך. אותו מספר במסמך אחר אינו קשור.
- LOCAL מסוג Variable (`0x009L`) הוא משתנה שיח בעל שם ([Reference](_index.md) Variable).

## מיזוג {#병합}

כשממזגים כמה מסמכים לאחד, יוצרים לכל מסמך מקור טבלת התאמה `old ID → new ID`, מקצים מחדש את כל ה-LOCAL ID ל-ID של המסמך החדש ומחליפים את כל ההפניות.

- ID שהיו שווים באותו מסמך מקור חייבים להישאר שווים גם אחרי המיזוג.
- אותו מספר במסמכי מקור שונים אינו קשור, ואין ממזגים אותם אוטומטית ל-Reference אחד.
- אם נותר LOCAL אחד שלא הוחלף, המיזוג נדחה.

## תקפות {#유효성}

הקידודים או ההקצאות הבאים הם invalid.

- קידוד non-minimal עם WORD מוביל `0x0000` (יוצא מן הכלל: `0x0000` ב-WORD אחד עבור הערך 0)
- Codec במקום הצהרת Edge Id שאינו Identified (`0x005L`), או ID השווה ל-`0`
- הקצאת ID אחד לשני יעדים שונים בחפיפה באותו מסמך
- הצהרה על אותו Edge Id יותר מפעם אחת באותו מסמך

## דוגמה {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000050/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

למעלה מסמך ה-Codec של `LOCAL-IDENTIFIED` (`0x005L`). במסמכי ה-Codec של שאר החברים (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
