---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID adalah Reference deklarasi yang menunjuk properti (Property) Wikidata dengan angka pada P-id."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID adalah Reference deklarasi yang menunjuk properti (Property) Wikidata. Bagian angka P-id tanpa `P` ditulis sebagai bilangan bulat tanpa tanda.

## Layout

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length extension TAG]
PID               unsigned big-endian dengan lebar terpendek
```

- PID ditulis dengan lebar terpendek. Nomor properti saat ini muat dalam 1 WORD sehingga totalnya 2 WORD, dan jika melebihi 65535 otomatis menjadi 3 WORD.
- Terutama dipakai pada posisi Predicate [TRIPLE](/id/grammar/edge/triple/) dan Property [QUALIFIER](/id/grammar/edge/qualifier/).

## Contoh

| Properti | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/), [TRIPLE](/id/grammar/edge/triple/), [QUALIFIER](/id/grammar/edge/qualifier/)
