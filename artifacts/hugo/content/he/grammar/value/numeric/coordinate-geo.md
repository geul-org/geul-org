---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO הוא Value שמכיל נקודה אחת על גרם שמים כמו כוכב לכת או ירח: Reference של גרם השמים, קו רוחב וקו אורך ב-binary64, אי-ודאות ב-binary32 ו-Reference של היחידה שלה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO הוא Value של קואורדינטה שמבטא נקודה על גרם שמים מסוים (כוכב לכת, ירח, אסטרואיד וכד') באמצעות קו רוחב, קו אורך ואי-ודאות. הוא Value עם קוד ישיר `0x05`, משפחה NUMERIC. זהו הפורמט של [COORDINATE-EARTH](/he/grammar/value/numeric/coordinate-earth/) (`0x04`) עם Reference של גרם שמים (Globe) לפניו, וכללי קו הרוחב, קו האורך, האי-ודאות והיחידה זהים לאלה של COORDINATE-EARTH.

## פריסה

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length extension TAG] כשהכול 15 WORD ומעלה
Globe             רשומת Reference אחת (Reference שמצביע על גרם שמים, Quantifier Identified)
Latitude          ערך גולמי של 4 WORD, IEEE 754 binary64 (מעלות)
Longitude         ערך גולמי של 4 WORD, IEEE 754 binary64 (מעלות)
Uncertainty       ערך גולמי של 2 WORD, IEEE 754 binary32 (ביחידת Unit)
Unit              רשומת Reference אחת, או סמן מקום 0x0000 ABSENT
```

## פירוש ותקינות

- ה-Payload מתחיל ברשומת Globe. Globe הוא רשומת Reference שלמה אחת בדיוק וה-Quantifier שלו הוא Identified (`000`). אפשר להשתמש בכל Reference שמצביע על גרם שמים: [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/) (גרם שמים בעל שם), [GEUL](/he/grammar/reference/geul/), [LOCAL](/he/grammar/reference/local/) באותו מסמך (גרם שמים שהוגדר במסמך), גרם שמים ממסמך אחר ([EXTERNAL-POINTER](/he/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/)) וכד'. גרמי השמים אינם ניתנים למנייה, ואלה שיש להם QID הם רק חלק מהם.
- אחרי ה-Globe באים 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) ורשומת Unit אחת. הסמן שקרא את ה-Unit חייב להתלכד עם סוף הרשומה.
- Latitude הוא `-90 ≤ φ ≤ 90`, ו-Longitude הוא `-180 ≤ λ ≤ 360`. `(180, 360]` מותר כדי לשמור כמות שהוא את הערך של מערכות קואורדינטות של גרמי שמים שבהן קו האורך נספר מ-0 עד 360°. שאר הכללים (binary64, ערך סופי, סדר צירים, משמעות Uncertainty ו-Unit, ייצוג "לא ידוע") זהים ל-COORDINATE-EARTH.
- מערכת הקואורדינטות לכל גרם שמים עוקבת אחרי המנהג של אותו גרם (קו רוחב מרכזי-פלנטרי, קו אורך מזרחי או מערבי 0~360° וכד'). מערכת הקואורדינטות לפי גרם שמים נקבעת במסמך GEUL נפרד.
- Uncertainty ביחידת מרחק (מטר וכד') הוא מרחק על פני השטח של גרם השמים. יחידת זווית (מעלה, דקת קשת, שנייה של קשת) היא רדיוס זוויתי של קו הרוחב וקו האורך, בלי קשר לגודל גרם השמים.
- לקואורדינטה על כדור הארץ (Q2) מומלץ להשתמש ב-COORDINATE-EARTH. גם אם כותבים בפורמט הזה את כדור הארץ זה אינו invalid, והצד המשווה מתאים אותה לאותה קואורדינטה.
- מסמך המפרט של geul.org `0x0000/0x0000000000000805` קובע בשדות הגולמיים Latitude, Longitude ו-Uncertainty את [CODEC](/he/grammar/edge/codec/) BINARY-FLOAT (`0803`), ובשדה הרשומה Unit את CODEC `0780` (כל Reference) ו-`0000` (ABSENT).

## אורך

- הסך הכול הוא TAG של WORD אחד + (TAG הרחבת Length) + רשומת Globe + 10 WORD + רשומת Unit.
- אם ה-Globe הוא 2 WORD (QID שנכנס ב-WORD אחד) וה-Unit הוא ABSENT, זה 14 WORD, `LLLL=1101`, TAG `0E85`. אם ה-Unit הוא Reference (2 WORD ומעלה), זה חורג מ-15 WORD ומשתמשים באורך מורחב: TAG `0F05`, וב-WORD הבא מספר ה-WORD הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).

## התאמה ל-Wikidata

- globecoordinate שה-globe שלו אינו כדור הארץ (Q2) נכתב בפורמט הזה. Globe = WIKIDATA-QID (פריט ה-globe). ההתאמה של קו רוחב, קו אורך ו-precision → Uncertainty ו-Unit זהה ל-COORDINATE-EARTH (ה-precision הוא רזולוציית רישום במעלות, ולכן מעבירים אותו כמות שהוא בלי קשר לגודל גרם השמים).
- גרמי שמים מחוץ לכדור הארץ במדגם של Wikidata (כ-24 אלף טענות קואורדינטה): מאדים (Q111), סרס (Q596), הירח (Q405), כוכב חמה (Q308), נוגה (Q313) וכד', 23 טענות. 41 טענות שה-globe שלהן ריק אינן מומרות, והטקסט המקורי נשמר ב-UTF8-TEXT.

## דוגמה

מאדים (Q111) 4.5, 137.4, אי-ודאות לא ידועה:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, לא ידוע).
- סימון טקסטואלי: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

אותה נקודה, precision של 0.1° (Unit מעלה Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, אורך מורחב), סך הכול `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## בסיס בתקנים

- משמעות: קו רוחב, קו אורך ו-`u` של [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (כשה-Unit הוא מטר). מערכת הקואורדינטות היחידה הרשומה ב-`crs` של RFC 5870 היא `wgs84`, ולכן גרם שמים מחוץ לכדור הארץ מצוין באמצעות Globe Reference של GEUL.
- מספרים: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (קו רוחב וקו אורך), binary32 (אי-ודאות).

## שאלות פתוחות

1. מסמכי מערכת קואורדינטות לפי גרם שמים: לכל גרם שמים הגדרת קו הרוחב (מרכזי-פלנטרי או פלנטוגרפי) וכיוון וטווח קו האורך.

## דפים קשורים

- [Value](/he/grammar/value/), [COORDINATE-EARTH](/he/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/), [GEUL](/he/grammar/reference/geul/), [LOCAL](/he/grammar/reference/local/)
