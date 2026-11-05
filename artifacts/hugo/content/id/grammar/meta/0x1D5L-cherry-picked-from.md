---
title: "CHERRY-PICKED-FROM (0x1D5L)"
weight: 469
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat hash isi versi asal perubahan yang diambil dari silsilah lain (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CHERRY-PICKED-FROM` (BIND `CHERRY-PICKED-FROM` pada dokumen spesifikasi) |
| TAG ID | `0x1D5L` |
| Codec ID | `0x00001D50` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D50/` (target DECLARE `1D50`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 21 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hash isi versi asal perubahan yang diambil dari silsilah lain (git cherry-pick `-x`) |
| Sisi Hugo | `meta/lineage/cherry-picked-from.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | record | `07C0` SHA-256-DIGEST |  |

Mencatat hash isi versi asal perubahan yang diambil dari silsilah lain (git cherry-pick `-x`).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0101 LLLL      Codec 0x1D5L
[TAG ekstensi Length]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D5L`, kelas silsilah
- Payload: Value bawaan ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Format digest ditanamkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D50/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D5000000000
BODY
#1 DECLARE 0x1D50
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "CHERRY-PICKED-FROM"
#4 BIND #2 "digest"
```
