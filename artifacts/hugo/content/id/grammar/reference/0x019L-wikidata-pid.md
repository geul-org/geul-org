---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID adalah Reference deklarasi yang menunjuk properti (Property) Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `WIKIDATA-PID` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x019L~0x01DL` |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 25~29 |
| Kind | Reference · klasifikasi: deklarasi |
| Sisi Hugo | `reference/wikidata-pid.md` |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

WIKIDATA-PID adalah Reference deklarasi yang menunjuk properti (Property) Wikidata. Bagian angka dari P-id tanpa `P` ditulis sebagai bilangan bulat tak bertanda.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[TAG ekstensi Length]
PID               unsigned big-endian dengan lebar terpendek
```

- PID ditulis dengan lebar terpendek. Nomor properti saat ini muat dalam 1 WORD sehingga berjumlah total 2 WORD, dan jika melebihi 65535 secara alami bertambah menjadi 3 WORD.
- Terutama dipakai pada posisi Predicate [TRIPLE](../edge/0x0AAL-triple.md) dan posisi Property [QUALIFIER](../edge/0x0ABL-qualifier.md).

## Contoh {#예시}

| Properti | WORD sequence |
|---|---|
| `P31` (instans dari) | `0191 001F` |
| `P279` (subkelas dari) | `0191 0117` |
| `P569` (tanggal lahir) | `0191 0239` |

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000190/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Di atas adalah dokumen codec `WIKIDATA-PID-IDENTIFIED` (`0x019L`). Dokumen codec anggota lain (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
