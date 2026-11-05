---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF הוא Value המכיל רצף בייטים ב-ASCII לפי דקדוק relative-ref של RFC 3986."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF הוא Value המכיל רצף בייטים ב-ASCII לפי דקדוק `relative-ref` של RFC 3986. ה-base URI והתוצאה לאחר ה-resolve אינם נכנסים ל-Payload.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000007` IETF, מספר Codec ‏`0x00008000` (מספר זוגי של בייטים) ו-`0x00008001` (מספר אי-זוגי של בייטים). משפחה TEXT.
- מספר הבייטים נקבע לפי הביט הנמוך ביותר של מספר ה-Codec ולפי מספר ה-WORD ב-Payload: `2 × מספר ה-WORD ב-Payload − הביט הנמוך ביותר`. אין Byte Count ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000007 (IETF)
מספר Codec        2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## פירוש ותוקף {#해석과-유효성}

- רצף הבייטים חייב להתאים לדקדוק `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` של RFC 3986.
- ה-terminal של דקדוק ה-URI הם תווי US-ASCII. תווי ASCII מותרים נשמרים כמות שהם, וכשעושים percent-encoding ל-octet משתמשים בצורה `pct-encoded = "%" HEXDIG HEXDIG`. אסור להכניס תווים שאינם ASCII ישירות כ-literal byte.
- מכיוון ש-`relative-part` יכול להיות `path-empty`, גם רצף בייטים ריק הוא `relative-ref` תקף מבחינת הדקדוק.
- ה-base URI, הקשר ה-resolution ותוצאת ה-resolve הם הקשר שמחוץ לפורמט הזה.
- בתוך WORD, הבייט העליון בא ראשון. אם מספר הבייטים אי-זוגי (קוד אי-זוגי), הבייט התחתון שאינו בשימוש ב-WORD האחרון חייב להיות `00`.
- מספר ה-WORD ב-Payload הוא `ceil(מספר הבייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.

## בסיס בתקנים {#표준-근거}

- `relative-ref`, תווי URI ודקדוק ה-percent-encoding הם לפי [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- זוג הקודים הזוגי-אי-זוגי, ה-zero padding, GEUL TAG/Length וסידור WORD בן 16 ביט הם כללי framing של הפורמט הזה. ה-base URI ותוצאת פירוש ההפניה הם הקשר של ה-RFC, אך אינם נכנסים ל-Payload.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([Length](../../record.md)).
- 0 בייטים הוא `relative-ref` ריק שמותר מבחינת המשמעות, ואין בו WORD של Payload. הפריסה הפיזית שלו היא הבעיה הפתוחה שלהלן.

## דוגמה {#예시}

- ‏`a/b?x=1` הוא 7 בייטים (אי-זוגי), ולכן מספר ה-Codec הוא `0x00008001` וה-Payload הוא `612F 623F 783D 3100`. הסך הכול 9 WORD, ולכן `LLLL=1000`. הרשומה כולה היא `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## בעיות פתוחות {#열린-문제}

- הפריסה הפיזית של `relative-ref` ריק (0 בייטים). רשומה ללא Payload אינה מתיישבת עם הכלל ״Payload מינימלי של WORD אחד״, ולכן הדבר טרם נקבע.
