---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT הוא טקסט בעל שפה, הנושא ב-Value אחד רשומת Value של שפה וטקסט UTF-8 (Codec 0x078L/0x079L)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT הוא טקסט בעל שפה, הנושא ב-Value אחד רשומת Value של שפה וטקסט UTF-8 (Codec 0x078L/0x079L).

| פריט | ערך |
|---|---|
| שם | `UTF8-LANGUAGE-TEXT` (קבוצת זוגי/אי-זוגי. שם כל קוד בטבלת החברים להלן) |
| TAG ID | `0x078L`·`0x079L` |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 24~25 |
| Kind | Value · משפחה: TEXT |
| תיאור באינדקס | טקסט בעל שפה. רשומת Value של שפה (LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE) ובייטי UTF-8. זוגי/אי-זוגי של בייטי הטקסט |
| בצד Hugo | `value/text/utf8-language-text.md` |

## חברים {#구성원}

דף זה עוסק בשני קודים של זוג זוגי/אי-זוגי יחד. הקוד הזוגי הוא ערך שמספר הבייטים שלו זוגי, והקוד האי-זוגי הוא ערך שמספר הבייטים שלו אי-זוגי ([רשומה ו-TAG WORD](../record.md#가변-길이-바이트열)). מסמך Codec אחד לכל קוד. השדות בשני מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | מספר בייטים | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | זוגי | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | אי-זוגי | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | רשומה | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | שארית ערך גולמי (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT הוא טקסט בעל שפה. הוא נושא ב-Value אחד רשומת Value של שפה ורצף בייטים של UTF-8.

[UTF8-TEXT](0x072L-utf8-text.md) הוא מחרוזת חסרת שפה (מזהה, קוד, שם קובץ, בייטים של מקור), ופורמט זה הוא טקסט בעל שפה (שם, כותרת, סיסמה, משפט). גם אם הבייטים זהים, אלה שני ערכים שונים. "Paris" (מחרוזת) ו-"Paris" (צרפתית) אינם שווים. זה כמו ההבחנה של RDF בין `xsd:string` ל-`rdf:langString`.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value ‏`0x078L` (בייטי הטקסט זוגיים) ו-`0x079L` (בייטי הטקסט אי-זוגיים). משפחה TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = בייטי הטקסט אי-זוגיים)
[Length TAG הרחבה] כשהסך הכול 15 WORD ומעלה
Language          רשומת Value אחת של LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE (כולל TAG)
Text WORD 1st ... Nth             UTF-8 bytes / אם אי-זוגי, האחרון 0x00
```

## פירוש ותוקף {#해석과-유효성}

- ה-Payload מתחיל ברשומת שפה. קוראים את ה-WORD הראשון של ה-Payload כ-TAG, ורשומת השפה היא באורך ה-Length שלו, והשאר הוא בייטי הטקסט. רשומת השפה חובה. כשאין שפה משתמשים ב-UTF8-TEXT ולא בפורמט זה.
- רשומת השפה היא בדיוק רשומה שלמה אחת של [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (‏`0x07AL`) או של [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (‏`0x076L`·`0x077L`). Codec אחר או רשומה חלקית הם invalid. תקפות רשומת השפה נקבעת לפי כללי הפורמט שלה.
- אפשר להשתמש בשני פורמטי השפה. כלל ההשוואה אם מדובר באותה שפה זהה לזה של [LABEL](../edge/0x0A4L-label.md). SHORT-CODE ו-tag של BCP 47 שה-registry קשר למספר שלו הם אותה שפה.
- `zxx` (אין תוכן לשוני) אינו בשימוש. מחרוזת כזו היא UTF8-TEXT. ‏`und` (שפה לא מוגדרת) ו-`mul` (שפות רבות) הם טקסט בעל שפה ולכן מותרים.
- בייטי הטקסט כפופים לאותם כללים כמו ב-UTF8-TEXT. חייבים להיות UTF-8 well-formed, גם U+FEFF בתחילה מותר כתו, נרמול אינו נאכף והמקור נשמר כפי שהוא. הצד שמשווה ומאנדקס משווה לאחר יישור ל-NFC.
- מספר בייטי הטקסט הוא `2 × (מספר Payload WORD − מספר WORD של רשומת השפה) − P`. P (הסיבית הנמוכה ביותר של ה-Codec) מציין רק זוגיות או אי-זוגיות של בייטי הטקסט. אם אי-זוגי, הבייט התחתון של ה-WORD האחרון חייב להיות `00`.
- טקסט ריק (0 בייטים) מונח בקוד הזוגי עם רשומת השפה בלבד.

## היכן משתמשים {#쓰는-곳}

- ערך monolingualtext של Wikidata: ‏`{"text":"Bundesrepublik Deutschland","language":"de"}` הופך לפורמט אחד זה. הוא נכנס כמות שהוא כ-Object של [TRIPLE](../edge/0x0AAL-triple.md) וכ-Value של [QUALIFIER](../edge/0x0ABL-qualifier.md). המאפיין, ה-rank וה-qualifier באחריות ה-TRIPLE.
- ה-Object של [LABEL](../edge/0x0A4L-label.md) ו-[ALIAS](../edge/0x0A5L-alias.md). ערך אחד זה נושא את השם ואת השפה.
- טקסט ששפתו קבועה, כמו כותרות של חוקים ומאמרים.

## התאמת קודי שפה (Wikidata) {#언어-코드-대응-위키데이터}

- לא כל קודי השפה של Wikidata ושל Wikimedia הם BCP 47 (לדוגמה `simple`, ‏`map-bms`). מעבירים אותם ל-tag של BCP 47 לפי טבלת התאמה. קוד שאי אפשר להעביר מטופל בדרכים שונות לפי השימוש.
  - ערך (monolingualtext): שומרים את המקור של ה-datavalue כ-UTF8-TEXT. הערך הוא חלק מהטענה, ואם משליכים אותו הטענה משתנה.
  - תווית, תיאור וכינוי: מדלגים ורושמים בדוח. ה-Edge הללו מתקיימים רק עם שפה (טקסט חסר שפה הוא invalid), והמקור נשאר בנתוני המקור.
- אם ל-tag שהועבר יש מספר ב-GEUL Language Registry, כותבים אותו כ-LANGUAGE-SHORT-CODE, ואם אין, כ-LANGUAGE-BCP47-CODE.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, ה-Length TAG של ההרחבה (אם יש), רשומת השפה ו-WORD-ים של הטקסט. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב ([Length](../record.md)).
- רשומת השפה היא 2 WORD אם SHORT-CODE, ואם BCP 47 היא `ceil(בייטי tag/2) + 1` WORD (‏`de` 2 WORD, ‏`zh-Hant` 5 WORD).

## דוגמה {#예시}

השפה בכולן היא דוגמה בפורמט LANGUAGE-BCP47-CODE. ל-`fr`, ‏`ko` ו-`de` יש מספר ב-registry, ולכן אפשר לכתוב גם ב-SHORT-CODE (2 WORD).

| ערך | בייטי טקסט | סך הכול WORD |
|---|---|---|
| "Paris" (fr) | 5 (אי-זוגי) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (זוגי) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": ‏TAG ‏`0795` (‏Codec ‏`0x079L`, ‏`LLLL=0101`, סך הכול 6 WORD), שפה `0761 6672` (‏BCP 47 ‏`fr`), טקסט `5061 7269 7300` (5 בייטים, האחרון `00`).
- השלישי הוא 17 WORD בסך הכול, ולכן משתמש בהרחבת Length (‏`LLLL=1110` של `078E`, ‏TAG ההרחבה `0011`).

## בסיס בתקנים {#표준-근거}

- tag של שפה: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). ‏`zxx`, ‏`und` ו-`mul` הם קודים מיוחדים (special) של IANA Language Subtag Registry.
- טקסט: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- ההבחנה בין מחרוזת לטקסט בעל שפה: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## בעיות פתוחות {#열린-문제}

- בדיקת דקדוק tag של BCP 47 ב-schema. כרגע בודקים רק שהוא ASCII ושאינו ריק.

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000780/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

למעלה מסמך ה-Codec של `UTF8-LANGUAGE-TEXT-EVEN` (‏`0x078L`). במסמך ה-Codec של חבר אחר (`UTF8-LANGUAGE-TEXT-ODD`) שונים רק ה-Codec ID ב-DOC-ID, יעד ה-DECLARE והשם הקשור ב-`#1` (BIND).
