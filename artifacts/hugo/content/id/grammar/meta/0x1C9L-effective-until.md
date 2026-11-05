---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan akhir masa berlaku versi ini (undang-undang berjangka waktu)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `EFFECTIVE-UNTIL` (BIND `EFFECTIVE-UNTIL` pada dokumen spesifikasi) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C90/` (target DECLARE `1C90`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 9 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Akhir masa berlaku versi ini (undang-undang berjangka waktu). Jika tidak ada, sampai versi berikutnya mulai berlaku |
| Sisi Hugo | `meta/declaration/effective-until.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Mendeklarasikan akhir masa berlaku versi ini (undang-undang berjangka waktu). Sejak saat itu versi ini tidak berlaku.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[TAG ekstensi Length]
Payload           satu Value TIME
```

- Codec: Meta `0x1C9L`, kelas definisi
- Payload: Value bawaan ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) atau [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Jika tidak ada, versi ini berlaku sampai versi berikutnya mulai berlaku.
- Setelah masa berlaku lewat, tidak ada edisi yang berlaku. Edisi lama tidak hidup kembali.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
