---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat hash isi versi sebelumnya (git parent)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `PARENT` (BIND `PARENT` pada dokumen spesifikasi) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D10/` (target DECLARE `1D10`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 17 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hash isi versi sebelumnya (git parent). Jika tidak ada, ini versi pertama; jika lebih dari satu, ini penggabungan (git merge commit). |
| Sisi Hugo | `meta/lineage/parent.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | record | `07C0` SHA-256-DIGEST |  |

Mencatat hash isi versi sebelumnya (git parent).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[TAG ekstensi Length]
Payload           satu Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D1L`, kelas silsilah
- Payload: Value bawaan ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Jumlah: dapat lebih dari satu (penggabungan)

## Interpretasi dan validitas {#해석과-유효성}

- Jika tidak ada, ini versi pertama; jika lebih dari satu, ini penggabungan (git merge commit).
- Karena termasuk dalam [hash isi](../document.md#내용-해시), seluruh riwayat menjadi rantai hash.
- Dokumen daftar versi menunjuk dokumen daftar sebelumnya ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Format digest ditanamkan sebagai Value agar algoritma hash dapat diganti. Saat ini hash isi hanya SHA-256.

## Contoh {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + TAG ekstensi Length + Value bawaan 18 WORD)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D10/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
