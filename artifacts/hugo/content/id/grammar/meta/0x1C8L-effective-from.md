---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan tanggal mulai berlaku versi ini."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `EFFECTIVE-FROM` (BIND `EFFECTIVE-FROM` pada dokumen spesifikasi) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C80/` (target DECLARE `1C80`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 8 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tanggal mulai berlaku versi ini. Value GREGORIAN-DATE atau POSIX-TIMESTAMP. Jika tidak ada, waktu publikasi |
| Sisi Hugo | `meta/declaration/effective-from.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Mendeklarasikan tanggal mulai berlaku versi ini. Tanggal mulai berlaku berbeda dari waktu publikasi ([revisi](../document.md#개정)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[TAG ekstensi Length]
Payload           satu Value TIME
```

- Codec: Meta `0x1C8L`, kelas definisi
- Payload: Value bawaan ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) atau [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Jika tidak ada, berlaku sejak waktu publikasi.
- Jika [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) ada, nilai ini harus lebih awal darinya.
- Jika tanggal mulai berlaku berbeda per pasal, tuliskan terpisah pada Edge pasal itu dengan QUALIFIER P580 (mulai) dan P582 (akhir) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Nilai ini dibaca saat menafsirkan dokumen pada titik waktu tertentu.

## Contoh {#예시}

- Berlaku sejak 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C80/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
