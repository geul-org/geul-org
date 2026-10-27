---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM היא Edge תיאורית שמקצה משמעות לערך קוד אחד של שדה גולמי (Codec 0x1D). השם נקשר באמצעות BIND."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM היא Edge תיאורית שמקצה משמעות לערך קוד אחד של שדה גולמי. Codec `0x1D`.

יחד עם [FIELD](/he/grammar/edge/field/) היא אוצר המילים לכתיבת מפרט Codec. הפריסה מוטמעת במפענח ([מסמך מפרט Codec](/he/grammar/codec-spec/)).

## פריסה

```
TAG WORD          0001 0LLL L001 1101
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
שדה               רשומת LOCAL Reference שמצביעה על Edge מסוג FIELD
ערך קוד           ערך גולמי. מספר WORD כרוחב אותו FIELD
```

## פירוש ותקינות

- השדה חייב להיות FIELD גולמי (רוחב `n ≥ 1`). לא מצרפים ENUM לשדה רשומה. משמעות רשומה נקבעת על ידי ה-Codec של אותה רשומה.
- ערך הקוד הוא בדיוק ברוחב ה-FIELD. הגבולות נבדקים לפי ה-Length של רשומת ה-ENUM.
- בשדה אחד לא מצהירים על אותו ערך קוד פעמיים.
- שם ערך הקוד נקשר ל-Edge Id של ה-ENUM באמצעות [BIND](/he/grammar/edge/bind/). כל UTF8-TEXT שמוצמד ל-DECLARE, FIELD, ENUM ו-CODEC מוצמד באמצעות BIND, ולא באמצעות Edge אחרת כמו LABEL.
- ערך קוד שלא הוצהר אינו שגיאה. ה-viewer מציג אותו כערך גולמי. סגירת הערכים המותרים היא עניין של מפרט ה-Codec, ובאוצר המילים הנוכחי אין סימון סגירה.

## אורך

```
סה"כ = 1 + N_len + N_id + N_field + n WORD
```

## דוגמה (לא נורמטיבית)

מצהירים על הקוד `0x0001` בשדה קטגוריית הסיבה (FIELD #4, ערך גולמי של WORD אחד) במסמך המפרט של TOMBSTONE. Edge Id 10. השם נקשר בנפרד באמצעות BIND. טבלת קודי קטגוריית הסיבה טרם נקבעה, ולכן ערך הקוד הוא דוגמה.

- TAG 1 + Edge Id 2 + שדה 2 + ערך קוד 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

במסמך המפרט של TRIPLE יש לשדה Rank (FIELD #5) שלושה ENUM (`0`, `1`, `2`), ולכל אחד מהם BIND ל-`normal`, `preferred`, `deprecated` ([TRIPLE](/he/grammar/edge/triple/)).

## דפים קשורים

- [DECLARE](/he/grammar/edge/declare/), [FIELD](/he/grammar/edge/field/), [CODEC](/he/grammar/edge/codec/), [BIND](/he/grammar/edge/bind/)
- [מסמך מפרט Codec](/he/grammar/codec-spec/)
