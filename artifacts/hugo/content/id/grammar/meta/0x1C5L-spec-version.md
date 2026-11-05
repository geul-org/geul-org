---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan edisi spesifikasi GEUL yang diikuti dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SPEC-VERSION` (BIND `SPEC-VERSION` pada dokumen spesifikasi) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C50/` (target DECLARE `1C50`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 5 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Edisi spesifikasi GEUL yang diikuti. Payload itu sendiri adalah bilangan bulat unsigned dengan lebar tersempit. v1 adalah `0x0001` (record `0x1C51 0x0001`) |
| Sisi Hugo | `meta/declaration/spec-version.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

Mendeklarasikan edisi spesifikasi GEUL yang diikuti dokumen. Nilai ini menentukan cara membaca record lainnya.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[TAG ekstensi Length]
Payload           edisi spesifikasi. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, kelas definisi
- Payload: nilai mentah (bilangan bulat unsigned dengan lebar tersempit)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Tidak bergantung pada kode Value. Hanya bilangan bulat tanpa Value bawaan, agar dekoder edisi mana pun dapat membacanya.
- Jika edisinya tidak dikenal, dekoder menolak atau memberi peringatan.
- Jika tidak ada, dekoder membaca dengan edisi yang diketahuinya. Dokumen yang dipublikasikan mencantumkannya.

## Contoh {#예시}

- `0x1C51 0x0001`: GEUL v1

## Masalah terbuka {#열린-문제}

- Kesesuaian dengan versi dokumen buku Codec ([dokumen spesifikasi](../codec-spec.md)).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C50/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
