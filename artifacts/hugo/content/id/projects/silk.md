---
title: "SILK — Mesin Indeks dan Pencarian Khusus GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "pencarian", "indeks", "GEUL", "Go"]
summary: "Mesin yang mengindeks dan menelusuri arsip GEUL pack per rekaman. Karena data sudah terstruktur sejak ditulis, pencarian tinggal perbandingan bilangan bulat dan penelusuran rentang. Kueri 0,1–4 ms pada Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /id/silk/
---

SILK adalah **mesin indeks dan pencarian khusus GEUL**. Tanpa mendekode seluruh dokumen GEUL, SILK menjawab kueri seperti "dokumen mana yang menyatakan bahwa pekerjaan (P106) adalah fisikawan (Q169470)?" hanya dengan indeks rekaman.

| | |
|---|---|
| Status | Pengembangan awal. Algoritme pencarian sedang divalidasi, dan format dapat berubah sebelum rilis pertama |
| Bahasa | Go |
| Masukan | Arsip GEUL pack (tanpa kompresi) |
| Lisensi | CC0 |
| Repositori | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Tesis Inti

Yang sulit bukan pencariannya. **Masalahnya adalah data tanpa struktur.**

```
Cara lama: tulis dulu → tebak strukturnya belakangan (tokenisasi, embedding, analisis)
GEUL:      strukturkan saat menulis → pencarian tinggal perbandingan bilangan bulat dan penelusuran rentang
```

Rekaman GEUL sudah memuat field seperti subjek, predikat, objek, dan bahasa sebagai ID bilangan bulat pada posisi tetap. SILK hanya mengambil field tersebut dan menyimpannya dalam keadaan terurut.

## Kecocokan dengan GEUL

| Sifat GEUL | Yang diperoleh SILK |
|---|---|
| Satu TAG WORD 16-bit memuat jenis (Kind·Codec) dan panjang | Rekaman dapat disaring dan dilewati tanpa codebook |
| Field Edge adalah rekaman pada posisi tetap | Kunci diambil berdasarkan posisi. Tidak perlu aturan parsing tersendiri |
| Kosakata terkendali berupa ID bilangan bulat (Q, P, bahasa) | Kesamaan dibandingkan sebagai bilangan bulat, tanpa normalisasi string |
| pack terdiri atas objek imutabel dan generasi | Indeks juga dibangun dari segmen imutabel dan generasi, sehingga snapshot aman |
| Konversi bersifat deterministik | Masukan yang sama menghasilkan indeks yang sama. Hasil inkremental dapat dicocokkan byte demi byte dengan indeks yang dibangun dari awal |

Dokumen GEUL tidak pernah diurutkan ulang. Indeks hanyalah **tampilan (view)** yang terurut; byte yang dipublikasikan, hash konten, dan tanda tangan tetap tidak berubah.

## Struktur

### Masukan

SILK membaca arsip GEUL pack melalui [gogeul](https://github.com/geul-org/gogeul). Karena indeks menunjuk posisi byte di dalam data pack, set harus menyimpan rekaman tanpa kompresi (`GEULCOMPRESS=none`). Kompresi zstd dipakai untuk distribusi dan penyimpanan arsip; lapisan pencarian memakai pack tanpa kompresi.

### Spesifikasi Partisi

Untuk setiap jenis TAG, **kunci partisi** dan **kunci urut** dideklarasikan sebagai field berposisi tetap pada rekaman. Predikat, bahasa, dan sejenisnya tidak di-hardcode; tabel di bawah adalah nilai bawaan untuk dokumen Wikidata.

| TAG | Kunci partisi | Kunci urut |
|---|---|---|
| TRIPLE | Predikat (Predicate) | Objek (Object) |
| QUALIFIER | Properti (Property) | Nilai (Value) |
| LABEL·ALIAS·DESCRIPTION | Bahasa | Subjek (Subject) |
| SOURCE | tidak ada | Asal (Origin) |
| REFERENCE-NODE | tidak ada | Objek (Object) |

- Kunci adalah beberapa byte pertama (slot) dari rekaman field. Jika rekaman muat dalam slot, kesamaannya tepat; jika lebih panjang, kunci hanya memilih kandidat.
- Validasi spesifikasi menolak field yang posisinya hanya bisa diketahui dengan codebook, atau field yang panjangnya tak terbatas, sebagai kunci partisi.
- Spesifikasi diidentifikasi dengan hash kontennya. Jika spesifikasi berubah, hanya TAG tersebut yang dibangun ulang.

### Run, Inkremen, dan Penggabungan

| Elemen | Peran |
|---|---|
| Run terurut | Segmen imutabel yang diurutkan berdasarkan (kunci urut, dokumen, offset) per partisi. Ditelusuri dengan pencarian biner |
| Segmen tambahan | Hanya memuat revisi baru dari pembaruan inkremental (`silk index update`). Dipindai |
| Bitmap revisi hidup | Menandai revisi lama dari dokumen yang berubah sebagai mati, alih-alih menghapusnya |
| Penggabungan bertingkat ukuran | Menggabungkan run dalam tingkat ukuran yang sama dengan merge O(n), dan jika baris mati banyak, menggabungkannya sampai ke run dasar |
| Generasi | Generasi manifest diganti secara atomik. Pembaca mengunci satu generasi, sehingga snapshot tetap terjaga bahkan selama penggabungan |

Penggabungan dapat dibatasi hanya saat menganggur (`-idle`, menyisakan 30% CPU dan memori). Prosesnya berhenti di batas partisi dan dilanjutkan dari checkpoint.

### Kueri

1. **Kondisi kesamaan**: temukan partisi, lalu lakukan pencarian biner pada run terurut.
2. **Beberapa kondisi**: lakukan merge join berdasarkan dokumen (subjek). Semua kondisi harus terpenuhi di dalam satu dokumen.
3. **Verifikasi presisi**: dekode rekaman kandidat dengan gogeul, bandingkan per field, dan baca Edge Id.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Hasil Pengukuran

Diukur pada Wikidata Q1–Q10000 dan 16.696 dokumen properti (271 MB, 7,07 juta rekaman indeks). 8 thread, nilai terbaik dari 7 kali percobaan, tidak termasuk waktu startup proses.

### Kueri

| Kueri | Dokumen hasil | Cara sebelumnya (pemindaian penuh) | Indeks SILK |
|---|---:|---:|---:|
| P106=Q169470 (pekerjaan = fisikawan) | 55 | ~20ms | 0,12ms |
| P31=Q5 (manusia) | 1.579 | ~19ms | ~1ms |
| manusia + fisikawan | 54 | ~38ms | ~1ms |
| LABEL ko | 9.746 | (tidak bisa) | ~4ms |

- Cara sebelumnya memindai seluruh peta rekaman TRIPLE.
- Untuk LABEL ko, sebagian besar waktunya habis untuk membaca 9.746 rekaman dari pack guna verifikasi presisi.

### Ukuran, Build, dan Inkremen

| Item | Nilai |
|---|---|
| Ukuran indeks | 113MB (rata-rata 15,7B per rekaman) |
| Build | ~3 detik (parsing dokumen satu thread) |
| Pembaruan inkremental (4.217 revisi berubah) | 1,8 detik |
| Hasil inkremental | Setelah 2 kali pembaruan, 2 kali penggabungan, serta interupsi lalu dilanjutkan, hasil kueri tetap identik byte demi byte dengan indeks yang dibangun dari awal |
| Amplifikasi tulis | Kumulatif 1,31 (1,71 jika dibangun ulang setiap kali) |

- Jika diekstrapolasi ke seluruh Wikidata (sekitar 7,5 miliar rekaman), ukuran indeks sekitar 110 GB (**perkiraan**).
- Biayanya adalah ukuran: sekitar 4 kali lebih besar dari peta sederhana 4 B per rekaman. Penyempitan lebar slot dan tanda tangan entitas menjadi bahan kajian berikutnya.

### Pemindaian Tanda Tangan (pengukuran awal untuk tanda tangan entitas)

Waktu yang dikonversi untuk memindai 100 juta tanda tangan 128-bit dengan mask dan pola (i7-14700K, AVX2).

| Implementasi | Waktu |
|---|---:|
| NumPy 1 thread | ~1 detik |
| Go 1 thread | ~134ms |
| Go 8 thread | ~27ms |
| Go 16–20 thread | ~23ms (batas bandwidth memori) |

Yang membuat perbedaan bukan bahasanya, melainkan **loop terfusi tanpa array perantara dan multithreading**.

## Hubungan dengan Pencarian Vektor

Bukan pengganti, melainkan pembagian peran.

| | SILK | Pencarian vektor |
|---|---|---|
| Kueri yang ditangani | Kueri terstruktur (kondisi predikat, objek, bahasa, entitas) | Kemiripan makna yang sulit dinyatakan sebagai struktur |
| Hasil | Himpunan yang memenuhi kondisi (tepat) | Peringkat kemiripan (aproksimasi) |
| Prasyarat | Data harus sudah terstruktur dalam GEUL | Cukup teks asli atau embedding |

Untuk kueri yang mencari fakta yang dinyatakan dalam GEUL, SILK tepat dan murah. Untuk teks asli tanpa struktur atau kueri yang mencari "sesuatu yang mirip", pencarian vektor lebih cocok.

## Posisi dan Langkah Berikutnya

SILK adalah **teknologi pencarian yang dipakai WMS (koordinator penyimpanan dan pengambilan GEUL)**. Penilaian apakah pernyataan yang ditemukan itu benar ditangani oleh mesin penilai tersendiri.

| Langkah berikutnya | Isi |
|---|---|
| Tanda tangan entitas | Untaian bit lebar tetap 16–128 bit per entitas. Pengguna mendeklarasikan field-nya (enumerasi, one-hot, Bloom, prefiks, rentang). Ini filter tahap pertama yang bersifat aproksimasi, diikuti verifikasi presisi. Saat ini masih tahap perencanaan (baru sebagian ada di pustaka, belum masuk ke indeks) |
| Spesifikasi sebagai dokumen GEUL | Mendeklarasikan spesifikasi JSON sebagai dokumen GEUL dan membaca tata letak dari dokumen spesifikasi codec (DECLARE·FIELD) |
| Indeks perakitan pernyataan | Indeks Target yang langsung menemukan TRIPLE yang ditunjuk oleh QUALIFIER·SOURCE |
| Persiapan skala besar | Batas atas memori untuk build dan penggabungan, paralelisasi parsing saat build |

Gagasan awal (2026-03) adalah desain Python·NumPy yang memindai pengenal entitas 64-bit dengan operasi AND bit. Kini telah berubah menjadi mesin Go yang langsung mengindeks rekaman GEUL.

## Repositori dan Lisensi

- Repositori: <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Instalasi: `go install github.com/geul-org/silk/cmd/silk@latest`
- Lisensi: karya kami berlisensi CC0 1.0. Komponen pihak ketiga mengikuti lisensinya masing-masing (NOTICE di repositori).
