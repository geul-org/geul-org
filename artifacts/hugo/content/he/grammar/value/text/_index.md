---
title: "Value — טקסט"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "פורמטים של משפחת TEXT (Codec `0x40`~`0x5F`, מספרי פורמט `0x8000`~`0xBFFF`): טקסט UTF-8, טקסט עם שפה, URI וקודי שפה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

משפחת TEXT היא פורמטים של טקסט ומזהים מחרוזתיים. היא מוצבת בקודים ישירים `0x40`~`0x5F` ובמספרי פורמט Issuer `0x8000`~`0xBFFF`.

- מחרוזת בלי שפה היא UTF8-TEXT, וטקסט עם שפה כמו שם, כותרת ומשפט הוא UTF8-LANGUAGE-TEXT.
- גם קודי שפה (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) שייכים למשפחת TEXT.
- רצף בייטים באורך משתנה מוצב בזוג Codec זוגי-אי-זוגי. אם הביט התחתון ביותר הוא `1`, מספר הבייטים אי-זוגי והבייט התחתון של ה-WORD האחרון הוא ריפוד `0x00` ([רשומות ו-TAG WORD](/he/grammar/record/)).
