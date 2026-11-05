---
title: "אינדקס קודים"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "הדף הזה הוא אינדקס של כל ה-Codec."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

הדף הזה הוא אינדקס של כל ה-Codec. לחיצה על שם מובילה למסמך הפירוט של אותו Codec. קוד ישיר שאינו בטבלה שמור (Reserved).

## Kind {#kind}

TAG WORD הוא `000K KKKC CCCC LLLL`. ארבעת הביטים העליונים `KKKK` הם הקטע, `C` הוא היסט של 5 ביט בתוך הקטע, ו-`LLLL` הוא ה-Length. 9 הביטים של הקטע ו-`C` יחד הם מקום ה-Codec. ה-TAG ID נכתב `0x000L`. שלוש הספרות הראשונות הן 9 הביטים האלה (`w >> 4`), ו-`L` הוא מקום ה-Length ([רשומה ו-TAG WORD](record.md)).

| קטע | TAG ID | סיווג | תיאור |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | רשומה המצביעה על יעד |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | רשומת ערך |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | רשומת הרכבה |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | רשומה על מסמכים ועל רשומות |

- הקטע הוא `S = w >> 9` (4 ביט), וכל קטע הוא 32 משבצות.
- ה-Kind נקבע לפי טווח הקטעים בלבד: `w < 0x0600` הוא Reference, ‏`w < 0x0A00` הוא Value, ‏`w < 0x1C00` הוא Edge, והשאר Meta. אין חריגים.
- שלוש המשבצות האחרונות בתחומי Reference, Value ו-Edge הן ISSUER (‏`..DL` ‏2 WORD, ‏`..EL` ‏4 WORD, ‏`..FL` ‏16 WORD). ב-Meta אין ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | שם | סיווג | ID של היעד |
|---|---|---|---|
| `0x000L~0x002L` | [סמן מקום](slot-marker.md) | סמן מקום | קבוצת סמנים של WORD אחד שאינם מצביעים על יעד (הטבלה שלהלן) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | הצהרה | ID שהמסמך הזה הנפיק |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | הצהרה | ישות ש-geul.org מנפיק תחת CC0. מספרים קטנים מוקצים לישויות בתדירות גבוהה |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | הצהרה | GEUL SIDX (‏Semantic-aligned Index). מזהה שהביטים שלו נושאים משמעות |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | הצהרה | פריט Wikidata. המספר השלם אחרי `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | הצהרה | תכונה ב-Wikidata. המספר השלם אחרי `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | הצבעה | ID מסוג LOCAL של מסמך שיובא באמצעות `IMPORT-DOC`. ID של IMPORT בגודל WORD אחד |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | הצבעה | כנ"ל. ID של IMPORT בגודל 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | הצבעה | כנ"ל. ID של IMPORT בגודל 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | הצבעה והצהרה | ID מסוג LOCAL של מסמך Issuer בן 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | הצבעה והצהרה | ID מסוג LOCAL של מסמך Issuer בן 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | הצבעה והצהרה | ID מסוג LOCAL של מסמך Issuer בן 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | הצבעה והצהרה | ה-Issuer עצמו. ה-Payload הוא רק Issuer (2/4/16 WORD) ואין ID של יעד |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | הצבעה והצהרה | גרסה אחת של מסמך Issuer. Issuer + ID של מסמך (4 WORD) + ID של גרסה (2 WORD), ואין ID של יעד |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | הצבעה והצהרה | גרסה אחת של Codec של Issuer. Issuer + ID של Codec (2 WORD) + ID של גרסה (2 WORD), ואין ID של יעד |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | פורמט Issuer | Issuer בן 2 WORD ומספר Codec בן 2 WORD. הסיווג והיעד נקבעים במסמך ה-Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | פורמט Issuer | Issuer בן 4 WORD ומספר Codec בן 2 WORD. כנ"ל |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | פורמט Issuer | Issuer בן 16 WORD ומספר Codec בן 2 WORD. כנ"ל |

- ל-Reference יש שלושה קטעים. קטע 0 ישויות `0x000L~0x01FL` (סמני מקום, מערכת 5Q), קטע 1 EXTERNAL ‏`0x020L~0x03FL`, קטע 2 שונות `0x040L~0x05FL` (מצביעים, REFERENCE-ISSUER). ה-Reserved הם `0x003L~0x004L`, ‏`0x01EL~0x01FL`, ‏`0x03EL~0x03FL`, ‏`0x043L~0x05CL`.
- קבוצות של 5 משבצות (מ-LOCAL עד EXTERNAL-ISSUER-16WORD) הן משבצת אחת לכל אחד מסדר ה-Quantifier שלהלן. למשל: WIKIDATA-QID מסוג Identified הוא `0x014L`, ומסוג Generic הוא `0x015L`.

### סמן מקום (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

‏`0x0000`, ‏`0x0010`, ‏`0x0020` — [סמן מקום](slot-marker.md). הוא מופיע במקום רק כשרשימת ה-CODEC של השדה מציינת את ה-WORD הזה במפורש.

| WORD | שם | משמעות | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | לא נרשם. שדה אופציונלי הושמט. לא נטען דבר על העולם | אין snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | לא ידוע. יש ערך אך לא ידוע מהו | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | אין. אין ערך | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | שם | משמעות | דוגמה |
|---|---|---|---|
| `0` | Identified | ישות מזוהה | אילון מאסק, קוריאה הדרומית |
| `1` | Generic | טענה כללית והגדרתית על סוג שלם. מתירה חריגים. | חייל מציית לפקודות |
| `2` | Free-choice | יעד כלשהו העונה על התנאי | כל חייל שהוא |
| `3` | Universal | כל היעדים בטווח נתון | כל החיילים |
| `4` | Variable | משתנה שיח | האיש ההוא, האישה הזאת |

- הכימות נקרא לפי ההיסט `C` בתוך הקטע. בקטע 0, אם `5 <= C < 30`, הכימות הוא `C % 5` והמערכת היא `C / 5` (1~5). בקטע 1, אם `C < 30`, הכימות הוא `C % 5` והמערכת היא `6 + C / 5` (6~11). אין שימוש בו בסמנים (קטע 0, ‏`C < 3`) ובקטע 2 (מצביעים, REFERENCE-ISSUER).
- ISSUER-POINTER, ‏DOC-POINTER ו-CODEC-POINTER הם משבצת אחת ללא כימות. הכימות של REFERENCE-ISSUER נקבע במסמך ה-Codec שה-Issuer הנפיק.

## Issuer {#issuer}

‏Issuer הוא הגורם המגדיר מסמכים ופורמטים — [Issuer ופרסום](issuer.md)

| מקום | משמעות |
|---|---|
| קודי ISSUER של Reference, ‏Value ו-Edge (שלוש המשבצות האחרונות בכל תחום) | פורמט שאותו Issuer הגדיר |
| ‏`DOC-ID` ב-Meta | ה-Issuer שהוציא את המסמך הזה |
| ‏`IMPORT-DOC` ב-Meta | ה-Issuer שהוציא את המסמך המיובא |
| ‏`EXTERNAL-ISSUER-*`, ‏`DOC-POINTER` ו-`CODEC-POINTER` ב-Reference | ה-Issuer שהוציא את המסמך או ה-Codec המוצבע (2/4/16 WORD) |
| ‏`ISSUER-POINTER` ב-Reference | ה-Issuer המוצבע עצמו (2/4/16 WORD) |

| רוחב Issuer | הנפקה |
|---|---|
| 2 WORD | רישום ב-geul.org. Issuer שעבר הוכחת בעלות על דומיין (למשל company.com). גם מספרים ש-geul.org הקצה לגופי תקינה ולמוסדות מרכזיים הם ברוחב הזה ([טבלת הקצאה ל-2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | רישום ב-geul.org. Issuer שנרשם בלי הוכחת בעלות |
| 16 WORD | הנפקה עצמית. נגזר מהמפתח הציבורי בלי רישום. לפי כללי היצירה שלהלן. |

### אלגוריתם החתימה של Issuer בן 16 WORD {#16-word-issuer-서명-알고리즘}

| ID של אלגוריתם חתימה | אלגוריתם |
|---|---|
| `0x0001` | Ed25519 |
| אחר | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

המשפחה של קוד ישיר היא `(קוד − 0xA0) >> 5` (הקוד הוא שלוש הספרות הראשונות של ה-TAG ID). כל משפחה היא 32 משבצות, והיא שווה לקטע `w >> 9` פחות 5. הקודים הישירים שהוקצו הם חמש המשפחות שלהלן. ‏`0x135L~0x1BCL` הוא Reserved (קטעים 10~12 הם Reserved לכל אורכם). לפורמט Issuer אין כלל משפחות.

| קטע | משפחה | קוד ישיר |
|---|---|---|
| 5 | היגד | `0x0A0L~0x0BFL` |
| 6 | ראיות | `0x0C0L~0x0DFL` |
| 7 | ביצוע | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | פורמט [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- ‏`0x11CL~0x11FL` הוא Reserved.
- ‏`0x1BDL~0x1BFL` (שלוש המשבצות האחרונות בקטע 13) הוא EDGE-ISSUER (פורמט ISSUER של Edge שלהלן).

### היגד (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | שם | תת-פורמט | תיאור |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | קשירה מכוונת שבה Subject מסוג Reference מצביע על Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | זהות: שני Reference מצביעים על אותו יעד |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | אי-זהות: שני Reference מצביעים על יעדים שונים |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | קושר ל-Subject שם שמכונה מתאימה אליו (`UTF8-TEXT-*`). חייב להיות ייחודי בטווח ולהתאים בדיוק, ואין בו שפה |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | קישור של שם בשפה (label) ל-Subject. ה-Object הוא UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | קישור של שם אחר (כינוי) ל-Subject. הפריסה זהה ל-LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | קישור של תיאור בשפה (description) ל-Subject. הפריסה זהה ל-LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | היגד פועל מקוצר |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | היגד פועל |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | טענה בסדר Predicate, ‏Subject, ‏Object ועוד rank. ה-Object הוא ערך או סמן UNKNOWN-VALUE או NO-VALUE. המשמעות היא האוסף של כל ה-QUALIFIER המצביעים על ה-Edge Id שלו |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | תנאי אחד המסייג את הטענה של Edge אחר. Property, ‏Target (‏Edge Id), ‏Value (ערך או סמן UNKNOWN-VALUE או NO-VALUE). הוא חלק מהטענה |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | יש | מבנה לייצוג תפיסות עולם |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | יש | מבנה לייצוג סדר של עולמות ואירועים |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | יש | מבנה סצנה לתיאור מאפייני תרחיש |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | פרסום מסמך. DOC-POINTER, ‏hash תוכן |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | ביטול תוקף (deprecate) של גרסה שפורסמה. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | מחיקה (מצבה) של גרסה שפורסמה. DOC-POINTER, קטגוריית סיבה |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | הצהרה על הרכב ה-Payload של Codec אחד. Kind ו-Codec של היעד |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | שדה אחד ב-Payload. ה-DECLARE שאליו הוא שייך, הרוחב: רשומה (Length של ה-TAG) או n WORD של ערך גולמי |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | ערך קוד אחד של שדה ערך גולמי. שדה, ערך קוד |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | Kind ו-Codec אחד שהשדה מקבל. שדה, WORD יעד (`000K KKKC CCCC LLLL`, ‏LLLL ‏0000 מדויק, ‏1111 תו כללי (כל 32 המשבצות של אותו קטע), וסמן מקום רק כיעד מדויק `0000`, ‏`0010`, ‏`0020`). בשדה רשומה יש כמה כאלה (רשימה סגורה), ובשדה ערך גולמי אחד (אותו Value ללא TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | קבוצה |
|---|---|
| `0x0A0L~0x0A7L` | הצבעה ושמות |
| `0x0A8L~0x0AFL` | טענות |
| `0x0B0L~0x0B7L` | מבנה |
| `0x0B8L~0x0BFL` | שונות |

### ראיות (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | שם | תת-פורמט | תיאור |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | מחבר רשומה אחת או מסמך שלם למקורם. Target (‏Edge Id ב-BODY, וב-HEAD הערך `0` = המסמך כולו), ‏Origin (‏Reference, ‏ABSENT או UNKNOWN-VALUE). אופי המקור נכתב ב-TRIPLE שה-Subject שלו הוא המקור, ואופי הציטוט (תאריך עיון, מיקום, hash של הטקסט המקורי) ב-QUALIFIER המצורף ל-SOURCE. ה-SOURCE של המסמך כולו וה-QUALIFIER שלו נמצאים ב-HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- טווח הטקסט המקורי, הגורם היוצר, מידת האמינות, תקופת התחולה לפי סעיף ורשומות ישנות נכתבים ב-QUALIFIER, והגרסה שבה הרשומה נכנסה לראשונה מחושבת מהיסטוריית הגרסאות ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### ביצוע (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | שם | תיאור |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | הצהרת פונקציה. סמל, רשימת סמלי פרמטרים, טיפוס החזרה, גוף (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | הצהרת טיפוס. סמל והרכב (רשימת סמלי שדות, ערכי enum, יעד כינוי) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | ביטוי קבוע. Value מובנה אחד |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | ביטוי אונרי. אופרטור של WORD אחד, אופרנד |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | ביטוי בינארי. אופרטור של WORD אחד, שמאל, ימין |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | קריאה. פונקציית יעד, מספר ארגומנטים, ארגומנט × מספר ארגומנטים |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | גישה לחבר. יעד, סמל שדה |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | גישה באינדקס. יעד, אינדקס |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | יצירת ערך מורכב (רשימה, רשומה). טיפוס, מספר איברים, איבר × מספר איברים |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | ביטוי תנאי. תנאי, ערך כשהוא אמת, ערך כשהוא שקר |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | קבוצה מסודרת של פקודות. מספר פקודות, פקודה × מספר פקודות |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | השמה. יעד (סמל, MEMBER, INDEX), ערך |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | הסתעפות לפי תנאי. תנאי, BLOCK לאמת, שקר (BLOCK או IF, ו-0 אם אין) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | הסתעפות מרובה. יעד, מספר ענפים, (ערך, BLOCK) × מספר ענפים, BLOCK ברירת מחדל (0 אם אין) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | לולאת תנאי. תנאי, BLOCK של הגוף |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | לולאת מעבר. סמל איבר, יעד, BLOCK של הגוף |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | בקרת לולאה. סוג של WORD אחד (break, continue), הלולאה היעד |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | החזרה. ערך (0 אם אין) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | הרמת שגיאה. ערך השגיאה |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | טיפול בשגיאות. BLOCK של הגוף, סמל שגיאה, BLOCK של הטיפול, BLOCK סיום (0 אם אין) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | קבוצה |
|---|---|
| `0x0E0L~0x0E7L` | הצהרות |
| `0x0E8L~0x0EFL` | ביטויים |
| `0x0F0L~0x0F7L` | פקודות |
| `0x0F8L~0x0FFL` | שגיאות |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

פירוט: [TOULMIN](toulmin/_index.md)

| Codec | שם | תיאור |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | הצהרת מקרה. גרף פסק דין המכיל צמתים וקשרים |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | הצהרת פרדיקט. פונקציית פסק דין או ביטוי פסק דין, קריטריון שיפוט (Spec), חוזה עובדות (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | הצהרת קריטריון שיפוט. קבועים ורשימות (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | הצהרת טענה. מציבה פרדיקט בתוך מקרה ככלל כללי (Warrant). אפשר לתקוף אותה. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | הצהרת ראיית נגד. תוקפת ויש לה מסקנה משלה. ה-Level כברירת מחדל הוא Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | הצהרת חריג. תוקפת בלי מסקנה משלה. ה-Level כברירת מחדל הוא Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | קשר תקיפה. פסק הדין של התוקף מקטין בהדרגה את פסק הדין של היעד. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | קשר הדרה. כשהתוקף Active, היעד מוסר באופן מכריע מהצבירה. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES בזוגות. הפריסה טרם נקבעה |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | הרכבת ביצוע. כשהצומת Active, מריץ מקרה משנה (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | פעולה שמתבצעת כשהצומת Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | פעולה שמתבצעת פעם אחת גם בניסיון חוזר |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | פעולת פיצוי של DO (saga). אם שלב מאוחר נכשל, מתבצעת בסדר הפוך. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | קישור שרק קובע פסק דין, בלי תופעות לוואי |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | נקודת כניסה חיצונית. מריצה מקרה או קובעת בו פסק דין |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | נקודת כניסה של אירוע או מחזור, בלי קריאה חיצונית |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | תוצאת פסק הדין של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך פסק דין, Activated, Excluded, Level. הפריסה טרם נקבעה. פסק הדין של המסמך כולו הוא Meta [VERDICT](meta/0x1E9L-verdict.md) (‏`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | ראיה לפסק דין. מיקום, ערך צפוי, ערך בפועל (Fact). הפריסה טרם נקבעה |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | קבוצה |
|---|---|
| `0x100L~0x107L` | הצהרות |
| `0x108L~0x10FL` | קשרים |
| `0x110L~0x117L` | ביצוע |
| `0x118L~0x11FL` | תוצאות (‏`0x11CL~0x11FL` הם Reserved) |

### פורמט TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

הטקסט המקורי, החלוקה לקטעים והצמתים והקשרים העזר של מסמך [TOULMIN](toulmin/_index.md).

| Codec | שם | תיאור |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | טקסט מקורי של המחבר. רוחב SPAN ו-Value מסוג UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | שם או מחרוזת |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | תחילת קטע. קוד קטע |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | תחילת טווח מקרה |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | סוף טווח מקרה |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | פסקת תיאור (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. ‏`this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. הפניה לפונקציה |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. ‏`is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. ‏`see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. קבוצת ביצוע מסודרת |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. מקרה ← שדה |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. פריט הגדרה ← ערך או טיפוס |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. פריט הגדרה ← שדה |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. נקודת כניסה ← מקרה, ביצוע |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. נקודת כניסה ← מקרה, פסק דין |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. טריגר ← מקרה |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. טריגר ← מקרה (‏`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. צומת ← מזהה גלובלי |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. כינוי ← נתיב (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. צומת ← TEXT, רישום שם |

- ‏`0x135L~0x1BCL` הוא Reserved.

### פורמט ISSUER של Edge {#edge-issuer-형식}

אחרי `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), ‏[-4WORD](edge/0x1BEL-edge-issuer-4word.md), ‏[-16WORD](edge/0x1BFL-edge-issuer-16word.md)) מגיע TAG ההרחבה של ה-Codec, ובו Issuer ומספר Codec בן 2 WORD. כרגע לא נרשם פורמט ISSUER של Edge.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

מספר ה-Value אינו מציין משפחה. הקודים הישירים נמצאים ב-`0x060L~0x081L` בלי Reserved. ‏`0x082L~0x09CL` הוא Reserved, ו-`0x09DL~0x09FL` הוא VALUE-ISSUER. שמות המשפחות (NUMERIC, DECIMAL, TIME, TEXT, BINARY) הם קבוצות נושא. זוגות זוגי ואי-זוגי מתחילים בקוד הזוגי.

| משפחה | קוד ישיר |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, ‏`0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### קוד ישיר {#직접-코드}

| Codec | שם | משפחה | תיאור |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false או true ב-WORD אחד קבוע |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | מספר שלם מסומן בשיטת המשלים ל-2 במספר ה-WORD המזערי |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | מספר שלם big-endian unsigned magnitude במספר ה-WORD המזערי |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | scalar מסוג IEEE 754 binary16/32/64/128 ב-Payload של 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | קו רוחב וקו אורך binary64 על כדור הארץ (WGS 84), אי-ודאות binary32 ו-Reference של היחידה שלה (ABSENT = לא ידוע) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference של גוף שמימי, קו רוחב וקו אורך binary64, אי-ודאות binary32 ו-Reference של היחידה שלה |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | amount מספרי של Value (מספר שלם, BINARY-FLOAT, עשרוני, שבר), Reference של יחידה, גבול תחתון ועליון. אפשר להשמיט את היחידה והגבולות (ABSENT ‏`0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | שבר ששומר את הכתיב המקורי: מונה שלם או עשרוני, מכנה שלם בלי סימן או עשרוני. בלי צמצום |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | ‏`C×10^E` כאשר `E` הוא signed exponent ו-`C` הוא coefficient במשלים ל-2 במספר ה-WORD המזערי |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | ‏`C×10^E` כאשר `E` הוא signed exponent ו-`C` הוא coefficient מסוג unsigned במספר ה-WORD המזערי |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | מספר ימים signed ביחס ל-`1970-01-01` בלוח proleptic Gregorian |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | מונה nanosecond מסוג unsigned מחצות של יום אזרחי |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | מונה שניות signed מ-epoch של Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | זמן שחלף ב-SI-second מסוג signed, בלי epoch |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | מחרוזת תאריך EDTF (‏ISO 8601-2). מספר בתים זוגי או אי-זוגי. אין להשתמש בו לתאריך שאפשר לכתוב כ-GREGORIAN-DATE |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | מחרוזת ערך תאריך של GEDCOM 7. שומרת את הכתיב המקורי של לוחות שנה אחרים (יוליאני ועוד). מספר בתים זוגי או אי-זוגי |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | רצף בתים valid UTF-8 שאינו מרמז על נורמליזציה. מספר בתים זוגי |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | כנ"ל. מספר בתים אי-זוגי |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | רצף בתי ASCII לפי production ‏`URI` של RFC 3986. מספר בתים זוגי |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | כנ"ל. מספר בתים אי-זוגי |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | רצף בתי ASCII של language tag מלא לפי BCP 47 בכתיב canonical. מספר בתים זוגי |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | כנ"ל. מספר בתים אי-זוגי |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | טקסט עם שפה. רשומת Value של שפה (LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE) ובתי UTF-8. זוגיות או אי-זוגיות של בתי הטקסט |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | תג BCP 47 במספר מ-GEUL Language Registry (‏Payload של WORD אחד) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | ‏UUID של 128 ביט לפי RFC 9562 ב-Payload קבוע של 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | תוצאת SHA-256 ב-Payload קבוע של 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | תוצאת SHA-1 ב-Payload קבוע של 10 WORD. רק לצורכי זיהוי, כמו ID של אובייקט ב-git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | רצף בתים שמשמעותו ופורמטו אינם ידועים. מספר בתים זוגי |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | כנ"ל. מספר בתים אי-זוגי |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N ביטים השמורים MSB-first אחרי bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | זמן שחלף ב-nanosecond מסוג signed, בלי epoch |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), ‏[-4WORD](value/0x09EL-value-issuer-4word.md), ‏[-16WORD](value/0x09FL-value-issuer-16word.md) |  | פורמט ש-Issuer הגדיר. ראו פורמט ISSUER של Value להלן |

### פורמט ISSUER של Value {#value-issuer-형식}

אחרי `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), ‏[-4WORD](value/0x09EL-value-issuer-4word.md), ‏[-16WORD](value/0x09FL-value-issuer-16word.md)) מגיע TAG ההרחבה של ה-Codec, ובו Issuer ומספר Codec בן 2 WORD. מסמך ה-Codec נמצא תחת `codecs/` של אותו Issuer, לפי מספר ה-Codec של הרשומה. למשל: CRC32C של IETF הוא `0x00000007/codecs/0x0000C000/` ([כתובת פרסום ורשימת גרסאות](publishing.md)).

| Issuer | מספר Codec | שם | תיאור |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | ביטי interchange של BF16 ב-Payload קבוע של WORD אחד |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | וקטור int16 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | וקטור uint16 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | וקטור int32 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | וקטור uint32 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | וקטור int64 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | וקטור uint64 רציף ב-big-endian |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | וקטור IEEE 754 binary16 רציף |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | וקטור BF16 רציף |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | וקטור IEEE 754 binary32 רציף |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | וקטור IEEE 754 binary64 רציף |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | וקטור דו-ממדי IEEE binary64 בסדר `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | וקטור תלת-ממדי IEEE binary64 בסדר `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | וקטור IEEE binary64 בסדר `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, ‏rank, ‏shape ו-payload צפוף C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, ‏rank, ‏shape ו-payload ארוז low-bit-first בתוך octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | שני binary32 בסדר `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | שני binary64 בסדר `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | numerator מסוג int64 מנורמל ו-denominator חיובי מסוג int64 |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | קטע סגור binary64 שבו `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | ארבעה binary32 בסדר `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | תוצאת BLAKE3 בסיסית ב-Payload קבוע של 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | רצף בתי ASCII של relative-ref לפי RFC 3986. מספר בתים זוגי |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | כנ"ל. מספר בתים אי-זוגי |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | תוצאת Castagnoli CRC-32C ב-Payload קבוע של 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | כתובת IPv4 של 32 ביט ב-Payload קבוע של 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | כתובת IPv6 של 128 ביט ב-Payload קבוע של 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | ‏IEEE 754 decimal32 ‏DPD ב-Payload קבוע של 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | ‏IEEE 754 decimal64 ‏DPD ב-Payload קבוע של 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | ‏IEEE 754 decimal128 ‏DPD ב-Payload קבוע של 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | ‏IEEE 754 decimal32 ‏BID ב-Payload קבוע של 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | ‏IEEE 754 decimal64 ‏BID ב-Payload קבוע של 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | ‏IEEE 754 decimal128 ‏BID ב-Payload קבוע של 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | מונה nanosecond מסוג signed מ-epoch של Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | כתובת IEEE 802 MAC של 48 ביט ב-Payload קבוע של 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | וקטור packed קבוע של 4×UNORM8 בסדר R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | וקטור packed קבוע של 4×UNORM8 בסדר B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | scalar מסוג ONNX E4M3FN ב-octet העליון של ה-Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | scalar מסוג ONNX E4M3FNUZ ב-octet העליון של ה-Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | scalar מסוג ONNX E5M2 ב-octet העליון של ה-Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | scalar מסוג ONNX E5M2FNUZ ב-octet העליון של ה-Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | scalar מסוג unsigned exponent-only ‏E8M0FNU ב-octet העליון של ה-Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | scalar מסוג ONNX/DLPack ‏E2M1FN ב-nibble העליון של ה-Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | מונה SI-second מסוג signed מ-`1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | מונה nanosecond מסוג signed מאותו epoch של TAI |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | תוצאת SHA-512 ב-Payload קבוע של 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | תוצאת SHA3-256 ב-Payload קבוע של 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | מונה שניות signed מ-epoch של GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | מונה nanosecond מסוג signed מ-epoch של GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

מספרי Meta אינם מציינים מחלקה בביטים. המחלקה ידועה מטבלת הטווחים שלהלן. מחלקת האימות ידועה בלי ספר Codec: בקטע 15 הרשומות שבהן `C >= 5`, כלומר `w >= 0x1E50`. ב-Meta אין קודי ISSUER.

| מחלקה | קוד ישיר | עוסקת ב |
|---|---|---|
| [מבנה](meta/_index.md#구조) | `0x1C0L~0x1C4L` | גבולות המסמך ואורכו |
| [הצהרה](meta/_index.md#정의) | `0x1C5L~0x1CAL` | הצהרות פירוש |
| [מוצא](meta/_index.md#출처) | `0x1CBL~0x1D0L` | מי, מתי, מאיפה |
| [שושלת](meta/_index.md#계보) | `0x1D1L~0x1DDL` | ממה ואיך נוצר |
| [מדיניות](meta/_index.md#정책) | `0x1DEL~0x1E3L` | איך מטפלים בו |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | מייבא מסמך חיצוני באמצעות ID של IMPORT (‏`IMPORT-DOC`) |
| [אימות](meta/_index.md#검증) | `0x1E5L~0x1E9L` | האם אפשר לסמוך עליו |
| Reserved (לאימות בלבד) | `0x1EAL~0x1FFL` |  |

- המספרים רציפים מ-`0x1C0L` בלי Reserved. אי אפשר להכניס Meta חדש שאינו אימות לפני האימות. ה-Reserved שאחריו, `0x1EAL~0x1FFL`, מיועד לאימות בלבד. אם יושם כאן Meta שאינו אימות, הוא ייעדר מ-hash התוכן.

### מבנה (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | שם | תיאור |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | תחילת מסמך שהאורך הכולל שלו מצוין ב-Payload של WORD אחד |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | תחילת מסמך שהאורך הכולל שלו מצוין ב-Payload של 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | תחילת מסמך שהאורך הכולל שלו מצוין ב-Payload של 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | ‏WORD אחד. מסיים את ה-HEAD של המסמך ומתחיל את ה-BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | ‏WORD אחד. סוגר את המסמך. |

### הצהרה (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | שם | תיאור |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | גרסת מפרט GEUL שהמסמך מציית לה. ה-Payload הוא עצמו מספר שלם unsigned ברוחב הקצר ביותר. v1 הוא `0x0001` (הרשומה `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | פרופיל מיושם |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | המזהה של המסמך הזה. ‏Reference מובנה `DOC-POINTER` (‏Issuer, ID של מסמך, גרסה 0). במסמך Codec: `CODEC-POINTER` (‏Issuer, ID של Codec, גרסה 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | יום התחולה של הגרסה הזו. Value מסוג GREGORIAN-DATE או POSIX-TIMESTAMP. אם אין, זמן הפרסום |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | סוף תקופת התוקף של הגרסה הזו (חוק לזמן קצוב). אם אין, עד שהגרסה הבאה נכנסת לתוקף |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | שפת ברירת מחדל |

### מוצא (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | שם | תיאור |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | מחבר. ‏Reference (‏git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | מחבר שותף. ‏Reference (‏git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | זמן הכתיבה. ‏Value מסוג TIME (‏git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | זמן העריכה. ‏Value מסוג TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | הגורם שרשם. ‏Reference (‏git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | זמן הרישום. ‏Value מסוג TIME (‏git commit date) |

- חומר המקור, טווחו, זמן השגתו וה-hash שלו נכתבים לא ב-Meta אלא ב-Edge של ראיות ב-HEAD, [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (‏Target ‏`0`), וב-QUALIFIER שלו.

### שושלת (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | שם | תיאור |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | hash התוכן של הגרסה הקודמת (git parent). אם אין, זו הגרסה הראשונה, ואם יש כמה, זהו מיזוג (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | נגזר מרשומות או מחומר של שושלת אחרת. כדי לקבע גרסה מסוימת של חומר חיצוני, מצרפים ל-[SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) ב-HEAD את ה-QUALIFIER של hash הטקסט המקורי (P4092) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | הגורם שיצר. אדם, מודל, מנוע כללים |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | שיטת ההמרה. כלי, כללים, גרסה |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | hash התוכן של הגרסה המקורית שממנה נלקח שינוי משושלת אחרת (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | hash התוכן של הגרסה שהשינוי בה בוטל (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | hash התוכן של הגרסה שנכתבה מחדש (git amend·rebase). הגרסה המקורית אינה נמחקת. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | hash התוכן של הגרסאות המקוריות שאוחדו לאחת (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | סיבת השינוי. ‏Value מסוג UTF8-LANGUAGE-TEXT, אחד לכל שפה (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | שם בלתי משתנה שניתן לגרסה. ‏Value מסוג TEXT ו-hash תוכן (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | קובץ הגרסה הזו הוא diff ביחס לגרסת הבסיס של אותו מסמך (ID גרסה של 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | רשימת ID מסוג LOCAL (‏Edge Id) להסרה מה-BODY של הבסיס ב-diff |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | ה-ID מסוג LOCAL שיוקצה הבא (auto increment). מוצב ב-HEAD של רשימת הגרסאות `versions.geul` |

### מדיניות (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | שם | תיאור |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | רישיון. ‏Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | היקף החשיפה |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | דרגת פרטיות |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | תקופת שמירה |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | היקף ההסכמה ובסיסה |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | הגבלות שימוש |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | שם | תיאור |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | מייבא מסמך חיצוני באמצעות ID של IMPORT. ‏Reference מובנה `DOC-POINTER` (במסמך Codec: `CODEC-POINTER`) + ID של IMPORT |

### אימות (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | שם | תיאור |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | הצהרה על ID של אלגוריתם החתימה והמפתח הציבורי של Issuer בהנפקה עצמית |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | חתימה על יעד. חתימה על מסמך היא חתימה על hash התוכן (חתימת commit ו-tag ב-git) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | אישור זכות התרומה. ‏Reference (‏git `Signed-off-by`, ‏DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | מידת אמינות |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | תוצאת פסק הדין של המסמך כולו. ‏Pass, ‏Review, ‏Fail. ברמת צומת או רשומה: [TOULMIN](toulmin/_index.md) ‏`VERDICT` (‏Edge ‏`0x118L`) |

## טבלת הקצאה מלאה {#전체-배정표}

227 משבצות הוקצו, ו-176 קובצי md. במערכת 5Q ובזוגות זוגי-אי-זוגי יש שורה לכל חבר, וה-md הוא ה-md של ראש הקבוצה.

| TAG ID | Codec ID | שם | Kind | קטע | md | קבוצה |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | זוגי-אי-זוגי `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | זוגי-אי-זוגי `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | זוגי-אי-זוגי `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | זוגי-אי-זוגי `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | זוגי-אי-זוגי `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | זוגי-אי-זוגי `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | זוגי-אי-זוגי `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | זוגי-אי-זוגי `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | זוגי-אי-זוגי `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | זוגי-אי-זוגי `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | זוגי-אי-זוגי `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | זוגי-אי-זוגי `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | זוגי-אי-זוגי `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | זוגי-אי-זוגי `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
