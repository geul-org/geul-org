---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES adalah deret byte sembarang yang makna dan formatnya tidak ditetapkan oleh format ini sendiri."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES adalah deret byte sembarang yang makna dan formatnya tidak ditetapkan oleh format ini sendiri. Kode langsung Value `0x07EL` (jumlah byte genap)·`0x07FL` (jumlah byte ganjil), keluarga BINARY. Jumlah byte ditentukan oleh bit paling rendah Codec dan jumlah Payload WORD. Rumusnya `2 × jumlah Payload WORD − bit paling rendah`, dan Byte Count tidak dipakai ([Value](_index.md)).

| Butir | Nilai |
|---|---|
| Nama | `OPAQUE-BYTES` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x07EL`·`0x07FL` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 30~31 |
| Kind | Value · keluarga: BINARY |
| Deskripsi indeks | Deret byte yang makna·formatnya tidak diketahui. Jumlah byte genap·ganjil |
| Sisi Hugo | `value/binary/opaque-bytes.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | genap | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | ganjil | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth   byte / zero padding di akhir
```

## Interpretasi dan validitas {#해석과-유효성}

- Dari Payload dibaca byte sebanyak jumlah byte secara berurutan. Dalam satu WORD, byte atas datang lebih dulu.
- Jumlah Payload WORD adalah `ceil(jumlah byte/2)`. Jika kode ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.
- Jika kode genap·ganjil, jumlah Payload WORD, dan zero padding tidak saling sesuai, ditolak.

## Status format {#형식-지위}

- Pasangan kode genap-ganjil (`0x07EL` genap, `0x07FL` ganjil), penempatan payload, dan zero padding pada WORD terakhir bukan kutipan standar industri eksternal, melainkan framing khas GEUL.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan extension TAG juga masuk ke total ([Record dan TAG WORD](../record.md)).
- 0 byte ditulis sebagai record 1 WORD (hanya TAG WORD) dari kode genap (`0x07EL`) ([Value](_index.md)).

## Contoh {#예시}

Byte `AB CD EF` adalah 3 byte (ganjil) sehingga `OPAQUE-BYTES-ODD` (`0x07FL`), Payload `ABCD EF00`. Total 3 WORD sehingga `LLLL=0010`.

```
07F2 ABCD EF00
```

Deret byte kosong adalah 1 WORD `07E0` (`OPAQUE-BYTES-EVEN`, hanya TAG WORD).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000007E0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec untuk `OPAQUE-BYTES-EVEN` (`0x07EL`). Dokumen Codec anggota lain (`OPAQUE-BYTES-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
