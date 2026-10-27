---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE היא Edge תיאורית שמצהירה על מבנה ה-Payload של Codec אחד (Codec 0x1B). יחד עם FIELD, ENUM ו-CODEC היא אוצר המילים לכתיבת מסמך מפרט Codec."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE היא Edge תיאורית שמצהירה על מבנה ה-Payload של Codec אחד. Codec `0x1B`.

יחד עם [FIELD](/he/grammar/edge/field/) (`0x1C`), [ENUM](/he/grammar/edge/enum/) (`0x1D`) ו-[CODEC](/he/grammar/edge/codec/) (`0x1E`) היא אוצר המילים לכתיבת מפרט Codec ([מסמך מפרט Codec](/he/grammar/codec-spec/)). הפריסה של ארבע ה-Edge מוטמעת במפענח. כל מסמך מפרט Codec שנכתב באוצר מילים זה הוא מסמך רגיל. מפרט אחד משמש יחד לאימות, לפירוק ולהצגה (viewer). ה-viewer אינו מחזיק קוד לכל Codec אלא מצייר לפי המפרט.

## פריסה

```
TAG WORD          0001 0LLL L001 1011
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
יעד               WORD אחד. משתמשים רק במקומות Kind ו-Codec של ה-TAG WORD של ה-Codec המוצהר (LLLL = 0)
[Issuer ומספר פורמט] כשהיעד הוא פורמט Issuer. אותה פריסה כמו Codec extension TAG
```

- רשימת השדות אינה ב-DECLARE. כל [FIELD](/he/grammar/edge/field/) מצביע על ה-DECLARE שלו, וסדר אותם FIELD במסמך הוא סדר שדות ה-Payload.

## כללי פירוש

כללים לקריאה ולהצגה של רשומה לפי מפרט Codec.

- שדה גולמי נקרא במספר ה-WORD הקבוע ש-FIELD הצהיר עליו. שדה אחד יכול להיות ערך גולמי שנותר (רוחב `0xFFFF`), והוא נקרא כמספר ה-WORD שנותרו פחות הרוחבים של השדות הקבועים שאחריו. אחרי השדה השנותר מניחים רק ערכים גולמיים ברוחב קבוע.
- שדה רשומה מתחיל ב-TAG WORD, ונקרא לפי ה-Length של אותו TAG.
- שדה גולמי הוא מספר שלם בלי סימן, big-endian, בן n WORD. הוא מוצג כ-`0x` + הקס ברוחב ×4 ספרות, ואם יש ENUM לאותו ערך, מוצג גם שם ה-BIND שלו.
- משמעות שדה רשומה נקבעת במפרט ה-Codec של אותה רשומה. ערך שדורש פירוש, כמו סימן, שבר או תאריך, מונח כרשומת Value ולא כערך גולמי.

אין כללי גבול נוספים. אי אפשר להצהיר באוצר מילים זה על Codec שיש בו יותר מערך גולמי משתנה אחד, שאחרי ערך גולמי משתנה בא בו שדה רשומה או שדה משתנה, או שרוחב ערך גולמי בו תלוי בערך של שדה אחר או במצב המסמך. בפריסה כזו עוטפים את החלק המשתנה ברשומה כדי שיישאר אחד בלבד (למשל: החותם ב-SIGNATURE הוא רשומת Reference).

## תקינות

- ה-Kind של היעד הוא אחד מ-Reference, Value, Edge, Meta. ב-Reference ה-Codec נמצא במקום של `CCCC`, וה-Quantifier נשאר 0.
- [סמן מקום](/he/grammar/reference/slot-marker/) (Codec `0000` של Reference) אינו יכול להיות יעד של DECLARE. הוא מוטמע במפענח (שכבה 0).
- את ה-Edge Id של Edge לא מצהירים כ-FIELD. הוא האיבר הראשון בכל Edge, ולכן משתמע ([Edge](/he/grammar/edge/)).
- שדות ה-DECLARE הם אותם FIELD שמצביעים עליו, ויכולים להיות 0. FIELD אחד שייך ל-DECLARE אחד בלבד. גם שדה בעל אותו מבנה מקבל FIELD נפרד בכל DECLARE.
- ב-DECLARE אין דבר מלבד היעד (ואם היעד הוא פורמט Issuer, גם ה-Issuer ומספר הפורמט).
- הסמן שקרא את השדות לפי הסדר חייב להתלכד בדיוק עם סוף הרשומה. אם נשאר או חסר, הרשומה מפרה את המפרט.
- במסמך אחד לא מצהירים על אותו יעד פעמיים.
- לא משתמשים בגרסאות שנבדלות בשדות הזנב כבענפים. לכל Codec יש DECLARE נפרד.

## מסמך מפרט

- מסמך המפרט של קוד ישיר הוא מסמך רגיל של Issuer `0x0000` (GEUL). מזהה המסמך הוא ה-TAG WORD של היעד מורחב ל-4 WORD (`0x1018` → `0x0000000000001018`), והוא מתפרסם כמו מסמכים אחרים של Issuer (מזהה גרסה, `versions.geul`) ([מסמך מפרט Codec](/he/grammar/codec-spec/)).
- במסמך מפרט אחד יש DECLARE אחד, והיעד שלו חייב להיות שווה ל-TAG WORD שבמזהה המסמך. `DOC-ID` הוא DOC-POINTER (`0x0000`, מזהה המסמך הזה, `0`).

## שמות

- שם ה-Codec נקשר ל-Edge Id של DECLARE באמצעות [BIND](/he/grammar/edge/bind/) (למשל: `PUBLICATION`). כל UTF8-TEXT שמוצמד ל-DECLARE, FIELD, ENUM ו-CODEC מוצמד באמצעות BIND, ולא באמצעות Edge אחרת כמו LABEL.
- שם שדה ושם enum נקשרים באותו אופן ל-FIELD ול-ENUM.

## דוגמה

מסמך המפרט של PUBLICATION (Edge `0x18`), `geul.org/publication`: אחרי ה-Edge Id בא רשומת DOC-POINTER, ואחריה hash תוכן של 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, רשומה         (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, ערך גולמי 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + יעד 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + רוחב 1 = 6 WORD (`LLLL = 0101`). ה-Kind וה-Codec שהשדה מקבל נקבעים בנפרד ב-[CODEC](/he/grammar/edge/codec/) (`0038` = DOC-POINTER).
- שדה רשות מוצהר ביעד CODEC `0000`. במקום שהושמט כותבים ABSENT (`0x0000`) ([CODEC](/he/grammar/edge/codec/), שדה רשות).
- סדר השדות הוא הסדר שבו FIELD #2 ו-#4 מונחים במסמך. ה-Edge Id לא חייבים להיות רצופים (LOCAL AUTO INCREMENT הוא המלצה).

## שאלות פתוחות

- חזרה. מבנה שבו ערך גולמי קודם קובע את הכמות, כמו "ארגומנט × מספר ארגומנטים" ב-`CALL`. כרגע אי אפשר להצהיר עליו.
- איך מצהירים על Codec שיש לו תת-פורמטים (TAG לכל Codec), כמו WORLD.
- איך מוצאים את מסמך המפרט של פורמט Issuer (Issuer ומספר פורמט → כתובת מסמך המפרט).
- לאיזו חבילת גרסאות של מסמכי המפרט של הקודים הישירים מתכוון `SPEC-VERSION`.

## דפים קשורים

- [FIELD](/he/grammar/edge/field/), [ENUM](/he/grammar/edge/enum/), [CODEC](/he/grammar/edge/codec/), [BIND](/he/grammar/edge/bind/)
- [Edge](/he/grammar/edge/), [מסמך מפרט Codec](/he/grammar/codec-spec/)
