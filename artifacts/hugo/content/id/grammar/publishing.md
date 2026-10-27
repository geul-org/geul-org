---
title: "Alamat publikasi dan daftar versi"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Dokumen GEUL yang diterbitkan dilayani pada alamat tetap yang ditentukan dari ID (Issuer, ID dokumen, ID versi), dan diverifikasi dengan daftar versi yang ditandatangani penerbit. Halaman ini menetapkan notasi ID, alamat, penetapan format, indeks nama, daftar versi, dan lapisan kepercayaan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL menunjuk dokumen bukan dengan string URL melainkan dengan ID (Issuer, ID dokumen, ID versi). Alamat ditentukan dari ID. Halaman ini menetapkan aturan publikasi yang diperlukan agar encoder·decoder·penerjemah saling bertaut. Tingkat Issuer dan cara publikasi ditetapkan oleh [Issuer dan publikasi](/id/grammar/issuer/).

## Notasi ID

ID yang dipakai pada alamat ditulis dengan hex.

- Awalan adalah `0x` huruf kecil, dan digit hex juga huruf kecil.
- Jumlah digit tetap lebar × 4. Nol di depan tidak dihilangkan, dan jumlah digit adalah lebar itu sendiri.
- Issuer ID ditulis dengan lebar terpendek tempat nilainya muat. Tidak ada notasi yang diperlebar seperti `0x00000005` (`0x0005`).

| Objek | Lebar | Jumlah digit | Contoh |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 digit |
| ID dokumen | 4 WORD | 16 | `0x0000000000000000` |
| ID versi | 2 WORD | 8 | `0x00000003` |
| Hash isi | 16 WORD | 64 | `0x` + 64 digit |

- Permintaan yang bukan bentuk kanonik (`0X`, huruf besar, nol dihilangkan) dialihkan `301` ke alamat kanonik. Kunci cache dan objek tanda tangan ditentukan secara tunggal.
- Aturan ID versi (mulai dari 1, `0` adalah yang terbaru, dialokasikan penerbit, ID dokumen baru jika habis) ditetapkan oleh [Dokumen](/id/grammar/document/#versi).

## Alamat publikasi

```
/.well-known/geul/<Issuer>/<ID dokumen>.geul              Versi terbaru. Dikirim ke alamat kanonik dengan 302 (berubah)
/.well-known/geul/<Issuer>/<ID dokumen>/<ID versi>.geul   Satu salinan dokumen (tetap, alamat kanonik)
/.well-known/geul/<Issuer>/<ID dokumen>/versions.geul     Dokumen daftar versi (berubah, ditandatangani)
/.well-known/geul/h/<hash isi>.geul                       Pencarian dengan hash isi (tetap)
```

Contoh: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- Path mengikuti `.well-known` RFC 8615. Publikasi geul.org dan publikasi pribadi memakai path yang sama dan hanya domainnya berbeda. Sufiks yang didaftarkan hanya satu, `geul`.
- Isi dokumen hanya keluar dari alamat tetap. Alamat versi terbaru tidak memberi isi dan mengirim ke alamat kanonik versi itu dengan `302`.
- Alamat kanonik satu versi adalah `/<Issuer>/<ID dokumen>/<ID versi>.geul`. Alamat lain yang memberi isi yang sama menunjuk alamat kanonik dengan `Link: rel=canonical`.
- Alamat tetap dapat ditaruh di cache permanen dan CDN. Pihak penerima memverifikasi dengan hash isi pada daftar versi (atau catatan kunci).
- ID selalu diawali `0x`. Karena itu nama cadangan (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) atau nama yang diberikan manusia tidak bertabrakan dengan ID walaupun berupa kata hex saja seperti `add`, `cafe`.
- Lokasi (dari server mana diterima) tidak dimasukkan ke dalam isi dokumen. Jika dimasukkan, hash isi berubah saat alamat berubah. Lokasi ditentukan oleh konfigurasi pihak yang menerima dokumen.

### Penetapan format

- Jika ada ekstensi, format ditetapkan. `.geul` adalah biner (`application/vnd.geul`).
- Jika tidak ada ekstensi, mengikuti header `Accept`. Browser diberi tampilan HTML, dan alat diberi biner. Contoh: `/<Issuer>/<ID dokumen>/<ID versi>`
- Biner adalah bentuk kanonik dokumen. Hash isi dan tanda tangan dihitung hanya dari biner.

### Nama domain

Issuer yang telah melalui bukti kepemilikan domain dapat memakai domain itu sebagai pengganti ID pada posisi `<Issuer>` alamat.

```
/.well-known/geul/<domain>/<ID dokumen>.geul              → 302 → /<Issuer>/<ID dokumen>.geul
/.well-known/geul/<domain>/<ID dokumen>/<ID versi>.geul   → 302 → /<Issuer>/<ID dokumen>/<ID versi>.geul
/.well-known/geul/<domain>/<ID dokumen>/                  → 302 → /<Issuer>/<ID dokumen>/
```

Contoh: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- Alamat domain tidak memberi isi dan mengirim ke alamat ID dengan `302`. Alamat kanonik, kunci cache, dan objek tanda tangan adalah alamat ID. Karena padanan dapat berubah, pengalihan permanen tidak dipakai.
- Domain ditulis huruf kecil, dan domain internasional ditulis dalam bentuk IDNA (punycode). `.` di akhir tidak ditambahkan. Jika bukan bentuk kanonik, dialihkan `301` ke bentuk kanonik.
- Domain memiliki `.` sehingga tidak bertabrakan dengan ID yang diawali `0x` atau nama cadangan.
- Penerjemah yang menerima alamat domain memeriksa padanan dengan indeks nama Issuer, mengubahnya menjadi ID, dan mencatatnya di catatan kunci.
- Issuer 16 WORD yang tidak memiliki registri dan lingkungan terisolasi jaringan yang tidak dapat menjangkau geul.org tidak dapat memakai nama domain. Pakai alamat ID.

### Nama Issuer

Indeks nama Issuer adalah satu dokumen `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   Nama = "geul.org"
  …
```

- Subject adalah [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/) (Issuer itu sendiri) dan nama diikat dengan [BIND](/id/grammar/edge/bind/).
- Nama adalah domain yang telah melalui bukti kepemilikan domain. Huruf kecil, dan domain internasional ditulis dengan IDNA (punycode). Satu nama hanya diikat pada satu Issuer.
- Nama tampilan Issuer yang dibaca manusia (per bahasa) ditempelkan pada Subject yang sama dengan [LABEL](/id/grammar/edge/label/) pernyataan.
- Ditandatangani geul.org (Issuer GEUL), dan jika berubah ditambahkan, tidak diperbaiki (aturan rantai yang sama dengan daftar versi).
- Nama cadangan `issuers.geul` memiliki `.` sehingga berbentuk domain. Walaupun muncul domain dengan nama yang sama, path ini tetap menjadi indeks nama Issuer.

### Nama dokumen

Alamat juga dapat memakai nama dokumen sebagai pengganti ID dokumen. Pada posisi `<Issuer>` dipakai ID atau nama domain.

```
/.well-known/geul/<Issuer|domain>/<nama dokumen>.geul              → 302 → /<Issuer>/<ID dokumen>.geul
/.well-known/geul/<Issuer|domain>/<nama dokumen>/<ID versi>.geul   → 302 → /<Issuer>/<ID dokumen>/<ID versi>.geul
/.well-known/geul/<Issuer|domain>/<nama dokumen>/                  → 302 → /<Issuer>/<ID dokumen>/
```

Contoh: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**Nama dokumen diikat dengan BIND oleh indeks nama Issuer `/<Issuer>/documents.geul`.** Penerjemah memadankan nama ke ID dokumen dengan indeks ini.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, ID dokumen, versi 0)   Nama = "publication"
  …
```

- Subject adalah [DOC-POINTER](/id/grammar/reference/doc-pointer/) (Issuer, ID dokumen, versi `0`). Nama diikat pada dokumen, bukan versi.
- Issuer pada Subject harus sama dengan Issuer yang menaruh indeks. Dokumen Issuer lain diabaikan.
- Nama hanya diikat pada dokumen yang sudah diterbitkan.
- Nama dokumen adalah slug ASCII huruf kecil: `a-z`, `0-9`, `-`. Awal dan akhir bukan `-` dan tidak diawali `0x`. Karena itu tidak bertabrakan dengan ID dokumen (`0x…`) atau nama cadangan (`h`, `versions.geul`, dan lain-lain) ([BIND](/id/grammar/edge/bind/)).
- Dalam satu Issuer, satu nama hanya diikat pada satu dokumen, dan nama yang sudah diikat tidak dipakai ulang untuk dokumen lain. Jika nama diubah, tambahkan BIND baru. Nama lama tetap dikirim ke dokumen yang sama. Jika nama yang sama muncul beberapa kali, BIND terakhir adalah nama utama.
- Di dalam dokumen, nama dirinya sendiri tidak ditulis. Alamat kanonik, kunci cache, dan objek tanda tangan adalah alamat ID. IMPORT dan kutipan di dalam dokumen hanya dengan ID.
- Judul yang dibaca manusia (per bahasa) bukan nama. Ditempelkan dengan `LABEL` pernyataan.
- BIND nama dokumen yang sama juga dapat ditaruh pada dokumen daftar versi ([PUBLICATION](/id/grammar/edge/publication/#nama-dokumen)). Jika ditaruh, harus sama dengan indeks nama. Penerjemah hanya membaca indeks nama.

### Dokumen yang dihapus

- Alamat versi yang dihapus secara hukum·atas kewenangan mengembalikan `410 Gone` dan batu nisan (ID versi, hash isi, tanggal penghapusan, kategori alasan).
- Pada daftar versi, ia tersisa sebagai record [TOMBSTONE](/id/grammar/edge/publication/).

## Lapisan

GEUL menyatakan asal·meta·daftar sampai dengan dokumen GEUL. Minimum yang diperlukan untuk membacanya ditanamkan di decoder untuk memutus sirkularitas. Setiap lapisan hanya bergantung pada lapisan di bawahnya.

| Lapisan | Isi | Bergantung pada |
|---|---|---|
| Lapisan 0 | Aturan yang ditanamkan decoder: framing, hash isi, verifikasi tanda tangan, Codec record daftar versi (`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), kosakata spesifikasi Codec (`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [penanda slot](/id/grammar/reference/slot-marker/) (`0x0000`~`0x0002`), kunci kepercayaan yang diterima dari luar dokumen | Tidak ada. Tidak mencari |
| Lapisan 1 | Dokumen daftar versi | Lapisan 0 |
| Lapisan 2 | Dokumen biasa, codebook, dokumen spesifikasi Codec, dokumen kunci verifikasi Issuer | Ditemukan dengan lapisan 1 dan diverifikasi dengan lapisan 0 |

- Tidak ada lapisan yang bergantung pada lapisan sendiri atau di atasnya.
- Dibedakan antara yang dinyatakan dengan GEUL dan yang baru terbaca jika diinterpretasikan dengan GEUL. Lapisan 0 dapat dinyatakan dengan GEUL, tetapi interpretasinya tidak memerlukan pencarian.
- Inti tetap yang tidak dapat diubah dengan dokumen TOULMIN seperti makna putusan juga ditaruh di sini ([TOULMIN](/id/grammar/edge/toulmin/#meta-kognisi-dan-revisi-mandiri)).

## Daftar versi

Penerbit menulis berkelanjutan satu dokumen daftar versi per dokumen (`/<Issuer>/<ID dokumen>/versions.geul`). Format record dan struktur dokumen ditetapkan oleh [PUBLICATION](/id/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          Hash isi dokumen daftar sebelumnya
  RECORDED-AT     Waktu daftar ini dikeluarkan
  NEXT-LOCAL-ID   LOCAL ID yang dialokasikan berikutnya
  SIGNATURE       Tanda tangan penerbit
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
| DEPRECATION | Menandai anjuran penghentian pemakaian pada versi yang diterbitkan. Tetap diinterpretasikan |
| TOMBSTONE | Menghapus versi yang diterbitkan (penghapusan hukum·atas kewenangan). Menulis kategori alasan |

- Record hanya ditambah. Tidak mengubah, menghapus, atau mengubah urutan. Deprecate·penghapusan juga menambahkan record. Daftar baru menaruh BODY daftar sebelumnya apa adanya di depan lalu menambahkan record, dan antar daftar tersambung dengan rantai hash `PARENT`.
- Ini berarti catatan publikasi tidak diperbaiki, dan berbeda dari revisi isi dokumen ([Dokumen](/id/grammar/document/#revisi)). Status saat ini sebuah versi dihitung dengan menerapkan record secara berurutan.
- ID versi naik berurutan dari 1 tanpa celah. Isi yang sama tidak diterbitkan ulang.
- Versi terbaru adalah versi tertinggi yang tidak dianjurkan dihentikan maupun dihapus.
- Waktu tidak dimasukkan ke dalam record. `RECORDED-AT` daftar tempat record itu pertama kali dimuat adalah waktu publikasi.
- Dokumen daftar tidak menaruh `DOC-ID`. ID dokumen pada record menyatakan daftar tentang apa.
- Dokumen daftar tidak menaruh IMPORT dan hanya memakai Codec lapisan 0.
- Dokumen daftar tidak dimuat pada daftar lain (tidak ada daftar dari daftar). Daftar lama hanya ditunjuk dengan hash isi (`h/<hash isi>.geul`), dan riwayat disambung dengan rantai `PARENT`.
- Alamat yang berubah hanya satu, alamat daftar terbaru (`/<Issuer>/<ID dokumen>/versions.geul`). Pointer yang berubah tidak dapat dibuat sebagai dokumen, sehingga diverifikasi dengan tanda tangan, `RECORDED-AT`, dan `PARENT` daftar yang diterima.

### Pihak penanda tangan

| Tanda tangan | Pihak | Objek |
|---|---|---|
| Tanda tangan dokumen | Issuer dokumen itu | Hash isi dokumen ([Issuer dan publikasi](/id/grammar/issuer/#tanda-tangan)) |
| Tanda tangan daftar | Penerbit yang mengalokasikan ID versi | Hash isi dokumen daftar |

- Untuk publikasi geul.org, geul.org (Issuer GEUL) mengalokasikan ID versi dan menandatangani daftar; untuk publikasi pribadi, Issuer itu.
- Penulis bertanggung jawab atas isi, penerbit atas nomor dan urutan.

### Verifikasi

- Tanda tangan dikeluarkan dari hash isi sehingga hash tetap sama walaupun dihapus. Karena itu verifikasi bukan "jika ada tanda tangan, periksa" melainkan "harus ada tanda tangan dengan kunci yang ditetapkan". Kunci yang dituntut ditentukan oleh pengaturan kepercayaan penerjemah dan catatan kunci.
- Penerjemah mencatat hash isi daftar yang terakhir dilihat di catatan kunci. Jika hash itu tidak ada di rantai `PARENT` daftar yang baru diterima, ditolak (pencegahan rollback·percabangan).
- Mirror dan lingkungan terisolasi jaringan menyalin rantai dokumen daftar bersama-sama. Dengan hanya kunci publik, verifikasi dapat dilakukan secara offline.
- Dokumen yang diterima diverifikasi dengan hash isi dari sumber mana pun. Sumbernya tidak perlu dipercaya.

## Resolusi dependensi

- Dokumen menulis dokumen dependensi dengan [IMPORT-DOC](/id/grammar/meta/import/import-doc/) di HEAD.
- Versi baru tidak menjanjikan kompatibilitas dengan versi sebelumnya. Karena itu versi sebuah dokumen tidak disatukan di seluruh graf (pemilihan versi minimum tidak dipakai).
- Setiap `IMPORT-DOC` terikat pada edisi yang dikuncinya. Beberapa edisi dokumen yang sama dapat ada bersama dalam satu graf (putusan yang mengutip hukum lama dan putusan yang mengutip hukum berlaku). Referensi diselesaikan dengan (dokumen, versi, LOCAL ID).
- Impor terbaru (versi `0`) terikat pada edisi terbaru pada saat interpretasi. Jika interpretasi dilakukan dengan menetapkan titik waktu, terikat pada edisi yang berlaku pada titik waktu itu ([Dokumen](/id/grammar/document/#revisi)).
- Impor yang dikunci dengan ID versi dapat direproduksi (isi ID versi tidak berubah dan diverifikasi dengan catatan kunci).

## Media type

- Media type dokumen GEUL adalah `application/vnd.geul`. Ekstensinya `.geul`.
- Walaupun dipindahkan ke standards tree `application/geul`, `application/vnd.geul` tetap diterima.

## Masalah terbuka

- Sampai di mana geul.org melayani langsung dokumen Issuer 1·2·4·16 WORD dan mulai di mana dikirim ke alamat registri. Kode status saat itu (kanonik 308, terbaru 302·307).
- Penanganan saat ID versi bercabang pada publikasi pribadi·Issuer 16 WORD·lingkungan terisolasi jaringan (ID versi sama, isi berbeda).
- Definisi representasi teks dan negosiasi konten (biner, teks, tampilan HTML menurut `Accept`).
- Hubungan indeks nama dokumen `documents.geul` dengan BIND daftar versi (apakah digabung menjadi satu), serta tanda tangan indeks.
- Susunan HEAD `issuers.geul` dan format tanda tangan·rantainya. Aturan nama Issuer tanpa domain (1·4 WORD), penanganan sengketa nama, dan batas atas panjang.
- Apakah Issuer 1 WORD juga dapat melalui bukti domain secara opsional agar dapat memakai nama domain.
- Kapan dan dalam format apa berpindah dari seluruh rantai ke log Merkle (bukti inklusi·konsistensi) saat daftar membesar.
- Meta yang menulis Issuer penyedia lokasi di HEAD.
