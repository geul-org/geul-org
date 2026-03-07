---
title: "Mengapa Harus Dibiarkan Kosong"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["reserved", "ekstensibilitas", "64-bit", "prinsip-desain", "IPv4"]
summary: "GEUL mengosongkan 75% ruang 64-bitnya. Pelajaran dari IPv4, Unicode, dan ASCII mengajarkan — biaya mengisi tidak dapat dikembalikan, tetapi biaya mengosongkan adalah nol."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 bit memiliki 18.446.744.073.709.551.616 alamat. 18,4 kuintiliun. GEUL mengosongkan 75% di antaranya.

```
bit1 = 1:    50%    masa depan jauh
bit1-2 = 01: 25%    masa depan dekat
bit1-3 = 001: 12,5% standar
bit1-4 = 0001: 6,25% proposal saat ini
```

Ruang yang saat ini digunakan adalah 6,25%. Dari 93,75% sisanya, 12,5% akan digunakan ketika standar ditetapkan, dan 75% dicadangkan untuk generasi yang belum lahir.

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

## Biaya mengosongkan

Apakah mengosongkan memiliki biaya?

```
75% dicadangkan dari 64 bit = 48 bit tidak digunakan.
Sisa 16 bit (6,25%) = 1.152.921.504.606.846.976 alamat.

11,5 kuintiliun.
10 juta kali lipat seluruh Wikidata (108 juta).
Cukup untuk menampung semua data yang ada dan masih tersisa.
```

Mengosongkan tidak berarti kekurangan. 6,25% sudah cukup untuk kebutuhan saat ini. Biaya mengosongkan adalah 0.

Biaya mengisi? IPv4 sudah menunjukkannya. Tidak bisa dikembalikan.

---

## Prinsip desain

Pasal 1 prinsip desain GEUL Grammar v0.11:

> **Ekstensibilitas jangka panjang:** Bit yang dicadangkan tidak dialihkan untuk penggunaan sementara. Ruang dipertahankan agar generasi mendatang dapat menggunakannya.

Ini bukan keputusan teknis, melainkan keputusan etis.

Tidak menggunakan ruang yang bisa digunakan sekarang adalah deklarasi bahwa kebebasan masa depan lebih penting daripada kenyamanan saat ini. Utang yang ditinggalkan generasi perancang IPv4 kepada kita, tidak akan kita tinggalkan kepada generasi berikutnya.

---

## Desain paling rendah hati

```
"Saya tahu masa depan" → Gunakan seluruh 64 bit.
"Saya tidak tahu masa depan" → Kosongkan 75%.
```

Mengosongkan adalah kerendahan hati. Mengakui bahwa kita yang ada sekarang tidak bisa mengetahui masa depan. Dan kerendahan hati itulah yang menghasilkan desain paling kokoh.

IPv4 adalah produk kepercayaan diri. 32 bit cukup. Ternyata tidak.

GEUL adalah produk kerendahan hati. Kami tidak tahu apakah 6,25% dari 64 bit akan cukup. Tapi jika kami mengosongkan 75%, tidak apa-apa jika kami salah.

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
