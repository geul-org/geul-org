---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE היא הפריסה שבה נכתבים צמתי גרף TOULMIN (מקרה, כלל, הגדרה, נקודת כניסה, trigger, פונקציה, שדה, כינוי, קבוצה). דגלים בכותרת של WORD אחד קובעים את השדות המותנים שאחריה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE היא הפריסה שבה נכתבים צמתי גרף ההכרעה והביצוע של TOULMIN. סוג הצומת נקבע לפי ה-Codec (או מספר פורמט ISSUER של GEUL), וכותרת של WORD אחד קובעת את התפקיד, ה-Level, צורת ה-Claim והשדות המותנים.

## Codec

| Codec | שם | TANGEUL | צומת |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | מקרה |
| `0x62` | SPEC-DECLARE | פריט ב-Definitions (`means`, `has`) | קריטריון שיפוט (Backing). ה-role הוא סוג ההגדרה |
| `0x63` | RULE-DECLARE | general rule | טענה (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | ראיית-נגד (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | חריג (Defeater) |
| `0x75` | ENTRY | `provides x` | נקודת כניסה חיצונית |
| `0x76` | TRIGGER | `on`, `every`, `until` | נקודת כניסה של אירוע או מחזור |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | מרחב שמות של המסמך |
| ISSUER `0x0000`/`0xC011` | FUNC | הפניה לפונקציה | פונקציה חיצונית (למשל `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | שדה חובה |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | כינוי של חבילה מיובאת |
| ISSUER `0x0000`/`0xC014` | GROUP | רשימה ממוספרת `1.` | קבוצת ביצוע סדורה |

פורמט ISSUER ממוקם אחרי `ISSUER-1WORD` (`0x7C`), ב-TAG הרחבת ה-Codec עם Issuer `0x0000` ומספר הפורמט ([TOULMIN](/he/grammar/edge/toulmin/)).

## פריסה

```
ID               רשומת LOCAL Reference (Edge Id)
כותרת WORD אחד   role 2b | שמור 2b | F_GROUNDS 1b | level 2b | סוג object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 אם אין) + VerbCode ב-WORD אחד
[F_QUAL]         Value מסוג SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF(מקרה)
[F_CLAIM]        Claim: REF(subject) + predicate ב-WORD אחד + object + mode ב-WORD אחד
[F_VERDICT]      Value מסוג SIGNED-DECIMAL. ערך ההכרעה ההתחלתי
[F_WITH]         מספר (Value מסוג UNSIGNED-INTEGER) + REF(TEXT) × המספר
[F_GROUNDS]      מספר (Value מסוג UNSIGNED-INTEGER) + REF(TEXT) × המספר
SPAN             הרוחב ש-SOURCE קובע × 2 (בייט התחלה, מספר בייטים)
```

### WORD הכותרת

| ביטים | שדה | ערך |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | שמור | 0 |
| 11 | F_GROUNDS | יש רשימת בסיסים |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 שמור) |
| 8–7 | סוג object | צורת ה-object של Claim. 0 REF, 1 Value מסוג UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | הטבלה שלהלן |

| ביט | flag | משמעות |
|---|---|---|
| b0 | F_FUNC | יש שדה FuncRef |
| b1 | F_QUAL | יש שדה Qualifier |
| b2 | F_CHECK | יש שדה מקרה היעד של `checking` |
| b3 | F_CLAIM | יש שדה Claim |
| b4 | F_VERDICT | יש שדה ערך ההכרעה ההתחלתי |
| b5 | F_STRIKE | הצהרה שנמחקה בקו חוצה. אין לה שדות |
| b6 | F_WITH | יש שדה רשימת קריטריונים |

- שדות מותנים מוצבים לפי סדר הדגלים (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). שדה שהדגל שלו כבוי אינו תופס מקום.
- אם דגל דלוק ואין שדה, דוחים. המיקום שאליו מגיעים אחרי קריאת השדות לפי הסדר, אחרי ה-SPAN, חייב להתלכד בדיוק עם סוף הרשומה.

## שדות

| שדה | הסבר |
|---|---|
| FuncRef | מקום של פונקציה. REF הוא רשומת ה-ALIAS שיבאה את הפונקציה, ו-`0` אם זו פונקציה של המסמך הזה. VerbCode הוא קוד של WORD אחד שעדיין לא הוקצה (`0x0000` מותר). הכתיב המקורי של הפונקציה נכתב בנפרד כ-TEXT + [LABEL](/he/grammar/edge/toulmin/link/) |
| Qualifier | מידת הוודאות של הצומת (0~1) |
| מקרה | F_CHECK: המקרה שהצומת הזה רק מכריע בו (`checking c`) |
| Claim | הטענה שהצומת מכיל. subject REF, predicate ב-WORD אחד, object, mode ב-WORD אחד. צורת ה-object נקבעת לפי סוג ה-object שבכותרת |
| ערך הכרעה | ערך התחלתי של ערך ההכרעה (−1~1) |
| F_WITH | קריטריון השיפוט בזמן ההצהרה (`기준으로 하는`, כלומר "שנקבע לפי"). רשימת REF של רשומות TEXT |
| F_GROUNDS | שמות העובדות החיצוניות שנפתרות בזמן ההערכה (`근거로 하는`, כלומר "המבוסס על"). רשימת REF של רשומות TEXT |
| SPAN | טווח הטקסט המקורי שממנו באה ההצהרה |

- רישום ערך ההכרעה וה-Qualifier נעשה לפי כללי [ערכים מספריים](/he/grammar/edge/toulmin/#ערכים-מספריים) של TOULMIN.
- מספר הפריטים ברשימה הוא רשומת Value מוטמעת מסוג [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/).
- הצורה הבסיסית של Claim תיאורי היא subject ו-predicate ששניהם `0` ו-object מסוג SPAN (סוג object 2). הוא ננעל לכתיב המקורי.

## פירוש ותקינות

- ב-RULE·COUNTER·EXCEPT-DECLARE ה-role חייב להיות שווה ל-Codec (0 general, 1 counter, 2 except). ב-SPEC-DECLARE הוא סוג ההגדרה. בשאר ה-Codec הוא 0.
- אם ה-level הוא 0 (Unset), משתמשים בברירת המחדל של המנוע: COUNTER-DECLARE הוא Fail, ו-EXCEPT-DECLARE הוא Review.
- כלל של פונקציית מארח ב-`tangl:규칙` ("כלל") של TANGEUL (`쓰는 규칙이다`, כלומר "כלל שמשתמש ב-") נכתב כ-NODE של RULE-DECLARE מחוץ למקרה. הפונקציה ב-F_FUNC, הקריטריון ב-F_WITH, והבסיסים ב-F_GROUNDS. רק כלל של ביטוי תנאי מקדים [PREDICATE-DECLARE](/he/grammar/edge/toulmin/expr/).
- הביטים השמורים (13–12) חייבים להיות 0. אם ביט שמור דלוק, או שה-role אינו תואם את ה-Codec, דוחים.

## דפים קשורים

- [TOULMIN](/he/grammar/edge/toulmin/), [LINK](/he/grammar/edge/toulmin/link/), [EXPR](/he/grammar/edge/toulmin/expr/), [SOURCE וחלוקה](/he/grammar/edge/toulmin/source/)
- [LOCAL](/he/grammar/reference/local/), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/)
