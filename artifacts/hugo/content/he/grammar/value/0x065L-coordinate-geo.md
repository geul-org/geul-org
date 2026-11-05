---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO הוא Value של קואורדינטה המייצג נקודה על גוף שמיים מוגדר (כוכב לכת, ירח, אסטרואיד וכד') באמצעות קו רוחב, קו אורך ואי-ודאות."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `COORDINATE-GEO` (מסמך מפרט BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| מסמך מפרט | `0x00000000/codecs/0x00000650/` (יעד DECLARE `0650`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 5 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | Reference של גוף שמיים, קו רוחב וקו אורך ב-binary64, אי-ודאות ב-binary32 ו-Reference של יחידתה |
| בצד Hugo | `value/numeric/coordinate-geo.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | רשומה | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | ערך גולמי, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | ערך גולמי, 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | ערך גולמי, 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `0000` ABSENT (שדה אופציונלי) |  |

COORDINATE-GEO הוא Value של קואורדינטה המייצג נקודה על גוף שמיים מוגדר (כוכב לכת, ירח, אסטרואיד וכד') באמצעות קו רוחב, קו אורך ואי-ודאות. קוד ישיר של Value הוא `0x065L`, משפחה NUMERIC. זהו [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) שלפניו נוסף Reference של גוף שמיים (Globe), וכללי קו הרוחב, קו האורך, האי-ודאות והיחידה זהים לאלה של COORDINATE-EARTH.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Globe             רשומת Reference אחת (Reference המצביע על גוף השמיים, Quantifier Identified)
Latitude          4 WORD ערך גולמי, IEEE 754 binary64 (מעלות)
Longitude         4 WORD ערך גולמי, IEEE 754 binary64 (מעלות)
Uncertainty       2 WORD ערך גולמי, IEEE 754 binary32 (ביחידת Unit)
Unit              רשומת Reference אחת, או סמן מקום 0x0000 ABSENT
```

## פירוש ותוקף {#해석과-유효성}

- ה-Payload מתחיל ברשומת Globe. Globe הוא רשומת Reference שלמה אחת בדיוק, וה-Quantifier שלה הוא Identified. אפשר להשתמש בכל Reference המצביע על גוף שמיים: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (גוף שמיים בעל שם), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) באותו מסמך (גוף שמיים המוגדר בתוך המסמך), גוף שמיים במסמך אחר ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) וכד'. גרמי השמיים רבים עד אין קץ, ואלה שיש להם QID הם חלק מהם.
- אחרי Globe באים 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) ורשומת Unit אחת. הסמן שקרא את Unit חייב להתיישר עם סוף הרשומה.
- Latitude הוא `-90 ≤ φ ≤ 90`, ו-Longitude הוא `-360 ≤ λ ≤ 360`. הטווח רחב מזה של כדור הארץ כדי להכיל, ללא שינוי, ערכים ממערכות קואורדינטות של גרמי שמים הסופרות את קו האורך בין 0 ל-360° (מזרח או מערב) וכן ערכים שליליים הכתובים בכיוון ההפוך. הטווח זהה למודל הנתונים של globecoordinate בוויקינתונים (`LatLongValue` של Wikibase). `λ` ו-`λ ± 360` הם אותו קו אורך, ו-GEUL אינו מנרמל. שאר הכללים (binary64, ערך סופי, סדר צירים, משמעות Uncertainty ו-Unit, ייצוג "לא ידוע") זהים לאלה של COORDINATE-EARTH.
- מערכת הקואורדינטות נקבעת לכל גוף שמיים לפי המוסכמה שלו (קו רוחב פלנטוצנטרי, קו אורך מזרחי או מערבי בין 0 ל-360° וכד'). מערכת הקואורדינטות של כל גוף שמיים מוגדרת במסמך GEUL נפרד.
- Uncertainty ביחידת מרחק (מטר וכד') הוא מרחק על פני השטח של גוף השמיים. יחידת זווית (מעלה, דקת קשת, שנייה קשתית) היא רדיוס זוויתי של קו הרוחב וקו האורך, ללא קשר לגודל גוף השמיים.
- לקואורדינטות של כדור הארץ (Q2) מומלץ להשתמש ב-COORDINATE-EARTH. גם רישום כדור הארץ בפורמט זה אינו invalid, והצד המשווה מתאים אותה לאותה קואורדינטה.
- מסמך המפרט של geul.org `0x00000000/codecs/0x00000650` מציב בשדות הערך הגולמי Latitude, Longitude ו-Uncertainty את [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`), ובשדה רשומת Unit את CODEC `000F`, `020F`, `040F` (כל Reference) ו-`0000` (ABSENT).

## אורך {#길이}

- הסך הכול הוא TAG אחד + (TAG הרחבת Length) + רשומת Globe + 10 WORD + רשומת Unit.
- אם Globe הוא 2 WORD (כאשר ה-QID נכנס ל-WORD אחד) ו-Unit הוא ABSENT, הסך הכול 14 WORD, `LLLL=1101`, TAG `065D`. אם Unit הוא Reference (2 WORD ומעלה), הסך הכול חורג מ-15 WORD ונעשה שימוש באורך מורחב: TAG `065E`, וב-WORD הבא סך כל ה-WORD ([רשומה ו-TAG WORD](../record.md)).

## התאמה לוויקינתונים {#위키데이터-대응}

- globecoordinate שה-globe שלו אינו כדור הארץ (Q2) נכתב בפורמט זה. Globe = WIKIDATA-QID (פריט ה-globe). ההתאמה של קו רוחב, קו אורך ו-precision → Uncertainty ו-Unit זהה לזו של COORDINATE-EARTH (precision הוא רזולוציית רישום במעלות, ולכן מועבר כמות שהוא ללא קשר לגודל גוף השמיים).
- גרמי שמיים מחוץ לכדור הארץ במדגם ויקינתונים (כ-24 אלף טענות קואורדינטה): מאדים (Q111), סרס (Q596), הירח (Q405), כוכב חמה (Q308), נוגה (Q313) וכד', 23 מקרים. 41 המקרים שבהם globe ריק אינם מומרים, והטקסט המקורי נשמר ב-UTF8-TEXT.

## דוגמה {#예시}

מאדים (Q111) 4.5, 137.4, אי-ודאות לא ידועה:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, לא ידוע).
- ייצוג טקסטואלי: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

אותה נקודה, precision של 0.1° (Unit מעלה Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, אורך מורחב), סך הכול `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## בסיס תקני {#표준-근거}

- משמעות: קו רוחב, קו אורך ו-`u` (כאשר Unit הוא מטר) לפי [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). מערכת הקואורדינטות היחידה הרשומה ב-`crs` של RFC 5870 היא `wgs84`, ולכן גרמי שמיים מחוץ לכדור הארץ מצוינים ב-Reference של Globe ב-GEUL.
- ערכים מספריים: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (קו רוחב וקו אורך), binary32 (אי-ודאות).
- טווח קו האורך: `-360 ≤ λ ≤ 360` של [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo), מודל הנתונים של globecoordinate בוויקינתונים.

## בעיות פתוחות {#열린-문제}

1. מסמכי מערכות קואורדינטות לכל גוף שמיים: הגדרת קו הרוחב (פלנטוצנטרי או פלנטוגרפי) וכיוון וטווח קו האורך לכל גוף שמיים.

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000650/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
