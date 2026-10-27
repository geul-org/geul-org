---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value היא רשומה שמכילה את הערך עצמו. שני הביטים העליונים של ה-Codec קובעים את המשפחה (מספרים ועשרוני, זמן, טקסט, בינארי). פורמטים נפוצים הם קודים ישירים, והשאר הם פורמטי Issuer לפי גוף התקינה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value היא רשומה שמכילה את הערך עצמו. ה-Codec קובע את פירוש ה-Payload.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  בפורמט Issuer
Payload
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל TAG WORD, פחות 1. 1~14 WORD הם אורך ישיר, ו-15 WORD ומעלה הם אורך מורחב.
- בפורמט Issuer, ב-TAG הרחבת ה-Codec מוצבים ה-Issuer (ברוחב 1/2/4/16 WORD שה-Codec קובע) ומספר פורמט של WORD אחד. שני הביטים העליונים של מספר הפורמט הם המשפחה.
- המפענח יודע את המשפחה ואת ה-Length גם בלי להכיר את הפורמט.

## משפחות

שני הביטים העליונים של ה-Codec הם המשפחה. אותו כלל חל על קוד ישיר (7 ביט) ועל מספר פורמט Issuer (16 ביט). לכן יודעים את המשפחה גם בלי codebook.

| שני הביטים העליונים | משפחה | קוד ישיר | מספר פורמט |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL מתחלקים עוד לפי הביט השלישי. `000` הוא NUMERIC ו-`001` הוא DECIMAL.
- ערכים מספריים כמו וקטור, טנסור, מספר מרוכב, שבר וקטע הם NUMERIC. חריג: BIT-VECTOR הוא BINARY. קוד שפה הוא TEXT.
- רשומת פורמט Issuer נושאת TAG הרחבת Codec (Issuer ומספר פורמט). אם ה-Payload ארוך (15 WORD ומעלה בסך הכול), משתמשים ב-TAG הרחבת Length.

## קודים ישירים

| Codec | שם | משפחה | תיאור |
|---|---|---|---|
| `0x00` | [BOOL](/he/grammar/value/numeric/bool/) | NUMERIC | false או true |
| `0x01` | [SIGNED-INTEGER](/he/grammar/value/numeric/signed-integer/) | NUMERIC | מספר שלם בשיטת המשלים ל-2 במינימום WORD |
| `0x02` | [UNSIGNED-INTEGER](/he/grammar/value/numeric/unsigned-integer/) | NUMERIC | מספר שלם בלי סימן במינימום WORD |
| `0x03` | [BINARY-FLOAT](/he/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/he/grammar/value/numeric/coordinate-earth/) | NUMERIC | קו רוחב וקו אורך על כדור הארץ (WGS 84) ואי-ודאות (Reference של יחידה) |
| `0x05` | [COORDINATE-GEO](/he/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference של גרם שמים, קו רוחב וקו אורך, ואי-ודאות (Reference של יחידה) |
| `0x06` | [QUANTITY](/he/grammar/value/numeric/quantity/) | NUMERIC | כמות מספרית (שלם, BINARY-FLOAT, עשרוני, שבר), Reference של יחידה, גבול תחתון ועליון |
| `0x07` | [FRACTION](/he/grammar/value/numeric/fraction/) | NUMERIC | שבר ששומר על הכתיב שלו (רשומות מונה ומכנה, בלי צמצום) |
| `0x10` | [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, מקדם חתום |
| `0x11` | [UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, מקדם בלי סימן |
| `0x20` | [GREGORIAN-DATE](/he/grammar/value/time/gregorian-date/) | TIME | מספר ימים מאז 1970-01-01 (לוח גרגוריאני) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/he/grammar/value/time/civil-time-nanoseconds/) | TIME | ננו-שניות מאז חצות |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/he/grammar/value/time/posix-timestamp-seconds/) | TIME | שניות מאז epoch של Unix |
| `0x23` | [DURATION-SECONDS](/he/grammar/value/time/duration-seconds/) | TIME | זמן שחלף (שניות) |
| `0x24`/`0x25` | [EDTF](/he/grammar/value/time/edtf/) | TIME | מחרוזת תאריך מורחבת של ISO 8601-2 (דיוק של שנה·חודש, אי-ודאות, קטע) |
| `0x26`/`0x27` | [GEDCOM-DATE](/he/grammar/value/time/gedcom-date/) | TIME | מחרוזת תאריך של GEDCOM 7 (לוחות שנה אחרים כמו יוליאני) |
| `0x40`/`0x41` | [UTF8-TEXT](/he/grammar/value/text/utf8-text/) | TEXT | מחרוזת UTF-8 בלי שפה |
| `0x44`/`0x45` | [URI](/he/grammar/value/text/uri/) | TEXT | URI לפי RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/) | TEXT | תג שפה של BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/) | TEXT | קוד שפה דחוס של WORD אחד |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/he/grammar/value/text/utf8-language-text/) | TEXT | טקסט עם שפה |
| `0x60` | [UUID](/he/grammar/value/binary/uuid/) | BINARY | UUID לפי RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/) | BINARY | תוצאת SHA-256 |
| `0x62` | [SHA1-DIGEST](/he/grammar/value/binary/sha1-digest/) | BINARY | תוצאת SHA-1 (לצורכי זיהוי כמו מזהה אובייקט של git) |

- קודים שמזווגים כזוגי-אי-זוגי הם רצפי בייטים באורך משתנה. קוד זוגי הוא מספר זוגי של בייטים, וקוד אי-זוגי הוא מספר אי-זוגי ([רשומות ו-TAG WORD](/he/grammar/record/)).
- קוד ישיר שאינו בטבלה שמור.

## פורמטי Issuer

פורמט שאין לו קוד ישיר מוצב כמספר פורמט תחת ה-Issuer של הגוף שקבע אותו. פורמט מקובל שאין לו גוף מתקנן מוצב תחת ADHOC (`0x0001`), ופורמט ייחודי של GEUL מוצב תחת GEUL (`0x0000`).

| Issuer | פורמטים לדוגמה |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, וקטורים של מספרים שלמים וממשיים, טנסורים, מספרים מרוכבים, שברים, קטעים, קווטרניונים, BLAKE3 |
| IETF `0x0020` | URI יחסי, CRC32C, כתובות IPv4·IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, חותמת זמן POSIX בננו-שניות, כתובת MAC |
| KHRONOS `0x0041` | פיקסלים RGBA8·BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | חותמת זמן TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | חותמת זמן GPS |

- מפענח שאינו מכיר את הפורמט יודע רק את המשפחה לפי מספר הפורמט, ומדלג על ה-Payload.
- ערכים גדולים כמו תמונות וסרטונים מומלץ להצביע עליהם באמצעות URI ו-SHA-256 ולא להטמיע אותם ישירות.
- יצירה שבתוך רצף בייטים כפופה לרישיון המקורי שלה. המקור והרישיון נרשמים ב-Meta.

## קבוצות פורמטים

הפריסה, הפירוש, התקינות והדוגמאות של כל פורמט נמצאים במסמך של הקבוצה.

| קבוצה | משפחה | פורמטים |
|---|---|---|
| [numeric](/he/grammar/value/numeric/) | NUMERIC | BOOL, מספרים שלמים, נקודה צפה, קואורדינטות, QUANTITY, FRACTION |
| [decimal](/he/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/he/grammar/value/time/) | TIME | תאריך, שעה, חותמת זמן, זמן שחלף, EDTF, תאריך GEDCOM |
| [text](/he/grammar/value/text/) | TEXT | טקסט UTF-8, טקסט עם שפה, URI, קוד שפה |
| [binary](/he/grammar/value/binary/) | BINARY | UUID, digest, CRC, כתובות רשת, רצף בייטים לא מזוהה, וקטור ביטים |
| [vector](/he/grammar/value/vector/) | NUMERIC | וקטורים צפופים של מספרים שלמים וממשיים, נקודות ותיבות תוחמות, פיקסלים RGBA·BGRA |
| [tensor](/he/grammar/value/tensor/) | NUMERIC | טנסורים dense ו-packed עם פורמט, rank ו-shape |
| [etc](/he/grammar/value/etc/) | NUMERIC | מספרים מרוכבים, שברים, קטעים סגורים, קווטרניונים |

- הקבוצות vector, tensor ו-etc הן כולן פורמטי Issuer (ADHOC, KHRONOS) של משפחת NUMERIC.

## טקסט

טקסט עם שפה וטקסט בלי שפה הם ערכים שונים. "Paris" (מחרוזת) ו-"Paris" (בצרפתית) אינם זהים.

| פורמט | איפה משתמשים |
|---|---|
| UTF8-TEXT | מחרוזת בלי שפה כמו מזהה, קוד, שם קובץ ו-ID חיצוני |
| UTF8-LANGUAGE-TEXT | טקסט עם שפה כמו שם, כותרת ומשפט |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = הטקסט במספר אי-זוגי של בייטים)
[Length extension TAG]
שפה               רשומת LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE
טקסט              בייטים של UTF-8 (אם אי-זוגי, 0x00 בסוף)
```

- הטקסט הוא UTF-8 תקין ונשמר כמות שהוא במקור. נרמול הוא באחריות מי שמשווה ומאנדקס.
- שם משותף לכמה שפות נכתב עם שפה `mul`, ושפה לא מוכרעת עם `und`. מחרוזת שאין לה תוכן לשוני היא UTF8-TEXT.

דוגמה: `"Douglas Adams"@en` (13 בייטים, אי-זוגי)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   שפה en     D o  u g  l a  s ␠  A d  a m  s (ריפוד)
```

## עשרוני וכמות

מספר עשרוני מדויק נכתב כ-`C × 10^E`. המעריך `E` הוא 32 ביט, והמקדם `C` הוא בשיטת המשלים ל-2 במינימום WORD. הוא שומר את מספר הספרות של הכתיב המקורי: `1.20` הוא `C=120, E=−2`, ו-`1.2` הוא `C=12, E=−1`. שני הכתיבים מייצגים את אותו מספר אך הם רשומות נפרדות עם בייטים שונים. המקודד אינו מנרמל את הכתיב באופן שרירותי. שוויון הערכים של שתי הרשומות והמשמעות של quantum (ספרות משמעותיות) הם שאלה פתוחה ([SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/#שאלות-פתוחות)).

QUANTITY מכילה כמות, יחידה וגבולות כערך אחד.

```
TAG WORD          0000 1LLL L000 0110
[Length extension TAG]
כמות              רשומת Value מספרית (שלם, BINARY-FLOAT, עשרוני, שבר)
יחידה             רשומת Reference (פריט יחידה), 0x0000 אם אין יחידה
גבול תחתון        רשומת Value מספרית, 0x0000 ABSENT אם הושמט
גבול עליון        רשומת Value מספרית, 0x0000 ABSENT אם הושמט
```

- היחידה היא חלק מהערך. לא כותבים אותה בנפרד במקום אחר (בלעדיה אי אפשר לדעת אם `652` הוא ק"מ או מטר).
- לא שומרים ערך שהומר ליחידות SI. אפשר לחשב אותו מהיחידה ומטבלת ההמרה.
- `0x0000` (ABSENT) הוא סמן שמציין ששדה רשות הושמט ([מסמך מפרט Codec](/he/grammar/codec-spec/)).

דוגמה: `652 km`, טווח `[651, 653]` (km = Q828224 ב-Wikidata)

```
0F06 0011                    TAG (אורך מורחב 17 WORD)
0990 0000 0000 028C          כמות 652
0120 000C A340               יחידה Q828224
0990 0000 0000 028B          גבול תחתון 651
0990 0000 0000 028D          גבול עליון 653
```

## תאריך

| דיוק | פורמט |
|---|---|
| תאריך (לוח גרגוריאני) | GREGORIAN-DATE |
| שנה·חודש, אי-ודאות (`1971~`), קטע | EDTF |
| כתיב מקורי של לוח שנה אחר (יוליאני וכד') | GEDCOM-DATE |
| שעה | חותמות זמן POSIX·TAI·GPS |

- תאריך שאפשר לכתוב ב-GREGORIAN-DATE לא נכתב ב-EDTF.

## שאלות פתוחות

- פורמטי מדיה פומביים (JPEG, PNG, MP4, MOV וכד') מוצבים כמספרי פורמט BINARY תחת ה-Issuer של IANA (`0x0021`). איך מנהלים את טבלת ההתאמה בין סוג מדיה למספר פורמט.
- הרשימה הסופית של קודים ישירים ל-Value. נקבעת אחרי מדידת תדירות ה-Value במדגם של חקיקה ושיחות עסקיות (מועמדים: סכום כסף, אחוז, טווח תאריכים).
- המפרט המפורט והמיקום של שבעה סקלרים קטנים (ADHOC BFLOAT16, ארבעה FP8 של ONNX, OCP FP8-E8M0FNU ו-FP4-E2M1FN). טרם הוחלט אם להעביר אותם לטווח השמור של קודים ישירים של NUMERIC (`0x08`~`0x0F`). כרגע הוקצו להם רק מספרי פורמט.
