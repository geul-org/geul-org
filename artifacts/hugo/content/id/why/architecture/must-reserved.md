---
title: "Mengapa Harus Dibiarkan Kosong"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["reserved", "ekstensibilitas", "TAG WORD", "prinsip-desain", "IPv4"]
summary: "GEUL mengosongkan 75% ruang TAG WORD 16-bit yang membuka setiap rekaman. Pelajaran dari IPv4, Unicode, dan ASCII: biaya mengisi tidak dapat dipulihkan, sedangkan biaya mengosongkan hanya tiga bit per rekaman."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Setiap rekaman GEUL dimulai dengan satu TAG WORD 16-bit. Bit-bit terdepan TAG WORD membaginya menjadi wilayah. GEUL mengosongkan 75% dari ruang ini.

```
1xx:  50%    Masa depan jauh
01x:  25%    Masa depan dekat
001:  12.5%  Standar
000:  12.5%  Tata bahasa saat ini (bebas / usulan)
```

Seluruh tata bahasa saat ini berada di wilayah `000`, di dalam 12.5%. Ketika standar resmi diluncurkan, tata letak yang diadopsi tetap seperti adanya dan hanya bit terdepannya yang dipindah ke `001`. Sisa 75% disisakan untuk generasi yang belum lahir.

Mengapa?

---

## Pelajaran dari IPv4

Pada tahun 1981, para perancang IPv4 berpikir bahwa 32 bit sudah cukup. 4,3 miliar alamat. Saat itu, komputer di seluruh dunia hanya berjumlah ratusan. 4,3 miliar terasa seolah akan bertahan selamanya.

Pada tahun 2011, alamat IPv4 habis.

30 tahun. Hanya 30 tahun.

Apa yang dilakukan umat manusia setelah kehabisan: NAT, CGNAT, pasar jual beli alamat, dual stack IPv6. Puluhan tahun dan triliunan biaya. Semuanya "tidak diperlukan jika sejak awal dibiarkan kosong".

IPv6 menggunakan 128 bit. 3,4 × 10^38 alamat. 6,7 × 10^17 per meter persegi permukaan bumi. Kali ini cukup? Mungkin. Tapi mereka sendiri tidak yakin, itulah mengapa memilih 128 bit.

---

## Pelajaran dari Unicode

Pada tahun 1991, Unicode 1.0 berpikir bahwa 16 bit sudah cukup. 65.536 karakter. Tampaknya bisa menampung semua karakter di dunia.

Ternyata tidak cukup. Ekstensi karakter Tionghoa, emoji, aksara kuno, simbol musik. Melampaui batas 16 bit.

Hasilnya: surrogate pair UTF-16. Salah satu hack paling buruk dalam sejarah perangkat lunak. Windows, Java, dan JavaScript masih menanggung warisan ini.

Unicode akhirnya diperluas menjadi 21 bit (1.114.112 code point). Penggunaan saat ini sekitar 10%. Sisanya dibiarkan kosong. Kali ini, pelajaran telah dipetik.

---

## Pelajaran dari ASCII

Pada tahun 1963, ASCII menggunakan 7 bit. 128 karakter. Hanya memikirkan bahasa Inggris.

Akibatnya, umat manusia hidup selama 60 tahun dalam neraka encoding. EUC-KR, Shift_JIS, Big5, seri ISO-8859, CP949. Byte yang sama menampilkan karakter berbeda di sistem yang berbeda. Karakter Korea rusak. Karakter Jepang rusak. Tanda tanya di subjek email.

Jika saja mereka menggunakan 1 bit lagi. Jika mereka mengamankan 8 bit penuh dan berkata "sisanya untuk nanti". Sejarah akan berbeda.

---

## Kesombongan perancang

Semua kasus ini memiliki kesamaan: **asumsi bahwa "yang kita butuhkan sekarang sudah cukup".**

Apakah para perancang IPv4 bodoh? Tidak. Mereka adalah insinyur terbaik di zamannya. Mereka hanya meremehkan masa depan. Setiap generasi melakukan hal yang sama.

"640 KB seharusnya cukup untuk siapa pun." Ada perdebatan apakah Bill Gates benar-benar mengatakannya, tetapi faktanya insinyur dari setiap zaman jatuh ke dalam jebakan ini.

GEUL berusaha menghindari jebakan ini. Caranya sederhana. **Tidak menggunakannya.**

---

## Tiga kali kesempatan

Ada pepatah yang mengatakan bahwa kesempatan datang tiga kali. Ketiga kesempatan itu masing-masing memiliki maknanya.

```
Kesempatan pertama: 001 (standar)
  Ketika manusia menetapkan standar.
  Baik organisasi internasional, konsorsium industri, maupun komunitas.
  Ruang yang akan terisi dengan kecepatan manusia mencapai konsensus.

Kesempatan kedua: 01 (masa depan)
  Setelah S1. Ketika superinteligensi muncul.
  Entitas yang akan menyusun pengetahuan dengan cara yang tidak bisa diprediksi manusia.
  Mereka mungkin menggunakan struktur yang kita rancang apa adanya,
  atau mendefinisikan ulang dengan cara yang tidak bisa kita bayangkan.
  Ruang untuk entitas itu.

Kesempatan ketiga: 1 (masa depan jauh)
  Tidak tahu kapan.
  Mungkin ketika K1 tercapai dan menjadi peradaban antarbintang,
  mungkin ketika bentuk kesadaran berubah,
  mungkin sesuatu yang saat ini hanya bisa kita bayangkan sebagai fiksi ilmiah.
  Jika seseorang di seberang Lengan Orion* membaca bit ini,
  ruang ini milik mereka.
```

Menyisakan 50% untuk masa depan jauh berarti menyerahkan separuh kemungkinan kepada "apa yang tidak kita ketahui".

---

## Biaya Mengosongkan

Apakah mengosongkan ruang ada biayanya?

```
TAG WORD 16 bit = wilayah 3 bit + 13 bit

13 bit di wilayah saat ini 000:
  Kind    2 bit   Reference · Value · Edge · Meta
  Length  4 bit   1–14 WORD, hingga 2³²−1 WORD bila diperluas
  Codec   7 bit   124 kode langsung + 4 bentuk Issuer
```

Apakah 13 bit tidak terlalu sedikit? Tidak. Format yang tidak mendapat kode langsung ditulis sebagai format Issuer. Setiap pihak yang mendefinisikan format (Issuer) punya nomor format 16-bit sendiri, sehingga praktis tidak ada batas jumlah format. Harganya beberapa WORD TAG perluasan. Format yang sering dipakai pendek; yang jarang sedikit lebih panjang.

Biaya mengosongkan adalah tiga bit TAG WORD per rekaman. Tiga bit itu menyisakan untuk masa depan enam kali ruang yang dipakai hari ini.

Biaya mengisi? IPv4 sudah menunjukkannya. Tidak dapat dipulihkan.

---

## Prinsip Desain

Prinsip desain kelima dari [tata bahasa](/id/grammar/overview/) GEUL v1:

> **Biarkan kosong.** Sebagian besar ruang bit disimpan untuk masa depan. Kode langsung tidak dapat ditarik kembali, jadi hanya format yang frekuensinya sudah terbukti yang mendapatkannya.

Tata bahasa menetapkan prinsip ini sebagai aturan. Dekoder v1 menolak setiap TAG WORD yang bit terdepannya bukan `000`. Jalan untuk meminjam ruang kosong demi keperluan sementara sudah tertutup sejak awal.

Ini bukan keputusan teknis. Ini keputusan etis.

Memilih untuk tidak menggunakan ruang yang bisa digunakan sekarang adalah deklarasi bahwa kebebasan masa depan lebih diutamakan daripada kenyamanan masa kini. Utang yang ditinggalkan generasi perancang IPv4 kepada kita tidak akan kita wariskan kepada generasi berikutnya.

---

## Desain Paling Rendah Hati

```
"Saya tahu masa depan" -> Gunakan seluruh 16 bit.
"Saya tidak tahu masa depan" -> Kosongkan 75%.
```

Mengosongkan ruang adalah kerendahan hati. Itu tindakan mengakui bahwa kita tidak bisa mengetahui masa depan. Dan kerendahan hati itulah yang menghasilkan desain paling kokoh.

IPv4 adalah produk kepercayaan diri. 32 bit sudah cukup. Ternyata tidak.

GEUL adalah produk kerendahan hati. Kami tidak tahu apakah 12.5% yang dipakai hari ini cukup. Tetapi jika 75% dikosongkan, tidak apa-apa jika salah.

---

*Menjelaskan mengapa harus dikosongkan membutuhkan begitu banyak kata. Tindakan mengosongkan itu sendiri cukup satu baris:*

```
if (bit1 == 1): reserved  // 50%. Masa depan jauh.
```

*Satu baris kode menjaga separuh dunia.*

---

<small>

\* Orion's Arm — lengan spiral Bima Sakti tempat tata surya kita berada. Juga merupakan nama dari [Orion's Arm Universe Project](https://www.orionsarm.com/), proyek kolaboratif fiksi ilmiah keras yang membayangkan masa depan lebih dari sepuluh ribu tahun ke depan, berlatar di lengan spiral ini. Proyek ini mengeksplorasi tema seperti superinteligensi, peradaban antarbintang, dan transformasi kesadaran dengan ketelitian ilmiah, dan telah dibangun oleh ratusan kontributor sejak tahun 2000. Apa yang GEUL sebut "masa depan jauh", mereka sudah membayangkannya.

</small>
