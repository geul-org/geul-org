---
title: "Contoh: item Wikidata"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Membaca dari awal sampai akhir dokumen GEUL sebesar 63 WORD yang memuat satu nama, dua proposisi, dan satu syarat pembatas Wikidata Q42 (Douglas Adams)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mari baca dari awal sampai akhir sebuah dokumen kecil tentang item Wikidata Q42 (Douglas Adams). Isinya sebagai berikut.

- Nama Inggris: Douglas Adams
- Q42 adalah instance dari manusia (Q5) (P31).
- Q42 dididik di St John's College (Q691283) (P69). Waktu mulai (P580) adalah tahun 1971.

Dokumennya adalah dokumen `0x510000000000002a` milik Issuer `0x00010000`, total 63 WORD (126 byte).

## Keseluruhan

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

`1880` adalah Meta (`11`), Length 2 WORD, Codec `0x00` (DOC-1WORD). Nilai `003f` (63) adalah jumlah WORD seluruh dokumen. Decoder mengetahui akhir dokumen lebih dulu dari nilai ini.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. Ini edisi spesifikasi yang diikuti dokumen ini. v1 adalah `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, total 10 WORD. Payload-nya adalah satu Reference DOC-POINTER.

| WORD | Arti |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | ID dokumen `0x510000000000002a` |
| `0000 0000` | Versi `0` (dirinya sendiri) |

```
180e
```

BODY. HEAD berakhir dan BODY dimulai.

## BODY

### #1 LABEL — nama Inggris

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Arti |
|---|---|
| `1704` | Edge, Length `1110` (extension), Codec `0x04` LABEL |
| `0010` | Panjang extension: total 16 WORD |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Wikidata Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORD, byte ganjil (`0x4B`) |
| `08c6 656e` | Bahasa: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 byte + padding `00` |

### #2 TRIPLE — Q42 adalah manusia

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Arti |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (manusia) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 dididik di St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Arti |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. Nilainya melebihi 16 bit sehingga Reference 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — waktu mulai tahun 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Arti |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (TRIPLE di atas) |
| `0924 3139 3731` | Value: EDTF `1971` (presisi tahun sehingga EDTF, bukan GREGORIAN-DATE) |

Makna #3 adalah gabungan #3 itu sendiri dan semua QUALIFIER yang menunjuk #3: "Q42 dididik di St John's College sejak tahun 1971."

```
180f
```

END. Sampai di sini 63 WORD.

## Jika dibaca tanpa codebook

Decoder yang tidak mengetahui codebook pun mengetahui hal berikut.

- Dokumen berukuran 63 WORD, dengan 2 Meta di HEAD dan 4 Edge di BODY.
- Codec setiap Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) dan Edge Id (1, 2, 3, 4).
- Posisi record berikutnya untuk setiap record.

Peran komponen (Predicate, Subject, Object, Rank) baru diketahui dengan membaca [dokumen spesifikasi](/id/grammar/codec-spec/) setiap Codec.

## Hash isi

Hash isi dokumen ini (SHA-256) adalah sebagai berikut. Jika diterbitkan, hash ini dicatat dalam daftar versi bersama ID versi.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
