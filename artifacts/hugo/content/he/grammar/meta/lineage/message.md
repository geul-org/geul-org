---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE היא Meta של שושלת שרושמת את סיבת השינוי כטקסט עם שפה (git commit message)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את סיבת השינוי (git commit message).

## פריסה

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length extension TAG]
הודעה             Value אחד מסוג UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x38`, מחלקת שושלת (`011`)
- Payload: Value מוטמע ([UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/))
- מספר: לכל היותר אחד לכל שפה

## פירוש ותקינות

- ההודעה והשפה נשמרות יחד ב-UTF8-LANGUAGE-TEXT אחד. יש MESSAGE אחד לאותה שפה.
- מסמך המפרט של geul.org כותב אותו ב-[CODEC](/he/grammar/edge/codec/) `084A`·`084B`.
