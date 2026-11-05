---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "רושם את היקף ההסכמה ואת עילתה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `CONSENT` (BIND של מסמך מפרט: `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| מסמך מפרט | `0x00000000/codecs/0x00001E20/` (יעד DECLARE: `1E20`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 2 |
| Kind | Meta · מחלקה: מדיניות |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | היקף ההסכמה ועילתה |
| בצד Hugo | `meta/policy/consent.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | רשומה | `000F` כל קטע 0 (תו כללי, Reference), `020F` כל קטע 1 (תו כללי, Reference), `040F` כל קטע 2 (תו כללי, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

רושם את היקף ההסכמה ואת עילתה.

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[TAG הרחבה של Length]
Payload           Reference שמצביע על עילת ההסכמה, או טקסט
```

- Codec: Meta `0x1E2L`, מחלקת מדיניות
- Payload: Reference או Value מובנה
- מספר: אפשר כמה

## בעיות פתוחות {#열린-문제}

- מבנה הייצוג של ההיקף (מטרה, תקופה, העברה לצד שלישי).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E20/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
