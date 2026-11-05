---
title: "דוגמה: פריט Wikidata"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "קוראים מסמך קטן על פריט Wikidata ‏Q42 (Douglas Adams) מתחילתו ועד סופו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

קוראים מסמך קטן על פריט Wikidata ‏Q42 (Douglas Adams) מתחילתו ועד סופו. תוכנו:

- שם באנגלית: Douglas Adams
- Q42 הוא מופע (instance) של אדם (Q5) (P31).
- Q42 התחנך ב-St John's College (Q691283) (P69). זמן ההתחלה (P580) הוא שנת 1971.

המסמך הוא המסמך `0x510000000000002A` של Issuer ‏`0x00000001`, ואורכו הכולל 63 WORD (126 בתים).

## כולו {#전체}

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD {#head}

```
1C01 003F
```

‏`1C01` הוא Meta (קטע 14), ‏Codec ‏`0x1C0L` (DOC-1WORD), ‏Length של 2 WORD. הערך `003F` (63) הוא מספר ה-WORD הכולל של המסמך. המפענח יודע בעזרתו מראש היכן המסמך מסתיים.

```
1C51 0001
```

‏Meta ‏`0x1C5L` ‏SPEC-VERSION. גרסת המפרט שהמסמך מציית לה. v1 הוא `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

‏Meta ‏`0x1C7L` ‏DOC-ID, בסך הכול 10 WORD. ה-Payload הוא Reference אחד מסוג DOC-POINTER.

| WORD | משמעות |
|---|---|
| `0418` | Reference, ‏Codec ‏`0x041L` (DOC-POINTER), ‏9 WORD |
| `0000 0001` | ‏Issuer ‏`0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ID של המסמך `0x510000000000002A` |
| `0000 0000` | גרסה `0` (עצמו) |

```
1C30
```

‏BODY. ה-HEAD מסתיים וה-BODY מתחיל.

## BODY {#body}

### #1 LABEL — שם באנגלית {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | משמעות |
|---|---|
| `0A4E` | ‏Edge, ‏Codec ‏`0x0A4L` ‏LABEL, ‏Length ‏`1110` (מורחב) |
| `0010` | אורך מורחב: בסך הכול 16 WORD |
| `0051 0001` | ‏Edge Id: ‏LOCAL ‏1 |
| `0141 002A` | ‏Subject: ‏Q42 ב-Wikidata |
| `0799` | ‏Object: ‏UTF8-LANGUAGE-TEXT, מספר בתים אי-זוגי (`0x079L`), ‏10 WORD |
| `0761 656E` | שפה: ‏BCP 47 ‏`en` |
| `446F … 7300` | ‏`Douglas Adams`, ‏13 בתים + ריפוד `00` |

### #2 TRIPLE — Q42 הוא אדם {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | משמעות |
|---|---|
| `0AA9` | ‏Edge, ‏Codec ‏`0x0AAL` ‏TRIPLE, ‏10 WORD |
| `0051 0002` | ‏Edge Id: ‏LOCAL ‏2 |
| `0191 001F` | ‏Predicate: ‏P31 (instance of) |
| `0141 002A` | ‏Subject: ‏Q42 |
| `0141 0005` | ‏Object: ‏Q5 (אדם) |
| `0000` | ‏Rank: ‏normal |

### #3 TRIPLE — Q42 התחנך ב-St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | משמעות |
|---|---|
| `0AAA` | ‏Edge, ‏TRIPLE, ‏11 WORD |
| `0051 0003` | ‏Edge Id: ‏LOCAL ‏3 |
| `0191 0045` | ‏Predicate: ‏P69 (educated at) |
| `0141 002A` | ‏Subject: ‏Q42 |
| `0142 000A 8C53` | ‏Object: ‏Q691283. הערך חורג מ-16 ביט, ולכן זה Reference של 3 WORD |
| `0000` | ‏Rank: ‏normal |

### #4 QUALIFIER — זמן התחלה 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | משמעות |
|---|---|
| `0AB9` | ‏Edge, ‏Codec ‏`0x0ABL` ‏QUALIFIER, ‏10 WORD |
| `0051 0004` | ‏Edge Id: ‏LOCAL ‏4 |
| `0191 0244` | ‏Property: ‏P580 (start time) |
| `0051 0003` | ‏Target: ‏#3 (ה-TRIPLE שלמעלה) |
| `06E2 3139 3731` | ‏Value: ‏EDTF ‏`1971` (דיוק של שנה, ולכן EDTF ולא GREGORIAN-DATE) |

משמעותו של #3 היא #3 עצמו יחד עם כל ה-QUALIFIER המצביעים עליו: "Q42 התחנך ב-St John's College מאז 1971."

```
1C40
```

‏END. עד כאן 63 WORD.

## קריאה בלי ספר Codec {#코덱북-없이-읽으면}

גם מפענח שאינו מכיר את ספר ה-Codec יודע את הדברים הבאים.

- המסמך הוא 63 WORD, וב-HEAD יש 2 רשומות Meta וב-BODY יש 4 רשומות Edge.
- ה-Codec של כל Edge (‏LABEL, ‏TRIPLE, ‏TRIPLE, ‏QUALIFIER) וה-Edge Id שלו (1, 2, 3, 4).
- מיקום הרשומה הבאה אחרי כל רשומה.

את תפקידי הרכיבים (‏Predicate, ‏Subject, ‏Object, ‏Rank) אפשר לדעת רק מקריאת [מסמך המפרט](codec-spec.md) של כל Codec.

## Hash תוכן {#내용-해시}

ה-hash של תוכן המסמך (SHA-256) הוא: עם הפרסום, ה-hash הזה נרשם ברשימת הגרסאות יחד עם ID הגרסה.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
