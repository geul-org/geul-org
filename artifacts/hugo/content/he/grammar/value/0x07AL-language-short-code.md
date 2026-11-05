---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE הוא קוד שפה דחוס של GEUL הנושא ב-WORD אחד tag של BCP 47 שהוקצה לו מספר ב-GEUL Language Registry."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `LANGUAGE-SHORT-CODE` (מסמך מפרט BIND `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| מסמך מפרט | `0x00000000/codecs/0x000007A0/` (יעד DECLARE ‏`07A0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 26 |
| Kind | Value · משפחה: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | tag של BCP 47 הכתוב במספר של GEUL Language Registry (Payload של WORD אחד) |
| בצד Hugo | `value/text/language-short-code.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | ערך גולמי, WORD אחד |  | 8678 ENUM. לדוגמה: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE הוא קוד שפה דחוס של GEUL הנושא ב-WORD אחד tag של BCP 47 שהוקצה לו מספר ב-GEUL Language Registry. ה-Payload הוא בדיוק WORD אחד.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value ‏`0x07AL`. משפחה TEXT.
- ה-Payload הוא בדיוק קוד unsigned של 16 סיביות ב-WORD אחד.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  סך הכול 2 WORD
Payload WORD 1st (16 סיביות)        מספר GEUL Language Registry (uint16)
```

## פירוש ותוקף {#해석과-유효성}

- קוראים את WORD ה-Payload האחד כמספר שלם unsigned של 16 סיביות.
- הערך הוא tag אחד שהוקצה על ידי GEUL Language Registry. הייצוג הרשמי של ה-registry הוא מסמך המפרט של Codec זה, `0x00000000/codecs/0x000007A0`. לכל ערך קוד יש [ENUM](../edge/0x0BDL-enum.md) אחד בשדה `code`, והשם הקשור ב-[BIND](../edge/0x0A3L-bind.md) ל-Edge Id של אותו ENUM הוא tag של BCP 47 באותיות קנוניות.
- ה-registry הוא רשימה סגורה. ערך שאין לו ENUM במסמך המפרט הוא invalid. כלל ה-Codec הזה גובר על הכלל הכללי של ENUM (ערך קוד שלא הוצהר אינו שגיאה).
- ההקצאה חלה על שלושה אלה.
  - רשומות `Type: language` של IANA Language Subtag Registry, פרט ל-`Scope: private-use` (‏`qaa..qtz`). collection, ‏macrolanguage ו-special (‏`mul`·`und`·`zxx`·`mis`) אינם מוחרגים.
  - tag-ים ש-IANA רשמה כשלמים: grandfathered ו-redundant (‏`zh-Hans`, ‏`sr-Latn`, ‏`zh-min-nan` וכו').
  - tag-ים של צירופים תקפים שנצפו במקורות CC0 ציבוריים (‏`pt-BR`, ‏`en-GB`, ‏`be-tarask` וכו'). אלה tag-ים המורכבים רק מ-subtag-ים של language, ‏extlang, ‏script, ‏region ו-variant. tag-ים שיש בהם extension (‏`-u-`·`-t-`) ו-private-use (‏`-x-`) אינם מתקבלים.
- tag שאין לו מספר אי אפשר לכתוב בפורמט זה. כותבים אותו ב-[LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (‏`0x076L`·`0x077L`). בתוך SHORT-CODE אין נתיב escape.
- `0x0000` ו-`0xFFFF` לא יוקצו לעולם. ב-Value זה שניהם invalid. אף אחד מהם אינו משמש במובן `null`, ‏`unknown` או `und`.
- טווחי הערכים הם מוסכמת הקצאה. מפענח אינו מסיק את סוג ה-tag מטווח הערך. משמעות הערך באה רק ממסמך המפרט.

| טווח | שימוש |
|---|---|
| `0x0000` | לא מוקצה (invalid) |
| `0x0001`–`0x3FFF` | tag שהוא subtag אחד של language |
| `0x4000`–`0x7FFF` | tag בעל שני subtag-ים ומעלה (tag שלם של IANA, tag צירוף שנצפה) |
| `0x8000`–`0xFFFE` | גלישה. כשהבלוקים שלמעלה מתמלאים ממשיכים להקצות כאן |
| `0xFFFF` | לא מוקצה (invalid) |

- הגרסה הראשונית נותנת מספרים בתוך בלוק לפי סדר ASCII של ה-tag באותיות קטנות. בבלוק `0x4000` באים תחילה tag-ים שלמים של IANA (בסדר ASCII, grandfathered ו-redundant מעורבים) ואחריהם tag-ים של צירופים שנצפו (בסדר ASCII). הסדר הפיזי של קובץ IANA ותדירות השימוש אינם כלל מספור.
- ההקצאה היא הוספה בלבד (append-only). tag חדש מתווסף בסוף הבלוק, וכשהבלוק מתמלא מתווסף בטווח הגלישה. ה-tag של מספר שניתן (בלי תלות ברישיות) אינו משתנה, ואינו נמחק ואינו מנוצל מחדש.
- tag חדש נכנס בגרסה חדשה של מסמך המפרט על ידי הוספת ENUM ו-BIND. ENUM ו-BIND קיימים אינם משתנים. לכן כל גרסה היא על-קבוצה של הגרסה הקודמת.
- כשכל 65,534 המספרים מתמלאים, לא מקצים עוד. tag חדש לאחר מכן נכתב ב-LANGUAGE-BCP47-CODE. כושר הביטוי אינו קטן, ורק היתרון בדחיסה נעלם.
- אותה שפה: SHORT-CODE ‏`n` ו-LANGUAGE-BCP47-CODE של ה-tag שה-registry קשר ל-`n` (בלי תלות ברישיות) הם אותה שפה.
- גרסת ה-registry היא גרסת מסמך המפרט. כל גרסה רושמת את קובץ ה-IANA registry שעליו התבססה (File-Date, ‏SHA-256) כ-[SOURCE](../edge/0x0C0L-source.md) ב-HEAD של מסמך המפרט. כשצריך לציין באיזו גרסה פורש הערך, משאירים יחד איתו את אותה גרסה ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (‏`0x00000000`, ‏`0x000007A0`, ‏ID גרסה `n`)).
- מפרט Codec יכול לשאת את אותו קוד של WORD אחד גם בשדה ערך גולמי ללא TAG (ה-[CODEC](../codec-spec.md#codec) של שדה ערך גולמי). זהו כלל של מפרט ה-Codec ההוא, וצורת ה-wire של Value עצמאי היא תמיד TAG של WORD אחד + Payload של WORD אחד.

## בסיס בתקנים {#표준-근거}

- משמעות ה-tag ותקפות ה-subtag נקבעות לפי [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) ו-[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA ו-IETF מציבות את הזכויות ברישומי הפרוטוקול תחת CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- מספרי ה-registry (הקצאה append-only בסדר ASCII, מבנה הבלוקים, אי-הקצאת `0x0000` ו-`0xFFFF`, רשימה סגורה), העובדה שה-ENUM של מסמך המפרט הוא הייצוג הרשמי וההבחנה מהטמעה בשדה ערך גולמי ללא TAG הם כללי GEUL.

## אורך {#길이}

- הסך הכול הוא בדיוק 2 WORD, ‏TAG של WORD אחד ו-Payload של WORD אחד, ומשתמשים באורך הישיר `LLLL=0001`. אין Length TAG של הרחבה, ואין descriptor ואין padding.
- אם ה-Payload אינו WORD אחד בדיוק, דוחים.

## דוגמה {#예시}

המספרים של registry v2 (גרסה 2 של מסמך המפרט `0x00000000/codecs/0x000007A0`, ‏IANA File-Date ‏2026-09-17). הוקצו 8,678 (language ‏8,275, ‏grandfathered ‏26, ‏redundant ‏67, צירופים שנצפו 310).

| tag | קוד | סך הכול WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- במסמך המפרט `en` הוא `ENUM #2 0x0784` ו-`BIND "en"` הקשור ל-Edge Id שלו.
- ל-`de-x-formal` (private-use) ול-`nl-u-sd-bebru` (extension) אין מספר, ולכן נכתבים ב-LANGUAGE-BCP47-CODE.

## בעיות פתוחות {#열린-문제}

- פירוש בין גרסאות: כשקורא פוגש מספר חדש מהגרסה שברשותו, האם לזרוק אותו כ-invalid או לשמר את הערך המקורי ולטפל בו כ"קוד לא מוכר". בגלל ה-append-only תמיד מספיקה הגרסה העדכנית ביותר, אך נדרש כלל למפענחים לא מקוונים.
- צורה קנונית: האם tag שיש לו מספר חייב (SHOULD/MUST) להיכתב כ-SHORT-CODE. עם MUST הכתיב נקבע באופן יחיד, אך כשיוצאת גרסה חדשה מסמך שנכתב קודם חדל להיות בצורה הקנונית.
- דרך לייצג במסמך המפרט tag שהוצא משימוש (deprecated) ו-Preferred-Value (אין כזו בגרסה הנוכחית).
- הליך להוספת tag-ים של צירופים שנצפו (מקור, רף תצפית).

## דפים קשורים {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [מסמך המפרט של Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000007A0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 שורות ENUM ו-BIND הושמטו)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
