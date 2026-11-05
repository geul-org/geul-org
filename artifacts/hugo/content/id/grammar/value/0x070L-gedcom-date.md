---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE adalah Value berupa string nilai tanggal GEDCOM 7 yang menyimpan tanggal kalender lain, seperti kalender Julian, persis seperti yang tertulis (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE adalah Value berupa string nilai tanggal GEDCOM 7 yang menyimpan tanggal kalender lain, seperti kalender Julian, persis seperti yang tertulis (Codec 0x070L/0x071L).

| Butir | Nilai |
|---|---|
| Nama | `GEDCOM-DATE` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x070L`·`0x071L` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 16~17 |
| Kind | Value · keluarga: TIME |
| Deskripsi indeks | String nilai tanggal GEDCOM 7. Menyimpan notasi asli kalender lain (Julian dan sebagainya). Jumlah byte genap·ganjil |
| Sisi Hugo | `value/time/gedcom-date.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | genap | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | ganjil | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

GEDCOM-DATE adalah Value yang memuat string nilai tanggal (`DateValue`) dari [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Tanggal yang dalam sumbernya ditulis dengan kalender selain Gregorian (Julian dan sebagainya) disimpan **persis seperti yang tertulis**.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x070L` (jumlah byte genap)·`0x071L` (jumlah byte ganjil). Keluarga TIME.
- Jumlah byte ditentukan oleh bit paling rendah Codec dan jumlah Payload WORD. Rumusnya `2 × jumlah Payload WORD − bit paling rendah`, dan Byte Count tidak dipakai ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = byte ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          byte ASCII string tanggal GEDCOM / jika ganjil, 0x00 di akhir
```

## Interpretasi dan validitas {#해석과-유효성}

- Deret byte adalah string ASCII yang mengikuti tata bahasa `DateValue` GEDCOM 7. String kosong tidak valid. GEDCOM mengizinkan `DateValue` kosong, tetapi jika tidak ada nilai, record tidak ditulis.
- Ringkasan tata bahasa: `[kalender] [[hari] bulan] tahun [BCE]`. Di depannya dapat ditambahkan `ABT`·`CAL`·`EST` (perkiraan), `BEF`·`AFT`·`BET … AND …` (rentang), `FROM … TO …` (periode). Pemisahnya satu spasi.
- Kalender: `GREGORIAN` (bawaan jika dihilangkan), `JULIAN`, `FRENCH_R`, `HEBREW`, tag ekstensi. Nama bulan ditentukan per kalender (kalender Julian memakai `JAN`…`DEC` yang sama dengan Gregorian).
- Tahun bergaya **historis**. Tidak ada tahun 0, dan tahun SM diberi `BCE` (`44 BCE` = 44 SM). Selisih satu tahun dengan gaya astronomis pada EDTF·GREGORIAN-DATE.
- schema hanya memeriksa format byte: ASCII `0x20`~`0x7E`, tidak kosong, tanpa spasi di awal dan akhir. Tata bahasa dan keberadaan tanggal sebenarnya diperiksa oleh produsen. Contoh: `gedcom.ParseDate` dari `github.com/cacack/gedcom-go/v3` (MIT). `Validate` pustaka ini hanya memeriksa hari pada kalender Gregorian sehingga meloloskan `JULIAN 30 FEB 1100`, dan `ToGregorian` tidak benar-benar mengonversi presisi tahun·bulan. Pemeriksaan keberadaan dan normalisasi tanggal dilakukan secara terpisah.
- **Tempat pemakaian:** tanggal Gregorian ditulis dengan [GREGORIAN-DATE](0x06AL-gregorian-date.md) atau [EDTF](0x06EL-edtf.md). GEDCOM-DATE dipakai untuk tanggal kalender lain yang notasi aslinya harus dipertahankan.

## Digunakan bersama nilai yang dinormalisasi {#정규화된-값과-함께-쓰기}

- Untuk membandingkan·mengindeks tanggal yang sama pada sumbu waktu, diperlukan nilai Gregorian. Untuk presisi hari, padanan yang tepat adalah GREGORIAN-DATE pada hari yang sama; untuk presisi tahun·bulan, EDTF rentang Gregorian periode itu (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Cara memuat notasi asli (GEDCOM-DATE) dan nilai yang dinormalisasi sebagai dua Value sekaligus belum ditetapkan (masalah terbuka).

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Length](../record.md)).

## Contoh {#예시}

| Tanggal | Byte | Total WORD |
|---|---|---|
| `JULIAN 1300` | 11 (ganjil) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Dasar standar {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). Lisensi repositori spesifikasinya adalah Apache 2.0. GEUL hanya merujuk format dan tidak menyalin isi spesifikasi.
- ISO 8601, EDTF, XSD, dan pengenal kalender CLDR (`u-ca`) tidak memiliki kalender Julian. GEDCOM 7 adalah format pertukaran terbuka yang menangani awalan kalender, SM, presisi, dan kualifikator dalam satu tata bahasa.

## Masalah terbuka {#열린-문제}

- Cara menulis notasi asli dan nilai yang dinormalisasi bersama (cara menghubungkan keduanya dalam satu TRIPLE).
- Pemeriksaan tata bahasa GEDCOM pada schema.
- Presisi abad·dasawarsa. GEDCOM tidak memiliki format itu. Tanggal yang tidak dapat dipindahkan dari Wikidata disimpan sebagai teks aslinya dalam UTF8-TEXT.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000700/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec untuk `GEDCOM-DATE-EVEN` (`0x070L`). Dokumen Codec anggota lain (`GEDCOM-DATE-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
