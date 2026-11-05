---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT adalah Value yang memuat string UTF-8 tanpa bahasa."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT adalah Value yang memuat string UTF-8 tanpa bahasa. Memakai pasangan kode jumlah byte genap·ganjil 0x072L/0x073L.

| Butir | Nilai |
|---|---|
| Nama | `UTF8-TEXT` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x072L`·`0x073L` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 18~19 |
| Kind | Value · keluarga: TEXT |
| Deskripsi indeks | Deret byte UTF-8 valid yang tidak menyiratkan normalisasi. Jumlah byte genap·ganjil |
| Sisi Hugo | `value/text/utf8-text.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | genap | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | ganjil | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

UTF8-TEXT adalah Value yang memuat deret byte UTF-8 valid menurut RFC 3629. Dipakai untuk string tanpa bahasa seperti pengenal, kode, dan nama berkas.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x072L` (jumlah byte genap)·`0x073L` (jumlah byte ganjil). Keluarga TEXT.
- Jumlah byte ditentukan oleh bit paling rendah Codec dan jumlah Payload WORD. Rumusnya `2 × jumlah Payload WORD − bit paling rendah`, dan Byte Count tidak dipakai ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretasi dan validitas {#해석과-유효성}

- Deret byte harus berupa UTF-8 well-formed shortest-form yang sesuai tata bahasa RFC 3629. Hasil dekode hanya memuat Unicode scalar value dalam rentang `U+0000..U+10FFFF`, tanpa rentang surrogate `U+D800..U+DFFF`.
- U+FEFF di awal Payload (deret byte UTF-8 `EF BB BF`) juga dianggap sebagai karakter yang sama dengan U+FEFF di posisi lain dan diizinkan. Penanganan signature (BOM) U+FEFF di awal yang dijelaskan RFC 3629 tidak dilakukan. Karakter itu tidak dibuang atau ditafsirkan sebagai signature, melainkan disimpan apa adanya.
- Unicode normalization tidak dipaksakan. Scalar sequence asli hasil dekode disimpan apa adanya.
- Deret byte UTF-8 yang valid ditempatkan di Payload tanpa konversi. Dalam satu WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah yang tidak terpakai pada WORD terakhir harus `00`.
- Jumlah Payload WORD adalah `ceil(jumlah byte/2)`. Jika kode ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar {#표준-근거}

- Rentang scalar UTF-8 dan deret byte well-formed mengikuti [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Pasangan kode genap-ganjil, zero padding, serta penempatan TAG/Length GEUL dan WORD 16 bit adalah aturan canonical framing format ini.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Length](../record.md)).
- String 0 byte ditulis sebagai record 1 WORD (hanya TAG WORD) dari kode genap ([Value](_index.md)).

## Contoh {#예시}

- `A` (`41`) adalah 1 byte (ganjil) sehingga memakai `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, total 2 WORD, `LLLL=0001`. Totalnya `0731 4100`.
- String kosong adalah 1 WORD `0720` (`UTF8-TEXT-EVEN`, hanya TAG WORD).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000720/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec untuk `UTF8-TEXT-EVEN` (`0x072L`). Dokumen Codec anggota lain (`UTF8-TEXT-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
