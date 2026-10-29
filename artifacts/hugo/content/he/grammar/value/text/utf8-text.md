---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT הוא Value שמכיל מחרוזת UTF-8 בלי שפה. הוא משתמש בזוג הקודים הזוגי-אי-זוגי 0x40/0x41."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT הוא Value שמכיל רצף בייטים תקין של UTF-8 לפי RFC 3629. משתמשים בו למחרוזת בלי שפה כמו מזהה, קוד ושם קובץ.

## פריסה

- קוד: קוד ישיר של Value `0x40` (מספר זוגי של בייטים) ו-`0x41` (מספר אי-זוגי). משפחה TEXT.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של ה-Codec ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## פירוש ותקינות

- רצף הבייטים חייב להיות UTF-8 תקין (well-formed) בצורה הקצרה ביותר, לפי הדקדוק של RFC 3629. תוצאת הפענוח כוללת רק Unicode scalar value בטווח `U+0000..U+10FFFF`, ולא את טווח ה-surrogate `U+D800..U+DFFF`.
- U+FEFF בתחילת ה-Payload (בייטים של UTF-8, `EF BB BF`) מותר והוא תו, כמו U+FEFF בכל מקום אחר. הטיפול בחתימה U+FEFF בתחילת הרצף (BOM) שמתאר RFC 3629 אינו חל: הוא אינו מוסר ואינו מתפרש כחתימה, והטקסט נשמר כמות שהוא במקור.
- לא כופים נרמול של Unicode. שומרים כמות שהיא את רצף ה-scalar המקורי שפוענח.
- רצף UTF-8 תקין מוצב ב-Payload בלי המרה. בתוך WORD בא קודם הבייט העליון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שלא בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-WORD של ה-Payload הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים

- טווח ה-scalar של UTF-8 ורצף בייטים תקין הם לפי [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- זוג קודים זוגי-אי-זוגי, ריפוד באפסים, ו-TAG/Length של GEUL ופריסת WORD של 16 ביט הם כללי ה-framing הקנוניים של הפורמט הזה.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).
- מחרוזת של 0 בייטים נכתבת כרשומה של WORD אחד (TAG WORD בלבד) של הקוד הזוגי ([Value](/he/grammar/value/)).

## דוגמה

- `A` (`41`) הוא בייט אחד (אי-זוגי), ולכן `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, סך הכול 2 WORD, `LLLL=0001`. הרשומה כולה היא `08C1 4100`.
- מחרוזת ריקה היא `0840` (`UTF8-TEXT-EVEN`, TAG WORD בלבד), WORD אחד.
