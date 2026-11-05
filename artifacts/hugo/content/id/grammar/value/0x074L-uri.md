---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI adalah Value yang memuat deret byte ASCII dengan tata bahasa URI RFC 3986 (URI absolut dengan scheme)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI adalah Value yang memuat deret byte ASCII dengan tata bahasa URI RFC 3986 (URI absolut dengan scheme). Memakai pasangan kode jumlah byte genap·ganjil 0x074L/0x075L.

| Butir | Nilai |
|---|---|
| Nama | `URI` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x074L`·`0x075L` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 20~21 |
| Kind | Value · keluarga: TEXT |
| Deskripsi indeks | Deret byte ASCII production `URI` RFC 3986. Jumlah byte genap·ganjil |
| Sisi Hugo | `value/text/uri.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | genap | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | ganjil | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

URI adalah Value yang memuat deret byte ASCII dengan tata bahasa RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. Karena menyertakan scheme, penafsirannya tidak memerlukan base URI.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x074L` (jumlah byte genap)·`0x075L` (jumlah byte ganjil). Keluarga TEXT.
- Jumlah byte ditentukan oleh bit paling rendah Codec dan jumlah Payload WORD. Rumusnya `2 × jumlah Payload WORD − bit paling rendah`, dan Byte Count tidak dipakai ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretasi dan validitas {#해석과-유효성}

- Deret byte harus sesuai tata bahasa RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]`. Dapat memuat query dan fragment.
- Terminal tata bahasa URI adalah karakter US-ASCII. Karakter ASCII yang diizinkan disimpan apa adanya, dan saat octet di-percent-encode dipakai format `pct-encoded = "%" HEXDIG HEXDIG`. Karakter non-ASCII tidak boleh dimasukkan langsung sebagai literal byte.
- `scheme` dan `:` wajib ada. Untuk referensi relatif, pakai [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) (nomor Codec IETF `0x00008000`·`0x00008001`).
- Production URI RFC 3986 tidak mengizinkan string kosong. Record 0 byte tidak valid.
- Dalam satu WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah yang tidak terpakai pada WORD terakhir harus `00`.
- Jumlah Payload WORD adalah `ceil(jumlah byte/2)`. Jika kode ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar {#표준-근거}

- Tata bahasa `URI`, karakter URI, dan percent-encoding mengikuti [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Pasangan kode genap-ganjil, zero padding, serta penempatan TAG/Length GEUL dan WORD 16 bit adalah aturan framing format ini.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Length](../record.md)).

## Contoh {#예시}

- `https://example.com/` adalah ASCII 20 byte (genap) sehingga `URI-EVEN` (`0x074L`).
- Payload adalah 10 WORD `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- TAG 1 WORD ditambah Payload 10 WORD menjadi total 11 WORD sehingga `LLLL=1010`. Totalnya `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` dirancang sebagai penyimpanan konten tak berubah untuk merujuk konten besar seperti biner dan dokumen eksternal dari GEUL, dan belum dioperasikan. Format alamat yang disarankan adalah `https://archive.geul.org/sha256/{digest}`. Deret byte yang sama harus memiliki URI yang sama, dan setelah dipublikasikan, byte pada URI yang sama tidak boleh diubah.

Value URI hanya menyatakan lokasi atau string alamat konten eksternal, dan tidak menjamin identitas atau ketakberubahan objeknya sendiri. Biner dan teks yang melebihi rentang maksimum Value inline dapat dirujuk dengan archive URI. Metadata objek yang disimpan harus mencatat butir-butir berikut.

- URI asal dan waktu pengumpulan
- SHA-256 dan Byte Length
- MIME type
- license identifier dan version
- pencipta, sumber, dan pemberitahuan
- URI dasar lisensi dan, jika perlu, salinan dasar tersebut pada saat pengumpulan

Layak-tidaknya pengumpulan dinilai bukan dari apakah dapat diakses gratis, melainkan dari apakah hak redistribusi dipastikan secara eksplisit. Syarat lisensi yang berlaku, seperti atribusi, nonkomersial, tanpa perubahan, dan berbagi serupa, harus dipatuhi. Pada dokumen dan konten dicatat lisensi eksplisit seperti Creative Commons, dan pada perangkat lunak dipakai SPDX License ID bila memungkinkan.

Meskipun penyediaan dihentikan karena masalah hak atau koreksi, byte lain tidak boleh dimasukkan ke URI yang sudah ada. URI itu harus mengembalikan tombstone yang memuat alasan dan waktu penghentian, serta menyimpan digest asli dan catatan audit. Namun jika kewajiban hukum melarang penyimpanan catatan audit, kewajiban itu diutamakan.

Archive URI menyediakan lokasi akses dan digest konten sekaligus. Aturan content-address dan ketakberubahan ini adalah kebijakan profil GEUL Archive, dan tata bahasa umum Value URI tidak bergantung pada `archive.geul.org`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000740/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec untuk `URI-EVEN` (`0x074L`). Dokumen Codec anggota lain (`URI-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
