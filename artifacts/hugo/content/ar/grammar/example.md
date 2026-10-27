---
title: "مثال: عنصر ويكيداتا"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "قراءة من البداية إلى النهاية لمستند GEUL من 63 WORD يحوي اسماً واحداً وقضيتين وشرط تقييد واحداً لعنصر ويكيداتا Q42 (Douglas Adams)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

نقرأ من البداية إلى النهاية مستنداً صغيراً عن عنصر ويكيداتا Q42 (Douglas Adams). محتواه كالآتي.

- الاسم الإنجليزي: Douglas Adams
- Q42 نموذج (instance) من إنسان (Q5) (P31).
- تلقّى Q42 تعليمه في St John's College (Q691283) (P69). وزمن البداية (P580) هو عام 1971.

المستند هو مستند Issuer `0x00010000` ورقمه `0x510000000000002a`، وحجمه 63 WORD (126 بايتاً).

## المستند كاملاً

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

`1880` هي Meta (`11`)، وLength بـ 2 WORD، وCodec `0x00` (DOC-1WORD). والقيمة `003f` (63) هي العدد الكلي لـ WORD في المستند. يعرف decoder بهذه القيمة نهاية المستند مسبقاً.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. هي إصدار المواصفة الذي يتبعه هذا المستند. وفي v1 هي `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID، بإجمالي 10 WORD. Payload هو Reference واحد من نوع DOC-POINTER.

| WORD | المعنى |
|---|---|
| `0438` | Reference، 9 WORD، Codec `0111` (DOC-POINTER)، وQuantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | معرّف المستند `0x510000000000002a` |
| `0000 0000` | الإصدار `0` (يشير إلى نفسه) |

```
180e
```

BODY. ينتهي HEAD ويبدأ BODY.

## BODY

### #1 LABEL — الاسم الإنجليزي

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | المعنى |
|---|---|
| `1704` | Edge، وLength `1110` (موسع)، وCodec `0x04` LABEL |
| `0010` | الطول الموسع: 16 WORD في المجموع |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: عنصر ويكيداتا Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT، 10 WORD، عدد بايتات فردي (`0x4B`) |
| `08c6 656e` | اللغة: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 بايتاً + حشو `00` |

### #2 TRIPLE — Q42 إنسان

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | المعنى |
|---|---|
| `148a` | Edge، 10 WORD، Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (إنسان) |
| `0000` | Rank: normal |

### #3 TRIPLE — تلقّى Q42 تعليمه في St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | المعنى |
|---|---|
| `150a` | Edge، 11 WORD، TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. القيمة تتجاوز 16 بت فهو Reference من 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — زمن البداية عام 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | المعنى |
|---|---|
| `148b` | Edge، 10 WORD، Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (TRIPLE أعلاه) |
| `0924 3139 3731` | Value: EDTF `1971` (الدقة بالسنة، فهو EDTF لا GREGORIAN-DATE) |

معنى #3 هو مجموع #3 نفسه وكل QUALIFIER يشير إليه: "تلقّى Q42 تعليمه في St John's College منذ عام 1971."

```
180f
```

END. وبه يكتمل 63 WORD.

## القراءة دون codebook

يعرف decoder لا يملك codebook ما يلي.

- المستند من 63 WORD، وفي HEAD سجلا Meta، وفي BODY أربعة Edge.
- Codec كل Edge (LABEL وTRIPLE وTRIPLE وQUALIFIER) وEdge Id (1 و2 و3 و4).
- موضع السجل التالي لكل سجل.

أما أدوار المكوّنات (Predicate وSubject وObject وRank) فلا تُعرف إلا بقراءة [مستند المواصفة](/ar/grammar/codec-spec/) لكل Codec.

## تجزئة المحتوى

تجزئة المحتوى (SHA-256) لهذا المستند كالآتي. وعند نشره تُسجَّل هذه التجزئة في قائمة الإصدارات مع معرّف الإصدار.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
