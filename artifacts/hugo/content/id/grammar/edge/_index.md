---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge adalah record yang mengikat Reference·Value·Edge lain untuk menyatakan sesuatu. Komponen pertamanya selalu Edge Id, dan 2 bit atas Codec adalah keluarganya (pernyataan, dasar, eksekusi, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge adalah record yang mengikat record lain sebagai komponen untuk menyatakan sesuatu. Pernyataan seperti "Q42 adalah manusia" atau "nama Inggris Q42 adalah Douglas Adams" adalah satu Edge.

## Layout

```
TAG WORD          0001 0LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  jika format Issuer
Edge Id           record LOCAL Reference
Komponen          urutan yang ditetapkan Codec
```

- `LLLL` adalah jumlah WORD total termasuk TAG WORD dikurangi 1. Decoder melompat ke record berikutnya hanya dengan Length tanpa perlu mengetahui Codec.
- **Komponen pertama selalu Edge Id (LOCAL Reference).** Karena berupa LOCAL Reference (`0088` + ID, Quantifier `000`), Edge Id dapat dibaca tanpa mengetahui codec.
- Setiap komponen menemukan batasnya dengan Length-nya sendiri. Posisi setelah membaca komponen terakhir harus tepat sama dengan akhir Edge.
- Susunan komponen (Payload) ditetapkan oleh dokumen Codec Edge masing-masing.
- Pada Codec yang memiliki sub-format (WORLD, TIMELINE, SCENE), 1 WORD TAG per Codec menetapkan sub-format.
- Urutan antar record Edge tidak bermakna (kecuali jika Codec menetapkan lain. Contoh: dokumen [TOULMIN](/id/grammar/edge/toulmin/)).
- Edge lain ditunjuk dengan Edge Id. Edge dokumen ini ditunjuk dengan LOCAL, Edge dokumen lain dengan Reference penunjuk (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Keluarga

| 2 bit atas | Keluarga | Kode langsung | Fungsi |
|---|---|---|---|
| `00` | Pernyataan | `0x00`~`0x1F` | Menyusun isi tentang dunia dan peristiwa |
| `01` | Dasar | `0x20`~`0x3F` | Dari mana record dan dokumen berasal ([SOURCE](/id/grammar/edge/source/)) |
| `10` | Eksekusi | `0x40`~`0x5F` | Struktur program yang dapat dieksekusi (AST) |
| `11` | [TOULMIN](/id/grammar/edge/toulmin/) | `0x60`~`0x7B` | Graf argumen: klaim·sanggahan·pengecualian, relasi serangan, eksekusi, hasil putusan |

## Edge pernyataan

| Codec | Nama | Komponen |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/id/grammar/edge/reference-node/) | Pengikatan berarah bahwa Subject (Reference) menunjuk Object |
| `0x01` | [SAME-NODE](/id/grammar/edge/same-node/) | Dua Reference menunjuk target yang sama |
| `0x02` | [DIFFERENT-NODE](/id/grammar/edge/different-node/) | Dua Reference menunjuk target yang berbeda |
| `0x03` | [BIND](/id/grammar/edge/bind/) | Mengikat nama untuk mesin (UTF8-TEXT) pada Subject |
| `0x04` | [LABEL](/id/grammar/edge/label/) | Nama Subject per bahasa (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/id/grammar/edge/alias/) | Nama lain Subject. Layout sama dengan LABEL |
| `0x06` | [DESCRIPTION](/id/grammar/edge/description/) | Deskripsi Subject per bahasa. Layout sama dengan LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Pernyataan verba |
| `0x0A` | [TRIPLE](/id/grammar/edge/triple/) | Satu proposisi (Predicate, Subject, Object) dan rank |
| `0x0B` | [QUALIFIER](/id/grammar/edge/qualifier/) | Satu syarat yang membatasi proposisi Edge lain |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Pandangan dunia, urutan peristiwa, struktur adegan |
| `0x18`~`0x1A` | [PUBLICATION](/id/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Publikasi·anjuran penghentian·penghapusan versi dokumen ([alamat publikasi dan daftar versi](/id/grammar/publishing/#daftar-versi)) |
| `0x1B`~`0x1E` | [DECLARE](/id/grammar/edge/declare/) / [FIELD](/id/grammar/edge/field/) / [ENUM](/id/grammar/edge/enum/) / [CODEC](/id/grammar/edge/codec/) | Kosakata untuk menulis spesifikasi Codec ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)) |

- `-SHORT` dan bentuk biasa dipasangkan sebagai genap·ganjil (VERB-SHORT `0x08`/VERB `0x09`). LABEL menerima bahasa sebagai record bahasa di dalam Object (UTF8-LANGUAGE-TEXT), sehingga hanya `0x04` yang dipakai.
- PUBLICATION·DEPRECATION·TOMBSTONE ditulis dokumen daftar versi. Karena daftar versi harus dapat dibaca tanpa codebook, ketiganya ditanamkan di decoder (lapisan 0 pada [alamat publikasi dan daftar versi](/id/grammar/publishing/#lapisan)).
- DECLARE·FIELD·ENUM·CODEC adalah kosakata untuk menulis spesifikasi Codec. Karena dokumen spesifikasi harus dapat dibaca tanpa codebook, layoutnya ditanamkan di decoder (lapisan 0). Setiap dokumen spesifikasi Codec yang ditulis dengan kosakata itu adalah dokumen biasa.

### TRIPLE

Rinci: [TRIPLE](/id/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (properti Wikidata, dan lain-lain)
Subject           Reference
Object            Reference atau Value
Rank              1 WORD
```

| Rank | Nama | Arti |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | Nilai saat ini, nilai paling berotoritas |
| `2` | deprecated | Nilai yang dinilai salah atau usang tetapi dicatat |

- Rank sama dengan statement rank Wikidata. Sumber yang tidak memberi rank memakai `0`.
- **Makna TRIPLE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya.** Pihak pembaca mengumpulkan QUALIFIER sebelum menginterpretasikan TRIPLE.

Contoh: Q42 — P31 (instance of) — Q5 (manusia), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Rinci: [QUALIFIER](/id/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id Edge yang dibatasi)
Value             Reference atau Value
```

- QUALIFIER adalah bagian dari proposisi. Ia bukan klaim terpisah tentang proposisi, melainkan membatasi syarat agar proposisi benar (waktu mulai·berakhir, cakupan penerapan, dan lain-lain).
- Klaim terpisah tentang proposisi (siapa yang mengklaim, dan sebagainya) ditulis dengan TRIPLE.
- Target adalah Edge dalam dokumen yang sama. Urutan QUALIFIER dengan Target yang sama adalah urutan dalam dokumen.

Contoh: Q42 — P69 (educated at) — Q691283, mulai (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Rinci: [LABEL](/id/grammar/edge/label/), [ALIAS](/id/grammar/edge/alias/), [DESCRIPTION](/id/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Nama dan bahasa dimuat dalam satu Object (UTF8-LANGUAGE-TEXT).
- LABEL dengan Subject dan bahasa yang sama paling banyak satu. Nama lain ditulis dengan ALIAS.
- Nama untuk mesin tanpa bahasa ditulis dengan BIND. LABEL harus memiliki bahasa.

### BIND

Rinci: [BIND](/id/grammar/edge/bind/)

- Mengikat nama yang dicocokkan mesin (UTF8-TEXT) pada Subject. Tanpa bahasa dan tidak dinormalisasi. Nama dianggap sama hanya jika byte-nya sama.
- Cakupan nama adalah dokumen yang memuat BIND. Dalam satu dokumen, nama yang sama tidak diikat pada Subject yang berbeda.
- Record lain menunjuk dengan LOCAL ID, bukan nama. Nama dipakai untuk mencocokkan dengan pihak luar (fungsi host, input alamat, manusia).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Rinci: [SAME-NODE](/id/grammar/edge/same-node/), [DIFFERENT-NODE](/id/grammar/edge/different-node/), [REFERENCE-NODE](/id/grammar/edge/reference-node/)

- SAME-NODE adalah identitas bahwa dua Reference menunjuk target yang sama. Bersifat refleksif·simetris·transitif.
- DIFFERENT-NODE adalah non-identitas bahwa dua Reference adalah target yang berbeda.
- REFERENCE-NODE adalah pengikatan berarah yang mendefinisikan apa Subject (Reference) itu dengan Object. Ini bukan klaim identitas. Contoh: mendefinisikan URI yang ditunjuk node LOCAL.

## Edge dasar

Menempelkan dasar pada setiap record di BODY, atau pada seluruh dokumen (HEAD). Kode langsung keluarga dasar hanya satu: [SOURCE](/id/grammar/edge/source/) (`0x20`).

| Codec | Nama | Komponen |
|---|---|---|
| `0x20` | [SOURCE](/id/grammar/edge/source/) | Target (Edge Id Edge BODY yang diberi dasar; di HEAD `0` = seluruh dokumen), Origin (Reference sumber, ABSENT atau UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- Sifat sumber itu sendiri (URL, judul, penulis, tanggal terbit …) ditulis dengan TRIPLE yang Subject-nya sumber, dan sifat kutipan (tanggal akses, posisi di dalam sumber …) ditulis dengan QUALIFIER yang Target-nya Edge Id SOURCE.
- Sumber seluruh dokumen ditulis di HEAD sebagai SOURCE dengan Target `0`, dan QUALIFIER yang Target-nya SOURCE itu juga ditaruh di HEAD. Edge yang boleh ada di HEAD hanya dua ini, dan Edge Id memakai satu ruang nomor bersama HEAD dan BODY ([sumber seluruh dokumen](/id/grammar/edge/source/#sumber-seluruh-dokumen)).
- Dasar lain (rentang teks asli, pelaku pembuat, tingkat kepercayaan, masa berlaku per pasal, record lama) ditulis dengan QUALIFIER, dan versi tempat pertama kali masuk dihitung dari riwayat versi ([SOURCE](/id/grammar/edge/source/#ungkapan-dasar-lain)).
- Hasil putusan pada tingkat record ditangani TOULMIN `VERDICT`.

### SOURCE

Rinci: [SOURCE](/id/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id Edge BODY yang diberi dasar; di HEAD 0 = seluruh dokumen)
Origin            Reference atau penanda slot 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

Contoh: sumber TRIPLE Q42 P19 `#178` adalah Encyclopaedia Britannica (Q5375741), dan P1417 adalah pengenal di dalamnya

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge eksekusi

Struktur program yang tidak terikat pada bahasa pemrograman tertentu. Komponennya ditunjuk dengan LOCAL ID dokumen ini.

| Kelompok | Codec |
|---|---|
| Deklarasi | FUNCTION-DECLARE, TYPE-DECLARE |
| Ekspresi | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Pernyataan | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Kesalahan | RAISE, TRY |

- Ini bukan format yang memuat kode bahasa eksternal apa adanya. Kode bahasa eksternal ditaruh dalam format Issuer.
- Komponen ditunjuk dengan LOCAL ID dokumen ini (REF). Pada posisi ekspresi ditaruh Edge ekspresi atau simbol. REF `0` berarti tidak ada.
- Ekspresi menghasilkan nilai, pernyataan tidak. Ekspresi dapat ditaruh pada posisi pernyataan BLOCK (nilainya dibuang).
- `for` gaya C ditulis dengan BLOCK (inisialisasi, WHILE), dan `else if` dengan IF pada posisi salah.
- Simbol adalah LOCAL ID, dan namanya diikat dengan BIND. Record lain menunjuk simbol dengan LOCAL ID, bukan nama. Walaupun namanya sama, jika LOCAL ID berbeda maka simbolnya berbeda.
- Apa simbol itu (variabel, parameter, fungsi, tipe) ditetapkan oleh record yang menunjuk simbol itu. Simbol yang tidak memiliki definisi di dalam dokumen disediakan pihak luar (host), dan jika menjadi target CALL maka itu adalah fungsi host.

Masalah terbuka: kode operator, representasi tipe, layout Payload setiap Codec.

## Edge TOULMIN

Rinci: [TOULMIN](/id/grammar/edge/toulmin/)

Menulis graf putusan·eksekusi dengan model argumen Toulmin. Ini adalah keluarga inti agar GEUL dapat menyatakan aturannya sendiri dengan GEUL dan memperbaikinya sendiri.

| Kelompok | Codec |
|---|---|
| Deklarasi | CASE-DECLARE (kasus), [PREDICATE-DECLARE](/id/grammar/edge/toulmin/expr/) (predikat), SPEC-DECLARE (kriteria penilaian), RULE-DECLARE (klaim), COUNTER-DECLARE (sanggahan), EXCEPT-DECLARE (pengecualian) — [NODE](/id/grammar/edge/toulmin/node/) |
| Relasi | ATTACKS (serangan), SUPERSEDES (pengesampingan) — [LINK](/id/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (rantai prioritas, layout belum ditetapkan) |
| Eksekusi | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/id/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/id/grammar/edge/toulmin/node/) |
| Hasil | VERDICT (hasil putusan: Pass·Review·Fail), EVIDENCE (bukti putusan) — layout belum ditetapkan |

- Teks asli·bagian·node bantu dan relasinya adalah format ISSUER Issuer GEUL (`0xC000`~`0xC029`) ([SOURCE dan bagian](/id/grammar/edge/toulmin/source/)).
- Hasil putusan ditaruh di dokumen yang berbeda dari objek putusan. Dokumen hasil mengimpor dokumen objek dan menunjuknya. Karena itu hash isi dokumen objek tidak berubah walaupun diputuskan.

## Edge format Issuer

Issuer dapat mendefinisikan format Edge sendiri (Codec `0x7C`~`0x7F`). Kode langsung `0x7C`~`0x7F` berada di dalam rentang TOULMIN tetapi merupakan kode ISSUER bersama, dan keluarganya ditentukan oleh 2 bit atas nomor format.

| Issuer | Nomor format | Nama | Keluarga |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/id/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/id/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/id/grammar/edge/toulmin/link/) | TOULMIN |
