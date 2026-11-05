---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND היא Edge של היגד שקושרת ל-Subject שם שהמכונה מתאימה אליו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `BIND` (BIND במסמך המפרט `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| מסמך מפרט | `0x00000000/codecs/0x00000A30/` (יעד DECLARE‏ `0A30`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 3 |
| Kind | Edge · משפחה: היגד, קבוצה: הצבעה ושמות |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קושרת ל-Subject שם שהמכונה מתאימה אליו (`UTF8-TEXT-*`). ייחודי בתוך התחום, חייב להתאים במדויק, ואין לו שפה |
| בצד Hugo | `edge/bind.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `name` | #3 | רשומה | `0720` UTF8-TEXT-EVEN, ‏`0730` UTF8-TEXT-ODD |  |

BIND היא Edge של היגד שקושרת ל-Subject שם שהמכונה מתאימה אליו. Codec‏ `0x0A3L`.

זהו מתן שם. השם שבני אדם קוראים (כותרת בכל שפה) הוא תפקידה של [LABEL](0x0A4L-label.md). השם של סמל בתוכנית והשם של דומיין ברשימת ה-Issuer נכתבים באותה רשומה.

## פריסה {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת, או WORD אחד של TAG של Codec
שם                Value אחד מסוג UTF8-TEXT-*
```

## פירוש ותוקף {#해석과-유효성}

- ה-Subject הוא רשומת [Reference](../reference/_index.md) שלמה אחת בדיוק. אם הוא LOCAL, זהו יעד של המסמך הזה (סמל וכד'), ואם הוא Reference מצביע, זהו יעד של מסמך אחר. המסמך עצמו הוא [DOC-POINTER](../reference/0x041L-doc-pointer.md), וה-Issuer עצמו הוא [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- לחלופין, ה-Subject הוא WORD אחד של TAG של Codec (רק Kind ו-Codec, ‏`LLLL = 0`, בלי Payload). זו אינה רשומה עם Payload ריק, אלא הקוד הישיר עצמו, כלומר מסמך המפרט שלו (Codec של Issuer GEUL‏ `0x0000<TAG>`) ([מסמך מפרט Codec](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). למשל: `0B80` הוא PUBLICATION. Codec בפורמט Issuer אינו מוזכר בצורה זו.
- רשומות אחרות (Value וכד') אינן יכולות להיות Subject. ה-FIELD במסמך המפרט של BIND מצהיר על ה-Subject רק ברוחב `0` (רשומה), ולכן אילוץ זה הוא כלל של גוף ה-BIND.
- השם הוא Value אחד בדיוק מסוג [UTF8-TEXT](../value/0x072L-utf8-text.md). אין לו שפה והוא אינו מנורמל. שמות הם אותו שם רק אם הבתים זהים.
- תחום השם הוא המסמך שמכיל את ה-BIND. במסמך אחד לא קושרים אותו שם ל-Subject שונים.
- אפשר לקשור ל-Subject אחד כמה שמות (כינוי, שם ישן). אם המסמך לא קבע אחרת, ה-BIND האחרון הוא השם המייצג.
- רשומות אחרות מצביעות על יעד באמצעות LOCAL ID ולא באמצעות שם. השם משמש להתאמה עם החוץ (פונקציות מארח, קלט כתובת, בני אדם).
- התווים המותרים בשם נקבעים לפי השימוש. שם דומיין ברשימת Issuer כפוף לכללי הדומיין (אותיות קטנות, IDNA) ([כתובת פרסום ורשימת גרסאות](../publishing.md#issuer-목록)).
- ברשימת גרסאות לא מציבים BIND. אין כתובת של שם מסמך ([כתובת פרסום ורשימת גרסאות](../publishing.md#문서-이름)).

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_subject + N_name WORD
```

## דוגמה (לא נורמטיבית) {#예시-비규범}

סמל בתוכנית: Edge Id הוא `0003`, ה-Subject הוא LOCAL 7, השם הוא `main`.

- השם `main` הוא 4 בתים (זוגי), ולכן `0722 6D61 696E`, כלומר 3 WORD.
- ה-Edge הוא TAG 1 + Edge Id 2 + Subject 2 + שם 3 = 8 WORD, וה-TAG הוא `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [כתובת פרסום ורשימת גרסאות](../publishing.md#issuer-목록) (שם דומיין ברשימת Issuer)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000A30/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
