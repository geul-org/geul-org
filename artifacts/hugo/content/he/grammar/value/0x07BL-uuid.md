---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID הוא Value ברוחב קבוע הנושא את ערך 128 הסיביות של UUID לפי RFC 9562."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `UUID` (מסמך מפרט BIND `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| מסמך מפרט | `0x00000000/codecs/0x000007B0/` (יעד DECLARE ‏`07B0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 27 |
| Kind | Value · משפחה: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | UUID של 128 סיביות לפי RFC 9562 ב-Payload קבוע של 8 WORD |
| בצד Hugo | `value/binary/uuid.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | ערך גולמי, 8 WORD |  |  |

UUID הוא Value ברוחב קבוע הנושא את ערך 128 הסיביות של UUID לפי RFC 9562. קוד ישיר של Value ‏`0x07BL`, משפחה BINARY. ה-Payload הוא בדיוק 8 WORD (16 octet, ‏128 סיביות).

## פריסה {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  סך הכול 9 WORD
Payload           8 WORD (128 סיביות)  UUID octet 0 → octet 15
```

## פירוש ותוקף {#해석과-유효성}

- מקבצים את ה-octet-ים הקנוניים של UUID לפי RFC 9562, מ-octet 0 עד octet 15, בזוגות לפי הסדר. ה-octet שבא ראשון הוא 8 הסיביות העליונות של ה-WORD. אין מסדרים מחדש ואין מקודדים מחדש את ה-field, סיביות ה-version וסיביות ה-variant של ה-UUID.
- מחרוזת hex-and-dash בצורת `8-4-4-4-12` היא רק ייצוג קלט/פלט. רישיות ומקפים אינם נכנסים ל-Payload, ונשמרים רק 16 ה-octet שהם תוצאת הניתוח.
- ה-Value של UUID משמר את תבנית 128 הסיביות ללא אובדן. ב-variant ‏`10xx` של RFC 9562, גרסאות 1, 3, 4, 5, 6, 7 הן layout תקני וגרסה 8 היא פורמט UUID מותאם אישית. גרסה 2 שמורה ל-DCE Security ול-RFC אין layout מוגדר עבורה, גרסה 0 אינה בשימוש וגרסאות 9–15 שמורות להגדרות עתידיות. גם variant אחרים שמורים לתאימות או להגדרה עתידית.
- Nil UUID הוא ערך מיוחד של 128 סיביות כולן אפס, ו-Max UUID הוא של 128 סיביות כולן אחד. גם תבנית של 128 סיביות הכוללת version/variant שמורים או שאינם בשימוש אינה מוחרגת מבחינה מבנית, ומשמעות התבנית ויכולת ה-interoperability שלה נקבעות לפי התקן החל והקשר חיצוני.
- זהות UUID נקבעת לפי השוויון של ערך 128 הסיביות ב-Payload. עצם שהערך שווה אינו מבטיח אימות של היעד, בעלות, קיום נוכחי, יכולת פתרון או הרשאת גישה.
- בשמירת COM GUID של Microsoft אין מעתיקים כמות שהן את הייצוג mixed-endian בזיכרון או בסריאליזציה. ממירים תחילה ל-16 octet בסדר ה-field/octet הקנוני של RFC 9562.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## בסיס בתקנים {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) מגדיר UUID כ-16 octet (128 סיביות), ומקודד את ה-field בסדר most-significant-byte-first כך שבפורמט הבינארי ה-field מחוברים בסדר big-endian. ה-variant נמצא בסיביות העליונות של octet 8 וה-version ב-4 הסיביות העליונות של octet 6, ופורמט זה משמר את המיקומים הללו כפי שהם.
- ‏Sections 4.1–5.10 של RFC 9562 מבחינים בין variant, גרסאות 1–8, ‏Nil, ‏Max וטווחים שמורים. מאחר ש-RFC 9562 מחליף את RFC 4122, הנורמה הנוכחית של פורמט זה היא RFC 9562.
- ה-ABNF של hex-and-dash ב-RFC 9562 הוא ייצוג טקסט, והסתייגות ה-little-endian של COM GUID נאמרת בנפרד. GEUL מכניסה ל-Payload רק את 16 ה-octet הקנוניים של ה-UUID לפי ה-RFC.
- ‏TAG של GEUL, אורך ישיר ו-framing של WORD בן 16 סיביות אינם חלק מ-RFC 9562, אלא כללים שפורמט זה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 9 WORD, ‏TAG של WORD אחד ו-Payload של 8 WORD, ומשתמשים באורך הישיר `LLLL=1000`. אין Length TAG של הרחבה, ואין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

וקטור הבדיקה של UUIDv7 ב-Appendix A.6 של RFC 9562, ‏`017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- ‏TAG ‏`07B8`, ‏Payload ‏`017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000007B0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
