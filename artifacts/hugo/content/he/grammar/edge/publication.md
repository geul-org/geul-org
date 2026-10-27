---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE הן Edge תיאוריות שרושמות פרסום, המלצה להפסיק להשתמש ומחיקה של גרסאות מסמך, והדף הזה קובע גם את מפרט מסמך רשימת הגרסאות שנכתב בהן (Codec 0x18~0x1A)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

אלה Edge תיאוריות שרושמות פרסום, deprecate ומחיקה של מסמך, והמפרט של מסמך רשימת הגרסאות שנכתב בהן. הן קובעות את פורמט רשימת הגרסאות ב[כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#רשימת-גרסאות).

## קודים

| Codec | שם | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, hash תוכן |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, קטגוריית סיבה |

- שלושת הקודים מוטמעים במפענח ([שכבה 0](/he/grammar/publishing/#שכבות)). רשימת גרסאות מפורשת בלי לשלוף codebook.
- אין תת-פורמטים (TAG לפי Codec). שומרים כמות שהוא את כלל ה-[Edge](/he/grammar/edge/) שהרכיב הראשון ב-Payload הוא Edge Id.

## פריסה

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
מסמך              רשומת DOC-POINTER Reference (Issuer, מזהה מסמך, מזהה גרסה)
hash תוכן         16 WORD   (PUBLICATION)
קטגוריית סיבה     WORD אחד  (TOMBSTONE)
```

| שדה | רוחב | הסבר |
|---|---|---|
| Edge Id | רשומת LOCAL Reference | מספר סידורי ברשימה. ממספרים מ-1 ומצרפים בסוף |
| מסמך | רשומת DOC-POINTER | גרסה אחת של המסמך שפורסם ([DOC-POINTER](/he/grammar/reference/doc-pointer/)). ה-Issuer ומזהה המסמך זהים למסמך שהרשימה עוסקת בו. כך מסמך הרשימה אומר של מה הוא רשימה גם בלי נתיב. מזהה הגרסה הוא המספר הסידורי בתוך אותו מסמך ([מסמך](/he/grammar/document/), גרסה), ו-`0` (האחרונה) אינו בשימוש |
| hash תוכן | 16 WORD | hash התוכן של אותה גרסה (SHA-256, [מסמך](/he/grammar/document/), hash תוכן) |
| קטגוריית סיבה | WORD אחד | קוד הקטגוריה של סיבת המחיקה. טבלת הקודים היא שאלה פתוחה |

- האורך אחרי ה-DOC-POINTER קבוע לכל קוד (16, 0, 1 WORD). אם שונה, דוחים.
- בתוך הרשומה לא מכניסים זמן. הזמן של פרסום, deprecate או מחיקה הוא ה-`RECORDED-AT` של מסמך הרשימה הראשון שבו נכללה הרשומה.

## מסמך רשימת גרסאות

מקום הפרסום ממשיך לכתוב מסמך רשימת גרסאות אחד לכל מסמך: `/<Issuer>/<doc-id>/versions.geul`. כל הגרסאות של אותו מסמך שפורסמו במקום הפרסום הזה נכנסות לרשימה אחת.

```
DOC-1WORD/2WORD/4WORD     אורך כולל
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value מסוג SHA-256-DIGEST. hash התוכן של מסמך הרשימה הקודם (אין ברשימה הראשונה)
  RECORDED-AT             Value מסוג POSIX-TIMESTAMP-SECONDS. הזמן שבו הוצאה הרשימה
  NEXT-LOCAL-ID           ה-LOCAL ID הבא להקצאה (אם יש גרסאות)
  SIGNATURE               חתימת מקום הפרסום. היעד הוא hash התוכן של מסמך הרשימה הזה
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- Meta של ה-HEAD: [SPEC-VERSION](/he/grammar/meta/declaration/spec-version/), [PARENT](/he/grammar/meta/lineage/parent/), [RECORDED-AT](/he/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/he/grammar/meta/lineage/next-local-id/), [SIGNATURE](/he/grammar/meta/verification/signature/).
- במסמך רשימה לא מציבים `DOC-ID` (חריג למסמכים ששמם אינו מתחיל ב-`0x`, [DOC-ID](/he/grammar/meta/declaration/doc-id/)). רשימה אינה מסמך שפורסם אלא רישום שמצורף למסמך. מזהה המסמך ברשומות אומר של איזה מסמך היא רשימה. לכן גם כשמקבלים אותה בלי נתיב (`h/`, dump) יודעים של מה היא רשימה.
- מזהי המסמך ברשומות חייבים כולם להיות של המסמך שהרשימה עוסקת בו. רשומה של מסמך אחר נדחית.
- מסמך הרשימה אינו מציב IMPORT ומשתמש רק ב-Codec של שכבה 0. אינו מועלה לרשימה אחרת (אין רשימה של רשימות).
- מסמך רשימה חדש שומר בתחילתו את ה-BODY של מסמך הרשימה הקודם כמות שהוא ומוסיף אחריו רשומות. לא מתקנים, לא מוחקים ולא משנים סדר.
- מקום הפרסום חותם על הרשימה. בפרסום ב-geul.org, geul.org (ה-Issuer של GEUL) חותמת, ובפרסום פרטי ה-Issuer עצמו חותם.
- מזהה המסמך `0x0000000000000000` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer ([Issuer ופרסום](/he/grammar/issuer/)). ה-Issuer עצמו מוצבע באמצעות [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/).

## כללים

- מזהי הגרסה ב-PUBLICATION עולים מ-1 בלי פערים. מזהה הגרסה מוקצה בידי מקום הפרסום.
- אין מפרסמים שוב את אותו hash תוכן. אם כבר קיים, מחזירים את מזהה הגרסה שלו.
- DEPRECATION ו-TOMBSTONE מצביעות רק על מזהה גרסה של PUBLICATION שהופיעה קודם. הצבעה על גרסה שאינה קיימת נדחית.
- מצב הגרסה מחושב מהחלת הרשומות לפי הסדר: פורסמה ← deprecated ← נמחקה. גרסה שנמחקה לא מפרסמים שוב ולא מוסרים.
- הגרסה האחרונה היא מזהה הגרסה הגבוה ביותר שאינו deprecated ואינו נמחק.
- כשמזהה הגרסה מגיע לסוף 2 ה-WORD, אין מפרסמים עוד גרסאות של המסמך ומוציאים אותו עם מזהה מסמך חדש.

## שם המסמך

השם של מסמך לצורך כתובת נקשר ב-[BIND](/he/grammar/edge/bind/) באינדקס השמות של ה-Issuer `/<Issuer>/documents.geul` ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שם-המסמך)). המפרש קורא רק את האינדקס הזה.

אפשר להציב את אותו BIND גם במסמך הרשימה (רשות). אם מציבים, שומרים על הכללים הבאים.

- ה-Subject הוא `DOC-POINTER` (Issuer, מזהה המסמך של אותה רשימה, גרסה `0`). השם נקשר למסמך ולא לגרסה, ולכן הגרסה היא `0`.
- קושרים רק למסמך שקדמה לו PUBLICATION. לא קושרים שם למסמך שמעולם לא פורסם.
- השם עוקב אחרי כללי שם מסמך (slug של ASCII באותיות קטנות), וחייב להיות שווה ל-BIND באינדקס השמות.
- כדי לשנות שם, מצרפים BIND חדש. השם הישן נשאר ומצביע על אותו מסמך. השם המייצג הוא ה-BIND האחרון.
- בתוך המסמך לא כותבים את שמו.

## כתובת

```
/.well-known/geul/<Issuer>/<doc-id>/versions.geul             מסמך הרשימה האחרון (משתנה)
/.well-known/geul/h/<content-hash>.geul                           מסמכי רשימה קודמים (בלתי משתנים)
```

- הדבר היחיד שמשתנה הוא כתובת הרשימה האחרונה. רשימה שהתקבלה מאומתת בחתימה, ב-`RECORDED-AT` ובשרשרת `PARENT`.
- כל מסמכי הרשימה הקודמים נשארים ב-`h/`. בעזרת שרשרת `PARENT` אפשר לשחזר רשימה מכל נקודת זמן.

## אימות

- במסמך הרשימה חייבת להיות `SIGNATURE` של מפתח מקום הפרסום שנקבע.
- מזהה המסמך ברשומות חייב להיות שווה למזהה המסמך שהתבקש.
- ה-hash של הרשימה הקודמת שנשמר ברישום הנעילה חייב להיות בשרשרת `PARENT` של הרשימה החדשה. ה-BODY של אותה רשימה חייב להיות שווה לתחילת ה-BODY של הרשימה החדשה.
- ה-hash של מסמך שהתקבל חייב להיות שווה לערך ש-PUBLICATION של מזהה הגרסה הזה רשמה, וה-`DOC-ID` של המסמך חייב להיות שווה ל-Issuer ולמזהה המסמך שהתבקשו.

## שאלות פתוחות

- טבלת קודים של קטגוריית הסיבה.
- ברירת המחדל של אלגוריתם החתימה ופריסת ה-Payload של `SIGNATURE`.
- מתי ובאיזה פורמט עוברים ליומן Merkle (הוכחות הכלה ועקביות) כשהרשימה גדלה.
- האם לאחד את ה-BIND ברשימה עם אינדקס השמות `documents.geul`, וחתימת האינדקס.
- מניעת חזרה לאחור ברמת Issuer. מכיוון שכל מסמך יוצר שרשרת רשימות משלו, התקפה שמציגה רשימה ישנה של מסמך אחד בלבד נחסמת רק על ידי השרשרת של אותו מסמך.

## דפים קשורים

- [Edge](/he/grammar/edge/), [BIND](/he/grammar/edge/bind/), [DOC-POINTER](/he/grammar/reference/doc-pointer/)
- [Issuer ופרסום](/he/grammar/issuer/), [כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/), [מסמך](/he/grammar/document/)
