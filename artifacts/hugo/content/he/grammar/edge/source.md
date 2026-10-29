---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE היא Edge של ראיה שמקשרת רשומה אחת או את המסמך כולו למקור שלה (Codec 0x20). תכונות המקור נכתבות כ-TRIPLE שה-Subject שלה הוא המקור, ותכונות הציטוט (תאריך גישה, מיקום בתוך המקור, hash של הטקסט המקורי) נכתבות כ-QUALIFIER שמצורף ל-SOURCE. ה-SOURCE של המסמך כולו ממוקם ב-HEAD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE היא Edge של ראיה שמקשרת רשומה אחת (היעד) או את המסמך כולו למקור שממנו בא. Codec `0x20`. זהו הקוד הישיר היחיד במשפחת הראיות (`01`).

reference אחד (קבוצת מקורות) של Wikidata הוא SOURCE אחד. אם לרשומה יש כמה מקורות, יש כמה SOURCE.

## פריסה

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
Target            רשומת LOCAL Reference (ב-BODY: ה-Edge Id של ה-Edge שאליה מצרפים ראיה, ב-HEAD: 0 = המסמך כולו)
Origin            רשומת Reference, או סמן מקום 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

- ה-Origin מצביע על המקור. אם יש Reference שמתאים למקור משתמשים בו (WIKIDATA-QID, DOC-POINTER·EXTERNAL-ISSUER של מסמך GEUL וכד'), ואם אין, זהו צומת LOCAL של המסמך הזה.
- אם הציטוט אינו מתאר מקור (למשל ציטוט ב-Wikidata שיש בו רק "imported from" (P143) ותאריך גישה), ה-Origin הוא [ABSENT](/he/grammar/reference/slot-marker/) (לא נכתב). הצד הכותב פשוט לא רשם מקור, ואינו קובע דבר על המקור. שאר הציטוט נשאר כמות שהוא ב-QUALIFIER.
- משתמשים ב-[UNKNOWN-VALUE](/he/grammar/reference/slot-marker/) רק כשהצד הכותב קובע ש"יש מקור אך לא ידוע מהו" (תיעוד שנכתב בידי אדם וכד'). ממיר שמעביר מחומר מקור אינו קובע מה שהמקור לא אמר, ולכן משתמש ב-ABSENT.
- Origin שהוא ABSENT או UNKNOWN-VALUE הוא עצמאי בכל הופעה. אין לקרוא את המקורות של שני SOURCE כזהים.

## שתי שכבות

המידע על המקור מתחלק לשניים. אין לערבב.

| שכבה | מה | איך כותבים | דוגמה |
|---|---|---|---|
| מקור | תכונות המקור עצמו. זהות לכל מי שמצטט | [TRIPLE](/he/grammar/edge/triple/) שה-Subject שלה הוא המקור (rank normal) | URL (P854), כותרת (P1476), מחבר (P50·P2093), תאריך פרסום (P577), כתב עת (P1433), מוציא לאור (P123), שפה (P407) |
| ציטוט | תכונות הפעולה שבה הרשומה הזו ציטטה את המקור | [QUALIFIER](/he/grammar/edge/qualifier/) שה-Target שלו הוא ה-Edge Id של ה-SOURCE | תאריך גישה (P813), מיקום בתוך המקור (עמוד P304, סעיף P958, מזהה חיצוני P227·P1417), מקום ההבאה (P143), שיטת הסקה (P887), hash הטקסט המקורי (P4092) |

- **המשמעות של SOURCE היא אוסף כל ה-QUALIFIER שמצביעים על ה-Edge Id שלו.** שני ציטוטים של אותו מקור שנגשו אליו בימים שונים הם אותו מקור עם QUALIFIER שונים.
- TRIPLE של מקור היא קביעה על המקור. תכונה שלא ברור לאיזו שכבה היא שייכת מוצבת בצד הציטוט (QUALIFIER). בטוח יותר לא לקבוע דבר על המקור.
- בתוך מסמך, אותו מקור מוצהר פעם אחת כ-LOCAL אחד, וכמה SOURCE מצביעים עליו יחד.
- מקור שמתואר ב-URL בלבד מוגדר ב-[REFERENCE-NODE](/he/grammar/edge/reference-node/) (LOCAL ← URI). זהו אותו אופן כמו בדף המסמך של sitelink.

## פירוש ותקינות

- ה-Target וה-Origin הם כל אחד רשומה שלמה אחת בדיוק. הסמן שקרא את ה-Origin חייב להתלכד עם סוף ה-Edge.
- ה-Target הוא LOCAL Reference. SOURCE ב-BODY מצביע על Edge Id של BODY באותו מסמך. `0` (המסמך כולו) משמש רק ב-SOURCE של ה-HEAD ([מקור המסמך כולו](#מקור-המסמך-כולו)). SOURCE עם Target `0` ב-BODY הוא invalid. ראיה לרשומה של מסמך אחר מצרפים בתוך אותו מסמך.
- ה-Origin הוא Reference. סמן מקום מקבל רק `0x0000` (ABSENT) ו-`0x0001` (UNKNOWN-VALUE). אינו מקבל NO-VALUE (`0x0002`) ולא Value.
- מסמך המפרט של geul.org `0x0000/0x0000000000001020` (השם `source`) קובע ב-Target את [CODEC](/he/grammar/edge/codec/) LOCAL (`0008`), וב-Origin את CODEC `0780` (כל Reference), `0000` (ABSENT, רשות) ו-`0001` (UNKNOWN-VALUE).
- לסדר בין SOURCE של אותו Target אין משמעות. גם לסדר הפריטים בתוך ציטוט אחד אין משמעות (סדר ערכים של אותו מאפיין נשמר כסדר המסמך).
- SOURCE אינה משנה אם היעד נכון או שקרי. היא רק רושמת מאיפה היעד בא. תוצאת הכרעה היא תפקידה של `VERDICT` ב-[TOULMIN](/he/grammar/edge/toulmin/).

## מקור המסמך כולו

המקור של המסמך כולו (dump מקורי, מהדורה, קובץ טקסט מקורי) נכתב כ-**SOURCE עם Target `0` ב-HEAD**. גם ה-QUALIFIER שה-Target שלו הוא אותו SOURCE (hash הטקסט המקורי P4092, זמן הקבלה P813, טווח בטקסט המקורי וכד') ממוקמים ב-HEAD ([מסמך](/he/grammar/document/#head-ו-body)).

- אלה ה-Edge היחידות שאפשר להציב ב-HEAD. כל Edge אחרת ממוקמת ב-BODY.
- ה-QUALIFIER של ה-HEAD ממוקם אחרי ה-SOURCE של ה-HEAD שהוא מצביע עליו. המפענח קורא מההתחלה ומפריד בין HEAD ל-BODY.
- QUALIFIER שה-Target שלו הוא SOURCE של ה-HEAD ושממוקם ב-BODY הוא invalid. SOURCE ו-QUALIFIER ב-BODY אינם מצביעים על Edge של ה-HEAD.
- **ה-Edge Id משותף ל-HEAD ול-BODY במרחב מספרים אחד.** הוא ייחודי בתוך המסמך, מתקבל מ-[NEXT-LOCAL-ID](/he/grammar/meta/lineage/next-local-id/) כמו Edge אחרת, וכשיוצרים את המסמך מחדש עם אותו תוכן, ממשיכים עם אותו מספר. גם בגרסה שבה HEAD Edge נעדרת, לא משתמשים שוב במספר שלה.
- אם ה-Origin הוא LOCAL, ההגדרה שלו (REFERENCE-NODE, TRIPLE של מקור) ממוקמת ב-BODY. תחום LOCAL הוא המסמך כולו.
- HEAD Edge אינה Meta של מחלקת האימות, ולכן היא נכללת ב-[hash התוכן](/he/grammar/document/#hash-תוכן). ב-diff היא מוחלפת כולה יחד עם ה-HEAD (לא רושמים אותה ב-`DELTA-REMOVE`).
- אין Meta נפרד למקור של המסמך כולו. טווח בטקסט המקורי וזמן ההשגה שנכתבים ב-Meta אינם יכולים להבהיר אל איזה מקור הם מתייחסים כשיש כמה מקורות. QUALIFIER שמצורף ל-SOURCE קובע זאת באמצעות ה-Target.

דוגמה: ה-HEAD של מסמך Q42 שהועבר מ-dump של Wikidata (ה-Edge Id לצורך הסבר).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         גרסת הישות (revision)
#1741 SOURCE     #0     #1740                                         קובץ ה-dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            hash הקובץ
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    זמן הקבלה
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      זמן שמירת הגרסה
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  כתובת קבועה של הגרסה
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- הגרסה וה-dump הם מקורות שונים, ולכן יש שני SOURCE. הגרסה היא מקור התוכן (אפשר לקבל את אותו תוכן שוב דרך הכתובת הקבועה), וה-dump הוא הקובץ שממנו התקבלה הגרסה הזו. hash הקובץ וזמן הקבלה הם תכונות של צד הציטוט לגבי קובץ ה-dump, ולכן הם מצורפים ל-SOURCE של ה-dump.

## ייצוג של ראיות אחרות

במשפחת הראיות יש רק SOURCE. ראיות אחרות נכתבות כ-QUALIFIER.

| ראיה | איך כותבים | Property |
|---|---|---|
| טווח בתוך הטקסט המקורי | QUALIFIER ל-SOURCE. SOURCE אחד לכל טווח | עמוד P304, סעיף P958, ציטוט P1683. טווח תווים הוא מונח של GEUL (טרם נקבע) |
| זמן קבלת חומר המקור | QUALIFIER ל-SOURCE | תאריך גישה P813 |
| hash של בייטי הטקסט המקורי (נעילת מהדורה) | QUALIFIER ל-SOURCE | checksum P4092, הערך הוא [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/) וכד' |
| מי יצר (אדם, מודל, מנוע כללים) | QUALIFIER ל-SOURCE (מי שיצר את הציטוט) או ליעד | מונח של GEUL (טרם נקבע) |
| מידת אמון | QUALIFIER ליעד | מונח של GEUL (טרם נקבע), הערך 0~1 כמו Meta [CONFIDENCE](/he/grammar/meta/verification/confidence/) |
| תקופת תחולה לפי סעיף | QUALIFIER ליעד | התחלה P580, סוף P582 |
| רשומה ישנה לפני העברה, פיצול או איחוד | QUALIFIER ליעד, הערך הוא ה-Edge Id הישן (LOCAL) | P1365 (replaces) |
| הגרסה שנכנסה ראשונה | לא נשמרת. מחשבים מהיסטוריית הגרסאות (git blame) | |

## דוגמה (לא נורמטיבית)

Q42 P19 (מקום לידה) Q350, ה-TRIPLE של היעד `#178`. ב-dump של Wikidata מ-2026-10-19 יש לטענה זו חמישה מקורות, ומוצגים שלושה מהם. ③, כתבה ב-Telegraph (`#1358`~`#1367`), זהה בצורתו ל-②, ו-⑤, Store norske leksikon (Q746368), זהה בצורתו ל-①, ולכן הושמטו.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: בלי תיאור מקור, P248 אחד בלבד
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

- ב-① אין תיאור מקור ויש P248 אחד, ולכן המקור הוא הפריט הזה. `#1347` הוא TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- מקור שיש לו URL אחד בלבד: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- מקור שיש בו רק "imported from" של ויקיפדיה האנגלית: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. ה-Origin `0x0000` הוא WORD אחד.

## שאלות פתוחות

- מונחי GEUL (מסמך הגדרת מונח ו-ID) שיבטאו טווח תווים, מי יצר ומידת אמון.
- כשתיאור המקור אינו מזהה את המקור (ציטוט שיש בו רק שפה וכד'), שיתוף אותו תיאור ב-LOCAL אחד יקבע ששני מקורות שונים הם אותו מקור.
- רשימת מאפייני מקור וציטוט למקורות מחוץ ל-Wikidata (חקיקה, ציטוט מהרשת).
- מקור של מקור (שרשרת): האם לצרף SOURCE נוסף ל-LOCAL של המקור.

## דפים קשורים

- [Edge](/he/grammar/edge/), [TRIPLE](/he/grammar/edge/triple/), [QUALIFIER](/he/grammar/edge/qualifier/), [REFERENCE-NODE](/he/grammar/edge/reference-node/), [סמן מקום](/he/grammar/reference/slot-marker/)
- [מסמך](/he/grammar/document/) (HEAD ו-BODY), [Meta — מוצא](/he/grammar/meta/provenance/)
