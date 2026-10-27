---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID adalah Reference deklarasi yang menunjuk item (Item) Wikidata dengan angka pada Q-id."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID adalah Reference deklarasi yang menunjuk item (Item) Wikidata. Bagian angka Q-id tanpa `Q` ditulis sebagai bilangan bulat tanpa tanda.

## Layout

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length extension TAG]
QID               unsigned big-endian dengan lebar terpendek
```

- QID ditulis dengan lebar terpendek. `Q1`~`Q65535` berukuran total 2 WORD, di atasnya 3 WORD.
- Data Wikidata adalah CC0.
- Jika Variable, itu adalah variabel anonim dari jenis yang ditunjuk item itu ([Reference](/id/grammar/reference/) Variable).

## Contoh

| Item | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/), [TRIPLE](/id/grammar/edge/triple/)
