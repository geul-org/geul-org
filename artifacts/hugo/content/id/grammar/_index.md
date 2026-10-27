---
title: "Tata Bahasa GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Spesifikasi tata bahasa GEUL v1. Mendefinisikan record di atas kata 16-bit, empat Kind dan semua Codec, struktur dokumen, serta aturan Issuer dan publikasi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Spesifikasi tata bahasa GEUL v1. Jika membaca untuk pertama kali, bacalah dengan urutan berikut.

1. [Ikhtisar](/id/grammar/overview/) — apa itu GEUL dan dengan prinsip apa dirancang
2. [Record dan TAG WORD](/id/grammar/record/) — TAG WORD 16 bit, Kind, Length, Codec
3. [Dokumen](/id/grammar/document/) — HEAD dan BODY, hash isi, versi dan revisi
4. [Reference](/id/grammar/reference/), [Value](/id/grammar/value/), [Edge](/id/grammar/edge/), [Meta](/id/grammar/meta/) — empat Kind
5. [Issuer dan publikasi](/id/grammar/issuer/) — pihak yang menerbitkan dokumen dan format, tabel alokasi 1 WORD, cara publikasi, tanda tangan dan kunci verifikasi
6. [Alamat publikasi dan daftar versi](/id/grammar/publishing/) — notasi ID, alamat publikasi, penetapan format, indeks nama, daftar versi, lapisan kepercayaan
7. [Dokumen spesifikasi Codec](/id/grammar/codec-spec/) — cara menulis layout Codec sebagai dokumen GEUL
8. [Contoh: item Wikidata](/id/grammar/example/) — satu dokumen nyata

Halaman ini adalah indeks semua Codec. Mengklik nama membawa ke dokumen rinci Codec itu. Nama tanpa tautan belum memiliki dokumen rinci. Kode langsung yang tidak ada di tabel adalah cadangan.

## Kind

TAG WORD adalah `000K KLLL LCCC CCCC`. `KK` adalah Kind, `LLLL` adalah Length, dan `CCC CCCC` adalah 7 bit Codec. Namun Reference adalah 4 bit Codec dan 3 bit Quantifier.

| Nilai | Kategori | Penjelasan |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/id/grammar/reference/) | Record yang menunjuk target. `QQQ` adalah Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/id/grammar/value/) | Record nilai |
| `0001 0LLL LCCC CCCC` | [Edge](/id/grammar/edge/) | Record komposisi |
| `0001 1LLL LCCC CCCC` | [Meta](/id/grammar/meta/) | Record tentang dokumen dan record |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/id/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Nama | Kategori | ID target |
|---|---|---|---|
| `0000` | [Penanda slot](/id/grammar/reference/slot-marker/) | Cadangan | Kelompok penanda 1 WORD yang tidak menunjuk target. 3 bit bawah adalah nomor penanda (tabel di bawah) |
| `0001` | [LOCAL](/id/grammar/reference/local/) | Deklarasi | ID yang diterbitkan dokumen ini |
| `0010` | [GEUL](/id/grammar/reference/geul/) | Deklarasi | Entitas yang diterbitkan geul.org sebagai CC0. Nomor kecil dialokasikan untuk entitas berfrekuensi tinggi |
| `0011` | [GEUL-SIDX](/id/grammar/reference/geul-sidx/) | Deklarasi | GEUL SIDX (Semantic-aligned Index). Pengenal yang bitnya memuat makna |
| `0100` | [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) | Deklarasi | Item Wikidata. Bilangan bulat setelah `Q` |
| `0101` | [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/) | Deklarasi | Properti Wikidata. Bilangan bulat setelah `P` |
| `0110` | [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/) | Penunjuk-deklarasi | Issuer itu sendiri. Payload hanya Issuer (1/2/4/16 WORD) dan tidak ada ID target |
| `0111` | [DOC-POINTER](/id/grammar/reference/doc-pointer/) | Penunjuk-deklarasi | Satu versi dokumen Issuer. Issuer + ID dokumen 4 WORD + ID versi 2 WORD, tidak ada ID target |
| `1000` | [EXTERNAL-POINTER-1WORD](/id/grammar/reference/external-pointer/) | Penunjuk | LOCAL ID dalam dokumen yang diimpor dengan `IMPORT-DOC`. IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/id/grammar/reference/external-pointer/) | Penunjuk | Sama dengan di atas. IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/id/grammar/reference/external-pointer/) | Penunjuk | Sama dengan di atas. IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/id/grammar/reference/external-pointer/) | Penunjuk | Sama dengan di atas. IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/id/grammar/reference/external-issuer/) | Penunjuk-deklarasi | LOCAL ID dokumen Issuer 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/id/grammar/reference/external-issuer/) | Penunjuk-deklarasi | LOCAL ID dokumen Issuer 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/id/grammar/reference/external-issuer/) | Penunjuk-deklarasi | LOCAL ID dokumen Issuer 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/id/grammar/reference/external-issuer/) | Penunjuk-deklarasi | LOCAL ID dokumen Issuer 16 WORD |

### Penanda slot (Codec `0000`)

`0000 0000 0000 0MMM` — [Penanda slot](/id/grammar/reference/slot-marker/). Hanya muncul pada posisi itu jika daftar CODEC field menaruh WORD tersebut secara tepat.

| WORD | Nama | Arti | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/id/grammar/reference/slot-marker/) | Tidak ditulis. Field opsional dihilangkan. Tidak menegaskan apa pun tentang dunia | Tanpa snak |
| `0x0001` | [UNKNOWN-VALUE](/id/grammar/reference/slot-marker/) | Tidak diketahui. Nilai ada tetapi tidak diketahui apa | `somevalue` |
| `0x0002` | [NO-VALUE](/id/grammar/reference/slot-marker/) | Tidak ada. Nilai tidak ada | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Nama | Arti | Contoh |
|---|---|---|---|
| `000` | Identified | Individu yang teridentifikasi | Elon Musk, Korea Selatan |
| `001` | Generic | Pernyataan umum·definisional tentang seluruh jenis. Mengizinkan pengecualian. | Prajurit mematuhi perintah |
| `010` | Free-choice | Target apa saja yang memenuhi syarat | Prajurit mana pun |
| `011` | Universal | Semua target dalam cakupan yang diberikan | Semua prajurit |
| `100` | Variable | Variabel wacana | orang itu, perempuan ini |
| `101`~`111` | Reserved |  |  |

- Pada Codec `0000` (penanda slot), 3 bit bawah bukan Quantifier melainkan nomor penanda.

## Issuer

Issuer adalah pihak yang mendefinisikan dokumen dan format — [Issuer dan publikasi](/id/grammar/issuer/)

| Posisi | Arti |
|---|---|
| Kode ISSUER Value·Edge (`0x7C`~`0x7F`) | Format yang didefinisikan Issuer itu |
| Meta `DOC-ID` | Issuer yang mengeluarkan dokumen ini |
| Meta `IMPORT-DOC` | Issuer yang mengeluarkan dokumen yang diimpor |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER` | Issuer yang mengeluarkan dokumen yang ditunjuk (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Issuer yang ditunjuk itu sendiri (1/2/4/16 WORD) |

| Lebar Issuer | Penerbitan |
|---|---|
| 1 WORD | geul.org mengalokasikan kepada lembaga penetap standar dan lembaga utama ([tabel alokasi 1 WORD](/id/grammar/issuer/#tabel-alokasi-1-word)). |
| 2 WORD | Didaftarkan di geul.org. Issuer yang melalui bukti kepemilikan domain (contoh: company.com) |
| 4 WORD | Didaftarkan di geul.org. Issuer yang mendaftar tanpa bukti kepemilikan |
| 16 WORD | Penerbitan mandiri. Dihitung dari kunci publik tanpa pendaftaran. Mengikuti aturan pembuatan di bawah. |

### Algoritma tanda tangan Issuer 16 WORD

| ID algoritma tanda tangan | Algoritma |
|---|---|
| `0x0001` | Ed25519 |
| Lainnya | Cadangan |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/id/grammar/edge/)

2 bit atas Codec adalah keluarganya. Kode langsung (7 bit) dan nomor format ISSUER (16 bit) mengikuti aturan yang sama.

| 2 bit atas | Keluarga | Kode langsung | Nomor format |
|---|---|---|---|
| `00` | Pernyataan | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | Dasar | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | Eksekusi | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/id/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Pernyataan (`00`)

| CCCCC | Codec | Nama | Sub-format | Penjelasan |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/id/grammar/edge/reference-node/) |  | Pengikatan berarah bahwa Subject yang berupa Reference menunjuk Object |
| `00001` | `0x01` | [SAME-NODE](/id/grammar/edge/same-node/) |  | Identitas bahwa dua Reference menunjuk target yang sama |
| `00010` | `0x02` | [DIFFERENT-NODE](/id/grammar/edge/different-node/) |  | Non-identitas bahwa dua Reference menunjuk target yang saling berbeda |
| `00011` | `0x03` | [BIND](/id/grammar/edge/bind/) |  | Mengikat nama yang dicocokkan mesin (`UTF8-TEXT-*`) pada Subject. Unik dalam cakupan, harus cocok persis, dan tanpa bahasa |
| `00100` | `0x04` | [LABEL](/id/grammar/edge/label/) |  | Menghubungkan nama (label) bahasa Subject. Object adalah UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/id/grammar/edge/alias/) |  | Menghubungkan nama lain (alias) Subject. Layout sama dengan LABEL |
| `00110` | `0x06` | [DESCRIPTION](/id/grammar/edge/description/) |  | Menghubungkan deskripsi (description) bahasa Subject. Layout sama dengan LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Singkatan pernyataan verba |
| `01001` | `0x09` | VERB |  | Pernyataan verba |
| `01010` | `0x0A` | [TRIPLE](/id/grammar/edge/triple/) |  | Proposisi dengan urutan Predicate, Subject, Object dan rank. Object adalah nilai atau penanda UNKNOWN-VALUE·NO-VALUE. Maknanya adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya |
| `01011` | `0x0B` | [QUALIFIER](/id/grammar/edge/qualifier/) |  | Satu syarat yang membatasi proposisi Edge lain. Property, Target (Edge Id), Value (nilai atau penanda UNKNOWN-VALUE·NO-VALUE). Bagian dari proposisi |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | Ada | Struktur untuk menyatakan pandangan dunia |
| `10001` | `0x11` | TIMELINE | Ada | Struktur yang menyatakan urutan dunia dan peristiwa |
| `10010` | `0x12` | SCENE | Ada | Struktur adegan untuk pernyataan bersifat skenario |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/id/grammar/edge/publication/) |  | Publikasi dokumen. DOC-POINTER, hash isi |
| `11001` | `0x19` | DEPRECATION |  | Deprecate versi yang diterbitkan. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Penghapusan versi yang diterbitkan (batu nisan). DOC-POINTER, kategori alasan |
| `11011` | `0x1B` | [DECLARE](/id/grammar/edge/declare/) |  | Deklarasi susunan Payload satu Codec. Kind·Codec target |
| `11100` | `0x1C` | [FIELD](/id/grammar/edge/field/) |  | Satu field Payload. DECLARE tempatnya berada, lebar: record (Length TAG) atau nilai mentah n WORD |
| `11101` | `0x1D` | [ENUM](/id/grammar/edge/enum/) |  | Satu nilai kode field nilai mentah. Field, nilai kode |
| `11110` | `0x1E` | [CODEC](/id/grammar/edge/codec/) |  | Satu Kind·Codec yang diterima field. Field, WORD target (`000K KLLL LCCC CCCC`, LLLL 0000 tepat·1111 wildcard, penanda slot hanya sebagai target tepat `0000`~`0002`). Field record boleh banyak (daftar tertutup), field nilai mentah satu (Value itu tanpa TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| 2 bit atas CCCCC | Kelompok |
|---|---|
| `00` | Penunjukan dan nama |
| `01` | Proposisi |
| `10` | Struktur |
| `11` | Lainnya |

### Dasar (`01`)

| Codec | Nama | Sub-format | Penjelasan |
|---|---|---|---|
| `0x20` | [SOURCE](/id/grammar/edge/source/) |  | Menghubungkan satu record atau seluruh dokumen dengan sumbernya. Target (Edge Id BODY; di HEAD `0` = seluruh dokumen), Origin (Reference, ABSENT atau UNKNOWN-VALUE). Sifat sumber adalah TRIPLE dengan sumber sebagai Subject, sifat kutipan (tanggal akses, posisi, hash teks asli) adalah QUALIFIER yang menempel pada SOURCE. SOURCE seluruh dokumen dan QUALIFIER-nya ditaruh di HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- Rentang teks asli, pelaku pembuat, tingkat kepercayaan, masa berlaku per pasal, dan record lama ditulis dengan QUALIFIER, dan versi tempat pertama kali masuk dihitung dari riwayat versi ([SOURCE](/id/grammar/edge/source/#ungkapan-dasar-lain)).

### Eksekusi (`10`)

| CCCCC | Codec | Nama | Penjelasan |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Deklarasi fungsi. Simbol, daftar simbol parameter, tipe kembalian, isi (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Deklarasi tipe. Simbol dan komposisi (daftar simbol field, nilai enumerasi, target alias) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Ekspresi konstanta. Satu Value tersemat |
| `01001` | `0x49` | UNARY | Ekspresi unary. Operator 1 WORD, operand |
| `01010` | `0x4A` | BINARY | Ekspresi biner. Operator 1 WORD, kiri, kanan |
| `01011` | `0x4B` | CALL | Pemanggilan. Fungsi target, jumlah argumen, argumen × jumlah argumen |
| `01100` | `0x4C` | MEMBER | Akses anggota. Target, simbol field |
| `01101` | `0x4D` | INDEX | Akses indeks. Target, indeks |
| `01110` | `0x4E` | CONSTRUCT | Pembuatan nilai komposit (daftar, record). Tipe, jumlah elemen, elemen × jumlah elemen |
| `01111` | `0x4F` | CONDITIONAL | Ekspresi kondisional. Kondisi, nilai jika benar, nilai jika salah |
| `10000` | `0x50` | BLOCK | Kelompok pernyataan berurutan. Jumlah pernyataan, pernyataan × jumlah pernyataan |
| `10001` | `0x51` | ASSIGN | Penugasan. Target (simbol, MEMBER, INDEX), nilai |
| `10010` | `0x52` | IF | Percabangan kondisi. Kondisi, BLOCK benar, salah (BLOCK·IF, 0 jika tidak ada) |
| `10011` | `0x53` | SWITCH | Percabangan ganda. Target, jumlah cabang, (nilai, BLOCK) × jumlah cabang, BLOCK default (0 jika tidak ada) |
| `10100` | `0x54` | WHILE | Pengulangan kondisi. Kondisi, BLOCK isi |
| `10101` | `0x55` | FOREACH | Pengulangan iterasi. Simbol elemen, target, BLOCK isi |
| `10110` | `0x56` | JUMP | Kontrol pengulangan. Jenis 1 WORD (break, continue), pengulangan target |
| `10111` | `0x57` | RETURN | Kembalian. Nilai (0 jika tidak ada) |
| `11000` | `0x58` | RAISE | Memunculkan kesalahan. Nilai kesalahan |
| `11001` | `0x59` | TRY | Penanganan kesalahan. BLOCK isi, simbol kesalahan, BLOCK penanganan, BLOCK penutup (0 jika tidak ada) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| 2 bit atas CCCCC | Kelompok |
|---|---|
| `00` | Deklarasi |
| `01` | Ekspresi |
| `10` | Pernyataan |
| `11` | Kesalahan |

### TOULMIN (`11`)

Rinci: [TOULMIN](/id/grammar/edge/toulmin/)

| CCCCC | Codec | Nama | Penjelasan |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/id/grammar/edge/toulmin/node/) | Deklarasi kasus. Graf putusan yang memuat node dan relasi |
| `00001` | `0x61` | [PREDICATE-DECLARE](/id/grammar/edge/toulmin/expr/) | Deklarasi predikat. Fungsi·ekspresi putusan, kriteria penilaian (Spec), kontrak fakta (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/id/grammar/edge/toulmin/node/) | Deklarasi kriteria penilaian. Konstanta·daftar (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/id/grammar/edge/toulmin/node/) | Deklarasi klaim. Menaruh predikat dalam kasus sebagai aturan umum (Warrant). Dapat diserang. |
| `00100` | `0x64` | [COUNTER-DECLARE](/id/grammar/edge/toulmin/node/) | Deklarasi sanggahan. Menyerang dengan kesimpulannya sendiri. Level default Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/id/grammar/edge/toulmin/node/) | Deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level default Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/id/grammar/edge/toulmin/link/) | Relasi serangan. Putusan penyerang mengurangi putusan target secara bertahap. |
| `01001` | `0x69` | [SUPERSEDES](/id/grammar/edge/toulmin/link/) | Relasi pengesampingan. Jika penyerang Active, target dikeluarkan dari agregasi secara pasti. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Rantai prioritas `A > B > C`. Singkatan SUPERSEDES per pasangan. Layout belum ditetapkan |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/id/grammar/edge/toulmin/link/) | Komposisi eksekusi. Jika node Active, kasus turunan dieksekusi (DAG). |
| `10001` | `0x71` | [DO](/id/grammar/edge/toulmin/link/) | Tindakan yang dilakukan jika node Active |
| `10010` | `0x72` | [DO-ONCE](/id/grammar/edge/toulmin/link/) | Tindakan yang dilakukan hanya sekali walaupun dicoba ulang |
| `10011` | `0x73` | [UNDO](/id/grammar/edge/toulmin/link/) | Tindakan kompensasi DO (saga). Dilakukan berurutan terbalik jika tahap berikutnya gagal. |
| `10100` | `0x74` | [CHECKING](/id/grammar/edge/toulmin/link/) | Sambungan yang hanya memutuskan tanpa efek samping |
| `10101` | `0x75` | [ENTRY](/id/grammar/edge/toulmin/node/) | Titik masuk eksternal. Mengeksekusi atau memutuskan kasus |
| `10110` | `0x76` | [TRIGGER](/id/grammar/edge/toulmin/node/) | Titik masuk peristiwa·periodik tanpa panggilan eksternal |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Hasil putusan node·record. Hasil (Pass, Review, Fail), nilai putusan, Activated, Excluded, Level. Layout belum ditetapkan. Putusan seluruh dokumen adalah Meta [VERDICT](/id/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Bukti putusan. Posisi, nilai yang diharapkan, nilai sebenarnya (Fact). Layout belum ditetapkan |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Format yang didefinisikan Issuer |

| 2 bit atas CCCCC | Kelompok |
|---|---|
| `00` | Deklarasi |
| `01` | Relasi |
| `10` | Eksekusi |
| `11` | Hasil (`0x7C`~`0x7F` adalah ISSUER) |

### Format ISSUER Edge

Issuer dan nomor format ditaruh pada Codec extension TAG setelah `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD). 2 bit atas nomor format adalah keluarganya. Ruang nomor format terpisah dari Value.

| Issuer | Nomor format | Nama | Keluarga | Penjelasan |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/id/grammar/edge/toulmin/source/) | TOULMIN | Teks asli tulisan. Lebar SPAN dan Value UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/id/grammar/edge/toulmin/source/) | TOULMIN | Nama·string |
| `0x0000` GEUL | `0xC002` | [SECTION](/id/grammar/edge/toulmin/source/) | TOULMIN | Awal bagian. Kode bagian |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/id/grammar/edge/toulmin/source/) | TOULMIN | Awal cakupan kasus |
| `0x0000` GEUL | `0xC004` | [CASE-END](/id/grammar/edge/toulmin/source/) | TOULMIN | Akhir cakupan kasus |
| `0x0000` GEUL | `0xC005` | [PROSE](/id/grammar/edge/toulmin/source/) | TOULMIN | Paragraf uraian (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/id/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/id/grammar/edge/toulmin/node/) | TOULMIN | NODE. Referensi fungsi |
| `0x0000` GEUL | `0xC012` | [FIELD](/id/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/id/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/id/grammar/edge/toulmin/node/) | TOULMIN | NODE. Kelompok eksekusi berurutan |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Kasus → field |
| `0x0000` GEUL | `0xC021` | [MEANS](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Butir definisi → nilai·tipe |
| `0x0000` GEUL | `0xC022` | [HAS](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Butir definisi → field |
| `0x0000` GEUL | `0xC023` | [RUNS](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Titik masuk → kasus, eksekusi |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Titik masuk → kasus, putusan |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → kasus |
| `0x0000` GEUL | `0xC026` | [UNTIL](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Trigger → kasus (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Node → pengenal global |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Alias → path (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/id/grammar/edge/toulmin/link/) | TOULMIN | LINK. Node → TEXT, penulisan nama |

## Value

`0000 1LLL LCCC CCCC` — [Value](/id/grammar/value/)

2 bit atas Codec adalah keluarganya. NUMERIC/DECIMAL dibagi lagi dengan bit ke-3 dari atas (`000` NUMERIC, `001` DECIMAL).

| 2 bit atas | Keluarga | Kode langsung | Nomor format |
|---|---|---|---|
| `00` | [NUMERIC](/id/grammar/value/numeric/)/[DECIMAL](/id/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/id/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/id/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/id/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Kode langsung

| Codec | Nama | Keluarga | Penjelasan |
|---|---|---|---|
| `0x00` | [BOOL](/id/grammar/value/numeric/bool/) | NUMERIC | false atau true dengan 1 WORD tetap |
| `0x01` | [SIGNED-INTEGER](/id/grammar/value/numeric/signed-integer/) | NUMERIC | Bilangan bulat bertanda komplemen 2 dengan WORD minimum |
| `0x02` | [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/) | NUMERIC | Bilangan bulat magnitudo unsigned big-endian dengan WORD minimum |
| `0x03` | [BINARY-FLOAT](/id/grammar/value/numeric/binary-float/) | NUMERIC | Scalar IEEE 754 binary16/32/64/128 dengan Payload 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/id/grammar/value/numeric/coordinate-earth/) | NUMERIC | Lintang·bujur Bumi (WGS 84) binary64, ketidakpastian binary32 dan Reference satuannya (ABSENT = tidak diketahui) |
| `0x05` | [COORDINATE-GEO](/id/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference benda langit dan lintang·bujur binary64, ketidakpastian binary32 dan Reference satuannya |
| `0x06` | [QUANTITY](/id/grammar/value/numeric/quantity/) | NUMERIC | amount Value numerik (bilangan bulat·BINARY-FLOAT·desimal·pecahan), Reference satuan, batas bawah·atas. Satuan·batas dapat dihilangkan (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/id/grammar/value/numeric/fraction/) | NUMERIC | Pecahan yang mempertahankan notasi asli: pembilang bilangan bulat·desimal, penyebut bilangan bulat·desimal tanpa tanda. Tidak disederhanakan |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` dari eksponen bertanda `E` dan koefisien `C` komplemen 2 dengan WORD minimum |
| `0x11` | [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` dari eksponen bertanda `E` dan koefisien unsigned `C` dengan WORD minimum |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/) | TIME | Jumlah hari bertanda dengan acuan `1970-01-01` proleptic Gregorian |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/id/grammar/value/time/civil-time-nanoseconds/) | TIME | Koefisien nanosecond unsigned setelah tengah malam hari sipil |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/) | TIME | Koefisien detik bertanda sejak epoch Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/id/grammar/value/time/duration-seconds/) | TIME | Waktu berlalu SI-second bertanda tanpa epoch |
| `0x24`/`0x25` | [EDTF](/id/grammar/value/time/edtf/) | TIME | String tanggal EDTF (ISO 8601-2). Byte genap·ganjil. Tanggal yang dapat ditulis sebagai GREGORIAN-DATE tidak ditulis dengan ini |
| `0x26`/`0x27` | [GEDCOM-DATE](/id/grammar/value/time/gedcom-date/) | TIME | String nilai tanggal GEDCOM 7. Mempertahankan notasi asli kalender lain (Julian, dan lain-lain). Byte genap·ganjil |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/id/grammar/value/text/utf8-text/) | TEXT | Deretan byte UTF-8 valid tanpa mengisyaratkan normalisasi. Byte genap |
| `0x41` | [UTF8-TEXT-ODD](/id/grammar/value/text/utf8-text/) | TEXT | Sama dengan di atas. Byte ganjil |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/id/grammar/value/text/uri/) | TEXT | Deretan byte ASCII production `URI` RFC 3986. Byte genap |
| `0x45` | [URI-ODD](/id/grammar/value/text/uri/) | TEXT | Sama dengan di atas. Byte ganjil |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/id/grammar/value/text/language-bcp47-code/) | TEXT | Deretan byte ASCII language tag BCP 47 lengkap dengan canonical casing. Byte genap |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/id/grammar/value/text/language-bcp47-code/) | TEXT | Sama dengan di atas. Byte ganjil |
| `0x48` | [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/) | TEXT | Kode kompresi bahasa primer GEUL dengan Payload tetap 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/) | TEXT | Teks dengan bahasa. Record Value bahasa (LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE) dan byte UTF-8. Genap·ganjil byte teks |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/id/grammar/value/binary/uuid/) | BINARY | UUID RFC 9562 128 bit dengan Payload tetap 8 WORD |
| `0x61` | [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/) | BINARY | Hasil SHA-256 dengan Payload tetap 16 WORD |
| `0x62` | [SHA1-DIGEST](/id/grammar/value/binary/sha1-digest/) | BINARY | Hasil SHA-1 dengan Payload tetap 10 WORD. Hanya untuk keperluan identifikasi seperti ID objek git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Format yang didefinisikan Issuer. Lihat Format ISSUER Value di bawah |

### Format ISSUER Value

Issuer dan nomor format ditaruh pada Codec extension TAG setelah `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD). 2 bit atas nomor format adalah keluarganya.

| Issuer | Nomor format | Nama | Keluarga | Penjelasan |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/id/grammar/value/time/duration-nanoseconds/) | TIME | Waktu berlalu nanosecond bertanda tanpa epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/id/grammar/value/binary/opaque-bytes/) | BINARY | Deretan byte yang makna·formatnya tidak diketahui. Byte genap |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/id/grammar/value/binary/opaque-bytes/) | BINARY | Sama dengan di atas. Byte ganjil |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/id/grammar/value/binary/bit-vector/) | BINARY | N bit yang disimpan MSB-first setelah bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | Interchange bits BF16 dengan Payload tetap 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/id/grammar/value/vector/dense-i16-vector/) | NUMERIC | Vektor int16 big-endian berurutan |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/id/grammar/value/vector/dense-u16-vector/) | NUMERIC | Vektor uint16 big-endian berurutan |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/id/grammar/value/vector/dense-i32-vector/) | NUMERIC | Vektor int32 big-endian berurutan |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/id/grammar/value/vector/dense-u32-vector/) | NUMERIC | Vektor uint32 big-endian berurutan |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/id/grammar/value/vector/dense-i64-vector/) | NUMERIC | Vektor int64 big-endian berurutan |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/id/grammar/value/vector/dense-u64-vector/) | NUMERIC | Vektor uint64 big-endian berurutan |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/id/grammar/value/vector/dense-binary16-vector/) | NUMERIC | Vektor IEEE 754 binary16 berurutan |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/id/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | Vektor BF16 berurutan |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/id/grammar/value/vector/dense-binary32-vector/) | NUMERIC | Vektor IEEE 754 binary32 berurutan |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/id/grammar/value/vector/dense-binary64-vector/) | NUMERIC | Vektor IEEE 754 binary64 berurutan |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/id/grammar/value/vector/point2-binary64/) | NUMERIC | Vektor 2 dimensi IEEE binary64 dengan urutan `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/id/grammar/value/vector/point3-binary64/) | NUMERIC | Vektor 3 dimensi IEEE binary64 dengan urutan `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/id/grammar/value/vector/bbox2-binary64/) | NUMERIC | Vektor IEEE binary64 dengan urutan `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/id/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format·rank·shape dan payload dense C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/id/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format·rank·shape dan payload packed low-bit-first dalam octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/id/grammar/value/etc/complex64/) | NUMERIC | Dua binary32 dengan urutan `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/id/grammar/value/etc/complex128/) | NUMERIC | Dua binary64 dengan urutan `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/id/grammar/value/etc/rational-i64/) | NUMERIC | Numerator int64 yang dinormalisasi dan denominator int64 positif |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/id/grammar/value/etc/closed-interval-binary64/) | NUMERIC | Interval tertutup binary64 dengan `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/id/grammar/value/etc/quaternion-binary32/) | NUMERIC | Empat binary32 dengan urutan `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/id/grammar/value/binary/blake3-256-digest/) | BINARY | Hasil BLAKE3 default dengan Payload tetap 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/id/grammar/value/text/uri-relative-ref/) | TEXT | Deretan byte ASCII relative-ref RFC 3986. Byte genap |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/id/grammar/value/text/uri-relative-ref/) | TEXT | Sama dengan di atas. Byte ganjil |
| `0x0020` IETF | `0xC000` | [CRC32C](/id/grammar/value/binary/crc32c/) | BINARY | Hasil CRC-32C Castagnoli dengan Payload tetap 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/id/grammar/value/binary/ipv4-address/) | BINARY | Alamat IPv4 32 bit dengan Payload tetap 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/id/grammar/value/binary/ipv6-address/) | BINARY | Alamat IPv6 128 bit dengan Payload tetap 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/id/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD dengan Payload tetap 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/id/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD dengan Payload tetap 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/id/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD dengan Payload tetap 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/id/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID dengan Payload tetap 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/id/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID dengan Payload tetap 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/id/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID dengan Payload tetap 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/id/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Koefisien nanosecond bertanda sejak epoch Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/id/grammar/value/binary/mac-48-address/) | BINARY | Alamat MAC IEEE 802 48 bit dengan Payload tetap 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/id/grammar/value/vector/rgba8-unorm/) | NUMERIC | Vektor packed 4×UNORM8 tetap dengan urutan R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/id/grammar/value/vector/bgra8-unorm/) | NUMERIC | Vektor packed 4×UNORM8 tetap dengan urutan B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Scalar ONNX E4M3FN pada octet atas Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Scalar ONNX E4M3FNUZ pada octet atas Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Scalar ONNX E5M2 pada octet atas Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Scalar ONNX E5M2FNUZ pada octet atas Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Scalar E8M0FNU unsigned hanya-eksponen pada octet atas Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Scalar ONNX/DLPack E2M1FN pada nibble atas Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/id/grammar/value/time/tai-timestamp-seconds/) | TIME | Koefisien SI-second bertanda sejak `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/id/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Koefisien nanosecond bertanda sejak epoch TAI yang sama |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/id/grammar/value/binary/sha-512-digest/) | BINARY | Hasil SHA-512 dengan Payload tetap 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/id/grammar/value/binary/sha3-256-digest/) | BINARY | Hasil SHA3-256 dengan Payload tetap 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/id/grammar/value/time/gps-timestamp-seconds/) | TIME | Koefisien detik bertanda sejak epoch GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/id/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Koefisien nanosecond bertanda sejak epoch GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/id/grammar/meta/)

3 bit atas Codec adalah kelasnya. Meta tidak memiliki kode ISSUER.

| 3 bit atas | Kelas | Kode langsung | Yang ditangani |
|---|---|---|---|
| `000` | [Struktur](/id/grammar/meta/structure/) | `0x00`~`0x0F` | Batas dan panjang dokumen |
| `001` | [Definisi](/id/grammar/meta/declaration/) | `0x10`~`0x1F` | Deklarasi interpretasi |
| `010` | [Asal-usul](/id/grammar/meta/provenance/) | `0x20`~`0x2F` | Siapa, kapan, di mana |
| `011` | [Silsilah](/id/grammar/meta/lineage/) | `0x30`~`0x3F` | Dari apa dan bagaimana dihasilkan |
| `100` | [Verifikasi](/id/grammar/meta/verification/) | `0x40`~`0x4F` | Apakah dapat dipercaya |
| `101` | [Kebijakan](/id/grammar/meta/policy/) | `0x50`~`0x5F` | Bagaimana diperlakukan |
| `110` | [IMPORT](/id/grammar/meta/import/) | `0x60`~`0x6F` | Mengimpor dokumen eksternal dengan IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Struktur (`000`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x00` | [DOC-1WORD](/id/grammar/meta/structure/doc/) | Awal dokumen yang menetapkan panjang total pada Payload 1 WORD |
| `0x01` | [DOC-2WORD](/id/grammar/meta/structure/doc/) | Awal dokumen yang menetapkan panjang total pada Payload 2 WORD |
| `0x02` | [DOC-4WORD](/id/grammar/meta/structure/doc/) | Awal dokumen yang menetapkan panjang total pada Payload 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/id/grammar/meta/structure/body/) | 1 WORD. Mengakhiri HEAD dokumen dan memulai BODY. |
| `0x0F` | [END](/id/grammar/meta/structure/end/) | 1 WORD. Menutup dokumen. |

### Definisi (`001`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x10` | [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/) | Edisi spesifikasi GEUL yang diikuti. Payload adalah bilangan bulat unsigned dengan lebar terpendek. v1 adalah `0x0001` (record `0x1890 0x0001`) |
| `0x11` | [PROFILE](/id/grammar/meta/declaration/profile/) | Profil yang diterapkan |
| `0x12` | [DOC-ID](/id/grammar/meta/declaration/doc-id/) | Pengenal dokumen ini. Reference tersemat `DOC-POINTER` (Issuer, ID dokumen, versi 0) |
| `0x13` | [EFFECTIVE-FROM](/id/grammar/meta/declaration/effective-from/) | Tanggal berlaku versi ini. Value GREGORIAN-DATE atau POSIX-TIMESTAMP. Jika tidak ada, waktu publikasi |
| `0x14` | [EFFECTIVE-UNTIL](/id/grammar/meta/declaration/effective-until/) | Akhir masa berlaku versi ini (berlaku terbatas). Jika tidak ada, sampai versi berikutnya berlaku |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/id/grammar/meta/declaration/default-language/) | Bahasa default |
| `0x17`~`0x1F` | Reserved |  |

### Asal-usul (`010`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x20` | [AUTHOR](/id/grammar/meta/provenance/author/) | Penulis. Reference (git author) |
| `0x21` | [CO-AUTHOR](/id/grammar/meta/provenance/co-author/) | Penulis bersama. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/id/grammar/meta/provenance/created-at/) | Waktu penulisan. Value TIME (git author date) |
| `0x23` | [MODIFIED-AT](/id/grammar/meta/provenance/modified-at/) | Waktu modifikasi. Value TIME |
| `0x24` | [RECORDED-BY](/id/grammar/meta/provenance/recorded-by/) | Pelaku perekam. Reference (git committer) |
| `0x25` | [RECORDED-AT](/id/grammar/meta/provenance/recorded-at/) | Waktu perekaman. Value TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- Materi sumber beserta rentang·waktu perolehan·hash-nya tidak ditulis sebagai Meta, melainkan sebagai Edge dasar [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) (Target `0`) di HEAD dan QUALIFIER-nya.

### Silsilah (`011`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x30` | [PARENT](/id/grammar/meta/lineage/parent/) | Hash isi versi sebelumnya (git parent). Jika tidak ada, itu versi pertama, dan jika beberapa, itu merge (git merge commit). |
| `0x31` | [DERIVED-FROM](/id/grammar/meta/lineage/derived-from/) | Diturunkan dari record·materi silsilah lain. Untuk mengunci pada versi tertentu materi eksternal, tempelkan QUALIFIER hash teks asli (P4092) pada [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) di HEAD (git submodule). |
| `0x32` | [GENERATED-BY](/id/grammar/meta/lineage/generated-by/) | Pelaku pembuat. Manusia, model, mesin aturan |
| `0x33` | [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/) | Metode konversi. Alat·aturan·versi |
| `0x34` | [CHERRY-PICKED-FROM](/id/grammar/meta/lineage/cherry-picked-from/) | Hash isi versi asal perubahan silsilah lain yang diambil (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/id/grammar/meta/lineage/reverts/) | Hash isi versi target yang perubahannya dibatalkan (git revert) |
| `0x36` | [REPLACES](/id/grammar/meta/lineage/replaces/) | Hash isi versi target yang ditulis ulang (git amend·rebase). Versi asal tidak dihapus. |
| `0x37` | [SQUASHED-FROM](/id/grammar/meta/lineage/squashed-from/) | Hash isi versi-versi asal yang digabung menjadi satu (git squash) |
| `0x38` | [MESSAGE](/id/grammar/meta/lineage/message/) | Alasan perubahan. Value UTF8-LANGUAGE-TEXT, satu per bahasa (git commit message) |
| `0x39` | [TAG](/id/grammar/meta/lineage/tag/) | Nama tetap yang diberikan pada versi. Value TEXT dan hash isi (git annotated tag) |
| `0x3A` | [DELTA-BASE](/id/grammar/meta/lineage/delta-base/) | File versi ini adalah diff terhadap versi dasar (ID versi 2 WORD) dokumen yang sama (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/id/grammar/meta/lineage/delta-remove/) | Daftar LOCAL ID (Edge Id) yang dikeluarkan dari BODY dasar pada diff |
| `0x3C` | [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/) | LOCAL ID yang dialokasikan berikutnya (auto increment). Ditaruh di HEAD daftar versi `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Verifikasi (`100`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x40` | [ISSUER-KEY](/id/grammar/meta/verification/issuer-key/) | Deklarasi ID algoritma tanda tangan dan kunci publik Issuer yang menerbitkan sendiri |
| `0x41` | [SIGNATURE](/id/grammar/meta/verification/signature/) | Tanda tangan atas target. Tanda tangan atas dokumen menandatangani hash isi (git signed commit·tag) |
| `0x42` | [SIGNED-OFF](/id/grammar/meta/verification/signed-off/) | Konfirmasi hak kontribusi. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/id/grammar/meta/verification/confidence/) | Tingkat kepercayaan |
| `0x44` | [VERDICT](/id/grammar/meta/verification/verdict/) | Hasil putusan seluruh dokumen. Pass, Review, Fail. Pada tingkat node·record adalah [TOULMIN](/id/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Kebijakan (`101`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x50` | [LICENSE](/id/grammar/meta/policy/license/) | Lisensi. Reference |
| `0x51` | [ACCESS](/id/grammar/meta/policy/access/) | Cakupan publikasi |
| `0x52` | [PRIVACY](/id/grammar/meta/policy/privacy/) | Tingkat data pribadi |
| `0x53` | [RETENTION](/id/grammar/meta/policy/retention/) | Batas retensi |
| `0x54` | [CONSENT](/id/grammar/meta/policy/consent/) | Cakupan dan dasar persetujuan |
| `0x55` | [USAGE](/id/grammar/meta/policy/usage/) | Batasan penggunaan |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x60` | [IMPORT-DOC](/id/grammar/meta/import/import-doc/) | Mengimpor dokumen eksternal dengan IMPORT ID. Reference tersemat `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
