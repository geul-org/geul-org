---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER היא Edge של היגד שמצרפת תנאי אחד שמסייג את הטענה שמכילה Edge אחרת (בדרך כלל TRIPLE)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `QUALIFIER` (BIND במסמך המפרט `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| מסמך מפרט | `0x00000000/codecs/0x00000AB0/` (יעד DECLARE‏ `0AB0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 11 |
| Kind | Edge · משפחה: היגד, קבוצה: טענה |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תנאי אחד שמסייג את הטענה של Edge אחרת. Property, ‏Target (‏Edge Id), ‏Value (ערך או סמן UNKNOWN-VALUE·NO-VALUE). הוא חלק מהטענה |
| בצד Hugo | `edge/qualifier.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `target` | #3 | רשומה | `0050` LOCAL |  |
| 3 | `value` | #4 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference), `060F` קטע 3 כולו (תו כללי, Value), `080F` קטע 4 כולו (תו כללי, Value), `0010` UNKNOWN-VALUE, ‏`0020` NO-VALUE |  |

QUALIFIER היא Edge של היגד שמצרפת תנאי אחד שמסייג את הטענה שמכילה Edge אחרת (בדרך כלל [TRIPLE](0x0AAL-triple.md)). Codec‏ `0x0ABL`.

היא שווה ל-qualifier (snak) אחד של Wikidata: מאפיין אחד וערך אחד.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Property          רשומת Reference (WIKIDATA-PID וכד')
Target            רשומת LOCAL Reference (ה-Edge Id של ה-Edge המסויגת)
Value             רשומת Reference או Value, או סמן מקום 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- סדר הרכיבים זהה ל-TRIPLE (‏Property ↔ Predicate, ‏Target ↔ Subject, ‏Value ↔ Object). המפענח קורא באותה דרך. התפקידים נקבעים על ידי ה-Codec.

## פירוש ותוקף {#해석과-유효성}

- ה-Property וה-Target הם כל אחד רשומת Reference שלמה אחת בדיוק, וה-Target הוא LOCAL Reference. מסמך המפרט של geul.org מציב ב-Target את [CODEC](0x0BEL-codec.md) LOCAL (‏`0050`). ה-Value הוא רשומת Reference או Value שלמה אחת בדיוק, או [סמן מקום](../slot-marker.md) של WORD אחד: ‏`0x0010` (UNKNOWN-VALUE) או `0x0020` (NO-VALUE). מסמך המפרט מציב ב-Value את CODEC‏ `000F`, ‏`020F`, ‏`040F` (כל Reference), ‏`060F`, ‏`080F` (כל Value), ‏`0010`, ‏`0020`. ABSENT (‏`0x0000`) אינו מתקבל. Property ו-Target אינם מקבלים סמן מקום. הסמן אחרי קריאת ה-Value חייב להתלכד עם סוף ה-Edge.
- ה-Target הוא Edge Id באותו מסמך. QUALIFIER נמצא באותו מסמך עם ה-Edge שהוא מסייג.
- אם ה-Target הוא [SOURCE](0x0C0L-source.md#문서-전체의-출처) ב-HEAD (מקור המסמך כולו), גם ה-QUALIFIER נמצא ב-HEAD, אחרי אותה SOURCE. שאר ה-QUALIFIER נמצאים ב-BODY. QUALIFIER שה-Target שלו הוא SOURCE של HEAD ונמצא ב-BODY הוא invalid.
- ה-Target יכול להיות Edge אחרת ולא רק TRIPLE. QUALIFIER שמצורף ל-[SOURCE](0x0C0L-source.md) מסייג את פעולת הציטוט (תאריך גישה, מיקום בתוך המקור וכד'). גם משמעות ה-SOURCE היא הסך של כל ה-QUALIFIER שמצביעים עליה.
- **QUALIFIER הוא חלק מהטענה.** הוא אינו טענה נפרדת על הטענה, אלא מסייג את התנאי שבו הטענה נכונה. משמעות ה-TRIPLE היעד היא הסך של כל ה-QUALIFIER שמצביעים עליה.
  - מקור הטענה נכתב כ-[SOURCE](0x0C0L-source.md). תכונות של צומת המקור (כותרת, מחבר וכד') נכתבות כ-TRIPLE שה-Subject שלה הוא המקור.
- לאותו Target יכולים להיות כמה QUALIFIER של אותו Property. סדר ה-QUALIFIER של אותו Target הוא הסדר במסמך (יוצא דופן שבו לסדר ה-Edge יש משמעות).

## לא ידוע ואין {#알-수-없음과-없음}

כשה-Value של QUALIFIER הוא סמן מקום, משתנה משמעות הסייג. נדגים עם זמן סיום (P582).

| מה שמצורף ל-TRIPLE היעד | משמעות | האם הטענה עדיין תקפה |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | הסתיים ב-1974 | לא |
| `QUALIFIER P582 #n UNKNOWN` | הסתיים. לא ידוע מתי (‏`somevalue` של Wikidata) | לא |
| `QUALIFIER P582 #n NONE` | נקבע שלא הסתיים (‏`novalue` של Wikidata) | כן |
| אין QUALIFIER של P582 | לא ידוע אם הסתיים (עולם פתוח) | לא ידוע |

- אם זורקים את ה-`somevalue` וה-`novalue` של qualifier ב-Wikidata, הטענה מתרחבת. TRIPLE של גבול שזרקנו ממנה את somevalue של זמן הסיום תיקרא כ“גבול שעדיין תקף”. לכן בהעברה מעבירים אותם כסמן.
- UNKNOWN-VALUE-ים אינם נחשבים לאותו ערך. תוצאת ההשוואה לא מוגדרת.

## דוגמה (לא נורמטיבית) {#예시-비규범}

Q42 ‏P69 (educated at) ‏Q691283 (St John's College), ‏1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. ה-Value הוא [EDTF](../value/0x06EL-edtf.md) ‏`"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

גבול (P47) בין Q30 (ארצות הברית) לבין Q34266 (האימפריה הרוסית), וזמן הסיום אינו ידוע. ה-Edge Id-ים הם `2060` ו-`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- ‏`0AB7` = ‏`000 0101 01011 0111` (קטע 5): ‏Edge, ‏Codec ‏`0x0ABL`, ‏8 WORD. ‏TAG 1 + Edge Id 2 + Property ‏P582 (‏`0191 0246`) 2 + Target ‏#2060 (‏`0051 080C`) 2 + סמן 1.

מצרפים תקופה ל-TRIPLE‏ `#3161` של NO-VALUE עבור בנק מרכזי (P1304) של Q30. בנק מרכזי חסר רק בשנים 1811~1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [סמן מקום](../slot-marker.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000AB0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
