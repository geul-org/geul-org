---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "רושם את הרישיון של המסמך הזה ושל היצירות שבתוך רצף הבתים."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `LICENSE` (BIND של מסמך מפרט: `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DE0/` (יעד DECLARE: `1DE0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 30 |
| Kind | Meta · מחלקה: מדיניות |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | רישיון. Reference |
| בצד Hugo | `meta/policy/license.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

רושם את הרישיון של המסמך הזה ושל היצירות שבתוך רצף הבתים.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[TAG הרחבה של Length]
Payload           Reference שמצביע על רישיון, או UTF8-TEXT של מזהה SPDX, או Value של URI
```

- Codec: Meta `0x1DEL`, מחלקת מדיניות
- Payload: Reference או Value מובנה ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מסמכים ש-geul.org מפרסם הם CC0. פרסום פרטי נקבע על ידי ה-Issuer ([Issuer](../issuer.md)).
- רושמים את הרישיון המקורי של יצירת המקור.

## בעיות פתוחות {#열린-문제}

- האם להציב את מזהה SPDX כטקסט או כ-Reference לישות GEUL.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DE0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
