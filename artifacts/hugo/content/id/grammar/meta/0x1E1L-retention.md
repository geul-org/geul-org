---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat batas waktu penyimpanan dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `RETENTION` (BIND `RETENTION` pada dokumen spesifikasi) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E10/` (target DECLARE `1E10`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 1 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Batas waktu penyimpanan |
| Sisi Hugo | `meta/policy/retention.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Mencatat batas waktu penyimpanan dokumen.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[TAG ekstensi Length]
Payload           waktu kedaluwarsa (GREGORIAN-DATE, dll.) atau durasi (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, kelas kebijakan
- Payload: Value bawaan (keluarga TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), dll., atau [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Jika berupa durasi, dihitung mulai dari [RECORDED-AT](0x1D0L-recorded-at.md).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E10/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
