---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Mencatat waktu dokumen direkam (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `RECORDED-AT` (BIND `RECORDED-AT` pada dokumen spesifikasi) |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D00/` (target DECLARE `1D00`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 16 |
| Kind | Meta · kelas: asal-usul |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Waktu perekaman. Value TIME (git commit date) |
| Sisi Hugo | `meta/provenance/recorded-at.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Mencatat waktu dokumen direkam (git commit date).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[TAG ekstensi Length]
Payload           satu Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, dll.)
```

- Codec: Meta `0x1D0L`, kelas asal-usul
- Payload: Value bawaan (keluarga TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), dll.)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Formatnya dipilih dari Value keluarga TIME. Jika diperlukan presisi, gunakan format nanodetik yang didefinisikan Issuer (contoh: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).
- Dokumen daftar versi ([PUBLICATION](../edge/0x0B8L-publication.md)) memakai nilai ini sebagai waktu publikasi, deprecate, dan penghapusan.

## Masalah terbuka {#열린-문제}

- Meta asal-usul termasuk dalam hash isi. Apakah diizinkan hash berbeda ketika isi yang sama direkam pada waktu berbeda.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
