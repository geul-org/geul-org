---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge היא רשומה שקושרת רשומות אחרות כרכיבים ומתארת אותן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge היא רשומה שקושרת רשומות אחרות כרכיבים ומתארת אותן. היגדים כמו "Q42 הוא אדם" או "השם האנגלי של Q42 הוא Douglas Adams" הם כל אחד Edge אחת.

## פריסה {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      קטעים 5~13 (0x0A0L~0x1BFL)
[Length extension TAG]
[Codec extension TAG]  בפורמט Issuer
Edge Id           רשומת LOCAL Reference
רכיבים            בסדר שה-Codec קובע
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל TAG WORD, פחות 1. המפענח מדלג לרשומה הבאה לפי Length בלבד, גם בלי להכיר את ה-Codec.
- **הרכיב הראשון הוא תמיד Edge Id (LOCAL Reference).** מכיוון שזהו LOCAL Reference (`0051` + ID, Identified `0x005L`), אפשר לקרוא את ה-Edge Id גם בלי להכיר את ה-Codec.
- כל רכיב מוצא את גבולותיו לפי ה-Length של עצמו. המקום שבו נגמר הרכיב האחרון חייב להתלכד בדיוק עם סוף ה-Edge.
- מבנה הרכיבים (Payload) נקבע במסמך ה-Codec של כל Edge.
- ל-Codec שיש לו תת-פורמטים (WORLD, TIMELINE, SCENE) יש TAG של WORD אחד לכל Codec שקובע את התת-פורמט.
- לסדר בין רשומות Edge אין משמעות (אלא אם Codec קבע אחרת. למשל: מסמך [TOULMIN](../toulmin/_index.md)).
- מצביעים ל-Edge אחרת באמצעות Edge Id. Edge במסמך זה מוזכרת כ-LOCAL, ו-Edge במסמך אחר מוזכרת באמצעות Reference מצביע (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## משפחות {#계열}

אזור ה-Edge הוא `0x0A0L~0x1BFL`. המשפחה של קוד ישיר היא `(קוד − 0xA0) >> 5` (הקוד הוא שלוש הספרות הראשונות של TAG ID). כל משפחה היא 32 משבצות, והיא שווה ל-`w >> 9` של הקטע פחות 5. ה-Edge תופסת את קטעים 5~13.

| קטע | משפחה | קוד ישיר | תפקיד |
|---|---|---|---|
| 5 | היגד | `0x0A0L~0x0BFL` | בונה תוכן על העולם ועל אירועים |
| 6 | ראיות | `0x0C0L~0x0DFL` | מאיפה באו הרשומות והמסמך ([SOURCE](0x0C0L-source.md)) |
| 7 | ביצוע | `0x0E0L~0x0FFL` | מבנה תוכנית שאפשר להריץ (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | גרף טיעונים: טענה, ראיית נגד, חריג, יחסי תקיפה, ביצוע, תוצאת פסק דין |
| 9 | פורמט [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | הטקסט המקורי, החלוקות, צמתי העזר והיחסים של מסמך TOULMIN |

- הקודים הישירים שהוקצו הם חמש המשפחות האלה. `0x11CL~0x11FL` הם Reserved, וכך גם `0x135L~0x1BCL` (קטעים 10~12 הם Reserved בשלמותם).
- `0x1BDL~0x1BFL` (שלוש המשבצות האחרונות של קטע 13) הם EDGE-ISSUER (ראו Edge בפורמט Issuer להלן). בפורמט Issuer אין כלל משפחות.

## Edge של היגד {#서술-edge}

| Codec | שם | רכיבים |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | קשירה מכוונת: Subject (Reference) מצביע על Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | שני Reference מצביעים על אותו יעד |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | שני Reference מצביעים על יעדים שונים |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | קושרת ל-Subject שם למכונה (UTF8-TEXT) |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | שם ה-Subject בכל שפה (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | שם נוסף של ה-Subject. הפריסה זהה ל-LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | תיאור ה-Subject בכל שפה. הפריסה זהה ל-LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | היגד פועלי |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | טענה אחת (Predicate, Subject, Object) ו-rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | תנאי אחד שמסייג את הטענה של Edge אחרת |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | עולם, סדר אירועים, מבנה סצנה |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | פרסום גרסה של מסמך, המלצה להפסיק להשתמש בה, מחיקה ([כתובת פרסום ורשימת גרסאות](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | אוצר המילים לכתיבת מפרט Codec ([מסמך מפרט Codec](../codec-spec.md)) |

- `-SHORT` והצורה הרגילה מוצבים כזוג זוגי-אי-זוגי (VERB-SHORT `0x0A8L` / VERB `0x0A9L`). LABEL מקבלת את השפה כרשומת שפה בתוך ה-Object (UTF8-LANGUAGE-TEXT), ולכן משתמשים רק ב-`0x0A4L`.
- PUBLICATION, DEPRECATION ו-TOMBSTONE נכתבות במסמך רשימת גרסאות. מפני שצריך לקרוא רשימת גרסאות בלי codebook, הן מובנות במפענח ([כתובת פרסום ורשימת גרסאות](../publishing.md#층), שכבה 0).
- DECLARE, FIELD, ENUM ו-CODEC הן אוצר המילים לכתיבת מפרט Codec. מפני שצריך לקרוא מסמך מפרט בלי codebook, הפריסה שלהן מובנית במפענח (שכבה 0). כל מסמך מפרט Codec שנכתב באוצר מילים זה הוא מסמך רגיל.

### TRIPLE {#triple}

פרטים: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (מאפיין של Wikidata וכד')
Subject           Reference
Object            Reference או Value
Rank              WORD אחד
```

| Rank | שם | משמעות |
|---|---|---|
| `0` | normal | ברירת מחדל |
| `1` | preferred | הערך הנוכחי, הסמכותי ביותר |
| `2` | deprecated | ערך שנקבע שהוא שגוי או מיושן אך נשמר כתיעוד |

- Rank זהה ל-statement rank של Wikidata. במקור שאינו מדרג, משתמשים ב-`0`.
- **משמעות ה-TRIPLE היא הסך של כל ה-QUALIFIER שמצביעים על ה-Edge Id שלה.** הקורא אוסף את ה-QUALIFIER לפני שהוא מפרש את ה-TRIPLE.

דוגמה: Q42 — P31 (instance of) — Q5 (אדם), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

פרטים: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (ה-Edge Id של ה-Edge המסויגת)
Value             Reference או Value
```

- QUALIFIER היא חלק מהטענה. היא אינה טענה נפרדת על הטענה, אלא מסייגת את התנאי שבו הטענה נכונה (זמן התחלה וסיום, תחום תחולה וכד').
- טענה נפרדת על הטענה (למשל מי טען אותה) נכתבת כ-TRIPLE.
- Target היא Edge באותו מסמך. סדר ה-QUALIFIER של אותו Target הוא הסדר במסמך.

דוגמה: Q42 — P69 (educated at) — Q691283, התחלה (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

פרטים: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- השם והשפה נכנסים יחד ב-Object אחד (UTF8-LANGUAGE-TEXT).
- לאותו Subject ואותה שפה יש לכל היותר LABEL אחת. שמות נוספים נכתבים כ-ALIAS.
- שם למכונה בלי שפה נכתב כ-BIND. ל-LABEL חייבת להיות שפה.

### BIND {#bind}

פרטים: [BIND](0x0A3L-bind.md)

- קושרת ל-Subject שם שהמכונה מתאימה אליו (UTF8-TEXT). אין לו שפה והוא אינו מנורמל. שמות הם אותו שם רק אם הבתים זהים.
- תחום השם הוא המסמך שמכיל את ה-BIND. במסמך אחד לא קושרים אותו שם ל-Subject שונים.
- רשומות אחרות מצביעות באמצעות LOCAL ID ולא באמצעות שם. השם משמש להתאמה עם החוץ (פונקציות מארח, קלט כתובת, בני אדם).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

פרטים: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE היא זהות: שני Reference מצביעים על אותו יעד. היא רפלקסיבית, סימטרית וטרנזיטיבית.
- DIFFERENT-NODE היא אי-זהות: שני Reference הם יעדים שונים.
- REFERENCE-NODE היא קשירה מכוונת שמגדירה באמצעות ה-Object מהו ה-Subject (Reference). היא אינה טענת זהות. למשל: מגדירה את ה-URI שצומת LOCAL מצביע עליו.

## Edge של ראיות {#근거-edge}

מצרפת ראיות לרשומה בודדת בתוך BODY, או למסמך כולו (HEAD). הקוד הישיר היחיד במשפחת הראיות הוא [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | שם | רכיבים |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (ה-Edge Id של Edge ב-BODY שמצרפים לה ראיות. ב-HEAD: `0` = המסמך כולו), Origin (Reference של המקור, ABSENT או UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- תכונות המקור עצמו (URL, כותרת, מחבר, תאריך פרסום …) נכתבות כ-TRIPLE שה-Subject שלה הוא המקור. תכונות הציטוט (תאריך גישה, מיקום בתוך המקור …) נכתבות כ-QUALIFIER שה-Target שלו הוא ה-Edge Id של ה-SOURCE.
- מקור המסמך כולו נכתב ב-HEAD כ-SOURCE עם Target `0`, וגם ה-QUALIFIER שה-Target שלו הוא אותה SOURCE נמצא ב-HEAD. אלה שתי ה-Edge היחידות שבאות ב-HEAD, ו-HEAD ו-BODY חולקים מרחב מספרים אחד של Edge Id ([מקור המסמך כולו](0x0C0L-source.md#문서-전체의-출처)).
- ראיות אחרות (טווח בטקסט המקורי, מי יצר, מידת אמון, תקופת תוקף לפי סעיף, רשומות ישנות) נכתבות כ-QUALIFIER, והגרסה שנכנסה ראשונה מחושבת מהיסטוריית הגרסאות ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- תוצאת פסק דין ברמת הרשומה היא תפקידו של `VERDICT` ב-TOULMIN.

### SOURCE {#source}

פרטים: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (ה-Edge Id של Edge ב-BODY שמצרפים לה ראיות, ב-HEAD: 0 = המסמך כולו)
Origin            Reference או סמן מקום 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

דוגמה: המקור של TRIPLE `#178` (Q42 P19) הוא Britannica (Q5375741), והמזהה בתוכו P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge של ביצוע {#실행-edge}

מבנה תוכנית שאינו קשור לשפת תכנות מסוימת. הרכיבים מוזכרים ב-LOCAL ID של המסמך הזה.

| קבוצה | Codec |
|---|---|
| הצהרה | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| ביטוי | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| פקודה | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| שגיאה | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- זה אינו פורמט שמכיל קוד משפה חיצונית כמות שהוא. קוד משפה חיצונית נכנס בפורמט Issuer.
- הרכיבים מוזכרים ב-LOCAL ID (REF) של המסמך הזה. במקום של ביטוי באים Edge של ביטוי או סמל. REF `0` פירושו אין.
- ביטוי מפיק ערך, ופקודה אינה מפיקה. אפשר לשים ביטוי במקום של פקודה ב-BLOCK (הערך נזרק).
- `for` בסגנון C נכתב כ-BLOCK (אתחול, WHILE), ו-`else if` נכתב כ-IF במקום ה"שקר".
- סמל הוא LOCAL ID, והשם נקשר באמצעות BIND. רשומות אחרות מצביעות על סמל באמצעות LOCAL ID ולא באמצעות שם. גם אם השם זהה, LOCAL ID שונה הוא סמל שונה.
- הרשומה שמצביעה על סמל קובעת מהו הסמל (משתנה, פרמטר, פונקציה, טיפוס). סמל שאין לו הגדרה במסמך מסופק מבחוץ (על ידי המארח), ואם הוא היעד של CALL, הוא פונקציית מארח.

בעיות פתוחות: קודי אופרטורים, ייצוג טיפוסים, פריסת ה-Payload של כל Codec.

## Edge של TOULMIN {#toulmin-edge}

כותבת גרף פסק דין וביצוע לפי מודל הטיעון של טולמין. הקודים הישירים הם `0x100L~0x11BL`, ורשומות העזר הן במשפחת פורמט TOULMIN `0x120L~0x134L`. פרטים: [TOULMIN](../toulmin/_index.md)

## Edge בפורמט Issuer {#issuer-형식-edge}

Issuer יכול להגדיר ולהשתמש בפורמט Edge משלו ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [4WORD](0x1BEL-edge-issuer-4word.md), [16WORD](0x1BFL-edge-issuer-16word.md), Codec‏ `0x1BDL`~`0x1BFL`). אלה שלוש המשבצות האחרונות של אזור ה-Edge. ב-Codec extension TAG באים Issuer ומספר Codec ב-2 WORD. ה-Edge Id הוא הרכיב הראשון של ה-Payload שאחריהם (TAG, Issuer, מספר Codec, Edge Id, שאר ה-Payload). מספר ה-Codec נקבע על ידי ה-Issuer ואין לו כלל משפחות. הוא אינו מתנגש בתוך `codecs/` של אותו Issuer, בלי קשר ל-Kind. מסמך ה-Codec נמצא תחת `codecs/` של אותו Issuer, לפי מספר ה-Codec של הרשומה ([כתובת פרסום ורשימת גרסאות](../publishing.md)).

- אין כרגע פורמט Edge של ISSUER שנרשם.
