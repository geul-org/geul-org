---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את האופן שבו הומר המסמך הזה מייצוג אחר (למשל ממיר Wikidata, מקודד שפה טבעית)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `TRANSFORMED-BY` (BIND של מסמך מפרט: `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| מסמך מפרט | `0x00000000/codecs/0x00001D40/` (יעד DECLARE: `1D40`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 20 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שיטת המרה. כלי, כללים, גרסה |
| בצד Hugo | `meta/lineage/transformed-by.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `version` | #3 | רשומה | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

רושם את האופן שבו הומר המסמך הזה מייצוג אחר (למשל, ממיר Wikidata, מקודד שפה טבעית). Tool הוא מה ששימש להמרה, ו-Version הוא איזה מקור של הכלי שימש. רק עם שניהם אפשר ליצור מחדש את אותו מסמך מאותו קלט.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[TAG הרחבה של Length]
Tool              רשומת Reference אחת (כלי המרה, כללים)
Version           רשומת Value אחת (SHA-256-DIGEST או SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, מחלקת שושלת
- Payload: Reference מובנה (הכלי) + Value מובנה (digest של גרסת המקור)
- מספר: אפשר כמה (אחד לכל כלי)

## פירוש ותוקף {#해석과-유효성}

- Tool הוא רשומת Reference שלמה אחת בדיוק. אפשר להשתמש בכל Reference שמצביע על כלי.
  - כלי ממסמך כלים של geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, מזהה מסמך `0x0001xxxx xxxxxxxx`, ה-LOCAL שלו). מסמך אחד לכל כלי (מסמך הגדרת מונחים של [Issuer](../issuer.md)).
  - אם ה-Codec הוא מסמך GEUL, מצביעים על מסמך ה-Codec הזה ב-[CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version הוא רשומת Value שלמה אחת בדיוק, ומזהה האובייקט בניהול הגרסאות של מקור ה-Tool. ב-git זה מזהה אובייקט ה-commit המלא.
  - אם פורמט האובייקטים של מאגר ה-git הוא SHA-256, זה [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORD); אם SHA-1, זה [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORD). את פורמט המאגר בודקים ב-`git rev-parse --show-object-format`.
  - אין להשתמש במזהה מקוצר (כמו `2bd496f`). Value של digest אינו מתיר ערך חתוך.
  - אין לכתוב כטקסט hex (UTF8-TEXT). אותו ערך תופס 22 WORD ב-SHA-1 (11 בבינארי) ו-34 WORD ב-SHA-256 (18 בבינארי).
- Version הוא חובה. רשומת כלי שגרסת המקור שלו אינה ידועה אינה יכולה לשמש בסיס לשחזור. אם הכלי מחוץ לניהול גרסאות, משתמשים ב-SHA-256 של התוצר המופץ (SHA-256-DIGEST).
- Version מצביע על מקור שנעשה לו commit. במסמך שנוצר מעץ עבודה עם שינויים שלא נעשה להם commit, אין לרשום את מזהה ה-commit הזה (מומלץ שהכלי יסרב לרוץ).
- אם הכלי נשען על קוד מחוץ למאגר (למשל ספרייה מקומית שהצביע עליה `replace` של Go), גם הקוד הזה נרשם בנפרד ב-TRANSFORMED-BY. מזהה ה-commit של הכלי לבדו אינו קובע את הקוד הזה.
- כלי שרק מעביר את המקור ללא אובדן (למשל כלי שטוען dump למסד נתונים כלשונו) אינו קובע את תוכן המסמך, ולכן אינו נרשם. טעינה עם אובדן משנה את המסמך, ולכן נרשמת ככלי.
- מסמך המפרט של geul.org (`0x1D40`) כותב אותו כשדה של שתי רשומות: Tool (רוחב 0, כל Reference ולכן בלי CODEC) ו-Version (רוחב 0, [CODEC](../edge/0x0BEL-codec.md) `07C0` ו-`07D0`).

## אורך {#길이}

```
סך הכול = 1 + N_len + N_tool + N_version WORD
```

- הסמן אחרי קריאת הרשומה האחרונה חייב להתיישר בדיוק עם סוף ה-Meta.
- אם Tool הוא EXTERNAL-ISSUER-2WORD (8 WORD) ו-Version הוא SHA1-DIGEST (11 WORD), הסך הוא 1 + 1 + 8 + 11 = 21 WORD, וכותבים אורך מורחב. עם SHA-256-DIGEST (18 WORD) הסך הוא 28 WORD.

## דוגמה {#예시}

דוגמה לא נורמטיבית. הכלי הוא LOCAL 2 של מסמך הכלים `0x0001000000000001` של geul.org (`02F7 0000 0000 0001 0000 0000 0001 0002`), והמקור הוא ה-commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## בעיות פתוחות {#열린-문제}

- האם גם הגרסה ב-[GENERATED-BY](0x1D3L-generated-by.md) תשתנה באותו אופן (digest חובה או פורמט אחר). גרסת מודל אינה מזהה commit.

## דפים קשורים {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D40/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
