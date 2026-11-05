---
title: "Contoh: entri Wikidata"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Membaca dari awal sampai akhir sebuah dokumen kecil tentang entri Wikidata Q42 (Douglas Adams)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kita membaca dari awal sampai akhir sebuah dokumen kecil tentang entri Wikidata Q42 (Douglas Adams). Isinya sebagai berikut.

- Nama Inggris: Douglas Adams
- Q42 adalah instans dari manusia (Q5) (P31).
- Q42 menempuh pendidikan di St John's College (Q691283) (P69). Waktu mulai (P580) adalah tahun 1971.

Dokumen ini adalah dokumen `0x510000000000002A` milik Issuer `0x00000001`, dengan total 63 WORD (126 byte).

## Keseluruhan {#전체}

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

`1C01` adalah Meta (bagian 14), Codec `0x1C0L` (DOC-1WORD), Length 2 WORD. Nilai `003F` (63) adalah jumlah WORD seluruh dokumen. Dengan nilai ini decoder mengetahui akhir dokumen sejak awal.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. Ini adalah edisi spesifikasi yang diikuti dokumen ini. v1 adalah `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, total 10 WORD. Payload-nya satu Reference DOC-POINTER.

| WORD | Arti |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ID dokumen `0x510000000000002A` |
| `0000 0000` | versi `0` (dirinya sendiri) |

```
1C30
```

BODY. HEAD berakhir dan BODY dimulai.

## BODY {#body}

### #1 LABEL — nama Inggris {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Arti |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (ekstensi) |
| `0010` | panjang ekstensi: total 16 WORD |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Wikidata Q42 |
| `0799` | Object: UTF8-LANGUAGE-TEXT, jumlah byte ganjil (`0x079L`), 10 WORD |
| `0761 656E` | bahasa: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13 byte + padding `00` |

### #2 TRIPLE — Q42 adalah manusia {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Arti |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (manusia) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 menempuh pendidikan di St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Arti |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. Nilainya melebihi 16 bit sehingga berupa Reference 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — waktu mulai tahun 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Arti |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (TRIPLE di atas) |
| `06E2 3139 3731` | Value: EDTF `1971` (presisi tahun, sehingga EDTF dan bukan GREGORIAN-DATE) |

Makna #3 adalah gabungan #3 itu sendiri dan semua QUALIFIER yang menunjuk #3: "Q42 menempuh pendidikan di St John's College sejak tahun 1971."

```
1C40
```

END. Sampai di sini totalnya 63 WORD.

## Dibaca tanpa codebook {#코덱북-없이-읽으면}

Decoder yang tidak mengetahui codebook pun dapat mengetahui hal-hal berikut.

- Dokumen berukuran 63 WORD, dengan 2 Meta di HEAD dan 4 Edge di BODY.
- Codec setiap Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) dan Edge Id-nya (1, 2, 3, 4).
- Posisi record berikutnya untuk setiap record.

Peran komponen (Predicate, Subject, Object, Rank) baru diketahui dengan membaca [dokumen spesifikasi](codec-spec.md) tiap Codec.

## Hash isi {#내용-해시}

Hash isi (SHA-256) dokumen ini adalah sebagai berikut. Jika dipublikasikan, hash ini dicatat dalam daftar versi bersama ID versi.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
