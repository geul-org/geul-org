---
title: "Mengapa 16-Bit?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-bit", "biner", "stream"]
summary: "Satu word 16-bit dirancang menjadi unit bagi tiga dunia: aliran jaringan, format file, dan kosakata LLM. Mengapa 16 bit, bukan 8, 32, atau panjang variabel."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Satu Kata Menembus Tiga Dunia

---

## Tiga Dunia

Ada tiga dunia dalam ilmu komputer.

**Dunia jaringan.**
Data mengalir sebagai stream byte.
Byte masuk melalui soket TCP, dan byte keluar.
Kosakata insinyur jaringan adalah paket, header, dan payload.

**Dunia penyimpanan.**
Data disimpan secara persisten dalam format file.
Ditulis ke disk, dibaca dari disk.
Kosakata insinyur penyimpanan adalah blok, offset, dan alignment.

**Dunia AI.**
Data diproses sebagai urutan token.
LLM menerima token sebagai input dan menghasilkan token sebagai output.
Kosakata insinyur AI adalah embedding, attention, dan konteks.

Ketiga dunia ini berbicara dalam bahasa yang berbeda.
Dan di antara mereka, penerjemahan selalu diperlukan.

---

## Biaya Penerjemahan

Mari kita telusuri jalur yang dilalui data dalam sistem AI modern.

Pengetahuan disimpan dalam file. Sebagai JSON atau teks biasa.

Untuk menyampaikan ini kepada AI:

1. Buka file dan baca teksnya.
2. Parse teksnya. Jika JSON, interpretasikan struktur dan ekstrak field.
3. Masukkan teks yang diekstrak ke tokenizer.
4. Tokenizer mengubah teks menjadi urutan ID token.
5. Urutan token dimasukkan ke LLM.

Ketika AI menghasilkan respons:

6. LLM menghasilkan urutan token.
7. Decode token kembali menjadi teks.
8. Serialisasi teks ke format terstruktur.
9. Tulis data yang diserialisasi ke file.

Operasi sederhana "baca dan tulis" membutuhkan sembilan langkah.

Setiap langkah membutuhkan waktu.
Setiap langkah membutuhkan memori.
Setiap langkah berisiko kehilangan informasi.

Langkah 3 dan 4 -- proses tokenisasi -- terkenal bermasalah.
Karena batas kata dalam bahasa alami tidak sejajar dengan batas token tokenizer,
nama diri seperti "Yi Sun-sin" bisa dipecah menjadi fragmen sembarang,
atau satu unit semantik tersebar di beberapa token.

Inilah harga dari tiga dunia yang berbicara bahasa berbeda.

---

## Bagaimana Jika Satu Unit Menembus Ketiga Dunia?

Dalam bahasa ini, satu word berukuran 16 bit (2 byte).

Satu word 16-bit ini dirancang untuk memainkan tiga peran sekaligus.

**Unit aliran byte.**
Word 16-bit mengalir berurutan melalui jaringan.
Big Endian. Selaras per 2 byte.
Cukup dibaca sesuai urutan kedatangannya.

**Unit format file.**
Tulis aliran apa adanya ke disk, itulah file Anda.
Baca byte dari disk dan kirim apa adanya ke jaringan, itulah aliran Anda.
Tanpa serialisasi. Tanpa deserialisasi.

**Unit kosakata LLM.**
16 bit = 65.536 simbol.
Ukuran kosakata LLM modern berkisar dari puluhan ribu hingga ratusan ribu.
GPT-2 memakai sekitar 50.000; model terbaru sekitar 100.000 hingga 200.000.
65.536 berada di dalam rentang itu.
Word 16-bit adalah unit dengan ukuran yang bisa dipelajari LLM sebagai kosakata.

Tiga dunia berbagi unit yang sama.
Penerjemahan berkurang.

---

## Aliran Adalah File

Mari lihat apa artinya secara konkret.

**Pendekatan konvensional: 9 langkah**

```
[File] -> Baca -> Parse -> Ekstrak teks -> Tokenisasi -> [LLM]
[LLM] -> Dekode -> Serialisasi -> Tulis -> [File]
```

**Pendekatan GEUL**

```
[Aliran] = [File]                             byte yang sama
[File] -> baca per rekaman, lompati           tanpa codebook
```

Tulis aliran apa adanya, itu file. Kirim file apa adanya, itu aliran.
Tanpa serialisasi maupun deserialisasi.
Word pertama setiap rekaman (TAG WORD) memberi tahu jenis dan panjangnya,
sehingga rekaman yang tidak diperlukan dilompati tanpa ditafsirkan.

Sisi LLM masih merupakan tujuan.
Satu word tidak sama dengan satu token.
Satu rekaman terdiri dari beberapa word, dan teks dibawa sebagai deretan byte.
Meski begitu, bila unitnya tetap 16 bit,
tokenizer tidak perlu menebak batas; cukup mengikuti batas yang sudah ditentukan.
"Yi Sun-sin" tidak terpotong di tempat sembarangan, karena ia adalah satu rekaman Reference yang menunjuk Wikidata Q50184.

---

## Mengapa Bukan 8-Bit?

8 bit memberikan 256 simbol berbeda.

256 simbol terlalu sedikit untuk merepresentasikan dunia.
Alokasikan alfabet, digit, dan tanda baca dasar, dan setengah ruang sudah terpakai.

Jika Anda menggunakan 8 bit sebagai unit fundamental,
sebagian besar token yang bermakna membutuhkan 2 byte atau lebih.
Ini memaksa encoding panjang variabel,
dan panjang variabel membuat parsing menjadi kompleks.

Cukup sebagai unit byte stream,
tetapi tidak cukup sebagai unit token.

---

## Mengapa Bukan 32-Bit?

32 bit memberi sekitar 4,3 miliar simbol.

Daya ekspresinya lebih dari cukup.
Tetapi masalahnya adalah efisiensi.

Rekaman terkecil dalam bahasa ini berukuran 1 word: penanda seperti BODY dan END yang hanya berupa satu TAG WORD.
Reference ke Wikidata Q42 berukuran 2 word,
dan satu TRIPLE yang menyatakan "Q42 adalah manusia" berukuran 10 word.
Dengan word 16-bit, TRIPLE itu 20 byte. Dengan word 32-bit, menjadi 40 byte.
Rekaman yang sama membengkak dua kali lipat.

Dari sudut pandang LLM pun ada masalah.
Kosakata 32-bit dengan 4,3 miliar simbol puluhan ribu kali lebih besar daripada kosakata LLM mana pun.
Tidak ada data maupun model untuk mempelajari kosakata sebesar itu.

Word 32-bit berlebihan sebagai unit bahasa ini.

---

## Mengapa Bukan Panjang Variabel?

UTF-8 adalah encoding panjang variabel.
Panjang karakter berkisar dari 1 byte hingga 4 byte tergantung pada karakternya.

Ini menawarkan keunggulan dalam efisiensi penyimpanan,
tetapi memperkenalkan kelemahan fatal dalam efisiensi pemrosesan.

Untuk menemukan karakter ke-n, Anda harus menghitung dari awal.
Akses acak tidak mungkin.
Pemrosesan paralel SIMD menjadi sulit.

Bahasa ini menggunakan kata 16-bit dengan lebar tetap sebagai unit fundamental.
Posisi kata ke-n selalu n * 2 byte.
Akses acak O(1).
SIMD dapat membandingkan beberapa kata dalam satu instruksi.
GPU dapat memindai miliaran kata secara paralel.

Namun, pada tingkat rekaman, panjang variabel tetap diizinkan.
Panjang rekaman berkisar dari 1 word hingga 2³²−1 word, dan panjangnya tertulis di word pertama.
Unit word tetap, tetapi unit rekaman fleksibel.

Efisiensi pemrosesan lebar tetap dikombinasikan dengan daya ekspresif panjang variabel.
Kata 16-bit mencapai keduanya secara bersamaan.

---

## Jalur yang Dibuktikan Unicode

Unicode adalah standar pengodean paling sukses yang pernah dibuat manusia.

Unit dasar UTF-16 adalah 16 bit (2 byte).
Karakter Basic Multilingual Plane (BMP) direpresentasikan dalam satu word,
dan karakter lainnya diperluas dengan pasangan surrogate (2 word = 4 byte).

GEUL mengikuti struktur yang sama.
Format yang sering dipakai dimuat sebagai kode langsung di dalam satu TAG WORD,
dan format yang jarang diperluas dengan TAG perluasan.

Sebagaimana Unicode mengekspresikan semua karakter di dunia
di atas unit dasar "satu karakter = 2 byte",
GEUL mengekspresikan pernyataan, sumbernya, dan dasarnya
di atas unit dasar "satu word = 2 byte".

---

## Kompatibilitas Mundur dan Perluasan ke Atas

Kekuatan lain dari 16 bit adalah alignment.

16 adalah kelipatan 8, pembagi 32, pembagi 64, dan pembagi 128.

Ini berarti alignment tidak pernah rusak, ke arah mana pun Anda memperluas.

Bagaimana jika arsitektur transformer berubah di masa depan
dan token menjadi 32 bit?
Dua kata 16-bit membuat satu token. Tidak ada masalah alignment.

Bagaimana dengan 64 bit?
Empat kata 16-bit membuat satu token. Tetap tidak ada masalah alignment.

Sebaliknya, bagaimana jika sistem embedded 8-bit memproses format ini?
Cukup baca setiap kata 16-bit sebagai byte tinggi dan byte rendah.

Kompatibilitas mundur harus dijaga secara absolut.
Kata 16-bit menjamin ini di tingkat fisik.

Kita tidak dapat memprediksi ukuran kata kecerdasan masa depan,
tetapi alignment kelipatan 16 bit menjamin kompatibilitas dengan ukuran apa pun.

---

## Struktur Tiga Rangkap

Mari kita rangkum.

Satu word 16-bit dirancang menjadi unit bagi tiga dunia.

| Dunia | Peran satu word |
|-------|---------------------|
| Jaringan | Unit aliran byte |
| Penyimpanan | Unit format file |
| AI | Unit kosakata LLM (tujuan) |

Satu unit menembus ketiga dunia itu.

Simpan aliran apa adanya, itu file.
Kirim file apa adanya, itu aliran.
Membuatnya bertaut dengan LLM per word adalah langkah berikutnya.

Konversi berkurang.
Penerjemahan berkurang.
Kehilangan berkurang.

Inilah alasan 16 bit.
Bukan 8, bukan 32, bukan panjang variabel.
Angka yang terletak tepat di persimpangan tiga dunia.

16.
