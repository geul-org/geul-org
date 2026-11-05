---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID הוא Reference מצהיר המצביע על פריט (Item) ב-Wikidata."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `WIKIDATA-QID` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x014L~0x018L` |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 20~24 |
| Kind | Reference · סיווג: הצהרה |
| צד Hugo | `reference/wikidata-qid.md` |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

WIKIDATA-QID הוא Reference מצהיר המצביע על פריט (Item) ב-Wikidata. כותבים את החלק המספרי של ה-Q ID, בלי ה-`Q`, כמספר שלם ללא סימן.

## פריסה {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[Length TAG הרחבה]
QID               unsigned big-endian ברוחב הקצר ביותר
```

- כותבים את ה-QID ברוחב הקצר ביותר. `Q1`~`Q65535` תופסים בסך הכול 2 WORD, ומעל זה 3 WORD.
- נתוני Wikidata הם CC0.
- ב-Variable זהו משתנה אנונימי מהסוג שהפריט מציין ([Reference](_index.md) Variable).

## דוגמה {#예시}

| פריט | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000140/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

למעלה מסמך ה-Codec של `WIKIDATA-QID-IDENTIFIED` (`0x014L`). במסמכי ה-Codec של שאר החברים (`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
