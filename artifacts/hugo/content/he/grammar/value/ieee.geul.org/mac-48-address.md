---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS הוא Value ברוחב קבוע המכיל ערך של כתובת MAC בת 48 bit לפי IEEE 802."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS הוא Value ברוחב קבוע המכיל ערך של כתובת MAC בת 48 bit לפי IEEE 802. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000D` IEEE, מספר Codec ‏`0x0000C000`, משפחה BINARY. ה-Payload הוא בדיוק 3 WORD (6 octet, ‏48bit).

## פריסה {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  8 WORD בסך הכול
Issuer            2 WORD  0x0000000D (IEEE)
מספר Codec        2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## פירוש ותוקף {#해석과-유효성}

- ששת ה-octet של כתובת MAC בת 48-bit נשארים בסדר ה-octet של מחרוזת הכתיב ושל השידור ב-LAN. ה-octet מס' 0–1, 2–3 ו-4–5 נארזים, כל זוג ל-WORD אחד, מה-octet העליון אל התחתון.
- במדיות IEEE 802, ה-least-significant bit של כל octet משודר ראשון, אך אין הופכים את הביטים בתוך ה-octet בגלל זה. ‏I/G ו-U/L נשארים כמות שהם ב-least-significant bit של octet 0 וב-bit שאחריו.
- I/G=0 היא כתובת individual, ובמקבל (destination) משמשת ל-unicast, ו-I/G=1 היא כתובת group ומשמשת ל-multicast או ל-broadcast. ‏U/L=0 היא כתובת universally administered, ו-U/L=1 היא כתובת locally administered.
- אין pattern שנשלל מבנית בגלל ערכי I/G או U/L. הפורמט מייצג כתובות universally/locally administered וכתובות individual/group כאחד, וגם כתובות MAC מסוג locally administered, randomized, spoofed או virtual ניתנות לייצוג כערך של 48bit.
- הערך הזה שומר רק את 48 הביטים של הכתובת שנצפתה או הוצגה. הוא אינו מבטיח כתובת קבועה של מכשיר מסוים, ייחודיות עולמית, אימות של מכשיר או משתמש, בעלות, או קשר מתמשך לאותו מכשיר.
- הפורמט הזה עוסק רק בכתובות MAC של IEEE 802 בנות 48bit בדיוק. הוא אינו מכיל EUI-64 או כתובות MAC אחרות בנות 64-bit. ה-IEEE RA מתאר את המונח ההיסטורי `MAC-48` כמיושן (obsolete), אך לא כל כתובת MAC בת 48-bit ניתנת לכינוי EUI-48, ולכן אין להשוות את הפורמט הזה ל-EUI-48 באופן אוטומטי.
- אם ה-Payload אינו בדיוק 3 WORD, דוחים.

## בסיס בתקנים {#표준-근거}

- ה-[Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) של IEEE Registration Authority מציג כתובת MAC בת 48-bit של LAN כשישה octet בסדר שידור, מסביר שכל octet משודר החל מה-least-significant bit, וש-I/G ו-U/L הם שני ה-least-significant bit של ה-octet הראשון. הפורמט הזה שומר את מיקומי ה-octet והביטים כמות שהם.
- ה-[Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) של IEEE Registration Authority מגדיר I/G=0/1 כ-individual/group ו-U/L=0/1 כ-universal/local administration, ומסביר שכתובת local אינה ייחודית גלובלית. הוא מסביר גם את היחס ההיסטורי ואת ההבדל בין המונח `MAC-48` לבין EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) מסביר ש-EUI-48 ו-EUI-64 יכולים לשמש ככתובות MAC ועוד. אין בכך משום הכנסת EUI-64 לרשומה הזאת בת 48-bit.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) ו-[RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) מתעדים שמכשירים אמיתיים יכולים ליצור ולשנות באופן אקראי כתובות MAC מסוג locally administered. לכן אין להסיק מערך MAC בלבד זהות (identity) קבועה של מכשיר.
- GEUL TAG, הקצאת Issuer, Length ישיר ו-framing של WORD בן 16bit אינם חלק מ-IEEE 802 או מהחומרים שלעיל, אלא כללים שהפורמט הזה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 8 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 3 WORD, עם אורך ישיר `LLLL=0111`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 3 WORD, דוחים.

## דוגמה {#예시}

כתובת locally administered individual (unicast) ‏`02:00:5e:10:00:00` (‏I/G=0 ו-U/L=1 ב-octet הראשון `0x02`):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
