---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY היא Meta של שושלת שרושמת את הכלי שהמיר ייצוג אחר למסמך הזה ואת גרסת המקור שלו (digest של commit)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת באיזו שיטה הומר ייצוג אחר למסמך הזה (למשל ממיר Wikidata, מקודד שפה טבעית). ה-Tool הוא במה בוצעה ההמרה, וה-Version הוא באיזה מקור של הכלי. רק עם שניהם אפשר ליצור מחדש את אותו מסמך מאותו קלט.

## פריסה

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length extension TAG]
Tool              רשומת Reference אחת (כלי או כלל המרה)
Version           רשומת Value אחת (SHA-256-DIGEST או SHA1-DIGEST)
```

- Codec: Meta `0x33`, מחלקת שושלת (`011`)
- Payload: Reference מוטמע (כלי) + Value מוטמע (digest של גרסת המקור)
- מספר: אפשר כמה (אחד לכל כלי)

## פירוש ותקינות

- Tool הוא רשומת Reference שלמה אחת בדיוק. אפשר להשתמש בכל Reference שמצביע על כלי.
  - כלי ממסמך כלי של geul.org: [EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/) (`0x0000`, מזהה מסמך `0x0001xxxx xxxxxxxx`, ה-LOCAL שלו). מסמך אחד לכל כלי ([Issuer](/he/grammar/issuer/), מסמך הגדרת מונחים).
  - אם ה-codec הוא מסמך GEUL, מצביעים על המסמך הזה באמצעות [DOC-POINTER](/he/grammar/reference/doc-pointer/).
- Version הוא רשומת Value שלמה אחת בדיוק, והוא מזהה האובייקט במערכת ניהול הגרסאות של מקור ה-Tool. ב-git זהו מזהה אובייקט ה-commit המלא.
  - אם פורמט האובייקטים של מאגר ה-git הוא SHA-256, זהו [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD), ואם SHA-1, [SHA1-DIGEST](/he/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). את פורמט המאגר בודקים ב-`git rev-parse --show-object-format`.
  - לא משתמשים במזהה מקוצר (`2bd496f` וכד'). Value מסוג digest אינו מתיר ערך חתוך.
  - לא כותבים כטקסט hex (UTF8-TEXT). אותו ערך הוא 22 WORD ב-SHA-1 (11 בבינארי) ו-34 WORD ב-SHA-256 (18 בבינארי).
- Version הוא חובה. רישום כלי שגרסת המקור שלו לא ידועה אינו בסיס לשחזור. אם הכלי מחוץ לניהול גרסאות, משתמשים ב-SHA-256 של החבילה המופצת (SHA-256-DIGEST).
- Version מצביע על מקור שנעשה לו commit. במסמך שנוצר מעץ עבודה שיש בו שינויים שלא נעשה להם commit, לא כותבים את מזהה ה-commit הזה (מומלץ שהכלי יסרב לרוץ).
- אם הכלי נשען על קוד מחוץ למאגר (למשל ספרייה מקומית שמוצבעת ב-`replace` של Go), רושמים גם את הקוד הזה בנפרד ב-TRANSFORMED-BY. מזהה ה-commit של הכלי לבדו אינו קובע את הקוד הזה.
- כלי שרק מעביר את המקור ללא אובדן (למשל כלי שטוען dump כמות שהוא ל-DB) אינו קובע את תוכן המסמך, ולכן לא רושמים אותו. טעינה עם אובדן משנה את המסמך, ולכן רושמים אותה ככלי.
- מסמך המפרט של geul.org (`0x1833`) כותב אותו כשני שדות רשומה: Tool (רוחב 0, כל Reference ולכן בלי CODEC) ו-Version (רוחב 0, [CODEC](/he/grammar/edge/codec/) `0861`·`0862`).

## אורך

```
סך הכול = 1 + N_len + N_tool + N_version WORD
```

- הסמן אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Meta.
- אם ה-Tool הוא EXTERNAL-ISSUER-1WORD (7 WORD) וה-Version הוא SHA1-DIGEST (11 WORD), סך הכול 1 + 1 + 7 + 11 = 20 WORD ומשתמשים באורך מורחב. עם SHA-256-DIGEST (18 WORD) זה 27 WORD.

## דוגמה

דוגמה לא נורמטיבית. הכלי הוא LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) של מסמך הכלי `0x0001000000000001` של geul.org, והמקור הוא ה-commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## שאלות פתוחות

- האם גם הגרסה ב-[GENERATED-BY](/he/grammar/meta/lineage/generated-by/) צריכה להיות באותה שיטה (digest חובה או פורמט אחר). גרסת מודל אינה מזהה commit.

## דפים קשורים

- [Meta](/he/grammar/meta/), [GENERATED-BY](/he/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/he/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [DOC-POINTER](/he/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/he/grammar/value/binary/sha1-digest/), [CODEC](/he/grammar/edge/codec/)
