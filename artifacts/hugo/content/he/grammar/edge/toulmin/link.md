---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK היא הפריסה שבה נכתבים יחסים בין צמתי TOULMIN (תקיפה, דחיקה, ביצוע, קישור הכרעה, הגדרה, שם). היא בנויה מ-REF של src ו-dst, WORD של דגלים, שער ודאות רשותי ו-SPAN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK היא הפריסה שבה נכתבים יחסים בין צמתים בגרף TOULMIN. סוג היחס נקבע לפי ה-Codec (או מספר פורמט ISSUER של GEUL).

## Codec

| Codec | שם | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | כלל → כלל. מקטינה בהדרגה את ההכרעה |
| `0x69` | SUPERSEDES | `X supersedes Y` | כלל → כלל. כש-Active, מוציאה את היעד מהצבירה |
| `0x70` | RUN | `run c when n` | כלל → מקרה |
| `0x71` | DO | `do fn when n` | כלל → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | כלל → FuncRef |
| `0x73` | UNDO | `undo fn when n` | כלל → FuncRef |
| `0x74` | CHECKING | `checking c` | כלל → מקרה. הכרעה בלי תופעות לוואי |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | מקרה → שדה |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | פריט הגדרה → ערך או טיפוס |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | פריט הגדרה → שדה |
| ISSUER `0x0000`/`0xC023` | RUNS | נקודת כניסה `run c` | נקודת כניסה → מקרה (ביצוע) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | נקודת כניסה `check c` | נקודת כניסה → מקרה (הכרעה) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | trigger `run c` | trigger → מקרה |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | trigger → מקרה |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | צומת → מזהה גלובלי |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | כינוי → נתיב (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | שם בגרשיים הפוכים | צומת → TEXT. רישום שם |

## פריסה

```
ID               רשומת LOCAL Reference (Edge Id)
src              REF
dst              REF. ב-DO·DO-ONCE·UNDO הוא FuncRef
flags WORD אחד   b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         אופרטור ב-WORD אחד (2 הביטים העליונים) + Value מסוג UNSIGNED-DECIMAL (אחוז)
SPAN             הרוחב ש-SOURCE קובע × 2
```

| flag | משמעות |
|---|---|
| b0 F_ONCE | מתבצע פעם אחת בלבד (`once` של UNDO) |
| b1 F_GATE | יש שדה שער ודאות |
| b2 F_STRIKE | יחס שנמחק בקו חוצה |
| b3 F_ORDERED | שייך לרשימה ממוספרת `1.` |

| אופרטור שער | משמעות |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## פירוש ותקינות

- REF הוא Edge Id של רשומה במסמך הזה ([TOULMIN](/he/grammar/edge/toulmin/#שדות-משותפים), שדות משותפים).
- צורת ה-dst נקבעת לפי ה-Codec. ב-DO·DO-ONCE·UNDO הוא FuncRef (REF(ALIAS, 0 אם אין) + VerbCode ב-WORD אחד, [NODE](/he/grammar/edge/toulmin/node/#שדות)), ב-LABEL·IMPORTED-FROM הוא REF של רשומת TEXT, ובשאר הוא REF של צומת.
- `do … once` מיוצג על ידי ה-Codec DO-ONCE. בדגלים של DO-ONCE לא משתמשים ב-F_ONCE (אם הוא דלוק, דוחים). ה-`once` של UNDO נכתב ב-F_ONCE.
- אופרטור השער הוא 2 הביטים העליונים של ה-WORD של האופרטור, ו-14 הביטים הנותרים הם 0. האחוז הוא Value מסוג UNSIGNED-DECIMAL עם `E=0` והוא 0~100.
- b4~b15 של הדגלים שמורים וחייבים להיות 0. אחרת דוחים.
- שרשרת `A > B > C` של SUPERSEDES נכתבת כ-SUPERSEDES אחד לכל זוג.

## דפים קשורים

- [TOULMIN](/he/grammar/edge/toulmin/), [NODE](/he/grammar/edge/toulmin/node/), [SOURCE וחלוקה](/he/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/)
