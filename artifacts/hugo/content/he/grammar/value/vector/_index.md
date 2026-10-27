---
title: "Value — וקטור"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "וקטורים בפורמטי Issuer של משפחת NUMERIC (ADHOC ‏`0x05xx`, KHRONOS): וקטורים צפופים של מספרים שלמים וממשיים, נקודות דו-ממדיות ותלת-ממדיות, תיבה תוחמת ופיקסלים RGBA8·BGRA8."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

פורמטי וקטור הם פורמטי Issuer של משפחת NUMERIC. וקטורים צפופים של מספרים שלמים וממשיים, נקודות ותיבות תוחמות מוצבים ב-ADHOC (`0x0001`) במספרי פורמט `0x0500`~`0x050C`, ופורמטי פיקסל מוצבים תחת KHRONOS (`0x0041`).

- אלמנטים של וקטור צפוף נשמרים ברצף ב-big-endian.
- מכיוון שאלה פורמטי Issuer, ל-TAG הרחבת ה-Codec מצטרפים Issuer ומספר פורמט, 2 WORD.
