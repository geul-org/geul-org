---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF adalah Value yang memuat string tanggal extended ISO 8601-2, yaitu tanggal seperti presisi tahun·bulan, SM, tidak pasti, dan interval (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF adalah Value yang memuat tanggal sebagai string [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Library of Congress AS, ISO 8601-2:2019). Menyatakan presisi yang lebih kasar dari hari, SM, tidak pasti·perkiraan·sebagian tidak diketahui, serta interval.

## Layout

- Kode: kode langsung Value `0x24` (byte genap)·`0x25` (byte ganjil). Keluarga TIME. Payload adalah string tetapi ditaruh pada keluarga TIME agar decoder dan indeks memperlakukannya sebagai nilai waktu walaupun tidak mengenal format.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = byte ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          byte ASCII string EDTF / 0x00 terakhir jika ganjil
```

## Interpretasi dan validitas

- Deretan byte adalah string ASCII yang mengikuti tata bahasa EDTF Level 0·1·2. String kosong adalah invalid.
- Contoh: hari `1952-03-11`, bulan `1952-03`, tahun `1952`, dekade `195X`, tahun 44 SM `-0043`, tidak pasti `1974?`, perkiraan `~1974`, interval `1952/2001`, tahun besar `Y-13799999999`.
- Tahun memakai gaya astronomis ISO 8601. `0000` adalah tahun 1 SM, dan `-0043` adalah tahun 44 SM. Saat memindahkan dari notasi gaya historis, geser satu tahun.
- Kalender Gregorian. EDTF tidak menangani kalender lain. Notasi asli kalender lain seperti Julian dipertahankan dengan [GEDCOM-DATE](/id/grammar/value/time/gedcom-date/). Nilai yang memindahkan hari·periode yang sama dengan tanggal itu ke kalender Gregorian dapat ditulis dengan EDTF atau GREGORIAN-DATE.
- **Bentuk kanonik:** tanggal yang dapat ditulis tepat dengan [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/), yaitu `[-]YYYY-MM-DD` tanpa kualifier (`?`, `~`, `%`), digit tidak diketahui (`X`), interval, dan awalan `Y`, ditulis dengan GREGORIAN-DATE. Menulis tanggal seperti itu dengan EDTF adalah invalid. Hari yang sama hanya boleh ditulis dengan satu format agar dapat diindeks·dibandingkan sebagai waktu.
- schema belum memeriksa tata bahasa EDTF. Produsen memeriksa dengan parser EDTF. Contoh: `parser.ParseString` dari `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` hanya melihat tata bahasa sehingga meloloskan `2023-02-29` dan `1974-13`, sehingga tidak dipakai. Parser ini belum mendukung tahun berawalan `Y`.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Length](/id/grammar/record/)).

## Contoh

| Tanggal | Byte | WORD total |
|---|---|---|
| `1974` | 4 (genap) | `0924 3139 3734` |
| `197X` | 4 (genap) | `0924 3139 3758` |
| `1952-03` | 7 (ganjil) | `0A25 3139 3532 2d30 3300` |

## Dasar standar

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0 adalah subset ISO 8601-1, dan Level 1·2 adalah fitur ISO 8601-2.
- Pada RDF, string yang sama ditandai dengan datatype `http://id.loc.gov/datatypes/edtf`.

## Masalah terbuka

- Pemeriksaan tata bahasa EDTF oleh pemeriksa (apakah pemeriksa bergantung pada pustaka eksternal).
- Aturan memindahkan presisi abad·milenium Wikidata menjadi digit tidak diketahui EDTF.

## Halaman terkait

- [Value](/id/grammar/value/), [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/id/grammar/value/time/gedcom-date/)
