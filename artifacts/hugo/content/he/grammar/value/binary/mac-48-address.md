---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS הוא פורמט Issuer של IEEE ברוחב קבוע של 6 WORD שמכיל כתובת MAC של IEEE 802 בת 48 ביט בסדר ה-octet המקורי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS הוא Value ברוחב קבוע שמכיל ערך של כתובת MAC של IEEE 802 בת 48 ביט. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, מספר פורמט `0xC000`, משפחה BINARY. ה-Payload הוא בדיוק 3 WORD (6 octet, 48 ביט).

## פריסה

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  6 WORD בסך הכול
Issuer            1 WORD  0x0040 (IEEE)
מספר פורמט        1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## פרשנות ותקינות

- ששת ה-octet של כתובת ה-MAC בת 48 הביט נשארים בסדר ה-octet של המחרוזת המסומנת ושל שידור ה-LAN. octet 0–1, 2–3 ו-4–5 מקובצים כל זוג ל-WORD, מה-octet העליון אל התחתון.
- במדיות IEEE 802 הביט הפחות משמעותי של כל octet משודר ראשון, אך מסיבה זו אין הופכים את הביטים בתוך ה-octet. I/G ו-U/L נשארים בביט הפחות משמעותי של octet 0 ובביט שאחריו.
- I/G=0 היא כתובת individual שביעד משמשת כ-unicast, ו-I/G=1 היא כתובת group שמשמשת כ-multicast או broadcast. U/L=0 היא כתובת universally administered, ו-U/L=1 היא כתובת locally administered.
- אין pattern שנשלל מבחינה מבנית בגלל ערכי I/G או U/L. אפשר לייצג כתובות universally/locally administered וכתובות individual/group, וכן כתובות MAC מסוג locally administered, randomized, spoofed או virtual כערך של 48 ביט.
- הערך שומר רק את 48 הביטים של הכתובת שנצפתה או הוצגה. הוא אינו מבטיח כתובת קבועה של מכשיר מסוים, ייחודיות עולמית, אימות מכשיר או משתמש, בעלות או קשר מתמשך לאותו מכשיר.
- הפורמט הזה מכסה רק כתובות MAC של IEEE 802 בנות 48 ביט בדיוק. הוא אינו מכיל EUI-64 או כתובות MAC אחרות בנות 64 ביט. IEEE RA מתארת את המונח ההיסטורי `MAC-48` כמיושן, אך לא כל כתובת MAC בת 48 ביט יכולה להיקרא EUI-48, ולכן הפורמט הזה אינו מזוהה אוטומטית עם EUI-48.
- אם ה-Payload אינו בדיוק 3 WORD, הרשומה נדחית.

## בסיס בתקנים

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) של IEEE Registration Authority מסמן כתובת MAC של LAN בת 48 ביט כשישה octet בסדר שידור, ומסביר שכל octet משודר החל מהביט הפחות משמעותי ושה-I/G וה-U/L הם שני הביטים הפחות משמעותיים של ה-octet הראשון. הפורמט הזה שומר את מיקומי ה-octet והביטים כפי שהם.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) של IEEE Registration Authority מגדיר I/G=0/1 כ-individual/group ו-U/L=0/1 כ-universal/local administration, ומסביר שכתובת local אינה ייחודית גלובלית. הוא גם מסביר את הקשר ההיסטורי ואת ההבדל בין `MAC-48` ל-EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) מסביר ש-EUI-48 ו-EUI-64 יכולים לשמש ככתובות MAC ועוד. אין בכך משמעות שמכניסים EUI-64 לרשומה הזו בת 48 הביט.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) ו-[RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) מתעדים שמכשירים אמיתיים יכולים ליצור ולשנות באופן אקראי כתובות MAC מסוג locally administered. לכן אין להסיק מערך ה-MAC לבדו זהות קבועה של מכשיר.
- GEUL TAG, הקצאת Issuer, Length ישיר ו-framing של WORD בן 16 ביט אינם חלק מ-IEEE 802 או מהמקורות שלמעלה אלא כללים שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 6 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-3 WORD של Payload, עם אורך ישיר `LLLL=0101`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 3 WORD, הרשומה נדחית.

## דוגמה

כתובת locally administered individual (unicast) `02:00:5e:10:00:00` (ב-octet הראשון `0x02`: I/G=0, U/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
