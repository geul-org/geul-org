---
title: "DOC-2WORD (0x1C1L)"
weight: 449
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD ו-DOC-4WORD הם Meta של מבנה שפותחים מסמך בציון מספר ה-WORD הכולל שלו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD ו-DOC-4WORD הם Meta של מבנה שפותחים מסמך בציון מספר ה-WORD הכולל שלו.

| פריט | ערך |
|---|---|
| שם | `DOC-2WORD` (BIND של מסמך מפרט: `DOC-2WORD`) |
| TAG ID | `0x1C1L` |
| Codec ID | `0x00001C10` |
| מסמך מפרט | `0x00000000/codecs/0x00001C10/` (יעד DECLARE: `1C10`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 1 |
| Kind | Meta · מחלקה: מבנה |
| TAG WORD | `0001 1100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תחילת מסמך שבו האורך הכולל נקבע ב-Payload של 2 WORD |
| בצד Hugo | `meta/structure/doc.md` (שם נדונים יחד גם [DOC-1WORD](0x1C0L-doc-1word.md) ו-[DOC-4WORD](0x1C2L-doc-4word.md)) |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | ערך גולמי, 2 WORD |  |  |

זו הרשומה שפותחת את המסמך. ב-Payload נקבע מספר ה-WORD הכולל של המסמך. בדף הזה נדונים יחד `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`) ו-`DOC-4WORD` (`0x1C2L`).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[TAG הרחבה של Length]
Payload           מספר ה-WORD הכולל. ה-Codec קובע את הרוחב: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, מחלקת מבנה
- Payload: ערך גולמי (מספר ה-WORD הכולל של המסמך, unsigned)
- מספר: אחד לכל מסמך, בראשיתו

## פירוש ותוקף {#해석과-유효성}

- האורך נמדד מתחילת הרשומה הפותחת ועד סוף [END](0x1C4L-end.md).
- משתמשים ברוחב הצר ביותר שהערך נכנס בו. קידוד ברוחב רחב יותר נדחה כקידוד לא נורמלי.
- האורך חייב להיות שווה לכל הקלט. מסמך אחד הוא קלט אחד.
- המפענח יכול לדלג על המסמך כולו לפי האורך הזה. אין Codec שפותח בלי לדעת את האורך.
- בחישוב hash תוכן, כותבים מחדש את האורך בלי Meta של מחלקת האימות, וברוחב המתאים לו ([hash תוכן](../document.md#내용-해시)).

## דוגמה {#예시}

- `0x1C01 0x0017`: DOC-1WORD, סך הכול 23 WORD

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C10/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C1000000000
BODY
#1 DECLARE 0x1C10
#2 FIELD #1 0x0002
#3 BIND #1 "DOC-2WORD"
#4 BIND #2 "count"
```
