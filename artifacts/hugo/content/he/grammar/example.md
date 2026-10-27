---
title: "דוגמה: פריט Wikidata"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "קריאה מהתחלה ועד הסוף של מסמך GEUL בן 63 WORD, שמכיל שם אחד, שתי טענות ותנאי הגבלה אחד על Q42 (Douglas Adams) ב-Wikidata."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

נקרא מהתחלה ועד הסוף מסמך קטן על פריט Wikidata Q42 (Douglas Adams). התוכן שלו:

- שם באנגלית: Douglas Adams
- Q42 הוא instance של אדם (Q5) (P31).
- Q42 למד ב-St John's College (Q691283) (P69). זמן ההתחלה (P580) הוא 1971.

המסמך הוא של Issuer `0x00010000` עם מזהה מסמך `0x510000000000002a`, והוא בן 63 WORD (126 בייטים) בסך הכול.

## המסמך כולו

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880` הוא Meta (`11`), Length של 2 WORD, Codec `0x00` (DOC-1WORD). הערך `003f` (63) הוא מספר ה-WORD של המסמך כולו. המפענח יודע לפי הערך הזה מראש איפה המסמך נגמר.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. גרסת המפרט שהמסמך מציית לה. v1 הוא `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 10 WORD בסך הכול. ה-Payload הוא Reference אחד מסוג DOC-POINTER.

| WORD | משמעות |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | מזהה מסמך `0x510000000000002a` |
| `0000 0000` | גרסה `0` (עצמו) |

```
180e
```

BODY. ה-HEAD נגמר וה-BODY מתחיל.

## BODY

### #1 LABEL — שם באנגלית

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | משמעות |
|---|---|
| `1704` | Edge, Length `1110` (מורחב), Codec `0x04` LABEL |
| `0010` | אורך מורחב: 16 WORD בסך הכול |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Q42 ב-Wikidata |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORD, מספר אי-זוגי של בייטים (`0x4B`) |
| `08c6 656e` | שפה: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams`, 13 בייטים + ריפוד `00` |

### #2 TRIPLE — Q42 הוא אדם

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | משמעות |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (אדם) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 למד ב-St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | משמעות |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. הערך חורג מ-16 ביט, ולכן זה Reference של 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — זמן התחלה 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | משמעות |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (ה-TRIPLE שלמעלה) |
| `0924 3139 3731` | Value: EDTF `1971` (דיוק של שנה, ולכן EDTF ולא GREGORIAN-DATE) |

המשמעות של #3 היא #3 עצמה יחד עם כל ה-QUALIFIER שמצביעים עליה: "Q42 למד ב-St John's College החל מ-1971."

```
180f
```

END. עד כאן 63 WORD.

## קריאה בלי codebook

גם מפענח שאינו מכיר את ה-codebook יודע את הדברים הבאים.

- המסמך הוא 63 WORD, וב-HEAD יש 2 Meta וב-BODY 4 Edge.
- ה-Codec של כל Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) וה-Edge Id (1, 2, 3, 4).
- המיקום של הרשומה הבאה אחרי כל רשומה.

את תפקיד הרכיבים (Predicate, Subject, Object, Rank) אפשר לדעת רק מקריאת [מסמך המפרט](/he/grammar/codec-spec/) של כל Codec.

## hash תוכן

hash התוכן (SHA-256) של המסמך הזה הוא כדלקמן. כשמפרסמים אותו, ה-hash נרשם ברשימת הגרסאות יחד עם מזהה הגרסה.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
