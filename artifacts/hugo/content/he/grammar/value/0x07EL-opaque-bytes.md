---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES הוא רצף בייטים שרירותי שהפורמט עצמו אינו קובע את משמעותו ואת צורתו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES הוא רצף בייטים שרירותי שהפורמט עצמו אינו קובע את משמעותו ואת צורתו. קוד ישיר של Value ‏`0x07EL` (בייטים זוגיים) ו-`0x07FL` (בייטים אי-זוגיים), משפחה BINARY. מספר הבייטים נקבע לפי הסיבית הנמוכה ביותר של ה-Codec ומספר ה-Payload WORD. הוא `2 × מספר Payload WORD − הסיבית הנמוכה ביותר`, ואין Byte Count ([Value](_index.md)).

| פריט | ערך |
|---|---|
| שם | `OPAQUE-BYTES` (קבוצת זוגי/אי-זוגי. שם כל קוד בטבלת החברים להלן) |
| TAG ID | `0x07EL`·`0x07FL` |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 30~31 |
| Kind | Value · משפחה: BINARY |
| תיאור באינדקס | רצף בייטים שמשמעותו וצורתו אינן ידועות. בייטים זוגיים ואי-זוגיים |
| בצד Hugo | `value/binary/opaque-bytes.md` |

## חברים {#구성원}

דף זה עוסק בשני קודים של זוג זוגי/אי-זוגי יחד. הקוד הזוגי הוא ערך שמספר הבייטים שלו זוגי, והקוד האי-זוגי הוא ערך שמספר הבייטים שלו אי-זוגי ([רשומה ו-TAG WORD](../record.md#가변-길이-바이트열)). מסמך Codec אחד לכל קוד. השדות בשני מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | מספר בייטים | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | זוגי | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | אי-זוגי | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | שארית ערך גולמי (`0xFFFF`) |  |  |

## פריסה {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length TAG הרחבה] כשהסך הכול 15 WORD ומעלה
Payload WORD 1st ... Nth   בייטים / zero padding בסוף
```

## פירוש ותוקף {#해석과-유효성}

- קוראים מה-Payload לפי הסדר מספר בייטים כמספר הבייטים. בתוך WORD הבייט העליון בא ראשון.
- מספר ה-Payload WORD הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי והבייט התחתון של ה-WORD האחרון אינו `00`, דוחים.
- אם הקוד הזוגי/אי-זוגי, מספר ה-Payload WORD ו-zero padding אינם תואמים זה לזה, דוחים.

## מעמד הפורמט {#형식-지위}

- זוג הקודים זוגי/אי-זוגי (`0x07EL` זוגי, ‏`0x07FL` אי-זוגי), פריסת ה-payload ו-zero padding ב-WORD האחרון אינם ציטוט של תקן תעשייתי חיצוני אלא framing ייחודי ל-GEUL.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, ה-Length TAG של ההרחבה (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG של ההרחבה נכלל גם הוא בסך הכול ([רשומה ו-TAG WORD](../record.md)).
- 0 בייטים נכתבים כרשומה של WORD אחד בקוד הזוגי (‏`0x07EL`) (TAG WORD בלבד) ([Value](_index.md)).

## דוגמה {#예시}

הבייטים `AB CD EF` הם 3 בייטים (אי-זוגי), ולכן `OPAQUE-BYTES-ODD` ‏(`0x07FL`), ‏Payload ‏`ABCD EF00`. הסך הכול 3 WORD, ולכן `LLLL=0010`.

```
07F2 ABCD EF00
```

רצף בייטים ריק הוא WORD אחד `07E0` (‏`OPAQUE-BYTES-EVEN`, ‏TAG WORD בלבד).

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000007E0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

למעלה מסמך ה-Codec של `OPAQUE-BYTES-EVEN` (‏`0x07EL`). במסמך ה-Codec של חבר אחר (`OPAQUE-BYTES-ODD`) שונים רק ה-Codec ID ב-DOC-ID, יעד ה-DECLARE והשם הקשור ב-`#1` (BIND).
