---
title: "Mengapa Indeks yang Selaras Secara Semantik?"
weight: 16
date: 2026-02-26T12:00:03+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SIDX", "penyelarasan semantik", "indeks"]
summary: "Jika ID adalah pengetahuan, bukan alamat, satu operasi bit dapat mempersempit kandidat tanpa JOIN apa pun. Esai ini membahas SIDX, pengenal yang diselaraskan secara semantik yang sedang diteliti GEUL, dan mengapa lebarnya akan ditentukan dari statistik penggunaan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Apa yang Terjadi Ketika ID Adalah Pengetahuan, Bukan Alamat

---

## Alamat Tidak Tahu Apa-Apa

Untuk menemukan Yi Sun-sin dalam database, Anda membutuhkan ID.

Di Wikidata, ID Yi Sun-sin adalah `Q50184`.

Angka ini menunjuk ke Yi Sun-sin.
Tetapi string `Q50184` itu sendiri tidak tahu apa-apa.

Ia tidak tahu apakah ini orang atau gedung.
Ia tidak tahu apakah ini warga Korea atau warga Prancis.
Ia tidak tahu apakah ini tokoh abad ke-16 atau abad ke-21.
Ia tidak tahu apakah mereka hidup atau mati.

`Q50184` adalah alamat.
Tukang pos yang mengantar surat tidak tahu apa yang tertulis di dalam amplop.
Mereka hanya melihat alamat pada amplop dan mengantarkannya.

UUID sama saja. `550e8400-e29b-41d4-a716-446655440000`.
128 bit angka acak. Unik hanya untuk menghindari tabrakan --
tidak memberi tahu apa-apa tentang apa yang dirujuknya.

Selama lima puluh tahun terakhir, ID database bekerja seperti ini.
ID adalah alamat, dan untuk mengetahui apa pun, Anda harus mengikuti alamat itu dan membaca datanya.

---

## Harus Mengikuti untuk Mengetahui

Mengapa ini masalah?

Misalkan Anda ingin menemukan "seorang filsuf pria berkewarganegaraan Jerman yang lahir di abad ke-19."

Dalam database tradisional, begini cara kerjanya:

```
1. Filter tabel persons di mana gender = 'male'
2. JOIN dengan tabel nationalities dan filter country = 'Germany'
3. JOIN dengan tabel birth_dates dan filter year BETWEEN 1800 AND 1899
4. JOIN dengan tabel occupations dan filter occupation = 'philosopher'
```

Empat operasi JOIN.
Setiap JOIN membandingkan baris antara dua tabel.
Jika tabelnya besar, ia menelusuri indeks; jika tidak ada indeks, ia melakukan full scan.
Dengan satu miliar rekaman, proses ini memakan waktu detik hingga puluhan detik.

Mengapa begitu kompleks?

Karena ID tidak tahu apa-apa.
Melihat `Q50184`, Anda tidak bisa tahu apakah ini orang Jerman atau Korea,
sehingga Anda harus pergi ke tabel lain untuk mengambil informasi itu.

Untuk setiap pertanyaan, Anda harus mengikuti ke mana ID menunjuk.
Inilah biaya yang dibayar database selama lima puluh tahun.

---

## Bagaimana Jika ID Sudah Tahu?

Mari kita balik premisnya.

Bagaimana jika ID itu sendiri mengandung informasi esensial?

Bagaimana jika, hanya dengan melihat ID,
Anda bisa tahu apakah ia merujuk pada manusia, dari negara mana mereka,
dari era mana mereka, dan bagaimana mereka diklasifikasikan?

Untuk menemukan "filsuf pria Jerman abad ke-19,"
JOIN menjadi tidak diperlukan.

Memindai satu miliar ID,
Anda bisa langsung menentukan kecocokan masing-masing dengan memeriksa bit-bitnya.

Inilah ide inti di balik Indeks yang Selaras Secara Semantik.

---

## Menyelaraskan Makna ke dalam ID

SIDX (Semantically-Aligned Index) adalah penelitian untuk membangun ID seperti itu.
Tata bahasa GEUL sudah memiliki tempat Reference yang menunjuk target lewat SIDX ([GEUL-SIDX](/id/grammar/reference/geul-sidx/)).
Namun lebar dan cara penetapannya belum diputuskan. Keduanya akan ditentukan dari statistik penggunaan yang terkumpul.
Di bawah ini, 64 bit dipakai sebagai contoh untuk penjelasan.

Bit-bit SIDX bukan angka acak.
Setiap posisi bit diberi makna.

Bit atas memuat informasi paling penting.
Entitas jenis apa ini? Orang, tempat, peristiwa, atau konsep?

Bit berikutnya memuat informasi klasifikasi.
Jika orang, dari era mana? Dari wilayah mana?

Semakin ke bit bawah, informasinya semakin spesifik.

Prinsip utamanya:

> Urutan bit adalah urutan kepentingan informasi.

Klasifikasi paling mendasar di puncak,
pembedaan paling rinci di dasar.

Ini bukan sekadar pengurutan.
Ini filosofi desain.

---

## Dari Satu Miliar ke Sepuluh Ribu, dalam Satu Kali Lewat

Kekuatan praktis SIDX terlihat dari angka.

Misalkan ada satu miliar entitas, masing-masing dengan SIDX 64-bit.
Ukuran total: 1 miliar × 8 byte = 8 GB.

8 GB ini muat seluruhnya di memori.

Anda ingin menemukan "entitas manusia yang berasal dari Asia Timur".
Jika bit atas memuat penanda "manusia" dan kode "Asia Timur",
satu bitmask cukup untuk menyaring.

```
mask   = 0xFF00_0000_0000_0000  (8 bit atas: tipe + wilayah)
target = 0x8100_0000_0000_0000  (manusia + Asia Timur)

for each sidx in 1_miliar:
    if (sidx & mask) == target:
        tambahkan ke kandidat
```

Operasi ini diparalelkan dengan SIMD.
Batasnya bukan komputasi, melainkan bandwidth memori.
Dalam pengukuran awal untuk [SILK](/id/projects/silk/), memindai 100 juta tanda tangan 128-bit (1,6 GB) dengan mask memakan sekitar 27 milidetik dengan 8 thread Go.
Pada laju yang sama, satu miliar SIDX 64-bit (8 GB) butuh sedikit di atas 0,1 detik.

Satu miliar rekaman menyempit menjadi sepuluh ribu.
Menyaring sepuluh ribu sisanya secara rinci berlangsung seketika.

Nol JOIN.
Nol penelusuran pohon indeks.
Hanya satu AND bit.

---

## Seberapa Lebar Seharusnya?

Awalnya saya kira dibutuhkan ruang yang lebih besar.

32 byte (256 bit). Vektor FP16 32 dimensi.
Saya mencoba menjejalkan semua atribut kunci entitas ke dalam ID.
Manusia atau bukan, jenis kelamin, kewarganegaraan, era, pekerjaan, wilayah, hidup atau mati, jalur klasifikasi...

Tetapi saya menyadari sesuatu.

**ID tidak perlu tahu segalanya.**

Cukup mempersempit satu miliar rekaman menjadi sepuluh ribu.
Sisanya diurus oleh verifikasi presisi.

Ini seperti pos pemeriksaan.
Di gerbang tol jalan tol, untuk menyimpulkan dari pelat nomor
bahwa "kendaraan ini menuju Provinsi Gyeonggi",
tidak perlu tahu isi bagasinya.

Jadi 64 bit mungkin cukup.
Dengan bit atas untuk tipe dan klasifikasi besar,
dan bit bawah untuk klasifikasi rinci,
mempersempit satu miliar menjadi sepuluh ribu tampak sangat mungkin.
64 bit = empat word 16-bit. Ringan bahkan di dalam aliran.

Tetapi ini masih hipotesis.
GEUL tidak menentukan lebar di atas meja.
Dengan kandidat seperti 4 WORD (64 bit) dan 16 WORD, lebar akan diputuskan dari statistik penggunaan nyata.
Sampai saat itu, target dirujuk dengan ID yang diberikan berurutan,
dan setelah SIDX ditetapkan, kedua ID itu dihubungkan sebagai target yang sama.

---

## Degradasi Anggun: Makna Bertahan Bahkan Ketika Bit Dipotong

Kekuatan lain dari penyelarasan semantik adalah karakteristik degradasinya.

Karena bit SIDX diurutkan dari yang paling penting ke yang paling tidak penting,
bahkan jika bit bawah rusak atau terpotong,
informasi inti di bit atas tetap terjaga.

```
64 bit penuh:  "Yi Sun-sin, komandan angkatan laut Joseon abad ke-16"
48 bit:        "Perwira militer Joseon abad ke-16"
32 bit:        "Manusia Asia Timur abad ke-16"
16 bit:        "Manusia"
8 bit:         "Entitas fisik"
```

Seiring informasi terpotong, spesifisitas hilang,
tetapi klasifikasi paling fundamental bertahan hingga akhir.

Ini adalah implementasi di tingkat bit dari prinsip "degradasi anggun."

Bahkan jika gangguan jaringan hanya mengirimkan data parsial,
sistem tahu "Saya tidak tahu persis siapa ini, tetapi setidaknya ini cerita tentang manusia"
dan dapat melanjutkan penalaran.

Garis besar yang kabur lebih baik dari keheningan total.
Pemahaman parsial lebih baik dari kegagalan total.

---

## Kueri Menjadi ID

Kemungkinan paling menarik yang dibuka oleh indeks yang diselaraskan secara semantik:

Bagaimana jika kueri bahasa alami bisa diubah menjadi SIDX sementara?

Seorang pengguna bertanya: "Siapa jenderal yang mengalahkan angkatan laut Jepang dalam Perang Imjin?"

Encoder menganalisis pertanyaan itu.
Manusia. Asia Timur. Abad ke-16. Terkait militer.
Merangkai atribut ini menjadi bit menghasilkan SIDX sementara.

SIDX sementara ini memindai satu miliar SIDX.
Entitas dengan pola bit paling mirip muncul sebagai kandidat.
Yi Sun-sin, Won Gyun, Gwon Yul, Yi Eok-gi...

Mencocokkan informasi rinci dengan kandidat ini menghasilkan jawaban akhir.

Pencarian dan penautan entitas (entity linking) bisa menjadi satu mekanisme.
Tanpa mesin pencari terpisah,
tanpa pipeline NER (Named Entity Recognition) terpisah,
cukup dengan satu perbandingan SIDX.

---

## Mengapa Bukan B-Tree?

Basis data tradisional memakai indeks B-Tree.

B-Tree unggul dalam menemukan nilai tertentu pada data terurut dalam O(log n).
Untuk "temukan Q50184", ia optimal.

Tetapi untuk "temukan semua entitas manusia dari Asia Timur", ia lemah.
Pencarian kondisi gabungan membutuhkan irisan beberapa indeks,
dan biaya irisan itu melonjak seiring skala data.

Pemindaian menyeluruh SIDX + SIMD adalah pendekatan lain.

Jika B-Tree adalah buku telepon yang cepat menjawab "siapa yang tinggal di alamat ini",
pemindaian SIDX adalah profiling yang cepat menjawab "siapa yang memiliki ciri-ciri ini".

Jenis pertanyaannya berbeda, maka struktur data optimalnya pun berbeda.

| Jenis kueri | B-Tree | Pemindaian SIDX |
|-----------|--------|-----------|
| Pencarian ID tertentu | O(log n), optimal | Tidak perlu (diselesaikan dengan hash) |
| Penyaringan kondisi gabungan | Butuh JOIN, lambat | Satu AND bit, cepat |
| Pencarian entitas serupa | Tidak mungkin | Mungkin lewat kemiripan bit |
| Penyisipan | O(log n), penyeimbangan ulang | O(1), append |
| Kompleksitas implementasi | Tinggi | Rendah |

Keduanya berbagi tugas, bukan bersaing.
Kini SILK menjawab kueri tepat seperti "dokumen dengan predikat P106 dan objek Q169470" dengan run terurut dan pencarian biner.
Pemindaian tanda tangan bit, sebagai saringan pertama di depannya, direncanakan sebagai langkah berikutnya.

Sederhana. Brute force. Cepat.

---

## Kebijaksanaan Huffman

Alokasi bit SIDX mengikuti prinsip pengodean Huffman.

Dalam pengodean Huffman, simbol yang sering muncul mendapat kode pendek,
dan simbol yang jarang mendapat kode panjang.

Dalam SIDX, informasi klasifikasi yang paling sering dibutuhkan menempati bit atas,
dan detail yang jarang dibutuhkan menempati bit bawah.

Penetapan Codec dalam tata bahasa GEUL mengikuti prinsip yang sama.
Format yang frekuensinya terbukti mendapat kode langsung pendek di dalam TAG WORD,
dan format yang jarang masuk ke format Issuer dengan TAG perluasan.

Kebijaksanaan Huffman menjiwai seluruh desain ini.
Biaya terendah untuk yang paling sering dipakai.

---

## Ringkasan

ID tradisional adalah alamat. Alamat tidak tahu apa-apa.

1. Jika ID tidak membawa makna, Anda harus menelusurinya ke data setiap kali. Itulah JOIN.
2. Empat JOIN atas satu miliar rekaman itu lambat.
3. SIDX adalah penelitian untuk menyandikan makna langsung ke dalam ID lewat penyelarasan semantik.
4. Satu AND bitmask dapat mempersempit satu miliar rekaman menjadi sepuluh ribu. Nol JOIN.
5. ID tidak perlu tahu segalanya; cukup mempersempit kandidat. Lebarnya ditentukan dari statistik penggunaan.
6. Karena informasi terpenting ada di bit atas, inti makna tetap bertahan meski bit terpotong.
7. Jika kueri bahasa alami bisa diubah menjadi SIDX sementara, pencarian menjadi operasi bit.

Saat ID berhenti menjadi alamat dan menjadi pengetahuan,
aturan basis data berubah.
