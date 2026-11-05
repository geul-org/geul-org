---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL adalah Edge pernyataan yang menghubungkan satu nama (label) objek Subject dalam bahasa tertentu sebagai Object."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `LABEL` (BIND dokumen spesifikasi `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A40/` (target DECLARE `0A40`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 4 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Menghubungkan nama (label) bahasa Subject. Object adalah UTF8-LANGUAGE-TEXT |
| Sisi Hugo | `edge/label.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL adalah Edge pernyataan yang menghubungkan satu nama (label) objek Subject dalam bahasa tertentu sebagai Object. Codec `0x0A4L`. Ini bukan Edge yang menyatakan lemma dalam leksikologi umum.

Nama dan bahasanya dimuat dalam satu Object, yaitu [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Tidak ada bidang nilai mentah.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 Value UTF8-LANGUAGE-TEXT atau record LOCAL Reference
```

## Interpretasi dan validitas {#해석과-유효성}

- Subject adalah tepat satu record Reference yang lengkap. Batasnya ditemukan dengan Length Subject sendiri; jika bukan Reference atau tidak lengkap, maka invalid.
- Object adalah tepat satu record [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`) yang lengkap. Aturan bahasa dan teks (kedua bentuk bahasa diizinkan, perbandingan bahasa yang sama) mengikuti bentuk itu.
- Object juga boleh berupa LOCAL Reference. Dalam hal ini, ia harus terselesaikan menjadi UTF8-LANGUAGE-TEXT lewat binding [REFERENCE-NODE](0x0A0L-reference-node.md) dalam dokumen yang sama. Jika tidak terselesaikan atau terselesaikan menjadi objek jenis lain, maka invalid.
- Dokumen spesifikasi geul.org menuliskan batasan ini dengan [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). Sasaran penyelesaian LOCAL tidak dinyatakan dengan CODEC.
- Jika Object bukan salah satu dari dua bentuk di atas atau recordnya tidak lengkap, maka invalid. Teks tanpa bahasa (UTF8-TEXT) tidak dapat menjadi LABEL. Nama untuk mesin tanpa bahasa ditulis dengan [BIND](0x0A3L-bind.md). Nama yang sama untuk banyak bahasa ditulis dengan bahasa `mul`.
- LABEL untuk Subject dan bahasa yang sama paling banyak satu. Nama lain ditulis dengan [ALIAS](0x0A5L-alias.md).

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- Record bahasa dan jumlah byte teks pada Object ditangani oleh record Object, bukan Edge. Kursor setelah membaca record terakhir harus tepat sama dengan akhir Edge.

## Contoh (non-normatif) {#예시-비규범}

Kode bahasa `0784` untuk `en` adalah nomor dalam GEUL Language Registry v2 (dokumen spesifikasi `0x00000000/codecs/0x000007A0` versi 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object terdiri dari bahasa `07A1 0784` (SHORT-CODE 2 WORD) + teks 12 byte (genap, 6 WORD), sehingga `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), total 9 WORD `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG-nya `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object terdiri dari bahasa `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORD) + teks 6 byte (genap, 3 WORD), sehingga total 8 WORD `0787 0773 7074 2D42 5200 4272 6173 696C`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. TAG-nya `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A40/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
