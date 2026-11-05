---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את הגורם שיצר את המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `GENERATED-BY` (BIND של מסמך מפרט: `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| מסמך מפרט | `0x00000000/codecs/0x00001D30/` (יעד DECLARE: `1D30`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 19 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | גורם יוצר. אדם, מודל, מנוע כללים |
| בצד Hugo | `meta/lineage/generated-by.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |
| 2 | `version` | #5 | רשומה | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (שדה אופציונלי) |  |

רושם את הגורם שיצר את המסמך. הוא יכול להיות אדם, מודל או מנוע כללים.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[TAG הרחבה של Length]
גורם יוצר         Reference (אדם, מודל, מנוע כללים)
גרסה              Value מסוג UTF8-TEXT, או סמן השמטה 0x0000 (שדה אופציונלי)
```

- Codec: Meta `0x1D3L`, מחלקת שושלת
- Payload: Reference מובנה + טקסט גרסה (אופציונלי)
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- אם זה מודל, רושמים יחד איתו את גרסת המודל.
- אם הגרסה אינה ידועה או שאין צורך בה, משמיטים את המקום ומציבים ABSENT (`0x0000`) (שדה אופציונלי של [CODEC](../edge/0x0BEL-codec.md)). מפרט geul.org `0x1D30` הוא שדה של שתי רשומות: agent (בלי CODEC) ו-version (`0720`, `0730`, `0000`).
- את גרסת המקור (commit) של תוכנית מתאר במדויק יותר הפורמט של [TRANSFORMED-BY](0x1D4L-transformed-by.md) (digest, חובה). הגרסה ב-GENERATED-BY רושמת כטקסט דברים שאינם מזהה commit, כמו שם המודל והגרסה שלו.
- במסמכים ש-geul.org מפרסם אין Reference שמצביע על אדם טבעי ([Issuer ופרסום](../issuer.md#geulorg-공표)). מצביעים על ארגון או Issuer. היוצא מן הכלל: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D30/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
