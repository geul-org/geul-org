---
title: "CREATED-AT (0x1CDL)"
weight: 461
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Mencatat waktu dokumen ditulis (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CREATED-AT` (BIND `CREATED-AT` pada dokumen spesifikasi) |
| TAG ID | `0x1CDL` |
| Codec ID | `0x00001CD0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001CD0/` (target DECLARE `1CD0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 13 |
| Kind | Meta · kelas: asal-usul |
| TAG WORD | `0001 1100 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Waktu penulisan. Value TIME (git author date) |
| Sisi Hugo | `meta/provenance/created-at.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | record | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Mencatat waktu dokumen ditulis (git author date).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1101 LLLL      Codec 0x1CDL
[TAG ekstensi Length]
Payload           satu Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, dll.)
```

- Codec: Meta `0x1CDL`, kelas asal-usul
- Payload: Value bawaan (keluarga TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), dll.)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Formatnya dipilih dari Value keluarga TIME. Jika diperlukan presisi, gunakan format nanodetik yang didefinisikan Issuer (contoh: [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001CD0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CD000000000
BODY
#1 DECLARE 0x1CD0
#2 FIELD #1 record
#3 BIND #1 "CREATED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
