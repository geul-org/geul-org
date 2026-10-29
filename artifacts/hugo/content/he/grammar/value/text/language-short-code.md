---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE הוא Value של קוד שפה של GEUL שמכיל ב-WORD אחד tag אחד של BCP 47 שקיבל מספר מ-GEUL Language Registry ‏(Codec 0x48). הרישום הוא רשומות ה-ENUM במסמך המפרט של Codec זה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE הוא קוד שפה דחוס של GEUL שמכיל ב-WORD אחד tag אחד של BCP 47 שיש לו מספר ב-GEUL Language Registry. ה-Payload הוא בדיוק WORD אחד.

## פריסה

- קוד: קוד Value ישיר `0x48`. משפחה TEXT.
- ה-Payload הוא בדיוק WORD אחד, קוד unsigned של 16 סיביות.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  סה"כ 2 WORD
Payload WORD 1st (16 סיביות)           מספר GEUL Language Registry ‏(uint16)
```

## פירוש ותקינות

- את ה-WORD של ה-Payload קוראים כמספר שלם unsigned של 16 סיביות.
- הערך הזה הוא tag אחד שהקצה GEUL Language Registry. הצורה הרשמית של הרישום היא מסמך המפרט של Codec זה, `0x0000/0x0000000000000848`. לכל ערך קוד יש [ENUM](/he/grammar/edge/enum/) אחד על FIELD ‏`code`, והשם שנקשר ב-[BIND](/he/grammar/edge/bind/) ל-Edge Id של אותו ENUM הוא ה-tag של BCP 47 באותיות הקנוניות.
- הרישום הוא רשימה סגורה. ערך שאין לו ENUM במסמך המפרט הוא invalid. כלל ה-Codec הזה קודם לכלל הכללי של ENUM ("ערך קוד שלא הוצהר אינו שגיאה").
- מקצים מספרים לשלושה סוגי tag.
  - רשומות `Type: language` של IANA Language Subtag Registry, למעט `Scope: private-use` ‏(`qaa..qtz`). אין מוציאים collection, ‏macrolanguage ו-special ‏(`mul`·`und`·`zxx`·`mis`).
  - tag ש-IANA רושם בשלמותו: grandfathered ו-redundant ‏(`zh-Hans`, `sr-Latn`, `zh-min-nan` וכדומה).
  - tag מורכב תקין שנצפה במקורות CC0 ציבוריים (`pt-BR`, `en-GB`, `be-tarask` וכדומה). הוא בנוי רק מ-subtag מסוג language, ‏extlang, ‏script, ‏region ו-variant. tag שיש בו extension ‏(`-u-`·`-t-`) או private-use ‏(`-x-`) אינו מתקבל.
- tag בלי מספר אי אפשר לכתוב בפורמט הזה. כותבים אותו כ-[LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/) ‏(`0x46`·`0x47`). ב-SHORT-CODE אין מסלול escape.
- `0x0000` ו-`0xffff` לעולם אינם מוקצים. שניהם invalid ב-Value הזה. אף אחד מהם אינו משמש במובן `null`, ‏`unknown` או `und`.
- טווחי הערכים הם מוסכמת הקצאה. המפענח אינו מסיק את סוג ה-tag מטווח הערך. משמעות הערך באה רק ממסמך המפרט.

| טווח | שימוש |
|---|---|
| `0x0000` | לא מוקצה (invalid) |
| `0x0001`–`0x3fff` | tag של language subtag יחיד |
| `0x4000`–`0x7fff` | tag של שני subtag או יותר (tag שלם של IANA, tag מורכב שנצפה) |
| `0x8000`–`0xfffe` | גלישה. כשגוש שמעליו מתמלא, ההקצאה ממשיכה כאן |
| `0xffff` | לא מוקצה (invalid) |

- המהדורה הראשונה ממספרת את ה-tag בתוך כל גוש לפי סדר ASCII באותיות קטנות. בגוש `0x4000` באים קודם ה-tag השלמים של IANA ‏(grandfathered ו-redundant מעורבים, בסדר ASCII), ואחריהם ה-tag המורכבים שנצפו (בסדר ASCII). לא הסדר הפיזי של קובץ IANA ולא תדירות השימוש הם כלל מספור.
- ההקצאה רק מוסיפה (append-only). tag חדש נוסף בסוף הגוש שלו, וכשהגוש מלא — בטווח הגלישה. ה-tag (בלי הבחנה בין אותיות גדולות לקטנות) של מספר שכבר ניתן אינו משתנה, אינו נמחק ואינו ממוחזר.
- tag חדש נכנס בהוספת ENUM ו-BIND בגרסה חדשה של מסמך המפרט. ENUM ו-BIND קיימים אינם משתנים. לכן כל גרסה היא על-קבוצה של הגרסה שלפניה.
- כשכל 65,534 המספרים תפוסים, לא מקצים עוד. tag חדשים שאחר כך נכתבים כ-LANGUAGE-BCP47-CODE. כושר הביטוי אינו פוחת; רק רווח הדחיסה אובד.
- אותה שפה: SHORT-CODE ‏`n` ו-LANGUAGE-BCP47-CODE של ה-tag שהרישום קשר ל-`n` (בלי הבחנה בין אותיות גדולות לקטנות) הם אותה שפה.
- מהדורת הרישום היא גרסה של מסמך המפרט. כל מהדורה רושמת את קובץ הרישום של IANA שעליו היא מבוססת (File-Date, ‏SHA-256) כ-[SOURCE](/he/grammar/edge/source/) ב-HEAD של מסמך המפרט. כשצריך לציין באיזו מהדורה פורש ערך, שומרים איתו את הגרסה (`0x0000/0x0000000000000848@n`).
- מפרט Codec רשאי להכיל את אותו קוד של WORD אחד בשדה ערך גולמי בלי TAG ‏([CODEC](/he/grammar/codec-spec/#codec) של שדה ערך גולמי). זהו כלל של אותו מפרט Codec; ה-wire form של Value עצמאי הוא תמיד TAG ‏1 WORD + Payload ‏1 WORD.

## בסיס בתקנים

- משמעות ה-tag ותקינות ה-subtag נקבעות לפי [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) ו-[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). ‏IANA ו-IETF מעמידים את זכויותיהם ברישומי הפרוטוקולים תחת CC0 1.0 ‏([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- מספרי הרישום (הקצאה append-only בסדר ASCII, חלוקת הגושים, אי-הקצאת `0x0000` ו-`0xffff`, רשימה סגורה), היות ה-ENUM של מסמך המפרט הצורה הרשמית, וההבחנה מ-embedding בלי TAG בשדה ערך גולמי הם כללי GEUL.

## אורך

- הסך הוא בדיוק 2 WORD, ‏TAG ‏1 WORD ועוד Payload ‏1 WORD, באורך ישיר `LLLL=0001`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק WORD אחד, דוחים.

## דוגמה

אלה מספרי הרישום v2 (מסמך המפרט `0x0000/0x0000000000000848` גרסה 2, ‏IANA File-Date ‏2026-09-17). הוקצו 8,678 tag ‏(language ‏8,275, ‏grandfathered ‏26, ‏redundant ‏67, מורכבים שנצפו 310).

| tag | קוד | כל ה-WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- במסמך המפרט, `en` הוא `ENUM #2 0x0784` ו-`BIND "en"` על ה-Edge Id שלו.
- ל-`de-x-formal` ‏(private-use) ול-`nl-u-sd-bebru` ‏(extension) אין מספר, ולכן הם נכתבים כ-LANGUAGE-BCP47-CODE.

## שאלות פתוחות

- קריאה בין מהדורות: האם מספר חדש יותר מהמהדורה שבידי הקורא נזרק כ-invalid, או נשמר עם ערכו הגולמי כ"קוד לא ידוע". מכיוון שההקצאה append-only, המהדורה האחרונה מספיקה תמיד, אבל מפענחים לא מקוונים צריכים כלל.
- צורה קנונית: האם tag שיש לו מספר צריך (SHOULD/MUST) להיכתב כ-SHORT-CODE. עם MUST הכתיב אחיד, אבל מהדורה חדשה תהפוך מסמכים שנכתבו קודם ללא קנוניים.
- איך לבטא tag מסוג deprecated ו-Preferred-Value במסמך המפרט (במהדורה הנוכחית אין).
- נוהל הוספת tag מורכבים שנצפו (מקורות, סף צפייה).

## דפים קשורים

- [LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/), [LABEL](/he/grammar/edge/label/)
- [מסמך מפרט Codec](/he/grammar/codec-spec/), [ENUM](/he/grammar/edge/enum/), [BIND](/he/grammar/edge/bind/), [SOURCE](/he/grammar/edge/source/)
