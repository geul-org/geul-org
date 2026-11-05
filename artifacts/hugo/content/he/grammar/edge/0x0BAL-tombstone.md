---
title: "TOMBSTONE (0x0BAL)"
weight: 186
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION ו-TOMBSTONE הן Edge של היגד שרושמות פרסום, המלצה להפסיק להשתמש ומחיקה של גרסאות מסמך, והדף הזה קובע גם את מפרט מסמך רשימת הגרסאות שנכתב בהן (Codec 0x0B8L~0x0BAL)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION ו-TOMBSTONE הן Edge של היגד שרושמות פרסום, המלצה להפסיק להשתמש ומחיקה של גרסאות מסמך, והדף הזה קובע גם את מפרט מסמך רשימת הגרסאות שנכתב בהן (Codec‏ 0x0B8L~0x0BAL).

| פריט | ערך |
|---|---|
| שם | `TOMBSTONE` (BIND במסמך המפרט `TOMBSTONE`) |
| TAG ID | `0x0BAL` |
| Codec ID | `0x00000BA0` |
| מסמך מפרט | `0x00000000/codecs/0x00000BA0/` (יעד DECLARE‏ `0BA0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 26 |
| Kind | Edge · משפחה: היגד, קבוצה: אחר |
| TAG WORD | `0000 1011 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מחיקה (מצבה) של גרסה שפורסמה. DOC-POINTER, קטגוריית סיבה |
| בצד Hugo | `edge/publication.md` (בצד ההוא מכוסות גם [PUBLICATION](0x0B8L-publication.md) ו-[DEPRECATION](0x0B9L-deprecation.md)) |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | רשומה | `0410` DOC-POINTER, ‏`0420` CODEC-POINTER |  |
| 2 | `reason` | #4 | ערך גולמי, WORD אחד |  |  |

אלה Edge של היגד שרושמות פרסום, deprecate ומחיקה של מסמך, והמפרט של מסמך רשימת הגרסאות שנכתב בהן. הן קובעות את פורמט רשימת הגרסאות ב[כתובת פרסום ורשימת גרסאות](../publishing.md#버전-목록).

## קודים {#코드}

| Codec | שם | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, ‏DOC-POINTER, ‏hash תוכן |
| `0x0B9L` | DEPRECATION | Edge Id, ‏DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, ‏DOC-POINTER, קטגוריית סיבה |

- שלושת הקודים מוטמעים במפענח ([שכבה 0](../publishing.md#층)). רשימת גרסאות מפורשת בלי לשלוף codebook.
- אין תת-פורמטים (TAG לפי Codec). שומרים כמות שהוא את כלל ה-[Edge](_index.md) שהרכיב הראשון ב-Payload הוא Edge Id.

## פריסה {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
מסמך              רשומת DOC-POINTER Reference (Issuer, מזהה מסמך, מזהה גרסה). ברשימת גרסאות של Codec: CODEC-POINTER
hash תוכן         16 WORD   (PUBLICATION)
קטגוריית סיבה     WORD אחד  (TOMBSTONE)
```

| שדה | רוחב | הסבר |
|---|---|---|
| Edge Id | רשומת LOCAL Reference | מספר סידורי ברשימה. ממספרים מ-1 ומצרפים בסוף |
| מסמך | רשומת DOC-POINTER | גרסה אחת של המסמך שפורסם ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). ה-Issuer ומזהה המסמך זהים למסמך שהרשימה עוסקת בו. כך מסמך הרשימה אומר של מה הוא רשימה גם בלי נתיב. מזהה הגרסה הוא המספר הסידורי בתוך אותו מסמך ([מסמך](../document.md), גרסה), ו-`0` (האחרונה) אינו בשימוש. רשימת הגרסאות של Codec משתמשת ב-[CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, מזהה Codec, מזהה גרסה) |
| hash תוכן | 16 WORD | hash התוכן של אותה גרסה (SHA-256, [מסמך](../document.md), hash תוכן) |
| קטגוריית סיבה | WORD אחד | קוד הקטגוריה של סיבת המחיקה. טבלת הקודים היא בעיה פתוחה |

- האורך אחרי ה-DOC-POINTER קבוע לכל קוד (16, 0, 1 WORD). אם שונה, דוחים.
- בתוך הרשומה לא מכניסים זמן. הזמן של פרסום, deprecate או מחיקה הוא ה-`RECORDED-AT` של מסמך הרשימה הראשון שבו נכללה הרשומה.

## מסמך רשימת גרסאות {#버전-목록-문서}

מקום הפרסום ממשיך לכתוב מסמך רשימת גרסאות אחד לכל מסמך: `/<Issuer>/docs/<מזהה מסמך>/versions.geul` (ל-Codec: `/<Issuer>/codecs/<מזהה Codec>/versions.geul`, ולרשימת ה-Issuer ראו [להלן](#목록-문서의-버전-목록)). כל הגרסאות של אותו מסמך שפורסמו במקום הפרסום הזה נכנסות לרשימה אחת.

```
DOC-1WORD/2WORD/4WORD     אורך כולל
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value מסוג SHA-256-DIGEST. hash התוכן של מסמך הרשימה הקודם (אין ברשימה הראשונה)
  RECORDED-AT             Value מסוג POSIX-TIMESTAMP-SECONDS. הזמן שבו הוצאה הרשימה
  NEXT-LOCAL-ID           ה-LOCAL ID הבא להקצאה (אם יש גרסאות)
  SIGNATURE               חתימת מקום הפרסום. היעד הוא hash התוכן של מסמך הרשימה הזה
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- Meta של ה-HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- במסמך רשימת גרסאות לא מציבים `DOC-ID` (חריג של מסמך רשימה, [DOC-ID](../meta/0x1C7L-doc-id.md)). רשימה אינה מסמך שפורסם אלא רישום שמצורף למסמך. מזהה המסמך ב-DOC-POINTER של הרשומה אומר של איזה מסמך היא רשימה. לכן גם כשמקבלים אותה בלי נתיב (`hashes/`, dump) יודעים של מה היא רשימה.
- מזהי המסמך ברשומות חייבים כולם להיות של המסמך שהרשימה עוסקת בו. רשומה של מסמך אחר נדחית.
- מסמך רשימת הגרסאות אינו מציב IMPORT ומשתמש רק ב-Codec של שכבה 0. ב-BODY מציבים רק PUBLICATION, ‏DEPRECATION ו-TOMBSTONE. לא מציבים BIND של שם מסמך ([כתובת פרסום ורשימת גרסאות](../publishing.md#문서-이름)).
- מסמך רשימה חדש שומר בתחילתו את ה-BODY של מסמך הרשימה הקודם כמות שהוא ומוסיף אחריו רשומות. לא מתקנים, לא מוחקים ולא משנים סדר.
- מקום הפרסום חותם על הרשימה. בפרסום ב-geul.org, geul.org (ה-Issuer של GEUL) חותמת, ובפרסום פרטי ה-Issuer עצמו חותם.
- מזהה המסמך `0x0000000000000000` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer ([Issuer ופרסום](../issuer.md)). ה-Issuer עצמו מוצבע באמצעות [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## רשימת הגרסאות של מסמך רשימה {#목록-문서의-버전-목록}

מסמך הרשימה הוא רשימת ה-Issuer‏ `issuers/` אחת ([כתובת פרסום ורשימת גרסאות](../publishing.md#목록-문서)). גם לרשימת ה-Issuer יש גרסאות מגרסה 1, ויש לה רשימת גרסאות `issuers/versions.geul`. הרשומה מצביעה על גרסת הרשימה באמצעות DOC-POINTER של מזהה מסמך שמור (`0x00000000`, ‏`0xFFFFFFFFFFFFFFFF`, מזהה גרסה).

- פורמט הרשומה זהה לאמור לעיל. לכן גם כשמקבלים אותה דרך `hashes/` יודעים של מה היא רשימה.
- גם מסמך הרשימה עצמו (`<מזהה גרסה>.geul`) אינו מציב `DOC-ID`.
- את מזהה המסמך `0xFFFFFFFFFFFFFFFF` לא מקבלים באף Issuer דרך כתובת `<Issuer>/docs/<מזהה מסמך>/` (404).
- ה-`latest.geul` של הרשימה הוא כינוי שאינו נשמר. מוצאים ברשימת הגרסאות הזו את הגרסה העדכנית ביותר ומוציאים את הבתים שלה.

## כללים {#규칙}

- מזהי הגרסה ב-PUBLICATION עולים מ-1 בלי פערים. מזהה הגרסה מוקצה בידי מקום הפרסום.
- אין מפרסמים שוב את אותו hash תוכן. אם כבר קיים, מחזירים את מזהה הגרסה שלו.
- DEPRECATION ו-TOMBSTONE מצביעות רק על מזהה גרסה של PUBLICATION שהופיעה קודם. הצבעה על גרסה שאינה קיימת נדחית.
- מצב הגרסה מחושב מהחלת הרשומות לפי הסדר: פורסמה ← deprecated ← נמחקה. גרסה שנמחקה לא מפרסמים שוב ולא מוסרים.
- הגרסה האחרונה היא מזהה הגרסה הגבוה ביותר שאינו deprecated ואינו נמחק.
- כשמזהה הגרסה מגיע לסוף 2 ה-WORD, אין מפרסמים עוד גרסאות של המסמך ומוציאים אותו עם מזהה מסמך חדש.

## כתובת {#주소}

```
/.well-known/geul/<Issuer>/docs/<מזהה מסמך>/versions.geul        מסמך הרשימה האחרון (משתנה)
/.well-known/geul/<Issuer>/codecs/<מזהה Codec>/versions.geul      מסמך הרשימה האחרון של Codec (משתנה)
/.well-known/geul/issuers/versions.geul                       רשימת הגרסאות האחרונה של רשימת ה-Issuer (משתנה)
/.well-known/geul/<Issuer>/hashes/<hash תוכן>.geul             מסמכי רשימה קודמים (בלתי משתנים)
```

- הדבר היחיד שמשתנה הוא כתובת הרשימה האחרונה. רשימה שהתקבלה מאומתת בחתימה, ב-`RECORDED-AT` ובשרשרת `PARENT`.
- כל מסמכי הרשימה הקודמים נשארים ב-`<Issuer>/hashes/`. בעזרת שרשרת `PARENT` אפשר לשחזר רשימה מכל נקודת זמן.

## אימות {#검증}

- במסמך הרשימה חייבת להיות `SIGNATURE` של מפתח מקום הפרסום שנקבע.
- מזהה המסמך ברשומות חייב להיות שווה למזהה המסמך שהתבקש.
- ה-hash של הרשימה הקודמת שנשמר ברישום הנעילה חייב להיות בשרשרת `PARENT` של הרשימה החדשה. ה-BODY של אותה רשימה חייב להיות שווה לתחילת ה-BODY של הרשימה החדשה.
- ה-hash של מסמך שהתקבל חייב להיות שווה לערך ש-PUBLICATION של מזהה הגרסה הזה רשמה, וה-`DOC-ID` של המסמך חייב להיות שווה ל-Issuer ולמזהה המסמך שהתבקשו. במסמך רשימה אין `DOC-ID`.

## בעיות פתוחות {#열린-문제}

- טבלת קודים של קטגוריית הסיבה.
- ברירת המחדל של אלגוריתם החתימה ופריסת ה-Payload של `SIGNATURE`.
- מתי ובאיזה פורמט עוברים ליומן Merkle (הוכחות הכלה ועקביות) כשהרשימה גדלה.
- מניעת חזרה לאחור ברמת Issuer. מכיוון שכל מסמך יוצר שרשרת רשימות משלו, התקפה שמציגה רשימה ישנה של מסמך אחד בלבד נחסמת רק על ידי השרשרת של אותו מסמך.

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer ופרסום](../issuer.md), [כתובת פרסום ורשימת גרסאות](../publishing.md), [מסמך](../document.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000BA0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BA000000000
BODY
#1 DECLARE 0x0BA0
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0001
#5 BIND #1 "TOMBSTONE"
#6 BIND #2 "doc"
#8 BIND #4 "reason"
#10 CODEC #2 0x0420
```
