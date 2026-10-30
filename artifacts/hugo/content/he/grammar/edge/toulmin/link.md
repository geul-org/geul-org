---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK היא הפריסה שבה נכתבים יחסים בין צמתי TOULMIN (תקיפה, דחיקה, ביצוע, קישור הכרעה, הגדרה, שם). היא בנויה מ-REF של src ו-dst, WORD של דגלים, שער ודאות רשותי, כוח תקיפה רשותי ו-SPAN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK היא הפריסה שבה נכתבים יחסים בין צמתים בגרף TOULMIN. סוג היחס נקבע לפי ה-Codec (או מספר פורמט ISSUER של GEUL).

## Codec

| Codec | שם | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | כלל → כלל. מקטינה בהדרגה את ההכרעה לפי כוח התקיפה |
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
flags WORD אחד   b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         אופרטור ב-WORD אחד (2 הביטים העליונים) + Value מסוג UNSIGNED-DECIMAL (אחוז)
[F_FORCE]        Value מסוג SIGNED-DECIMAL. כוח תקיפה (0~1). ATTACKS בלבד
SPAN             הרוחב ש-SOURCE קובע × 2
```

| flag | משמעות |
|---|---|
| b0 F_ONCE | מתבצע פעם אחת בלבד (`once` של UNDO) |
| b1 F_GATE | יש שדה שער ודאות |
| b2 F_STRIKE | יחס שנמחק בקו חוצה |
| b3 F_ORDERED | שייך לרשימה ממוספרת `1.` |
| b4 F_FORCE | יש שדה כוח תקיפה. ATTACKS בלבד |

| אופרטור שער | משמעות |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- שדות מותנים באים לפי סדר הדגלים (F_GATE, F_FORCE). שדה שהדגל שלו כבוי אינו תופס מקום.

## כוח התקיפה

כוח התקיפה (Force) מציין באיזה כוח קשת ATTACKS אחת תוקפת את היעד שלה. הטווח הוא 0~1, וכשאין F_FORCE הוא 1.

- בהכרעה, התרומה `(v+1)/2` של ערך ההכרעה v של התוקף מוכפלת בכוח F. תקיפת הפרכה (COUNTER) נכנסת לאיבר המכנה כ-`F·(v+1)/2`, ותקיפת חריג (EXCEPT) נכנסת לשער `Π(1 − F·(v+1)/2)`. כאשר F הוא 0 אין לתקיפה השפעה על ההכרעה.
- הערך פועל לפי כללי המספרים של [TOULMIN](/he/grammar/edge/toulmin/#ערכים-מספריים). המקודד מוחק אפסים בסוף המקדם (0.5 הוא `C=5, E=−1`, ו-1.0 הוא `C=1, E=0`). המפענח מקבל עד 4 ספרות אחרי הנקודה.
- משטח שאינו כותב כוח (`don't X when Y`, ובקוריאנית `` `Y` 면 `X` 는 무효다``) מכבה את F_FORCE.
- משטח שכותב כוח (בקוריאנית `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) מדליק את F_FORCE ונושא את הערך. גם כשכותבים 1, כמו ב-`1.0의 세기로`, מדליקים את F_FORCE ונושאים 1. כך משטח המקור חוזר כפי שנכתב.
- כוח התקיפה הוא ציר שונה מעוצמת הצומת (Strict, Defeasible, Defeater). העוצמה שייכת לצומת, וכוח התקיפה שייך לקשת ATTACKS.

### דוגמה

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, התוקף Y הוא Edge Id 3, היעד X הוא Edge Id 2, רוחב SPAN הוא WORD אחד.

```
16E8                  TAG WORD: Edge, סך הכול 14 WORD, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, תוקף)
0088 0002             dst     LOCAL 2 (X, יעד)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    בית התחלה 0x40, מספר בתים 0x1A
```

לאותה קשת בלי כוח יש flags `0000` ואין לה שדה F_FORCE. ה-TAG WORD שלה הוא `14E8` (סך הכול 10 WORD).

## פירוש ותקינות

- REF הוא Edge Id של רשומה במסמך הזה ([TOULMIN](/he/grammar/edge/toulmin/#שדות-משותפים), שדות משותפים).
- צורת ה-dst נקבעת לפי ה-Codec. ב-DO·DO-ONCE·UNDO הוא FuncRef (REF(ALIAS, 0 אם אין) + VerbCode ב-WORD אחד, [NODE](/he/grammar/edge/toulmin/node/#שדות)), ב-LABEL·IMPORTED-FROM הוא REF של רשומת TEXT, ובשאר הוא REF של צומת.
- `do … once` מיוצג על ידי ה-Codec DO-ONCE. בדגלים של DO-ONCE לא משתמשים ב-F_ONCE (אם הוא דלוק, דוחים). ה-`once` של UNDO נכתב ב-F_ONCE.
- אופרטור השער הוא 2 הביטים העליונים של ה-WORD של האופרטור, ו-14 הביטים הנותרים הם 0. האחוז הוא Value מסוג UNSIGNED-DECIMAL עם `E=0` והוא 0~100.
- b5~b15 של הדגלים שמורים וחייבים להיות 0. אחרת דוחים.
- F_FORCE משמש רק ב-ATTACKS. אם הוא דולק ב-Codec אחר (SUPERSEDES, קישורי ביצוע והכרעה, יחסים בפורמט ISSUER), דוחים.
- אם כוח התקיפה אינו Value מסוג SIGNED-DECIMAL, נמצא מחוץ ל-0~1 או אי אפשר לכתוב אותו במדויק ב-4 ספרות אחרי הנקודה, דוחים.
- שרשרת `A > B > C` של SUPERSEDES נכתבת כ-SUPERSEDES אחד לכל זוג.

## דפים קשורים

- [TOULMIN](/he/grammar/edge/toulmin/), [NODE](/he/grammar/edge/toulmin/node/), [SOURCE וחלוקה](/he/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/)
