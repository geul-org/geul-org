---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE adalah Value yang mempertahankan apa adanya tanggal kalender lain seperti Julian sebagai string nilai tanggal GEDCOM 7 (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE adalah Value yang memuat string nilai tanggal (`DateValue`) [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Tanggal yang oleh sumbernya ditulis dengan kalender selain Gregorian (Julian, dan lain-lain) dipertahankan **sebagaimana tertulis**.

## Layout

- Kode: kode langsung Value `0x26` (byte genap)·`0x27` (byte ganjil). Keluarga TIME.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = byte ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          byte ASCII string tanggal GEDCOM / 0x00 terakhir jika ganjil
```

## Interpretasi dan validitas

- Deretan byte adalah string ASCII yang mengikuti tata bahasa `DateValue` GEDCOM 7. String kosong adalah invalid. GEDCOM mengizinkan `DateValue` kosong, tetapi jika tidak ada nilai, record tidak ditulis.
- Inti tata bahasa: `[kalender] [[hari] bulan] tahun [BCE]`. Di depannya ditempelkan `ABT`·`CAL`·`EST` (perkiraan), `BEF`·`AFT`·`BET … AND …` (rentang), dan `FROM … TO …` (periode). Pemisahnya satu spasi.
- Kalender: `GREGORIAN` (default jika dihilangkan), `JULIAN`, `FRENCH_R`, `HEBREW`, tag ekstensi. Nama bulan ditetapkan per kalender (Julian memakai `JAN`…`DEC` yang sama dengan Gregorian).
- Tahun bergaya **historis**. Tidak ada tahun 0 dan SM diberi `BCE` (`44 BCE` = tahun 44 SM). Berbeda satu tahun dari gaya astronomis EDTF·GREGORIAN-DATE.
- schema hanya memeriksa format byte: ASCII `0x20`~`0x7E`, tidak kosong, tanpa spasi di depan·belakang. Tata bahasa dan apakah harinya benar-benar ada diperiksa produsen. Contoh: `gedcom.ParseDate` dari `github.com/cacack/gedcom-go/v3` (MIT). `Validate` pustaka ini hanya memeriksa hari pada kalender Gregorian sehingga meloloskan `JULIAN 30 FEB 1100`, dan `ToGregorian` tidak benar-benar mengonversi presisi tahun·bulan. Pemeriksaan keberadaan tanggal dan normalisasi dilakukan terpisah.
- **Tempat pemakaian:** tanggal Gregorian ditulis dengan [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/) atau [EDTF](/id/grammar/value/time/edtf/). GEDCOM-DATE dipakai untuk tanggal kalender lain yang notasi aslinya harus dipertahankan.

## Dipakai bersama nilai yang dinormalisasi

- Untuk membandingkan·mengindeks tanggal yang sama pada sumbu waktu, diperlukan nilai Gregorian. Presisi hari berpadanan tepat dengan GREGORIAN-DATE pada hari yang sama, dan presisi tahun·bulan dengan EDTF interval Gregorian periode itu (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Cara memuat notasi asli (GEDCOM-DATE) dan nilai yang dinormalisasi bersama sebagai dua Value belum ditetapkan (masalah terbuka).

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Length](/id/grammar/record/)).

## Contoh

| Tanggal | Byte | WORD total |
|---|---|---|
| `JULIAN 1300` | 11 (ganjil) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Dasar standar

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). Lisensi repositori spesifikasi adalah Apache 2.0. GEUL hanya merujuk format dan tidak memindahkan isi spesifikasi.
- ISO 8601, EDTF, XSD, dan pengenal kalender CLDR (`u-ca`) tidak memiliki kalender Julian. GEDCOM 7 adalah format pertukaran terbuka yang menangani awalan kalender·SM·presisi·kualifier dalam satu tata bahasa.

## Masalah terbuka

- Cara menulis notasi asli dan nilai yang dinormalisasi bersama (cara menghubungkan keduanya dalam satu TRIPLE).
- Pemeriksaan tata bahasa GEDCOM pada schema.
- Presisi abad·dekade. GEDCOM tidak memiliki format yang sesuai. Tanggal yang tidak dapat dipindahkan dari Wikidata dibiarkan sebagai teks asli UTF8-TEXT.

## Halaman terkait

- [Value](/id/grammar/value/), [EDTF](/id/grammar/value/time/edtf/), [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/)
