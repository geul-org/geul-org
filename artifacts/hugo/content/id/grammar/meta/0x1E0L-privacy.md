---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat tingkat data pribadi dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `PRIVACY` (BIND `PRIVACY` pada dokumen spesifikasi) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E00/` (target DECLARE `1E00`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 0 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tingkat data pribadi |
| Sisi Hugo | `meta/policy/privacy.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | nilai mentah 1 WORD |  |  |

Mencatat tingkat data pribadi dokumen.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[TAG ekstensi Length]
tingkat           1 WORD
```

- Codec: Meta `0x1E0L`, kelas kebijakan
- Payload: nilai mentah (tingkat 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Tidak mengubah interpretasi. Hanya menentukan penanganan.

## Masalah terbuka {#열린-문제}

- Tabel kode tingkat (kesesuaian dengan klasifikasi undang-undang pelindungan data pribadi).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
