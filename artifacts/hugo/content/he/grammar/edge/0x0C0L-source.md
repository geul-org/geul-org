---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE הוא Edge של ראיות שמחבר רשומה אחת (היעד) או מסמך שלם אל המקור שממנו בא."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SOURCE` (BIND של מסמך המפרט `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| מסמך מפרט | `0x00000000/codecs/0x00000C00/` (יעד DECLARE `0C00`) |
| קטע | 6 `0110` (ראיות Edge), היסט בתוך הקטע C = 0 |
| Kind | Edge · משפחה: ראיות |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מחבר רשומה אחת או מסמך שלם אל מקורו. Target (Edge Id של BODY, ב-HEAD `0` = המסמך כולו), Origin (Reference, ABSENT או UNKNOWN-VALUE). תכונות המקור נכתבות כ-TRIPLE שה-Subject שלה הוא המקור, ותכונות הציטוט (תאריך גישה, מיקום, גיבוב הטקסט המקורי) כ-QUALIFIER שמצורף ל-SOURCE. ה-SOURCE של המסמך כולו וה-QUALIFIER שלו ממוקמים ב-HEAD |
| צד Hugo | `edge/source.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר ב-FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | רשומה | `0050` LOCAL |  |
| 2 | `origin` | #3 | רשומה | `000F` קטע 0 כולו (תו כללי, Reference), `020F` קטע 1 כולו (תו כללי, Reference), `040F` קטע 2 כולו (תו כללי, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (שדה אופציונלי) |  |

SOURCE הוא Edge של ראיות שמחבר רשומה אחת (היעד) או מסמך שלם אל המקור שממנו בא. Codec `0x0C0L`. הוא הקוד הישיר היחיד במשפחת הראיות (`01`).

reference אחד של Wikidata (חבילת מקורות) הוא SOURCE אחד. אם לרשומה אחת כמה מקורות, יש כמה SOURCE.

## פריסה {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[TAG הרחבה של Length]
Edge Id           רשומת LOCAL Reference
Target            רשומת LOCAL Reference (ב-BODY: ה-Edge Id של ה-Edge שאליו מצרפים ראיה, ב-HEAD: 0 = המסמך כולו)
Origin            רשומת Reference, או סמן מקום 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin מצביע על המקור. אם יש Reference שמתאים למקור משתמשים בו (WIKIDATA-QID, DOC-POINTER או EXTERNAL-ISSUER של מסמך GEUL וכד'), ואם אין, זהו צומת LOCAL של המסמך הזה.
- אם המקור אינו מתאר את המקור עצמו (למשל מקור של Wikidata שיש בו רק "imported from" (P143) ותאריך גישה), Origin הוא [ABSENT](../slot-marker.md) (לא נכתב). הכותב פשוט לא כתב את המקור, ואינו קובע דבר על המקור. שאר המקור נשאר ב-QUALIFIER.
- רק כשהכותב קובע ש"יש מקור אבל איני יודע מהו" משתמשים ב-[UNKNOWN-VALUE](../slot-marker.md) (תיעוד שנכתב בידי אדם וכד'). ממיר שמעביר מחומר מקור אינו קובע מה שהמקור לא אמר, ולכן משתמש ב-ABSENT.
- Origin שהוא ABSENT או UNKNOWN-VALUE הוא עצמאי בכל הופעה. אין לקרוא את המקורות של שני SOURCE כזהים.

## שתי שכבות {#두-층}

המידע על המקור מתחלק לשניים. אין לערבב.

| שכבה | מה | איך כותבים | דוגמה |
|---|---|---|---|
| מקור | תכונות המקור עצמו, זהות לכל מי שמצטט | [TRIPLE](0x0AAL-triple.md) שה-Subject שלה הוא המקור (rank normal) | URL (P854), כותרת (P1476), מחבר (P50, P2093), תאריך פרסום (P577), כתב עת (P1433), מו״ל (P123), שפה (P407) |
| ציטוט | תכונות פעולת הציטוט של הרשומה הזו את המקור | [QUALIFIER](0x0ABL-qualifier.md) שה-Target שלו הוא ה-Edge Id של ה-SOURCE | תאריך גישה (P813), מיקום בתוך המקור (עמוד P304, סעיף P958, מזהה חיצוני P227, P1417), נלקח מ- (P143), שיטת הסקה (P887), גיבוב הטקסט המקורי (P4092) |

- **משמעות ה-SOURCE היא אוסף כל ה-QUALIFIER שמצביעים על ה-Edge Id שלו.** שני ציטוטים של אותו מקור שנבדק בימים שונים: המקור זהה וה-QUALIFIER שונים.
- TRIPLE של מקור היא קביעה על המקור. תכונה שאי אפשר להכריע לאיזו שכבה היא שייכת מניחים בצד הציטוט (QUALIFIER). בטוח יותר לא לקבוע דבר על המקור.
- אותו מקור בתוך מסמך מוצהר פעם אחת בלבד כ-LOCAL אחד, וכמה SOURCE מצביעים עליו יחד.
- מקור שמתואר ב-URL יחיד מוגדר ב-[REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL ← URI). זה כמו דף המסמך של sitelink.

## פירוש ותוקף {#해석과-유효성}

- Target ו-Origin הם כל אחד רשומה שלמה אחת בדיוק. הסמן שקרא את Origin חייב להתיישר עם סוף ה-Edge.
- Target הוא LOCAL Reference. SOURCE ב-BODY מצביע על Edge Id ב-BODY של אותו מסמך. `0` (המסמך כולו) משמש רק SOURCE ב-HEAD ([מקור המסמך כולו](#문서-전체의-출처)). SOURCE שה-Target שלו `0` ב-BODY הוא invalid. לרשומה במסמך אחר מצרפים ראיה בתוך אותו מסמך.
- Origin הוא Reference. מבין סמני המקום מתקבלים רק `0x0000` (ABSENT) ו-`0x0010` (UNKNOWN-VALUE). NO-VALUE (`0x0020`) ו-Value אינם מתקבלים.
- מסמך המפרט של geul.org `0x00000000/codecs/0x00000C00` (שם `source`) מציב ב-Target את [CODEC](0x0BEL-codec.md) LOCAL (`0050`), וב-Origin את CODEC `000F`, `020F`, `040F` (כל Reference), `0000` (ABSENT, אופציונלי) ו-`0010` (UNKNOWN-VALUE).
- הסדר בין SOURCE של אותו Target חסר משמעות. גם סדר הפריטים בתוך מקור אחד חסר משמעות (סדר ערכים של אותה תכונה נשמר כסדר המסמך).
- SOURCE אינו משנה את האמת או השקר של היעד. הוא רק רושם מאיפה היעד בא. תוצאת ההכרעה באחריות [TOULMIN](../toulmin/_index.md) `VERDICT`.

## מקור המסמך כולו {#문서-전체의-출처}

המקור של המסמך כולו (קובץ dump מקורי, מהדורה, קובץ טקסט מקורי) נכתב כ-**SOURCE עם Target `0` ב-HEAD**. גם ה-QUALIFIER שמצביעים על אותו SOURCE (גיבוב הטקסט המקורי P4092, זמן קבלה P813, טווח בטקסט המקורי וכד') ממוקמים ב-HEAD ([מסמך](../document.md#head와-body)).

- אלה שני ה-Edge היחידים שמותר למקם ב-HEAD. כל שאר ה-Edge ב-BODY.
- ה-QUALIFIER של HEAD ממוקם אחרי ה-SOURCE של HEAD שעליו הוא מצביע. המפענח קורא מההתחלה ומפריד בין HEAD ל-BODY.
- QUALIFIER שמצביע על SOURCE של HEAD ומופיע ב-BODY הוא invalid. ה-SOURCE וה-QUALIFIER של BODY אינם מצביעים על Edge של HEAD.
- **HEAD ו-BODY חולקים מרחב מספרים אחד ל-Edge Id.** הוא ייחודי בתוך המסמך, מתקבל מ-[NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) כמו בשאר ה-Edge, וכשבונים מחדש תוכן זהה מקבל אותו מספר. גם בגרסה שבה חסר Edge של HEAD לא משתמשים שוב במספר שלו.
- אם Origin הוא LOCAL, ההגדרה שלו (REFERENCE-NODE, TRIPLE של המקור) ממוקמת ב-BODY. היקף ה-LOCAL הוא המסמך כולו.
- Edge של HEAD אינו Meta ממחלקת האימות, ולכן הוא נכלל ב-[גיבוב התוכן](../document.md#내용-해시). ב-diff הוא משתנה כולו יחד עם HEAD (לא נרשם ב-`DELTA-REMOVE`).
- אין Meta נפרד למקור של המסמך כולו. טווח בטקסט המקורי וזמן רכישה שנכתבים כ-Meta אינם מאפשרים לקבוע, כשיש כמה מקורות, לאיזה מקור הם שייכים. QUALIFIER שמצורף ל-SOURCE קובע זאת באמצעות ה-Target.

דוגמה: HEAD של מסמך Q42 שהועבר מ-dump של Wikidata (ה-Edge Id להמחשה בלבד).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         גרסת הישות (revision)
#1741 SOURCE     #0     #1740                                         קובץ dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            גיבוב הקובץ
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    זמן קבלה
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      זמן שמירת הגרסה
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  כתובת קבועה של הגרסה
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- הגרסה וה-dump הם מקורות שונים, ולכן יש שני SOURCE. הגרסה היא מקור התוכן (אפשר לקבל שוב את אותו תוכן דרך הכתובת הקבועה), וה-dump הוא הקובץ שבו התקבלה אותה גרסה. גיבוב הקובץ וזמן הקבלה הם תכונות של הקובץ מצד הציטוט, ולכן מצורפים ל-SOURCE של ה-dump.

## ייצוג של ראיות אחרות {#다른-근거의-표현}

במשפחת הראיות יש רק SOURCE. ראיות אחרות נכתבות כ-QUALIFIER.

| ראיה | איך כותבים | Property |
|---|---|---|
| טווח בתוך הטקסט המקורי | QUALIFIER ל-SOURCE. SOURCE אחד לכל טווח | עמוד P304, סעיף P958, ציטוט P1683. טווח תווים הוא מונח GEUL (טרם נקבע) |
| זמן קבלת חומר המקור | QUALIFIER ל-SOURCE | תאריך גישה P813 |
| גיבוב בתים של הטקסט המקורי (קיבוע מהדורה) | QUALIFIER ל-SOURCE | checksum P4092, הערך [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) וכד' |
| יוצר (אדם, מודל, מנוע כללים) | QUALIFIER ל-SOURCE (היוצר של הציטוט) או ליעד | מונח GEUL (טרם נקבע) |
| מהימנות | QUALIFIER ליעד | מונח GEUL (טרם נקבע), הערך 0~1 כמו Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| תקופת תוקף לפי סעיף | QUALIFIER ליעד | התחלה P580, סיום P582 |
| רשומה ישנה לפני העברה, פיצול או איחוד | QUALIFIER ליעד, הערך הוא ה-Edge Id הישן (LOCAL) | P1365 (replaces) |
| הגרסה שנכנסה ראשונה | לא נשמרת. מחושבת מהיסטוריית הגרסאות (git blame) | |

## דוגמה (לא נורמטיבית) {#예시-비규범}

Q42 P19 (מקום לידה) Q350, TRIPLE היעד `#178`. ב-dump של Wikidata מ-2026-10-19 יש לקביעה הזו חמישה מקורות, ומוצגים שלושה מהם. ③ כתבה ב-Telegraph (`#1358`~`#1367`) זהה בצורתה ל-②, ו-⑤ Store norske leksikon (Q746368) זהה ל-①, ולכן הושמטו.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: בלי תיאור מקור, רק P248 אחד
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② כתבה ב-Guardian #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 שהוצהר קודם (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ל-① אין תיאור מקור ויש P248 אחד, ולכן המקור הוא אותו פריט. `#1347` הוא TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- מקור שיש לו רק URL אחד: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- מקור שיש בו רק "imported from" ויקיפדיה האנגלית: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` הוא WORD אחד.

## בעיות פתוחות {#열린-문제}

- מונחי GEUL לטווח תווים, ליוצר ולמהימנות (מסמך הגדרת מונח ו-ID).
- כשתיאור המקור אינו מזהה את המקור (מקור שיש בו רק שפה וכד'), שיתוף אותו תיאור ב-LOCAL אחד יקבע ששני מקורות שונים הם אותו מקור.
- רשימת תכונות מקור וציטוט למקורות מחוץ ל-Wikidata (חקיקה, ציטוטי רשת).
- מקור של מקור (שרשרת): האם לצרף SOURCE נוסף ל-LOCAL של המקור.

## דפים קשורים {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [סמן מקום](../slot-marker.md)
- [מסמך](../document.md) (HEAD ו-BODY), [Meta — מוצא](../meta/_index.md#출처)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00000C00/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
