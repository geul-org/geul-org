---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER הוא Reference מכוון המצביע על LOCAL ID של מסמך שיובא באמצעות IMPORT-DOC ב-HEAD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER הוא Reference מכוון המצביע על LOCAL ID של מסמך שיובא באמצעות IMPORT-DOC ב-HEAD.

| פריט | ערך |
|---|---|
| שם | `EXTERNAL-POINTER-2WORD` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x025L~0x029L` |
| קטע | 1 `0001` (Reference EXTERNAL), היסט C בתוך הקטע = 5~9 |
| Kind | Reference · סיווג: מכוון |
| צד Hugo | `reference/external-pointer.md` (הדף שם עוסק גם ב-[EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) ו-[EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | ערך גולמי 2 WORD |  |  |
| 2 | `target-id` | #3 | ערך גולמי לשארית (`0xFFFF`) |  |  |

EXTERNAL-POINTER הוא Reference מכוון המצביע על LOCAL ID של מסמך שיובא באמצעות [IMPORT-DOC](../meta/0x1E4L-import-doc.md) ב-HEAD.

## פריסה {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (קטע 1)
[Length TAG הרחבה]
IMPORT ID         ברוחב שנקבע ב-Codec (1/2/4 WORD)
ID יעד            כל השאר. LOCAL ID של המסמך שיובא, ברוחב הקצר ביותר
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | שם | רוחב IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- הרוחב נקבע לפי מספר הערכה: אם ערכה − 6 (`C / 5` של ההיסט `C` בתוך הקטע) הוא 0, 1 או 2, הרוחב הוא 1, 2 או 4 WORD. הכימות הוא `C % 5`.

- משתמשים ב-Codec הצר ביותר שערך ה-IMPORT ID נכנס בו.
- ה-IMPORT ID הוא ערך ש-`IMPORT-DOC` של המסמך הזה הקצה. ב-EXTERNAL-POINTER אין כותבים Issuer. ה-Issuer ו-ID המסמך נלקחים מאותו `IMPORT-DOC`. גם הגרסה נקבעת על ידי אותו `IMPORT-DOC` (קבועה או עדכנית).
- אם זה אותו LOCAL ID של המסמך שיובא, הוא אותו יעד, בין שנכתב בתוך אותו מסמך כ-LOCAL ובין שנכתב כאן כ-EXTERNAL-POINTER.
- ב-Variable זהו משתנה LOCAL של המסמך שיובא.

## תקפות {#유효성}

- אם במסמך הזה אין `IMPORT-DOC` שהקצה את ה-IMPORT ID הזה, זה invalid.
- אם ה-IMPORT ID נכנס ב-Codec צר יותר אך נעשה שימוש ב-Codec רחב, נדחה כ-non-minimal.
- אם ID היעד הוא `0`, זה invalid. המסמך שיובא עצמו מצביעים עליו ב-[DOC-POINTER](0x041L-doc-pointer.md).
- WORD מוביל `0x0000` ב-ID היעד אסור.

## דוגמה {#예시}

| יעד | WORD sequence |
|---|---|
| LOCAL 5 של IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 של IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 של IMPORT ID 70000 | `0253 0001 1170 0005` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000250/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

למעלה מסמך ה-Codec של `EXTERNAL-POINTER-2WORD-IDENTIFIED` (`0x025L`). במסמכי ה-Codec של שאר החברים (`EXTERNAL-POINTER-2WORD-GENERIC`, `EXTERNAL-POINTER-2WORD-FREE-CHOICE`, `EXTERNAL-POINTER-2WORD-UNIVERSAL`, `EXTERNAL-POINTER-2WORD-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
