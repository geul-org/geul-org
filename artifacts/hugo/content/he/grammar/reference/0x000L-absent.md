---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT הוא סמן מקום המציין «לא נרשם»."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT הוא [סמן מקום](../slot-marker.md) המציין «לא נרשם». הוא אומר על המסמך שמקום זה לא מולא, ואינו מצהיר דבר על העולם.

| פריט | ערך |
|---|---|
| שם | `ABSENT` (מסמך מפרט BIND `ABSENT`) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| מסמך מפרט | `0x00000000/codecs/0x00000000/` (יעד DECLARE `0000`) |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 0 |
| Kind | Reference · סיווג: סמן מקום |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | לא נרשם. שדה אופציונלי הושמט. אינו מצהיר דבר על העולם |
| צד Hugo | `reference/slot-marker.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- אין Payload. אין ID יעד ואין Quantifier ([סמן מקום](../slot-marker.md#레이아웃)).
- ב-`0x000L` צורה עם Payload (L ≥ 1) היא Reserved.
- הייצוג הטקסטי של `geul show` ו-`geul add`: `ABSENT`.

## משמעות {#뜻}

| פריט | לא נרשם |
|---|---|
| על מה נאמר הדבר | **המסמך**: מקום זה לא מולא |
| לוגיקה | אינו מצהיר דבר |
| הנחת עולם | עולם פתוח (אין מידע) |
| Wikidata | אין snak מתאים |

## קבלה {#수용}

- רק שדה שיש לו יעד CODEC `0000` מקבל אותו. שדה זה הוא **שדה אופציונלי**. כשמשמיטים שדה אופציונלי, כותבים במקומו WORD `0x0000` אחד. גם שדה אופציונלי תופס את מקומו תמיד ([מסמך מפרט של Codec](../codec-spec.md#선택-필드와-자리-표지)). דוגמאות: Origin של [SOURCE](../edge/0x0C0L-source.md), היחידה, הגבול התחתון והגבול העליון של [QUANTITY](../value/0x066L-quantity.md).
- אי אפשר להשתמש בו בתו כללי (wildcard), בשדה ללא CODEC, במקום של רשומת HEAD או BODY, במקום של Edge Id או בשדה של ערך גולמי (הכלל המשותף של [סמן מקום](../slot-marker.md#수용-규칙)).

## חובת הקורא {#읽는-쪽의-의무}

- **ABSENT אינו אומר דבר על העולם.** אין לקרוא אותו כ-UNKNOWN-VALUE או כ-NO-VALUE.
- אסור לכתוב כ-UNKNOWN-VALUE ערך שהממיר לא הצליח להעביר (ערך שקיים במקור), משום שבמקור הערך ידוע. גם מקום שהמקור לא אמר עליו דבר (למשל Origin של [SOURCE](../edge/0x0C0L-source.md) עבור מקור שלא תואר) הממיר כותב כ-ABSENT.
- בגרף פסק הדין, ABSENT והיעדר היגד הם בלתי מוכרעים (U) בכל אופרטור השוואה. כדי לקרוא ABSENT כ-empty, צד הקלט צריך להצהיר על עולם סגור ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## דוגמה {#예시}

`0x0000` ב-WORD אחד. לדוגמה: מקום היחידה ב-QUANTITY שבו לא נרשמה יחידה.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec כולל רק DECLARE אחד (יעד `0000`). בלי Payload אין FIELD. המפענח מכיל מובנית את משמעות הסמן וכללי הקבלה ([שכבה 0](../publishing.md#층)). כדי לקרוא את הסמן אין צורך לעיין במסמך Codec.

## דפים קשורים {#관련-페이지}

- [סמן מקום](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [מסמך מפרט של Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000000/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
