---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI הוא Value שמכיל רצף בייטים ASCII לפי דקדוק ה-URI של RFC 3986 (URI מוחלט עם scheme). הוא משתמש בזוג הקודים הזוגי-אי-זוגי 0x44/0x45."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI הוא Value שמכיל רצף בייטים ASCII לפי הדקדוק `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` של RFC 3986. מכיוון שהוא כולל scheme, הפירוש שלו אינו דורש base URI.

## פריסה

- קוד: קוד ישיר של Value `0x44` (מספר זוגי של בייטים) ו-`0x45` (מספר אי-זוגי). משפחה TEXT.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של ה-Codec ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## פירוש ותקינות

- רצף הבייטים חייב להתאים לדקדוק `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` של RFC 3986. אפשר לכלול query ו-fragment.
- ה-terminal בדקדוק ה-URI הם תווי US-ASCII. תווי ASCII מותרים נשמרים כמות שהם, וכשעושים percent-encoding של octet משתמשים בצורה `pct-encoded = "%" HEXDIG HEXDIG`. אסור להכניס ישירות תו שאינו ASCII כבייט literal.
- חובה לכלול `scheme` ואת `:`. הפניה יחסית כותבים ב-[URI-RELATIVE-REF](/he/grammar/value/text/uri-relative-ref/) (מספרי פורמט IETF `0x8000`·`0x8001`).
- ה-production `URI` של RFC 3986 אינו מתיר מחרוזת ריקה. רשומה של 0 בייטים אינה תקפה.
- בתוך WORD בא קודם הבייט העליון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שלא בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-WORD של ה-Payload הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים

- הדקדוק של `URI`, תווי URI ו-percent-encoding הוא לפי [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- זוג הקודים הזוגי-אי-זוגי, ריפוד באפסים, ו-TAG/Length של GEUL ופריסת WORD של 16 ביט הם כללי ה-framing של הפורמט הזה.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## דוגמה

- `https://example.com/` הוא 20 בייטים של ASCII (זוגי), ולכן `URI-EVEN` (`0x44`).
- ה-Payload הוא 10 WORD: `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- TAG של WORD אחד ועוד Payload של 10 WORD הם 11 WORD בסך הכול, ולכן `LLLL=1010`. הרשומה כולה היא `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

‏`archive.geul.org` הוא מאגר תוכן בלתי משתנה מתוכנן, שנועד להפניה מ-GEUL לתוכן גדול כמו בינארי ומסמכים חיצוניים. הוא עדיין אינו פועל. פורמט הכתובת המומלץ הוא `https://archive.geul.org/sha256/{digest}`. אותו רצף בייטים חייב לקבל אותו URI, ואחרי הפרסום אסור לשנות את הבייטים של אותו URI.

Value של URI מבטא רק מיקום או מחרוזת כתובת של תוכן חיצוני, ואינו מבטיח את הזהות או את אי-השינוי של היעד עצמו. בינארי וטקסט החורגים מהטווח המרבי של Value מוטמע אפשר להפנות אליהם באמצעות archive URI. במטא-נתונים של האובייקט השמור חייבים לרשום את הפריטים הבאים.

- ה-URI המקורי וזמן האיסוף
- SHA-256 ו-Byte Length
- MIME type
- license identifier וגרסה
- הכותב, המקור וההודעות
- ה-URI של בסיס הרישיון, ואם צריך, עותק של הבסיס בזמן האיסוף

האפשרות לאסוף נקבעת לא לפי האם אפשר לגשת בחינם אלא לפי האם זכות ההפצה מחדש אומתה במפורש. חייבים לכבד את תנאי הרישיון החלים כמו ייחוס, אי-מסחריות, איסור שינוי ושיתוף זהה. במסמכים ובתוכן רושמים רישיון מפורש כמו Creative Commons, ובתוכנה משתמשים אם אפשר ב-SPDX License ID.

גם אם מפסיקים את ההגשה בגלל בעיית זכויות או תיקון, אסור להכניס בייטים אחרים ל-URI קיים. אותו URI מחזיר tombstone שמכיל את סיבת ההפסקה והזמן, וחייבים לשמור את ה-digest המקורי ואת רישום הביקורת. אם חובה משפטית אוסרת לשמור את רישום הביקורת, החובה הזו קודמת.

archive URI מספק יחד את מיקום הגישה ואת ה-digest של התוכן. כללי כתובת התוכן ואי-השינוי האלה הם מדיניות של פרופיל GEUL Archive, והדקדוק הכללי של Value מסוג URI אינו תלוי ב-`archive.geul.org`.
