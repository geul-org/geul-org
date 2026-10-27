---
title: "דקדוק GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "מפרט הדקדוק של GEUL v1. מגדיר רשומות על גבי WORD של 16 ביט, ארבעת סוגי ה-Kind וכל ה-Codec, מבנה המסמך, וכללי Issuer ופרסום."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

זהו מפרט הדקדוק של GEUL v1. בקריאה ראשונה קוראים לפי הסדר שלהלן.

1. [סקירה](/he/grammar/overview/) — מהי GEUL ובאילו עקרונות תוכננה
2. [רשומות ו-TAG WORD](/he/grammar/record/) — TAG WORD של 16 ביט, Kind, Length, Codec
3. [מסמך](/he/grammar/document/) — HEAD ו-BODY, hash תוכן, גרסאות ותיקונים
4. [Reference](/he/grammar/reference/), [Value](/he/grammar/value/), [Edge](/he/grammar/edge/), [Meta](/he/grammar/meta/) — ארבעת סוגי ה-Kind
5. [Issuer ופרסום](/he/grammar/issuer/) — הגורם שמוציא מסמכים ופורמטים, טבלת ההקצאה ל-WORD אחד, שיטת הפרסום, חתימה ומפתח אימות
6. [כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/) — רישום ID, כתובת פרסום, ציון פורמט, אינדקס שמות, רשימת גרסאות, שכבות אמון
7. [מסמך מפרט Codec](/he/grammar/codec-spec/) — איך כותבים פריסת Codec כמסמך GEUL
8. [דוגמה: פריט Wikidata](/he/grammar/example/) — מסמך אחד שלם

הדף הזה הוא אינדקס של כל ה-Codec. לחיצה על שם מובילה למסמך הפירוט של אותו Codec. שם בלי קישור עדיין אין לו מסמך פירוט. קוד ישיר שאינו בטבלה שמור (Reserved).

## Kind

TAG WORD הוא `000K KLLL LCCC CCCC`. `KK` הוא ה-Kind, `LLLL` הוא ה-Length, ו-`CCC CCCC` הם 7 ביטים של Codec. ב-Reference, לעומת זאת, יש 4 ביטים של Codec ו-3 ביטים של Quantifier.

| ערך | סיווג | תיאור |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/he/grammar/reference/) | רשומה שמצביעה על יעד. `QQQ` הוא ה-Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/he/grammar/value/) | רשומת ערך |
| `0001 0LLL LCCC CCCC` | [Edge](/he/grammar/edge/) | רשומת קישור |
| `0001 1LLL LCCC CCCC` | [Meta](/he/grammar/meta/) | רשומה על המסמך ועל רשומות |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/he/grammar/reference/)

### Codec (`CCCC`)

| CCCC | שם | סיווג | ID של היעד |
|---|---|---|---|
| `0000` | [סמן מקום](/he/grammar/reference/slot-marker/) | שמור | קבוצת סמנים של WORD אחד שאינם מצביעים על יעד. שלושת הביטים התחתונים הם מספר הסמן (טבלה בהמשך) |
| `0001` | [LOCAL](/he/grammar/reference/local/) | הצהרה | ID שהמסמך הזה הנפיק |
| `0010` | [GEUL](/he/grammar/reference/geul/) | הצהרה | ישות ש-geul.org מנפיקה ב-CC0. מספרים קטנים מוקצים לישויות בעלות תדירות גבוהה |
| `0011` | [GEUL-SIDX](/he/grammar/reference/geul-sidx/) | הצהרה | GEUL SIDX (Semantic-aligned Index). מזהה שהביטים שלו נושאים משמעות |
| `0100` | [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/) | הצהרה | פריט Wikidata. המספר השלם שאחרי `Q` |
| `0101` | [WIKIDATA-PID](/he/grammar/reference/wikidata-pid/) | הצהרה | מאפיין Wikidata. המספר השלם שאחרי `P` |
| `0110` | [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/) | הצבעה-הצהרה | ה-Issuer עצמו. ה-Payload הוא ה-Issuer בלבד (1/2/4/16 WORD) ואין ID של יעד |
| `0111` | [DOC-POINTER](/he/grammar/reference/doc-pointer/) | הצבעה-הצהרה | גרסה אחת של מסמך Issuer. Issuer + 4 WORD של מזהה מסמך + 2 WORD של מזהה גרסה, ללא ID של יעד |
| `1000` | [EXTERNAL-POINTER-1WORD](/he/grammar/reference/external-pointer/) | הצבעה | LOCAL ID של מסמך שיובא ב-`IMPORT-DOC`. IMPORT ID של WORD אחד |
| `1001` | [EXTERNAL-POINTER-2WORD](/he/grammar/reference/external-pointer/) | הצבעה | כמו לעיל. IMPORT ID של 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/he/grammar/reference/external-pointer/) | הצבעה | כמו לעיל. IMPORT ID של 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/he/grammar/reference/external-pointer/) | הצבעה | כמו לעיל. IMPORT ID של 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/he/grammar/reference/external-issuer/) | הצבעה-הצהרה | LOCAL ID של מסמך Issuer בן WORD אחד |
| `1101` | [EXTERNAL-ISSUER-2WORD](/he/grammar/reference/external-issuer/) | הצבעה-הצהרה | LOCAL ID של מסמך Issuer בן 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/he/grammar/reference/external-issuer/) | הצבעה-הצהרה | LOCAL ID של מסמך Issuer בן 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/he/grammar/reference/external-issuer/) | הצבעה-הצהרה | LOCAL ID של מסמך Issuer בן 16 WORD |

### סמן מקום (Codec `0000`)

`0000 0000 0000 0MMM` — [סמן מקום](/he/grammar/reference/slot-marker/). מופיע במקום רק כשרשימת ה-CODEC של השדה מציינת בדיוק את ה-WORD הזה.

| WORD | שם | משמעות | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/he/grammar/reference/slot-marker/) | לא נכתב. שדה רשות הושמט. אין שום קביעה על העולם | אין snak |
| `0x0001` | [UNKNOWN-VALUE](/he/grammar/reference/slot-marker/) | לא ידוע. יש ערך אך לא ידוע מהו | `somevalue` |
| `0x0002` | [NO-VALUE](/he/grammar/reference/slot-marker/) | אין. אין ערך | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | שם | משמעות | דוגמה |
|---|---|---|---|
| `000` | Identified | ישות מזוהה | אילון מאסק, מדינת ישראל |
| `001` | Generic | קביעה כללית או מגדירה על סוג שלם. מתירה חריגים. | חייל מציית לפקודות |
| `010` | Free-choice | כל יעד שמקיים את התנאי | כל חייל שהוא |
| `011` | Universal | כל היעדים בטווח נתון | כל החיילים |
| `100` | Variable | משתנה שיח | האיש ההוא, האישה הזאת |
| `101`~`111` | Reserved |  |  |

- ב-Codec `0000` (סמן מקום) שלושת הביטים התחתונים הם מספר הסמן ולא Quantifier.

## Issuer

Issuer הוא הגורם שמגדיר מסמכים ופורמטים — [Issuer ופרסום](/he/grammar/issuer/)

| מקום | משמעות |
|---|---|
| קודי ISSUER של Value ושל Edge (`0x7C`~`0x7F`) | הפורמט ש-Issuer זה הגדיר |
| Meta `DOC-ID` | ה-Issuer שהוציא את המסמך הזה |
| Meta `IMPORT-DOC` | ה-Issuer שהוציא את המסמך המיובא |
| Reference `EXTERNAL-ISSUER-*` ו-`DOC-POINTER` | ה-Issuer שהוציא את המסמך המוצבע (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | ה-Issuer המוצבע עצמו (1/2/4/16 WORD) |

| רוחב Issuer | הנפקה |
|---|---|
| WORD אחד | geul.org מקצה לגופי תקינה ולמוסדות מרכזיים ([טבלת הקצאה ל-WORD אחד](/he/grammar/issuer/#טבלת-הקצאה-ל-word-אחד)). |
| 2 WORD | רישום ב-geul.org. Issuer שעבר הוכחת בעלות על דומיין (למשל company.com) |
| 4 WORD | רישום ב-geul.org. Issuer שנרשם בלי הוכחת בעלות |
| 16 WORD | הנפקה עצמית. מחושב מהמפתח הציבורי בלי רישום. לפי כלל היצירה שלהלן. |

### אלגוריתם חתימה של Issuer בן 16 WORD

| ID של אלגוריתם חתימה | אלגוריתם |
|---|---|
| `0x0001` | Ed25519 |
| אחר | שמור |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/he/grammar/edge/)

שני הביטים העליונים של ה-Codec קובעים את המשפחה. אותו כלל חל על קוד ישיר (7 ביט) ועל מספר פורמט ISSUER (16 ביט).

| שני הביטים העליונים | משפחה | קוד ישיר | מספר פורמט |
|---|---|---|---|
| `00` | תיאור | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | ראיה | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | ביצוע | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/he/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### תיאור (`00`)

| CCCCC | Codec | שם | תת-פורמט | תיאור |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/he/grammar/edge/reference-node/) |  | קשירה מכוונת ש-Subject שהוא Reference מצביע בה על Object |
| `00001` | `0x01` | [SAME-NODE](/he/grammar/edge/same-node/) |  | זהות: שני Reference מצביעים על אותו יעד |
| `00010` | `0x02` | [DIFFERENT-NODE](/he/grammar/edge/different-node/) |  | אי-זהות: שני Reference מצביעים על יעדים שונים |
| `00011` | `0x03` | [BIND](/he/grammar/edge/bind/) |  | קושרת ל-Subject שם שהמכונה מתאימה אליו (`UTF8-TEXT-*`). ייחודי בתחום, חייב להתאים במדויק, ואין לו שפה |
| `00100` | `0x04` | [LABEL](/he/grammar/edge/label/) |  | קישור שם בשפה (label) של ה-Subject. ה-Object הוא UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/he/grammar/edge/alias/) |  | קישור שם נוסף (כינוי) של ה-Subject. הפריסה זהה ל-LABEL |
| `00110` | `0x06` | [DESCRIPTION](/he/grammar/edge/description/) |  | קישור תיאור (description) של ה-Subject בשפה. הפריסה זהה ל-LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | תיאור פועלי, מקוצר |
| `01001` | `0x09` | VERB |  | תיאור פועלי |
| `01010` | `0x0A` | [TRIPLE](/he/grammar/edge/triple/) |  | טענה בסדר Predicate, Subject, Object ו-rank. ה-Object הוא ערך או סמן UNKNOWN-VALUE·NO-VALUE. המשמעות היא אוסף כל ה-QUALIFIER שמצביעים על ה-Edge Id שלה |
| `01011` | `0x0B` | [QUALIFIER](/he/grammar/edge/qualifier/) |  | תנאי אחד שמגביל את הטענה של Edge אחרת. Property, Target (Edge Id), Value (ערך או סמן UNKNOWN-VALUE·NO-VALUE). הוא חלק מהטענה |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | יש | מבנה לייצוג עולם בדיוני |
| `10001` | `0x11` | TIMELINE | יש | מבנה לייצוג סדר של עולמות ואירועים |
| `10010` | `0x12` | SCENE | יש | מבנה סצנה לתיאור מאפייני תסריט |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/he/grammar/edge/publication/) |  | פרסום מסמך. DOC-POINTER, hash תוכן |
| `11001` | `0x19` | DEPRECATION |  | המלצה להפסיק להשתמש בגרסה שפורסמה. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | מחיקה (מצבה) של גרסה שפורסמה. DOC-POINTER, קטגוריית סיבה |
| `11011` | `0x1B` | [DECLARE](/he/grammar/edge/declare/) |  | הצהרה על מבנה ה-Payload של Codec אחד. Kind ו-Codec של היעד |
| `11100` | `0x1C` | [FIELD](/he/grammar/edge/field/) |  | שדה Payload אחד. ה-DECLARE שאליו הוא שייך, רוחב: רשומה (ה-Length של ה-TAG) או ערך גולמי של n WORD |
| `11101` | `0x1D` | [ENUM](/he/grammar/edge/enum/) |  | ערך קוד אחד של שדה גולמי. שדה, ערך קוד |
| `11110` | `0x1E` | [CODEC](/he/grammar/edge/codec/) |  | Kind ו-Codec אחד שהשדה מקבל. שדה, WORD של היעד (`000K KLLL LCCC CCCC`, LLLL `0000` מדויק·`1111` תו כללי, סמן מקום רק כיעד מדויק `0000`~`0002`). בשדה רשומה יש כמה כאלה (רשימה סגורה), בשדה גולמי רק אחד (ה-Value בלי TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| שני הביטים העליונים של CCCCC | קבוצה |
|---|---|
| `00` | הצבעה ושמות |
| `01` | טענות |
| `10` | מבנה |
| `11` | אחר |

### ראיה (`01`)

| Codec | שם | תת-פורמט | תיאור |
|---|---|---|---|
| `0x20` | [SOURCE](/he/grammar/edge/source/) |  | מקשרת רשומה אחת או את המסמך כולו למקור שלה. Target (Edge Id ב-BODY, ב-HEAD `0` = המסמך כולו), Origin (Reference, ABSENT או UNKNOWN-VALUE). תכונות המקור נכתבות כ-TRIPLE שה-Subject שלה הוא המקור, ותכונות הציטוט (תאריך גישה, מיקום, hash של הטקסט המקורי) כ-QUALIFIER שמצורף ל-SOURCE. ה-SOURCE של המסמך כולו וה-QUALIFIER שלו ממוקמים ב-HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- טווח בטקסט המקור, מי יצר, מידת אמון, תקופת תוקף לפי סעיף ורשומה ישנה נכתבים כ-QUALIFIER, והגרסה שנכנסה ראשונה מחושבת מהיסטוריית הגרסאות ([SOURCE](/he/grammar/edge/source/#ייצוג-של-ראיות-אחרות)).

### ביצוע (`10`)

| CCCCC | Codec | שם | תיאור |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | הצהרת פונקציה. סמל, רשימת סמלי פרמטרים, טיפוס החזרה, גוף (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | הצהרת טיפוס. סמל ומבנה (רשימת סמלי שדות, ערכי enum, יעד כינוי) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | ביטוי קבוע. Value מוטמע אחד |
| `01001` | `0x49` | UNARY | ביטוי אונרי. אופרטור של WORD אחד, אופרנד |
| `01010` | `0x4A` | BINARY | ביטוי בינרי. אופרטור של WORD אחד, שמאל, ימין |
| `01011` | `0x4B` | CALL | קריאה. פונקציית היעד, מספר ארגומנטים, ארגומנט × מספר הארגומנטים |
| `01100` | `0x4C` | MEMBER | גישה לחבר. יעד, סמל שדה |
| `01101` | `0x4D` | INDEX | גישה באינדקס. יעד, אינדקס |
| `01110` | `0x4E` | CONSTRUCT | יצירת ערך מורכב (רשימה, רשומה). טיפוס, מספר איברים, איבר × מספר האיברים |
| `01111` | `0x4F` | CONDITIONAL | ביטוי תנאי. תנאי, ערך כשהתנאי נכון, ערך כשהוא שקרי |
| `10000` | `0x50` | BLOCK | קבוצה סדורה של פקודות. מספר פקודות, פקודה × מספר הפקודות |
| `10001` | `0x51` | ASSIGN | השמה. יעד (סמל, MEMBER, INDEX), ערך |
| `10010` | `0x52` | IF | הסתעפות. תנאי, BLOCK לנכון, ענף שקר (BLOCK·IF, 0 אם אין) |
| `10011` | `0x53` | SWITCH | הסתעפות מרובה. יעד, מספר ענפים, (ערך, BLOCK) × מספר הענפים, BLOCK ברירת מחדל (0 אם אין) |
| `10100` | `0x54` | WHILE | לולאת תנאי. תנאי, BLOCK של הגוף |
| `10101` | `0x55` | FOREACH | לולאת מעבר. סמל האיבר, יעד, BLOCK של הגוף |
| `10110` | `0x56` | JUMP | בקרת לולאה. סוג של WORD אחד (break, continue), הלולאה המיועדת |
| `10111` | `0x57` | RETURN | החזרה. ערך (0 אם אין) |
| `11000` | `0x58` | RAISE | העלאת שגיאה. ערך השגיאה |
| `11001` | `0x59` | TRY | טיפול בשגיאה. BLOCK של הגוף, סמל השגיאה, BLOCK של הטיפול, BLOCK של הסיום (0 אם אין) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| שני הביטים העליונים של CCCCC | קבוצה |
|---|---|
| `00` | הצהרה |
| `01` | ביטוי |
| `10` | פקודה |
| `11` | שגיאה |

### TOULMIN (`11`)

לפירוט: [TOULMIN](/he/grammar/edge/toulmin/)

| CCCCC | Codec | שם | תיאור |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/he/grammar/edge/toulmin/node/) | הצהרת מקרה. גרף הכרעה שמכיל צמתים ויחסים |
| `00001` | `0x61` | [PREDICATE-DECLARE](/he/grammar/edge/toulmin/expr/) | הצהרת פרדיקט. פונקציית הכרעה או ביטוי, קריטריון שיפוט (Spec), חוזה עובדות (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/he/grammar/edge/toulmin/node/) | הצהרת קריטריון שיפוט. קבוע או רשימה (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/he/grammar/edge/toulmin/node/) | הצהרת טענה. מציבה פרדיקט במקרה ככלל כללי (Warrant). אפשר לתקוף אותה. |
| `00100` | `0x64` | [COUNTER-DECLARE](/he/grammar/edge/toulmin/node/) | הצהרת ראיית-נגד. תוקפת ויש לה מסקנה משלה. ה-Level כברירת מחדל הוא Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/he/grammar/edge/toulmin/node/) | הצהרת חריג. תוקף בלי מסקנה משלו. ה-Level כברירת מחדל הוא Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/he/grammar/edge/toulmin/link/) | יחס תקיפה. ההכרעה של התוקף מקטינה בהדרגה את ההכרעה של היעד. |
| `01001` | `0x69` | [SUPERSEDES](/he/grammar/edge/toulmin/link/) | יחס דחיקה. כשהתוקף Active, היעד מוצא באופן מכריע מהצבירה. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES בזוגות. הפריסה טרם נקבעה |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/he/grammar/edge/toulmin/link/) | הרכבת ביצוע. כשהצומת Active, מריצה מקרה משנה (DAG). |
| `10001` | `0x71` | [DO](/he/grammar/edge/toulmin/link/) | פעולה שמתבצעת כשהצומת Active |
| `10010` | `0x72` | [DO-ONCE](/he/grammar/edge/toulmin/link/) | פעולה שמתבצעת פעם אחת בלבד גם בניסיון חוזר |
| `10011` | `0x73` | [UNDO](/he/grammar/edge/toulmin/link/) | פעולת פיצוי של DO (saga). אם שלב מאוחר נכשל, מתבצעת בסדר הפוך. |
| `10100` | `0x74` | [CHECKING](/he/grammar/edge/toulmin/link/) | קישור שרק מכריע, בלי תופעות לוואי |
| `10101` | `0x75` | [ENTRY](/he/grammar/edge/toulmin/node/) | נקודת כניסה חיצונית. מריצה או מכריעה מקרה |
| `10110` | `0x76` | [TRIGGER](/he/grammar/edge/toulmin/node/) | נקודת כניסה של אירוע או מחזור, בלי קריאה חיצונית |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | תוצאת הכרעה של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך הכרעה, Activated, Excluded, Level. הפריסה טרם נקבעה. ההכרעה של המסמך כולו היא Meta [VERDICT](/he/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | ראיה להכרעה. מיקום, ערך צפוי, ערך בפועל (Fact). הפריסה טרם נקבעה |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | פורמט שה-Issuer הגדיר |

| שני הביטים העליונים של CCCCC | קבוצה |
|---|---|
| `00` | הצהרה |
| `01` | יחס |
| `10` | ביצוע |
| `11` | תוצאה (`0x7C`~`0x7F` הם ISSUER) |

### פורמט ISSUER של Edge

אחרי `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), ב-TAG הרחבת ה-Codec, באים ה-Issuer ומספר הפורמט. שני הביטים העליונים של מספר הפורמט קובעים את המשפחה. מרחב מספרי הפורמט נפרד מזה של Value.

| Issuer | מספר פורמט | שם | משפחה | תיאור |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/he/grammar/edge/toulmin/source/) | TOULMIN | טקסט מקור של הכותב. רוחב SPAN ו-Value של UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/he/grammar/edge/toulmin/source/) | TOULMIN | שם או מחרוזת |
| `0x0000` GEUL | `0xC002` | [SECTION](/he/grammar/edge/toulmin/source/) | TOULMIN | תחילת סעיף. קוד סעיף |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/he/grammar/edge/toulmin/source/) | TOULMIN | תחילת טווח של מקרה |
| `0x0000` GEUL | `0xC004` | [CASE-END](/he/grammar/edge/toulmin/source/) | TOULMIN | סוף טווח של מקרה |
| `0x0000` GEUL | `0xC005` | [PROSE](/he/grammar/edge/toulmin/source/) | TOULMIN | פסקת תיאור (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/he/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/he/grammar/edge/toulmin/node/) | TOULMIN | NODE. הפניה לפונקציה |
| `0x0000` GEUL | `0xC012` | [FIELD](/he/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/he/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/he/grammar/edge/toulmin/node/) | TOULMIN | NODE. קבוצת ביצוע סדורה |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. מקרה → שדה |
| `0x0000` GEUL | `0xC021` | [MEANS](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. פריט הגדרה → ערך או טיפוס |
| `0x0000` GEUL | `0xC022` | [HAS](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. פריט הגדרה → שדה |
| `0x0000` GEUL | `0xC023` | [RUNS](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. נקודת כניסה → מקרה, ביצוע |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. נקודת כניסה → מקרה, הכרעה |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. trigger → מקרה |
| `0x0000` GEUL | `0xC026` | [UNTIL](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. trigger → מקרה (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. צומת → מזהה גלובלי |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. כינוי → נתיב (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/he/grammar/edge/toulmin/link/) | TOULMIN | LINK. צומת → TEXT, רישום שם |

## Value

`0000 1LLL LCCC CCCC` — [Value](/he/grammar/value/)

שני הביטים העליונים של ה-Codec קובעים את המשפחה. NUMERIC/DECIMAL מתחלקים עוד לפי הביט השלישי מלמעלה (`000` NUMERIC, `001` DECIMAL).

| שני הביטים העליונים | משפחה | קוד ישיר | מספר פורמט |
|---|---|---|---|
| `00` | [NUMERIC](/he/grammar/value/numeric/)/[DECIMAL](/he/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/he/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/he/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/he/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### קוד ישיר

| Codec | שם | משפחה | תיאור |
|---|---|---|---|
| `0x00` | [BOOL](/he/grammar/value/numeric/bool/) | NUMERIC | false או true ברוחב קבוע של WORD אחד |
| `0x01` | [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/) | NUMERIC | מספר שלם חתום בשיטת המשלים ל-2 במינימום WORD |
| `0x02` | [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/) | NUMERIC | מספר שלם unsigned magnitude בשיטת big-endian במינימום WORD |
| `0x03` | [BINARY-FLOAT](/he/grammar/value/numeric/binary-float/) | NUMERIC | scalar של IEEE 754 binary16/32/64/128 עם Payload של 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/he/grammar/value/numeric/coordinate-earth/) | NUMERIC | קו רוחב וקו אורך על כדור הארץ (WGS 84) ב-binary64, אי-ודאות ב-binary32 ו-Reference של יחידה שלה (ABSENT = לא ידוע) |
| `0x05` | [COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference של גרם שמים, קו רוחב וקו אורך ב-binary64, אי-ודאות ב-binary32 ו-Reference של יחידה שלה |
| `0x06` | [QUANTITY](/he/grammar/value/numeric/quantity/) | NUMERIC | amount מסוג Value מספרי (שלם, BINARY-FLOAT, עשרוני, שבר), Reference של יחידה, גבול תחתון ועליון. היחידה והגבולות יכולים להיות מושמטים (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/he/grammar/value/numeric/fraction/) | NUMERIC | שבר ששומר על הכתיב המקורי: מונה שלם או עשרוני, מכנה שלם או עשרוני בלי סימן. לא מצומצם |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` ממעריך חתום `E` ומקדם `C` בשיטת המשלים ל-2 במינימום WORD |
| `0x11` | [UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` ממעריך חתום `E` ומקדם `C` unsigned במינימום WORD |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) | TIME | מספר ימים חתום ביחס ל-`1970-01-01` בלוח proleptic Gregorian |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/he/grammar/value/time/civil-time-nanoseconds/) | TIME | מספר unsigned של ננו-שניות מאז חצות של יום אזרחי |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/) | TIME | מספר חתום של שניות מאז epoch של Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/he/grammar/value/time/duration-seconds/) | TIME | זמן שחלף חתום ב-SI-second, בלי epoch |
| `0x24`/`0x25` | [EDTF](/he/grammar/value/time/edtf/) | TIME | מחרוזת תאריך EDTF (ISO 8601-2). מספר זוגי·אי-זוגי של בייטים. תאריך שאפשר לכתוב ב-GREGORIAN-DATE לא נכתב כך |
| `0x26`/`0x27` | [GEDCOM-DATE](/he/grammar/value/time/gedcom-date/) | TIME | מחרוזת ערך תאריך של GEDCOM 7. שומרת את הכתיב המקורי של לוחות שנה אחרים (יוליאני ועוד). מספר זוגי·אי-זוגי של בייטים |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/he/grammar/value/text/utf8-text/) | TEXT | רצף בייטים תקין של UTF-8 בלי רמז לנרמול. מספר זוגי של בייטים |
| `0x41` | [UTF8-TEXT-ODD](/he/grammar/value/text/utf8-text/) | TEXT | כמו לעיל. מספר אי-זוגי של בייטים |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/he/grammar/value/text/uri/) | TEXT | רצף בייטים ASCII לפי production `URI` של RFC 3986. מספר זוגי של בייטים |
| `0x45` | [URI-ODD](/he/grammar/value/text/uri/) | TEXT | כמו לעיל. מספר אי-זוגי של בייטים |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/he/grammar/value/text/language-bcp47-code/) | TEXT | רצף בייטים ASCII של language tag מלא לפי BCP 47 באותיות קנוניות. מספר זוגי של בייטים |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/he/grammar/value/text/language-bcp47-code/) | TEXT | כמו לעיל. מספר אי-זוגי של בייטים |
| `0x48` | [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/) | TEXT | קוד דחוס של שפה ראשית ב-GEUL, Payload קבוע של WORD אחד |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/) | TEXT | טקסט עם שפה. רשומת Value של שפה (LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE) ובייטים של UTF-8. זוגי·אי-זוגי לפי בייטי הטקסט |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/he/grammar/value/binary/uuid/) | BINARY | UUID של 128 ביט לפי RFC 9562, Payload קבוע של 8 WORD |
| `0x61` | [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/) | BINARY | תוצאת SHA-256, Payload קבוע של 16 WORD |
| `0x62` | [SHA1-DIGEST](/he/grammar/value/binary/sha1-digest/) | BINARY | תוצאת SHA-1, Payload קבוע של 10 WORD. רק לצורכי זיהוי, כמו מזהה אובייקט של git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | פורמט שה-Issuer הגדיר. ראו להלן פורמט ISSUER של Value |

### פורמט ISSUER של Value

אחרי `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), ב-TAG הרחבת ה-Codec, באים ה-Issuer ומספר הפורמט. שני הביטים העליונים של מספר הפורמט קובעים את המשפחה.

| Issuer | מספר פורמט | שם | משפחה | תיאור |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/he/grammar/value/time/duration-nanoseconds/) | TIME | זמן שחלף חתום בננו-שניות, בלי epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/he/grammar/value/binary/opaque-bytes/) | BINARY | רצף בייטים שמשמעותו ופורמטו אינם ידועים. מספר זוגי של בייטים |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/he/grammar/value/binary/opaque-bytes/) | BINARY | כמו לעיל. מספר אי-זוגי של בייטים |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/he/grammar/value/binary/bit-vector/) | BINARY | N ביטים שנשמרים MSB-first אחרי bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | ביטי interchange של BF16, Payload קבוע של WORD אחד |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/he/grammar/value/vector/dense-i16-vector/) | NUMERIC | וקטור int16 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/he/grammar/value/vector/dense-u16-vector/) | NUMERIC | וקטור uint16 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/he/grammar/value/vector/dense-i32-vector/) | NUMERIC | וקטור int32 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/he/grammar/value/vector/dense-u32-vector/) | NUMERIC | וקטור uint32 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/he/grammar/value/vector/dense-i64-vector/) | NUMERIC | וקטור int64 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/he/grammar/value/vector/dense-u64-vector/) | NUMERIC | וקטור uint64 רציף ב-big-endian |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/he/grammar/value/vector/dense-binary16-vector/) | NUMERIC | וקטור IEEE 754 binary16 רציף |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/he/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | וקטור BF16 רציף |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/he/grammar/value/vector/dense-binary32-vector/) | NUMERIC | וקטור IEEE 754 binary32 רציף |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/he/grammar/value/vector/dense-binary64-vector/) | NUMERIC | וקטור IEEE 754 binary64 רציף |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/he/grammar/value/vector/point2-binary64/) | NUMERIC | וקטור דו-ממדי של IEEE binary64 בסדר `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/he/grammar/value/vector/point3-binary64/) | NUMERIC | וקטור תלת-ממדי של IEEE binary64 בסדר `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/he/grammar/value/vector/bbox2-binary64/) | NUMERIC | וקטור IEEE binary64 בסדר `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/he/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape ו-payload צפוף C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/he/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape ו-payload ארוז low-bit-first בתוך octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/he/grammar/value/etc/complex64/) | NUMERIC | שני binary32 בסדר `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/he/grammar/value/etc/complex128/) | NUMERIC | שני binary64 בסדר `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/he/grammar/value/etc/rational-i64/) | NUMERIC | numerator של int64 מנורמל ו-denominator חיובי של int64 |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/he/grammar/value/etc/closed-interval-binary64/) | NUMERIC | קטע סגור של binary64 עם `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/he/grammar/value/etc/quaternion-binary32/) | NUMERIC | ארבעה binary32 בסדר `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/he/grammar/value/binary/blake3-256-digest/) | BINARY | תוצאת BLAKE3 ברירת מחדל, Payload קבוע של 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/he/grammar/value/text/uri-relative-ref/) | TEXT | רצף בייטים ASCII של relative-ref לפי RFC 3986. מספר זוגי של בייטים |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/he/grammar/value/text/uri-relative-ref/) | TEXT | כמו לעיל. מספר אי-זוגי של בייטים |
| `0x0020` IETF | `0xC000` | [CRC32C](/he/grammar/value/binary/crc32c/) | BINARY | תוצאת Castagnoli CRC-32C, Payload קבוע של 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/he/grammar/value/binary/ipv4-address/) | BINARY | כתובת IPv4 של 32 ביט, Payload קבוע של 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/he/grammar/value/binary/ipv6-address/) | BINARY | כתובת IPv6 של 128 ביט, Payload קבוע של 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/he/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, Payload קבוע של 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/he/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, Payload קבוע של 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/he/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, Payload קבוע של 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/he/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, Payload קבוע של 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/he/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, Payload קבוע של 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/he/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, Payload קבוע של 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/he/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | מספר חתום של ננו-שניות מאז epoch של Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/he/grammar/value/binary/mac-48-address/) | BINARY | כתובת IEEE 802 MAC של 48 ביט, Payload קבוע של 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/he/grammar/value/vector/rgba8-unorm/) | NUMERIC | וקטור packed קבוע של 4×UNORM8 בסדר R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/he/grammar/value/vector/bgra8-unorm/) | NUMERIC | וקטור packed קבוע של 4×UNORM8 בסדר B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | scalar של ONNX E4M3FN ב-octet העליון של ה-Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | scalar של ONNX E4M3FNUZ ב-octet העליון של ה-Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | scalar של ONNX E5M2 ב-octet העליון של ה-Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | scalar של ONNX E5M2FNUZ ב-octet העליון של ה-Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | scalar unsigned של exponent בלבד E8M0FNU ב-octet העליון של ה-Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | scalar של ONNX/DLPack E2M1FN ב-nibble העליון של ה-Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/he/grammar/value/time/tai-timestamp-seconds/) | TIME | מספר חתום של SI-second מאז `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/he/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | מספר חתום של ננו-שניות מאז אותו epoch של TAI |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/he/grammar/value/binary/sha-512-digest/) | BINARY | תוצאת SHA-512, Payload קבוע של 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/he/grammar/value/binary/sha3-256-digest/) | BINARY | תוצאת SHA3-256, Payload קבוע של 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/he/grammar/value/time/gps-timestamp-seconds/) | TIME | מספר חתום של שניות מאז epoch של GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/he/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | מספר חתום של ננו-שניות מאז epoch של GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/he/grammar/meta/)

שלושת הביטים העליונים של ה-Codec הם המחלקה. ב-Meta אין קודי ISSUER.

| שלושת הביטים העליונים | מחלקה | קוד ישיר | נושא |
|---|---|---|---|
| `000` | [מבנה](/he/grammar/meta/structure/) | `0x00`~`0x0F` | גבולות המסמך ואורכו |
| `001` | [הצהרה](/he/grammar/meta/declaration/) | `0x10`~`0x1F` | הצהרות פירוש |
| `010` | [מוצא](/he/grammar/meta/provenance/) | `0x20`~`0x2F` | מי, מתי, איפה |
| `011` | [שושלת](/he/grammar/meta/lineage/) | `0x30`~`0x3F` | ממה ואיך נוצר |
| `100` | [אימות](/he/grammar/meta/verification/) | `0x40`~`0x4F` | האם אפשר לסמוך עליו |
| `101` | [מדיניות](/he/grammar/meta/policy/) | `0x50`~`0x5F` | איך מטפלים בו |
| `110` | [IMPORT](/he/grammar/meta/import/) | `0x60`~`0x6F` | מייבא מסמך חיצוני באמצעות IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### מבנה (`000`)

| Codec | שם | תיאור |
|---|---|---|
| `0x00` | [DOC-1WORD](/he/grammar/meta/structure/doc/) | תחילת מסמך, האורך הכולל נקבע ב-Payload של WORD אחד |
| `0x01` | [DOC-2WORD](/he/grammar/meta/structure/doc/) | תחילת מסמך, האורך הכולל נקבע ב-Payload של 2 WORD |
| `0x02` | [DOC-4WORD](/he/grammar/meta/structure/doc/) | תחילת מסמך, האורך הכולל נקבע ב-Payload של 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/he/grammar/meta/structure/body/) | WORD אחד. מסיים את ה-HEAD של המסמך ופותח את ה-BODY. |
| `0x0F` | [END](/he/grammar/meta/structure/end/) | WORD אחד. סוגר את המסמך. |

### הצהרה (`001`)

| Codec | שם | תיאור |
|---|---|---|
| `0x10` | [SPEC-VERSION](/he/grammar/meta/declaration/spec-version/) | גרסת מפרט GEUL שהמסמך מציית לה. ה-Payload הוא עצמו מספר שלם unsigned ברוחב הקצר ביותר. v1 הוא `0x0001` (הרשומה `0x1890 0x0001`) |
| `0x11` | [PROFILE](/he/grammar/meta/declaration/profile/) | פרופיל שחל |
| `0x12` | [DOC-ID](/he/grammar/meta/declaration/doc-id/) | מזהה המסמך הזה. Reference מוטמע `DOC-POINTER` (Issuer, מזהה מסמך, גרסה 0) |
| `0x13` | [EFFECTIVE-FROM](/he/grammar/meta/declaration/effective-from/) | יום כניסת הגרסה הזו לתוקף. Value מסוג GREGORIAN-DATE או POSIX-TIMESTAMP. אם אין, זמן הפרסום |
| `0x14` | [EFFECTIVE-UNTIL](/he/grammar/meta/declaration/effective-until/) | סוף תקופת התוקף של הגרסה הזו (חוק זמני). אם אין, עד שתיכנס לתוקף הגרסה הבאה |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/he/grammar/meta/declaration/default-language/) | שפת ברירת מחדל |
| `0x17`~`0x1F` | Reserved |  |

### מוצא (`010`)

| Codec | שם | תיאור |
|---|---|---|
| `0x20` | [AUTHOR](/he/grammar/meta/provenance/author/) | כותב. Reference (git author) |
| `0x21` | [CO-AUTHOR](/he/grammar/meta/provenance/co-author/) | כותב שותף. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/he/grammar/meta/provenance/created-at/) | זמן כתיבה. Value מסוג TIME (git author date) |
| `0x23` | [MODIFIED-AT](/he/grammar/meta/provenance/modified-at/) | זמן שינוי. Value מסוג TIME |
| `0x24` | [RECORDED-BY](/he/grammar/meta/provenance/recorded-by/) | הגורם שתיעד. Reference (git committer) |
| `0x25` | [RECORDED-AT](/he/grammar/meta/provenance/recorded-at/) | זמן התיעוד. Value מסוג TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- חומר המקור, הטווח שלו, זמן ההשגה וה-hash אינם נכתבים ב-Meta אלא ב-Edge הראיה [SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) (Target `0`) שב-HEAD וב-QUALIFIER שלה.

### שושלת (`011`)

| Codec | שם | תיאור |
|---|---|---|
| `0x30` | [PARENT](/he/grammar/meta/lineage/parent/) | hash התוכן של הגרסה הקודמת הישירה (git parent). אם אין, זו הגרסה הראשונה, ואם יש כמה, זו מיזוג (git merge commit). |
| `0x31` | [DERIVED-FROM](/he/grammar/meta/lineage/derived-from/) | נגזר מרשומה או מחומר של שושלת אחרת. כדי לנעול גרסה מסוימת של חומר חיצוני, מצרפים ל-[SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) שב-HEAD QUALIFIER של hash הטקסט המקורי (P4092) (git submodule). |
| `0x32` | [GENERATED-BY](/he/grammar/meta/lineage/generated-by/) | הגורם שיצר. אדם, מודל, מנוע כללים |
| `0x33` | [TRANSFORMED-BY](/he/grammar/meta/lineage/transformed-by/) | שיטת ההמרה. כלי, כלל, גרסה |
| `0x34` | [CHERRY-PICKED-FROM](/he/grammar/meta/lineage/cherry-picked-from/) | hash התוכן של הגרסה המקורית שממנה נלקח שינוי משושלת אחרת (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/he/grammar/meta/lineage/reverts/) | hash התוכן של הגרסה שהשינוי שלה בוטל (git revert) |
| `0x36` | [REPLACES](/he/grammar/meta/lineage/replaces/) | hash התוכן של הגרסה שנכתבה מחדש (git amend·rebase). הגרסה המקורית אינה נמחקת. |
| `0x37` | [SQUASHED-FROM](/he/grammar/meta/lineage/squashed-from/) | hash התוכן של הגרסאות המקוריות שאוחדו לאחת (git squash) |
| `0x38` | [MESSAGE](/he/grammar/meta/lineage/message/) | סיבת השינוי. Value מסוג UTF8-LANGUAGE-TEXT, אחד לכל שפה (git commit message) |
| `0x39` | [TAG](/he/grammar/meta/lineage/tag/) | שם בלתי משתנה שניתן לגרסה. Value מסוג TEXT ו-hash תוכן (git annotated tag) |
| `0x3A` | [DELTA-BASE](/he/grammar/meta/lineage/delta-base/) | קובץ הגרסה הזה הוא diff ביחס לגרסת בסיס של אותו מסמך (מזהה גרסה של 2 WORD) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/he/grammar/meta/lineage/delta-remove/) | רשימת LOCAL ID (Edge Id) שיש להסיר מה-BODY של הבסיס ב-diff |
| `0x3C` | [NEXT-LOCAL-ID](/he/grammar/meta/lineage/next-local-id/) | ה-LOCAL ID הבא להקצאה (auto increment). נמצא ב-HEAD של רשימת הגרסאות `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### אימות (`100`)

| Codec | שם | תיאור |
|---|---|---|
| `0x40` | [ISSUER-KEY](/he/grammar/meta/verification/issuer-key/) | הצהרה על ID של אלגוריתם החתימה ועל המפתח הציבורי של Issuer בהנפקה עצמית |
| `0x41` | [SIGNATURE](/he/grammar/meta/verification/signature/) | חתימה על יעד. חתימה על מסמך היא חתימה על hash התוכן (git signed commit·tag) |
| `0x42` | [SIGNED-OFF](/he/grammar/meta/verification/signed-off/) | אישור זכות התרומה. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/he/grammar/meta/verification/confidence/) | מידת אמון |
| `0x44` | [VERDICT](/he/grammar/meta/verification/verdict/) | תוצאת ההכרעה של המסמך כולו. Pass, Review, Fail. ברמת צומת·רשומה, [TOULMIN](/he/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### מדיניות (`101`)

| Codec | שם | תיאור |
|---|---|---|
| `0x50` | [LICENSE](/he/grammar/meta/policy/license/) | רישיון. Reference |
| `0x51` | [ACCESS](/he/grammar/meta/policy/access/) | היקף חשיפה |
| `0x52` | [PRIVACY](/he/grammar/meta/policy/privacy/) | דרגת מידע אישי |
| `0x53` | [RETENTION](/he/grammar/meta/policy/retention/) | תקופת שמירה |
| `0x54` | [CONSENT](/he/grammar/meta/policy/consent/) | היקף ההסכמה ובסיסה |
| `0x55` | [USAGE](/he/grammar/meta/policy/usage/) | מגבלות שימוש |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | שם | תיאור |
|---|---|---|
| `0x60` | [IMPORT-DOC](/he/grammar/meta/import/import-doc/) | מייבא מסמך חיצוני באמצעות IMPORT ID. Reference מוטמע `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
