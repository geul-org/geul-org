---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "מייבא מסמך חיצוני באמצעות IMPORT ID."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `IMPORT-DOC` (BIND של מסמך מפרט: `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| מסמך מפרט | `0x00000000/codecs/0x00001E40/` (יעד DECLARE: `1E40`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 4 |
| Kind | Meta · מחלקה: ייבוא |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מייבא מסמך חיצוני באמצעות IMPORT ID. Reference מובנה `DOC-POINTER` (במסמך Codec `CODEC-POINTER`) + IMPORT ID |
| בצד Hugo | `meta/import/import-doc.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | רשומה | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

מייבא מסמך חיצוני באמצעות IMPORT ID. המסמך לייבוא מצוין ב-[DOC-POINTER](../reference/0x041L-doc-pointer.md), וגם רוחב ה-Issuer נושא ה-DOC-POINTER.

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[TAG הרחבה של Length]
מסמך              רשומת Reference מסוג DOC-POINTER (Issuer, מזהה מסמך, מזהה גרסה. גרסה 0 היא האחרונה). במסמך Codec: CODEC-POINTER
IMPORT ID         כל השאר. unsigned ברוחב הקצר ביותר
```

- Codec: Meta `0x1E4L`, מחלקת IMPORT
- Payload: Reference מובנה `DOC-POINTER` (Issuer, מזהה מסמך, מזהה גרסה) + ערך גולמי של IMPORT ID
- מספר: אפשר כמה (אחד לכל IMPORT ID)

## פירוש ותוקף {#해석과-유효성}

- המסמך הוא רשומת DOC-POINTER אחת בדיוק. כשמייבאים מסמך Codec, זו רשומת [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, מזהה גרסה). היא מסתיימת ב-Length של עצמה, והשאר הוא ה-IMPORT ID.
- IMPORT ID הוא לפחות WORD אחד, ברוחב הקצר ביותר. רוחב ה-IMPORT ID נקבע כאן לפי אורך הרשומה, וב-[EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) לפי ה-Codec.
- אין להקצות אותו IMPORT ID פעמיים באותו מסמך.
- אם נרשם מזהה גרסה, הקישור הוא לנוסח הזה; אם `0`, הקישור הוא לנוסח האחרון בזמן הפירוש (או לנוסח שהיה בתוקף בנקודת הזמן שצוינה) ([תיקון](../document.md#개정)).
- ה-[EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) ב-BODY מצביע על LOCAL של המסמך שיובא באמצעות IMPORT ID. המסמך המיובא עצמו מוצבע באמצעות DOC-POINTER.
- ה-HEAD של המסמך המיובא אינו מיובא. הפריטים של אותו מסמך מפורשים לפי ההצהרות של אותו מסמך.
- באמצעות IMPORT ID אי אפשר לחפש בין מסמכים. מאגר שטוען כמה מסמכים פותח את ה-IMPORT ID לנתיב המלא (Issuer, מזהה מסמך, מזהה גרסה, LOCAL ID) ושומר אותו כך.

## דוגמה {#예시}

- IMPORT ID 1, Issuer `0x00000002`, מסמך `0x…0002`, האחרון: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG של Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E40/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
