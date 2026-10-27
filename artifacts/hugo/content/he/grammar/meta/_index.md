---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta היא רשומה על המסמך ולא על העולם. היא מתחלקת לשבע מחלקות: מבנה, הצהרה, מוצא, שושלת, אימות, מדיניות ו-IMPORT, וממוקמת ב-HEAD של המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta היא רשומה על המסמך ולא תוכן על העולם. חוץ מרשומות מבנה המסמך (DOC·BODY·END), כולן ממוקמות ב-HEAD של המסמך. ב-HEAD מופיעה, מלבד Meta, גם Edge הראיה של המסמך כולו [SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) וה-QUALIFIER שלה.

## פריסה

```
TAG WORD          0001 1LLL LCCC CCCC
[Length extension TAG]
Payload           ערך גולמי או רשומות Value·Reference מוטמעות
```

- ל-Meta אין פורמט Issuer. Meta הוא מפרט משותף שכל ה-Issuer מציתים לו, ו-GEUL לבדה מגדירה אותו.
- `LLLL` הוא מספר ה-WORD הכולל, כולל TAG WORD, פחות 1. Codec שאינו בטבלה שמור.

## פורמט Payload

| פורמט | מתי | דוגמה |
|---|---|---|
| ערך גולמי | כשהפורמט נקבע באופן יחיד. אינו נשען על Codec של רשומה אחרת | אורך `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value מוטמע | כשבוחרים בין כמה פורמטים. ה-TAG של ה-Value מציין את הפורמט | `PROFILE`, `EFFECTIVE-*`, זמן, hash תוכן |
| Reference מוטמע | כשמצביעים על יעד כמו אדם, ארגון, כלי או מסמך | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, החותם ב-`SIGNATURE` |
| אין | סמן של WORD אחד | `BODY`, `END` |

- רשומה מוטמעת אינה רשומה עצמאית ושייכת ל-Meta שלה. כל אחת מוצאת את גבולותיה לפי ה-Length של עצמה, והמיקום שאליו מגיעים אחרי קריאת הרשומה האחרונה חייב להתלכד בדיוק עם סוף ה-Meta.
- אילו Meta אפשר להציב רק פעם אחת במסמך ואילו כמה פעמים נקבע ב"מספר" שבמסמך של כל Codec.

## מחלקות

שלושת הביטים העליונים של ה-Codec הם המחלקה.

| שלושת הביטים העליונים | מחלקה | קוד ישיר | נושא |
|---|---|---|---|
| `000` | מבנה | `0x00`~`0x0F` | גבולות המסמך ואורכו |
| `001` | הצהרה | `0x10`~`0x1F` | הצהרות פירוש |
| `010` | מוצא | `0x20`~`0x2F` | מי, מתי, איפה |
| `011` | שושלת | `0x30`~`0x3F` | ממה ואיך נוצר |
| `100` | אימות | `0x40`~`0x4F` | האם אפשר לסמוך עליו |
| `101` | מדיניות | `0x50`~`0x5F` | איך מטפלים בו |
| `110` | IMPORT | `0x60`~`0x6F` | מייבא מסמך חיצוני |
| `111` | שמור | `0x70`~`0x7F` | |

- **Meta הדרוש לפירוש**: מבנה, הצהרה ו-IMPORT. אם מוחקים אותם, אי אפשר לקרוא את הרשומות או שהפירוש משתנה. כל מפענח חייב לטפל בהם. ה-Codec האלה שייכים ל**codebook הליבה של GEUL**.
- **Meta שאינו משנה פירוש**: מוצא, שושלת, אימות ומדיניות. גם אם מוחקים אותם, התיאור נשאר כמות שהוא. רק חומר הגלם לשיקול אמון ולטיפול נעלם.
- ראיות נכתבות לא ב-Meta אלא ב-Edge הראיה [SOURCE](/he/grammar/edge/source/) וב-QUALIFIER. הראיה של רשומה בודדת נמצאת ב-BODY, והמקור של המסמך כולו ב-HEAD כ-SOURCE עם Target `0` ([מסמך](/he/grammar/document/#head-ו-body)).

## מבנה

מסמך מקבץ: [Meta — מבנה](/he/grammar/meta/structure/)

| Codec | שם | משמעות |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/he/grammar/meta/structure/doc/) | פותח מסמך ומציין את האורך הכולל |
| `0x0E` | [BODY](/he/grammar/meta/structure/body/) | מסיים את ה-HEAD ופותח את ה-BODY |
| `0x0F` | [END](/he/grammar/meta/structure/end/) | סוגר את המסמך |

הכללים המפורטים נמצאים ב[מסמך](/he/grammar/document/).

## הצהרה

מסמך מקבץ: [Meta — הצהרה](/he/grammar/meta/declaration/)

| Codec | שם | משמעות |
|---|---|---|
| `0x10` | [SPEC-VERSION](/he/grammar/meta/declaration/spec-version/) | גרסת המפרט שהמסמך מציית לה. מספר שלם אחד |
| `0x11` | [PROFILE](/he/grammar/meta/declaration/profile/) | פרופיל שחל |
| `0x12` | [DOC-ID](/he/grammar/meta/declaration/doc-id/) | מזהה המסמך הזה. DOC-POINTER (גרסה 0) שמצביע על המסמך עצמו |
| `0x13` | [EFFECTIVE-FROM](/he/grammar/meta/declaration/effective-from/) | יום כניסת הגרסה הזו לתוקף. אם אין, זמן הפרסום |
| `0x14` | [EFFECTIVE-UNTIL](/he/grammar/meta/declaration/effective-until/) | סוף תקופת התוקף של הגרסה הזו (חוק זמני). אם אין, עד שתיכנס לתוקף הגרסה הבאה |
| `0x16` | [DEFAULT-LANGUAGE](/he/grammar/meta/declaration/default-language/) | שפת ברירת מחדל |

- השם של מסמך לצורך כתובת אינו מוצב כ-Meta. אינדקס השמות של ה-Issuer `documents.geul` מצמיד אותו ב-BIND ([כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שם-המסמך)). הכותרת שבני אדם קוראים מצורפת כ-LABEL ב-BODY.

## מוצא

מסמך מקבץ: [Meta — מוצא](/he/grammar/meta/provenance/)

| Codec | שם | משמעות |
|---|---|---|
| `0x20` | [AUTHOR](/he/grammar/meta/provenance/author/) | כותב (Reference) |
| `0x21` | [CO-AUTHOR](/he/grammar/meta/provenance/co-author/) | כותב שותף |
| `0x22` | [CREATED-AT](/he/grammar/meta/provenance/created-at/) | זמן כתיבה |
| `0x23` | [MODIFIED-AT](/he/grammar/meta/provenance/modified-at/) | זמן שינוי |
| `0x24` | [RECORDED-BY](/he/grammar/meta/provenance/recorded-by/) | הגורם שתיעד |
| `0x25` | [RECORDED-AT](/he/grammar/meta/provenance/recorded-at/) | זמן התיעוד |
| `0x26`~`0x2F` | Reserved | |

- חומר המקור אינו נכתב ב-Meta אלא ב-Edge הראיה [SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) (Target `0`) שב-HEAD, והטווח בטקסט המקורי, זמן ההשגה וה-hash של הטקסט המקורי נכתבים כ-QUALIFIER שמצורף ל-SOURCE הזה.

## שושלת

מסמך מקבץ: [Meta — שושלת](/he/grammar/meta/lineage/)

השושלת עוקבת אחרי מודל ה-commit של git. היחידה שמקבילה ל-commit היא המסמך.

| Codec | שם | משמעות |
|---|---|---|
| `0x30` | [PARENT](/he/grammar/meta/lineage/parent/) | hash התוכן של הגרסה הקודמת הישירה. אם יש כמה, זהו מיזוג |
| `0x31` | [DERIVED-FROM](/he/grammar/meta/lineage/derived-from/) | נגזר מחומר של שושלת אחרת |
| `0x32` | [GENERATED-BY](/he/grammar/meta/lineage/generated-by/) | הגורם שיצר (אדם, מודל, מנוע כללים) |
| `0x33` | [TRANSFORMED-BY](/he/grammar/meta/lineage/transformed-by/) | כלי ההמרה וגרסת המקור שלו (digest של commit) |
| `0x34` | [CHERRY-PICKED-FROM](/he/grammar/meta/lineage/cherry-picked-from/) | הגרסה המקורית של השינוי שנלקח |
| `0x35` | [REVERTS](/he/grammar/meta/lineage/reverts/) | הגרסה שהשינוי שלה בוטל |
| `0x36` | [REPLACES](/he/grammar/meta/lineage/replaces/) | הגרסה שנכתבה מחדש. הגרסה המקורית אינה נמחקת |
| `0x37` | [SQUASHED-FROM](/he/grammar/meta/lineage/squashed-from/) | הגרסאות המקוריות שאוחדו לאחת |
| `0x38` | [MESSAGE](/he/grammar/meta/lineage/message/) | סיבת השינוי. אחת לכל שפה |
| `0x39` | [TAG](/he/grammar/meta/lineage/tag/) | שם בלתי משתנה שניתן לגרסה |
| `0x3A` | [DELTA-BASE](/he/grammar/meta/lineage/delta-base/) | הקובץ הזה הוא diff ביחס לגרסת בסיס |
| `0x3B` | [DELTA-REMOVE](/he/grammar/meta/lineage/delta-remove/) | רשימת LOCAL ID להסרה ב-diff |
| `0x3C` | [NEXT-LOCAL-ID](/he/grammar/meta/lineage/next-local-id/) | ה-LOCAL ID הבא להקצאה. ממוקם במסמך רשימת הגרסאות |

- ההיסטוריה לא נמחקת. תיקון יוצא כגרסה חדשה.
- מצביע משתנה כמו branch אינו ממוקם במסמך. המאגר והאינדקס מנהלים אותו.

## אימות

מסמך מקבץ: [Meta — אימות](/he/grammar/meta/verification/)

| Codec | שם | משמעות |
|---|---|---|
| `0x40` | [ISSUER-KEY](/he/grammar/meta/verification/issuer-key/) | אלגוריתם החתימה והמפתח הציבורי של Issuer בהנפקה עצמית |
| `0x41` | [SIGNATURE](/he/grammar/meta/verification/signature/) | חתימה על hash התוכן. אלגוריתם, חותם, חתימה |
| `0x42` | [SIGNED-OFF](/he/grammar/meta/verification/signed-off/) | אישור זכות התרומה |
| `0x43` | [CONFIDENCE](/he/grammar/meta/verification/confidence/) | מידת אמון |
| `0x44` | [VERDICT](/he/grammar/meta/verification/verdict/) | תוצאת ההכרעה של המסמך כולו (Pass, Review, Fail) |

- מחלקת האימות מוצאת מחישוב hash התוכן. לכן גם כשהחתימה בתוך המסמך, וגם כשמוסיפים כמה חתימות, hash התוכן אינו משתנה.

## מדיניות

מסמך מקבץ: [Meta — מדיניות](/he/grammar/meta/policy/)

| Codec | שם | משמעות |
|---|---|---|
| `0x50` | [LICENSE](/he/grammar/meta/policy/license/) | רישיון |
| `0x51` | [ACCESS](/he/grammar/meta/policy/access/) | היקף חשיפה |
| `0x52` | [PRIVACY](/he/grammar/meta/policy/privacy/) | דרגת מידע אישי |
| `0x53` | [RETENTION](/he/grammar/meta/policy/retention/) | תקופת שמירה |
| `0x54` | [CONSENT](/he/grammar/meta/policy/consent/) | היקף ההסכמה ובסיסה |
| `0x55` | [USAGE](/he/grammar/meta/policy/usage/) | מגבלות שימוש |

- מדיניות אינה משנה פירוש אלא קובעת איך מטפלים.

## IMPORT

מסמך מקבץ: [Meta — IMPORT](/he/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length extension TAG]
מסמך              רשומת DOC-POINTER (Issuer, מזהה מסמך, מזהה גרסה)
IMPORT ID         השאר. מספר שלם ברוחב הקצר ביותר
```

- משתמשים רק ב-[IMPORT-DOC](/he/grammar/meta/import/import-doc/) (`0x60`). IMPORT מייבא מסמכים בלבד. יעד בתוך המסמך המיובא מוצבע ב-BODY באמצעות `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- אם כותבים מזהה גרסה, הייבוא קשור למהדורה הזו, ואם `0`, למהדורה האחרונה בזמן הפירוש. מסמך שפורסם כותב גרסה.
- במסמך אחד לא מקצים את אותו IMPORT ID פעמיים.
- ה-HEAD של המסמך המיובא אינו מיובא. היעדים של אותו מסמך מפורשים לפי ההצהרות שלו.

דוגמה: ייבוא הגרסה האחרונה של מסמך של Issuer `0x0001` עם מזהה מסמך `0x0000000000000002`, עם IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
