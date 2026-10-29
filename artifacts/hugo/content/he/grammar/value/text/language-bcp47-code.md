---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE הוא Value שמכיל language tag מלא של BCP 47 כרצף בייטים ASCII. הוא משתמש בזוג הקודים הזוגי-אי-זוגי 0x46/0x47."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE הוא Value שמכיל language tag מלא של BCP 47. משתמשים בו כשרוצים לכתוב שפה במדויק, כולל script, region ו-variant.

## פריסה

- קוד: קוד ישיר של Value `0x46` (מספר זוגי של בייטים) ו-`0x47` (מספר אי-זוגי). משפחה TEXT.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של ה-Codec ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).
- ה-Payload אינו טקסט UTF-8 אלא רצף בייטים ASCII של תג BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## פירוש ותקינות

- רצף הבייטים חייב להיות language tag תקין (well-formed) של BCP 47 לפי RFC 5646. מחרוזת ריקה אסורה.
- ה-Payload משתמש רק בתווי ASCII, ספרות ומקף `-`. המפריד הוא תמיד ASCII `-`, ואסורים `_`, רווח ותו שאינו ASCII.
- השוואת תגי BCP 47 אינה רגישה לאותיות גדולות וקטנות. הפרופיל הקנוני של GEUL כותב את כל המפרידים כ-`-`, ומסריאל את תתי-התגים language/extlang/variant/extension/private-use באותיות קטנות, את ה-script ב-Titlecase ואת ה-region באותיות גדולות.
- well-formed לבדו אינו מספיק. תקינות של subtag רשום ושל tag מסוג grandfathered נקבעת לפי snapshot מסוים של IANA Language Subtag Registry, וחייבים לשמור יחד איתה את תאריך ה-snapshot או גרסת ה-registry.
- tag של private-use ו-subtag של private-use מותרים אם הם well-formed לפי הדקדוק של RFC 5646. עם זאת משמעותם תלויה בהסכמת הצדדים ו-IANA registry אינו מגדיר אותם, ולכן אין ערובה לתאימות הדדית ציבורית.
- אם ל-subtag שהוצא משימוש (deprecated) או ל-tag מסוג grandfathered ב-snapshot זהה יש Preferred-Value, הצורה הקנונית של GEUL כותבת את ערך ההחלפה באותיות קנוניות. tag בכתיב deprecated אפשר לפרש כקלט, אך אינו צורת אחסון קנונית.
- מכיוון ש-BCP 47 הוא פרופיל ASCII, אין חלה דרישה של נרמול Unicode כמו UTF-8 NFC.
- בתוך WORD בא קודם הבייט העליון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שלא בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-WORD של ה-Payload הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים

- הדקדוק של language tag, פירוש שאינו רגיש לאותיות והמושג deprecated/Preferred-Value הם לפי [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- הפנקס שקובע את תקינות ה-tag הוא [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- זוג הקודים הזוגי-אי-זוגי, ריפוד באפסים, מדיניות האחסון באותיות קנוניות וחישוב ה-Length הם כללי ה-framing של GEUL.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## הקשר ל-LANGUAGE-SHORT-CODE

- tag שיש לו מספר ב-GEUL Language Registry אפשר לכתוב ב-WORD אחד כ-[LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/).
- tag שאין לו מספר ברישום (כולל tag עם extension או private-use) נכתב כ-LANGUAGE-BCP47-CODE. גם כשצריך לשמור את הטקסט המקורי של ה-tag המלא, משתמשים ב-LANGUAGE-BCP47-CODE.
- SHORT-CODE ‏`n` ו-LANGUAGE-BCP47-CODE של ה-tag שהרישום קשר ל-`n` (בלי הבחנה בין אותיות גדולות לקטנות) הם אותה שפה.

## דוגמה

- `ko-KR` הוא 5 בייטים של ASCII (אי-זוגי), ולכן `LANGUAGE-BCP47-CODE-ODD` (`0x47`), וה-Payload הוא `6b6f 2d4b 5200`.
- TAG של WORD אחד ו-Payload של 3 WORD הם 4 WORD בסך הכול, `LLLL=0011`. הרשומה כולה היא `09C7 6b6f 2d4b 5200`.
