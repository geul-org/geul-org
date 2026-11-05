---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE הוא Value הנושא language tag שלם של BCP 47 כרצף בייטים ASCII."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE הוא Value הנושא language tag שלם של BCP 47 כרצף בייטים ASCII. הוא משתמש בזוג הקודים 0x076L/0x077L לבייטים זוגיים ואי-זוגיים.

| פריט | ערך |
|---|---|
| שם | `LANGUAGE-BCP47-CODE` (קבוצת זוגי/אי-זוגי. שם כל קוד בטבלת החברים להלן) |
| TAG ID | `0x076L`·`0x077L` |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 22~23 |
| Kind | Value · משפחה: TEXT |
| תיאור באינדקס | רצף בייטים ASCII של language tag שלם של BCP 47 באותיות canonical. בייטים זוגיים ואי-זוגיים |
| בצד Hugo | `value/text/language-bcp47-code.md` |

## חברים {#구성원}

דף זה עוסק בשני קודים של זוג זוגי/אי-זוגי יחד. הקוד הזוגי הוא ערך שמספר הבייטים שלו זוגי, והקוד האי-זוגי הוא ערך שמספר הבייטים שלו אי-זוגי ([רשומה ו-TAG WORD](../record.md#가변-길이-바이트열)). מסמך Codec אחד לכל קוד. השדות בשני מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | מספר בייטים | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | זוגי | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | אי-זוגי | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | שארית ערך גולמי (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE הוא Value הנושא language tag שלם של BCP 47. משתמשים בו כשצריך לרשום שפה במדויק, עד script, ‏region ו-variant.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value ‏`0x076L` (בייטים זוגיים) ו-`0x077L` (בייטים אי-זוגיים). משפחה TEXT.
- מספר הבייטים נקבע לפי הסיבית הנמוכה ביותר של ה-Codec ומספר ה-Payload WORD. הוא `2 × מספר Payload WORD − הסיבית הנמוכה ביותר`, ואין Byte Count ([Value](_index.md)).
- ה-Payload אינו טקסט UTF-8 אלא רצף בייטים ASCII של tag מסוג BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length TAG הרחבה] כשהסך הכול 15 WORD ומעלה
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## פירוש ותוקף {#해석과-유효성}

- רצף הבייטים חייב להיות language tag של BCP 47 שהוא well-formed לפי RFC 5646. מחרוזת ריקה אינה מותרת.
- ה-Payload משתמש רק בתווי ASCII, בספרות ובמקף `-` (hyphen-minus). המפריד חייב להיות ASCII ‏`-`, ו-`_`, רווח ותווים שאינם ASCII אינם מותרים.
- השוואת tag של BCP 47 אינה תלויה ברישיות. הפרופיל הקנוני של GEUL משתמש ב-`-` בכל המפרידים וכותב את ה-subtag של language/extlang/variant/extension/private-use באותיות קטנות, את script ב-Titlecase ואת region באותיות גדולות.
- well-formed בלבד אינו מספיק. תקפותם של registered subtag ושל grandfathered tag נקבעת לפי snapshot מסוים של IANA Language Subtag Registry, ויש לשמר יחד איתה את תאריך ה-snapshot או את גרסת ה-registry.
- tag של private-use ו-subtag של private-use מותרים אם הם well-formed לפי דקדוק RFC 5646. אולם משמעותם תלויה בהסכמת הצדדים וה-IANA registry אינו מגדיר אותם, ולכן אין ערובה ל-interoperability ציבורי.
- אם ב-snapshot אחד ל-subtag שהוצא משימוש (deprecated) או ל-grandfathered tag יש Preferred-Value, הצורה הקנונית של GEUL כותבת את ערך ההחלפה באותיות canonical. tag בכתיב deprecated אפשר לפרש כקלט, אך אינו צורת אחסון קנונית.
- מכיוון ש-BCP 47 הוא פרופיל ASCII, דרישות נרמול Unicode כמו UTF-8 NFC אינן חלות.
- בתוך WORD הבייט העליון בא ראשון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שאינו בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-Payload WORD הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים {#표준-근거}

- דקדוק ה-language tag, הפירוש שאינו תלוי ברישיות ומושג ה-deprecated/Preferred-Value נקבעים לפי [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- ה-registry הקובע את תקפות ה-tag הוא [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- זוג הקודים זוגי/אי-זוגי, zero padding, מדיניות אחסון באותיות canonical וחישוב Length הם כללי ה-framing של GEUL.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, ה-Length TAG של ההרחבה (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG של ההרחבה נכלל גם הוא בסך הכול ([Length](../record.md)).

## היחס ל-LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- tag שיש לו מספר ב-GEUL Language Registry אפשר לכתוב ב-WORD אחד של [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- tag שאין לו מספר ב-registry (כולל tag שיש בו extension או private-use) נכתב ב-LANGUAGE-BCP47-CODE. גם כשצריך לשמר את המקור של ה-tag המלא משתמשים ב-LANGUAGE-BCP47-CODE.
- SHORT-CODE ‏`n` ו-LANGUAGE-BCP47-CODE של ה-tag שה-registry קשר ל-`n` (בלי תלות ברישיות) הם אותה שפה.

## דוגמה {#예시}

- `ko-KR` הוא 5 בייטים של ASCII (אי-זוגי), ולכן `LANGUAGE-BCP47-CODE-ODD` ‏(`0x077L`), וה-Payload הוא `6B6F 2D4B 5200`.
- TAG של WORD אחד ו-Payload של 3 WORD נותנים סך הכול 4 WORD, ו-`LLLL=0011`. השלם הוא `0773 6B6F 2D4B 5200`.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000760/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

למעלה מסמך ה-Codec של `LANGUAGE-BCP47-CODE-EVEN` (‏`0x076L`). במסמך ה-Codec של חבר אחר (`LANGUAGE-BCP47-CODE-ODD`) שונים רק ה-Codec ID ב-DOC-ID, יעד ה-DECLARE והשם הקשור ב-`#1` (BIND).
