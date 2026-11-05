---
title: "VALUE-ISSUER-4WORD (0x09EL)"
weight: 158
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-4WORD adalah format Value yang didefinisikan oleh Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-4WORD adalah format Value yang didefinisikan oleh Issuer. Ini salah satu dari tiga kode terakhir zona Value, dengan lebar Issuer 4 WORD. Layout ISSUER ketiga Kind sama ([Record dan TAG WORD](../record.md#issuer-형식-레코드)).

| Butir | Nilai |
|---|---|
| Nama | `VALUE-ISSUER-4WORD` (dokumen spesifikasi BIND `VALUE-ISSUER-4WORD`) |
| TAG ID | `0x09EL` |
| Codec ID | `0x000009E0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000009E0/` (sasaran DECLARE `09E0`) |
| Bagian | 4 `0100` (Value), offset dalam bagian C = 30 |
| Kind | Value · klasifikasi: format Issuer |
| TAG WORD | `0000 1001 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Issuer 4 WORD dan nomor Codec 2 WORD. Formatnya ditetapkan oleh dokumen Codec Issuer |
| Sisi Hugo | `value/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1110 LLLL      Codec 0x09EL
[Length extension TAG]
Issuer            4 WORD
Nomor Codec       2 WORD. Didefinisikan oleh Issuer
Payload           Ditetapkan oleh dokumen Codec yang diterbitkan Issuer
```

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | nilai mentah 4 WORD |  |  |
| 2 | `codec` | #3 | nilai mentah 2 WORD |  |  |
| 3 | `payload` | #4 | sisa nilai mentah (`0xFFFF`) |  |  |

Susunan `payload` ditetapkan oleh dokumen Codec Issuer tersebut.

## Interpretasi dan validitas {#해석과-유효성}

- GEUL hanya mengetahui batas Payload dari Length. Dekoder yang tidak mengenal formatnya mengetahui hingga Kind, Length, Issuer, dan nomor Codec, lalu melompatinya dengan Length.
- Penafsiran Payload ditetapkan oleh dokumen Codec Issuer. Value format Issuer yang sudah terdaftar saat ini ada di [indeks Codec](../codec-index.md#value-issuer-형식).
- Issuer ditulis dengan lebar terpendek yang dapat memuat nilainya ([Issuer dan publikasi](../issuer.md#issuer-등급)). Jika 2 WORD atas nilai Issuer adalah 0, invalid. Nilai itu ditulis dengan kode 2 WORD ([VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)).
- Nomor Codec adalah 2 WORD. Issuer menetapkannya tanpa tumpang tindih di dalam `codecs/` miliknya, tanpa memandang Kind. Jika nomor tidak cukup, minta Issuer tambahan.
- Dokumen Codec ditempatkan di bawah `<Issuer>/codecs/<nomor Codec>/` milik Issuer itu ([alamat publikasi dan daftar versi](../publishing.md#id-표기)).
- Lisensi format Issuer ditetapkan oleh Issuer itu ([Issuer dan publikasi](../issuer.md#라이선스)).

## Halaman terkait {#관련-페이지}

- [Value — format Issuer](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [Record dan TAG WORD](../record.md#issuer-형식-레코드), [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000009E0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009E000000000
BODY
#1 DECLARE 0x09E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
