---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat bahwa dokumen ini diturunkan dari dokumen atau bahan dari silsilah lain."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DERIVED-FROM` (BIND `DERIVED-FROM` pada dokumen spesifikasi) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D20/` (target DECLARE `1D20`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 18 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Diturunkan dari record atau bahan silsilah lain. Untuk mengunci pada versi tertentu bahan eksternal, lampirkan QUALIFIER hash teks asli (P4092) pada [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) di HEAD (git submodule). |
| Sisi Hugo | `meta/lineage/derived-from.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Mencatat bahwa dokumen ini diturunkan dari dokumen atau bahan dari silsilah lain.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[TAG ekstensi Length]
Payload           Reference, atau SHA-256-DIGEST (hash isi), atau Value URI
```

- Codec: Meta `0x1D2L`, kelas silsilah
- Payload: Reference atau Value bawaan
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Jika diturunkan dari dokumen GEUL, tulis hash isinya ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)); jika bahan eksternal, tulis [URI](../value/0x074L-uri.md). Untuk mengunci edisi bahan eksternal dengan hash, lampirkan QUALIFIER hash teks asli (P4092) pada [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) di HEAD.
- Sumber asal per record menjadi tugas Edge dasar [SOURCE](../edge/0x0C0L-source.md); record lama sebelum dipindah, dipecah, atau digabung menjadi tugas QUALIFIER P1365 pada Edge sasaran (nilainya Id Edge lama).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D20/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
