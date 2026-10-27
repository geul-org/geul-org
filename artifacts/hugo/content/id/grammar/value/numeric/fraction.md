---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION adalah Value pecahan yang memuat pembilang (bilangan bulat·desimal) dan penyebut (bilangan bulat·desimal tanpa tanda) persis seperti ditulis dalam teks asli, tanpa disederhanakan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION adalah Value yang menyatakan pecahan yang tertulis dalam teks asli dengan mempertahankan notasinya. Kode langsung Value `0x07`, keluarga NUMERIC. Pembilang dan penyebut masing-masing adalah record Value lengkap. Tidak disederhanakan. FRACTION memuat pecahan yang bentuk tertulisnya sendiri adalah catatannya, seperti "dua pertiga" dan "lima per seratus" dalam peraturan perundang-undangan serta bagian desimal `23.45/1256.1` dalam buku tanah.

## Layout

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length extension TAG] jika total 15 WORD atau lebih
numerator         1 record Value: SIGNED-INTEGER atau SIGNED-DECIMAL
denominator       1 record Value: UNSIGNED-INTEGER atau UNSIGNED-DECIMAL
```

## Interpretasi dan validitas

- numerator adalah tepat satu record [SIGNED-INTEGER](/id/grammar/value/numeric/signed-integer/) (`0x01`) atau [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/) (`0x10`).
- denominator adalah tepat satu record [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/) (`0x02`) atau [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- Ini daftar tertutup. Value lain, FRACTION itu sendiri (dilarang bersarang), dan penanda slot (`0x0000` dan sebagainya) tidak diterima.
- Kedua record masing-masing membawa panjangnya sendiri sehingga batasnya tidak ditulis terpisah. Kursor setelah membaca kedua record harus tepat sama dengan akhir Payload.
- Record di dalamnya juga mengikuti bentuk kanonis masing-masing Codec (WORD minimum untuk bilangan bulat·koefisien). Jika ada record dalam yang tidak kanonis, seluruh FRACTION adalah invalid.
- Nilainya adalah `numerator / denominator`.

### Pelestarian notasi

- **Bilangan bulat dan desimal**: jika komponen dalam teks asli adalah bilangan bulat (tanpa titik desimal), dipakai record INTEGER; jika ada titik desimal, dipakai record DECIMAL. Menulis komponen sebagai DECIMAL dengan eksponen `E = 0` adalah invalid. Karena itu satu notasi hanya punya satu urutan byte.
- C dan E pada komponen DECIMAL memuat jumlah digit teks asli apa adanya. `23.450` adalah `23450×10^-3` dan merupakan Value yang berbeda dari `23.45`.
- **Tidak disederhanakan.** `2/4` dan "lima per seratus" (`5/100`) ditulis apa adanya. Jika byte-nya sama, notasi aslinya sama.
- Pecahan berpenyebut 1 (`3/1`) juga ditulis apa adanya jika teks asli menulisnya begitu. Jika teks asli berupa bilangan bulat, dipakai Codec bilangan bulat, bukan FRACTION. Jika teks asli berupa desimal (`0.5`, `5%`), dipakai DECIMAL.
- Tanda hanya ditaruh pada pembilang. Penyebut adalah Codec tanpa tanda.
- Penyebut yang nilainya 0 adalah invalid (baik `0` maupun `0.0`).

### Perbandingan

- Lapisan perbandingan menghitung FRACTION sebagai bilangan rasional eksak `(C1 × 10^E1) / (C2 × 10^E2)` (`E = 0` untuk komponen INTEGER). Tidak dihampiri dengan floating-point.
- Perbandingan·pengurutan·penentuan duplikat memakai nilai ini, sedangkan penyimpanan·tanda tangan·hash konten memakai notasi (byte). `2/4`, `1/2`, dan `0.5` bernilai sama tetapi byte-nya berbeda.
- Penentuan kuorum ("sekurang-kurangnya dua pertiga hak suara pemegang saham yang hadir") dibandingkan dengan nilai eksak ini.

## Panjang

- Total adalah TAG 1 WORD + (Length extension TAG) + dua record. Record bilangan bulat adalah TAG 1 + Payload 1 WORD atau lebih, dan record desimal adalah TAG 1 + eksponen 2 + koefisien 1 WORD atau lebih.
- Pecahan bilangan bulat kecil adalah 5 WORD, pecahan desimal kecil 9 WORD. Jika 15 WORD atau lebih, dipakai panjang extension ([Record dan TAG WORD](/id/grammar/record/)).

| Teks asli | Komponen | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Contoh

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Hubungan dengan format lain

- amount·lower·upper pada [QUANTITY](/id/grammar/value/numeric/quantity/) menerima FRACTION. "Dua pertiga hak suara yang hadir" dapat ditulis sebagai QUANTITY tanpa satuan dengan amount `2/3`.
- Dokumen spesifikasi geul.org `0x0000/0x0000000000000807` menuliskannya dengan dua field record: numerator (`0801`·`0810`) dan denominator (`0802`·`0811`) ([Dokumen spesifikasi Codec](/id/grammar/codec-spec/)).
- Jika diperlukan pecahan int64 tetap yang wajib disederhanakan, pakai format Issuer [RATIONAL-I64](/id/grammar/value/etc/rational-i64/).

## Masalah terbuka

1. Pelestarian notasi pecahan campuran (`1 2/3`).
2. Format yang memuat pecahan yang komponennya bersatuan (luas/luas) sebagai dua QUANTITY. FRACTION tidak memuat satuan.
3. Kriteria notasi persen·permil (`5%`, `5‰`): DECIMAL dengan satuan atau FRACTION (`5/100`).
4. Pecahan bertingkat (FRACTION di pembilang·penyebut). Untuk saat ini dilarang.

## Halaman terkait

- [Value](/id/grammar/value/), [QUANTITY](/id/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/id/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/id/grammar/value/etc/rational-i64/)
