---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD היא Edge תיאורית שמצהירה על שדה אחד של Payload ב-Codec (Codec 0x1C). היא רושמת את ה-DECLARE שהשדה שייך אליו ואת הרוחב (רשומה, ערך גולמי של n WORD, שאר הערך הגולמי)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD היא Edge תיאורית שמצהירה על שדה אחד של Payload ב-Codec. Codec `0x1C`.

FIELD מצביעה על ה-[DECLARE](/he/grammar/edge/declare/) שלה. ה-FIELD שמצביעים על אותו DECLARE בונים את ה-Payload לפי סדרם במסמך. הפריסה מוטמעת במפענח ([מסמך מפרט Codec](/he/grammar/codec-spec/)).

## פריסה

```
TAG WORD          0001 0LLL L001 1100
Edge Id           רשומת LOCAL Reference
DECLARE           רשומת LOCAL Reference. ה-Edge DECLARE שהשדה הזה שייך אליה
רוחב              WORD אחד. 0 = רשומה, n (1~65534) = ערך גולמי של n WORD, 0xFFFF = שאר הערך הגולמי
```

## פירוש ותקינות

- ה-DECLARE מצביע על Edge DECLARE באותו מסמך. FIELD אחד שייך ל-DECLARE אחד בלבד. הסדר לא נרשם בנפרד אלא הוא הסדר שבו רשומות ה-FIELD מונחות במסמך.
- מסמך המפרט של FIELD מצהיר על DECLARE כשדה ברוחב `0` (רשומה) עם CODEC `0008` (LOCAL). לכן בגרף ה-viewer הוא מצויר כקישור FIELD → DECLARE.
- רוחב `0` הוא שדה רשומה. הוא מתחיל ב-TAG WORD וקוראים לפי ה-Length של אותו TAG (כללי הפירוש ב-[DECLARE](/he/grammar/edge/declare/)).
- רוחב `n` (1~65534) הוא שדה גולמי. הוא תמיד בדיוק n WORD.
- רוחב `0xFFFF` הוא שאר הערך הגולמי. מציבים אותו פעם אחת בלבד ב-DECLARE, ובכל מקום: בהתחלה, באמצע או בסוף. הרוחב הוא ה-WORD שנותרו לפי ה-Length של ה-TAG של הרשומה החיצונית, פחות הרוחבים של השדות שאחריו. לכן כל שדה שאחרי שאר הערך הגולמי חייב להיות ערך גולמי ברוחב קבוע (רשומה אפשר לקרוא רק מההתחלה כדי לדעת את סופה). הוא יכול להיות 0 WORD. לא מצרפים לו ENUM.
- ה-Kind וה-Codec שהשדה מקבל מצוינים ב-[CODEC](/he/grammar/edge/codec/). שדה רשומה בלי CODEC מקבל כל רשומה, ואם יש CODEC, הרשומה חייבת להיות אחד מהם. אם מציבים CODEC אחד בשדה גולמי, הערך הגולמי מפורש כ-Value הזה בלי ה-TAG.
- שם השדה נקשר ל-Edge Id של ה-FIELD ב-[BIND](/he/grammar/edge/bind/) (למשל: `doc`, `hash`). כל UTF8-TEXT שמוצמד ל-DECLARE, FIELD, ENUM ו-CODEC מוצמד באמצעות BIND, ולא באמצעות Edge אחרת כמו LABEL.
- משמעות ערכי הקוד של שדה גולמי מצורפת ב-[ENUM](/he/grammar/edge/enum/).
- שדה שמצביע על צומת אחר בגרף אינו מסומן בנפרד. אם שדה רשומה הוא Reference, זהו הקישור.

## אורך

```
סך הכול = 1 + 2 + 2 + 1 WORD   (כש-Edge Id ו-DECLARE הם LOCAL ID של WORD אחד)
```

## דוגמה (לא נורמטיבית)

- שדה רשומה: Edge Id 7, DECLARE #1, רוחב `0`. TAG 1 + Edge Id 2 + DECLARE 2 + רוחב 1 = 6 WORD. כדי להגביל לקבלת LOCAL בלבד, ראו את הדוגמה ב-[CODEC](/he/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- שדה גולמי כמו hash תוכן: ראו את הדוגמה ב-[DECLARE](/he/grammar/edge/declare/).

## דפים קשורים

- [DECLARE](/he/grammar/edge/declare/), [ENUM](/he/grammar/edge/enum/), [CODEC](/he/grammar/edge/codec/), [BIND](/he/grammar/edge/bind/)
- [מסמך מפרט Codec](/he/grammar/codec-spec/)
