---
title: "Issuer dan publikasi"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL tidak memusatkan sistem identifikasi di satu tempat."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL tidak memusatkan sistem identifikasi di satu tempat. Setiap Issuer mendefinisikan objek dan format, dan dokumen lain memakai definisi yang telah diterbitkan. Definisi dapat dipakai secara rahasia, atau diterbitkan di geul.org (CC0) atau melalui publikasi privat (lisensi ditetapkan Issuer). Definisi mana yang dipercaya dan dipakai ditentukan pengguna.

Alamat publikasi, penetapan format, daftar Issuer, daftar versi, dan lapisan kepercayaan ditetapkan oleh [alamat publikasi dan daftar versi](publishing.md).

## Yang didefinisikan Issuer {#issuer가-정의하는-것}

| Objek | Cara |
|---|---|
| Objek (entitas, konsep, istilah) | Dideklarasikan sebagai LOCAL di dokumennya sendiri |
| Format Reference | Didefinisikan dengan nomor Codec 2 WORD di bawah kode Issuer |
| Format Value | Didefinisikan dengan nomor Codec 2 WORD di bawah kode Issuer |
| Format Edge | Didefinisikan dengan nomor Codec 2 WORD di bawah kode Issuer |

- Definisi format Reference·Value·Edge juga diterbitkan sebagai dokumen.

## Prinsip {#원칙}

- Objek yang didefinisikan Issuer adalah LOCAL dari dokumen yang diterbitkan Issuer itu. Dokumen lain mengutipnya langsung dengan deklarasi penunjuk (`EXTERNAL-ISSUER-*`), atau mengimpornya dengan `IMPORT-DOC` lalu menunjuknya dengan `EXTERNAL-POINTER-*`. Arti record [REFERENCE-ISSUER](reference/_index.md#reference-issuer) ditetapkan oleh dokumen Codec yang diterbitkan Issuer.
- Untuk objek yang harus ditunjuk dari luar dokumen, diterbitkan LOCAL dari dokumen publikasi. Dokumen itu harus memiliki [DOC-ID](meta/0x1C7L-doc-id.md).

## Tingkat Issuer {#issuer-등급}

| Lebar | Rentang nilai | Penerbitan |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Pendaftaran di geul.org. Melalui bukti kepemilikan domain. Nomor yang diberikan geul.org kepada badan penetap standar dan lembaga utama juga berlebar ini ([tabel penetapan 2 WORD](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Pendaftaran di geul.org. Tanpa bukti kepemilikan |
| 16 WORD | `2^64` atau lebih | Diterbitkan sendiri. Dihitung dari kunci publik |

- **ID Issuer adalah nilai bilangan bulat.** Jika nilainya sama, itu Issuer yang sama. Lebar bukan bagian dari pengenal.
- **Penulisan panjang dengan angka 0 di depan ID Issuer yang pendek adalah Issuer yang sama** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` dan `0x0000000000000001` adalah Issuer yang sama. Karena itu `0x00000000XXXXXXXX` tidak ditetapkan sebagai Issuer 4 WORD, dan nilai dengan 12 WORD atas bernilai 0 tidak ditetapkan sebagai Issuer 16 WORD.
- **Bentuk kanonis adalah lebar tersempit.** Dalam record ditulis dengan lebar tersempit yang memuat nilainya, dan penulisan dengan lebar lebih besar ditolak. Karena itu penetapan setiap lebar dimulai dari nilai tepat setelah rentang lebar di bawahnya berakhir. 2 WORD adalah lebar tersempit. Saat dipakai dalam alamat publikasi, ditulis dengan jumlah digit lebar penerbitan (2 WORD 8 digit, 4 WORD 16 digit, 16 WORD 64 digit) dan hex huruf besar (alamat yang ditulis huruf kecil juga dicari setelah diubah ke huruf besar), dan saat membaca, penulisan yang diperlebar juga diterima sebagai Issuer yang sama ([alamat publikasi dan daftar versi](publishing.md#id-표기)).

## Tabel penetapan 2 WORD {#2-word-배정표}

geul.org menetapkan nomor Issuer 2 WORD kepada badan penetap standar dan lembaga utama secara berurutan dari depan. Format de facto standar atau format konvensi yang tidak memiliki badan penetap ditaruh di bawah `ADHOC` (`adhoc.geul.org`). Format asli yang dirancang GEUL adalah kode langsung. Issuer badan penetap standar adalah Issuer subdomain geul.org. Nama subdomain adalah nama lembaga dalam huruf kecil (`<nama lembaga>.geul.org`, contoh: `iso.geul.org`, `iec.geul.org`). Domain dicatat dalam tabel di bawah.

| Issuer | Nama | Domain | Badan | Format utama |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Dokumen spesifikasi kode langsung (codebook) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Dokumen item·properti Wikidata |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Format konvensi tanpa badan penetap. BFLOAT16, BLAKE3, bilangan kompleks·pecahan·interval·kuaternion, vektor·tensor |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (mata uang), ISO 3166 (negara) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (notasi satuan) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | Standar teknologi informasi ISO/IEC |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (pengodean ASN.1) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4·IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Tipe media, registri subtag bahasa |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | Tipe data XML Schema, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Pengodean karakter, normalisasi, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | Floating point·decimal IEEE 754, alamat MAC (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Format piksel (RGBA8·BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Koordinat·kotak pembatas, keluarga GeoJSON |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Format Microscaling (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Standar dokumen·keamanan |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | Satuan SI, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Detik kabisat, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Pengelola GPS (pemerintah) | Waktu GPS |
| `0x00000017` | KATS | `kats.geul.org` | Badan Teknologi dan Standar Nasional Korea (국가기술표준원) | Standar KS |

- Format ekstensi ditaruh di bawah Issuer badan yang menetapkan format itu. Nomor Codec di bawah Issuer didefinisikan oleh masing-masing Issuer.
- Nomor Codec ditetapkan Issuer. GEUL tidak menetapkan artinya. Nomor Codec tidak tumpang tindih dalam Issuer itu, terlepas dari Kind ([alamat publikasi dan daftar versi](publishing.md#id-표기)).
- Jika badan standar tidak mengelola nomor Codec GEUL secara langsung, geul.org mendaftarkan standar badan itu dengan nomor sebagai gantinya. Nomor dicatat bersama pengenal dokumen standar.
- Badan penetap standar baru menerima nomor kosong berikutnya.
- **Domain dapat berubah.** Pengikatan Issuer dan domain dapat berubah kemudian. ID Issuer tidak berubah. Jika lembaga mengelolanya sendiri, diganti dengan domain resmi lembaga itu.
- **Subdomain geul.org bukan penerbit resmi.** Subdomain geul.org yang memakai nama lembaga standar bukan penerbit resmi lembaga itu. Misalnya, `iso.geul.org` bukan penerbit resmi ISO.

## Issuer 16 WORD {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID algoritma tanda tangan (2 byte) ‖ kunci publik)
```

- 32 byte hasilnya ditulis ke 16 WORD mulai dari byte teratas.
- Siapa pun dapat membuatnya tanpa pendaftaran. Kepemilikan dibuktikan dengan tanda tangan kunci privat itu.
- Kunci publik dan algoritma dideklarasikan dengan [ISSUER-KEY](meta/0x1E5L-issuer-key.md) pada HEAD dokumen. Algoritma tanda tangan `0x0001` adalah Ed25519, nilai lainnya Reserved.
- Prefiks `GEUL-ISSUER-v1` mencegah ID yang sama muncul saat kunci yang sama dipakai untuk keperluan lain (pemisahan keperluan).
- Meski algoritma tanda tangan berubah (contoh: Ed25519 → ML-DSA), lebar ID tetap 16 WORD.
- Jika hasilnya kurang dari `2^64` (probabilitasnya praktis 0), Issuer tidak dibuat dengan kunci itu. Itu karena akan bertumpang tindih dengan aturan lebar tersempit.

## Bukti domain {#도메인-증명}

- Bukti kepemilikan domain Issuer 2 WORD hanya diperiksa pada saat pendaftaran. Pengelolaan domain setelahnya menjadi tanggung jawab Issuer.
- Satu domain hanya berkorespondensi dengan satu Issuer. Satu Issuer dapat memiliki beberapa domain. Korespondensi ditulis dengan BIND di daftar Issuer `issuers/` ([alamat publikasi dan daftar versi](publishing.md#issuer-목록)).
- Meski domain kedaluwarsa atau berpindah tangan, korespondensi tetap pada Issuer yang pertama kali membuktikan. Pemilik baru tidak dapat memakai domain itu sebagai nama Issuer.
- Nama domain dipakai untuk input dan tampilan interpreter·CLI. Bukan alamat URL publikasi ([alamat publikasi dan daftar versi](publishing.md#도메인-이름)). Dalam dokumen GEUL hanya ditulis ID Issuer.

## Dokumen definisi istilah {#용어-정의-문서}

- Istilah yang didefinisikan Issuer (alat, program, peran, konsep dalam organisasi) ditaruh dengan **satu dokumen per istilah**. Istilah adalah LOCAL dari dokumen itu, nama dihubungkan dengan [BIND](edge/0x0A3L-bind.md), dan objek eksternal yang ditunjuk (URI dan sebagainya) dihubungkan dengan [REFERENCE-NODE](edge/0x0A0L-reference-node.md).
- Dokumen lain menunjuk istilah dengan `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, LOCAL ID). Definisi yang sama tidak diulang di setiap dokumen. Contoh: alat pada [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- Rentang ID dokumen untuk dokumen definisi istilah ditetapkan Issuer. geul.org (`0x00000000`) memakai `0x0001xxxx xxxxxxxx`.
- Setiap Issuer mencadangkan ID dokumen `0x0000000000000000` dan `0xFFFFFFFFFFFFFFFF`. Penggunaan saat ini ada dua di bawah.
- ID dokumen `0x0000000000000000` adalah tempat **dokumen indeks definisi istilah** Issuer itu: `<Issuer>/docs/0x0000000000000000/`. Tempat untuk mendaftar dokumen definisi istilah.
- ID dokumen `0xFFFFFFFFFFFFFFFF` dipakai untuk daftar Issuer `issuers/` milik Issuer geul.org (`0x00000000`). Issuer lain tidak memakai ID ini. ID ini tidak diterima di Issuer mana pun dengan alamat `<Issuer>/docs/<ID dokumen>/` (404) ([alamat publikasi dan daftar versi](publishing.md#목록-문서)).
- Dokumen indeks **dianjurkan** untuk semua Issuer. Bukan wajib.
- Urutan menunjuk objek eksternal: (1) jika ada Codec Reference yang cocok, itu (WIKIDATA-QID dan sebagainya), (2) jika ada dokumen GEUL yang mendefinisikan objek itu, itu (DOC-POINTER·EXTERNAL-ISSUER), (3) jika tidak ada, definisikan sebagai LOCAL di dokumen definisi istilah sendiri lalu tunjuk.

## Cara membuka dokumen {#문서-공개-방식}

| Cara | Objek | Lisensi | Pengelolaan versi | Keberlangsungan |
|---|---|---|---|---|
| Rahasia | Semua Issuer | Internal Issuer | Issuer | Bergantung pada Issuer |
| Publikasi geul.org | Issuer 2 WORD | CC0 | geul.org | Dilestarikan geul.org |
| Publikasi privat | Semua Issuer | Ditetapkan Issuer | Issuer | Bergantung pada Issuer |

### Publikasi geul.org {#geulorg-공표}

- Issuer 2 WORD dapat mendaftarkan dokumen di geul.org dan menerbitkannya. Dokumen yang didaftarkan adalah CC0. Begitu didaftarkan langsung diterbitkan, dan masalah ditangani setelahnya.
- Definisi yang dapat diterbitkan adalah konsep dan codec. **Reference yang menunjuk orang perseorangan tidak dapat diterbitkan di geul.org.** Dilakukan secara rahasia atau publikasi privat.
  - Pengecualian: menunjuk orang perseorangan dengan [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) diizinkan.
- Versi yang didaftarkan tidak diubah atau dihapus, dan dokumen tetap ada meski Issuer lenyap (pelestarian undang-undang lama). Pengecualiannya penghapusan hukum dan penghapusan oleh otoritas ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- Issuer hanya dapat menandai anjuran penghentian penggunaan (deprecated) pada definisi. Definisi yang dianjurkan dihentikan tetap ditafsirkan.
- Versi baru dari dokumen yang sama dapat membuat, merevisi, dan menghapus definisi ([dokumen](document.md#개정)). **ID entitas dan nomor Codec yang telah dihapus tidak dipakai ulang untuk objek lain.** Layout wire nomor Codec tidak direvisi.

### Publikasi privat {#사설-공표}

- Issuer yang ingin menerbitkan dengan lisensi selain CC0 melayani dokumen di jaringan privat (domain sendiri dan sebagainya). Lisensi dideklarasikan dengan [LICENSE](meta/0x1DEL-license.md) pada HEAD dokumen.
- Publikasi privat juga memakai jalur yang sama dengan geul.org ([alamat publikasi dan daftar versi](publishing.md)).
- Pengelolaan versi, ketersediaan, pemeliharaan domain, dan ketentuan lisensi ditetapkan Issuer. geul.org tidak terlibat atau menjamin publikasi privat.

### Rahasia {#대외비}

- Dokumen rahasia tidak diterbitkan. Dipasang kontrol akses dan ditandai dengan [ACCESS](meta/0x1DFL-access.md).
- Jika dokumen yang memakai definisi rahasia dikirim ke luar, pihak penerima tidak dapat menafsirkan Reference·Value·Edge itu dan melewatinya. Definisi yang akan dipertukarkan dengan pihak luar diterbitkan.

### Pilihan pengguna {#사용자의-선택}

- Pengguna memilih dokumen yang dipakai dengan melihat lisensi yang dideklarasikan dan kemungkinan keberlangsungan Issuer.
- Definisi dengan lisensi yang terlalu membatasi atau Issuer yang keberlangsungannya meragukan tidak akan dipakai.
- Untuk rujukan yang harus dilestarikan lama, gunakan dokumen publikasi geul.org.

## Tanda tangan {#서명}

- Tanda tangan wajib pada dokumen publikasi. Diletakkan di HEAD sebagai [SIGNATURE](meta/0x1E6L-signature.md). Dokumen tanpa tanda tangan juga dokumen GEUL yang valid, dan dokumen rahasia·internal pun sebaiknya ditandatangani bila memungkinkan.
- Objek tanda tangan adalah **hash isi** dokumen ([dokumen](document.md#내용-해시)). Tidak menandatangani BODY saja.
  - HEAD memiliki aturan penafsiran. Jika objek `IMPORT-DOC` diubah, BODY yang sama menunjuk objek lain.
  - Jika `LICENSE`·`PARENT` tidak ditandatangani, lisensi dan riwayat dapat dipalsukan.
- Satu dokumen dapat memiliki beberapa tanda tangan. Semuanya menandatangani hash isi yang sama sehingga hash isi tidak berubah meski tanda tangan ditambahkan.
- Pemeriksaan kunci tanda tangan:
  - Issuer 2·4 WORD: kunci yang didaftarkan di geul.org (kunci verifikasi dibuka di bawah).
  - Issuer 16 WORD: `ISSUER-KEY` di dokumen yang sama. ID Issuer yang dihitung dari kunci publik itu harus sama dengan penanda tangan.
- Pihak pembaca menurunkan tingkat kepercayaan jika tanda tangan tidak ada, dan menurunkannya lebih besar lagi jika ada tanda tangan tetapi verifikasi gagal, karena itu bukti pemalsuan·penyamaran.
- Tanda tangan dokumen dibuat oleh Issuer dokumen itu, dan tanda tangan daftar versi dibuat oleh penerbit yang menetapkan ID versi ([alamat publikasi dan daftar versi](publishing.md#서명-주체)).

## Pembukaan kunci verifikasi {#검증키-공개}

- geul.org membuka kunci verifikasi tanda tangan Issuer terdaftar (2·4 WORD).
- Daftar kunci dikeluarkan sebagai dokumen publikasi Issuer GEUL (`0x00000000`). CC0 dan ditandatangani geul.org.
  - Entri: Issuer, ID algoritma tanda tangan, kunci publik, waktu mulai berlaku, waktu pencabutan dan alasannya.
- Kunci yang dicabut pun tidak dihapus. Tanda tangan masa lalu diverifikasi dengan kunci yang berlaku pada saat penandatanganan.
- Penggantian kunci dilakukan dengan mendaftarkan kunci baru yang ditandatangani kunci lama. Pihak yang memverifikasi dapat memeriksa kesinambungan kunci tanpa mempercayai geul.org.
- Catatan perubahan kunci disimpan sebagai log yang hanya dapat ditambah (seperti Certificate Transparency, Go sumdb). Jika riwayat diubah, akan terlihat.
- Jika kunci hilang sehingga tidak dapat menandatangani dengan kunci lama, geul.org memeriksa ulang identitas dan mendaftarkan kunci baru. Issuer 2 WORD melalui bukti kepemilikan domain lagi. Dalam hal ini geul.org harus dipercaya, dan alasannya dicatat di log.
- Tidak berlaku untuk Issuer 16 WORD. Karena ID Issuer dihitung dari kunci publik, verifikasi cukup dengan `ISSUER-KEY` di dalam dokumen.

## Impor {#가져오기}

IMPORT hanya mengimpor dokumen.

```
IMPORT-DOC                      DOC-POINTER(Issuer + ID dokumen + ID versi) + IMPORT ID
                                dokumen codec: CODEC-POINTER(Issuer + Codec ID + ID versi) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + ID dokumen + LOCAL ID (tanpa IMPORT)
ISSUER-POINTER                  Issuer (Issuer itu sendiri)
DOC-POINTER                     Issuer + ID dokumen + ID versi (2 WORD, 0 berarti terbaru)
CODEC-POINTER                   Issuer + Codec ID + ID versi (2 WORD, 0 berarti terbaru)
```

- Issuer dengan lebar mana pun beserta dokumennya dapat ditunjuk dengan deklarasi penunjuk tanpa IMPORT. Issuer itu sendiri dengan `ISSUER-POINTER`, dokumen itu sendiri dengan `DOC-POINTER`, dan LOCAL dokumen dengan `EXTERNAL-ISSUER-*`. Deklarasi penunjuk mengikuti versi terbaru, dan untuk mengunci versi dipakai `IMPORT-DOC` (ID versi) dan `EXTERNAL-POINTER-*`.
- Reference isi yang menunjuk objek dokumen eksternal hanya menulis IMPORT ID + ID objek, bukan jalur lengkap (Issuer + dokumen + ID objek). [REFERENCE-ISSUER](reference/_index.md#reference-issuer) menulis Issuer dan nomor Codec.
- Lebar IMPORT ID ditetapkan oleh panjang pada `IMPORT-DOC`, dan oleh Codec pada `EXTERNAL-POINTER-*` ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Jika diimpor tanpa ID versi, mengikuti versi terbaru. Jika ID versi ditulis, terkunci pada versi itu. Dokumen publikasi menulis ID versi.

## Lisensi {#라이선스}

- Dokumen publikasi geul.org dan dokumen Issuer GEUL (`0x00000000`) adalah CC0.
- Lisensi dokumen publikasi privat ditetapkan Issuer. GEUL tidak memaksakan.
- **Lisensi format Issuer.** Hanya kode langsung dan publikasi yang disediakan geul.org yang CC0. Lisensi format Issuer ditetapkan Issuer itu.
- **Penandaan Issuer.** GEUL menyandarkan Resolve pada penandaan Issuer. Pada dokumen yang memakai codec Issuer lain, Issuer itu selalu ditandai.
- Hasil inti GEUL tidak menyalin isi dokumen Issuer yang bukan CC0.

## Masalah terbuka {#열린-문제}

- Cara bukti kepemilikan domain (DNS TXT `_geul.<domain>`, HTTP `.well-known`) dan apakah sidik jari kunci tanda tangan diikat ke nilai bukti.
- Penanganan perebutan domain saat pemulihan kunci hilang. Jika kunci baru didaftarkan hanya dengan pembuktian ulang domain, perebut dapat mengambil Issuer. Dikaji pemeriksaan kontak pendaftaran, masa tenggang dan keberatan kunci lama, serta penerapan hasil sengketa domain.
- Format record dokumen indeks definisi istilah (ID dokumen `0`) (Edge yang mendaftar dokumen definisi istilah).
- Nilai bawaan algoritma tanda tangan (Ed25519 dianjurkan).
