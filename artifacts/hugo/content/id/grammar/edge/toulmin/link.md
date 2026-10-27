---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK adalah layout yang menulis relasi antar node TOULMIN (serangan, pengesampingan, eksekusi, sambungan putusan, definisi, nama). Terdiri dari REF src·dst, WORD flag, gerbang keyakinan opsional, dan SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK adalah layout yang menulis relasi antar node pada graf TOULMIN. Jenis relasi ditetapkan oleh Codec (atau nomor format ISSUER GEUL).

## Codec

| Codec | Nama | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | aturan → aturan. Mengurangi putusan secara bertahap |
| `0x69` | SUPERSEDES | `X supersedes Y` | aturan → aturan. Jika Active, target dikeluarkan dari agregasi |
| `0x70` | RUN | `run c when n` | aturan → kasus |
| `0x71` | DO | `do fn when n` | aturan → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | aturan → FuncRef |
| `0x73` | UNDO | `undo fn when n` | aturan → FuncRef |
| `0x74` | CHECKING | `checking c` | aturan → kasus. Putusan tanpa efek samping |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | kasus → field |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | butir definisi → nilai·tipe |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | butir definisi → field |
| ISSUER `0x0000`/`0xC023` | RUNS | titik masuk `run c` | titik masuk → kasus (eksekusi) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | titik masuk `check c` | titik masuk → kasus (putusan) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | trigger `run c` | trigger → kasus |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | trigger → kasus |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | node → pengenal global |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | alias → path (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | nama backtick | node → TEXT. Penulisan nama |

## Layout

```
ID               record LOCAL Reference (Edge Id)
src              REF
dst              REF. DO·DO-ONCE·UNDO adalah FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         operator 1 WORD (2 bit atas) + Value UNSIGNED-DECIMAL (persen)
SPAN             lebar yang ditetapkan SOURCE × 2
```

| flag | Arti |
|---|---|
| b0 F_ONCE | Dilakukan hanya sekali (`once` pada UNDO) |
| b1 F_GATE | Ada field gerbang keyakinan |
| b2 F_STRIKE | Relasi yang dicoret |
| b3 F_ORDERED | Termasuk dalam daftar berurutan `1.` |

| Operator gerbang | Arti |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Interpretasi dan validitas

- REF adalah Edge Id record dokumen ini (field umum [TOULMIN](/id/grammar/edge/toulmin/#field-umum)).
- Bentuk dst ditetapkan oleh Codec. DO·DO-ONCE·UNDO adalah FuncRef (REF(ALIAS, 0 jika tidak ada) + VerbCode 1 WORD, [NODE](/id/grammar/edge/toulmin/node/#field)), LABEL·IMPORTED-FROM adalah REF record TEXT, dan sisanya adalah REF node.
- `do … once` dinyatakan oleh Codec DO-ONCE. F_ONCE tidak dipakai pada flags DO-ONCE (jika menyala, ditolak). `once` pada UNDO ditulis dengan F_ONCE.
- Operator gerbang adalah 2 bit atas WORD operator dan 14 bit sisanya adalah 0. Persen adalah Value UNSIGNED-DECIMAL dengan `E=0` dan bernilai 0~100.
- b4~b15 flags adalah cadangan dan harus 0. Jika tidak, ditolak.
- Rantai `A > B > C` pada SUPERSEDES ditulis dengan satu SUPERSEDES per pasangan.

## Halaman terkait

- [TOULMIN](/id/grammar/edge/toulmin/), [NODE](/id/grammar/edge/toulmin/node/), [SOURCE dan bagian](/id/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/)
