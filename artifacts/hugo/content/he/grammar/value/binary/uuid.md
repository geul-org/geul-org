---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID הוא Value ברוחב קבוע של 9 WORD שמכיל את הערך בן 128 הביט של UUID לפי RFC 9562 כ-16 octet קנוניים."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID הוא Value ברוחב קבוע שמכיל את הערך בן 128 הביט של UUID לפי RFC 9562. הוא Value עם קוד ישיר `0x60`, משפחה BINARY. ה-Payload הוא בדיוק 8 WORD (16 octet, 128 ביט).

## פריסה

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  9 WORD בסך הכול
Payload           8 WORD (128 ביט)  UUID octet 0 → octet 15
```

## פרשנות ותקינות

- ה-octet הקנוניים של UUID לפי RFC 9562, מ-octet 0 עד octet 15, מקובצים לפי הסדר שניים שניים. ה-octet שבא ראשון הוא 8 הביטים העליונים של ה-WORD. אין לסדר מחדש או לקודד מחדש את שדות ה-UUID, ביטי ה-version וביטי ה-variant.
- מחרוזת hex-and-dash בצורה `8-4-4-4-12` היא רק ייצוג קלט/פלט. אותיות גדולות/קטנות ומקפים אינם נכנסים ל-Payload, ורק 16 ה-octet שהתקבלו מהפענוח נשמרים.
- ה-Value הזה של UUID שומר את pattern של 128 הביט ללא אובדן. ב-variant `10xx` של RFC 9562, גרסאות 1, 3, 4, 5, 6 ו-7 הן פריסות תקניות וגרסה 8 היא פורמט UUID מותאם אישית (custom). גרסה 2 שמורה ל-DCE Security וה-RFC אינו קובע לה פריסה, גרסה 0 אינה בשימוש וגרסאות 9–15 שמורות להגדרה עתידית. גם variants אחרים שמורים לתאימות או להגדרה עתידית.
- Nil UUID הוא ערך מיוחד של 128 ביט כולם אפס, ו-Max UUID הוא ערך מיוחד של 128 ביט כולם אחד. גם pattern של 128 ביט הכולל version/variant שמורים או שאינם בשימוש אינו נשלל מבחינה מבנית, והמשמעות והתאימות ההדדית שלו נקבעות לפי התקן החל וההקשר החיצוני.
- זהות של UUID נקבעת לפי שוויון ערכי 128 הביט ב-Payload. העובדה שהערך זהה אינה מבטיחה אימות של היעד, בעלות, קיום נוכחי, יכולת פתרון או הרשאת גישה.
- בעת שמירת GUID של Microsoft COM אין להעתיק כמות שהוא ייצוג mixed-endian של הזיכרון או הסריאליזציה. קודם ממירים אותו ל-16 octet בסדר השדות/octet הקנוני של RFC 9562.
- אם ה-Payload אינו בדיוק 8 WORD, הרשומה נדחית.

## בסיס בתקנים

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) מגדיר UUID כ-16 octet (128 ביט), ומקודד את השדות כ-most-significant-byte-first כך שבפורמט הבינארי הם מחוברים בסדר שדות big-endian. ה-variant נמצא בביטים העליונים של octet 8 וה-version ב-4 הביטים העליונים של octet 6, והפורמט הזה שומר את המיקומים האלה כפי שהם.
- סעיפים 4.1–5.10 ב-RFC 9562 מבחינים בין variant, גרסאות 1–8, Nil, Max וטווחים שמורים. RFC 9562 מחליף את RFC 4122, ולכן הנורמה העדכנית של הפורמט הזה היא RFC 9562.
- ה-ABNF של hex-and-dash ב-RFC 9562 הוא ייצוג טקסט, והוא מציין בנפרד גם את ההסתייגות little-endian של COM GUID. GEUL מכניסה ל-Payload רק את 16 ה-octet הקנוניים של ה-UUID לפי ה-RFC.
- GEUL TAG, Length ישיר ו-framing של WORD בן 16 ביט אינם חלק מ-RFC 9562 אלא כללים שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 9 WORD: TAG אחד ו-8 WORD של Payload, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, הרשומה נדחית.

## דוגמה

וקטור הבדיקה UUIDv7 `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` מ-Appendix A.6 של RFC 9562:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
