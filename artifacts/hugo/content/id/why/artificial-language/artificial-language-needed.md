---
title: "Mengapa Bahasa Buatan Diperlukan?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["bahasa buatan", "bahasa alami", "halusinasi", "LLVM IR"]
summary: "Bahasa alami berevolusi untuk komunikasi manusia. Ambiguitas, redundansi, dan implikasi adalah kelebihan bagi manusia tetapi penyebab halusinasi bagi AI. Bahasa pemrograman maupun kerangka semantik yang ada bukan jawabannya. Diperlukan bahasa buatan baru yang memenuhi enam syarat secara bersamaan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## Bahasa alami membawa manusia sampai di sini. Tetapi tidak bisa lagi melangkah lebih jauh.

---

## Bahasa Alami: Penemuan Terbesar

Teknologi terbesar yang pernah diciptakan manusia adalah bahasa alami.

Bukan penemuan api, bukan penemuan roda, bukan penemuan semikonduktor.
Yang membuat semua itu mungkin adalah bahasa alami.

Berkat bahasa alami, pengetahuan bisa ditransmisikan.
Berkat bahasa alami, kerja sama bisa terjadi.
Berkat bahasa alami, yang hidup bisa mewarisi pikiran yang mati.

Alasan Homo sapiens menguasai bumi bukan ototnya melainkan bahasanya.
Selama puluhan ribu tahun, bahasa alami menjadi medium seluruh aktivitas intelektual manusia.

Dan sekarang, bahasa alami telah menjadi bottleneck era AI.

---

## Mengapa bahasa alami lahir?

Untuk memahami masalah ini, kita harus kembali ke tujuan asal bahasa alami.

Bahasa alami berevolusi untuk **komunikasi real-time antarmanusia**.

Ketika manusia purba berburu di sabana,
yang diperlukan untuk menyampaikan "Ada singa di sana!" bukanlah
struktur logis yang presisi melainkan kecepatan penyampaian.

Tekanan evolusioner inilah yang menentukan semua karakteristik bahasa alami.

**Ambiguitas adalah fitur.**
Tidak perlu tahu "di sana" tepatnya berapa meter.
Ketika pendengar menoleh, singa akan terlihat.
Konteks mengompensasi ambiguitas.

**Redundansi adalah fitur.**
Makna harus tersampaikan meskipun angin menelan separuh ucapan.
Karena itu bahasa alami mengekspresikan makna yang sama dengan berbagai cara.

**Implikasi adalah fitur.**
"Sudah makan?" dalam bahasa Indonesia bisa menjadi sapaan akrab,
karena konteks budaya bersama mendekode implikasi itu.

Semua karakteristik ini adalah kelebihan dalam komunikasi antarmanusia.
Cepat, fleksibel, dan beradaptasi dengan konteks.

Masalah muncul ketika kita mencoba menggunakannya untuk AI.

---

## Apa arti bahasa alami bagi AI?

LLM saat ini menerima bahasa alami, bernalar dalam bahasa alami, dan menghasilkan bahasa alami.

Ini seperti melakukan eksperimen kimia
sambil mencatat semua pengukuran sebagai "agak banyak", "sedikit", "kira-kira segini".

"Soekarno itu hebat."

Apa yang terjadi ketika AI memproses kalimat ini?

Siapa yang bilang dia hebat? Pembicara? Sejarawan? Masyarakat Indonesia?
Dengan kriteria apa hebat? Militer? Moral? Dampak sejarah?
Kapan ukurannya? Di zamannya? Sekarang?
Seberapa yakin? Fakta? Opini? Tebakan?

Bahasa alami tidak menentukan satupun dari itu.
Semuanya diimplikasikan dalam "pahami sendiri dari konteks".

Manusia memiliki perangkat keras evolusioner puluhan ribu tahun untuk mendekode implikasi ini.
Ekspresi wajah, nada suara, pengalaman bersama, latar belakang budaya.
AI tidak punya semua itu. Yang dimilikinya hanya teks.

Maka AI menebak. Dan menyampaikan tebakannya seolah-olah itu kepastian.
Kita menyebutnya "halusinasi (Hallucination)".

Halusinasi bukan bug. Selama bahasa alami digunakan
sebagai bahasa penalaran AI, ini adalah hasil yang secara struktural tak terhindarkan.

---

## Halusinasi lahir dari ambiguitas bahasa alami

Mari kita lebih presisi di titik ini.

Ketika LLM menjawab "Soekarno memproklamasikan kemerdekaan Indonesia pada 17 Agustus 1945",
apa dasar kalimat ini?

Karena pola yang mirip dengan kalimat ini muncul dengan frekuensi tinggi dalam data pelatihan.

Namun dari sumber mana pola itu berasal,
seberapa tepercaya sumber itu,
kapan referensi waktu informasi ini,
apakah ada narasi yang bertentangan ---
semua itu tidak bisa ditampung secara struktural dalam output bahasa alami.

Tidak ada tempat untuk metadata dalam bahasa alami.

"Soekarno memproklamasikan kemerdekaan pada 17 Agustus 1945" dan
"Catatan sejarah menyatakan bahwa Soekarno memproklamasikan kemerdekaan pada 17 Agustus 1945"
dalam bahasa alami hanyalah dua kalimat yang berbeda panjang.

Namun secara epistemologis, keduanya adalah jenis pernyataan yang sepenuhnya berbeda.
Yang satu adalah klaim faktual, yang lain adalah narasi dengan sumber eksplisit.

Bahasa alami tidak membedakan perbedaan ini secara struktural.
Maka AI pun tidak membedakannya.
Maka halusinasi terjadi.

---

## Bahasa pemrograman bukan jawabannya

"Kalau begitu, kenapa tidak pakai bahasa pemrograman?"

Bahasa pemrograman tidak ambigu. Terstruktur. Presisi.
Tetapi bahasa pemrograman adalah **bahasa untuk mendeskripsikan prosedur**,
bukan **bahasa untuk mendeskripsikan dunia**.

Coba ekspresikan "Soekarno itu hebat" dalam Python:

```python
is_great("Soekarno") == True
```

Ini bukan deskripsi melainkan penilaian boolean.
Siapa yang menilai? Dengan bukti apa? Dalam konteks apa? Dengan keyakinan seberapa?
Bahasa pemrograman tidak punya struktur untuk menampung itu.

Format data seperti JSON, XML, dan RDF juga sama.
Ada struktur, tetapi tidak ada sistem terpadu untuk mendefinisikan makna struktur itu.
Setiap proyek membuat schema sendiri,
dan schema-schema itu tidak kompatibel satu sama lain.

Bahasa alami kaya makna tetapi tanpa struktur.
Bahasa pemrograman punya struktur tetapi tanpa makna.
Format data punya struktur dan makna tetapi tidak terpadu.

Yang diperlukan adalah jenis bahasa yang berbeda.

---

## Jalan yang ditunjukkan LLVM

Ada preseden yang persis dalam ilmu komputer.

Pada 1990-an, ada puluhan bahasa pemrograman
dan puluhan arsitektur prosesor.
Agar setiap bahasa mendukung setiap arsitektur,
diperlukan N × M compiler.

Solusi LLVM adalah representasi antara (IR, Intermediate Representation).

Semua bahasa diterjemahkan ke LLVM IR.
LLVM IR diterjemahkan ke semua arsitektur.
Cukup N + M konverter saja.

Pengguna tidak melihat LLVM IR.
Menulis dalam C++ dan mendapat file executable.
LLVM IR bekerja di balik layar.

GEUL adalah LLVM IR untuk AI.

Semua bahasa alami diterjemahkan ke GEUL.
GEUL disimpan di WMS, digunakan untuk penalaran, lalu diterjemahkan kembali ke bahasa alami.
Pengguna tidak melihat GEUL.
Bertanya dalam bahasa alami, menerima jawaban dalam bahasa alami.
GEUL bekerja di balik layar.

---

## Syarat yang harus dipenuhi bahasa buatan

Untuk melampaui batas bahasa alami tanpa kehilangan daya ekspresinya,
bahasa buatan harus memenuhi syarat-syarat berikut secara bersamaan:

**1. Penghapusan ambiguitas**

Ketika "Soekarno itu hebat" dimasukkan,
harus jelas secara struktural "siapa, dalam konteks apa, dengan bukti apa, dengan keyakinan seberapa mendeskripsikan itu".
Jika ada field kosong, harus ditandai sebagai kosong.
Tidak bergantung pada implikasi.

**2. Metadata tertanam**

Setiap deskripsi harus menyertakan sumber, waktu, tingkat kepercayaan, dan sudut pandang (POV)
bukan sebagai anotasi terpisah melainkan sebagai bagian dari struktur deskripsi itu sendiri.
Tanpa ini, AI White-box tidak mungkin.

**3. Kecocokan dengan LLM**

LLM harus bisa "mempelajari" bahasa ini.
Tidak harus mudah dipahami manusia.
Yang penting adalah bisa di-tokenisasi, memiliki pola reguler,
dan mengikuti struktur tetap.

**4. Daya ekspresi graf**

Dunia adalah graf, bukan tabel.
Entitas adalah node, relasi adalah edge.
Bahasa buatan harus bisa menserialisasi graf secara alami.

**5. Pemisahan fakta dan narasi**

"Soekarno wafat pada tahun 1970" bukan fakta dengan sendirinya.
"Catatan sejarah menyatakan bahwa Soekarno wafat pada tahun 1970" adalah data primer.
Bahasa buatan harus memaksakan pembedaan ini secara struktural.

**6. Kemampuan perluasan masa depan**

Sistem yang didefinisikan hari ini harus tetap bisa diperluas
dengan menjaga kompatibilitas mundur
dalam 10 tahun, 100 tahun, dan di masa depan yang tak terbayangkan.

---

## Mengapa upaya sebelumnya tidak cukup?

Ini bukan upaya pertama.

**Esperanto** adalah bahasa buatan untuk manusia.
Terstruktur, tetapi tidak dirancang untuk menampung penalaran AI.
Mengutamakan kemudahan belajar di atas presisi semantik.

**OWL/RDF** adalah sistem representasi semantik untuk mesin.
Ketat secara logika, tetapi dirancang di era pra-LLM.
Sulit dikonversi dari dan ke bahasa alami, dan ekspresinya bertele-tele.
Dan yang fatal, sangat lambat. Penalaran skala besar tidak realistis.

**Knowledge graph (Wikidata, Freebase)** merepresentasikan dunia sebagai graf.
Tetapi menyimpan "fakta", bukan "narasi".
Menyimpan "Soekarno adalah presiden" sebagai triple,
tetapi tidak mencakup siapa yang mengklaim itu, atau dengan keyakinan seberapa.

**Chain-of-Thought** mencatat proses penalaran LLM dalam bahasa alami.
Arah yang benar, tetapi karena medium catatannya bahasa alami,
tidak menyelesaikan masalah ambiguitas secara fundamental.

Semua upaya ini memenuhi satu atau dua syarat,
tetapi tidak ada yang memenuhi keenamnya secara bersamaan.

---

## GEUL: Titik temu enam syarat

GEUL berdiri di titik temu keenam syarat ini.

Format stream berbasis word 16-bit.
Setiap deskripsi secara struktural menyertakan konteks, sumber, dan tingkat keyakinan.
Menserialisasi graf melalui paket node dan edge.
Mengikuti pola tetap yang bisa dipetakan 1:1 dengan token LLM.
Memperlakukan narasi (Claim), bukan fakta, sebagai data primer.
Mereservasi 50% dari total ruang alamat untuk masa depan.

GEUL tidak terlihat oleh pengguna.
Pengguna berbicara dalam bahasa alami dan menerima jawaban dalam bahasa alami.
Di antaranya, GEUL menstrukturkan penalaran,
mencatat, mengakumulasi, dan membuatnya dapat digunakan kembali.

---

## Era bahasa alami tidak akan berakhir

Ada hal yang tidak boleh disalahpahami.

GEUL tidak menggantikan bahasa alami.
Manusia akan terus berbicara, menulis, dan berpikir dalam bahasa alami.
Bahasa alami akan hidup selamanya sebagai bahasa manusia.

Yang digantikan GEUL adalah
peran yang selama ini dimainkan bahasa alami di dalam AI.

Medium penalaran.
Format penyimpanan pengetahuan.
Protokol komunikasi antarsistem.

Dalam peran ini, bahasa alami sudah mencapai batasnya.
Batas itu terwujud sebagai halusinasi, kotak hitam, dan inefisiensi.

Bahasa alami membawa umat manusia sampai di sini.
Jasa itu abadi.
Tetapi untuk melangkah ke tahap berikutnya, diperlukan bahasa baru.

Itulah mengapa bahasa buatan diperlukan.

---

## Ringkasan

Ambiguitas bahasa alami adalah fitur dalam komunikasi manusia, tetapi cacat dalam penalaran AI.

1. Tidak ada tempat struktural untuk metadata dalam bahasa alami.
2. Maka AI bernalar tanpa sumber, tanpa tingkat keyakinan, tanpa konteks.
3. Maka halusinasi terjadi. Ini bukan bug melainkan keniscayaan struktural.
4. Bahasa pemrograman mendeskripsikan prosedur, bukan mendeskripsikan dunia.
5. Sistem representasi semantik yang ada hanya memenuhi satu atau dua syarat.
6. Diperlukan bahasa buatan baru yang memenuhi enam syarat secara bersamaan.

Sebagaimana LLVM IR adalah jembatan tak terlihat antara bahasa pemrograman dan perangkat keras,
GEUL adalah jembatan tak terlihat antara bahasa alami dan penalaran AI.
