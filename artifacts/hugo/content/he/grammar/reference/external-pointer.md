---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER הוא Reference מסוג הצבעה שמצביע על LOCAL ID של מסמך שיובא ב-IMPORT-DOC שב-HEAD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER הוא Reference מסוג הצבעה שמצביע על LOCAL ID של מסמך שיובא ב-[IMPORT-DOC](/he/grammar/meta/import/import-doc/) שב-HEAD.

## פריסה

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length extension TAG]
IMPORT ID         הרוחב ש-WW קובע (00=1, 01=2, 10=4, 11=8 WORD)
ID של היעד        כל השאר. ה-LOCAL ID של המסמך המיובא, ברוחב הקצר ביותר
```

| CCCC | שם | רוחב IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- משתמשים ב-Codec הצר ביותר שערך ה-IMPORT ID נכנס בו.
- ה-IMPORT ID הוא ערך ש-`IMPORT-DOC` של המסמך הזה הקצה, והוא תקף רק בתוך המסמך הזה. ב-EXTERNAL-POINTER לא כותבים Issuer. ה-Issuer ומזהה המסמך נלקחים מאותו `IMPORT-DOC`. גם הגרסה נקבעת על ידי אותו `IMPORT-DOC` (נעולה או אחרונה).
- אותו LOCAL ID של המסמך המיובא הוא אותו יעד, בין אם משתמשים בו כ-LOCAL בתוך המסמך ובין אם כ-EXTERNAL-POINTER כאן.
- אם זה Variable, זהו משתנה LOCAL של המסמך המיובא.

## תקינות

- אם אין במסמך הזה `IMPORT-DOC` שהקצה את ה-IMPORT ID, זה invalid.
- אם ה-IMPORT ID נכנס ב-Codec צר יותר ומשתמשים ב-Codec רחב, דוחים כלא-מינימלי.
- אם ה-ID של היעד הוא `0`, זה invalid. המסמך המיובא עצמו מוצבע באמצעות [DOC-POINTER](/he/grammar/reference/doc-pointer/).
- WORD מוביל של `0x0000` ב-ID של היעד אסור.

## דוגמה

| יעד | WORD sequence |
|---|---|
| LOCAL 5 של IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 של IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 של IMPORT ID 70000 | `01C8 0001 1170 0005` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [LOCAL](/he/grammar/reference/local/), [EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [DOC-POINTER](/he/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/he/grammar/meta/import/import-doc/)
