---
title: "Mengapa WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-03-01T14:00:00+09:00
tags: ["WordNet", "kata kerja", "primitif semantik", "synset"]
summary: "Membangun sistem kata kerja dari nol berarti ada yang terlewat, subjektif, dan tanpa dasar. WordNet adalah basis data leksikal 40 tahun berisi 13.767 synset kata kerja yang dibangun oleh ahli bahasa. Kami meminjam kamusnya dan membangun tata bahasa di atasnya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Kata kerja diperlukan.

Agar AI dapat mendeskripsikan dunia, harus ada kata kerja. Dalam kalimat "Laksamana Korea Yi Sun-sin membangun kapal penyu", tanpa "membangun" tidak ada kalimat.

Untuk identifikasi entitas ada Wikidata. Yi Sun-sin adalah Q28090. Kapal penyu adalah Q249845. Identifikasinya sudah selesai.

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

Ini analog dengan relasi Wikidata. Wikidata memberi tahu bahwa Yi Sun-sin adalah Q28090. Tapi bagaimana menyusun kalimat tentang Yi Sun-sin bukan urusan Wikidata.

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

## Di balik itu: atom semantik

13.767 kata kerja WordNet adalah daftar kata kerja yang diberi nama oleh manusia. Komprehensif, tapi bukan segalanya.

"give" bisa dipecah lebih lanjut: CAUSE + HAVE + MOVE. Dekomposisi menjadi atom semantik (semantic primitive). Ketika dekomposisi ini selesai, kata kerja yang tidak ada dalam daftar pun bisa diekspresikan sebagai kombinasi atom.

Jika WordNet adalah pustaka standar, sistem atom semantik adalah kompiler. Sebagaimana kompiler bisa membuat fungsi yang tidak ada di pustaka standar.

Ini adalah tantangan riset besar, yang dicoba setelah sistem berbasis WordNet berjalan. Untuk saat ini, pustaka standar sudah cukup.

---

## Ringkasan

Setiap proyek yang hendak membangun sistem kata kerja menemui pertanyaan yang sama: dari mana mendapatkannya?

Membangun sendiri berarti ada yang terlewat, sewenang-wenang, dan tanpa dasar.
Membangun di atas WordNet berarti tidak ada yang terlewat, ada konsensus, dan berbasis data.

WordNet adalah kamus kata kerja umat manusia yang diakumulasikan oleh ahli bahasa selama 40 tahun.
Meminjam kata-kata dari kamus ini, tapi membangun tata bahasanya sendiri.
Inilah alasan menggunakan Wikidata untuk entitas dan WordNet untuk kata kerja.
