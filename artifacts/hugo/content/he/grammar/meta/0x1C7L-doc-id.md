---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על המזהה של המסמך הזה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DOC-ID` (BIND של מסמך מפרט: `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| מסמך מפרט | `0x00000000/codecs/0x00001C70/` (יעד DECLARE: `1C70`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 7 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | המזהה של המסמך הזה. Reference מובנה `DOC-POINTER` (Issuer, מזהה מסמך, גרסה 0). במסמך Codec: `CODEC-POINTER` (Issuer, Codec ID, גרסה 0) |
| בצד Hugo | `meta/declaration/doc-id.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | רשומה | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

מצהיר על המזהה של המסמך הזה. הוא נחוץ כדי שמסמכים אחרים יוכלו להצביע על המסמך הזה ועל הפריטים שבתוכו.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[TAG הרחבה של Length]
מסמך              רשומת Reference מסוג DOC-POINTER. (Issuer, מזהה מסמך, גרסה 0). במסמך Codec: CODEC-POINTER
```

- Codec: Meta `0x1C7L`, מחלקת הצהרה
- Payload: Reference מובנה אחד [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, מזהה מסמך, גרסה 0)
- מספר: לכל היותר אחד. במסמכי הגרסה שתחת `docs/<מזהה מסמך>/` ו-`codecs/<Codec ID>/` הוא חובה

## פירוש ותוקף {#해석과-유효성}

- ה-Payload הוא רשומת Reference אחת בדיוק מסוג `DOC-POINTER` (Issuer, מזהה מסמך, גרסה `0`). משתמשים רק במזהה גרסה `0`. את הגרסה מקצה רשימת הגרסאות, לא המסמך. במסמך Codec משתמשים ב-`CODEC-POINTER` (Issuer, Codec ID, גרסה `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- לכן הסימון שמצביע על "המסמך הזה" זהה ב-DOC-ID, ברשומת PUBLICATION ברשימת הגרסאות ובציטוט ממסמך אחר.
- אותו מסמך, בלי קשר לגרסה, הוא אותו `DOC-ID`. מזהה הגרסה ו-hash התוכן אינם נרשמים במסמך ([גרסה](../document.md#버전)).
- אין כתובת לפי שם מסמך ([כתובת פרסום ורשימת גרסאות](../publishing.md#문서-이름)). את הכותרת שאדם קורא נושא [LABEL](../edge/0x0A4L-label.md) של היגד.
- אם אין, זה מסמך בלי שם, שאפשר להצביע עליו רק ב-hash התוכן. הוא נחוץ כדי שמסמך אחר יוכל להצביע ב-Reference מצביע על LOCAL של המסמך הזה.
- הצד שמביא את המסמך מוודא שה-`DOC-ID` של המסמך שהתקבל שווה ל-Issuer ולמזהה המסמך שנתבקשו.
- מזהה מסמך `0x0000000000000000` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer ([Issuer](../issuer.md)). גם הוא מסמך גרסה תחת `docs/<מזהה מסמך>/`, ולכן יש בו DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). ה-Issuer עצמו מיוצג על ידי [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- במסמכי הגרסה `<מזהה גרסה>.geul` (כולל מסמכי מפרט) שב-`<Issuer>/docs/<מזהה מסמך>/` וב-`<Issuer>/codecs/<Codec ID>/` תחת `.well-known/geul/`, `DOC-ID` הוא חובה.
- מסמכי רשימה הם היוצא מן הכלל ואין בהם `DOC-ID`: רשימת הגרסאות `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) והגרסה `<מזהה גרסה>.geul` של רשימת ה-Issuer `issuers/` ([כתובת פרסום ורשימת גרסאות](../publishing.md#목록-문서)). על מה הרשימה אומר ה-DOC-POINTER ברשומה. את הגרסה של מסמך רשימה מציינת רשומת PUBLICATION ב-`versions.geul` שלו, ב-DOC-POINTER (`0x00000000`, מזהה מסמך שמור, מזהה גרסה). כתובת hash התוכן `<Issuer>/hashes/` היא עותק של המסמכים שלמעלה, ולכן הולכים אחרי המקור.
- מזהה מסמך `0xFFFFFFFFFFFFFFFF` שמור בכל ה-Issuer (וכך גם `0x0000000000000000`), ומשמש ברשימת ה-Issuer של Issuer `0x00000000`. Issuer אחרים אינם משתמשים בו. במסמכי רשימה אין `DOC-ID`, ולכן הערך הזה מופיע רק ב-DOC-POINTER של רשומות `issuers/versions.geul`.
- מסמך המפרט של Codec הוא מסמך Codec של Issuer GEUL `0x00000000`. אין לו מזהה מסמך, וב-`DOC-ID` מציבים CODEC-POINTER (`0x00000000`, Codec ID, `0`). Codec ID הוא TAG WORD של Kind·Codec כתוב ב-32 ביט (`0x0B80` → `0x00000B80`) ([מסמך מפרט](../codec-spec.md)).

## דוגמה {#예시}

- Issuer `0x00000002`, מסמך `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG של Meta 1 + TAG של Reference 1 + Issuer 2 + מזהה מסמך 4 + גרסה 2 = 10 WORD)

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C70/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
