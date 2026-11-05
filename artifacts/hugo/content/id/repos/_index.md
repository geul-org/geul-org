---
title: "Repositori"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
summary: "Repositori GitHub publik GEUL: pustaka Go dan CLI geul, pemuatan dan konversi Wikidata, mesin penelusuran SILK, statistik arsip, penganalisis teks bahasa Korea, codebook pra-v1, dan situs web ini."
image: "/images/og-default.webp"
---

Repositori publik GEUL berada di organisasi [geul-org](https://github.com/geul-org) GitHub. Tata bahasa normatifnya adalah [Tata Bahasa GEUL](/id/grammar/) di situs ini.

Dokumen GEUL adalah rangkaian WORD 16-bit. Satuan datanya adalah rekaman (record) yang diawali satu TAG WORD, dan rekaman-rekaman itu dimuat dalam satu dokumen. Dokumen diterbitkan oleh Issuer, dan setiap versinya dipatok dengan hash isi. Repositori di bawah ini adalah alat untuk menulis, membaca, mengonversi, menelusuri, dan menghitung dokumen tersebut, ditambah sebuah penganalisis teks bahasa Korea.

---

## Pustaka

### gogeul

Pustaka Go GEUL dan alat baris perintah `geul`.

Menulis, membaca, memeriksa, dan menerbitkan dokumen GEUL (`.geul`). Paket-paketnya menyediakan pemeriksaan format, dekode rekaman melalui dokumen spesifikasi Codec, diff antarversi, resolusi dependensi IMPORT, dan Codec TOULMIN. CLI `geul` mencakup penyuntingan (`new`, `add`), penerbitan (`publish`), penelusuran (`ls`, `log`, `show`, `diff`, `check`), penampil di peramban (`serve`, `build`), dan arsip pack (`pack build`, `pack unpack`). Arsip pack dapat menyimpan rekaman yang dikompresi dengan zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Bahasa | Go |
| Lisensi | CC0 |

---

## Wikidata

### wikigeul

Konversi Wikidata → GEUL (nama lama gogeulwiki).

Membaca dump JSON Wikidata secara langsung dan menghasilkan satu dokumen GEUL per item atau properti, berisi label, deskripsi, alias, pernyataan beserta kualifikator dan referensinya, serta sitelink dalam semua bahasa. Semua dokumen diterbitkan di bawah Issuer `wikidata.geul.org` (`0x00000001`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Bahasa | Go |
| Lisensi | CC0 |

### wikipg

Pemuatan dump JSON Wikidata ke PostgreSQL tanpa kehilangan data. Tidak dipakai lagi (deprecated) sejak 2026-11-03; gunakan [wikigeul](#wikigeul), yang membaca dump secara langsung.

Menyimpan entitas, label, deskripsi, alias, pernyataan, kualifikator, referensi, sitelink, dan Lexeme sesuai urutan dump, serta menyimpan setiap baris dump apa adanya. Dump itu sendiri (berkas, URL, ukuran, checksum, commit pemuat) juga dicatat. wikipg tidak bergantung pada GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipgeul](https://github.com/geul-org/wikipgeul) |
| Bahasa | Go |
| Lisensi | CC0 |

---

## Penelusuran

### silk

[SILK](/id/projects/silk/) — mesin pengindeksan dan penelusuran khusus untuk GEUL.

Membangun indeks terpartisi dan terurut dari rekaman dalam arsip pack GEUL dan menjawab kueri seperti "dokumen mana yang menyatakan bahwa pekerjaan (P106) seseorang adalah fisikawan (Q169470)?" tanpa mendekode semua dokumen. Ia memisahkan rekaman dan bidangnya hanya dari TAG WORD, tanpa codebook. Saat ini dalam tahap pengembangan awal untuk memvalidasi algoritme penelusurannya, dan formatnya dapat berubah sebelum rilis pertama.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Bahasa | Go |
| Lisensi | CC0 |

---

## Statistik

### statistics

Menghitung pemakaian TAG dalam arsip pack GEUL per Issuer.

Menghitung jumlah rekaman untuk setiap kode 9-bit yang tersisa setelah Length dibuang dari TAG WORD (TAG ID `0x000L`–`0x1FFL`). Jika diberi beberapa folder arsip atau folder set pack, semuanya dihitung bersama.

| | |
|---|---|
| GitHub | [geul-org/statistics](https://github.com/geul-org/statistics) |
| Bahasa | Go |
| Lisensi | CC0 |

---

## Bahasa Korea

### koparse

Penganalisis teks bahasa Korea.

Dimulai dengan memisahkan kata benda dari partikel dan akhiran yang melekat padanya dalam kata-kata bahasa Korea (eojeol), lalu bila perlu dikembangkan menjadi penganalisis morfologis. Dibuat sendiri dari awal tanpa memakai penganalisis morfologis atau kamus yang sudah ada, dan kamusnya hanya memakai sumber CC0 (label dan Lexeme Wikidata) serta data yang dibuat sendiri. Masih dalam tahap pengembangan awal.

| | |
|---|---|
| GitHub | [geul-org/koparse](https://github.com/geul-org/koparse) |
| Bahasa | Go |
| Lisensi | CC0 |

---

## Codebook (pra-v1)

Dua repositori di bawah ini dirancang sebelum tata bahasa v1 saat ini. Sebagian isinya tidak sesuai dengannya.

### sidx

Riset penetapan SIDX (Semantic-aligned Index).

Bahan riset untuk menetapkan SIDX, alamat semantik yang memberi nomor berdekatan kepada entitas yang maknanya berdekatan, berdasarkan statistik penggunaan Wikidata. Berisi skema atribut Entity 48-bit lama, skrip encoder, dan codebook; belum ada hasil penetapan SIDX. Definisi normatif SIDX adalah [GEUL-SIDX](/id/grammar/reference/geul-sidx/) dalam tata bahasa.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Bahasa | Python |
| Lisensi | CC0 |

### wordnet-verb

Edisi sementara codebook kata kerja 16-bit berbasis WordNet 3.0.

Memberi satu kode 16-bit kepada masing-masing dari 13.767 synset kata kerja WordNet 3.0, dengan kode berdekatan untuk kata kerja yang maknanya berdekatan. Ini edisi sementara yang akan digantikan codebook tanpa WordNet, dan cara membawa kode-kode itu dalam rekaman GEUL belum diputuskan.

Repositori ini memuat bahan turunan WordNet, sehingga **bukan keluaran CC0.** Bagian turunan WordNet mengikuti WordNet 3.0 License; hanya bagian milik proyek GEUL sendiri, seperti kode dan klasifikasinya, yang CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Bahasa | Python |
| Lisensi | WordNet 3.0 License (bagian turunan) · CC0 (bagian sendiri) |

---

## Situs Web

### geul-org

Sumber situs web ini, geul.org.

Situs statis Hugo dalam 12 bahasa, disebarkan dengan S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Bahasa | Hugo |
| Lisensi | CC0 |
