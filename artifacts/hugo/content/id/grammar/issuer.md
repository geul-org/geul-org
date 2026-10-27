---
title: "Issuer dan publikasi"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Issuer adalah pihak yang mendefinisikan dokumen dan format. Cara penerbitan berbeda menurut lebar (1·2·4·16 WORD). Halaman ini menetapkan tingkat Issuer, tabel alokasi 1 WORD, cara publikasi dokumen, serta tanda tangan dan publikasi kunci verifikasi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL tidak mengumpulkan sistem identifikasi di satu tempat. Setiap Issuer mendefinisikan target dan format, dan dokumen lain memakai definisi yang sudah diterbitkan. Definisi dipakai secara rahasia, atau diterbitkan melalui geul.org (CC0) atau publikasi pribadi (lisensi yang ditetapkan Issuer). Definisi mana yang dipercaya dan dipakai ditentukan pengguna.

Alamat publikasi, penetapan format, indeks nama, daftar versi, dan lapisan kepercayaan ditetapkan oleh [alamat publikasi dan daftar versi](/id/grammar/publishing/).

## Yang didefinisikan Issuer

| Objek | Cara |
|---|---|
| Target (entitas, konsep, istilah) | Dideklarasikan sebagai LOCAL dokumennya sendiri |
| Format Value | Didefinisikan dengan nomor format di bawah kode Issuer |
| Format Edge | Didefinisikan dengan nomor format di bawah kode Issuer |

- Definisi format Value·Edge juga diterbitkan sebagai dokumen.

## Prinsip

- Semua ID berlingkup dokumen. LOCAL ID (termasuk Edge Id dan variabel) dan IMPORT ID hanya valid di dalam dokumen itu.
- Target yang didefinisikan Issuer adalah LOCAL dari dokumen yang diterbitkan Issuer itu. Dokumen lain mengutipnya langsung dengan penunjuk-deklarasi (`EXTERNAL-ISSUER-*`), atau mengimpornya dengan `IMPORT-DOC` lalu menunjuk dengan `EXTERNAL-POINTER-*`.
- Untuk target yang harus ditunjuk dari luar dokumen, LOCAL dokumen terbitan dikeluarkan. Dokumen itu harus memiliki [DOC-ID](/id/grammar/meta/declaration/doc-id/).

## Tingkat Issuer

| Lebar | Rentang nilai | Penerbitan |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org mengalokasikan kepada lembaga penetap standar dan lembaga utama ([tabel alokasi 1 WORD](#tabel-alokasi-1-word)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | Didaftarkan di geul.org. Melalui bukti kepemilikan domain |
| 4 WORD | `2^32`~`2^64−1` | Didaftarkan di geul.org. Tanpa bukti kepemilikan |
| 16 WORD | `2^64` atau lebih | Penerbitan mandiri. Dihitung dari kunci publik |

- **Issuer ID adalah nilai bilangan bulat.** Jika nilainya sama, Issuer-nya sama (`0x0001` dan `0x00000001` adalah nilai yang sama). Lebar bukan bagian dari pengenal.
- **Bentuk kanonik adalah lebar terpendek.** Ditulis dengan lebar terpendek tempat nilainya muat, dan notasi dengan lebar lebih lebar ditolak. Karena itu alokasi setiap lebar dimulai dari nilai setelah rentang lebar di bawahnya berakhir (2 WORD mulai dari `0x00010000`).

## Tabel alokasi 1 WORD

Issuer 1 WORD dialokasikan geul.org kepada lembaga penetap standar dan lembaga utama. Format khas yang dirancang GEUL ditaruh di bawah `GEUL`, dan standar de facto atau format konvensi tanpa lembaga penetap di bawah `ADHOC`.

| Issuer | Nama | Lembaga | Format utama |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | Format khas GEUL, codebook |
| `0x0001` | ADHOC | geul.org | Format konvensi tanpa lembaga penetap. BFLOAT16, BLAKE3, bilangan kompleks·pecahan·interval·kuaternion, vektor·tensor |
| `0x0002`~`0x000F` | Cadangan | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (mata uang), ISO 3166 (negara) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (notasi satuan) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | Standar teknologi informasi ISO/IEC |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (encoding ASN.1) |
| `0x0014`~`0x001F` | Cadangan | Lembaga standar internasional | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4·IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | Media type, registri subtag bahasa |
| `0x0022` | W3C | World Wide Web Consortium | Tipe data XML Schema, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | Encoding karakter, normalisasi, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`~`0x003F` | Cadangan | Lembaga standar internet·web | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | Floating-point·decimal IEEE 754, alamat MAC (802) |
| `0x0041` | KHRONOS | Khronos Group | Format piksel (RGBA8·BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | Koordinat·bounding box, keluarga GeoJSON |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Format Microscaling (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | Standar dokumen·keamanan |
| `0x0046`~`0x005F` | Cadangan | Lembaga standar industri | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | Satuan SI, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | Detik kabisat, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | Pihak pemerintah pengelola GPS | Waktu GPS |
| `0x0064`~`0x00FF` | Cadangan | Lembaga metrologi·pemerintah | |
| `0x0100` | KATS | Korean Agency for Technology and Standards | Standar KS |
| `0x0101`~`0x01FF` | Cadangan | Lembaga standar nasional | |
| `0x0200`~`0xFFFF` | Cadangan | Dialokasikan kemudian | |

- Format perluasan ditaruh di bawah Issuer lembaga yang menetapkan format itu. Nomor format di bawah Issuer didefinisikan oleh masing-masing Issuer.
- Bit atas nomor format harus mengikuti aturan keluarga Kind terkait. Dengan begitu keluarga diketahui tanpa codebook.
- Jika lembaga standar tidak mengelola nomor format GEUL sendiri, geul.org mendaftarkan standar lembaga itu sebagai nomor atas namanya. Nomor dicatat bersama pengenal dokumen standar.
- Alokasi dilakukan dari nomor rendah dalam rentang pembagian lembaga. Rentang hanya kemudahan klasifikasi dan decoder tidak wajib menginterpretasikannya.

## Issuer 16 WORD

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID algoritma tanda tangan (2 byte) ‖ kunci publik)
```

- 32 byte hasil ditulis pada 16 WORD mulai dari byte atas.
- Siapa pun dapat membuatnya tanpa pendaftaran. Kepemilikan dibuktikan dengan tanda tangan kunci privat.
- Kunci publik dan algoritma dideklarasikan dengan [ISSUER-KEY](/id/grammar/meta/verification/issuer-key/) di HEAD dokumen. Algoritma tanda tangan `0x0001` adalah Ed25519, dan nilai lain adalah cadangan.
- Awalan `GEUL-ISSUER-v1` mencegah ID yang sama keluar saat kunci yang sama dipakai untuk keperluan lain (pemisahan penggunaan).
- Walaupun algoritma tanda tangan berubah (contoh: Ed25519 → ML-DSA), lebar ID tetap 16 WORD.
- Jika hasilnya kurang dari `2^64` (probabilitasnya praktis 0), Issuer tidak dibuat dengan kunci itu. Karena bertabrakan dengan aturan lebar terpendek.

## Bukti domain

- Bukti kepemilikan domain Issuer 2 WORD hanya dikonfirmasi saat pendaftaran. Pengelolaan domain setelahnya adalah tanggung jawab Issuer.
- Satu domain hanya berpadanan dengan satu Issuer. Satu Issuer boleh memiliki beberapa domain. Padanan ditulis dengan BIND pada indeks nama Issuer `issuers.geul` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-issuer)).
- Walaupun domain kedaluwarsa atau berpindah tangan, padanan tetap pada Issuer yang pertama kali membuktikan. Pemilik baru tidak dapat memakai domain itu sebagai nama Issuer.
- Nama domain untuk input alamat dan tampilan. Di dalam dokumen GEUL hanya ditulis Issuer ID.

## Dokumen definisi istilah

- Istilah yang didefinisikan Issuer (alat, program, peran, konsep di dalam organisasi) ditaruh sebagai **satu istilah, satu dokumen**. Istilah adalah LOCAL dokumen itu, namanya dihubungkan dengan [BIND](/id/grammar/edge/bind/), dan target eksternal yang ditunjuk (URI, dan lain-lain) dengan [REFERENCE-NODE](/id/grammar/edge/reference-node/).
- Dokumen lain menunjuk istilah dengan `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, LOCAL ID). Definisi yang sama tidak diulang pada setiap dokumen. Contoh: alat pada [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/).
- Rentang ID dokumen untuk dokumen definisi istilah ditetapkan Issuer. geul.org (`0x0000`) memakai `0x0001xxxx xxxxxxxx` ([dokumen spesifikasi Codec](/id/grammar/codec-spec/#id-dokumen-issuer-geul)).
- ID dokumen `0x0000000000000000` setiap Issuer dicadangkan sebagai **dokumen indeks definisi istilah** Issuer itu: `<Issuer>/0x0000000000000000/`. Tempat mendaftar dokumen-dokumen definisi istilah.
- Dokumen indeks **dianjurkan** untuk semua Issuer. Tidak wajib. Jika tidak ada indeks, dokumen definisi istilah ditemukan dengan indeks nama `documents.geul`.
- Urutan menunjuk target eksternal: (1) jika ada Codec Reference yang sesuai, itu (WIKIDATA-QID, dan lain-lain), (2) jika ada dokumen GEUL yang mendefinisikan target itu, itu (DOC-POINTER·EXTERNAL-ISSUER), (3) jika tidak ada, definisikan sebagai LOCAL pada dokumen definisi istilah sendiri lalu tunjuk.

## Cara publikasi dokumen

| Cara | Objek | Lisensi | Pengelolaan versi | Keberlangsungan |
|---|---|---|---|---|
| Rahasia | Semua Issuer | Internal Issuer | Issuer | Bergantung pada Issuer |
| Publikasi geul.org | Issuer 1·2 WORD | CC0 | geul.org | Dilestarikan geul.org |
| Publikasi pribadi | Semua Issuer | Ditetapkan Issuer | Issuer | Bergantung pada Issuer |

### Publikasi geul.org

- Issuer 1·2 WORD dapat mendaftarkan dokumen di geul.org dan menerbitkannya. Dokumen terdaftar adalah CC0.
  - Issuer 1 WORD menerbitkan setelah melalui penyaringan awal geul.org.
  - Issuer 2 WORD langsung diterbitkan setelah mendaftar, dan masalah ditangani setelahnya.
- Definisi yang dapat diterbitkan adalah konsep dan codec. **Reference yang menunjuk orang perseorangan tidak dapat diterbitkan di geul.org.** Lakukan dengan rahasia atau publikasi pribadi.
  - Pengecualian: menunjuk orang perseorangan dengan [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) diizinkan.
- Versi yang didaftarkan tidak diubah atau dihapus, dan dokumen tetap ada walaupun Issuer menghilang (pelestarian hukum lama). Pengecualiannya penghapusan hukum dan penghapusan atas kewenangan ([TOMBSTONE](/id/grammar/edge/publication/)).
- Issuer hanya dapat menandai anjuran penghentian pemakaian (deprecated) pada definisi. Definisi yang dianjurkan dihentikan tetap diinterpretasikan.
- Versi baru dokumen yang sama dapat membuat·merevisi·menghapus definisi ([Dokumen](/id/grammar/document/#revisi)). **ID entitas dan nomor format yang dihapus tidak dipakai ulang untuk target lain.** Layout wire nomor format tidak direvisi.

### Publikasi pribadi

- Issuer yang ingin menerbitkan dengan lisensi selain CC0 melayani dokumen di jaringan pribadi (domain sendiri, dan lain-lain). Lisensi dideklarasikan dengan [LICENSE](/id/grammar/meta/policy/license/) di HEAD dokumen.
- Publikasi pribadi juga memakai path yang sama dengan geul.org ([alamat publikasi dan daftar versi](/id/grammar/publishing/)).
- Pengelolaan versi, ketersediaan, pemeliharaan domain, dan syarat lisensi ditetapkan Issuer. geul.org tidak terlibat atau menjamin publikasi pribadi.

### Rahasia

- Dokumen rahasia tidak diterbitkan. Pasang kontrol akses dan tandai dengan [ACCESS](/id/grammar/meta/policy/access/).
- Jika dokumen yang memakai definisi rahasia dikirim ke luar, penerima tidak dapat menginterpretasikan Reference·Value·Edge itu dan melompatinya. Definisi yang akan dipertukarkan dengan pihak luar diterbitkan.

### Pilihan pengguna

- Pengguna memilih dokumen yang dipakai dengan melihat lisensi yang dideklarasikan dan kemungkinan keberlangsungan Issuer.
- Definisi dari lisensi yang terlalu membatasi atau Issuer yang keberlangsungannya mengkhawatirkan tidak akan dipakai.
- Untuk referensi yang harus dilestarikan lama, pakai dokumen terbitan geul.org.

## Tanda tangan

- Tanda tangan wajib pada dokumen terbitan. Ditaruh di HEAD sebagai [SIGNATURE](/id/grammar/meta/verification/signature/). Dokumen tanpa tanda tangan tetap dokumen GEUL yang valid, dan dokumen rahasia·internal pun sebaiknya ditandatangani jika memungkinkan.
- Objek tanda tangan adalah **hash isi** dokumen ([Dokumen](/id/grammar/document/#hash-isi)). BODY saja tidak ditandatangani.
  - HEAD memiliki aturan interpretasi. Jika target `IMPORT-DOC` diubah, BODY yang sama menunjuk target yang berbeda.
  - Jika `LICENSE`·`PARENT` tidak ditandatangani, lisensi dan riwayat dapat dipalsukan.
- Satu dokumen boleh memiliki beberapa tanda tangan. Semuanya menandatangani hash isi yang sama sehingga hash isi tidak berubah walaupun tanda tangan ditambah.
- Konfirmasi kunci tanda tangan:
  - Issuer 1·2·4 WORD: kunci yang didaftarkan di geul.org (publikasi kunci verifikasi di bawah).
  - Issuer 16 WORD: `ISSUER-KEY` pada dokumen yang sama. Issuer ID yang dihitung dengan kunci publik itu harus sama dengan penanda tangan.
- Pihak pembaca menurunkan tingkat kepercayaan jika tidak ada tanda tangan, dan menurunkannya lebih besar jika ada tanda tangan tetapi verifikasi gagal karena itu bukti pemalsuan·peniruan.
- Tanda tangan dokumen dilakukan Issuer dokumen itu, dan tanda tangan daftar versi dilakukan penerbit yang mengalokasikan ID versi ([alamat publikasi dan daftar versi](/id/grammar/publishing/#pihak-penanda-tangan)).

## Publikasi kunci verifikasi

- geul.org mempublikasikan kunci verifikasi tanda tangan Issuer terdaftar (1·2·4 WORD).
- Daftar kunci dikeluarkan sebagai dokumen terbitan Issuer GEUL (`0x0000`). CC0 dan ditandatangani geul.org.
  - Butir: Issuer, ID algoritma tanda tangan, kunci publik, waktu mulai berlaku, waktu pencabutan dan alasannya.
- Kunci yang dicabut pun tidak dihapus. Tanda tangan masa lalu diverifikasi dengan kunci yang berlaku pada waktu penandatanganan.
- Penggantian kunci dilakukan dengan menandatangani kunci baru memakai kunci lama lalu mendaftarkannya. Pihak yang memverifikasi dapat memastikan kesinambungan kunci tanpa harus mempercayai geul.org.
- Catatan perubahan kunci disimpan dalam log yang hanya dapat ditambah (seperti Certificate Transparency, Go sumdb). Jika riwayat diubah, akan terungkap.
- Jika kunci hilang sehingga tidak dapat menandatangani dengan kunci lama, geul.org mengonfirmasi ulang identitas dan mendaftarkan kunci baru. Issuer 2 WORD melalui bukti kepemilikan domain lagi. Dalam hal ini geul.org harus dipercaya, dan alasannya dicatat di log.
- Tidak berlaku untuk Issuer 16 WORD. Karena Issuer ID dihitung dari kunci publik, verifikasi hanya dengan `ISSUER-KEY` di dalam dokumen.

## Impor

IMPORT hanya mengimpor dokumen.

```
IMPORT-DOC                      DOC-POINTER (Issuer + ID dokumen + ID versi) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + ID dokumen + LOCAL ID (tanpa IMPORT)
ISSUER-POINTER                  Issuer (Issuer itu sendiri)
DOC-POINTER                     Issuer + ID dokumen + ID versi (2 WORD, jika 0 terbaru)
```

- Issuer lebar apa pun dan dokumennya dapat ditunjuk dengan penunjuk-deklarasi tanpa IMPORT. Issuer itu sendiri dengan `ISSUER-POINTER`, dokumen itu sendiri dengan `DOC-POINTER`, dan LOCAL dokumen dengan `EXTERNAL-ISSUER-*`. Penunjuk-deklarasi mengikuti versi terbaru, dan untuk mengunci versi pakai `IMPORT-DOC` (ID versi) dan `EXTERNAL-POINTER-*`.
- Reference di isi dokumen hanya memakai IMPORT ID + ID target, bukan path lengkap (Issuer + dokumen + ID target).
- Lebar IMPORT ID ditetapkan oleh panjang pada `IMPORT-DOC` dan oleh Codec pada `EXTERNAL-POINTER-*`. Hanya valid di dalam dokumen itu ([IMPORT-DOC](/id/grammar/meta/import/import-doc/)).
- Jika diimpor tanpa ID versi, mengikuti versi terbaru. Jika ID versi ditulis, terkunci pada versi itu. Dokumen terbitan menulis ID versi.

## Lisensi

- Dokumen terbitan geul.org dan dokumen Issuer GEUL (`0x0000`) adalah CC0.
- Lisensi dokumen publikasi pribadi ditetapkan Issuer. GEUL tidak memaksakan.
- Produk inti GEUL tidak menyalin isi dokumen Issuer yang bukan CC0.

## Masalah terbuka

- Apakah publikasi geul.org untuk Issuer 4 WORD·16 WORD diizinkan.
- Cara bukti kepemilikan domain (DNS TXT `_geul.<domain>`, HTTP `.well-known`) dan apakah sidik jari kunci tanda tangan diikat pada nilai bukti.
- Penanganan perampasan domain saat pemulihan kunci hilang. Jika kunci baru didaftarkan hanya dengan pembuktian ulang domain, perampas dapat mengambil Issuer. Dipertimbangkan konfirmasi kontak pendaftaran, masa tenggang dan keberatan kunci lama, serta penerapan hasil sengketa domain.
- Format record dokumen indeks definisi istilah (ID dokumen `0`) (Edge yang mendaftar dokumen definisi istilah).
- Nilai default algoritma tanda tangan (Ed25519 dianjurkan).
