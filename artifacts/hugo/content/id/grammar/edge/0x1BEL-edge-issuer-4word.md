---
title: "EDGE-ISSUER-4WORD (0x1BEL)"
weight: 446
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-4WORD adalah format Edge yang didefinisikan oleh Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-4WORD adalah format Edge yang didefinisikan oleh Issuer. Ia salah satu dari tiga slot terakhir wilayah Edge, dan lebar Issuer-nya 4 WORD. Layout ISSUER ketiga Kind sama ([Record dan TAG WORD](../record.md#issuer-형식-레코드)).

| Butir | Nilai |
|---|---|
| Nama | `EDGE-ISSUER-4WORD` (dokumen spesifikasi BIND `EDGE-ISSUER-4WORD`) |
| TAG ID | `0x1BEL` |
| Codec ID | `0x00001BE0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001BE0/` (target DECLARE `1BE0`) |
| Bagian | 13 `1101` (Edge (3 slot terakhir ISSUER)), offset dalam bagian C = 30 |
| Kind | Edge · klasifikasi: format Issuer |
| TAG WORD | `0001 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Issuer 4 WORD dan nomor Codec 2 WORD. Formatnya ditetapkan oleh dokumen Codec milik Issuer |
| Sisi Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0001 1011 1110 LLLL      Codec 0x1BEL
[Length extension TAG]
Issuer            4 WORD
Nomor Codec       2 WORD. Didefinisikan oleh Issuer
Edge Id           record LOCAL Reference. Elemen pertama setelah Issuer dan nomor Codec
Sisa Payload      Ditetapkan oleh dokumen Codec yang diterbitkan Issuer
```

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan dengan FIELD. Edge Id pada EDGE-ISSUER terletak setelah nomor Codec dan sebelum field `payload` ([layout](#레이아웃)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | nilai mentah 4 WORD |  |  |
| 2 | `codec` | #3 | nilai mentah 2 WORD |  |  |
| 3 | `payload` | #4 | sisa nilai mentah (`0xFFFF`) |  |  |

Komposisi `payload` ditetapkan oleh dokumen Codec milik Issuer tersebut.

## Interpretasi dan validitas {#해석과-유효성}

- GEUL hanya mengetahui batas Payload lewat Length. Dekoder yang tidak mengenal formatnya mengetahui hingga Kind, Length, Issuer, dan nomor Codec, lalu melompatinya dengan Length.
- Payload diawali Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). Komponen setelah Edge Id ditetapkan oleh dokumen Codec milik Issuer.
- Issuer ditulis dengan lebar terpendek yang dapat memuat nilainya ([Issuer dan publikasi](../issuer.md#issuer-등급)). Jika 2 WORD teratas nilai Issuer adalah 0, itu invalid. Nilai itu ditulis dengan kode 2 WORD ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Nomor Codec berukuran 2 WORD. Issuer menetapkannya agar tidak bertabrakan di dalam `codecs/` miliknya sendiri, tanpa memandang Kind. Jika nomor tidak cukup, minta satu Issuer lagi.
- Dokumen Codec ditaruh di bawah `<Issuer>/codecs/<nomor Codec>/` milik Issuer itu ([alamat publikasi dan daftar versi](../publishing.md#id-표기)).
- Lisensi format Issuer ditetapkan oleh Issuer itu ([Issuer dan publikasi](../issuer.md#라이선스)).

## Halaman terkait {#관련-페이지}

- [Edge — Edge berformat Issuer](_index.md#issuer-형식-edge), [EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [Record dan TAG WORD](../record.md#issuer-형식-레코드), [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001BE0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BE000000000
BODY
#1 DECLARE 0x1BE0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
