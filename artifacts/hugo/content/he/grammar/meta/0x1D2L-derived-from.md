---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם שהמסמך הזה נגזר ממסמך או מחומר משושלת אחרת."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DERIVED-FROM` (BIND של מסמך מפרט: `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| מסמך מפרט | `0x00000000/codecs/0x00001D20/` (יעד DECLARE: `1D20`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 18 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | נגזר מרשומה או מחומר משושלת אחרת. כדי לקבע גרסה מסוימת של חומר חיצוני, מצרפים ל-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) ב-HEAD את ה-QUALIFIER של hash הנוסח המקורי (P4092) (git submodule). |
| בצד Hugo | `meta/lineage/derived-from.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

רושם שהמסמך הזה נגזר ממסמך או מחומר משושלת אחרת.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[TAG הרחבה של Length]
Payload           Reference, או SHA-256-DIGEST (hash תוכן), או Value של URI
```

- Codec: Meta `0x1D2L`, מחלקת שושלת
- Payload: Reference או Value מובנה
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- אם הנגזרת היא ממסמך GEUL, מציבים את hash התוכן שלו ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)); אם מחומר חיצוני, מציבים [URI](../value/0x074L-uri.md). כדי לקבע את מהדורת החומר החיצוני ב-hash, מצרפים ל-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) ב-HEAD את ה-QUALIFIER של hash הנוסח המקורי (P4092).
- מקור ברמת רשומה נושא Edge של ראיות [SOURCE](../edge/0x0C0L-source.md); רשומה ישנה לפני העברה, פיצול או איחוד נושא ה-QUALIFIER P1365 של ה-Edge המטרה (הערך הוא מזהה ה-Edge הישן).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D20/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
