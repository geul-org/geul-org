---
title: "Mengapa Anotasi Harus Menjadi Indeks"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["indeks", "anotasi", "kode", "AST", "pola-desain"]
summary: "Komentar ditulis untuk manusia. Tetapi ketika ada 10.000 fungsi, mesin juga perlu membacanya. Dengan mengubah komentar dari narasi menjadi indeks, full scan menjadi pencarian instan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Komentar ditulis untuk manusia.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

Komentar ini berguna ketika dibaca oleh manusia. Tetapi ketika mesin membacanya, mesin tidak memahami apa-apa. Tidak tahu apakah "retrieves" itu Read atau Search. Tidak tahu entitas apa "user" itu. Tidak tahu apakah fungsi ini menggunakan pola Service atau pola Repository.

Karena komentar ini adalah narasi.

---

## Ketika Ada 10.000 Fungsi

Ketika ada 10 fungsi, tidak masalah. Manusia bisa membaca semuanya.

Ketika ada 10.000 fungsi, berbeda. Ketika seseorang meminta "tampilkan semua fungsi terkait pembayaran", baik manusia maupun mesin tidak bisa menemukannya. Hanya menemukan yang namanya mengandung "payment". Jika tidak ada di namanya, terlewat.

Hal yang sama terjadi ketika agen AI memodifikasi kode. Ketika Anda meminta Claude Code untuk "perbaiki penanganan error PaymentFailed", agen membaca ulang seluruh kode. Setiap kali. Menganalisis 10.000 fungsi dari awal, setiap kali. Membaca hari ini kode yang sama yang dibaca kemarin. Bahkan dengan komentar, hasilnya sama. Karena komentar adalah narasi untuk manusia. Agar mesin mengekstrak makna dari narasi, diperlukan inferensi. Itu mahal.

---

## Jika Komentar Adalah Indeks

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

Komentar ini bisa dibaca oleh manusia maupun mesin.

"Semua fungsi dengan pola Service" -> cari di field Pattern. Instan.
"Semua fungsi terkait entitas Order" -> cari di field Entity. Instan.
"Fungsi yang menghasilkan PaymentFailed" -> cari di field errs. Instan.

Full scan berubah menjadi pencarian indeks. O(n) menjadi O(1).

---

## Tidak Perlu Ditulis oleh Manusia

Indeks ini tidak perlu ditulis oleh manusia.

Ketika kode dimodifikasi, perubahan terdeteksi secara otomatis. File watching.
Fungsi yang dimodifikasi diisolasi melalui AST. Secara mekanis.
Badan fungsi diteruskan ke LLM kecil. "Tentukan pola, entitas, dan aksi dari fungsi ini."
Hasil analisis disisipkan dalam format yang telah ditentukan. Secara mekanis.

Manusia tidak melakukan apa-apa. Cukup menulis kode. Indeks ditambahkan secara otomatis.

Dalam seluruh pipeline, LLM hanya campur tangan di satu titik -- menentukan makna fungsi. Sisanya semuanya kode deterministik.

---

## Dari Inferensi ke Aturan

Di sini kita melangkah lebih jauh.

Ketika LLM kecil berulang kali memberikan indeks yang sama pada pola yang sama -- pengulangan itu terdeteksi. Jika "Service suffix dengan receiver method maka Pattern:Service" telah berulang 100 kali, itu dikonsolidasi menjadi aturan. Setelah itu, LLM tidak lagi dipanggil. Aturan yang menangani.

Panggilan LLM semakin berkurang. Aturan semakin bertambah. Biaya konvergen menuju nol.

Komentar berubah dari narasi menjadi indeks,
indeks berubah dari manual menjadi otomatis,
dan otomatis berubah dari inferensi menjadi aturan.

---

## Mengapa Ini Mungkin: Design Pattern sebagai Codebook

Ada alasan mengapa ini mungkin.

Pemrograman sudah memiliki kosakata semantik yang terstandarisasi. Yaitu design pattern.

Singleton, Factory, Observer, MVC, Service. Sejak GoF menyusun 23 pola pada tahun 1994, industri perangkat lunak telah memperluas dan menstandarisasi kosakata ini selama 30 tahun.

23 pola GoF. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. Semuanya sudah tersusun.

Kosakata ini tidak ambigu. Singleton adalah Singleton. Tidak ditafsirkan berbeda oleh setiap pengembang. Definisinya disepakati, kondisi implementasinya jelas, dan pelanggaran ditangkap dalam code review.

Sistem kosakata ini menjadi codebook untuk indeks. Tidak perlu membuat yang baru. Sudah ada.

Dalam bahasa alami, ini tidak ada. "Hebat" memiliki definisi di kamus, tetapi setiap orang menggunakannya secara berbeda. Dalam kode, Service tidak digunakan secara berbeda oleh setiap orang.

---

## Mengapa Kode Adalah Domain Termudah

Pipeline konteks GEUL -- [klarifikasi](/id/why/clarification/), [pengindeksan](/id/why/semantically-aligned-index/), [verifikasi](/id/why/mechanical-verification/), [penyaringan](/id/why/filter/), [konsistensi](/id/why/consistency-check/), [eksplorasi](/id/why/exploration/) -- sulit diterapkan pada bahasa alami. Menerapkannya pada kode itu mudah.

Klarifikasi: bahasa alami ambigu. Kode, jika compiler menerimanya, maknanya sudah pasti.
Pengindeksan: entitas dalam bahasa alami memerlukan konteks. Entitas dalam kode sudah di-parse oleh AST.
Verifikasi: validitas bahasa alami tidak bisa didefinisikan. Validitas kode dinilai oleh compiler.
Penyaringan: relevansi dalam bahasa alami memerlukan LLM. Relevansi dalam kode bisa ditentukan secara mekanis melalui call graph.
Konsistensi: kontradiksi dalam bahasa alami hanya ditemukan melalui inferensi. Kontradiksi dalam kode ditangkap oleh sistem tipe dan pengujian.
Eksplorasi: pengetahuan bahasa alami bersifat datar. Kode sudah memiliki hierarki paket -> file -> tipe -> metode.

Pipeline yang sama bekerja dengan biaya yang jauh lebih rendah di domain kode. Membuktikan terlebih dahulu di tempat yang paling mudah, lalu memperluas ke tempat yang lebih sulit. Inilah rekayasa.

---

## Ringkasan

Komentar awalnya untuk manusia.
Sekarang juga harus untuk mesin.
Komentar yang bisa dibaca manusia dan bisa dicari mesin.
Komentar yang merupakan narasi sekaligus indeks.

Kode sudah memiliki makna, sudah memiliki struktur, sudah memiliki kosakata.
Yang belum ada hanyalah indeks.
Dan komentar bisa menjadi indeks itu.
