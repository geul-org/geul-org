---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS היא Edge תיאורית שמקשרת שם נוסף (כינוי) אחד ליעד ה-Subject (Codec 0x05). הפריסה זהה ל-LABEL."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS היא Edge תיאורית שמקשרת שם נוסף (כינוי) אחד של יעד ה-Subject בתור Object. Codec `0x05`.

[LABEL](/he/grammar/edge/label/) הוא השם המייצג בשפה (לכל היותר אחד בכל שפה), ו-ALIAS הוא שם נוסף של אותו יעד (כמה בכל שפה, כמו "also known as" ב-Wikidata). משמש בעיקר לחיפוש. הפריסה והתקינות זהות ל-LABEL.

## פריסה

```
TAG WORD          0001 0LLL L000 0101
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Subject           רשומת Reference אחת
Object            Value מסוג UTF8-LANGUAGE-TEXT או רשומת LOCAL Reference אחת
```

## פירוש ותקינות

- הכללים של Subject ו-Object זהים ל-[LABEL](/he/grammar/edge/label/) (ה-Object הוא [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/) או LOCAL שנפתר אליו).
- אפשר להציב כמה ALIAS לאותם Subject ושפה. הסדר הוא הסדר במסמך.
- לא מציבים כ-ALIAS טקסט זהה ל-LABEL של אותם Subject ושפה (LABEL אחת מספיקה לשם המייצג). כלל זה הוא המלצה.
- מסמך המפרט של geul.org מגביל את ה-Object ל-[CODEC](/he/grammar/edge/codec/) (`084A`, `084B`, `0008`, כמו ב-LABEL).

## דוגמה (לא נורמטיבית)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): רשומת שפה `08C6 656e` (BCP47 `en`) + טקסט של 3 בייטים (אי-זוגי) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. ה-TAG הוא `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## דפים קשורים

- [Edge](/he/grammar/edge/), [LABEL](/he/grammar/edge/label/), [DESCRIPTION](/he/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/)
