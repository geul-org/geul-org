---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE היא Edge תיאורית שמכילה טענה אחת (Predicate, Subject, Object) ואת הדרגה (rank) שלה (Codec 0x0A). ב-Object אפשר לכתוב במקום ערך 'לא ידוע' (UNKNOWN-VALUE) או 'אין' (NO-VALUE)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE היא Edge תיאורית שמכילה טענה אחת (Predicate, Subject, Object) ואת הדרגה (rank) שלה. Codec `0x0A`.

תנאי שמגביל את הטענה (זמן התחלה וסיום, תחום תחולה וכד') מצורף כ-[QUALIFIER](/he/grammar/edge/qualifier/) שמצביע על ה-Edge Id של ה-TRIPLE. המקור (references של Wikidata) מצורף כ-Edge הראיה [SOURCE](/he/grammar/edge/source/) שמצביעה על ה-Edge Id של ה-TRIPLE.

## פריסה

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Predicate         רשומת Reference (WIKIDATA-PID וכד')
Subject           רשומת Reference
Object            רשומת Reference או Value, או סמן מקום 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
Rank              WORD אחד (ENUM)
```

## Rank

| קוד | שם | משמעות |
|---|---|---|
| `0` | normal | ברירת מחדל |
| `1` | preferred | הערך הנוכחי, הסמכותי ביותר |
| `2` | deprecated | ערך שנקבע שהוא שגוי או מיושן אך נשמר כתיעוד |

- זהה ל-statement rank של Wikidata. הערך המייצג (truthy ב-Wikidata) מבין אותם Subject ו-Predicate הוא preferred אם יש, ואחרת normal.
- במקור שאינו מדרג, משתמשים ב-`0` (normal).
- כל קוד אחר הוא invalid.

## פירוש ותקינות

- Predicate ו-Subject הם כל אחד רשומת Reference שלמה אחת בדיוק.
- Object הוא רשומת Reference או Value שלמה אחת בדיוק, או [סמן מקום](/he/grammar/reference/slot-marker/) של WORD אחד `0x0001` (UNKNOWN-VALUE) או `0x0002` (NO-VALUE). ABSENT (`0x0000`) אינו מתקבל. Object אינו שדה רשות.
- אחרי קריאת ה-Object חייב להישאר בדיוק WORD אחד (Rank).
- מסמך המפרט של geul.org קובע בשדה הגולמי Rank את [CODEC](/he/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) ואת [ENUM](/he/grammar/edge/enum/) 0·1·2. בשדה Object הוא קובע CODEC `0780` (כל Reference), `0F80` (כל Value), `0001` (UNKNOWN-VALUE) ו-`0002` (NO-VALUE). Predicate ו-Subject אינם מקבלים סמן מקום.
- **המשמעות של TRIPLE היא אוסף כל ה-QUALIFIER באותו מסמך שמצביעים על ה-Edge Id שלה.** הקורא אוסף את ה-QUALIFIER לפני שהוא מפרש את ה-TRIPLE. TRIPLE שנקראה בלי QUALIFIER עלולה להיות טענה שחסרה בה הגבלה (למשל "ראש הרשות המבצעת" בלי הגבלת זמן).

## לא ידוע ואין

סמן מקום במקום ה-Object אינו ערך אלא קביעה על הטענה.

| Object | משמעות | לוגיקה |
|---|---|---|
| ערך v | אחד מערכי ה-Predicate של ה-Subject הוא v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | יש ערך. לא ידוע מהו (`somevalue` ב-Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | אין ערך (`novalue` ב-Wikidata) | `¬∃x. P(s, x)` |
| אין TRIPLE | לא קובעים דבר (עולם פתוח) | |

- **קוראים בתוך תנאי ההגבלה.** תחום ה-`∃` וה-`¬∃` נקבע על ידי ה-QUALIFIER שמצביעים על ה-TRIPLE. כשמצורף QUALIFIER, הקביעה סגורה רק בתחום הזה. "בין 1811 ל-1816 לא היה בנק מרכזי" נכתב כ-TRIPLE של NO-VALUE עם QUALIFIER P580·P582. אין סתירה בינה ובין TRIPLE של ערך באותו Predicate בתקופה אחרת.
- **ה-rank חל באותו אופן.** בבחירת הערך המייצג (truthy), גם TRIPLE של UNKNOWN-VALUE ושל NO-VALUE הן מועמדות. אם יש preferred, נשארות רק preferred.
- **UNKNOWN-VALUE אינו שווה ל-UNKNOWN-VALUE אחר.** UNKNOWN-VALUE אינו שווה ואינו שונה מאף ערך (תוצאת ההשוואה לא מוכרעת), וגם שני UNKNOWN-VALUE לא נחשבים לאותו ערך. בכל הופעה הוא כמת קיום עצמאי. לכן שתי TRIPLE של UNKNOWN-VALUE עם אותם בייטים אינן כפילות ואינן ממוזגות (יכולים להיות שני ילדים או אחד).
- אם באותם Subject, Predicate ו-rank יש יחד TRIPLE של NO-VALUE ו-TRIPLE של ערך (או UNKNOWN-VALUE) כשתנאי ההגבלה אינם מבחינים ביניהן, זו סתירה. הבודק מזהיר. לא דוחה (המצב קיים גם ב-Wikidata).
- אין לכתוב ב-UNKNOWN-VALUE ערך שלא הועבר (שבמקור יש לו ערך).

## דוגמה (לא נורמטיבית)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. ה-TAG הוא `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (ארצות הברית) P1304 (בנק מרכזי) NO-VALUE, normal. בין 1811 ל-1816 לא היה בנק מרכזי (QUALIFIER P580·P582 בדוגמה ב-[QUALIFIER](/he/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. ה-TAG הוא `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "אין ילדים (P40)" הוא `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## שאלות פתוחות

- scope (הקשר הטענה: עולם, נקודת מבט): נקבע כשיהיה לו שימוש.
- צורה מקוצרת שמקפלת TRIPLE ו-QUALIFIER לרשומה אחת: אחרי שתהיה הצהרה על שדה חוזר (שאלה פתוחה ב-[DECLARE](/he/grammar/edge/declare/)).

## דפים קשורים

- [Edge](/he/grammar/edge/), [QUALIFIER](/he/grammar/edge/qualifier/), [SOURCE](/he/grammar/edge/source/), [LABEL](/he/grammar/edge/label/), [ALIAS](/he/grammar/edge/alias/), [סמן מקום](/he/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/he/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/)
