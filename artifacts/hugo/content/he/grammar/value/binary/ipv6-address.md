---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS הוא פורמט Issuer של IETF ברוחב קבוע של 11 WORD שמכיל את 128 הביטים של כתובת IPv6 בסדר המקורי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS הוא Value ברוחב קבוע שמכיל את הערך בן 128 הביט של כתובת IPv6. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, מספר פורמט `0xC002`, משפחה BINARY. ה-Payload הוא בדיוק 8 WORD (128 ביט).

## פריסה

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD בסך הכול
Issuer            1 WORD  0x0020 (IETF)
מספר פורמט        1 WORD  0xC002
Payload           8 WORD (128 ביט)  IPv6 address, high-order bit → low-order bit
```

## פרשנות ותקינות

- שמונת ה-Payload WORD משורשרים מה-WORD העליון, ו-128 הביטים של שדה כתובת ה-IPv6 נקראים בסדרם המקורי. בכל WORD ה-octet הראשון הוא 8 הביטים העליונים.
- ה-Payload מכיל 128 ביט של כתובת אחת בלבד. הוא אינו מכיל CIDR prefix length, port או transport protocol.
- zone identifier אינו חלק מ-128 ביט הכתובת, ולכן אינו נכנס ל-Payload. כתובת scoped שזקוקה ל-zone מקבלת אותו מהקשר חיצוני כגון interface, או Edge, Reference או Profile.
- אפשר לייצג כל pattern של 128 ביט. המשמעות התפעולית והשימושיות של patterns מסוג unspecified, loopback, multicast, מיוחד ושמור נקבעות בהקשר חיצוני, ואינן מגבילות את התקינות המבנית.
- IPV4-ADDRESS ו-IPV6-ADDRESS הם פורמטים נפרדים. גם כתובת IPv6 מסוג IPv4-mapped נשמרת כערך IPv6 של 128 ביט, ואינה מזוהה אוטומטית עם IPV4-ADDRESS ואינה מנורמלת אליו או ממנו.
- אפשר להשתמש ב-Value הזה כמרכיב מזהה של Reference, אבל ה-scope ומדיניות ההפניה אינם כלולים ב-bit pattern של הכתובת.

## בסיס בתקנים

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) מגדיר כתובת IPv6 כ-identifier של 128 ביט וקובע את פורמט הביטים של הכתובות, כולל unicast, anycast, multicast ו-IPv4-mapped IPv6. הפורמט הזה שומר את 128 הביטים בלי לפרש אותם מחדש.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) מגדיר את Source Address ו-Destination Address בחבילת IPv6 כשדות של 128 ביט כל אחד. ה-Payload WORD שומרים על הסדר של שדה הכתובת, מה-high-order bit עד ה-low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) קובע ש-zone של כתובת non-global אינו מקודד בכתובת עצמה אלא נקבע לפי הקשר. לכן ה-zone identifier נשאר מחוץ ל-Payload.
- הסימון המחרוזתי של RFC 4291 מיועד להסבר ולקלט/פלט בלבד. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) אינו קובע פורמט אחסון פנימי, ולכן canonicalization המחרוזתי שלו אינו משמש כ-canonicalization של הרשומה הבינארית הזו.
- GEUL TAG, הקצאת Issuer, Length ישיר ו-framing של WORD בן 16 ביט אינם חלק מ-RFCs האלה אלא כללים שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 11 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-8 WORD של Payload, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, הרשומה נדחית.

## דוגמה

כתובת IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- הקיצור במחרוזת אינו משפיע על ה-Payload.
