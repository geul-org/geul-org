---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat pembatasan penggunaan (contoh: larangan pelatihan, larangan penggunaan komersial)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `USAGE` (BIND `USAGE` pada dokumen spesifikasi) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E30/` (target DECLARE `1E30`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 3 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pembatasan penggunaan |
| Sisi Hugo | `meta/policy/usage.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Mencatat pembatasan penggunaan (contoh: larangan pelatihan, larangan penggunaan komersial).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[TAG ekstensi Length]
Payload           teks atau Reference yang menyatakan pembatasan penggunaan
```

- Codec: Meta `0x1E3L`, kelas kebijakan
- Payload: Value atau Reference bawaan
- Jumlah: dapat lebih dari satu

## Masalah terbuka {#열린-문제}

- Tabel kode jenis pembatasan.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E30/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
