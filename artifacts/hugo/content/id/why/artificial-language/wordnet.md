---
title: "Mengapa WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["WordNet", "kata kerja", "primitif semantik", "synset"]
summary: "Membangun sistem kata kerja sendiri berarti ada celah, sewenang-wenang, dan tanpa dasar. GEUL mempelajari strukturnya dengan membuat codebook sementara dari 13.767 kata kerja WordNet yang terkumpul selama 40 tahun. Karena WordNet bukan CC0 dan terikat pada bahasa Inggris, edisi sementara ini akan diganti dengan codebook kata kerja tanpa WordNet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kata kerja diperlukan.

Agar AI dapat mendeskripsikan dunia, harus ada kata kerja. Dalam kalimat "Laksamana Korea Yi Sun-sin membangun kapal penyu", tanpa "membangun" tidak ada kalimat.

Untuk identifikasi entitas ada Wikidata. Yi Sun-sin adalah Q50184. Kapal penyu adalah Q695959. Identifikasinya sudah selesai.

Untuk kata kerja, tidak ada padanannya. Tidak ada ID untuk "membangun". Tidak ada standar yang disepakati apakah "membangun", "membuat", dan "memproduksi" bermakna sama atau berbeda.

Setiap proyek yang berurusan dengan kata kerja — baik grafik pengetahuan, pencarian semantik, maupun desain bahasa terstruktur — pasti menemui pertanyaan ini: dari mana mendapatkan sistem kata kerja?

---

## Membangun sendiri

Daftar kata kerja bisa dirancang dari awal.

move, give, think, feel, say. Tentukan sekitar 50 kata kerja dasar, lalu tambahkan kata kerja turunan. Di bawah move: walk, run, crawl. Di bawah give: donate, bestow, grant.

Muncul tiga masalah.

Pertama, ada yang terlewat. Ketika seseorang mendaftar kata kerja dari kepala, pasti ada yang terlupa. Terlupa "mengadsorpsi", terlupa "merenungkan", terlupa "menyerah". Saat kata kerja yang terlewat dibutuhkan, sistem runtuh.

Kedua, tidak ada kriteria. Apakah walk dan stroll adalah kata kerja terpisah atau variasi dari kata kerja yang sama? Jika dibangun sendiri, keputusan ini bergantung pada intuisi perancang. Intuisi tiap orang berbeda.

Ketiga, hierarkinya sewenang-wenang. walk diletakkan di bawah move, tapi walk juga bisa menjadi turunan travel. Perancang yang memutuskan penempatannya. Keputusan itu tanpa dasar objektif.

Sistem kata kerja buatan sendiri terlihat sempurna di benak pembuatnya. Ketika orang lain melihat, reaksinya: "Kenapa diklasifikasikan begini?"

---

## Warisan WordNet

Basis data leksikal bahasa Inggris yang mulai dibangun di Universitas Princeton sejak 1985.

Selama 40 tahun, ahli bahasa mengelompokkan kata-kata bahasa Inggris ke dalam unit makna (synset) dan menghubungkannya dengan relasi hierarkis. Kata kerja saja berjumlah 13.767 synset. Setiap synset memiliki ID unik, definisi, dan relasi eksplisit dengan synset lain.

"donate" dan "bestow" dikelompokkan dalam synset yang sama. Artinya bermakna sama.
"donate" adalah troponym dari "give". Artinya bentuk spesifik dari give.
"give" adalah troponym dari "transfer". Artinya bentuk spesifik dari transfer.

Hierarki ini sudah tersusun untuk 13.767 kata kerja.

Tidak ada yang terlewat. Karena ahli bahasa mengisinya selama 40 tahun.
Ada kriteria. Karena definisi dan relasi synset bersifat eksplisit.
Hierarkinya berdasar. Karena relasi troponym dibangun atas analisis linguistik.

---

## Kamus dan tata bahasa berbeda

Jika WordNet adalah kamus kata kerja, bagaimana menggunakan kata kerja tersebut adalah masalah terpisah.

WordNet memberi tahu arti "give" dan hubungannya dengan "donate". Tapi tidak memberi tahu struktur penggunaan "give" dalam kalimat — siapa yang memberi, apa yang diberikan, kepada siapa.

Ini analog dengan relasi Wikidata. Wikidata memberi tahu bahwa Yi Sun-sin adalah Q50184. Tapi bagaimana menyusun kalimat tentang Yi Sun-sin bukan urusan Wikidata.

Kamusnya dipinjam, tapi tata bahasanya dibangun sendiri.

Yang diambil dari WordNet: ID synset, definisi semantik, dan pohon hierarki troponym. Verb frame, struktur partisipan, dan pola sintaksis yang juga disediakan WordNet lebih baik dirancang sendiri oleh setiap proyek. Karena informasi sintaksis WordNet terikat pada bahasa Inggris, dan sistem semantik kata kerja dengan cara penggunaannya adalah masalah yang terpisah.

---

## Dari 13.767 ke 10

Mendaftar seluruh 13.767 kata kerja WordNet tidak ada gunanya. Diperlukan struktur.

Menelusuri pohon troponym WordNet ke atas, kita sampai di simpul puncak yang tidak bisa naik lagi. Kata kerja akar. Jumlahnya 559.

Mengelompokkan 559 secara semantik menghasilkan 68 sub-primitif (sub-primitive).
Mengelompokkan 68 lebih lanjut menghasilkan 10 primitif (primitive).

```
13.767 kata kerja → 559 akar → 68 sub-primitif → 10 primitif

BE        — keberadaan, kepemilikan, lokasi
PERCEIVE  — persepsi, penginderaan, penemuan
FEEL      — emosi, preferensi, keinginan
THINK     — pemikiran, penilaian, ingatan
CHANGE    — perubahan, permulaan, pengakhiran
CAUSE     — tindakan, penciptaan, penghancuran
MOVE      — perpindahan, kedatangan, kepergian
COMMUNICATE — ujaran, penandaan, kesepakatan
TRANSFER  — penyerahan, penerimaan, pertukaran
SOCIAL    — kerja sama, persaingan, keanggotaan
```

Sepuluh ini adalah primitif semantik kata kerja manusia. Bukan dari intuisi satu orang, melainkan dari struktur akumulasi 40 tahun WordNet dan 13.767 titik data.

Hierarki empat lapis ini — primitif, sub-primitif, akar, kata kerja individual — memungkinkan pengaturan resolusi. Secara kasar ada 10 jenis tindakan; secara detail ada 13.767 jenis. Baca di resolusi yang dibutuhkan.

---

## Perluasan dan kompresi

Jika 13.767 tidak cukup? Kata kerja baru bisa ditambahkan. Kata kerja multibahasa, neologisme, istilah teknis. Tambahkan di bawah sub-primitif yang sesuai. Sistem yang ada tidak rusak.

Jika 13.767 terlalu banyak? Synset sinonim bisa digabung menjadi satu. Arahkan donate ke give. Data yang sebelumnya tercatat sebagai donate akan menemukan give. Prinsipnya sama dengan HTTP 301.

Yang penting adalah urutannya. Masukkan semua dulu, jalankan, lihat data penggunaan, baru kurangi. Mengurangi di atas kertas tanpa data akan menghilangkan pembedaan yang diperlukan.

---

## Lebih jauh: atom semantik

13.767 kata kerja WordNet adalah daftar kata kerja yang pernah dinamai manusia. Menyeluruh, tetapi bukan segalanya.

"give" bisa diurai lebih jauh: CAUSE + HAVE + MOVE. Menguraikannya menjadi primitif semantik (semantic primitive). Setelah penguraian ini selesai, kata kerja yang tidak ada dalam daftar pun bisa diungkapkan sebagai kombinasi atom.

Jika WordNet adalah pustaka standar, sistem atom semantik adalah kompilernya. Seperti kompiler bisa membuat fungsi yang tidak ada di pustaka standar.

Ini tugas penelitian besar, yang dicoba setelah codebook kata kerja benar-benar dipakai.

---

## Mengapa sementara

GEUL membuat codebook kata kerja di atas struktur ini: [wordnet-verb](/id/repos/#wordnet-verb), yang memberi setiap dari 13.767 synset kata kerja WordNet 3.0 sebuah kode 16-bit, dengan kode berdekatan untuk makna berdekatan. Namun ini edisi sementara untuk rujukan. Ada tiga alasan.

**Lisensi.** WordNet berada di bawah WordNet 3.0 License. Keluaran publik GEUL adalah CC0. Daftar dan definisi turunan WordNet tidak bisa dipindahkan ke codebook CC0.

**Bahasa Inggris.** Synset adalah satuan makna kata-kata bahasa Inggris. GEUL membutuhkan sistem kata kerja yang tidak terikat pada bahasa tertentu.

**Tempat.** Cara membawa kode kata kerja di dalam rekaman GEUL belum diputuskan.

Karena itu edisi sementara ini akan diganti dengan codebook kata kerja murni yang tidak memakai WordNet. Pelajaran dari WordNet tetap tinggal: cakupan harus lengkap, kriteria harus eksplisit, dan hierarki harus berdasar.

---

## Ringkasan

Setiap proyek yang mencoba membangun sistem kata kerja menghadapi pertanyaan yang sama: dari mana mengambilnya?

Membangun sendiri berarti ada celah, kesewenang-wenangan, dan tanpa dasar.
Memulai dari WordNet berarti tanpa celah, ada konsensus, dan berdasar data.

Karena itu GEUL memulai dari WordNet. Tetapi itu hanya titik awal.
Keluaran publik harus CC0, dan sistem kata kerja tidak boleh terikat pada bahasa Inggris.
Pelajari strukturnya dari WordNet, lalu bangun ulang dari sumber CC0 dan data penggunaan nyata.
Prinsipnya tetap: pinjam kamusnya, bangun tata bahasanya sendiri.
