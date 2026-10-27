---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER היא Edge תיאורית שמוסיפה תנאי אחד שמגביל את הטענה של Edge אחרת, בדרך כלל TRIPLE (Codec 0x0B). ב-Value אפשר לכתוב במקום ערך 'לא ידוע' (UNKNOWN-VALUE) או 'אין' (NO-VALUE)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER היא Edge תיאורית שמוסיפה תנאי אחד שמגביל את הטענה שמכילה Edge אחרת (בדרך כלל [TRIPLE](/he/grammar/edge/triple/)). Codec `0x0B`.

היא זהה ל-qualifier (snak) אחד של Wikidata: מאפיין אחד וערך אחד.

## פריסה

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Property          רשומת Reference (WIKIDATA-PID וכד')
Target            רשומת LOCAL Reference (ה-Edge Id של ה-Edge המוגבלת)
Value             רשומת Reference או Value, או סמן מקום 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
```

- סדר הרכיבים זהה ל-TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). המפענח קורא באותו מסלול. התפקידים נקבעים על ידי ה-Codec.

## פירוש ותקינות

- Property ו-Target הם כל אחד רשומת Reference שלמה אחת בדיוק, ו-Target הוא LOCAL Reference. מסמך המפרט של geul.org קובע ב-Target את [CODEC](/he/grammar/edge/codec/) LOCAL (`0008`). Value הוא רשומת Reference או Value שלמה אחת בדיוק, או [סמן מקום](/he/grammar/reference/slot-marker/) של WORD אחד `0x0001` (UNKNOWN-VALUE) או `0x0002` (NO-VALUE). מסמך המפרט קובע ב-Value את CODEC `0780`, `0F80`, `0001`, `0002`. ABSENT (`0x0000`) אינו מתקבל. Property ו-Target אינם מקבלים סמן מקום. הסמן שקרא את ה-Value חייב להתלכד עם סוף ה-Edge.
- ה-Target הוא Edge Id בתוך אותו מסמך. QUALIFIER ממוקם באותו מסמך שבו נמצאת ה-Edge המוגבלת.
- אם ה-Target הוא [SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) של ה-HEAD (המקור של המסמך כולו), גם ה-QUALIFIER ממוקם ב-HEAD, אחרי אותו SOURCE. כל QUALIFIER אחר ממוקם ב-BODY. QUALIFIER שה-Target שלו הוא SOURCE של ה-HEAD ושנמצא ב-BODY הוא invalid.
- ה-Target יכול להיות Edge שאינה TRIPLE. QUALIFIER שמצורף ל-[SOURCE](/he/grammar/edge/source/) מגביל את פעולת הציטוט (תאריך גישה, מיקום בתוך המקור וכד'). גם המשמעות של SOURCE היא אוסף כל ה-QUALIFIER שמצביעים עליו.
- **QUALIFIER הוא חלק מהטענה.** הוא אינו טענה נפרדת על הטענה אלא מגביל את התנאי שבו הטענה נכונה. המשמעות של ה-TRIPLE שהוא מצביע עליו היא אוסף כל ה-QUALIFIER שמצביעים עליה.
  - המקור של טענה נכתב כ-[SOURCE](/he/grammar/edge/source/). תכונות של צומת מקור (כותרת, מחבר וכד') נכתבות כ-TRIPLE שה-Subject שלה הוא המקור.
- יכולים להיות כמה QUALIFIER של אותו Property באותו Target. סדר ה-QUALIFIER עם אותו Target הוא הסדר במסמך (חריג שבו לסדר ה-Edge יש משמעות).

## לא ידוע ואין

אם ה-Value של QUALIFIER הוא סמן מקום, משמעות ההגבלה משתנה. ניקח לדוגמה את זמן הסיום (P582).

| מה שמצורף ל-TRIPLE של היעד | משמעות | האם הטענה עדיין בתוקף |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | הסתיימה ב-1974 | לא |
| `QUALIFIER P582 #n UNKNOWN` | הסתיימה. לא ידוע מתי (`somevalue` ב-Wikidata) | לא |
| `QUALIFIER P582 #n NONE` | קובע שלא הסתיימה (`novalue` ב-Wikidata) | כן |
| אין QUALIFIER של P582 | לא ידוע אם הסתיימה (עולם פתוח) | לא ידוע |

- אם זורקים `somevalue` ו-`novalue` של qualifier ב-Wikidata, הטענה מתרחבת. TRIPLE של גבול שנזרק ממנה `somevalue` של זמן הסיום תיקרא כ"גבול שעדיין בתוקף". לכן מעבירים אותם כסמנים.
- UNKNOWN-VALUE אינו נחשב לאותו ערך כמו UNKNOWN-VALUE אחר. תוצאת ההשוואה לא מוכרעת.

## דוגמה (לא נורמטיבית)

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. ה-Value הוא [EDTF](/he/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

הגבול (P47) בין Q30 (ארצות הברית) ל-Q34266 (האימפריה הרוסית), זמן הסיום לא ידוע. Edge Id `2060`·`3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + סמן 1.

מצרפים תקופה ל-TRIPLE `#3161` של NO-VALUE עבור בנק מרכזי (P1304) של Q30. לא היה רק בין 1811 ל-1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [TRIPLE](/he/grammar/edge/triple/), [SOURCE](/he/grammar/edge/source/), [WIKIDATA-PID](/he/grammar/reference/wikidata-pid/), [EDTF](/he/grammar/value/time/edtf/), [סמן מקום](/he/grammar/reference/slot-marker/)
