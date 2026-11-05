---
title: "Alamat publikasi dan daftar versi"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL menunjuk dokumen bukan dengan string URL, melainkan dengan ID (Issuer, ID dokumen, ID versi)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL menunjuk dokumen bukan dengan string URL, melainkan dengan ID (Issuer, ID dokumen, ID versi). Alamat ditetapkan dari ID. Halaman ini menetapkan aturan publikasi yang diperlukan agar encoder, decoder, dan interpreter bekerja saling berkaitan. Tingkat Issuer dan cara membuka ditetapkan oleh [Issuer dan publikasi](issuer.md).

## Notasi ID {#id-표기}

ID yang dipakai dalam alamat ditulis dengan hex.

- Prefiks adalah `0x` huruf kecil. Hex ditulis dengan huruf besar A-F. Interpreter juga mencari alamat yang ditulis huruf kecil setelah mengubahnya ke huruf besar.
- Jumlah digit ditetapkan lebar × 4. Angka 0 di depan tidak dihilangkan, dan jumlah digit adalah lebarnya.
- Saat menulis alamat, Issuer ditulis dengan jumlah digit lebar penerbitan: 2 WORD 8 digit, 4 WORD 16 digit, 16 WORD 64 digit.
- Saat membaca, Issuer diterima dalam 8, 16, maupun 64 digit. Penulisan panjang dengan angka 0 di depan ID Issuer yang pendek dicari sebagai Issuer yang sama (`0x00000001` dan `0x0000000000000001` adalah Issuer yang sama, [Issuer dan publikasi](issuer.md#issuer-등급)).

| Objek | Lebar | Digit | Contoh |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 digit |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| ID dokumen | 4 WORD | 16 | `0x0000000000000000` |
| ID versi | 2 WORD | 8 | `0x00000003` |
| Hash isi | 16 WORD | 64 | `0x` + 64 digit |

- Codec ID kode langsung GEUL adalah nilai TAG WORD-nya (L=0) yang ditulis dalam 32 bit (TRIPLE `0x0AAL` → `0x00000AA0`). Karena Kind ada di dalam TAG, tidak tumpang tindih.
- Codec format ISSUER dari Issuer lain ditaruh di bawah `codecs/` Issuer itu dengan nomor Codec record. Contoh: CRC32C IETF adalah `0x00000007/codecs/0x0000C000/`.
- Codec ID codec Issuer adalah nomor Codec record (2 WORD). Issuer menetapkan nomor Codec agar tidak tumpang tindih di dalam `<Issuer>/codecs/` miliknya, terlepas dari Kind (Reference, Value, Edge). Alamat tidak dibagi menurut Kind (tidak ada folder seperti `references/`, `values/`, `edges/`).
- Interpreter menganggapnya galat jika Kind record berbeda dengan Kind target [DECLARE](edge/0x0BBL-declare.md) pada dokumen codec-nya.
- Publikasi menolak mengunggah codec lain ke Codec ID yang sama.
- Aturan ID versi (mulai dari 1, `0` adalah terbaru, ditetapkan penerbit, jika habis diganti ID dokumen baru) ditetapkan oleh [dokumen](document.md#버전).

## Alamat publikasi {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              daftar Issuer terbaru
/.well-known/geul/issuers/<ID versi>.geul                          daftar Issuer, versi ditentukan
/.well-known/geul/issuers/versions.geul                            daftar versi dari daftar Issuer
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           codec terbaru
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID versi>.geul       codec, versi ditentukan
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         daftar versi codec
/.well-known/geul/<Issuer>/docs/<ID dokumen>/latest.geul           dokumen terbaru
/.well-known/geul/<Issuer>/docs/<ID dokumen>/<ID versi>.geul       dokumen, versi ditentukan
/.well-known/geul/<Issuer>/docs/<ID dokumen>/versions.geul         daftar versi dokumen
/.well-known/geul/<Issuer>/hashes/<hash isi>.geul                  pencarian dengan hash isi
```

Contoh: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- Jalur mengikuti `.well-known` RFC 8615. geul.org dan publikasi privat memakai jalur yang sama dan hanya domainnya berbeda. Sufiks yang didaftarkan hanya satu, `geul`.
- Daftar Issuer adalah `issuers/`. Codec, dokumen umum, dan hash terbagi di bawah folder Issuer menjadi `codecs/<Codec ID>/`, `docs/<ID dokumen>/`, `hashes/`. Daftar Issuer juga dimulai dari versi 1 dan memiliki `versions.geul` ([dokumen daftar](#목록-문서)).
- `latest.geul` adalah kata cadangan dan alias. Tidak disimpan. Mencari versi terbaru dari `versions.geul` di tempat yang sama dan mengeluarkan byte versi itu apa adanya. Tidak dialihkan (redirect). Semua `latest.geul` daftar Issuer, codec, dan dokumen sama.
- Alamat kanonis satu versi adalah `/<Issuer>/docs/<ID dokumen>/<ID versi>.geul`. Untuk codec, `/<Issuer>/codecs/<Codec ID>/<ID versi>.geul`. Alamat lain yang memberikan isi yang sama menunjuk alamat kanonis dengan `Link: rel=canonical`.
- Alamat dengan versi ditentukan dan alamat hash isi tidak dapat diubah. Alamat yang tidak dapat diubah dapat ditaruh di cache permanen dan CDN. Pihak penerima memverifikasi dengan hash isi dari daftar versi (atau catatan kunci).
- Untuk mencari dengan hash isi, Issuer harus diketahui. Tidak ada pencarian global hanya dengan hash.
- Dokumen codec tidak memiliki ID dokumen. Menunjuk dirinya dan versinya dengan [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID versi).
- ID selalu dimulai dengan `0x`. Karena itu nama cadangan (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) atau nama yang diberikan manusia tidak tumpang tindih dengan ID, meski kata yang seluruhnya hex seperti `add`, `cafe`.
- Lokasi (dari server mana diterima) tidak dimasukkan ke isi dokumen. Jika dimasukkan, hash isi berubah saat alamat berubah. Lokasi ditetapkan oleh pengaturan pihak yang menerima dokumen.

### Bentuk publikasi dan pencarian {#공표-형태와-조회}

- Alamat adalah alamat logis. Penerbit dapat mengeluarkan berkas individual atau pack, dan jika pack, tidak dapat diterima langsung dengan URL alamat dan dibaca dengan interpreter GEUL.
- Baik disimpan dalam bentuk berkas individual, pack, maupun pack zstd, dicari dengan alamat yang sama. Alamat di luar 10 bentuk di atas dan alamat yang tidak ada adalah 404 (tidak ada).

Alat baris perintah `geul` ([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <alamat>     mengeluarkan biner dokumen GEUL murni ke keluaran standar
geul show <alamat>    menampilkan dokumen sebagai teks
```

- `geul get` menerima alamat `file://`, `https://`. Alamat di luar 10 bentuk dan alamat yang tidak ada berakhir dengan 404 (tidak ada).

`pkg/resolve` pada pustaka Go gogeul memiliki fungsi pencarian per alamat. Semuanya mengembalikan biner GEUL murni (`[]byte`). ID versi dimulai dari 1, sehingga `Latest` (0) adalah terbaru. Alamat yang tidak ada adalah galat tidak ada (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // bentuk selain 10 adalah 404 (tidak ada)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → keluaran standar
```

### Penetapan format {#형식-지정}

- Alamat publikasi berakhir dengan `.geul` dan berupa biner (`application/vnd.geul`).
- Biner adalah bentuk kanonis dokumen. Hash isi dan tanda tangan dihitung hanya dari biner.

### Dokumen daftar {#목록-문서}

Dokumen daftar hanya satu, daftar Issuer `issuers/`. Mengikat Issuer dan domain ([daftar Issuer](#issuer-목록)). Dimulai dari versi 1 dan memiliki `versions.geul`. ID dokumen daftar adalah ID dokumen cadangan `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Setiap Issuer mencadangkan ID dokumen `0x0000000000000000` dan `0xFFFFFFFFFFFFFFFF` ([Issuer dan publikasi](issuer.md#용어-정의-문서)).

- `latest.geul` adalah alias yang tidak disimpan. Mencari versi terbaru dari `versions.geul` dan mengeluarkan byte-nya.
- PUBLICATION·DEPRECATION·TOMBSTONE pada `issuers/versions.geul` menunjuk versi daftar dengan DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID versi). Karena itu, meski diterima dengan `hashes/`, diketahui daftar dari apa ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- ID dokumen `0xFFFFFFFFFFFFFFFF` tidak diterima di Issuer mana pun dengan alamat `<Issuer>/docs/<ID dokumen>/` (404). ID dokumen cadangan lain `0x0000000000000000` adalah dokumen indeks definisi istilah Issuer itu dan ditaruh di bawah `docs/` ([Issuer dan publikasi](issuer.md#용어-정의-문서)).
- `DOC-ID` tidak diletakkan di dokumen daftar. Daftar dari apa dikatakan oleh DOC-POINTER pada record ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Dokumen dan codec langsung dicari dengan ID yang dihitung dari record tanpa daftar ([nama dokumen](#문서-이름)).

### Nama domain {#도메인-이름}

Nama domain bukan alamat URL publikasi. Alamat yang menulis domain di posisi `<Issuer>` atau menulis nama di posisi ID berada di luar 10 bentuk di atas sehingga 404 (tidak ada). Tidak ada pula pengalihan dari nama ke alamat ID.

- Nama domain adalah input interpreter dan CLI. Interpreter mengubah domain menjadi ID Issuer dengan BIND di daftar Issuer `issuers/`. ID hasil perubahan dicatat di catatan kunci. Tidak ada alamat nama dokumen ([nama dokumen](#문서-이름)).
- Alamat kanonis, kunci cache, dan objek tanda tangan adalah alamat ID.
- Domain ditulis huruf kecil, dan domain internasional ditulis dalam bentuk IDNA (punycode). Tidak ditambahkan `.` di akhir.
- Issuer 16 WORD yang tidak memiliki register dan lingkungan terisolasi yang tidak dapat menjangkau geul.org tidak dapat memakai nama domain. Pakai ID.

### Daftar Issuer {#issuer-목록}

Daftar Issuer adalah dokumen di bawah `/.well-known/geul/issuers/` (yang terbaru adalah `issuers/latest.geul`). Mengikat Issuer dan namanya (domain).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nama = "geul.org"
  …
```

- Subject adalah [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (Issuer itu sendiri) dan nama diikat dengan [BIND](edge/0x0A3L-bind.md).
- Nama adalah domain yang telah melalui bukti kepemilikan domain. Huruf kecil, dan domain internasional ditulis dengan IDNA (punycode). Satu nama hanya terikat pada satu Issuer.
- Nama tampilan Issuer yang dibaca manusia (per bahasa) dilekatkan pada Subject yang sama sebagai pernyataan [LABEL](edge/0x0A4L-label.md).
- Ditandatangani geul.org (Issuer GEUL), dan jika berubah ditambahkan, tidak diperbaiki (aturan rantai yang sama dengan daftar versi).

### Nama dokumen {#문서-이름}

**Tidak ada alamat nama dokumen.** Dokumen dan codec dicari dengan ID.

- Tidak dibuat indeks yang mengubah nama dokumen·nama codec menjadi ID. Di daftar versi juga tidak diletakkan [BIND](edge/0x0A3L-bind.md) nama dokumen ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- Indeks yang dijelajahi manusia dibuat alat (viewer) dari inventaris pack.
- Alamat kanonis, kunci cache, dan objek tanda tangan adalah alamat ID. IMPORT dan kutipan dalam dokumen hanya dengan ID.
- Judul yang dibaca manusia (per bahasa) dilekatkan sebagai pernyataan [LABEL](edge/0x0A4L-label.md).

### Dokumen yang dihapus {#삭제된-문서}

- Alamat versi yang dibatalkan dengan penghapusan hukum·penghapusan oleh otoritas (TOMBSTONE) juga 404 (tidak ada) seperti alamat lain yang tidak ada.
- Versi yang dianjurkan dihentikan penggunaannya (DEPRECATION) bukan 404. Tetap dikeluarkan dengan alamat versi itu.
- Penghapusan tercatat di daftar versi sebagai record [TOMBSTONE](edge/0x0BAL-tombstone.md) (DOC-POINTER versi itu, kategori alasan).

## Lapisan {#층}

GEUL menyatakan hingga asal-usul, meta, dan daftar sebagai dokumen GEUL. Minimum yang diperlukan untuk membacanya tertanam di decoder untuk memutus sirkularitas. Setiap lapisan hanya bersandar pada lapisan di bawahnya.

| Lapisan | Isi | Bersandar pada |
|---|---|---|
| Lapisan 0 | Aturan tertanam decoder: framing, hash isi, verifikasi tanda tangan, Codec record daftar versi (`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), kosakata spesifikasi Codec (`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [penanda slot](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), kunci kepercayaan yang diterima dari luar dokumen | Tidak ada. Tidak melakukan pencarian |
| Lapisan 1 | Dokumen daftar versi | Lapisan 0 |
| Lapisan 2 | Dokumen umum, codebook, dokumen spesifikasi Codec, dokumen kunci verifikasi Issuer | Dicari dengan lapisan 1 dan diverifikasi dengan lapisan 0 |

- Lapisan mana pun tidak bersandar pada lapisannya sendiri atau lapisan di atasnya.
- Dibedakan antara yang dinyatakan dengan GEUL dan yang hanya terbaca jika ditafsirkan dengan GEUL. Lapisan 0 dapat dinyatakan dengan GEUL, tetapi penafsirannya tidak memerlukan pencarian.
- Inti tetap yang tidak dapat diubah menjadi dokumen TOULMIN, seperti arti penilaian, juga ditaruh di tempat ini ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Daftar versi {#버전-목록}

Penerbit menyambung satu dokumen daftar versi untuk setiap dokumen (`/<Issuer>/docs/<ID dokumen>/versions.geul`, codec adalah `/<Issuer>/codecs/<Codec ID>/versions.geul`, daftar Issuer adalah `issuers/versions.geul`). Format record dan struktur dokumen ditetapkan oleh [PUBLICATION](edge/0x0B8L-publication.md).

```
DOC-*
  SPEC-VERSION
  PARENT          hash isi daftar versi sebelumnya
  RECORDED-AT     waktu daftar ini dikeluarkan
  NEXT-LOCAL-ID   LOCAL ID yang akan ditetapkan berikutnya
  SIGNATURE       tanda tangan penerbit
BODY
  PUBLICATION     #1  dokumen@1  hash isi
  PUBLICATION     #2  dokumen@2  hash isi
  DEPRECATION     #3  dokumen@1
  …
END
```

| Edge | Arti |
|---|---|
| PUBLICATION | Menerbitkan satu versi dokumen dan hash isinya |
| DEPRECATION | Menandai anjuran penghentian penggunaan pada versi yang diterbitkan. Tetap ditafsirkan |
| TOMBSTONE | Menghapus versi yang diterbitkan (penghapusan hukum·oleh otoritas). Menulis kategori alasan |

- Record hanya ditambah. Tidak diperbaiki, dihapus, atau diubah urutannya. Deprecate·penghapusan juga menambahkan record. Daftar baru menaruh BODY daftar sebelumnya apa adanya di depan dan menambahkan record, dan daftar-daftar terhubung dengan rantai hash `PARENT`.
- Artinya catatan publikasi tidak diperbaiki, dan berbeda dengan revisi isi dokumen ([dokumen](document.md#개정)). Keadaan versi saat ini dihitung dengan menerapkan record secara berurutan.
- ID versi naik secara berurutan dari 1 tanpa celah. Isi yang sama tidak diterbitkan ulang.
- Versi terbaru adalah versi tertinggi yang bukan anjuran penghentian maupun penghapusan.
- Waktu tidak dimasukkan ke record. `RECORDED-AT` dari daftar yang pertama kali memuat record itu adalah waktu publikasi.
- `DOC-ID` tidak diletakkan di daftar versi. DOC-POINTER pada record (ID dokumen, daftar Issuer adalah ID dokumen cadangan) mengatakan daftar dari apa.
- Daftar versi tidak meletakkan IMPORT, dan hanya memakai Codec lapisan 0. Di BODY hanya diletakkan PUBLICATION·DEPRECATION·TOMBSTONE.
- Daftar versi lama hanya ditunjuk dengan hash isi (`<Issuer>/hashes/<hash isi>.geul`), dan riwayat dihubungkan dengan rantai `PARENT`.
- Alamat yang dapat berubah adalah `latest.geul` dan `versions.geul`. Penunjuk yang dapat berubah tidak dapat dibuat menjadi dokumen, sehingga diverifikasi dengan tanda tangan, `RECORDED-AT`, dan `PARENT` dari daftar yang diterima.

### Penanda tangan {#서명-주체}

| Tanda tangan | Penanda tangan | Objek |
|---|---|---|
| Tanda tangan dokumen | Issuer dokumen itu | Hash isi dokumen ([Issuer dan publikasi](issuer.md#서명)) |
| Tanda tangan daftar | Penerbit yang menetapkan ID versi | Hash isi daftar versi |

- Pada publikasi geul.org, geul.org (Issuer GEUL) yang menetapkan ID versi dan menandatangani daftar. Pada publikasi privat, Issuer itu yang melakukannya.
- Penulis bertanggung jawab atas isi, penerbit bertanggung jawab atas nomor dan urutan.

### Verifikasi {#검증}

- Tanda tangan dikeluarkan dari hash isi sehingga hash tetap sama meski dihapus. Karena itu verifikasi bukan “jika ada tanda tangan, diperiksa”, melainkan “harus ada tanda tangan dengan kunci yang ditetapkan”. Kunci yang diminta ditetapkan oleh pengaturan kepercayaan interpreter dan catatan kunci.
- Interpreter mencatat hash isi daftar yang terakhir dilihat di catatan kunci. Jika hash itu tidak ada dalam rantai `PARENT` daftar yang baru diterima, ditolak (mencegah pemutaran mundur·percabangan).
- Mirror dan lingkungan terisolasi menyalin rantai daftar versi bersama-sama. Jika ada kunci publik, dapat diverifikasi secara luring.
- Dokumen yang diterima, dari sumber mana pun, diverifikasi dengan hash isi. Sumber tidak perlu dipercaya.

## Penyelesaian dependensi {#의존성-해석}

- Dokumen menulis dokumen dependensi dengan [IMPORT-DOC](meta/0x1E4L-import-doc.md) pada HEAD.
- Versi baru tidak menjanjikan kompatibilitas dengan versi sebelumnya. Karena itu versi satu dokumen tidak disatukan di seluruh graf (pemilihan versi minimum tidak dipakai).
- Setiap `IMPORT-DOC` terikat pada edisi yang dikuncinya. Beberapa edisi dari dokumen yang sama dapat ada bersama dalam satu graf (putusan yang mengutip undang-undang lama dan putusan yang mengutip undang-undang yang berlaku saat ini). Rujukan diselesaikan dengan (dokumen, versi, LOCAL ID).
- Impor terbaru (versi `0`) terikat pada edisi terbaru pada saat penafsiran. Jika penafsiran dilakukan dengan menentukan waktu, terikat pada edisi yang berlaku pada waktu itu ([dokumen](document.md#개정)).
- Impor yang dikunci dengan ID versi dapat direproduksi (isi ID versi tidak dapat diubah dan diverifikasi dengan catatan kunci).

## Tipe media {#미디어-타입}

- Tipe media dokumen GEUL adalah `application/vnd.geul`. Ekstensinya `.geul`.
- Meski dipindahkan ke pohon standar `application/geul`, `application/vnd.geul` tetap diterima.

## Masalah terbuka {#열린-문제}

- Penanganan ketika ID versi bercabang pada publikasi privat·Issuer 16 WORD·lingkungan terisolasi (ID versi sama, isi berbeda).
- Susunan HEAD daftar Issuer `issuers/` serta format tanda tangan·rantai. Aturan nama Issuer tanpa domain (4 WORD), penanganan sengketa nama, dan batas panjang.
- Waktu dan format peralihan dari seluruh rantai ke log Merkle (bukti inklusi·konsistensi) saat daftar membesar.
- Meta yang menulis Issuer penyedia lokasi di HEAD.
