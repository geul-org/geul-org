---
title: "Mengapa Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontologi", "wikigeul", "SIDX"]
summary: "GEUL tidak menolak Wikidata. GEUL memuat dump tanpa kehilangan dan mengubah setiap entitas dari sekitar 120 juta entitas menjadi satu dokumen GEUL yang memuat semua bahasa. Merancang pengidentifikasi selaras makna (SIDX) dari klasifikasi dan statistik frekuensinya masih dalam riset."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL tidak menolak Wikidata. GEUL berdiri di atasnya.

---

## Bahasa tidak bisa dibuat tanpa kamus

Setiap bahasa membutuhkan kosakata.

Bahasa Korea punya kamus Korea.
Bahasa Inggris punya kamus Inggris.
Bahasa pemrograman punya pustaka standar.

Hal yang sama berlaku untuk bahasa buatan.
Daftar entitas, daftar relasi, daftar properti.
Kode apa yang mewakili "Samsung Electronics" dalam bahasa ini?
Kode apa yang mewakili relasi "ibu kota"?
Kosakata harus ada sebelum kalimat bisa ditulis.

Bagaimana membangun kosakata ini?
Ada dua cara.

Membangunnya dari nol.
Atau menggunakan yang sudah ada.

---

## Membangun dari nol: pelajaran dari CYC

Proyek CYC dimulai pada 1984.

Tujuannya adalah memformalisasi dan menyimpan pengetahuan akal sehat secara umum.
Ontologinya dirancang dari awal.
Konsep didefinisikan, relasi didefinisikan, aturan didefinisikan.
Para ahli memasukkannya secara manual.

Tiga puluh tahun berlalu.
Jutaan aturan dimasukkan.

Namun itu masih sangat jauh dari cukup untuk mencakup pengetahuan dunia.
Setiap domain memerlukan ontologi terpisah.
Menjaga konsistensi antaromain terbukti sulit.
Setiap kali muncul konsep baru, ontologi harus direvisi.
Revisi sering bertentangan dengan aturan yang sudah ada.

Yang dibuktikan CYC bukan potensinya, melainkan batasannya.
Membiarkan tim kecil ahli merancang ontologi dunia
menjadi tidak bisa dipertahankan seiring bertambahnya skala.

---

## Yang sudah ada: Wikidata

Wikidata diluncurkan pada 2012.

Basis pengetahuan terstruktur yang dioperasikan oleh Wikimedia Foundation.
Siapa pun bisa mengeditnya.
Menurut dump 19 Oktober 2026, sekitar 121,97 juta entitas.
Di antaranya 13.991 properti.
Sekitar 1,78 miliar pernyataan.
Label dalam lebih dari 600 kode bahasa.

Skala yang CYC tidak bisa capai dalam 30 tahun dengan tim ahli,
Wikidata capai dalam 14 tahun dengan komunitas.

Mari lihat apa yang Wikidata sediakan.

**Pengidentifikasi entitas.** Q-ID. Samsung Electronics adalah Q20718. Seoul adalah Q8684. Yi Sun-sin adalah Q217300. Pengidentifikasi unik secara global. Tidak bergantung pada bahasa.

**Pengidentifikasi properti.** P-ID. "Lokasi kantor pusat" adalah P159. "Tanggal pendirian" adalah P571. "Populasi" adalah P1082. Relasi dan properti diidentifikasi secara unik.

**Struktur hierarkis.** P31 (instance of) dan P279 (subclass of) membentuk hierarki tipe. "Seoul → kota → permukiman manusia → entitas geografis." Sistem klasifikasi dunia diekspresikan melalui dua properti ini.

**Label multibahasa.** Label Korea untuk Q20718 adalah "삼성전자", label Inggris adalah "Samsung Electronics", label Jepang adalah "サムスン電子". Satu pengidentifikasi, nama berbeda untuk setiap bahasa.

**Validasi komunitas.** Editor dari seluruh dunia. Deteksi vandalisme. Persyaratan sumber. Tidak sempurna, tapi lebih skalabel daripada tim kecil ahli.

Tidak ada alasan untuk membangun semua ini dari nol.

---

## GEUL memindahkan Wikidata apa adanya

GEUL tidak membuat pengidentifikasi baru untuk Wikidata.
GEUL memakainya apa adanya.

Tata bahasa GEUL punya Reference khusus untuk Wikidata.
[WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) menulis angka dari Q-ID, dan [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/) angka dari P-ID, sebagai bilangan bulat tak bertanda.
Q42 adalah bilangan bulat 42. P31 adalah bilangan bulat 31.
Karena berupa bilangan bulat, bukan string, membandingkannya tidak memerlukan normalisasi.

Jalurnya seperti ini.

**Langkah 1: Pemuatan tanpa kehilangan.**
[wikipg](/id/repos/#wikipg) memuat dump JSON Wikidata ke PostgreSQL.
Ia menyimpan entitas, label, deskripsi, alias, pernyataan, kualifikator, referensi, dan tautan situs sesuai urutan dump,
dan menyimpan setiap baris dump apa adanya.
Berkas dump itu sendiri (URL, ukuran, checksum, commit pemuat) juga dicatat.
Hanya bila tidak ada yang dibuang, kelak bisa diperiksa apa yang dipindahkan dan apa yang dilewati.

**Langkah 2: Satu dokumen per entitas.**
[wikigeul](/id/repos/#wikigeul) membaca dump yang sudah dimuat dan membuat satu dokumen GEUL untuk setiap item dan setiap properti.
Dokumen itu berisi label, deskripsi, alias, pernyataan beserta kualifikator dan referensinya, serta tautan situs.
Semua bahasa masuk ke satu dokumen. Tidak dipecah per bahasa.

Semua dokumen memakai satu Issuer, `0x00010000` (wikidata.geul.org).
ID dokumen berukuran 64 bit. Byte teratas adalah huruf jenis entitas, dan 56 bit terbawah adalah nomornya.
Dokumen Q42 adalah `0x510000000000002a`. `0x51` adalah `Q`, dan `0x2a` adalah 42.
Dokumen P31 adalah `0x500000000000001f`.
Dari hex saja sudah terlihat dokumen milik entitas mana.
Satu dokumen nyata bisa dibaca dari awal sampai akhir di [Contoh: item Wikidata](/id/grammar/example/).

**Langkah 3: Mengutip dengan bilangan bulat.**
Di dalam pernyataan, item dan properti ditulis sebagai bilangan bulat.
"Q42 adalah manusia (Q5)" adalah TRIPLE dari tiga bilangan bulat: P31, Q42, dan Q5.
Bilangan itu sama dengan nomor pada ID dokumen.
Dari pernyataan mana pun, kita bisa langsung menuju dokumen dari hal yang disebutnya.

Referensi juga ikut dipindahkan.
Satu referensi Wikidata menjadi satu SOURCE GEUL.
Kepala setiap dokumen mencatat dump asalnya dan alat (commit) yang mengonversinya.

**Langkah 4: Menerbitkan sebagai arsip pack.**
120 juta entitas tidak bisa diterbitkan sebagai 120 juta berkas.
Dokumen dikemas dalam satu arsip pack per Issuer, dan rekaman dikompresi dengan zstd.
Pembaca hanya mengambil dokumen yang dibutuhkan, bukan seluruh arsip.

Saat ini konversi sedang diverifikasi pada rentang Q1–Q10000.
Perjalanan bolak-balik lewat konversi balik, arsip, dan kelengkapan diperiksa secara menyeluruh.
Konversi penuh dan penerbitan menyusul setelahnya.

---

## SIDX datang sesudahnya

Q-ID adalah nomor yang diberikan menurut urutan pendaftaran.
Nomor yang berdekatan tidak berarti maknanya berdekatan.
Q42 adalah Douglas Adams; Q41 adalah Yunani, dan Q43 adalah Turki.

GEUL juga meneliti jenis pengidentifikasi lain.
[SIDX](/id/grammar/reference/geul-sidx/) (Semantic-aligned Index), pengidentifikasi yang selaras makna, yang memberi nilai berdekatan kepada hal-hal yang maknanya berdekatan.
Tujuannya adalah menaruh makna di dalam bit itu sendiri,
sehingga bit atas saja cukup untuk mengetahui apakah sesuatu itu orang, tempat, atau organisasi.

SIDX masih berupa riset sebelum v1.
Tata bahasa hanya menyediakan tempat untuknya: Reference GEUL-SIDX.
Lebarnya belum ditetapkan. 64 bit, 256 bit, dan lainnya sedang dikaji, dan pilihannya akan mengikuti statistik.
Belum ada SIDX yang ditetapkan.
Karena itu dokumen Wikidata saat ini ditulis dengan Q-ID, tanpa SIDX.
Setelah nilai SIDX ditetapkan, pengidentifikasi yang ada dan SIDX untuk hal yang sama akan dihubungkan dengan [SAME-NODE](/id/grammar/edge/same-node/).

Di sinilah Wikidata dipakai lagi.
Riset SIDX berangkat dari sistem klasifikasi dan statistik frekuensi Wikidata.
Arah yang sedang dikaji adalah sebagai berikut.

**Ekstraksi tipe.**
Kumpulkan Q-ID yang dipakai sebagai objek P31 (instance of).
Inilah daftar "tipe".
"Manusia (Q5)", "kota (Q515)", "negara (Q6256)", "perusahaan (Q4830453)"...
Hitung jumlah instans setiap tipe.

**Pembangunan hierarki.**
Bangun pohon dari relasi P279 (subclass of) antartipe.
"Kota → permukiman manusia → entitas geografis → entitas."
Cara menangani pewarisan ganda, ketika satu tipe termasuk dalam beberapa tipe induk, masih menjadi masalah terbuka.

**Penetapan bit.**
Struktur pohon menjadi relasi prefiks pola bit.
Subtipe di bawah induk yang sama berbagi prefiks yang sama.
"Kota" dan "desa" berbagi prefiks "permukiman manusia".
Tipe dengan banyak instans mendapat prefiks lebih pendek, yaitu ruang nomor yang lebih luas.
Idenya sama dengan pengodean Huffman.

Ini masih hipotesis.
Masih ada masalah yang harus dipecahkan.
SIDX yang sudah ditetapkan tidak boleh berpindah ketika statistik berubah.
Nilai yang sama tidak boleh diberikan kepada dua hal.
Format penerbitan buku kode dan registrinya juga harus ditentukan.

---

## Apa yang disediakan Wikidata

Pada jalur ini, Wikidata menyediakan tiga hal.

**Pengidentifikasi.**
Jawaban atas "apa di dunia ini yang kita tunjuk?"
Q-ID dan P-ID menjadi Reference bilangan bulat GEUL apa adanya.
Pengetahuan Wikidata bisa dipindahkan ke dokumen GEUL,
dan pengidentifikasi Wikidata bisa dibaca langsung dari dokumen GEUL.

**Sistem klasifikasi.**
Jawaban atas "jenis-jenis apa saja yang ada di dunia?"
CYC menyuruh tim ahli merancang ini.
GEUL mengambilnya dari Wikidata.
Tujuan risetnya adalah mengubah sistem klasifikasi yang disepakati para editor selama 14 tahun
menjadi pohon bit SIDX.

**Statistik frekuensi.**
Jawaban atas "berapa banyak setiap jenis ada di dunia?"
Jika ada 9 juta entitas manusia dan 1 juta asteroid,
tipe "manusia" seharusnya mendapat kode yang lebih efisien daripada "asteroid".
Frekuensi penggunaan nyata menjadi dasar desain kode.

---

## Apa yang tidak disediakan Wikidata

Wikidata adalah kamus. Kamus bukan bahasa.

Kamus menyediakan daftar kata.
Bahasa menyediakan tata bahasa untuk menyusun kalimat dari kata.

Apa yang tidak disediakan Wikidata adalah apa yang ditambahkan GEUL.

**Dari fakta ke klaim.**
Unit dasar Wikidata adalah fakta (Fact).
"Populasi Seoul adalah 9,74 juta."
Benar atau salah.

Unit dasar GEUL adalah klaim (Claim).
"Menurut A, populasi Seoul sekitar 9,74 juta. (keyakinan 0,9, per 2023)"
Siapa yang mengklaim, seberapa yakin, dan per kapan — semua tertanam dalam pernyataan.
Perbedaan ini dibahas secara rinci di [Mengapa klaim, bukan fakta](/id/why/claims-not-facts/).

**Kualifikator verba.**
Wikidata tidak punya tempat untuk mengekspresikan nuansa verba.
Dalam "Yi Sun-sin memenangkan Pertempuran Myeongnyang",
di mana kala, aspek, evidensialitas, modus, dan keyakinan?
Di Wikidata, ini sebagian diekspresikan lewat kualifikator,
tetapi tidak ada sistem kualifikasi verba yang sistematis.

GEUL sedang merancang sistem kualifikasi verba yang menempelkan secara struktural ke setiap pernyataan
dimensi seperti kala, aspek, polaritas, evidensialitas, modus, volisionalitas, dan keyakinan.
Ini juga pekerjaan sebelum v1.

**Word 16-bit.**
Representasi Wikidata tidak dirancang untuk jendela konteks.
JSON-LD, RDF, SPARQL.
Dapat dibaca mesin, tetapi tidak efisien token.

GEUL adalah deretan word 16-bit.
Word pertama sebuah rekaman (TAG WORD) menyatakan jenis dan panjang rekaman itu.
Rekaman bisa disaring dan dilewati bahkan tanpa buku kode.
Ini sistem representasi yang dibangun atas premis bahwa jendela konteks terbatas.
Ini sudah dibahas di [Mengapa bukan MD/JSON/XML](/id/why/not-md-json-xml/).

**Pipeline konteks.**
Wikidata adalah penyimpanan. GEUL adalah bagian dari pipeline.
Klarifikasi, verifikasi, penyaringan, pemeriksaan konsistensi, eksplorasi — semua yang dibahas dalam seri ini
beroperasi di atas representasi terstruktur GEUL.
Wikidata tidak punya pipeline ini.
Juga tidak perlu. Tujuan Wikidata berbeda.

---

## Hubungan antara kamus dan bahasa

Ringkasnya:

Wikidata adalah kosakata dunia.
Entitas apa yang ada,
relasi apa yang ada,
tipe apa saja yang ada dan bagaimana mereka diklasifikasikan.
Sebuah komunitas membangunnya selama 14 tahun.

GEUL menaruh tata bahasa di atas kosakata ini.
Pengidentifikasi kosakata → Reference bilangan bulat GEUL.
Entri kosakata → satu dokumen GEUL per entitas.
Sistem klasifikasi dan statistik frekuensi kosakata → bahan riset SIDX.

Dan menambahkan apa yang tidak ada dalam kosakata.
Struktur klaim. Kualifikasi verba. Word 16-bit. Pipeline konteks.

Bisakah GEUL dibangun tanpa Wikidata?
Bisa. Rancang ontologi dari nol, seperti CYC.
Tetapi itu sudah dicoba 40 tahun lalu, dan hasilnya sudah terlihat.

Karena Wikidata ada, GEUL tidak merancang ontologi.
GEUL memindahkan konsensus yang sudah ada.

---

## Ringkasan

Bahasa buatan membutuhkan kosakata.
Membangunnya dari nol sudah dicoba CYC, dan 30 tahun membuktikan batasnya.

Wikidata adalah kosakata dunia, dengan sekitar 120 juta entitas dan sekitar 1,78 miliar pernyataan (dump Oktober 2026).
Sebuah komunitas membangunnya selama 14 tahun.

GEUL memindahkan kosakata ini apa adanya.
wikipg memuat dump ke PostgreSQL tanpa kehilangan,
dan wikigeul mengubah setiap entitas menjadi satu dokumen GEUL yang memuat semua bahasa.
Item dan properti dikutip sebagai bilangan bulat, dan dokumen diterbitkan sebagai arsip pack.

SIDX adalah riset berikutnya.
Ia merancang pengidentifikasi yang selaras makna dari frekuensi instans P31 dan hierarki P279.
Lebar maupun penetapannya belum diputuskan.

Wikidata adalah kamus; GEUL adalah bahasa.
Kamus menyediakan kata; bahasa menyediakan tata bahasa.
GEUL membangun struktur klaim, kualifikasi verba, word 16-bit, dan pipeline konteks di atas kosakata Wikidata.

GEUL tidak menolak Wikidata.
GEUL berdiri di atasnya.
