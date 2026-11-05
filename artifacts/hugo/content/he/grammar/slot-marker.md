---
title: "סמן מקום"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "סמן מקום (slot marker) הוא רשומה של 1 WORD הממלאת מקום של שדה ברשומה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

סמן מקום (slot marker) הוא רשומה של 1 WORD הממלאת מקום של שדה ברשומה. הוא אינו מצביע על דבר. אלה קודים שהוקצו לשלושת התאים הראשונים `0x000L~0x002L` בקטע 0 של Reference. לכל סמן יש דף: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

במקום של ערך אפשר לומר שלושה דברים. לא כתבו את הערך, יש ערך אך אינו ידוע מהו, אין ערך. השלושה שונים זה מזה. סמן מקום כותב את השלושה בשלושה WORD סמוכים.

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, קטע 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | שם | משמעות | סימון |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | לא נכתב | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | אינו ידוע: יש ערך. אינו ידוע מהו | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | אין: אין ערך | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | צורת TAG זו (סמן בעל Payload) לא הוקצתה | |

- **לסמן אין Quantifier.** כימות נקרא רק ממערך 5Q (בקטע 0 `5 <= C < 30`, בקטע 1 `C < 30`). אין לפרש את `0x0010` UNKNOWN-VALUE כ-Generic באמצעות `C % 5` ([Reference](reference/_index.md) Quantifier).
- אין Payload. גם אין ID יעד.
- מפענח ללא codebook יודע מה-TAG WORD בלבד שה-Kind הוא Reference ושהרשומה היא 1 WORD, ומדלג. ״אם ערך ה-WORD הוא `0x0000`, ‏`0x0010` או `0x0020` זה סמן מקום״ נקבע ב-`w & 0xF == 0 && w <= 0x0020`.
- הסימונים `ABSENT`·`UNKNOWN`·`NONE` הם סימון הטקסט של `geul show` ו-`geul add`.

## שלוש ההבחנות {#세-가지-구분}

| | לא נכתב (ABSENT) | אינו ידוע (UNKNOWN-VALUE) | אין (NO-VALUE) |
|---|---|---|---|
| על מה האמירה | **המסמך**: המקום הזה לא מולא | **העולם**: יש ערך. אינו ידוע מהו | **העולם**: אין ערך |
| לוגיקה | אינו טוען דבר | `∃x. P(s, x)`, ‏x אינו מזוהה | `¬∃x. P(s, x)` |
| הנחת עולם | עולם פתוח (אין מידע) | הקיום סגור, הזהות פתוחה | עולם סגור ביחס ל-(s, P, תנאי מסייג) |
| Wikidata | אין snak כזה | `somevalue` | `novalue` |
| היכן משתמשים | שדה אופציונלי שיש לו יעד CODEC ‏`0000` (SOURCE Origin וכדומה) | שדה שיש לו יעד CODEC ‏`0010` (TRIPLE Object, ‏QUALIFIER Value, ‏SOURCE Origin) | שדה שיש לו יעד CODEC ‏`0020` (TRIPLE Object, ‏QUALIFIER Value) |
| ״כמה ילדים (P40)״ | אין יודעים | אחד או יותר | 0 |
| ״האם יש זמן סיום (P582)״ | אין יודעים ← אין יודעים אם עדיין תקף | הסתיים. אין יודעים מתי | לא הסתיים (טענה) |

אותה הבחנה קיימת גם ברמת הפסוק. **TRIPLE שאינו במסמך** הוא ״לא נכתב״. מסמך GEUL הוא עולם פתוח, ולכן העובדה שאין תיאור אינה אומרת שאין עובדה. ״אין״ אפשר לומר רק אם **כותבים** NO-VALUE.

## כלל קבלה {#수용-규칙}

- סמן מקום תקף **רק אם אותו WORD מופיע כיעד מדויק** ברשימת [CODEC](edge/0x0BEL-codec.md) של השדה. יעד `0000` פירושו ״שדה אופציונלי״, ‏`0010` ״מקבל אינו ידוע״, ‏`0020` ״מקבל אין״.
- תו כללי (`000F`, ‏`060F` וכדומה, ‏`L=1111`) אינו מקבל סמן. גם כל Reference (`000F`·`020F`·`040F`) אינו חופף לסמן.
- גם שדה רשומה שאין לו CODEC (״כל רשומה״) אינו מקבל סמן.
- סמן במקום של רשומת HEAD·BODY ובמקום של Edge Id הוא invalid.
- בשדה ערך גולמי אי אפשר להשתמש בסמן. לערך גולמי אין TAG ולכן אין מקום לסמן של 1 WORD.
- רשימת CODEC שיש בה רק יעדי סמן (תמיד סמן) היא invalid.
- משמעות הסמן (מה יש ומה אין) נקבעת במפרט ה-Edge המקבל אותו. זה אותו עיקרון שלפיו כימות ושלילה נקבעים ב-Edge ולא ב-Reference.
- משמעות הסמן וכלל הקבלה שייכים ל[שכבה 0](publishing.md#층) (מובנים במפענח). לשלושתם אין Payload ולכן אין עלות הטמעה. עם זאת, לכל קוד יש מסמך Codec. במסמך ה-Codec יש DECLARE בלבד וללא FIELD.

## חובות הצד הקורא {#읽는-쪽의-의무}

הן נרשמות בדף של כל סמן. עיקרן:

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) אינו ערך אלא טענת קיום. הוא אינו שווה ואינו שונה מאף ערך, וה-TRIPLE שלו אינו ממוזג ככפילות.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) סגור בתוך התנאי המסייג של אותו פסוק.
- בשני הסמנים rank חל באותו אופן, וכשהם משמשים כערך QUALIFIER הם משנים את משמעות המסייג.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) אינו אומר דבר על העולם. אין משתמשים ב-UNKNOWN-VALUE עבור ערך שלא הצליחו להעביר.

## ההבדל מ״אין״ אחרים {#다른-없음과의-차이}

- כלל Codec שמשתמש ב-[LOCAL](reference/0x005L-local.md) ‏`0` כ״אין״ ([TOULMIN](toulmin/_index.md) REF וכדומה) הוא הסכמה בתוך אותו Codec. הוא שונה מסמן מקום.
- אין משתמשים ב-Identified LOCAL כ-null או כ-sentinel. כדי לרשום ״לא ידוע״ או ״חסר״, כותבים סמן בשדה שמקבל סמנים.

## דוגמה {#예시}

הגבול בין Q30 (ארצות הברית) ל-Q34266 (האימפריה הרוסית), זמן הסיום אינו ידוע. ה-Edge Id נועד להסבר.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

הבנק המרכזי של Q30, לא היה קיים בשנים 1811~1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- מקום הסמן הוא 1 WORD. ‏TRIPLE הוא 9 WORD (`0AA8`) ו-QUALIFIER הוא 8 WORD (`0AB7`).
- בצורה פשוטה, ״אין ילדים (P40)״ הוא `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## דפים קשורים {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [מסמך מפרט Codec](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
