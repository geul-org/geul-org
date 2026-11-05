---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE הוא סמן מקום המציין «אין»."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE הוא [סמן מקום](../slot-marker.md) המציין «אין». זו הצהרה על העולם: אין ערך.

| פריט | ערך |
|---|---|
| שם | `NO-VALUE` (מסמך מפרט BIND `NO-VALUE`) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| מסמך מפרט | `0x00000000/codecs/0x00000020/` (יעד DECLARE `0020`) |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 2 |
| Kind | Reference · סיווג: סמן מקום |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | אין. אין ערך (`novalue` של Wikidata) |
| צד Hugo | `reference/slot-marker.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- אין Payload. אין ID יעד ואין Quantifier ([סמן מקום](../slot-marker.md#레이아웃)).
- ב-`0x002L` צורה עם Payload (L ≥ 1) היא Reserved.
- הייצוג הטקסטי של `geul show` ו-`geul add`: `NONE`.

## משמעות {#뜻}

| פריט | אין |
|---|---|
| על מה נאמר הדבר | **העולם**: אין ערך |
| לוגיקה | `¬∃x. P(s, x)` |
| הנחת עולם | עולם סגור ביחס ל-(s, P, תנאי הסייג) |
| Wikidata | `novalue` |

## קבלה {#수용}

- רק שדה שיש לו יעד CODEC `0020` מקבל אותו. שדה זה מקבל את ההצהרה «אין». דוגמאות: Object של [TRIPLE](../edge/0x0AAL-triple.md), Value של [QUALIFIER](../edge/0x0ABL-qualifier.md).
- אי אפשר להשתמש בו בתו כללי (wildcard), בשדה ללא CODEC, במקום של רשומת HEAD או BODY, במקום של Edge Id או בשדה של ערך גולמי (הכלל המשותף של [סמן מקום](../slot-marker.md#수용-규칙)).

## חובת הקורא {#읽는-쪽의-의무}

- **NO-VALUE סגור בתוך תנאי הסייג של אותה טענה.** כשמצורף QUALIFIER, הוא סגור רק בטווח זה. Q30 P1304 NO-VALUE(P580 1811, P582 1816) פירושו שרק בשנים 1811–1816 לא היה בנק מרכזי, והוא אינו סותר את TRIPLE הערך של אותה תכונה (מערכת הפדרל ריזרב, preferred).
- אם NO-VALUE ו-TRIPLE של ערך נמצאים יחד באותו Subject ו-Predicate, באותו rank, ובלי שתנאי הסייג מבחינים ביניהם, זו סתירה. הבודק מפיק אזהרה. הוא אינו דוחה. זה מצב שקיים גם ב-Wikidata, והקורא בוחר לפי rank.
- **rank חל באותו אופן.** בבחירת הערך המייצג (truthy), גם TRIPLE של NO-VALUE הוא מועמד.
- **כשהוא משמש ערך של QUALIFIER, הוא משנה את משמעות הסייג.** `P582 = NONE` מצהיר שזה לא הסתיים. כשאין כלל QUALIFIER של P582, לא ידוע אם זה הסתיים.
- אפשר לומר «אין» **רק על ידי כתיבתו** כ-NO-VALUE. כשאין TRIPLE במסמך, זה «לא נרשם» (עולם פתוח).

## דוגמה {#예시}

`0x0020` ב-WORD אחד. לדוגמה: «אין ילדים» (P40) הוא `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, מקום Object הוא `0020`).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec כולל רק DECLARE אחד (יעד `0020`). בלי Payload אין FIELD. המפענח מכיל מובנית את משמעות הסמן וכללי הקבלה ([שכבה 0](../publishing.md#층)). כדי לקרוא את הסמן אין צורך לעיין במסמך Codec.

## דפים קשורים {#관련-페이지}

- [סמן מקום](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [מסמך מפרט של Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000020/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
