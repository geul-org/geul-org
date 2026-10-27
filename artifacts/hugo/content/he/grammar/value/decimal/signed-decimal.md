---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL הוא Value שמכיל מספר עשרוני מדויק C×10^E באמצעות מעריך E חתום של 32 ביט ומקדם C בשיטת המשלים ל-2 במינימום WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL הוא Value של מספר עשרוני מדויק (exact decimal) בעל coefficient חתום. הוא Value עם קוד ישיר `0x10`, משפחה DECIMAL. שני ה-Payload WORD הראשונים הם exponent עשרוני `E` חתום של 32 ביט, והשאר הוא coefficient `C` בשיטת המשלים ל-2 במינימום WORD, והערך הוא `C×10^E`.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[TAG הרחבת Length] כשהכול 15 WORD ומעלה
Payload WORD 1st–2nd (32 ביט)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD ומעלה)  Signed Two's-complement Coefficient C
```

## פרשנות

- `E` הוא מספר שלם חתום של 32 ביט בשיטת המשלים ל-2 ב-big-endian, הכתוב מה-WORD העליון.
- `C` הוא מספר שלם בשיטת המשלים ל-2 בדיוק שרירותי, שמתקבל משרשור כל שאר ה-WORD מה-WORD העליון.
- `C` כפוף לאותו כלל מינימום WORD כמו [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/). WORD מוביל `0000` או `ffff` שאפשר למחוק אסור.

## אורך ותקינות

- האורך הכולל הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- ה-Payload מורכב מ-2 WORD של exponent ומ-WORD אחד לפחות של coefficient, ולכן המינימום הוא 3 WORD.
- נורמליות הייצוג הבייטי נבדקת רק לפי הייצוג במינימום WORD של ה-coefficient.

## דוגמה

| ייצוג הערך | Payload (`E` + `C`) | פסק דין |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | הייצוג הבייטי תקין |
| `10×10^-1` | `ffff ffff 000a` | הייצוג הבייטי תקין, ויחס ה-canonical לייצוג שלמעלה הוא שאלה פתוחה |
| `1×10^0` | `0000 0000 0000 0001` | לא תקין: ה-`0000` המוביל ב-coefficient מיותר |
| Payload של 7 WORD | אורך ישיר `LLLL=0111`, 8 WORD בסך הכול | מבנה אורך תקין |

## מעמד הפורמט

- הפריסה הזו, שמצמידה exponent `E` חתום של 32 ביט ל-coefficient `C` במינימום WORD, היא פורמט ייחודי של GEUL ואינה IEEE 754 decimal interchange או `DECIMAL` של Apache Parquet.
- `DECIMAL` של Parquet משתמש ב-`unscaledValue × 10^(-scale)` וב-metadata חובה של precision/scale, שומר את ה-unscaled value של טיפוס פיזי byte-array כמשלים ל-2 ב-big-endian, וה-scale שלו אינו שלילי. הפורמט הזה מכניס `E` חתום לגוף הרשומה ואין בו precision metadata, ולכן אינו אותו פורמט.
- כדי להחליף נתונים עם IEEE 754 decimal או עם `DECIMAL` של Parquet נדרשת המרה מפורשת שקובעת מדיניות לטווח, precision/scale, quantum וערכים מיוחדים.
- בסיס להשוואה: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## שאלות פתוחות

- יש כמה זוגות exponent/coefficient שמייצגים את אותו מספר, כמו `10×10^-1` ו-`1×10^0`.
- עדיין לא נקבע אם הפורמט הזה שומר quantum, איך קובעים שוויון ערכים, ואיך מנרמלים ל-canonical exponent.
- לכן מימוש אינו רשאי לכפות באופן שרירותי נרמול של exponent/coefficient מעבר לכלל מינימום ה-WORD של ה-coefficient.
