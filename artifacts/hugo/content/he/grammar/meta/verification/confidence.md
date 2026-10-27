---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE היא Meta של אימות שרושמת את מידת האמון במסמך כולו כ-Value עשרוני מ-0 עד 1."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את מידת האמון במסמך כולו. מידת אמון ברמת רשומה נכתבת כ-QUALIFIER שמצורף ל-Edge היעד (המאפיין טרם נקבע, [SOURCE](/he/grammar/edge/source/#ייצוג-של-ראיות-אחרות)).

## פריסה

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length extension TAG]
Payload           Value מסוג UNSIGNED-DECIMAL, מ-0 עד 1
```

- Codec: Meta `0x43`, מחלקת אימות (`100`)
- Payload: Value מוטמע ([UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- מי נתן את הערך נרשם יחד, למשל ב-[GENERATED-BY](/he/grammar/meta/lineage/generated-by/).

## שאלות פתוחות

- הסקאלה (0~1) והקשר להכרעה של TOULMIN.
