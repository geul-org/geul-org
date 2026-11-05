---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS הוא Value ברוחב קבוע המכיל את ערך 128bit של כתובת IPv6."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS הוא Value ברוחב קבוע המכיל את ערך 128bit של כתובת IPv6. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000007` IETF, מספר Codec ‏`0x0000C002`, משפחה BINARY. ה-Payload הוא בדיוק 8 WORD (‏128bit).

## פריסה {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD בסך הכול
Issuer            2 WORD  0x00000007 (IETF)
מספר Codec        2 WORD  0x0000C002
Payload           8 WORD (128 ביט)  IPv6 address, high-order bit → low-order bit
```

## פירוש ותוקף {#해석과-유효성}

- שמונת ה-WORD של ה-Payload, המחוברים מה-WORD העליון, נקראים כ-128 הביטים של שדה כתובת ה-IPv6 לפי הסדר. בכל WORD, ה-octet שבא ראשון הוא 8 הביטים העליונים.
- ה-Payload מכיל רק את 128 הביטים של כתובת אחת. הוא אינו מכיל אורך תחילית CIDR, port או פרוטוקול תעבורה (transport protocol).
- zone identifier אינו כלול ב-128 הביטים של הכתובת, ולכן אינו נכנס ל-Payload. כתובת scoped שזקוקה ל-zone נמסרת בהקשר חיצוני כמו interface, או Edge, Reference או Profile.
- ניתן לייצג כל pattern של 128bit. המשמעות התפעולית והשימושיות של patterns מסוג unspecified, loopback, multicast, מיוחד או שמור נקבעות בהקשר חיצוני ואינן מגבילות את התוקף המבני.
- IPV4-ADDRESS ו-IPV6-ADDRESS הם פורמטים נפרדים. גם כתובת IPv6 מסוג IPv4-mapped נשמרת כערך IPv6 בן 128bit, ואין משווים אותה אוטומטית ל-IPV4-ADDRESS ואין מנרמלים ביניהם.
- ניתן להשתמש ב-Value הזה כרכיב מזהה של Reference, אך ה-scope ומדיניות ההפניה אינם כלולים בדפוס הביטים של הכתובת.

## בסיס בתקנים {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) מגדיר כתובת IPv6 כמזהה (identifier) של 128bit וקובע את פורמט הביטים של הכתובות, כולל unicast, anycast, multicast ו-IPv4-mapped IPv6. הפורמט הזה שומר את 128 הביטים האלה ואינו מפרש אותם מחדש.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) מגדיר את Source Address ו-Destination Address של חבילת IPv6 כשדות של 128bit כל אחד. ה-WORD של ה-Payload שומרים את סדר שדה הכתובת מה-high-order bit עד ה-low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) קובע ש-zone של כתובת non-global אינו מקודד בכתובת עצמה אלא נקבע לפי הקשר (context). לכן ה-zone identifier נשאר מחוץ ל-Payload.
- את הכתיב כמחרוזת של RFC 4291 מותר להשתמש בו רק להסבר ולקלט/פלט. ‏[RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) אינו קובע פורמט אחסון פנימי, ולכן אין משתמשים בנרמול המחרוזת שלו כנרמול של הרשומה הבינארית הזו.
- GEUL TAG, הקצאת Issuer, Length ישיר ו-framing של WORD בן 16bit אינם חלק מ-RFC אלה, אלא כללים שהפורמט הזה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

כתובת IPv6 ‏`2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- כתיב מקוצר של המחרוזת אינו משפיע על ה-Payload.
