---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS adalah Edge pernyataan yang menghubungkan satu nama lain (alias) objek Subject sebagai Object."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `ALIAS` (BIND dokumen spesifikasi `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A50/` (target DECLARE `0A50`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 5 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Menghubungkan nama lain (alias) Subject. Layout sama dengan LABEL |
| Sisi Hugo | `edge/alias.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS adalah Edge pernyataan yang menghubungkan satu nama lain (alias) objek Subject sebagai Object. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) adalah nama representatif dalam bahasa itu (paling banyak satu per bahasa), sedangkan ALIAS adalah nama lain untuk objek yang sama (boleh banyak per bahasa, "also known as" di Wikidata). Terutama dipakai untuk pencarian. Layout dan validitasnya sama dengan LABEL.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 Value UTF8-LANGUAGE-TEXT atau record LOCAL Reference
```

## Interpretasi dan validitas {#해석과-유효성}

- Aturan Subject dan Object sama dengan [LABEL](0x0A4L-label.md) (Object adalah [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) atau LOCAL yang terselesaikan menjadi itu).
- Pada Subject dan bahasa yang sama dapat ditaruh beberapa ALIAS. Urutannya adalah urutan dalam dokumen.
- Teks yang sama dengan LABEL pada Subject dan bahasa yang sama tidak ditaruh sebagai ALIAS (nama representatif cukup dengan satu LABEL). Aturan ini bersifat anjuran.
- Dokumen spesifikasi geul.org membatasi Object dengan [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, sama dengan LABEL).

## Contoh (non-normatif) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): bahasa `0761 656E` (BCP47 `en`) + teks 3 byte (ganjil) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG-nya `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A50/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
