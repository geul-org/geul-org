---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX הוא Reference מצהיר המצביע על יעד באמצעות GEUL SIDX (Semantic-aligned Index)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `GEUL-SIDX` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x00FL~0x013L` |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 15~19 |
| Kind | Reference · סיווג: הצהרה |
| צד Hugo | `reference/geul-sidx.md` |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

GEUL-SIDX הוא Reference מצהיר המצביע על יעד באמצעות GEUL SIDX (Semantic-aligned Index). SIDX הוא מזהה שהביטים עצמם נושאים בו משמעות (סוג, תכונה).

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length TAG הרחבה]
SIDX              כל השאר
```

- ה-Quantifier זהה לשאר Codec ההצהרה. ב-Variable זהו משתנה אנונימי מאותו סוג ([Reference](_index.md) Variable). הכימות נעשה רק בקוד 5Q (`0x00FL~0x013L`, `C % 5`). אין מכניסים כימות לתוך ערך ה-SIDX.
- מסמך המפרט מצהיר על SIDX כשדה אחד של ערך גולמי ברוחב השארית. כשייקבעו כללי הרוחב, הוא ישתנה.

## דוגמה {#예시}

| SIDX | WORD sequence |
|---|---|
| (לא נורמטיבי) 64 ביט `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## מדיניות הקצאה {#배정-방침}

- התפקיד שונה מזה של [GEUL](0x00AL-geul.md). GEUL הוא ID של זהות שמוקצה בדרך כלל לפי הסדר (auto increment), ואילו GEUL-SIDX הוא כתובת משמעות שנותנת ליעדים קרובים במשמעות ערכים קרובים.
- מידת הקרבה נקבעת בסטטיסטיקה שנאספת מנתוני שימוש. עד שנאספת הסטטיסטיקה משתמשים ב-GEUL ID, ואחרי שמוקצה SIDX מקשרים את ה-GEUL וה-GEUL-SIDX של אותו יעד ב-[SAME-NODE](../edge/0x0A1L-same-node.md).

## בעיות פתוחות {#열린-문제}

- **רוחב.** ייקבע לפי הסטטיסטיקה. נבחנים 4 WORD (64 ביט), 16 WORD ועוד. ל-SIDX יש משמעות בביטים העליונים, ולכן אי אפשר להחיל עליו כמות שהוא את כלל «הרוחב הקצר ביותר» (איסור WORD מוביל `0x0000`) של שאר Codec ההצהרה. לכן יהיה זה רוחב קבוע (או רוחב קבוע לכל תת-פורמט). עד שייקבע, מסמך המפרט מצהיר על SIDX כערך גולמי ברוחב השארית.
- **יציבות ההקצאה.** ב-Reference, ערכים שלמים שווים הם אותו יעד, ו-ID שהוקצה אינו נעשה בו שימוש חוזר. כדי שלא להזיז SIDX שכבר הוקצו גם כשהסטטיסטיקה משתנה, נדרשת הקצאת append-only (הקצאה דלילה ששומרת מקומות קרובים במשמעות). אם ההזזות תכופות, יוחלט אם להגדיר את ה-SIDX לא כמזהה קבוע אלא כאינדקס הקשור לגרסת הרישום.
- **ייחודיות.** אם SIDX נוצר לפי משמעות הביטים ועלולות להיות התנגשויות, הדבר אינו מתיישב עם ההנחה «ערכים שלמים שווים הם אותו יעד». בהקצאה פותרים את ההתנגשויות ומבטיחים ייחודיות.
- הקודבוק והפורמט הציבורי של הרישום.

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x000000F0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

למעלה מסמך ה-Codec של `GEUL-SIDX-IDENTIFIED` (`0x00FL`). במסמכי ה-Codec של שאר החברים (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
