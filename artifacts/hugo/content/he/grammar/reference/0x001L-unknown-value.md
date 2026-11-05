---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE הוא סמן מקום המציין «לא ידוע»."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE הוא [סמן מקום](../slot-marker.md) המציין «לא ידוע». זו הצהרה על העולם: יש ערך, אך איננו יודעים מהו.

| פריט | ערך |
|---|---|
| שם | `UNKNOWN-VALUE` (מסמך מפרט BIND `UNKNOWN-VALUE`) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| מסמך מפרט | `0x00000000/codecs/0x00000010/` (יעד DECLARE `0010`) |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 1 |
| Kind | Reference · סיווג: סמן מקום |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | לא ידוע. יש ערך אך לא ידוע מהו (`somevalue` של Wikidata) |
| צד Hugo | `reference/slot-marker.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- אין Payload. אין ID יעד ואין Quantifier ([סמן מקום](../slot-marker.md#레이아웃)).
- ב-`0x001L` צורה עם Payload (L ≥ 1) היא Reserved.
- הייצוג הטקסטי של `geul show` ו-`geul add`: `UNKNOWN`.

## משמעות {#뜻}

| פריט | לא ידוע |
|---|---|
| על מה נאמר הדבר | **העולם**: יש ערך. לא ידוע מהו |
| לוגיקה | `∃x. P(s, x)`, x אינו מזוהה |
| הנחת עולם | הקיום סגור, הזהות פתוחה |
| Wikidata | `somevalue` |

## קבלה {#수용}

- רק שדה שיש לו יעד CODEC `0010` מקבל אותו. שדה זה מקבל את ההצהרה «לא ידוע». דוגמאות: Object של [TRIPLE](../edge/0x0AAL-triple.md), Value של [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin של [SOURCE](../edge/0x0C0L-source.md).
- אי אפשר להשתמש בו בתו כללי (wildcard), בשדה ללא CODEC, במקום של רשומת HEAD או BODY, במקום של Edge Id או בשדה של ערך גולמי (הכלל המשותף של [סמן מקום](../slot-marker.md#수용-규칙)).

## חובת הקורא {#읽는-쪽의-의무}

- **UNKNOWN-VALUE אינו ערך אלא הצהרת קיום.** הוא אינו שווה לשום ערך אחר ואינו שונה מהם (תוצאת ההשוואה בלתי מוכרעת). גם שני UNKNOWN-VALUE אינם נחשבים לאותו ערך. בכל הופעה זה כימות קיומי בלתי תלוי (כמו צומת ריק ב-Wikidata).
- לכן שני TRIPLE זהים בבתים (`P40 Q… UNKNOWN` ×2) אינם כפילות. ייתכנו שני ילדים וייתכן ילד אחד. TRIPLE שמכיל UNKNOWN-VALUE אינו ממוזג ככפילות.
- כשהזהות מתבררת מאוחר יותר, מפרסמים גרסה חדשה של אותו TRIPLE בתיקון. אי אפשר להצביע על UNKNOWN-VALUE. כשנדרשת הפניה משותפת, משתמשים ב-LOCAL Variable ([Reference](_index.md#quantifier) Variable).
- **rank חל באותו אופן.** בבחירת הערך המייצג (truthy), גם TRIPLE של UNKNOWN-VALUE הוא מועמד.
- **כשהוא משמש ערך של QUALIFIER, הוא משנה את משמעות הסייג.** `P582 = UNKNOWN` פירושו שזה הסתיים ושמועד הסיום אינו ידוע. אין לקרוא זאת כטענה שעדיין תקפה.
- UNKNOWN-VALUE הוא הצהרה ש«יש», ולכן משתמשים בו רק כשהמקור אומר כך. ערך שלא הועבר אינו נכתב כ-UNKNOWN-VALUE.

## דוגמה {#예시}

`0x0010` ב-WORD אחד. לדוגמה: מועד הסיום (P582) של הגבול Q30–Q34266 אינו ידוע: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, מקום Value הוא `0010`).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec כולל רק DECLARE אחד (יעד `0010`). בלי Payload אין FIELD. המפענח מכיל מובנית את משמעות הסמן וכללי הקבלה ([שכבה 0](../publishing.md#층)). כדי לקרוא את הסמן אין צורך לעיין במסמך Codec.

## דפים קשורים {#관련-페이지}

- [סמן מקום](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [מסמך מפרט של Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000010/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
