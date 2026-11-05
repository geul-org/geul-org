---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference הוא רשומה המצביעה על יעד."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference הוא רשומה המצביעה על יעד. היעד יכול להיות ישות, מושג, מסמך או Edge אחר. מצביעים עליו ב-ID ולא בשם.

## פריסה {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      קטעים 0~2 (0x000L~0x05FL)
[Length TAG הרחבה]
[IMPORT ID]       ב-EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          ב-EXTERNAL-ISSUER (2/4/16 WORD)
[ID מסמך]         ב-EXTERNAL-ISSUER (4 WORD)
ID יעד            כל השאר
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל ה-TAG WORD, פחות אחד ([רשומה ו-TAG WORD](../record.md)).
- Reference הוא 96 מקומות בקטעים 0~2 (`w < 0x0600`). קטע 0, ישויות: `0x000L~0x01FL`. קטע 1, EXTERNAL: `0x020L~0x03FL`. קטע 2, שונים: `0x040L~0x05FL`.
- ה-Codec נכתבים בטבלת קודים (להלן). בערכת 5Q, קוד אחד נושא יחד את ערכת הזיהוי ואת הכימות. הכימות של REFERENCE-ISSUER נקבע במסמך ה-Issuer.
- ID היעד הוא מספר שלם ללא סימן ב-big-endian ונכתב ב**רוחב הקצר ביותר**. הרוחב הוא מה שנותר מ-Length אחרי הפחתת השדות הקודמים.
- ID יעד `0` נכתב כ-`0x0000` ב-WORD אחד. בשאר המקרים אין מוסיפים לפניו WORD `0x0000`.
- ערכים שלמים שווים הם אותו ID. הרוחב אינו חלק מה-ID.
- כל ה-Codec משתמשים ברוחב הקצר ביותר. Codec אינו קובע רוחב קבוע ל-ID היעד.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md) ו-[CODEC-POINTER](0x042L-codec-pointer.md) אינם פועלים לפי הפריסה הזו. אין להם ID יעד, ויש בהם רק Issuer (ו-ID מסמך, Codec ID, ID גרסה).
- גם [REFERENCE-ISSUER](#reference-issuer) אינו פועל לפי הפריסה הזו. הוא TAG, Issuer, מספר Codec של 2 WORD ו-Payload. ה-Payload נקבע במסמך ה-Codec ש-Issuer פרסם.

## Codec {#codec}

| TAG ID | שם | סיווג | יעד |
|---|---|---|---|
| `0x000L~0x002L` | [סמן מקום](../slot-marker.md) | סמן מקום | אינו מצביע על יעד. משתמשים רק בסמנים של WORD אחד: `0x0000` ABSENT (לא נרשם), `0x0010` UNKNOWN-VALUE (לא ידוע), `0x0020` NO-VALUE (אין) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | הצהרה | ID שהמסמך הזה הנפיק |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | הצהרה | ישות ש-geul.org מנפיק |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | הצהרה | מזהה מיושר-משמעות שהביטים שלו נושאים משמעות |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | הצהרה | פריט ב-Wikidata. המספר השלם אחרי `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | הצהרה | תכונה ב-Wikidata. המספר השלם אחרי `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | מכוון | LOCAL ID של מסמך שיובא ב-IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | מכוון-מצהיר | LOCAL ID של מסמך שפרסם Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | מכוון-מצהיר | ה-Issuer עצמו |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | מכוון-מצהיר | גרסה אחת של מסמך שפרסם Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | מכוון-מצהיר | גרסה אחת של Codec שפרסם Issuer |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | פורמט Issuer | ה-Issuer מגדיר. הסיווג ומקום ID היעד נקבעים במסמך ה-Issuer |

- Reserved הם `0x003L~0x004L`, `0x01EL~0x01FL` (קטע 0), `0x03EL~0x03FL` (קטע 1) ו-`0x043L~0x05CL` (קטע 2, מקום לערכות זיהוי חדשות).
- מספר הערכה נקרא מההיסט בתוך הקטע `C`. בקטע 0, אם `5 <= C < 30`, הערכה היא `C / 5` (1~5). בקטע 1, אם `C < 30`, הערכה היא `6 + C / 5` (6~11).

| ערכה | שם | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **הצהרה** מזהה את היעד ישירות באמצעות ID שגורם ההנפקה קבע.
- **מכוון** מצביע על LOCAL בתוך מסמך שיובא באמצעות IMPORT ID. רוחב ה-IMPORT ID נקבע לפי הערכה: אם ערכה − 6 הוא 0, 1 או 2, הרוחב הוא 1, 2 או 4 WORD.
- **מכוון-מצהיר** מצביע ברשומה אחת, בלי IMPORT, על מסמך אחר ועל יעד בתוכו. רוחב ה-Issuer ב-EXTERNAL-ISSUER הוא 2, 4 או 16 WORD כאשר ערכה − 9 הוא 0, 1 או 2.
- `0x020L~0x03DL` (קטע 1, ערכות 6~11) מצביעים על LOCAL של מסמך אחר. ערכות ההצהרה האחרות מזהות את היעד ישירות (LOCAL של המסמך הזה, ID מונפק). מצביעים (קטע 2, `0x040L~0x042L`) מצביעים על ה-Issuer, המסמך וה-Codec עצמם. REFERENCE-ISSUER נמצא מחוץ להבחנה הזו.
- `0x000L~0x002L` הם קודים שהוקצו לסמני מקום, ולא משתמשים בהם כ-Reference המצביע על יעד. ה-WORD `0x0000`, `0x0010` ו-`0x0020` (L 0, WORD אחד) הם [סמני מקום](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). הסמן תקף רק במקום של שדה ברשומה שיעד ה-CODEC שלו הוא בדיוק ה-WORD הזה. תו כללי (wildcard) ושדה ללא CODEC אינם מקבלים אותו, ובמקום של רשומת HEAD או BODY ובמקום של Edge Id הוא invalid. צורת TAG עם Payload ב-C 0~2 (L ≥ 1) היא Reserved.
- רק direct code ופרסומים ש-geul.org מספק הם CC0. אין מציבים כ-direct code ערכות זיהוי שאינן CC0 (WordNet ועוד). הרישיון של פורמט Issuer נקבע על ידי אותו Issuer.

### TAG נפוצים {#자주-쓰는-tag}

| רשומה | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (אדם) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| סמן מקום ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL הוא ID שהמסמך הזה הנפיק.

- **ייחודי.** במסמך אחד, LOCAL ID אחד מצביע על יעד אחד בלבד.
- **0 אינו מוקצה.** ID של יעד מוקצים החל מ-1.
- **מומלץ להקצות בסדר עולה** (auto increment). לגודל ה-ID אין משמעות.
- הוא מצביע על אותו יעד גם בין גרסאות. ID שנמחק אינו נעשה בו שימוש חוזר (תיקון של [מסמך](../document.md)).
- כדי שיהיה אפשר להצביע מחוץ למסמך, חייב להיות במסמך `DOC-ID`.
- LOCAL ID שונים אינם אומרים שהיעדים במציאות שונים. אם הם זהים, מקשרים ב-Edge `SAME-NODE`, ואם שונים, ב-`DIFFERENT-NODE`.

### Edge Id {#edge-id}

כל Edge מציב LOCAL Reference כאיבר הראשון ב-Payload שלו. אותו LOCAL ID הוא **Edge Id**.

- אפשר לקרוא את ה-Edge Id גם בלי הקודבוק.
- LOCAL במקום של Edge Id הוא הצהרה, ו-LOCAL בשאר המקומות של ה-Edge הוא אזכור.
- ההצהרה על Edge Id משתמשת רק ב-LOCAL מסוג Identified (`0x005L`).
- Edge אחר מצביעים עליו ב-Edge Id. Edge של המסמך הזה מצביעים עליו ב-LOCAL, ו-Edge של מסמך אחר ב-Reference מכוון.

## הצבעה על מסמכים אחרים {#다른-문서-가리키기}

| מה | איך |
|---|---|
| ה-Issuer עצמו | `ISSUER-POINTER` (Issuer) |
| גרסה אחת של מסמך | `DOC-POINTER` (Issuer, ID מסמך של 4 WORD, ID גרסה של 2 WORD). גרסה `0` היא העדכנית |
| גרסה אחת של Codec | `CODEC-POINTER` (Issuer, Codec ID של 2 WORD, ID גרסה של 2 WORD). גרסה `0` היא העדכנית |
| יעד בתוך מסמך שפורסם (עדכני) | `EXTERNAL-ISSUER-*` (Issuer, ID מסמך, LOCAL ID) |
| יעד בתוך מסמך שיובא (גרסה מקובעת) | מקצים IMPORT ID באמצעות Meta `IMPORT-DOC` ו-`EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- מסמך עצמו, בין בתוך המסמך ובין מחוצה לו, מצביעים עליו רק ב-DOC-POINTER אחד. הצבעה על עצמו היא DOC-POINTER של ה-`DOC-ID` שלו. מסמך Codec הוא יוצא מן הכלל ומצביעים עליו ב-CODEC-POINTER (גם `DOC-ID` שלו הוא CODEC-POINTER).
- EXTERNAL-ISSUER עוקב אחר הגרסה העדכנית. כדי לקבע גרסה משתמשים ב-IMPORT.
- ה-Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו (2/4/16 WORD) ובוחרים Codec התואם לאותו רוחב. כך ב-EXTERNAL-ISSUER וב-REFERENCE-ISSUER.
- ID מסמך `0` של כל Issuer שמור למסמך האינדקס של המונחים שה-Issuer הגדיר (כלים, תפקידים ועוד). מסמך אינדקס מומלץ לכל Issuer ואינו חובה ([Issuer ופרסום](../issuer.md#용어-정의-문서)).

דוגמה: LOCAL 7 בתוך המסמך `0x0000000000000002` של Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | שם | משמעות | דוגמה |
|---|---|---|---|
| `0` | Identified | ישות מזוהה | אילון מאסק, הרפובליקה של קוריאה |
| `1` | Generic | היגד כללי על סוג שלם. מתיר חריגים | חיילים מצייתים לפקודות |
| `2` | Free-choice | יעד כלשהו העונה על התנאי | כל חייל שהוא |
| `3` | Universal | כל היעדים בטווח | כל החיילים |
| `4` | Variable | משתנה שיח | האדם ההוא, האישה הזאת |

- **הכימות נקרא רק בערכות 5Q (ערכות 1~11).** לפי ההיסט בתוך הקטע `C`: בקטע 0 כאשר `5 <= C < 30`, ובקטע 1 כאשר `C < 30`, הכימות הוא `C % 5`. קטע הוא 32 מקומות, ולכן חלוקת מקום ה-Codec של 9 ביט (`w >> 4`) ב-5 תסיט את קטע 1. לסמנים (קטע 0, `C < 3`) ולקטע 2 (מצביעים, REFERENCE-ISSUER) אין כימות. הסמן `0x0010` UNKNOWN-VALUE אינו Generic. הכימות של REFERENCE-ISSUER נקבע במסמך ה-Codec ש-Issuer פרסם.
- Generic, שלא כמו Universal, אינו אומר שהוא חל על כל יעד בודד ללא חריגים. אפשר להשתמש ב-Generic בביטוי הגדרתי כמו «מהו חייל». כשנדרשת הגדרה קפדנית של מושג או סיווג, מפרטים אותה ביחס נפרד.
- היקף הכימות והשלילה שלו נקבעים על ידי ה-Edge שמשתמש בו, ולא על ידי ה-Reference.
- **Variable** הוא יעד בשיח שסוגו ידוע אך הוא עדיין לא זוהה.
  - משתנה בעל שם מקבלים בצירוף Variable ל-LOCAL. אותו LOCAL ID הוא אותו משתנה. את הסוג מקשרים ב-Edge.
  - משתנה אנונימי מקבלים בצירוף Variable ל-Codec הצהרה שמציין את הסוג (GEUL, WIKIDATA-*) (לדוגמה: «נשיא» ב-Wikidata + Variable). אין עוקבים אחר הפניה משותפת ואי אפשר להצביע עליו שוב. משתנים אנונימיים אינם נחשבים לאותו משתנה.
  - כשהיעד מתברר מאוחר יותר, מקשרים את המשתנה ליעד ב-`SAME-NODE`. כל הביטויים המצביעים על אותו משתנה מפורשים יחד כאותו יעד.
  - גם משתנים שונים אינם בהכרח יעדים שונים במציאות. אם הם זהים, מקשרים ב-`SAME-NODE`, ואם שונים, ב-`DIFFERENT-NODE`.
  - ב-Codec מכוון חיצוני (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*), Variable הוא משתנה LOCAL של המסמך שמצביעים עליו.
  - דוגמה: ב«הנשיא נשא נאום», אם האדם לא נקבע, משתמשים ב-Variable של «נשיא». כדי להזכיר אותו שוב, מציבים LOCAL Variable ומקשרים ב-Edge את הסוג «נשיא». אם מתברר מאוחר יותר שזה אובמה, מקשרים את המשתנה ל-Identified של אובמה ב-`SAME-NODE`. כל הביטויים המצביעים על אותו משתנה מפורשים יחד כאובמה.
- דוגמה: Q5 (אדם) ב-Wikidata, ב-Generic, הוא `0151 0005` («אדם הוא …»).

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER הוא פורמט Reference שה-Issuer הגדיר. אלה שלושת המקומות האחרונים באזור Reference. הפריסה זהה ל-ISSUER של Value ושל Edge ([רשומה ו-TAG WORD](../record.md#issuer-형식-레코드)).

### פריסה {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = רוחב Issuer: 01 2, 10 4, 11 16 WORD)
[Length TAG הרחבה]
Issuer            2/4/16 WORD (ה-Codec קובע את הרוחב)
מספר Codec        2 WORD. ה-Issuer מגדיר
Payload           נקבע במסמך ה-Codec ש-Issuer פרסם
```

| Codec | שם | רוחב Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- לכל קוד יש דף: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- מסמך ה-Codec של Issuer GEUL הוא אחד לכל קוד וכולל שלושה FIELD: Issuer (2·4·16 WORD), מספר Codec (2 WORD) ו-Payload (נקבע ב-Codec של ה-Issuer).

### פירוש ותוקף {#해석과-유효성}

- GEUL מכיר רק את גבול ה-Payload דרך Length. אין מפרשים Payload בלי קודבוק.
- משמעות מספר ה-Codec והכימות נקבעים על ידי ה-Issuer. גם מה שהוא מצביע עליו נקבע במסמך ה-Codec ש-Issuer פרסם.
- כללי Reference המשותפים אינם חלים: הרוחב הקצר ביותר של ID היעד, הכתיבה של ID יעד `0` ב-WORD אחד, Quantifier, קריאת כימות וערכה לפי ההיסט בתוך הקטע, הסיווג להצהרה ולמכוון, והיעד המצוין.
- מספר Codec של 2 WORD זהה ל-ISSUER של Value ושל Edge. אם המספרים אינם מספיקים, מקבלים Issuer נוסף.
- מפענח שאינו מכיר את הפורמט יודע עד Kind, Length, Issuer ומספר Codec, ומדלג דרך Length.
- הרישיון של פורמט Issuer נקבע על ידי אותו Issuer ([Issuer ופרסום](../issuer.md#라이선스)).

### דפים קשורים {#관련-페이지}

- [רשומה ו-TAG WORD](../record.md), [Issuer ופרסום](../issuer.md)
