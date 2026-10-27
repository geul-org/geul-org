---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge היא רשומה שקושרת יחד Reference, Value ו-Edge אחרות ומתארת אותן. הרכיב הראשון הוא תמיד Edge Id, ושני הביטים העליונים של ה-Codec קובעים את המשפחה (תיאור, ראיה, ביצוע, TOULMIN)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge היא רשומה שקושרת רשומות אחרות כרכיבים ומתארת אותן. משפטים כמו "Q42 הוא אדם" או "השם האנגלי של Q42 הוא Douglas Adams" הם כל אחד Edge אחת.

## פריסה

```
TAG WORD          0001 0LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  בפורמט Issuer
Edge Id           רשומת LOCAL Reference
רכיבים            בסדר שה-Codec קובע
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל TAG WORD, פחות 1. המפענח מדלג לרשומה הבאה לפי Length בלבד, גם בלי להכיר את ה-Codec.
- **הרכיב הראשון הוא תמיד Edge Id (LOCAL Reference).** מכיוון שזהו LOCAL Reference (`0088` + ID, Quantifier `000`), אפשר לקרוא את ה-Edge Id גם בלי codebook.
- כל רכיב מוצא את גבולותיו לפי ה-Length של עצמו. המקום שבו נגמר הרכיב האחרון חייב להתלכד בדיוק עם סוף ה-Edge.
- מבנה הרכיבים (Payload) נקבע במסמך ה-Codec של כל Edge.
- ל-Codec שיש לו תת-פורמטים (WORLD, TIMELINE, SCENE) יש TAG של WORD אחד לכל Codec שקובע את התת-פורמט.
- לסדר בין רשומות Edge אין משמעות (אלא אם Codec קבע אחרת, למשל במסמך [TOULMIN](/he/grammar/edge/toulmin/)).
- מצביעים ל-Edge אחרת באמצעות Edge Id. Edge במסמך זה מוזכרת כ-LOCAL, ו-Edge במסמך אחר מוזכרת באמצעות Reference מצביע (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## משפחות

| שני הביטים העליונים | משפחה | קוד ישיר | תפקיד |
|---|---|---|---|
| `00` | תיאור | `0x00`~`0x1F` | בונה תוכן על העולם ועל אירועים |
| `01` | ראיה | `0x20`~`0x3F` | מאיפה באו הרשומות והמסמך ([SOURCE](/he/grammar/edge/source/)) |
| `10` | ביצוע | `0x40`~`0x5F` | מבנה תוכנית שאפשר להריץ (AST) |
| `11` | [TOULMIN](/he/grammar/edge/toulmin/) | `0x60`~`0x7B` | גרף טיעונים: טענה, ראיית-נגד, חריג, יחסי תקיפה, ביצוע, תוצאת הכרעה |

## Edge תיאורי

| Codec | שם | רכיבים |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/he/grammar/edge/reference-node/) | קשירה מכוונת: Subject (Reference) מצביע על Object |
| `0x01` | [SAME-NODE](/he/grammar/edge/same-node/) | שני Reference מצביעים על אותו יעד |
| `0x02` | [DIFFERENT-NODE](/he/grammar/edge/different-node/) | שני Reference מצביעים על יעדים שונים |
| `0x03` | [BIND](/he/grammar/edge/bind/) | קושרת ל-Subject שם למכונה (UTF8-TEXT) |
| `0x04` | [LABEL](/he/grammar/edge/label/) | שם ה-Subject בכל שפה (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/he/grammar/edge/alias/) | שם נוסף של ה-Subject. הפריסה זהה ל-LABEL |
| `0x06` | [DESCRIPTION](/he/grammar/edge/description/) | תיאור ה-Subject בכל שפה. הפריסה זהה ל-LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | תיאור פועלי |
| `0x0A` | [TRIPLE](/he/grammar/edge/triple/) | טענה אחת (Predicate, Subject, Object) ו-rank |
| `0x0B` | [QUALIFIER](/he/grammar/edge/qualifier/) | תנאי אחד שמגביל את הטענה של Edge אחרת |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | עולם, סדר אירועים, מבנה סצנה |
| `0x18`~`0x1A` | [PUBLICATION](/he/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | פרסום גרסה של מסמך, המלצה להפסיק להשתמש בה, מחיקה ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#רשימת-גרסאות)) |
| `0x1B`~`0x1E` | [DECLARE](/he/grammar/edge/declare/) / [FIELD](/he/grammar/edge/field/) / [ENUM](/he/grammar/edge/enum/) / [CODEC](/he/grammar/edge/codec/) | אוצר המילים לכתיבת מפרט Codec ([מסמך מפרט Codec](/he/grammar/codec-spec/)) |

- `-SHORT` והצורה הרגילה מוצבים כזוג זוגי-אי-זוגי (VERB-SHORT `0x08` / VERB `0x09`). LABEL מקבלת את השפה כרשומת שפה בתוך ה-Object (UTF8-LANGUAGE-TEXT), ולכן משתמשים רק ב-`0x04`.
- PUBLICATION, DEPRECATION ו-TOMBSTONE נכתבות במסמך רשימת הגרסאות. מכיוון שצריך לקרוא את רשימת הגרסאות בלי codebook, הן מוטמעות במפענח (שכבה 0 ב[כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שכבות)).
- DECLARE, FIELD, ENUM ו-CODEC הן אוצר המילים לכתיבת מפרטי Codec. מכיוון שצריך לקרוא את מסמך המפרט בלי codebook, הפריסה מוטמעת במפענח (שכבה 0). כל מסמך מפרט Codec שנכתב באוצר מילים זה הוא מסמך רגיל.

### TRIPLE

לפירוט: [TRIPLE](/he/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (מאפיין Wikidata וכד')
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
- **המשמעות של TRIPLE היא אוסף כל ה-QUALIFIER שמצביעים על ה-Edge Id שלה.** הקורא אוסף את ה-QUALIFIER לפני שהוא מפרש את ה-TRIPLE.

דוגמה: Q42 — P31 (instance of) — Q5 (אדם), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

לפירוט: [QUALIFIER](/he/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (ה-Edge Id של ה-Edge המוגבלת)
Value             Reference או Value
```

- QUALIFIER היא חלק מהטענה. היא אינה טענה נפרדת על הטענה, אלא מגבילה את התנאי שבו הטענה נכונה (זמן התחלה וסיום, תחום תחולה וכד').
- טענה נפרדת על הטענה (למשל מי טען אותה) נכתבת כ-TRIPLE.
- ה-Target הוא Edge באותו מסמך. סדר ה-QUALIFIER עם אותו Target הוא הסדר במסמך.

דוגמה: Q42 — P69 (educated at) — Q691283, התחלה (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

לפירוט: [LABEL](/he/grammar/edge/label/), [ALIAS](/he/grammar/edge/alias/), [DESCRIPTION](/he/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- השם והשפה נשמרים יחד ב-Object אחד (UTF8-LANGUAGE-TEXT).
- לכל היותר LABEL אחת לכל Subject ושפה. שמות נוספים נכתבים כ-ALIAS.
- שם למכונה, ללא שפה, נכתב כ-BIND. ל-LABEL חייבת להיות שפה.

### BIND

לפירוט: [BIND](/he/grammar/edge/bind/)

- קושרת ל-Subject שם שהמכונה מתאימה אליו (UTF8-TEXT). ללא שפה וללא נרמול. שמות זהים רק אם הבייטים זהים.
- תחום השם הוא המסמך שמכיל את ה-BIND. במסמך אחד לא קושרים את אותו שם ל-Subject שונים.
- רשומות אחרות מצביעות על היעד באמצעות LOCAL ID ולא באמצעות שם. השם משמש להתאמה לגורמים חיצוניים (פונקציית מארח, קלט כתובת, בני אדם).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

לפירוט: [SAME-NODE](/he/grammar/edge/same-node/), [DIFFERENT-NODE](/he/grammar/edge/different-node/), [REFERENCE-NODE](/he/grammar/edge/reference-node/)

- SAME-NODE היא זהות: שני Reference מצביעים על אותו יעד. היא רפלקסיבית, סימטרית וטרנזיטיבית.
- DIFFERENT-NODE היא אי-זהות: שני Reference מצביעים על יעדים שונים.
- REFERENCE-NODE היא קשירה מכוונת שמגדירה באמצעות Object מהו ה-Subject (Reference). אין זו טענת זהות. למשל: הגדרת ה-URI שאליו מצביע צומת LOCAL.

## Edge של ראיות

מצרפת ראיה לרשומה בודדת בתוך BODY, או למסמך כולו (HEAD). הקוד הישיר היחיד במשפחת הראיות הוא [SOURCE](/he/grammar/edge/source/) (`0x20`).

| Codec | שם | רכיבים |
|---|---|---|
| `0x20` | [SOURCE](/he/grammar/edge/source/) | Target (ה-Edge Id של ה-Edge ב-BODY שאליה מצרפים ראיה, ב-HEAD `0` פירושו המסמך כולו), Origin (Reference של המקור, ABSENT או UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- תכונות המקור עצמו (URL, כותרת, מחבר, תאריך פרסום ...) נכתבות כ-TRIPLE שה-Subject שלה הוא המקור. תכונות הציטוט (תאריך גישה, מיקום בתוך המקור ...) נכתבות כ-QUALIFIER שה-Target שלה הוא ה-Edge Id של ה-SOURCE.
- המקור של המסמך כולו נכתב ב-HEAD כ-SOURCE עם Target `0`, וגם ה-QUALIFIER שה-Target שלהם הוא אותו SOURCE ממוקמים ב-HEAD. אלה שתי ה-Edge היחידות שמופיעות ב-HEAD, וה-Edge Id משותף ל-HEAD ול-BODY במרחב מספרים אחד ([מקור המסמך כולו](/he/grammar/edge/source/#מקור-המסמך-כולו)).
- ראיות אחרות (טווח בטקסט המקור, מי יצר, מידת אמון, תקופת תוקף לפי סעיף, רשומה ישנה) נכתבות כ-QUALIFIER, והגרסה שנכנסה ראשונה מחושבת מהיסטוריית הגרסאות ([SOURCE](/he/grammar/edge/source/#ייצוג-של-ראיות-אחרות)).
- תוצאת הכרעה ברמת רשומה היא תפקידה של `VERDICT` ב-TOULMIN.

### SOURCE

לפירוט: [SOURCE](/he/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (ה-Edge Id של ה-Edge ב-BODY שאליה מצרפים ראיה, ב-HEAD 0 פירושו המסמך כולו)
Origin            Reference או סמן מקום 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

דוגמה: המקור של TRIPLE `#178` (Q42 P19) הוא בריטניקה (Q5375741), והמזהה בתוכו הוא P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge של ביצוע

מבנה תוכנית שאינו קשור לשפת תכנות מסוימת. הרכיבים מוזכרים באמצעות LOCAL ID של המסמך הזה.

| קבוצה | Codec |
|---|---|
| הצהרה | FUNCTION-DECLARE, TYPE-DECLARE |
| ביטוי | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| פקודה | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| שגיאה | RAISE, TRY |

- אין זה פורמט שמכיל קוד של שפה חיצונית כמות שהוא. קוד של שפה חיצונית מונח בפורמט Issuer.
- הרכיבים מוזכרים באמצעות LOCAL ID (REF) של המסמך הזה. במקום של ביטוי מניחים Edge של ביטוי או סמל. REF `0` פירושו אין.
- ביטוי מפיק ערך, ופקודה אינה מפיקה ערך. אפשר להניח ביטוי במקום של פקודה ב-BLOCK (הערך נזרק).
- `for` בסגנון C נכתב כ-BLOCK (אתחול, WHILE), ו-`else if` נכתב כ-IF במקום של ענף השקר.
- סמל הוא LOCAL ID, והשם נקשר באמצעות BIND. רשומות אחרות מצביעות על הסמל באמצעות LOCAL ID ולא באמצעות שם. אם ה-LOCAL ID שונה, הסמל שונה גם כששמו זהה.
- הרשומה שמצביעה על הסמל קובעת מהו (משתנה, פרמטר, פונקציה, טיפוס). סמל שאין לו הגדרה במסמך מסופק מבחוץ (מארח), ואם הוא יעד של CALL הוא פונקציית מארח.

שאלות פתוחות: קודי אופרטורים, ייצוג טיפוסים, פריסת ה-Payload של כל Codec.

## Edge של TOULMIN

לפירוט: [TOULMIN](/he/grammar/edge/toulmin/)

כותבת גרפי הכרעה וביצוע לפי מודל הטיעון של טולמין. זוהי המשפחה המרכזית שבה GEUL מתארת את כלליה שלה ב-GEUL ומתקנת את עצמה.

| קבוצה | Codec |
|---|---|
| הצהרה | CASE-DECLARE (מקרה), [PREDICATE-DECLARE](/he/grammar/edge/toulmin/expr/) (פרדיקט), SPEC-DECLARE (קריטריון שיפוט), RULE-DECLARE (טענה), COUNTER-DECLARE (ראיית-נגד), EXCEPT-DECLARE (חריג) — [NODE](/he/grammar/edge/toulmin/node/) |
| יחס | ATTACKS (תקיפה), SUPERSEDES (דחיקה) — [LINK](/he/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (שרשרת עדיפויות, הפריסה טרם נקבעה) |
| ביצוע | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/he/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/he/grammar/edge/toulmin/node/) |
| תוצאה | VERDICT (תוצאת הכרעה: Pass, Review, Fail), EVIDENCE (ראיה להכרעה) — הפריסה טרם נקבעה |

- צמתי טקסט המקור, צמתי החלוקה וצמתי העזר והיחסים הם פורמטי ISSUER של Issuer GEUL (`0xC000`~`0xC029`) ([SOURCE וחלוקה](/he/grammar/edge/toulmin/source/)).
- תוצאת ההכרעה מונחת במסמך שונה ממסמך היעד. מסמך התוצאה מייבא את מסמך היעד ומצביע עליו. לכן גם אחרי הכרעה ה-hash של תוכן מסמך היעד אינו משתנה.

## Edge בפורמט Issuer

Issuer יכול להגדיר ולהשתמש בפורמטי Edge משלו (Codec `0x7C`~`0x7F`). הקודים הישירים `0x7C`~`0x7F` נמצאים בתוך טווח TOULMIN אך הם קודי ISSUER משותפים, והמשפחה נקבעת לפי שני הביטים העליונים של מספר הפורמט.

| Issuer | מספר פורמט | שם | משפחה |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/he/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/he/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/he/grammar/edge/toulmin/link/) | TOULMIN |
