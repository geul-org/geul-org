---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Mencatat hasil penilaian seluruh dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `VERDICT` (BIND `VERDICT` pada dokumen spesifikasi) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E90/` (target DECLARE `1E90`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 9 |
| Kind | Meta · kelas: verifikasi |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hasil penilaian seluruh dokumen. Pass, Review, Fail. Untuk satuan node atau record, [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`) |
| Sisi Hugo | `meta/verification/verdict.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | nilai mentah 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Mencatat hasil penilaian seluruh dokumen. Penilaian per node atau record menjadi tugas [TOULMIN](../toulmin/_index.md) `VERDICT` (Edge `0x118L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[TAG ekstensi Length]
penilaian         1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, kelas verifikasi
- Payload: nilai mentah (penilaian 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Karena kelas verifikasi, dikeluarkan dari hash isi.
- Penilaian terhadap dokumen lain ditaruh pada BODY dokumen yang berbeda dari dokumen yang dinilai.

## Masalah terbuka {#열린-문제}

- Apakah pihak penilai dan dasarnya dicatat bersama.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
