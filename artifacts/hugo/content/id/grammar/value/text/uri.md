---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI adalah Value yang memuat deretan byte ASCII tata bahasa URI RFC 3986 (URI absolut dengan scheme). Memakai pasangan kode byte genap·ganjil 0x44/0x45."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI adalah Value yang memuat deretan byte ASCII tata bahasa RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. Karena menyertakan scheme, base URI tidak diperlukan untuk interpretasi.

## Layout

- Kode: kode langsung Value `0x44` (byte genap)·`0x45` (byte ganjil). Keluarga TEXT.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretasi dan validitas

- Deretan byte harus sesuai dengan tata bahasa `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` RFC 3986. Dapat menyertakan query dan fragment.
- Terminal tata bahasa URI adalah karakter US-ASCII. Karakter ASCII yang diizinkan disimpan apa adanya, dan saat octet di-percent-encode dipakai format `pct-encoded = "%" HEXDIG HEXDIG`. Karakter non-ASCII tidak boleh dimasukkan langsung sebagai byte literal.
- Harus menyertakan `scheme` dan `:`. Untuk referensi relatif, pakai [URI-RELATIVE-REF](/id/grammar/value/text/uri-relative-ref/) (nomor format IETF `0x8000`·`0x8001`).
- Production URI RFC 3986 tidak mengizinkan string kosong. Record 0 byte tidak valid.
- Dalam WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah WORD terakhir yang tidak dipakai harus `00`.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar

- `URI`, karakter URI, dan tata bahasa percent-encoding mengikuti [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Pasangan kode genap·ganjil, zero padding, serta TAG/Length GEUL dan penataan WORD 16 bit adalah aturan framing format ini.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).

## Contoh

- `https://example.com/` adalah 20 byte ASCII (genap) sehingga `URI-EVEN` (`0x44`).
- Payload adalah 10 WORD `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- TAG 1 WORD ditambah Payload 10 WORD sehingga total 11 WORD dan `LLLL=1010`. Seluruhnya adalah `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## URI Arsip GEUL

`archive.geul.org` adalah rencana penyimpanan konten tak berubah untuk merujuk konten besar seperti biner·dokumen eksternal dari GEUL. Layanan ini belum beroperasi. Format alamat yang dianjurkan adalah `https://archive.geul.org/sha256/{digest}`. Deretan byte yang sama harus memiliki URI yang sama, dan setelah diterbitkan, byte pada URI yang sama tidak boleh diubah.

Value URI hanya menyatakan lokasi atau string alamat konten eksternal, dan tidak menjamin identitas atau sifat tak berubah target itu sendiri. Biner dan teks yang melebihi rentang maksimum Value inline dapat dirujuk dengan URI arsip. Pada metadata objek tersimpan harus dicatat butir berikut.

- URI asli dan waktu pengumpulan
- SHA-256 dan Byte Length
- MIME type
- identifier dan versi lisensi
- penulis, sumber, dan pemberitahuan
- URI dasar lisensi, dan jika perlu salinan dasar pada saat pengumpulan

Layak tidaknya dikumpulkan dinilai bukan dari apakah dapat diakses gratis, melainkan dari apakah hak redistribusi dikonfirmasi secara eksplisit. Syarat lisensi yang berlaku seperti atribusi, nonkomersial, tanpa perubahan, dan share-alike harus dipatuhi. Pada dokumen dan konten dicatat lisensi eksplisit seperti Creative Commons, dan pada perangkat lunak dipakai ID Lisensi SPDX jika memungkinkan.

Walaupun penyediaan dihentikan karena masalah hak atau koreksi, byte lain tidak boleh dimasukkan ke URI yang sudah ada. URI itu harus mengembalikan tombstone yang memuat alasan dan waktu penghentian, serta mempertahankan digest asli dan catatan audit. Namun jika kewajiban hukum melarang pelestarian catatan audit, kewajiban itu diutamakan.

URI arsip menyediakan lokasi akses dan digest konten bersama-sama. Aturan content-address dan sifat tak berubah ini adalah kebijakan profil Arsip GEUL, dan tata bahasa umum Value URI tidak bergantung pada `archive.geul.org`.
