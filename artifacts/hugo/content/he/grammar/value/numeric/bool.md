---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL הוא Value ברוחב קבוע של 2 WORD שמכיל את הערכים הלוגיים false ו-true."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL הוא Value שמייצג את הערכים הלוגיים false ו-true. הוא Value עם קוד ישיר `0x00`, משפחה NUMERIC. הוא טיפוס שונה מ-SIGNED-INTEGER ומ-UNSIGNED-INTEGER, שמכילים את המספרים 0 ו-1.

## פריסה

```
TAG WORD          0x0880 (0000 1000 1000 0000)  סך הכול 2 WORD
Payload           WORD אחד  Boolean Code
```

## פירוש ותקינות

- Payload `0000` הוא false, ו-`0001` הוא true.
- אין padding ואין descriptor.
- ה-Payload הוא בדיוק `0000` או `0001`. כל ערך אחר של 16 ביט נדחה כ-invalid.
- כל ייצוג אחר של Length נדחה כ-invalid.

## אורך

- הסך הכול הוא בדיוק 2 WORD: TAG אחד ו-Payload אחד, עם אורך ישיר `LLLL=0001`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק WORD אחד, דוחים.

## דוגמה

| רשומה שלמה (TAG + Payload) | Payload | פסק דין |
|---|---|---|
| `0880 0000` | `0000` | false, קנוני |
| `0880 0001` | `0001` | true, קנוני |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG ש-Length שלו אינו `0001` + `0000` או `0001` | `0000` או `0001` | invalid |

## מעמד הפורמט

- הייצוג הזה, שמצמיד word של קוד בן 16 ביט `0000`/`0001` ל-TAG של GEUL, הוא scalar profile ייחודי של GEUL.
- הערך הלוגי עצמו אוניברסלי, אך לא נטען שיש תקן תעשייתי יחיד שמתאים לייצוג הזה של WORD אחד.
