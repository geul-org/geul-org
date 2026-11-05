---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Mencatat tingkat keyakinan seluruh dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CONFIDENCE` (BIND `CONFIDENCE` pada dokumen spesifikasi) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E80/` (target DECLARE `1E80`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 8 |
| Kind | Meta · kelas: verifikasi |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tingkat keyakinan |
| Sisi Hugo | `meta/verification/confidence.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | record | `0690` UNSIGNED-DECIMAL |  |

Mencatat tingkat keyakinan seluruh dokumen. Keyakinan per record ditulis sebagai QUALIFIER yang dilekatkan pada Edge sasaran (propertinya belum ditetapkan, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[TAG ekstensi Length]
Payload           Value UNSIGNED-DECIMAL, dari 0 sampai 1
```

- Codec: Meta `0x1E8L`, kelas verifikasi
- Payload: Value bawaan ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Siapa yang memberi nilai dicatat bersama dengan [GENERATED-BY](0x1D3L-generated-by.md) dan sejenisnya.

## Masalah terbuka {#열린-문제}

- Skala (0 sampai 1) dan hubungannya dengan penilaian TOULMIN.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E80/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
