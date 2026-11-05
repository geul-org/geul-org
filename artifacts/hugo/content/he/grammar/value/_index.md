---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value הוא רשומה הנושאת את הערך עצמו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value הוא רשומה הנושאת את הערך עצמו. ה-Codec קובע את פירוש ה-Payload.

## פריסה {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      קטעים 3·4 (0x060L~0x09FL)
[Length TAG הרחבה]
[Codec TAG הרחבה] כשזה פורמט Issuer
Payload
```

- `LLLL` הוא מספר ה-WORD הכולל, כולל ה-TAG WORD, פחות 1. ל-1~14 WORD יש אורך ישיר, ומ-15 WORD ומעלה אורך מורחב.
- בפורמט Issuer, ב-Codec TAG של ההרחבה מונחים ה-Issuer (ברוחב 2/4/16 WORD שה-Codec קובע) ומספר Codec של 2 WORD. מספר ה-Codec נקבע על ידי ה-Issuer.
- מפענח יודע גם בלי להכיר את הפורמט עד Kind, ‏Length, ‏Issuer ומספר Codec.

## משפחה {#계열}

מספר Value אינו מציין משפחה. הקוד הישיר אינו מציין משפחה בסיביות, ולפורמטי Issuer אין כלל משפחה. משפחה היא קבוצה לפי נושא.

| משפחה | קודים ישירים |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- ערכים מספריים כמו וקטורים, טנזורים, מספרים מרוכבים, שברים וטווחים הם NUMERIC. היוצא מן הכלל הוא BIT-VECTOR, שהוא BINARY. קודי שפה הם TEXT.
- רשומת פורמט Issuer מקבלת Codec TAG של הרחבה (Issuer ומספר Codec). אם ה-Payload ארוך (סך הכול 15 WORD ומעלה) משתמשים ב-Length TAG של הרחבה.

## קודים ישירים {#직접-코드}

| Codec | שם | משפחה | תיאור |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false או true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | מספר שלם במשלים ל-2 ב-WORD המינימלי |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | מספר שלם ללא סימן ב-WORD המינימלי |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | קו רוחב וקו אורך של כדור הארץ (WGS 84) וחוסר ודאות (Reference של יחידה) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference של גרם שמים, קו רוחב וקו אורך, וחוסר ודאות (Reference של יחידה) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | כמות מספרית (מספר שלם, BINARY-FLOAT, מספר עשרוני, שבר), Reference של יחידה, חסם תחתון ועליון |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | שבר ששומר על הכתיב (רשומות מונה ומכנה, ללא צמצום) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, מקדם עם סימן |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, מקדם ללא סימן |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | מספר הימים מ-1970-01-01 (לוח גרגוריאני) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | ננו-שניות מחצות |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | שניות מ-Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | זמן שחלף (שניות) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | מחרוזת תאריך מורחבת של ISO 8601-2 (דיוק של שנה וחודש, אי-ודאות, טווח) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | מחרוזת תאריך של GEDCOM 7 (לוח יוליאני וכו', לוחות שנה אחרים) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | מחרוזת UTF-8 חסרת שפה |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI לפי RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | תג שפה של BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | טקסט בעל שפה |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | קוד שפה דחוס של WORD אחד |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID לפי RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | תוצאת SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | תוצאת SHA-1 (למטרות זיהוי כמו מזהה אובייקט של git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | רצף בייטים שמשמעותו וצורתו אינן ידועות. בייטים זוגיים ואי-זוגיים |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N סיביות השמורות MSB-first אחרי bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | זמן שחלף (ננו-שניות) |

- קודים המזווגים כזוגי/אי-זוגי הם רצפי בייטים באורך משתנה. בקוד הזוגי מספר הבייטים זוגי, ובקוד האי-זוגי הוא אי-זוגי ([רשומה ו-TAG WORD](../record.md)).
- הקודים הישירים נמצאים ב-`0x060L~0x081L` ללא Reserved. ‏`0x082L~0x09CL` הם Reserved, ו-`0x09DL~0x09FL` הם [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## פורמט Issuer {#issuer-형식}

פורמט שאינו בקוד ישיר ממוקם תחת ה-Issuer של הגוף שקבע אותו, כמספר Codec. פורמט מקובל שאין לו גוף קובע ממוקם תחת ADHOC (‏`0x00000002`). פורמטים ייחודיים ל-GEUL (OPAQUE-BYTES, ‏BIT-VECTOR, ‏DURATION-NANOSECONDS) הם קודים ישירים.

| Issuer | דוגמאות לפורמטים |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, וקטורים של מספרים שלמים וממשיים, טנזורים, מספרים מרוכבים, שברים, טווחים, קווטרניונים, BLAKE3 |
| IETF `0x00000007` | URI יחסי, CRC32C, כתובות IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, חותמת זמן POSIX בננו-שניות, כתובת MAC |
| KHRONOS `0x0000000E` | פיקסלים RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | חותמת זמן TAI |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | חותמת זמן GPS |

- מפענח שאינו מכיר את הפורמט יודע עד ה-Issuer ומספר ה-Codec, ומדלג באמצעות Length.
- מסמך ה-Codec מונח תחת `codecs/` של אותו Issuer, לפי מספר ה-Codec של הרשומה. לדוגמה: CRC32C של IETF נמצא ב-`0x00000007/codecs/0x0000C000/` ([כתובת פרסום ורשימת גרסאות](../publishing.md)).
- ביצירות גדולות כמו תמונות וסרטונים מומלץ להפנות באמצעות URI ו-SHA-256 ולא להכניסן ישירות.
- יצירה שבתוך רצף הבייטים כפופה לרישיון המקורי שלה. מקור ורישיון נרשמים כ-Meta.

## קבוצות פורמטים {#형식-묶음}

התיאור לכל קבוצה נמצא להלן. הפריסה, הפירוש, התוקף והדוגמאות של כל פורמט נמצאים במסמך הפורמט.

| קבוצה | משפחה | פורמטים |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, מספרים שלמים, נקודה צפה, קואורדינטות, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | תאריך, שעה, חותמת זמן, זמן שחלף, EDTF, תאריך GEDCOM |
| [text](#text) | TEXT | טקסט UTF-8, טקסט בעל שפה, URI, קוד שפה |
| [binary](#binary) | BINARY | UUID, digest, CRC, כתובת רשת, רצף בייטים לא ידוע, וקטור סיביות |
| [vector](#vector) | NUMERIC | וקטורים צפופים של מספרים שלמים וממשיים, נקודה ותיבה תוחמת, פיקסלים RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | טנזורים dense·packed עם פורמט, rank ו-shape |
| [etc](#etc) | NUMERIC | מספרים מרוכבים, שברים, טווחים סגורים, קווטרניונים |

- הקבוצות vector, ‏tensor ו-etc הן כולן פורמטי Issuer (ADHOC, ‏KHRONOS) של משפחת NUMERIC.

### numeric {#numeric}

פורמטי המספרים הבסיסיים של משפחת NUMERIC. ממוקמים בקודים הישירים `0x060L~0x067L`.

- יש BOOL, מספרים שלמים עם סימן וללא סימן, נקודה צפה בינארית של IEEE 754, קואורדינטות של כדור הארץ (WGS 84) ושל גרמי שמים, QUANTITY המאגד כמות, יחידה וגבולות, ו-FRACTION, שבר בכתיב המקור.
- מספר שלם נכתב ב-WORD המינימלי שהערך נכנס בו.
- לפורמטי Issuer סקלריים קטנים (BFLOAT16, ‏FP8, ‏FP4) הוקצו רק מספרי Codec ואין להם מפרט מפורט (בעיה פתוחה ב-[Value](#열린-문제)).
- וקטורים, טנזורים, מספרים מרוכבים, שבר מצומצם (RATIONAL-I64) וטווחים הם גם משפחת NUMERIC, אך מכיוון שהם פורמטי Issuer הם ממוקמים בקבוצות [vector](#vector), ‏[tensor](#tensor) ו-[etc](#etc).

### decimal {#decimal}

משפחת DECIMAL היא פורמטים של מספרים עשרוניים מדויקים. ממוקמים בקודים הישירים `0x068L~0x069L`.

- הקודים הישירים SIGNED-DECIMAL ו-UNSIGNED-DECIMAL נכתבים כ-`C × 10^E` ונושאים כפי שהם את מספר הספרות של הכתיב המקורי. `1.20` (‏`C=120, E=−2`) ו-`1.2` (‏`C=12, E=−1`) הן רשומות שונות. שוויון ערכים ושימור ה-quantum הם בעיה פתוחה של [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- קידוד DPD·BID של IEEE 754 decimal32/64/128 הוא פורמט של ה-Issuer ‏IEEE (‏`0x0000000D`).

### time {#time}

משפחת TIME היא פורמטים של תאריך ושעה. ממוקמים בקודים הישירים `0x06AL~0x071L` ו-`0x081L` (DURATION-NANOSECONDS).

| דיוק | פורמט |
|---|---|
| תאריך (לוח גרגוריאני) | GREGORIAN-DATE |
| שנה וחודש, אי-ודאות, טווח | EDTF |
| כתיב מקורי של לוח שנה אחר (יוליאני וכו') | GEDCOM-DATE |
| שעה | חותמות זמן POSIX·TAI·GPS |
| זמן שחלף | DURATION-SECONDS, DURATION-NANOSECONDS |

- תאריך שאפשר לכתוב ב-GREGORIAN-DATE אינו נכתב ב-EDTF.
- חותמות זמן בננו-שניות ופורמטי TAI·GPS הם פורמטים תחת ה-Issuer של גוף התקינה המתאים (IEEE, ‏BIPM, ‏GPS).

### text {#text}

משפחת TEXT היא פורמטים של טקסט ושל מזהי מחרוזת. ממוקמים בקודים הישירים `0x072L~0x07AL`.

- מחרוזת חסרת שפה היא UTF8-TEXT, וטקסט בעל שפה כמו שם, כותרת ומשפט הוא UTF8-LANGUAGE-TEXT.
- גם קודי שפה (LANGUAGE-SHORT-CODE, ‏LANGUAGE-BCP47-CODE) הם משפחת TEXT.
- רצף בייטים באורך משתנה מוצג בזוג Codec זוגי/אי-זוגי. אם הסיבית הנמוכה ביותר היא `1`, מספר הבייטים אי-זוגי והבייט התחתון של ה-WORD האחרון הוא padding של `0x00` ([רשומה ו-TAG WORD](../record.md)).

### binary {#binary}

משפחת BINARY היא פורמטים של רצפי בייטים. ממוקמים בקודים הישירים `0x07BL~0x080L`.

- UUID, ‏SHA-256, ‏SHA-1, רצף בייטים לא ידוע (OPAQUE-BYTES) ווקטור סיביות (BIT-VECTOR) הם קודים ישירים. שאר ה-digest, ‏CRC32C וכתובות IPv4·IPv6·MAC הם פורמטי Issuer.
- ערכים בגודל קבוע (UUID, ‏digest, כתובת) גודלם קבוע, ולכן אין להם זוג זוגי/אי-זוגי.
- מדיה ציבורית כמו תמונות וסרטונים ממוקמת בפורמטים של ה-Issuer ‏IANA (‏`0x00000008`). מספרי Codec מוקצים בזוגות זוגי/אי-זוגי וה-Payload הוא רצף בייטים. תקרת ה-Length היא 2^32−1 WORD. ערכים גדולים מומלץ להפנות אליהם באמצעות URI ו-SHA-256 ולא להכניס ישירות.
- יצירה שבתוך רצף הבייטים כפופה לרישיון המקורי שלה. מקור ורישיון נרשמים כ-Meta.

### vector {#vector}

פורמטי וקטור הם פורמטי Issuer של משפחת NUMERIC. וקטורים צפופים של מספרים שלמים וממשיים ונקודה ותיבה תוחמת ממוקמים ב-ADHOC (‏`0x00000002`) במספרי Codec ‏`0x00000500`~`0x0000050C`, ופורמטי פיקסלים תחת KHRONOS (‏`0x0000000E`).

- רכיבי וקטור צפוף נשמרים ברצף ב-big-endian.
- מכיוון שהם פורמטי Issuer, ב-Codec TAG של ההרחבה מצטרפים Issuer של 2 WORD ומספר Codec של 2 WORD.

### tensor {#tensor}

פורמטי טנזור הם פורמטי Issuer של משפחת NUMERIC. ממוקמים ב-ADHOC (‏`0x00000002`) במספרי Codec ‏`0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR נושא פורמט רכיב, ‏rank, ‏shape ו-payload צפוף C-contiguous.
- DESCRIBED-PACKED-TENSOR נושא פורמט packed, ‏rank, ‏shape ו-payload ארוז low-bit-first בתוך octet.

### etc {#etc}

פורמטי מספרים אחרים הם פורמטי Issuer של משפחת NUMERIC. ממוקמים ב-ADHOC (‏`0x00000002`) במספרי Codec ‏`0x00000700`~`0x00000704`.

- יש מספרים מרוכבים (COMPLEX64, ‏COMPLEX128), שבר מנורמל (RATIONAL-I64), טווח סגור של binary64 וקווטרניון של binary32.

## טקסט {#텍스트}

טקסט בעל שפה וטקסט חסר שפה הם ערכים שונים. "Paris" (מחרוזת) ו-"Paris" (צרפתית) אינם שווים.

| פורמט | היכן משתמשים |
|---|---|
| UTF8-TEXT | מחרוזת חסרת שפה כמו מזהה, קוד, שם קובץ ו-ID חיצוני |
| UTF8-LANGUAGE-TEXT | טקסט בעל שפה כמו שם, כותרת ומשפט |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = בייטי הטקסט אי-זוגיים)
[Length TAG הרחבה]
שפה               רשומת LANGUAGE-SHORT-CODE או LANGUAGE-BCP47-CODE
טקסט              בייטי UTF-8 (אם אי-זוגי, האחרון 0x00)
```

- הטקסט הוא UTF-8 well-formed ונשמר כפי שהוא במקור. הנרמול באחריות הצד שמשווה ומאנדקס.
- שם משותף לשפות רבות נכתב עם השפה `mul`, ושפה לא מוגדרת עם `und`. מחרוזת חסרת תוכן לשוני היא UTF8-TEXT.

דוגמה: `"Douglas Adams"@en` (13 בייטים, אי-זוגי)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   שפה en    D o  u g  l a  s ␠  A d  a m  s (padding)
```

## מספרים עשרוניים וכמויות {#10진수와-수량}

מספר עשרוני מדויק נכתב כ-`C × 10^E`. המעריך `E` הוא 32 סיביות, והמקדם `C` הוא במשלים ל-2 ב-WORD המינימלי. מספר הספרות של הכתיב המקורי נשמר כפי שהוא: `1.20` הוא `C=120, E=−2`, ו-`1.2` הוא `C=12, E=−1`. שני הכתיבים מייצגים אותו מספר אך הם רשומות נפרדות שהבייטים שלהן שונים. המקודד אינו מנרמל את הכתיב באופן שרירותי. שוויון הערכים של שתי הרשומות ומשמעות ה-quantum (ספרות משמעותיות) הם בעיה פתוחה ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY נושא כמות, יחידה וגבולות כערך אחד.

```
TAG WORD          0000 0110 0110 LLLL
[Length TAG הרחבה]
כמות              רשומת Value מספרית (מספר שלם, BINARY-FLOAT, מספר עשרוני, שבר)
יחידה             רשומת Reference (פריט יחידה), ללא יחידה 0x0000
חסם תחתון         רשומת Value מספרית, אם מושמט 0x0000 ABSENT
חסם עליון         רשומת Value מספרית, אם מושמט 0x0000 ABSENT
```

- היחידה היא חלק מהערך. לא רושמים את היחידה בנפרד במקום אחר (אם מפרידים, אי אפשר לדעת אם `652` הוא ק"מ או מטר).
- לא נושאים ערך שהומר ליחידות SI. אפשר לחשב אותו מהיחידה ומטבלת ההמרה.
- ‏`0x0000` הוא סימן ABSENT שפירושו ששדה אופציונלי הושמט ([מסמך המפרט של Codec](../codec-spec.md)).

דוגמה: `652 km`, טווח `[651, 653]` (ק"מ = Q828224 ב-Wikidata)

```
066E 0011                    TAG (אורך מורחב 17 WORD)
0683 0000 0000 028C          כמות 652
0142 000C A340               יחידה Q828224
0683 0000 0000 028B          חסם תחתון 651
0683 0000 0000 028D          חסם עליון 653
```

## תאריך {#날짜}

| דיוק | פורמט |
|---|---|
| תאריך (לוח גרגוריאני) | GREGORIAN-DATE |
| שנה וחודש, אי-ודאות (`1971~`), טווח | EDTF |
| כתיב מקורי של לוח שנה אחר (יוליאני וכו') | GEDCOM-DATE |
| שעה | חותמות זמן POSIX·TAI·GPS |

- תאריך שאפשר לכתוב ב-GREGORIAN-DATE אינו נכתב ב-EDTF.

## בעיות פתוחות {#열린-문제}

- פורמטי מדיה ציבוריים (JPEG, ‏PNG, ‏MP4, ‏MOV וכו') ממוקמים במספרי Codec של ה-Issuer ‏IANA (‏`0x00000008`). דרך לנהל את טבלת ההתאמה בין סוג מדיה למספר Codec.
- הרשימה הסופית של הקודים הישירים של Value. תיקבע לאחר מדידת תדירות ה-Value במדגם של חוקים ושיחות עבודה (מועמדים: סכום כסף, אחוז, טווח תאריכים).
- המפרט המפורט והפריסה של 7 הסקלרים הקטנים (ADHOC ‏BFLOAT16, ארבעת ה-FP8 של ONNX, ‏FP8-E8M0FNU·FP4-E2M1FN של OCP). טרם הוחלט אם להעבירם לקודים ישירים. כרגע הוקצו רק מספרי Codec.
