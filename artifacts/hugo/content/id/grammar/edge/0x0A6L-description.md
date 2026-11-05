---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION adalah Edge pernyataan yang menghubungkan satu deskripsi objek Subject dalam bahasa tertentu sebagai Object."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DESCRIPTION` (BIND dokumen spesifikasi `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A60/` (target DECLARE `0A60`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 6 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Menghubungkan deskripsi (description) bahasa Subject. Layout sama dengan LABEL |
| Sisi Hugo | `edge/description.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION adalah Edge pernyataan yang menghubungkan satu deskripsi objek Subject dalam bahasa tertentu sebagai Object. Codec `0x0A6L`.

Deskripsi adalah frasa pendek yang membedakan objek (description Wikidata, contoh: "ibu kota dan kota terbesar Jerman"). Ini bukan definisi atau klaim tentang objek. Proposisi tentang objek ditulis dengan [TRIPLE](0x0AAL-triple.md). Layout sama dengan [LABEL](0x0A4L-label.md). Deskripsi dan bahasanya dimuat dalam satu Object, yaitu [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Tidak ada bidang nilai mentah.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 Value UTF8-LANGUAGE-TEXT atau record LOCAL Reference
```

## Interpretasi dan validitas {#해석과-유효성}

- Aturan Subject dan Object sama dengan [LABEL](0x0A4L-label.md). Subject adalah tepat satu record Reference yang lengkap. Object adalah tepat satu record UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`) yang lengkap, atau LOCAL Reference yang terselesaikan menjadi UTF8-LANGUAGE-TEXT lewat binding [REFERENCE-NODE](0x0A0L-reference-node.md) dalam dokumen yang sama.
- Teks tanpa bahasa (UTF8-TEXT) tidak dapat menjadi DESCRIPTION. Deskripsi satu per bahasa, sehingga aturan itu hanya berlaku jika ada bahasa. Deskripsi yang sama untuk banyak bahasa ditulis dengan bahasa `mul`.
- DESCRIPTION untuk Subject dan bahasa yang sama paling banyak satu.
- Deskripsi dipakai untuk membedakan dari objek lain yang bernama sama. Sebaiknya pasangan LABEL dan DESCRIPTION dalam bahasa yang sama tidak tumpang tindih pada dua objek, tetapi spesifikasi tidak memeriksanya (Wikidata pun hanya menganjurkan, tidak memaksa).
- Dokumen spesifikasi geul.org membatasi Object dengan [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, sama dengan LABEL).

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- Record bahasa dan jumlah byte teks pada Object ditangani oleh record Object. Kursor setelah membaca record terakhir harus tepat sama dengan akhir Edge.
- Deskripsi lebih panjang daripada label, sehingga Object maupun Edge mudah melebihi 15 WORD. Dalam hal itu dipakai Length extension ([record](../record.md)).

## Contoh (non-normatif) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). Bahasa adalah contoh bentuk LANGUAGE-BCP47-CODE (`en` punya nomor registri `0x0784`, sehingga dapat juga dipakai sebagai SHORT-CODE).

- Object terdiri dari bahasa `0761 656E` (BCP47 `en`, 2 WORD) + teks 35 byte (ganjil, 18 WORD), sehingga `0x079L`, TAG 1 + extension TAG 1 + 20 = 22 WORD, `079E 0016 …`.
- Edge adalah TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD sehingga `LLLL=1110`, TAG `0A6E`, extension TAG `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Padanan Wikidata {#위키데이터-대응}

- `descriptions` item (satu per bahasa) → satu DESCRIPTION per bahasa. Kode bahasa dialihkan dengan tabel padanan kode bahasa yang sama dengan LABEL.

## Masalah terbuka {#열린-문제}

- Apakah ada kasus yang perlu mengizinkan deskripsi UTF8-TEXT tanpa bahasa (saat ini tidak diizinkan).

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A60/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
