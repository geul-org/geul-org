---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD adalah format Reference yang didefinisikan Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD adalah format Reference yang didefinisikan Issuer. Ia salah satu dari tiga slot terakhir wilayah Reference, dan lebar Issuer-nya 16 WORD. Layout ISSUER ketiga Kind sama ([record dan TAG WORD](../record.md#issuer-형식-레코드)).

| Butir | Nilai |
|---|---|
| Nama | `REFERENCE-ISSUER-16WORD` (BIND `REFERENCE-ISSUER-16WORD` pada dokumen spesifikasi) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000005F0/` (target DECLARE `05F0`) |
| Bagian | 2 `0010` (Reference lainnya), offset C dalam bagian = 31 |
| Kind | Reference · klasifikasi: format Issuer |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Issuer 16 WORD dan nomor Codec 2 WORD. Formatnya ditetapkan dokumen Codec milik Issuer |
| Sisi Hugo | `reference/reference-issuer.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[TAG ekstensi Length]
Issuer            16 WORD
Nomor Codec       2 WORD. Didefinisikan Issuer
Payload           Ditetapkan dokumen Codec yang diterbitkan Issuer
```

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | nilai mentah 16 WORD |  |  |
| 2 | `codec` | #3 | nilai mentah 2 WORD |  |  |
| 3 | `payload` | #4 | sisa nilai mentah (`0xFFFF`) |  |  |

Susunan `payload` ditetapkan oleh dokumen Codec Issuer itu.

## Interpretasi dan validitas {#해석과-유효성}

- GEUL hanya mengetahui batas Payload melalui Length. Decoder yang tidak mengetahui formatnya mengetahui sampai Kind, Length, Issuer, dan nomor Codec, lalu melompatinya dengan Length.
- Makna nomor Codec, kuantifikasi, dan apa yang ditunjuk ditetapkan oleh dokumen Codec yang diterbitkan Issuer. Aturan umum Reference seperti lebar terpendek ID target dan pembacaan kuantifikasi tidak berlaku ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- Issuer ditulis dengan lebar terpendek yang dapat memuat nilainya ([Issuer dan publikasi](../issuer.md#issuer-등급)). Jika 12 WORD teratas nilai Issuer adalah 0, itu invalid. Nilai itu ditulis dengan kode berlebar lebih sempit.
- Nomor Codec berukuran 2 WORD. Issuer menetapkannya agar tidak tumpang tindih di dalam `codecs/` miliknya, tanpa memandang Kind. Jika nomor tidak cukup, ajukan penerbitan satu Issuer lagi.
- Dokumen codec ditaruh di bawah `<Issuer>/codecs/<nomor Codec>/` milik Issuer itu ([alamat publikasi dan daftar versi](../publishing.md#id-표기)).
- Lisensi format Issuer ditetapkan oleh Issuer itu ([Issuer dan publikasi](../issuer.md#라이선스)).

## Halaman terkait {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [Record dan TAG WORD](../record.md#issuer-형식-레코드), [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000005F0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
