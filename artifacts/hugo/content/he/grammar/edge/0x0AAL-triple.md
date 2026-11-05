---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE היא Edge של היגד שמכילה טענה אחת (Predicate, Subject, Object) ואת דרגתה (rank)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `TRIPLE` (BIND במסמך המפרט `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| מסמך מפרט | `0x00000000/codecs/0x00000AA0/` (יעד DECLARE‏ `0AA0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 10 |
| Kind | Edge · משפחה: היגד, קבוצה: טענה |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | טענה בסדר Predicate, Subject, Object, ו-rank. ה-Object הוא ערך או סמן UNKNOWN-VALUE·NO-VALUE. המשמעות היא הסך של כל ה-QUALIFIER שמצביעים על ה-Edge Id שלה |
| בצד Hugo | `edge/triple.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference) |  |
| 2 | `subject` | #3 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference) |  |
| 3 | `object` | #4 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference), `060F` קטע 3 כולו (תו כללי, Value), `080F` קטע 4 כולו (תו כללי, Value), `0010` UNKNOWN-VALUE, ‏`0020` NO-VALUE |  |
| 4 | `rank` | #5 | ערך גולמי, WORD אחד | `0620` UNSIGNED-INTEGER | `0x0000` normal, ‏`0x0001` preferred, ‏`0x0002` deprecated |

TRIPLE היא Edge של היגד שמכילה טענה אחת (Predicate, Subject, Object) ואת דרגתה (rank). Codec‏ `0x0AAL`.

תנאי שמסייג את הטענה (זמן התחלה וסיום, תחום תחולה וכד') מצורף כ-[QUALIFIER](0x0ABL-qualifier.md) שמצביע על ה-Edge Id של ה-TRIPLE. המקור (references של Wikidata) מצורף כ-Edge של ראיות, [SOURCE](0x0C0L-source.md), שמצביעה על ה-Edge Id של ה-TRIPLE.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Predicate         רשומת Reference (WIKIDATA-PID וכד')
Subject           רשומת Reference
Object            רשומת Reference או Value, או סמן מקום 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              WORD אחד (ENUM)
```

## Rank {#rank}

| קוד | שם | משמעות |
|---|---|---|
| `0` | normal | ברירת מחדל |
| `1` | preferred | הערך הנוכחי, הסמכותי ביותר |
| `2` | deprecated | ערך שנקבע שהוא שגוי או מיושן אך נשמר כתיעוד |

- זהה ל-statement rank של Wikidata. הערך המייצג (truthy ב-Wikidata) מבין אותם Subject ו-Predicate הוא preferred אם יש, ואחרת normal.
- במקור שאינו מדרג, משתמשים ב-`0` (normal).
- כל קוד אחר הוא invalid.

## פירוש ותוקף {#해석과-유효성}

- ה-Predicate וה-Subject הם כל אחד רשומת Reference שלמה אחת בדיוק.
- ה-Object הוא רשומת Reference או Value שלמה אחת בדיוק, או [סמן מקום](../slot-marker.md) של WORD אחד: ‏`0x0010` (UNKNOWN-VALUE) או `0x0020` (NO-VALUE). ABSENT (‏`0x0000`) אינו מתקבל. ה-Object אינו שדה אופציונלי.
- אחרי קריאת ה-Object צריך להישאר WORD אחד בדיוק (Rank).
- מסמך המפרט של geul.org מציב בשדה הערך הגולמי Rank את [CODEC](0x0BEL-codec.md) ‏UNSIGNED-INTEGER (‏`0620`) ואת [ENUM](0x0BDL-enum.md) 0·1·2. בשדה ה-Object מציבים CODEC‏ `000F`·`020F`·`040F` (כל Reference), ‏`060F`·`080F` (כל Value), ‏`0010` (UNKNOWN-VALUE), ‏`0020` (NO-VALUE). בשדות Predicate ו-Subject מציבים CODEC‏ `000F`·`020F`·`040F` (כל Reference). מפני שאלה תווים כלליים, סמן מקום אינו מתקבל.
- **משמעות ה-TRIPLE היא הסך של כל ה-QUALIFIER שמצביעים על ה-Edge Id שלה באותו מסמך.** הקורא אוסף את ה-QUALIFIER לפני שהוא מפרש את ה-TRIPLE. TRIPLE שנקראה בלי QUALIFIER עלולה להיות טענה שחסר בה סייג (למשל: “ראש הרשות המבצעת” בלי הסייג של זמן).

## לא ידוע ואין {#알-수-없음과-없음}

סמן המקום במקום ה-Object אינו ערך אלא קביעה על הטענה.

| Object | משמעות | לוגיקה |
|---|---|---|
| ערך v | אחד מערכי ה-Predicate של ה-Subject הוא v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | יש ערך. לא ידוע מהו (‏`somevalue` של Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | אין ערך (‏`novalue` של Wikidata) | `¬∃x. P(s, x)` |
| אין TRIPLE | לא נקבע דבר (עולם פתוח) | |

- **קוראים בתוך תנאי הסייג.** תחום ה-`∃` וה-`¬∃` נקבע על ידי ה-QUALIFIER שמצביע על אותה TRIPLE. כשמצורף QUALIFIER, הסגירה היא רק בתחום הזה. “בשנים 1811~1816 לא היה בנק מרכזי” נכתב כ-TRIPLE של NO-VALUE עם QUALIFIER‏ P580 ו-P582. אין סתירה עם TRIPLE-ים של ערכים בתקופות אחרות עבור אותו Predicate.
- **ה-rank חל באותו אופן.** בבחירת הערך המייצג (truthy) גם TRIPLE-ים של UNKNOWN-VALUE·NO-VALUE הם מועמדים. אם יש preferred, נשאר רק preferred.
- **UNKNOWN-VALUE-ים אינם שווים זה לזה.** UNKNOWN-VALUE אינו שווה ואינו שונה מאף ערך (תוצאת ההשוואה לא מוגדרת), וגם שני UNKNOWN-VALUE אינם נחשבים לאותו ערך. כל הופעה היא כימות קיומי עצמאי. לכן שתי TRIPLE-ים של UNKNOWN-VALUE עם בתים זהים אינן כפילות ואין למזג אותן (ייתכן שיש שני ילדים וייתכן שאחד).
- אם לאותם Subject, Predicate ו-rank יש יחד TRIPLE של NO-VALUE ו-TRIPLE של ערך (או UNKNOWN-VALUE) בלי שתנאי הסייג מבחינים ביניהן, זו סתירה. הבודק מזהיר. הוא אינו דוחה (גם ב-Wikidata מצב כזה קיים).
- ערך שלא הצלחנו להעביר (במקור יש ערך) לא נכתב כ-UNKNOWN-VALUE.

## דוגמה (לא נורמטיבית) {#예시-비규범}

Q42 (Douglas Adams) ‏P31 (instance of) ‏Q5 (human), ‏normal. ה-Edge Id הוא `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, ‏`LLLL=1001`. ה-TAG הוא `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (ארצות הברית) ‏P1304 (בנק מרכזי) ‏NO-VALUE, ‏normal. בשנים 1811~1816 לא היה בנק מרכזי (QUALIFIER‏ P580·P582 בדוגמה של [QUALIFIER](0x0ABL-qualifier.md)). ה-Edge Id הוא `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, ‏`LLLL=1000`. ה-TAG הוא `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- “אין ילדים (P40)” הוא `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## בעיות פתוחות {#열린-문제}

- scope (הקשר הטענה: עולם, נקודת מבט): ייקבע כשיהיה שימוש.
- צורה מקוצרת שמקפלת TRIPLE ו-QUALIFIER לרשומה אחת: אחרי שתהיה הצהרה על שדה חוזר (בעיות פתוחות של [DECLARE](0x0BBL-declare.md)).

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [סמן מקום](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000AA0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
