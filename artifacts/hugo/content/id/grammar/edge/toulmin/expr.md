---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR adalah layout ekspresi kondisi yang dipakai PREDICATE-DECLARE (Codec 0x61). Memuat pohon ekspresi kondisi dengan tabel label sendiri dan record ekspresi yang dibentangkan dalam urutan prefiks."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR adalah layout untuk menulis ekspresi kondisi Rules TANGEUL. Dipakai oleh Codec `0x61` PREDICATE-DECLARE (deklarasi predikat). Pohon ekspresi kondisi dibentangkan dalam urutan prefiks, dan string di dalam ekspresi ditunjuk dengan tabel label di dalam record. Karena itu ia lengkap sendiri tanpa record TEXT.

## Layout

```
ID                     record LOCAL Reference (Edge Id)
Jumlah node 1 WORD      jumlah seluruh record ekspresi
Jumlah label 1 WORD
Label × jumlah label    record Value UTF8-TEXT
Record ekspresi × jumlah node   urutan prefiks
```

- Label adalah string seperti nama field, nilai string, langkah path, dan nama fungsi. String kosong juga menjadi label. Record ekspresi menunjuk label dengan indeks (1 WORD) yang diberi nomor mulai dari 0.
- Record ekspresi menaruh anak secara berurutan setelah induk (urutan prefiks). Dengan jumlah anak setiap record dan urutan ini, pohon ditentukan secara unik.

## Record ekspresi

Record ekspresi dimulai dengan header 1 WORD.

```
Header 1 WORD    2 bit bawah jenis (b15–14) | 1 bit atas jenis (b13) | jumlah anak 13 bit (b12–0)
```

Jenis = `(b13 << 2) | b15–14`.

| Jenis | Nama | Jumlah anak | Setelah header |
|---|---|---|---|
| 0 | COMPARE | 0 | Operator perbandingan 1 WORD, label field 1 WORD, slot nilai |
| 1 | LOGIC | n | Operator logika 1 WORD |
| 2 | NOT | 1 | Tidak ada |
| 3 | EITHER | n | Tidak ada |
| 4 | EXISTS | 1 | Operator kuantifikasi 1 WORD, operand target, label nama pengikat 1 WORD |
| 5 | CALL | 0 | Label alias 1 WORD, label nama fungsi 1 WORD |
| 6 | COMPARE-X | 0 | Operator perbandingan 1 WORD, label field 1 WORD, penanda kiri 1 WORD [+ operand], slot nilai |
| 7 | Cadangan | | |

- Record anak mengikuti field setelah header. Anak EXISTS adalah satu kondisi.
- COMPARE adalah perbandingan `<field> <operator> <nilai>` tanpa operand di kedua sisi. Jika ada operand di salah satu sisi, pakai COMPARE-X.
- Jika penanda kiri COMPARE-X adalah `1`, operand mengikuti; jika `0`, tidak ada. Jika ada operand kiri, label field adalah string kosong.
- CALL adalah pemanggilan fungsi host pada posisi predikat. Jika fungsi dokumen ini, label alias adalah string kosong.

### Slot nilai

```
Jenis nilai 1 WORD   0 angka, 1 string, 2 operand
Nilai                0: record Value UNSIGNED-INTEGER
                     1: label 1 WORD
                     2: operand (hanya pada COMPARE-X)
```

- Jika string nilai persis sama dengan notasi desimal kanonik bilangan bulat non-negatif, ia ditulis sebagai Value UNSIGNED-INTEGER. Nilai lain ditulis sebagai label. Karena itu string nilai dipulihkan apa adanya.

### Operand

```
Jenis operand 1 WORD   0 path, 1 referensi kriteria, 2 pemanggilan fungsi
Path·referensi kriteria   jumlah langkah 1 WORD + label 1 WORD × jumlah langkah
Pemanggilan fungsi        label alias 1 WORD + label nama fungsi 1 WORD
```

- Path adalah path data input, dan referensi kriteria adalah path kriteria penilaian (SPEC) yang disuntikkan dengan `with`.

### Kode operator

| Kode | Operator perbandingan |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Kode | Operator logika |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Kode | Operator kuantifikasi |
|---|---|
| `0x0321` | any |

### Evaluasi input yang tidak diketahui

Operator perbandingan dievaluasi dengan 3 nilai (benar, salah, belum ditentukan U) saat input adalah penanda slot. Untuk NO-VALUE, `is empty` benar dan perbandingan lain salah. Untuk UNKNOWN-VALUE, `is not empty` benar sedangkan `equals`·`is in`·perbandingan ukuran adalah U. Untuk ABSENT dan tanpa pernyataan, semua operator adalah U. Operator logika mengikuti Kleene kuat 3 nilai, dan jika predikat U maka putusan node adalah Review. Evaluasi ini adalah inti tetap ([TOULMIN](/id/grammar/edge/toulmin/#memutuskan-di-atas-ketidaktahuan)).

## Interpretasi dan validitas

- Jumlah node harus sama dengan jumlah record ekspresi yang dibentangkan. Posisi setelah membaca record ekspresi terakhir harus tepat sama dengan akhir record.
- Jika indeks label sama dengan atau melebihi jumlah label, ditolak.
- Jumlah anak NOT dan EXISTS harus 1.
- Jenis yang tidak dikenal (7) atau jenis nilai·jenis operand yang tidak dikenal ditolak.
- Jumlah anak adalah 13 bit (maksimum 8191).

## Halaman terkait

- [TOULMIN](/id/grammar/edge/toulmin/), [NODE](/id/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/id/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/)
