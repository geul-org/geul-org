---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK adalah layout yang menulis relasi antar node TOULMIN (serangan, pengesampingan, eksekusi, sambungan putusan, definisi, nama). Terdiri dari REF src·dst, WORD flag, gerbang keyakinan opsional, intensitas serangan opsional, dan SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK adalah layout yang menulis relasi antar node pada graf TOULMIN. Jenis relasi ditetapkan oleh Codec (atau nomor format ISSUER GEUL).

## Codec

| Codec | Nama | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | aturan → aturan. Mengurangi putusan secara bertahap sebesar intensitas serangan |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operator 1 WORD (2 bit atas) + Value UNSIGNED-DECIMAL (persen)
[F_FORCE]        SIGNED-DECIMAL Value. Intensitas serangan (0~1). Hanya ATTACKS
SPAN             lebar yang ditetapkan SOURCE × 2
```

| flag | Arti |
|---|---|
| b0 F_ONCE | Dilakukan hanya sekali (`once` pada UNDO) |
| b1 F_GATE | Ada field gerbang keyakinan |
| b2 F_STRIKE | Relasi yang dicoret |
| b3 F_ORDERED | Termasuk dalam daftar berurutan `1.` |
| b4 F_FORCE | Ada field intensitas serangan. Hanya ATTACKS |

| Operator gerbang | Arti |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Field bersyarat ditempatkan menurut urutan flag (F_GATE, F_FORCE). Field yang flag-nya mati tidak memakan tempat.

## Intensitas serangan

Intensitas serangan (Force) menyatakan seberapa kuat satu edge ATTACKS menyerang targetnya. Rentangnya 0~1, dan bernilai 1 jika tidak ada F_FORCE.

- Dalam putusan, kontribusi `(v+1)/2` dari nilai putusan v penyerang dikalikan dengan intensitas F. Serangan bantahan (COUNTER) masuk ke suku penyebut sebagai `F·(v+1)/2`, dan serangan pengecualian (EXCEPT) masuk ke gerbang `Π(1 − F·(v+1)/2)`. Jika F = 0, serangan tidak memengaruhi putusan.
- Nilainya mengikuti aturan numerik [TOULMIN](/id/grammar/edge/toulmin/#numerik). Encoder menghapus nol di akhir koefisien (0.5 adalah `C=5, E=−1`, 1.0 adalah `C=1, E=0`). Decoder menerima hingga 4 angka desimal.
- Permukaan yang tidak menulis intensitas (`don't X when Y`, bahasa Korea `` `Y` 면 `X` 는 무효다``) mematikan F_FORCE.
- Permukaan yang menulis intensitas (bahasa Korea `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) menyalakan F_FORCE dan memuat nilainya. Walaupun yang ditulis 1, seperti `1.0의 세기로`, F_FORCE tetap dinyalakan dan memuat 1. Dengan begitu permukaan teks asli kembali apa adanya.
- Intensitas serangan adalah sumbu yang berbeda dari kekuatan node (Strict, Defeasible, Defeater). Kekuatan melekat pada node; intensitas serangan melekat pada edge ATTACKS.

### Contoh

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, penyerang Y adalah Edge Id 3, target X adalah Edge Id 2, lebar SPAN 1 WORD.

```
16E8                  TAG WORD: Edge, total 14 WORD, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, penyerang)
0088 0002             dst     LOCAL 2 (X, target)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte awal 0x40, jumlah byte 0x1A
```

Edge yang sama tanpa intensitas memiliki flags `0000` dan tidak memiliki field F_FORCE. TAG WORD-nya `14E8` (total 10 WORD).

## Interpretasi dan validitas

- REF adalah Edge Id record dokumen ini (field umum [TOULMIN](/id/grammar/edge/toulmin/#field-umum)).
- Bentuk dst ditetapkan oleh Codec. DO·DO-ONCE·UNDO adalah FuncRef (REF(ALIAS, 0 jika tidak ada) + VerbCode 1 WORD, [NODE](/id/grammar/edge/toulmin/node/#field)), LABEL·IMPORTED-FROM adalah REF record TEXT, dan sisanya adalah REF node.
- `do … once` dinyatakan oleh Codec DO-ONCE. F_ONCE tidak dipakai pada flags DO-ONCE (jika menyala, ditolak). `once` pada UNDO ditulis dengan F_ONCE.
- Operator gerbang adalah 2 bit atas WORD operator dan 14 bit sisanya adalah 0. Persen adalah Value UNSIGNED-DECIMAL dengan `E=0` dan bernilai 0~100.
- b5~b15 flags adalah cadangan dan harus 0. Jika tidak, ditolak.
- F_FORCE hanya dipakai pada ATTACKS. Jika menyala pada Codec lain (SUPERSEDES, sambungan eksekusi dan putusan, relasi format ISSUER), ditolak.
- Jika intensitas serangan bukan Value SIGNED-DECIMAL, berada di luar 0~1, atau tidak dapat ditulis tepat dengan 4 angka desimal, ditolak.
- Rantai `A > B > C` pada SUPERSEDES ditulis dengan satu SUPERSEDES per pasangan.

## Halaman terkait

- [TOULMIN](/id/grammar/edge/toulmin/), [NODE](/id/grammar/edge/toulmin/node/), [SOURCE dan bagian](/id/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/)
