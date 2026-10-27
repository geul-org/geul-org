---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value adalah record yang memuat nilai itu sendiri. 2 bit atas Codec adalah keluarganya (bilangan·desimal, waktu, teks, biner), format yang sering dipakai adalah kode langsung, dan sisanya ditaruh sebagai format Issuer per lembaga standar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value adalah record yang memuat nilai itu sendiri. Codec menetapkan interpretasi Payload.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  jika format Issuer
Payload
```

- `LLLL` adalah jumlah WORD total termasuk TAG WORD dikurangi 1. 1~14 WORD adalah panjang langsung, dan 15 WORD atau lebih adalah panjang extension.
- Jika format Issuer, Codec extension TAG berisi Issuer (lebar 1/2/4/16 WORD yang ditetapkan Codec) dan nomor format 1 WORD. 2 bit atas nomor format adalah keluarganya.
- Decoder mengetahui keluarga dan Length walaupun tidak mengenal format.

## Keluarga

2 bit atas Codec adalah keluarganya. Kode langsung (7 bit) dan nomor format Issuer (16 bit) mengikuti aturan yang sama. Karena itu keluarga diketahui tanpa codebook.

| 2 bit atas | Keluarga | Kode langsung | Nomor format |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL dibagi lagi dengan bit ketiga. `000` adalah NUMERIC, dan `001` adalah DECIMAL.
- Nilai numerik seperti vektor, tensor, bilangan kompleks, pecahan, dan interval adalah NUMERIC. Pengecualiannya BIT-VECTOR adalah BINARY. Kode bahasa adalah TEXT.
- Record format Issuer disertai Codec extension TAG (Issuer dan nomor format). Jika Payload panjang (total 15 WORD atau lebih), pakai Length extension TAG.

## Kode langsung

| Codec | Nama | Keluarga | Penjelasan |
|---|---|---|---|
| `0x00` | [BOOL](/id/grammar/value/numeric/bool/) | NUMERIC | false atau true |
| `0x01` | [SIGNED-INTEGER](/id/grammar/value/numeric/signed-integer/) | NUMERIC | Bilangan bulat komplemen 2 dengan WORD minimum |
| `0x02` | [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/) | NUMERIC | Bilangan bulat tanpa tanda dengan WORD minimum |
| `0x03` | [BINARY-FLOAT](/id/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/id/grammar/value/numeric/coordinate-earth/) | NUMERIC | Lintang·bujur Bumi (WGS 84) dan ketidakpastian (Reference satuan) |
| `0x05` | [COORDINATE-GEO](/id/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference benda langit, lintang·bujur, dan ketidakpastian (Reference satuan) |
| `0x06` | [QUANTITY](/id/grammar/value/numeric/quantity/) | NUMERIC | Kuantitas desimal, Reference satuan, batas bawah·atas |
| `0x10` | [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, koefisien bertanda |
| `0x11` | [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, koefisien tanpa tanda |
| `0x20` | [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/) | TIME | Jumlah hari sejak 1970-01-01 (kalender Gregorian) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/id/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanodetik sejak tengah malam |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/) | TIME | Detik sejak epoch Unix |
| `0x23` | [DURATION-SECONDS](/id/grammar/value/time/duration-seconds/) | TIME | Waktu berlalu (detik) |
| `0x24`/`0x25` | [EDTF](/id/grammar/value/time/edtf/) | TIME | String tanggal extended ISO 8601-2 (presisi tahun·bulan, ketidakpastian, interval) |
| `0x26`/`0x27` | [GEDCOM-DATE](/id/grammar/value/time/gedcom-date/) | TIME | String tanggal GEDCOM 7 (kalender lain seperti Julian) |
| `0x40`/`0x41` | [UTF8-TEXT](/id/grammar/value/text/utf8-text/) | TEXT | String UTF-8 tanpa bahasa |
| `0x44`/`0x45` | [URI](/id/grammar/value/text/uri/) | TEXT | URI RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/) | TEXT | Tag bahasa BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/) | TEXT | Kode bahasa terkompresi 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/) | TEXT | Teks dengan bahasa |
| `0x60` | [UUID](/id/grammar/value/binary/uuid/) | BINARY | UUID RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/) | BINARY | Hasil SHA-256 |
| `0x62` | [SHA1-DIGEST](/id/grammar/value/binary/sha1-digest/) | BINARY | Hasil SHA-1 (untuk keperluan identifikasi seperti ID objek git) |

- Kode yang dipasangkan sebagai genap·ganjil adalah deretan byte panjang variabel. Kode genap berarti jumlah byte genap, dan kode ganjil berarti ganjil ([Record dan TAG WORD](/id/grammar/record/)).
- Kode langsung yang tidak ada di tabel adalah cadangan.

## Format Issuer

Format yang tidak ada di kode langsung ditaruh sebagai nomor format di bawah Issuer lembaga yang menetapkannya. Format konvensi tanpa lembaga penetap ditaruh di bawah ADHOC (`0x0001`), dan format khas GEUL di bawah GEUL (`0x0000`).

| Issuer | Contoh format |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, vektor bilangan bulat·riil, tensor, bilangan kompleks, pecahan, interval, kuaternion, BLAKE3 |
| IETF `0x0020` | URI relatif, CRC32C, alamat IPv4·IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, timestamp nanodetik POSIX, alamat MAC |
| KHRONOS `0x0041` | Piksel RGBA8·BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | Timestamp TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | Timestamp GPS |

- Decoder yang tidak mengenal format hanya mengetahui keluarga dari nomor format dan melompati Payload.
- Untuk nilai besar seperti gambar·video, dianjurkan merujuk dengan URI dan SHA-256 daripada memasukkannya langsung.
- Karya yang ada di dalam deretan byte mengikuti lisensi aslinya. Sumber dan lisensi dicatat dengan Meta.

## Kelompok format

Layout, interpretasi, validitas, dan contoh setiap format ada pada dokumen per kelompok.

| Kelompok | Keluarga | Format |
|---|---|---|
| [numeric](/id/grammar/value/numeric/) | NUMERIC | BOOL, bilangan bulat, floating-point, koordinat, QUANTITY |
| [decimal](/id/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/id/grammar/value/time/) | TIME | Tanggal, waktu, timestamp, waktu berlalu, EDTF, tanggal GEDCOM |
| [text](/id/grammar/value/text/) | TEXT | Teks UTF-8, teks dengan bahasa, URI, kode bahasa |
| [binary](/id/grammar/value/binary/) | BINARY | UUID, digest, CRC, alamat jaringan, deretan byte tak dikenal, vektor bit |
| [vector](/id/grammar/value/vector/) | NUMERIC | Vektor padat bilangan bulat·riil, titik·bounding box, piksel RGBA·BGRA |
| [tensor](/id/grammar/value/tensor/) | NUMERIC | Tensor dense·packed dengan format·rank·shape |
| [etc](/id/grammar/value/etc/) | NUMERIC | Bilangan kompleks, pecahan, interval tertutup, kuaternion |

- Kelompok vector, tensor, dan etc seluruhnya adalah format Issuer keluarga NUMERIC (ADHOC, KHRONOS).

## Teks

Teks dengan bahasa dan teks tanpa bahasa adalah nilai yang berbeda. "Paris" (string) dan "Paris" (bahasa Prancis) tidak sama.

| Format | Tempat dipakai |
|---|---|
| UTF8-TEXT | String tanpa bahasa seperti pengenal, kode, nama file, dan ID eksternal |
| UTF8-LANGUAGE-TEXT | Teks dengan bahasa seperti nama, judul, dan kalimat |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = teks berjumlah byte ganjil)
[Length extension TAG]
Bahasa            record LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE
Teks              byte UTF-8 (0x00 terakhir jika ganjil)
```

- Teks adalah UTF-8 well-formed dan dipertahankan apa adanya. Normalisasi ditangani pihak yang membandingkan·mengindeks.
- Nama yang sama untuk beberapa bahasa ditulis dengan bahasa `mul`, dan bahasa yang belum ditentukan dengan `und`. String tanpa konten bahasa adalah UTF8-TEXT.

Contoh: `"Douglas Adams"@en` (13 byte, ganjil)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   bahasa en  D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Desimal dan kuantitas

Desimal yang tepat ditulis sebagai `C × 10^E`. Eksponen `E` adalah 32 bit, dan koefisien `C` adalah komplemen 2 dengan WORD minimum. Jumlah digit notasi asli dimuat apa adanya: `1.20` adalah `C=120, E=−2`, dan `1.2` adalah `C=12, E=−1`. Kedua notasi menyatakan bilangan yang sama tetapi merupakan record terpisah dengan byte berbeda. Encoder tidak menormalisasi notasi secara sembarangan. Kesetaraan nilai dua record dan makna quantum (angka signifikan) adalah masalah terbuka ([SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/#masalah-terbuka)).

QUANTITY memuat kuantitas, satuan, dan batas sebagai satu nilai.

```
TAG WORD          0000 1LLL L000 0110
[Length extension TAG]
Kuantitas         record SIGNED-DECIMAL
Satuan            record Reference (item satuan), 0x0000 jika tanpa satuan
Batas bawah       record SIGNED-DECIMAL, 0x0000 ABSENT jika dihilangkan
Batas atas        record SIGNED-DECIMAL, 0x0000 ABSENT jika dihilangkan
```

- Satuan adalah bagian dari nilai. Satuan tidak dilepas dan ditulis di tempat lain (jika dilepas, tidak diketahui apakah `652` itu km atau m).
- Nilai yang dikonversi ke satuan SI tidak dimuat. Dapat dihitung dari satuan dan tabel konversi.
- `0x0000` adalah ABSENT, penanda bahwa field opsional dihilangkan ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).

Contoh: `652 km`, rentang `[651, 653]` (km = Wikidata Q828224)

```
0F06 0011                    TAG (panjang extension 17 WORD)
0990 0000 0000 028C          kuantitas 652
0120 000C A340               satuan Q828224
0990 0000 0000 028B          batas bawah 651
0990 0000 0000 028D          batas atas 653
```

## Tanggal

| Presisi | Format |
|---|---|
| Tanggal (kalender Gregorian) | GREGORIAN-DATE |
| Tahun·bulan, tidak pasti (`1971~`), interval | EDTF |
| Notasi asli kalender lain (Julian, dan lain-lain) | GEDCOM-DATE |
| Waktu | Timestamp POSIX·TAI·GPS |

- Tanggal yang dapat ditulis sebagai GREGORIAN-DATE tidak ditulis sebagai EDTF.

## Masalah terbuka

- Format media publik (JPEG, PNG, MP4, MOV, dan lain-lain) ditaruh sebagai nomor format BINARY Issuer IANA (`0x0021`). Cara mengelola tabel padanan media type dan nomor format.
- Daftar akhir kode langsung Value. Ditetapkan dengan mengukur frekuensi Value pada sampel undang-undang·percakapan bisnis (kandidat: jumlah uang, persentase, interval tanggal).
- Spesifikasi rinci dan penempatan tujuh scalar kecil (ADHOC BFLOAT16, ONNX FP8 4 jenis, OCP FP8-E8M0FNU·FP4-E2M1FN). Belum ditetapkan apakah dipindah ke rentang cadangan kode langsung NUMERIC (`0x07`~`0x0F`). Saat ini hanya nomor format yang dialokasikan.
