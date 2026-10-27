---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE הוא Value של קוד שפה של GEUL שדוחס ל-WORD אחד רק את ה-primary language subtag (Codec 0x48)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE הוא קוד שפה דחוס של GEUL שמכיל רק את ה-primary language subtag ולא את ה-tag המלא של BCP 47. ה-Payload הוא בדיוק WORD אחד.

## פריסה

- קוד: קוד ישיר של Value `0x48`. משפחה TEXT.
- ה-Payload הוא קוד unsigned של 16 ביט, WORD אחד בדיוק.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  סך הכול 2 WORD
Payload WORD 1st (16 ביט)           GEUL language code (uint16)
```

## פירוש ותקינות

- קוראים את ה-Payload של WORD אחד כמספר שלם unsigned של 16 ביט.
- הערך הזה הוא קוד דחוס של primary language subtag. הוא אינו מכיל script, region, variant, extension או private-use. כשדרוש מידע כזה, משתמשים ב-[LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`).
- `0x0000..0xfffe` הוא טווח ההקצאה של GEUL Language Registry. גם בתוך הטווח הזה, ערך שלא הוקצה בפועל בגרסת ה-registry הרלוונטית הוא invalid.
- היעד של ההקצאה הראשונית הוא הרשומות הציבוריות מסוג `Type: language` ב-snapshot מסוים של IANA Language Subtag Registry, פרט ל-`Scope: private-use`. collections, macrolanguage ו-special אינם מוצאים.
- בהקצאה הראשונית ממיינים את הרשומות הציבוריות האלה לפי סדר ה-subtag ב-ASCII ומצמידים להן ID. הסדר הפיזי של קובץ IANA אינו כלל ה-ID.
- subtag חדש מסוג `Type: language` מצורף בסוף בלי לשנות מספרים קיימים (append-only).
- ה-ID של language subtag שהוצא משימוש לא נמחק ולא משמש שוב. היחס ל-Preferred-Value והמצב deprecated נשמרים ב-metadata של ה-registry.
- `0xffff` שמור כ-escape להרחבה. עד שיוגדר פורמט הרחבה נפרד, הוא invalid ב-Value עצמאי של LANGUAGE-SHORT-CODE. לא משתמשים בו במשמעות כמו `null`, `unknown` או `und`.
- בעתיד schema נפרד כמו Lemma Edge יכול להגדיר כללי פירוש אחרי `0xffff`. עם זאת, אין פירוש הדבר שהכלל הזה מאריך את ה-Payload של הפורמט הזה או מתיר Payload שבא אחריו.
- schema של Lemma Edge מסוימים יכולים להטמיע את אותו קוד של WORD אחד בלי TAG כשדה compact. זה כלל של ה-schema של ה-Edge, וה-wire form של Value עצמאי הוא תמיד TAG של WORD אחד + Payload של WORD אחד.
- כדי לקבוע את משמעות הערך, חייבים לשמור יחד גם את גרסת GEUL Language Registry שנעשה בה שימוש וגם את תאריך ה-snapshot של IANA registry שהגרסה הזו נועלת.

## בסיס בתקנים

- ה-registry המקורי של ה-primary language subtag וה-metadata של deprecated/Preferred-Value הם לפי [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- המשמעות הבסיסית של מערכת language subtag של BCP 47 היא לפי [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- הצמדת ID במיון ASCII ו-append-only, שמירת `0xffff`, וההבחנה מהטמעת Lemma compact בלי TAG הם כללי GEUL.

## אורך

- הסך הכול הוא בדיוק 2 WORD: TAG אחד ו-Payload אחד, עם אורך ישיר `LLLL=0001`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק WORD אחד, דוחים.

## דוגמה

- פנקס ה-snapshot וטבלת הקודים בפועל טרם נקבעו, ולכן לא מובאת דוגמה של ID מספרי לשפה מסוימת.

## שאלות פתוחות

- תאריך ה-snapshot הראשוני של IANA, שם גרסת GEUL Language Registry וטבלת ההתאמה המלאה. עד שייקבעו, לא נועלים דוגמאות מספריות קונקרטיות או טבלת קודים.
