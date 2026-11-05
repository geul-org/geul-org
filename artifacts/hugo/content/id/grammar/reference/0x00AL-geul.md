---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL adalah Reference deklarasi yang menunjuk entitas yang diterbitkan geul.org dengan CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `GEUL` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x00AL~0x00EL` |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 10~14 |
| Kind | Reference · klasifikasi: deklarasi |
| Sisi Hugo | `reference/geul.md` |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

GEUL adalah Reference deklarasi yang menunjuk entitas yang diterbitkan geul.org dengan CC0. Ia adalah ID berurutan yang nomornya tidak memuat makna. Pengenal yang memuat makna pada bit ditangani Codec tersendiri [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[TAG ekstensi Length]
GEUL ID           unsigned big-endian dengan lebar terpendek
```

- Nomor kecil ditetapkan untuk entitas berfrekuensi tinggi. ID yang muat dalam 1 WORD berjumlah total 2 WORD.
- Penetapan ID dan registri dikelola geul.org. Registri hanya diisi dengan yang berasal dari sumber CC0.
- Jika Variable, ia adalah variabel anonim dari jenis itu ([Reference](_index.md) Variable).

## Contoh {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Masalah terbuka {#열린-문제}

- Aturan penetapan GEUL ID dan format publikasi registri.

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000000A0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Di atas adalah dokumen codec `GEUL-IDENTIFIED` (`0x00AL`). Dokumen codec anggota lain (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
