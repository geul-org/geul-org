---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF adalah Value yang memuat tanggal dengan presisi tahun atau bulan, SM, ketidakpastian, dan interval melalui string tanggal diperluas ISO 8601-2 (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF adalah Value yang memuat tanggal dengan presisi tahun atau bulan, SM, ketidakpastian, dan interval melalui string tanggal diperluas ISO 8601-2 (Codec 0x06EL/0x06FL).

| Butir | Nilai |
|---|---|
| Nama | `EDTF` (kelompok genap-ganjil. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x06EL`·`0x06FL` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 14~15 |
| Kind | Value · keluarga: TIME |
| Deskripsi indeks | string tanggal EDTF (ISO 8601-2). Jumlah byte genap·ganjil. Tanggal yang dapat ditulis dengan GREGORIAN-DATE tidak ditulis dengan format ini |
| Sisi Hugo | `value/time/edtf.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | genap | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | ganjil | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

EDTF adalah Value yang memuat tanggal melalui string [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress AS, ISO 8601-2:2019). Format ini menyatakan presisi yang lebih kasar daripada hari, SM, ketidakpastian·perkiraan·sebagian tidak diketahui, dan interval.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x06EL` (jumlah byte genap)·`0x06FL` (jumlah byte ganjil). Keluarga TIME. Payload adalah string tetapi ditempatkan pada keluarga TIME.
- Jumlah byte ditentukan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak disediakan ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = jumlah byte ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          byte ASCII string EDTF / jika ganjil, 0x00 di akhir
```

## Interpretasi dan validitas {#해석과-유효성}

- Deret byte adalah string ASCII yang mengikuti tata bahasa EDTF Level 0·1·2. String kosong adalah invalid.
- Contoh: hari `1952-03-11`, bulan `1952-03`, tahun `1952`, dekade `195X`, 44 SM `-0043`, tidak pasti `1974?`, perkiraan `~1974`, interval `1952/2001`, tahun besar `Y-13799999999`.
- Tahun mengikuti gaya astronomis ISO 8601. `0000` adalah 1 SM, `-0043` adalah 44 SM. Saat memindahkan dari penulisan gaya historis, tahunnya digeser satu.
- Kalender Gregorian. EDTF tidak menangani kalender lain. Penulisan asli kalender lain seperti kalender Julian disimpan dengan [GEDCOM-DATE](0x070L-gedcom-date.md). Nilai yang memindahkan hari atau periode yang sama dengan tanggal itu ke kalender Gregorian dapat ditulis dengan EDTF atau GREGORIAN-DATE.
- **Bentuk kanonik:** tanggal yang dapat ditulis secara tepat dengan [GREGORIAN-DATE](0x06AL-gregorian-date.md), yaitu `[-]YYYY-MM-DD` tanpa kualifikator (`?`, `~`, `%`), digit tidak diketahui (`X`), interval, dan awalan `Y`, ditulis dengan GREGORIAN-DATE. Menulis tanggal seperti ini dengan EDTF adalah invalid. Hanya jika hari yang sama ditulis dalam satu format saja, tanggal dapat diindeks dan dibandingkan sebagai waktu.
- Schema belum memeriksa tata bahasa EDTF. Produsen memeriksanya dengan parser EDTF. Contoh: `parser.ParseString` dari `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` hanya melihat tata bahasa sehingga meloloskan `2023-02-29` dan `1974-13`, jadi tidak dipakai. Parser ini belum mendukung tahun berawalan `Y`.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Length](../record.md)).

## Contoh {#예시}

| Tanggal | Byte | WORD total |
|---|---|---|
| `1974` | 4 (genap) | `06E2 3139 3734` |
| `197X` | 4 (genap) | `06E2 3139 3758` |
| `1952-03` | 7 (ganjil) | `06F4 3139 3532 2D30 3300` |

## Dasar standar {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 adalah himpunan bagian dari ISO 8601-1, Level 1·2 adalah fitur ISO 8601-2.
- Pada RDF, string yang sama ditandai dengan datatype `http://id.loc.gov/datatypes/edtf`.

## Masalah terbuka {#열린-문제}

- Pemeriksaan tata bahasa EDTF oleh pemeriksa (apakah pemeriksa bergantung pada pustaka eksternal).
- Aturan memindahkan presisi abad dan milenium Wikidata menjadi digit tidak diketahui EDTF.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000006E0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec `EDTF-EVEN` (`0x06EL`). Dokumen Codec anggota lain (`EDTF-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat (BIND) pada `#1`.
