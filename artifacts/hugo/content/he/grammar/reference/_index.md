---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference היא רשומה שמצביעה על יעד. 4 ביטים של Codec קובעים את מערכת הזיהוי (LOCAL, Wikidata, מסמך חיצוני וכד'), ו-3 ביטים של Quantifier קובעים את הכימות (מזוהה, כללי, אוניברסלי, משתנה וכד'). ה-Codec השמור 0000 הוא קבוצת סמני מקום."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference היא רשומה שמצביעה על יעד. היעד יכול להיות ישות, מושג, מסמך או Edge אחרת. מצביעים באמצעות ID ולא באמצעות שם.

## פריסה

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length extension TAG]
[IMPORT ID]       כשזה EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          כשזה EXTERNAL-ISSUER (1/2/4/16 WORD)
[מזהה מסמך]       כשזה EXTERNAL-ISSUER (4 WORD)
ID של היעד        כל השאר
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל TAG WORD, פחות 1 ([רשומות ו-TAG WORD](/he/grammar/record/)).
- ה-Codec הוא 4 הביטים `CCCC` וה-Quantifier הוא 3 הביטים `QQQ`. 7 הביטים התחתונים של ה-TAG WORD הם `CCCC << 3 | QQQ`.
- ה-ID של היעד הוא מספר שלם unsigned ב-big-endian ונכתב ב**רוחב הקצר ביותר**. הרוחב הוא מה שנותר מה-Length אחרי השדות שלפניו.
- ה-ID של היעד `0` נכתב כ-`0x0000`, WORD אחד. בכל מקרה אחר לא מוסיפים לפניו WORD של `0x0000`.
- ערך מספרי זהה הוא אותו ID. הרוחב אינו חלק מה-ID.
- כל ה-Codec משתמשים ברוחב הקצר ביותר. Codec אינו מקבע את רוחב ה-ID של היעד.
- [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/) ו-[DOC-POINTER](/he/grammar/reference/doc-pointer/) אינם עוקבים אחרי הפריסה הזו. אין להם ID של יעד, ויש רק Issuer (ומזהה מסמך ומזהה גרסה).

## Codec (`CCCC`)

| CCCC | שם | סיווג | יעד |
|---|---|---|---|
| `0000` | [סמן מקום](/he/grammar/reference/slot-marker/) | שמור | אינו מצביע על יעד. משתמשים רק בסמני WORD אחד ששלושת הביטים התחתונים שלהם הם מספר הסמן: `0x0000` ABSENT (לא נכתב), `0x0001` UNKNOWN-VALUE (לא ידוע), `0x0002` NO-VALUE (אין) |
| `0001` | [LOCAL](/he/grammar/reference/local/) | הצהרה | ID שהמסמך הזה הנפיק |
| `0010` | [GEUL](/he/grammar/reference/geul/) | הצהרה | ישות ש-geul.org מנפיקה |
| `0011` | [GEUL-SIDX](/he/grammar/reference/geul-sidx/) | הצהרה | מזהה ממוין סמנטית שהביטים שלו נושאים משמעות |
| `0100` | [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/) | הצהרה | פריט Wikidata. המספר השלם שאחרי `Q` |
| `0101` | [WIKIDATA-PID](/he/grammar/reference/wikidata-pid/) | הצהרה | מאפיין Wikidata. המספר השלם שאחרי `P` |
| `0110` | [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/) | הצבעה-הצהרה | ה-Issuer עצמו |
| `0111` | [DOC-POINTER](/he/grammar/reference/doc-pointer/) | הצבעה-הצהרה | גרסה אחת של מסמך ש-Issuer פרסם |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/he/grammar/reference/external-pointer/) | הצבעה | LOCAL ID של מסמך שיובא ב-IMPORT |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/he/grammar/reference/external-issuer/) | הצבעה-הצהרה | LOCAL ID של מסמך ש-Issuer פרסם |

- **הצהרה** מזהה יעד ישירות באמצעות ID שהגורם המנפיק קבע.
- **הצבעה** מצביעה על LOCAL בתוך מסמך שיובא באמצעות IMPORT ID. שני הביטים התחתונים הם רוחב ה-IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- **הצבעה-הצהרה** מצביעה ברשומה אחת, בלי IMPORT, על מסמך אחר ועל יעד שבתוכו.
- אם הביט העליון ביותר הוא `0`, הרשומה מזהה את היעד ישירות (LOCAL של המסמך הזה, ID מונפק, ה-Issuer או המסמך עצמו), ואם `1`, היא מצביעה על LOCAL של מסמך אחר.
- Codec `0000` שמור ואינו משמש כ-Reference שמצביע על יעד. יש חריג אחד, קבוצה אחת: ה-WORD `0x0000`~`0x0007` (Codec `0000`, WORD אחד) הם [סמן מקום](/he/grammar/reference/slot-marker/). כרגע משתמשים בשלושה (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). סמן תקף רק במקום של שדה רשומה שרשימת ה-CODEC שלו מציינת בדיוק את ה-WORD הזה. תו כללי ושדה בלי CODEC אינם מקבלים אותו, ובמקום של רשומה ב-HEAD או ב-BODY ובמקום של Edge Id הוא invalid. `0x0003`~`0x0007` ו-Codec `0000` עם Payload שמורים.
- מערכות זיהוי שאינן CC0 (WordNet וכד') אינן מוצבות כ-Reference Codec. ל-Reference אין גם קוד ISSUER, ולכן אין מקום להעביר אותן לפורמט Issuer.

### TAG נפוצים

| רשומה | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Q5 ב-Wikidata (אדם) | `00A0 0005` |
| Q691283 ב-Wikidata | `0120 000a 8c53` |
| P31 ב-Wikidata (instance of) | `00A8 001f` |
| סמן מקום ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL הוא ID שהמסמך הזה הנפיק. יש לו משמעות רק בתוך המסמך.

- **ייחודי.** במסמך אחד LOCAL ID אחד מצביע על יעד אחד בלבד.
- **0 אינו מוקצה.** ה-ID של היעד מוקצה מ-1.
- **מומלץ להקצות בהגדלה** (auto increment). לגודל ה-ID אין משמעות.
- הוא מצביע על אותו יעד לאורך גרסאות. ID שנמחק לא משתמשים בו שוב ([מסמך](/he/grammar/document/), תיקון).
- כדי שאפשר יהיה להצביע עליו מחוץ למסמך, חייב להיות במסמך `DOC-ID`.
- LOCAL ID שונים אינם אומרים שהיעדים שונים במציאות. אם הם זהים, מקשרים ב-Edge `SAME-NODE`, ואם שונים, ב-`DIFFERENT-NODE`.

### Edge Id

כל Edge מציבה LOCAL Reference כרכיב הראשון של ה-Payload. ה-LOCAL ID הזה הוא ה-**Edge Id**.

- אפשר לקרוא את ה-Edge Id גם בלי לדעת את ה-codebook.
- LOCAL במקום של Edge Id הוא הצהרה, ו-LOCAL בכל מקום אחר ב-Edge הוא אזכור.
- ה-Quantifier של LOCAL שמצהיר על Edge Id הוא `000` בלבד.
- מצביעים על Edge אחרת באמצעות Edge Id. Edge במסמך הזה מוצבעת כ-LOCAL, ו-Edge במסמך אחר מוצבעת כ-Reference מצביע.

## הצבעה על מסמך אחר

| מה | איך |
|---|---|
| ה-Issuer עצמו | `ISSUER-POINTER` (Issuer) |
| גרסה אחת של מסמך | `DOC-POINTER` (Issuer, מזהה מסמך של 4 WORD, מזהה גרסה של 2 WORD). גרסה `0` היא האחרונה |
| יעד בתוך מסמך שפורסם (האחרונה) | `EXTERNAL-ISSUER-*` (Issuer, מזהה מסמך, LOCAL ID) |
| יעד בתוך מסמך מיובא (מהדורה נעולה) | מקצים IMPORT ID ב-Meta `IMPORT-DOC` ו-`EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- מסמך עצמו, בתוך המסמך או מחוצה לו, מוצבע רק באמצעות DOC-POINTER אחד. המסמך עצמו הוא ה-DOC-POINTER של ה-`DOC-ID` שלו.
- EXTERNAL-ISSUER עוקב אחרי הגרסה האחרונה. כדי לנעול מהדורה משתמשים ב-IMPORT.
- ה-Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו (1/2/4/16 WORD), ובוחרים את ה-Codec שמתאים לרוחב הזה.
- מזהה המסמך `0` של כל Issuer שמור כמסמך אינדקס של מונחים (כלים, תפקידים וכד') ש-Issuer הגדיר. מסמך אינדקס מומלץ לכל Issuer ואינו חובה ([Issuer ופרסום](/he/grammar/issuer/#מסמך-הגדרת-מונחים)).

דוגמה: LOCAL 7 בתוך מסמך של Issuer `0x0001` עם מזהה `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | שם | משמעות | דוגמה |
|---|---|---|---|
| `000` | Identified | ישות מזוהה | אילון מאסק, מדינת ישראל |
| `001` | Generic | קביעה כללית על סוג שלם. מתירה חריגים | חייל מציית לפקודות |
| `010` | Free-choice | כל יעד שמקיים את התנאי | כל חייל שהוא |
| `011` | Universal | כל היעדים בטווח | כל החיילים |
| `100` | Variable | משתנה שיח | האיש ההוא, האישה הזאת |
| `101`~`111` | שמור | | |

- **חריג: ב-Codec `0000` (סמן מקום) שלושת הביטים התחתונים הם מספר הסמן ולא Quantifier.** אין קשר בין מספר הסמן למשמעות של Quantifier (`0x0001` UNKNOWN-VALUE אינו Generic). ה-Quantifier בטבלה הזו חל רק על Codec `0001`~`1111`.
- Generic, בניגוד ל-Universal, אינו אומר שהוא חל על כל יעד בודד בלי יוצא מן הכלל. ביטוי מגדיר כמו `מהו חייל` אפשר לכתוב כ-Generic. כשנדרשת הגדרה קפדנית של מושג או סיווג, מפרטים אותה ביחס נפרד.
- תחום החלת הכימות והשלילה נקבעים לא ב-Reference אלא ב-Edge שמשתמשת בו.
- **Variable** הוא יעד בשיח שהסוג שלו ידוע אך הוא עדיין לא מזוהה.
  - משתנה בעל שם מציבים כ-Variable על LOCAL. אותו LOCAL ID הוא אותו משתנה. הסוג מקושר ב-Edge.
  - משתנה אנונימי מציבים כ-Variable על Codec הצהרה שמצביע על הסוג (GEUL, WIKIDATA-*) (למשל "נשיא" ב-Wikidata + Variable). אינו עוקב אחרי הפניות חוזרות ואי אפשר להצביע עליו שוב. משתנים אנונימיים אינם נחשבים לאותו משתנה.
  - כשהיעד מאומת בהמשך, מקשרים את המשתנה ליעד ב-`SAME-NODE`. כל הביטויים שמצביעים על אותו משתנה מפורשים יחד כאותו יעד.
  - גם משתנים שונים אינם אומרים שהיעדים בפועל שונים. אם זהים, מקשרים ב-`SAME-NODE`, ואם שונים, ב-`DIFFERENT-NODE`.
  - משתנה תקף רק בתוך המסמך שלו ואין להשתמש בו כמזהה קבוע.
  - Variable ב-Codec הצבעה חיצוני (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) הוא משתנה LOCAL של המסמך המוצבע.
  - דוגמה: ב"הנשיא נשא נאום", אם האדם טרם נקבע, משתמשים ב-Variable "נשיא". כדי להזכיר אותו שוב, מציבים LOCAL Variable ומקשרים ב-Edge את הסוג "נשיא". אם בהמשך מאומת שזה אובמה, מקשרים את המשתנה ל-Identified של אובמה ב-`SAME-NODE`. כל הביטויים שמצביעים על אותו משתנה מפורשים יחד כאובמה.
- דוגמה: אם משתמשים ב-Q5 (אדם) ב-Wikidata כ-Generic, זה `00A1 0005` ("אדם הוא …").
