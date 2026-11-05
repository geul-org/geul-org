---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER הוא Reference מכוון-מצהיר המצביע על גרסה אחת של מסמך שפרסם Issuer."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DOC-POINTER` (מסמך מפרט BIND `DOC-POINTER`) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| מסמך מפרט | `0x00000000/codecs/0x00000410/` (יעד DECLARE `0410`) |
| קטע | 2 `0010` (Reference שונים), היסט C בתוך הקטע = 1 |
| Kind | Reference · סיווג: מכוון-מצהיר |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| צד Hugo | `reference/doc-pointer.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | ערך גולמי 4 WORD |  |  |
| 3 | `version` | #4 | ערך גולמי 2 WORD |  |  |

DOC-POINTER הוא Reference מכוון-מצהיר המצביע על גרסה אחת של מסמך שפרסם Issuer. הוא יכול להיות יעד של פרסום מסמך, של deprecate ושל מחיקה, של גרסה מצוטטת ושל היגד על המסמך.

## פריסה {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length TAG הרחבה]
Issuer            2/4/16 WORD
ID מסמך           4 WORD
ID גרסה           2 WORD
```

## פירוש ותוקף {#해석과-유효성}

- רוחב ה-Issuer הוא מה שנותר מה-Payload אחרי הפחתת 6 WORD של ID המסמך ו-ID הגרסה. ה-Codec אינו מחלק את הרוחב. אם הרוחב אינו 2, 4 או 16 WORD, או שערך ה-Issuer נכנס ברוחב צר יותר, זה invalid (צורה קנונית של Issuer).
- אין משמיטים את ID הגרסה. אם ההשמטה הייתה מותרת, אי אפשר היה לקבוע את רוחב ה-Issuer מאורך ה-Payload בלבד (Issuer של 4 WORD בלי גרסה ו-Issuer של 2 WORD עם גרסה הם שניהם 8 WORD).
- ID גרסה `0` הוא הגרסה העדכנית. הוא קשור לגרסה הנוכחית ברגע הפירוש. כל ערך אחר מקבע את הגרסה הזאת ([PUBLICATION](../edge/0x0B8L-publication.md)).
- מסמך ID `0` הוא מסמך האינדקס של הגדרות המונחים של ה-Issuer. ה-Issuer עצמו מצביעים עליו ב-[ISSUER-POINTER](0x040L-issuer-pointer.md).
- כל Issuer שומר לעצמו את ID המסמך `0x0000000000000000` ו-`0xFFFFFFFFFFFFFFFF` ([Issuer ופרסום](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` משמש ברשימת ה-Issuer `issuers/` של Issuer `0x00000000`, ו-Issuer אחרים אינם משתמשים בו. PUBLICATION, DEPRECATION ו-TOMBSTONE ב-`issuers/versions.geul` מצביעים בערך זה על גרסאות הרשימה ([כתובת הפרסום ורשימת הגרסאות](../publishing.md#목록-문서)).
- זהו מקום אחד, Codec `0x041L`. אין כימות (Identified).
- הצורה היחידה להצבעה על מסמך של Issuer היא DOC-POINTER. הצבעה על מסמך באמצעות `EXTERNAL-ISSUER-*` (Issuer, ID מסמך, ID יעד `0`) או `EXTERNAL-POINTER-*` (IMPORT ID, ID יעד `0`) היא invalid.
- היכן משתמשים: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) ו-[IMPORT-DOC](../meta/0x1E4L-import-doc.md), וכן PUBLICATION, DEPRECATION ו-TOMBSTONE ברשימת הגרסאות.
- למסמך Codec אין ID מסמך. מצביעים על מסמך Codec ועל גרסתו ב-[CODEC-POINTER](0x042L-codec-pointer.md).

## דוגמה {#예시}

המסמך `0xFFFF000000000001` של Issuer GEUL `0x00000000`.

| גרסה | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| עדכנית (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID מסמך 4 + ID גרסה 2 = 9 WORD, ו-`LLLL=1000`. ה-TAG הוא `0000 0100 0001 1000` = `0418`.

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer ופרסום](../issuer.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000410/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
