---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE adalah Codec TOULMIN yang mendeklarasikan predikat (ekspresi penilaian)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE adalah Codec TOULMIN yang mendeklarasikan predikat (ekspresi penilaian). Layout-nya adalah EXPR. EXPR adalah layout yang menulis ekspresi kondisi TANGEUL Rules. Pohon ekspresi kondisi dibentangkan dalam urutan pra-urut, dan string di dalam ekspresi ditunjuk melalui tabel label di dalam record. Karena itu ia lengkap dengan sendirinya tanpa record TEXT.

| Butir | Nilai |
|---|---|
| Nama | `PREDICATE-DECLARE` (BIND dokumen spesifikasi `PREDICATE-DECLARE`) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001010/` (target DECLARE `1010`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 1 |
| Kind | Edge · keluarga: TOULMIN, kelompok: deklarasi, layout: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi predikat. Fungsi dan ekspresi penilaian, kriteria penilaian (Spec), kontrak fakta (Ground) |
| Sisi Hugo | `edge/toulmin/expr.md` |

## Layout {#레이아웃}

```
ID                     LOCAL Reference record (Edge Id)
jumlah node 1 WORD     jumlah seluruh record ekspresi
jumlah label 1 WORD
label × jumlah label   record UTF8-TEXT Value
record ekspresi × jumlah node   urutan pra-urut
```

- Label adalah string seperti nama field, nilai string, langkah path, dan nama fungsi. String kosong juga menjadi label. Record ekspresi menunjuk label dengan indeks yang dihitung dari 0 (1 WORD).
- Record ekspresi menempatkan induk lalu anak-anaknya secara berurutan (pra-urut). Jumlah anak setiap record dan urutan ini menentukan satu pohon secara tunggal.

## Record ekspresi {#식-레코드}

Record ekspresi diawali header 1 WORD.

```
header 1 WORD    2 bit bawah jenis (b15–14) | 1 bit atas jenis (b13) | jumlah anak 13 bit (b12–0)
```

Jenis = `(b13 << 2) | b15–14`.

| Jenis | Nama | Jumlah anak | Setelah header |
|---|---|---|---|
| 0 | COMPARE | 0 | 1 WORD operator perbandingan, 1 WORD label field, slot nilai |
| 1 | LOGIC | n | 1 WORD operator logika |
| 2 | NOT | 1 | tidak ada |
| 3 | EITHER | n | tidak ada |
| 4 | EXISTS | 1 | 1 WORD operator kuantifikasi, operan sasaran, 1 WORD label nama pengikat |
| 5 | CALL | 0 | 1 WORD label alias, 1 WORD label nama fungsi |
| 6 | COMPARE-X | 0 | 1 WORD operator perbandingan, 1 WORD label field, 1 WORD penanda kiri [+ operan], slot nilai |
| 7 | Reserved | | |

- Record anak mengikuti field setelah header. Anak EXISTS adalah satu kondisi.
- COMPARE adalah perbandingan `<field> <operator> <nilai>` tanpa operan di kedua sisi. Jika ada operan di salah satu sisi, dipakai COMPARE-X.
- Jika penanda kiri COMPARE-X bernilai `1`, operan menyusul; jika `0`, tidak ada. Jika ada operan kiri, label field adalah string kosong.
- CALL adalah pemanggilan fungsi host pada posisi predikat. Jika fungsinya milik dokumen ini, label alias adalah string kosong.

### Slot nilai {#값-자리}

```
jenis nilai 1 WORD   0 angka, 1 string, 2 operan
nilai                0: record UNSIGNED-INTEGER Value
                     1: 1 WORD label
                     2: operan (hanya pada COMPARE-X)
```

- Jika string nilai persis sama dengan notasi desimal kanonik bilangan bulat tak negatif, ia ditulis sebagai UNSIGNED-INTEGER Value. Nilai lainnya ditulis sebagai label. Dengan demikian string nilai pulih apa adanya.

### Operan {#피연산자}

```
jenis operan 1 WORD    0 path, 1 rujukan kriteria, 2 pemanggilan fungsi
path, rujukan kriteria   jumlah langkah 1 WORD + 1 WORD label × jumlah langkah
pemanggilan fungsi       1 WORD label alias + 1 WORD label nama fungsi
```

- Path adalah path pada data masukan; rujukan kriteria adalah path pada kriteria penilaian (SPEC) yang disuntikkan dengan `with`.

### Kode operator {#연산자-코드}

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

### Evaluasi masukan yang tidak diketahui {#미상-입력의-평가}

Operator perbandingan dievaluasi dengan tiga nilai (benar, salah, tak tentu U) ketika masukan adalah penanda slot. Pada NO-VALUE, `is empty` bernilai benar dan perbandingan lain bernilai salah. Pada UNKNOWN-VALUE, `is not empty` bernilai benar, sedangkan `equals`, `is in`, dan perbandingan ukuran bernilai U. Pada ABSENT dan tanpa pernyataan, semua operator bernilai U. Operator logika mengikuti tiga nilai kuat Kleene, dan jika predikat bernilai U, penilaian node adalah Review. Evaluasi ini adalah inti tetap ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interpretasi dan validitas {#해석과-유효성}

- Jumlah node harus sama dengan jumlah record ekspresi yang dibentangkan. Posisi setelah membaca record ekspresi terakhir harus tepat sama dengan akhir record.
- Jika indeks label sama dengan atau lebih besar dari jumlah label, ditolak.
- Jumlah anak NOT dan EXISTS harus 1.
- Jenis yang tidak dikenal (7) atau jenis nilai dan jenis operan yang tidak dikenal ditolak.
- Jumlah anak berukuran 13 bit (maksimum 8191).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1010`). Pada layout EXPR, nilai mentah di depan (jumlah node, jumlah label) menentukan jumlah pengulangan sehingga tidak dapat dideklarasikan dengan FIELD; deklarasi field menjadi masalah terbuka (pengulangan [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001010/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
