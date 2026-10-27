---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID היא Meta של שושלת שרושמת ברשימת הגרסאות את ה-LOCAL ID שהגרסה הבאה של המסמך תקצה לתיאור חדש (auto increment)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את ה-LOCAL ID שהגרסה הבאה של המסמך תקצה לתיאור חדש (auto increment ב-DBMS, `AUTO_INCREMENT` ב-MySQL). כל LOCAL ID שהוקצה בכל גרסה של המסמך קטן מהערך הזה.

## פריסה

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           ה-LOCAL ID הבא להקצאה, מספר שלם unsigned ברוחב הקצר ביותר
```

- Codec: Meta `0x3C`, מחלקת שושלת (`011`)
- Payload: ערך גולמי (מספר שלם unsigned ברוחב הקצר ביותר)
- מספר: לכל היותר אחד
- איפה מציבים: ב-HEAD של מסמך רשימת הגרסאות `versions.geul` ([PUBLICATION](/he/grammar/edge/publication/))

## פירוש ותקינות

- LOCAL ID (כולל Edge Id) הוא זהות שחוצה גרסאות ([תיקון](/he/grammar/document/#תיקון)). תיאור חדש מקבל את הערך הזה והערך גדל ב-1. LOCAL ID שנמחק לא משתמשים בו שוב. לכן גם כשהתיאור בעל הערך הגבוה ביותר נמחק, הערך הזה לא קטן.
- LOCAL ID `0` אינו מוקצה, ולכן הערך ההתחלתי הוא `1`. כל עוד אין גרסה, לא מציבים את ה-Meta הזה והמספר הבא הוא `1`.
- מקום הפרסום מעדכן אותו במסמך הרשימה החדש כשהוא מפרסם גרסה. הוא חייב להיות גדול מכל LOCAL ID שבשימוש בגרסה שפורסמה. אם קטן או שווה, זה invalid.
- הערך רק גדל. אם הוא קטן מהערך במסמך הרשימה הקודם הישיר ([PARENT](/he/grammar/meta/lineage/parent/)), זה invalid.
- אין אותו במסמך שאינו מנהל גרסאות (מסמך שאין לו `versions.geul`, מסמך ללא שם). במסמך כזה גם אין diff ([DELTA-BASE](/he/grammar/meta/lineage/delta-base/)).
- לא מציבים אותו בגוף המסמך (מסמך גרסה). זכירת המספר היא מצב של מקום הפרסום שממשיך לכתוב את המסמך ולא תוכן המסמך (כמו refs של git ולא commit).

## דוגמה

המספר הבא להקצאה 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
