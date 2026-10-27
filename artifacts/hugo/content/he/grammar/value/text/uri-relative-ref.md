---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF הוא Value שמכיל רצף בייטים ASCII לפי דקדוק ה-relative-ref של RFC 3986. הוא משתמש במספרי הפורמט 0x8000/0x8001 של Issuer IETF."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF הוא Value שמכיל רצף בייטים ASCII לפי הדקדוק `relative-ref` של RFC 3986. ה-base URI והתוצאה אחרי ה-resolve אינם נכנסים ל-Payload.

## פריסה

- קוד: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, מספר פורמט `0x8000` (מספר זוגי של בייטים) ו-`0x8001` (מספר אי-זוגי). משפחה TEXT.
- מספר הבייטים נקבע לפי הביט התחתון ביותר של מספר הפורמט ומספר ה-WORD של ה-Payload. הוא `2 × מספר ה-WORD של ה-Payload − הביט התחתון ביותר`, ואין Byte Count ([Value](/he/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0020 (IETF)
מספר פורמט        WORD אחד  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## פירוש ותקינות

- רצף הבייטים חייב להתאים לדקדוק `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` של RFC 3986.
- ה-terminal בדקדוק ה-URI הם תווי US-ASCII. תווי ASCII מותרים נשמרים כמות שהם, וכשעושים percent-encoding של octet משתמשים בצורה `pct-encoded = "%" HEXDIG HEXDIG`. אסור להכניס ישירות תו שאינו ASCII כבייט literal.
- מכיוון ש-`relative-part` יכול להיות `path-empty`, גם רצף בייטים ריק הוא `relative-ref` תקף מבחינת הדקדוק.
- ה-base URI, הקשר ה-resolution ותוצאת ה-resolve הם הקשר מחוץ לפורמט הזה.
- בתוך WORD בא קודם הבייט העליון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שלא בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-WORD של ה-Payload הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים

- הדקדוק של `relative-ref`, תווי URI ו-percent-encoding הוא לפי [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- זוג הקודים הזוגי-אי-זוגי, ריפוד באפסים, ו-TAG/Length של GEUL ופריסת WORD של 16 ביט הם כללי ה-framing של הפורמט הזה. ה-base URI ותוצאת פירוש ההפניה הם הקשר של ה-RFC, אך אינם נכנסים ל-Payload.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).
- 0 בייטים הוא `relative-ref` ריק שמותר במשמעות, ואין לו WORD של Payload. הפריסה הפיזית שלו היא שאלה פתוחה להלן.

## דוגמה

- `a/b?x=1` הוא 7 בייטים (אי-זוגי), ולכן מספר פורמט `0x8001`, Payload `612f 623f 783d 3100`. הסך הכול 7 WORD, ולכן `LLLL=0110`. הרשומה כולה היא `0B7C 0020 8001 612f 623f 783d 3100`.

## שאלות פתוחות

- הפריסה הפיזית של `relative-ref` ריק (0 בייטים). רשומה בלי Payload אינה מתיישבת עם הכלל "Payload מינימלי של WORD אחד", ולכן טרם נקבע.
