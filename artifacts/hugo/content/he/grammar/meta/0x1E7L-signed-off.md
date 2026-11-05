---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "אישור זכות התרומה (git Signed-off-by, DCO)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SIGNED-OFF` (BIND של מסמך מפרט: `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| מסמך מפרט | `0x00000000/codecs/0x00001E70/` (יעד DECLARE: `1E70`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 7 |
| Kind | Meta · מחלקה: אימות |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | אישור זכות תרומה. Reference (git `Signed-off-by`, DCO) |
| בצד Hugo | `meta/verification/signed-off.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |

אישור זכות התרומה (git `Signed-off-by`, DCO).

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[TAG הרחבה של Length]
Payload           Reference אחד
```

- Codec: Meta `0x1E7L`, מחלקת אימות
- Payload: Reference מובנה
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- במסמכים ש-geul.org מפרסם אין Reference שמצביע על אדם טבעי ([Issuer ופרסום](../issuer.md#geulorg-공표)). מצביעים על ארגון או Issuer. היוצא מן הכלל: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E70/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
