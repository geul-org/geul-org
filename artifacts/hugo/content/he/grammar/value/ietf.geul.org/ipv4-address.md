---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS הוא Value ברוחב קבוע המכיל את ערך 32bit של כתובת IPv4."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS הוא Value ברוחב קבוע המכיל את ערך 32bit של כתובת IPv4. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000007` IETF, מספר Codec ‏`0x0000C001`, משפחה BINARY. ה-Payload הוא בדיוק 2 WORD (‏32bit).

## פריסה {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD בסך הכול
Issuer            2 WORD  0x00000007 (IETF)
מספר Codec        2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## פירוש ותוקף {#해석과-유효성}

- ה-octet של הכתובת נשארים בסדר network byte order. בכל WORD, ה-octet שבא ראשון הוא 8 הביטים העליונים וה-octet הבא הוא 8 הביטים התחתונים.
- ה-Payload מכיל רק את 32 הביטים של כתובת אחת. הוא אינו מכיל אורך תחילית CIDR, port או פרוטוקול תעבורה (transport protocol).
- ניתן לייצג כל pattern של 32bit. המשמעות התפעולית והשימושיות של patterns כמו unspecified, מיוחד, שמור או multicast נקבעות בהקשר חיצוני ואינן מגבילות את התוקף המבני.
- IPV4-ADDRESS ו-IPV6-ADDRESS הם פורמטים נפרדים. אין ממירים אוטומטית כתובת IPv6 מסוג IPv4-mapped לפורמט הזה, ואין מנרמלים אותה לאותו ערך.
- ניתן להשתמש ב-Value הזה כרכיב מזהה של Reference, אך מדיניות ההפניה ותוחלת החיים שלה אינן כלולות בדפוס הביטים של הכתובת.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## בסיס בתקנים {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) מגדיר כתובת IPv4 כאורך קבוע של 4 octet (‏32bit), ומגדיר את Source Address ו-Destination Address כשדות של 32bit כל אחד. סדר שידור ה-octet שבנספח B וכלל most-significant-bit-first של כל octet נשמרים ב-Payload.
- GEUL TAG, הקצאת Issuer, אריזת WORD בן 16bit ו-Length אינם חלק מ-RFC 791, אלא כללי framing שהפורמט הזה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 7 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 2 WORD, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## דוגמה {#예시}

כתובת IPv4 ‏`1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
