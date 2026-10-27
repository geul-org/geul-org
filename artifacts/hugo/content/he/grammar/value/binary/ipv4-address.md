---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS הוא פורמט Issuer של IETF ברוחב קבוע של 5 WORD שמכיל את 32 הביטים של כתובת IPv4 בסדר network byte order."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS הוא Value ברוחב קבוע שמכיל את הערך בן 32 הביט של כתובת IPv4. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, מספר פורמט `0xC001`, משפחה BINARY. ה-Payload הוא בדיוק 2 WORD (32 ביט).

## פריסה

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD בסך הכול
Issuer            1 WORD  0x0020 (IETF)
מספר פורמט        1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## פרשנות ותקינות

- ה-octet של הכתובת נשארים בסדר network byte order. בכל WORD ה-octet הראשון הוא 8 הביטים העליונים וה-octet הבא הוא 8 הביטים התחתונים.
- ה-Payload מכיל 32 ביט של כתובת אחת בלבד. הוא אינו מכיל CIDR prefix length, port או transport protocol.
- אפשר לייצג כל pattern של 32 ביט. המשמעות התפעולית והשימושיות של patterns כגון unspecified, מיוחד, שמור או multicast נקבעות בהקשר חיצוני, ואינן מגבילות את התקינות המבנית.
- IPV4-ADDRESS ו-IPV6-ADDRESS הם פורמטים נפרדים. כתובת IPv6 מסוג IPv4-mapped אינה מומרת אוטומטית לפורמט הזה ואינה מנורמלת לאותו ערך.
- אפשר להשתמש ב-Value הזה כמרכיב מזהה של Reference, אבל מדיניות ההפניה ואורך חייה אינם כלולים ב-bit pattern של הכתובת.
- אם ה-Payload אינו בדיוק 2 WORD, הרשומה נדחית.

## בסיס בתקנים

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) מגדיר כתובת IPv4 כאורך קבוע של 4 octet (32 ביט), ומגדיר את Source Address ו-Destination Address כשדות של 32 ביט כל אחד. סדר שידור ה-octet שב-Appendix B וכלל most-significant-bit-first בכל octet נשמרים ב-Payload.
- GEUL TAG, הקצאת Issuer, קיבוץ ל-WORD של 16 ביט ו-Length אינם חלק מ-RFC 791 אלא כללי framing שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 5 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-2 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 2 WORD, הרשומה נדחית.

## דוגמה

כתובת IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
