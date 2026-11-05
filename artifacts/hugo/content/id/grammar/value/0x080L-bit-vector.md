---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR adalah raw bit sequence yang panjangnya dinyatakan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR adalah raw bit sequence yang panjangnya dinyatakan. Kode langsung Value `0x080L`, keluarga BINARY. 2 Payload WORD pertama adalah bit count `N` unsigned 32 bit, diikuti `ceil(N/16)` WORD.

| Butir | Nilai |
|---|---|
| Nama | `BIT-VECTOR` (dokumen spesifikasi BIND `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000800/` (sasaran DECLARE `0800`) |
| Bagian | 4 `0100` (Value), offset dalam bagian C = 0 |
| Kind | Value · keluarga: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | N bit yang disimpan MSB-first setelah bit-count |
| Sisi Hugo | `value/binary/bit-vector.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | nilai mentah 2 WORD |  |  |
| 2 | `bits` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st–2nd       Bit Count N (16 bit atas │ 16 bit bawah)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretasi dan validitas {#해석과-유효성}

- `N` adalah nilai yang diperoleh dengan membaca 2 Payload WORD pertama sebagai bilangan bulat unsigned 32 bit big-endian.
- Bit payload diisi berurutan mulai dari bit paling signifikan setiap WORD.
- Jumlah payload WORD tepat `ceil(N/16)`, dan bit bawah yang tidak terpakai pada WORD terakhir semuanya harus 0.
- Jika `N=0`, tidak ada payload WORD. Dua WORD count sudah membentuk Payload sehingga tidak bertentangan dengan aturan Payload minimal 1 WORD.

## Status format {#형식-지위}

- Bit count unsigned 32 bit, penempatan MSB-first, dan zero padding pada WORD terakhir bukan kutipan standar industri eksternal, melainkan framing khas GEUL.
- Halaman ini mendefinisikan representasinya, termasuk aturan TAG, Length, dan WORD 16 bit GEUL.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan extension TAG juga masuk ke total ([Record dan TAG WORD](../record.md)).

## Contoh {#예시}

- Bit vector kosong: count `0000 0000`, tanpa payload, total 3 WORD, `LLLL=0010`. Totalnya `0802 0000 0000`.
- Bit sequence `101`: count `0000 0003`, payload `A000`, total 4 WORD, `LLLL=0011`. Totalnya `0803 0000 0003 A000`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000800/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
