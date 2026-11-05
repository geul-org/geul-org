---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value adalah record yang memuat nilai itu sendiri."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value adalah record yang memuat nilai itu sendiri. Codec menetapkan penafsiran Payload.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      bagian 3·4 (0x060L~0x09FL)
[Length extension TAG]
[Codec extension TAG]  jika format Issuer
Payload
```

- `LLLL` adalah jumlah WORD total termasuk TAG WORD − 1. 1~14 WORD adalah panjang langsung, 15 WORD atau lebih adalah panjang ekstensi.
- Jika format Issuer, pada Codec extension TAG ditempatkan Issuer (lebar 2/4/16 WORD yang ditetapkan Codec) dan nomor Codec 2 WORD. Nomor Codec ditetapkan oleh Issuer.
- Dekoder yang tidak mengenal formatnya mengetahui hingga Kind, Length, Issuer, dan nomor Codec.

## Keluarga {#계열}

Nomor Value tidak berarti keluarga. Kode langsung tidak menyatakan keluarga lewat bit, dan format Issuer pun tidak memiliki aturan keluarga. Keluarga adalah pengelompokan tema.

| Keluarga | Kode langsung |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Nilai numerik seperti vektor, tensor, bilangan kompleks, pecahan, dan interval adalah NUMERIC. Pengecualiannya BIT-VECTOR yang BINARY. Kode bahasa adalah TEXT.
- Record format Issuer disertai Codec extension TAG (Issuer dan nomor Codec). Jika Payload panjang (total 15 WORD atau lebih), dipakai Length extension TAG.

## Kode langsung {#직접-코드}

| Codec | Nama | Keluarga | Deskripsi |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false atau true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | Bilangan bulat komplemen dua dengan WORD minimum |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | Bilangan bulat tak bertanda dengan WORD minimum |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | Lintang·bujur Bumi (WGS 84) dan ketidakpastian (Reference satuan) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference benda langit, lintang·bujur, dan ketidakpastian (Reference satuan) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | Kuantitas numerik (bilangan bulat·BINARY-FLOAT·desimal·pecahan), Reference satuan, batas bawah·atas |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | Pecahan yang mempertahankan notasi (record pembilang·penyebut, tidak disederhanakan) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, koefisien bertanda |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, koefisien tak bertanda |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | Jumlah hari sejak 1970-01-01 (kalender Gregorian) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | Nanodetik sejak tengah malam |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | Detik sejak Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | Waktu berlalu (detik) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | String tanggal ekstensi ISO 8601-2 (presisi tahun·bulan, ketidakpastian, interval) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | String tanggal GEDCOM 7 (kalender lain seperti Julian) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | String UTF-8 tanpa bahasa |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | Language tag BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | Teks berbahasa |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | Kode bahasa terkompresi 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | Hasil SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | Hasil SHA-1 (untuk identifikasi seperti ID objek git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | Deret byte yang makna·formatnya tidak diketahui. Jumlah byte genap·ganjil |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N bit yang disimpan MSB-first setelah bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | Waktu berlalu (nanodetik) |

- Kode yang dipasangkan genap-ganjil adalah deret byte berpanjang variabel. Kode genap adalah jumlah byte genap, kode ganjil jumlah byte ganjil ([Record dan TAG WORD](../record.md)).
- Kode langsung ada pada `0x060L~0x081L` tanpa Reserved. `0x082L~0x09CL` adalah Reserved dan `0x09DL~0x09FL` adalah [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Format Issuer {#issuer-형식}

Format yang tidak ada di kode langsung ditempatkan sebagai nomor Codec di bawah Issuer lembaga yang menetapkan format itu. Format konvensi yang tidak memiliki lembaga penetap ditempatkan di bawah ADHOC (`0x00000002`). Format khas GEUL (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS) adalah kode langsung.

| Issuer | Contoh format |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, vektor bilangan bulat·riil, tensor, bilangan kompleks, pecahan, interval, kuaternion, BLAKE3 |
| IETF `0x00000007` | URI relatif, CRC32C, alamat IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, timestamp nanodetik POSIX, alamat MAC |
| KHRONOS `0x0000000E` | Piksel RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | Timestamp TAI |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | Timestamp GPS |

- Dekoder yang tidak mengenal formatnya mengetahui hingga Issuer dan nomor Codec, lalu melompatinya dengan Length.
- Dokumen Codec ditempatkan di bawah `codecs/` milik Issuer itu dengan nomor Codec record. Contoh: CRC32C IETF ada di `0x00000007/codecs/0x0000C000/` ([alamat publikasi dan daftar versi](../publishing.md)).
- Nilai besar seperti gambar·video sebaiknya dirujuk dengan URI dan SHA-256, bukan dimasukkan langsung.
- Karya di dalam deret byte mengikuti lisensi aslinya. Sumber dan lisensi dicatat dengan Meta.

## Kelompok format {#형식-묶음}

Penjelasan per kelompok ada di bawah. Layout, interpretasi, validitas, dan contoh tiap format ada di dokumen per format.

| Kelompok | Keluarga | Format |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, bilangan bulat, bilangan titik mengambang, koordinat, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | tanggal, waktu, timestamp, waktu berlalu, EDTF, tanggal GEDCOM |
| [text](#text) | TEXT | teks UTF-8, teks berbahasa, URI, kode bahasa |
| [binary](#binary) | BINARY | UUID, digest, CRC, alamat jaringan, deret byte tak dikenal, bit vector |
| [vector](#vector) | NUMERIC | vektor padat bilangan bulat·riil, titik·bounding box, piksel RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | tensor dense·packed dengan format·rank·shape |
| [etc](#etc) | NUMERIC | bilangan kompleks, pecahan, interval tertutup, kuaternion |

- Kelompok vector, tensor, dan etc seluruhnya adalah format Issuer (ADHOC, KHRONOS) keluarga NUMERIC.

### numeric {#numeric}

Format bilangan dasar keluarga NUMERIC. Ditempatkan pada kode langsung `0x060L~0x067L`.

- Ada BOOL, bilangan bulat bertanda·tak bertanda, bilangan titik mengambang binary IEEE 754, koordinat Bumi (WGS 84)·benda langit, QUANTITY yang menyatukan kuantitas·satuan·batas, dan FRACTION yaitu pecahan dengan notasi asli apa adanya.
- Bilangan bulat ditulis dengan WORD minimum yang dapat memuat nilainya.
- Format skalar kecil Issuer (BFLOAT16, FP8, FP4) hanya diberi nomor Codec dan belum memiliki spesifikasi rinci (masalah terbuka [Value](#열린-문제)).
- Vektor, tensor, bilangan kompleks, pecahan tak tereduksi (RATIONAL-I64), dan interval juga keluarga NUMERIC, tetapi karena format Issuer, ditempatkan pada kelompok [vector](#vector), [tensor](#tensor), [etc](#etc).

### decimal {#decimal}

Keluarga DECIMAL adalah format bilangan desimal eksak. Ditempatkan pada kode langsung `0x068L~0x069L`.

- SIGNED-DECIMAL·UNSIGNED-DECIMAL kode langsung ditulis sebagai `C × 10^E` dan memuat jumlah digit notasi asli apa adanya. `1.20` (`C=120, E=−2`) dan `1.2` (`C=12, E=−1`) adalah record yang berbeda. Kesetaraan nilai dan pelestarian quantum adalah masalah terbuka [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- Encoding DPD·BID IEEE 754 decimal32/64/128 adalah format Issuer IEEE (`0x0000000D`).

### time {#time}

Keluarga TIME adalah format tanggal dan waktu. Ditempatkan pada kode langsung `0x06AL~0x071L` dan `0x081L` (DURATION-NANOSECONDS).

| Presisi | Format |
|---|---|
| Tanggal (kalender Gregorian) | GREGORIAN-DATE |
| Tahun·bulan, ketidakpastian, interval | EDTF |
| Notasi asli kalender lain (Julian dan sebagainya) | GEDCOM-DATE |
| Waktu | Timestamp POSIX·TAI·GPS |
| Waktu berlalu | DURATION-SECONDS, DURATION-NANOSECONDS |

- Tanggal yang dapat ditulis dengan GREGORIAN-DATE tidak ditulis dengan EDTF.
- Timestamp nanodetik dan format TAI·GPS adalah format di bawah Issuer lembaga standar masing-masing (IEEE, BIPM, GPS).

### text {#text}

Keluarga TEXT adalah format teks dan pengenal string. Ditempatkan pada kode langsung `0x072L~0x07AL`.

- String tanpa bahasa adalah UTF8-TEXT, dan teks yang memiliki bahasa seperti nama·judul·kalimat adalah UTF8-LANGUAGE-TEXT.
- Kode bahasa (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) juga keluarga TEXT.
- Deret byte berpanjang variabel ditempatkan sebagai pasangan Codec genap-ganjil. Jika bit paling rendah `1`, jumlah byte ganjil dan byte bawah WORD terakhir adalah padding `0x00` ([Record dan TAG WORD](../record.md)).

### binary {#binary}

Keluarga BINARY adalah format deret byte. Ditempatkan pada kode langsung `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, deret byte tak dikenal (OPAQUE-BYTES), dan bit vector (BIT-VECTOR) adalah kode langsung. Digest lainnya, CRC32C, dan alamat IPv4·IPv6·MAC adalah format Issuer.
- Nilai berukuran tetap (UUID, digest, alamat) ukurannya sudah ditentukan sehingga tidak memiliki pasangan genap-ganjil.
- Media publik seperti gambar·video ditempatkan sebagai format Issuer IANA (`0x00000008`). Nomor Codec ditetapkan sebagai pasangan genap-ganjil dan Payload adalah deret byte. Batas atas Length adalah 2^32−1 WORD. Nilai besar sebaiknya dirujuk dengan URI dan SHA-256, bukan dimasukkan langsung.
- Karya di dalam deret byte mengikuti lisensi aslinya. Sumber dan lisensi dicatat dengan Meta.

### vector {#vector}

Format vektor adalah format Issuer keluarga NUMERIC. Vektor padat bilangan bulat·riil dan titik·bounding box ada di nomor Codec ADHOC (`0x00000002`) `0x00000500`~`0x0000050C`, dan format piksel di bawah KHRONOS (`0x0000000E`).

- Elemen vektor padat disimpan berurutan dalam big-endian.
- Karena format Issuer, pada Codec extension TAG dilekatkan Issuer 2 WORD dan nomor Codec 2 WORD.

### tensor {#tensor}

Format tensor adalah format Issuer keluarga NUMERIC. Ditempatkan pada nomor Codec ADHOC (`0x00000002`) `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR memuat format elemen·rank·shape dan payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR memuat format packed·rank·shape dan payload packed low-bit-first di dalam octet.

### etc {#etc}

Format bilangan lain adalah format Issuer keluarga NUMERIC. Ditempatkan pada nomor Codec ADHOC (`0x00000002`) `0x00000700`~`0x00000704`.

- Ada bilangan kompleks (COMPLEX64, COMPLEX128), pecahan ternormalisasi (RATIONAL-I64), interval tertutup binary64, dan kuaternion binary32.

## Teks {#텍스트}

Teks yang berbahasa dan yang tidak berbahasa adalah nilai yang berbeda. "Paris" (string) dan "Paris" (bahasa Prancis) tidak sama.

| Format | Tempat pemakaian |
|---|---|
| UTF8-TEXT | String tanpa bahasa seperti pengenal, kode, nama berkas, ID eksternal |
| UTF8-LANGUAGE-TEXT | Teks berbahasa seperti nama, judul, kalimat |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = teks berjumlah byte ganjil)
[Length extension TAG]
Bahasa            record LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE
Teks              byte UTF-8 (jika ganjil, 0x00 di akhir)
```

- Teks adalah UTF-8 well-formed dan disimpan apa adanya. Normalisasi ditangani pihak yang membandingkan·mengindeks.
- Nama yang sama untuk banyak bahasa ditulis dengan bahasa `mul`, dan bahasa yang belum ditentukan dengan `und`. String tanpa konten bahasa adalah UTF8-TEXT.

Contoh: `"Douglas Adams"@en` (13 byte, ganjil)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   bhs en     D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Desimal dan kuantitas {#10진수와-수량}

Bilangan desimal eksak ditulis sebagai `C × 10^E`. Eksponen `E` adalah 32 bit, dan koefisien `C` adalah komplemen dua dengan WORD minimum. Jumlah digit notasi asli dimuat apa adanya: `1.20` adalah `C=120, E=−2`, dan `1.2` adalah `C=12, E=−1`. Kedua notasi menyatakan bilangan yang sama tetapi record terpisah dengan byte yang berbeda. Encoder tidak menormalisasi notasi sembarangan. Kesetaraan nilai kedua record dan makna quantum (angka signifikan) adalah masalah terbuka ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY memuat kuantitas, satuan, dan batas sebagai satu nilai.

```
TAG WORD          0000 0110 0110 LLLL
[Length extension TAG]
Kuantitas         record Value numerik (bilangan bulat·BINARY-FLOAT·desimal·pecahan)
Satuan            record Reference (butir satuan), jika tanpa satuan 0x0000
Batas bawah       record Value numerik, jika dihilangkan 0x0000 ABSENT
Batas atas        record Value numerik, jika dihilangkan 0x0000 ABSENT
```

- Satuan adalah bagian dari nilai. Satuan tidak dilepas dan ditulis di tempat lain (jika dilepas, tidak diketahui apakah `652` itu km atau m).
- Nilai yang dikonversi ke satuan SI tidak dimuat. Dapat dihitung dari satuan dan tabel konversi.
- `0x0000` adalah penanda ABSENT bahwa field opsional dihilangkan ([dokumen spesifikasi Codec](../codec-spec.md)).

Contoh: `652 km`, rentang `[651, 653]` (km = Wikidata Q828224)

```
066E 0011                    TAG (panjang ekstensi 17 WORD)
0683 0000 0000 028C          kuantitas 652
0142 000C A340               satuan Q828224
0683 0000 0000 028B          batas bawah 651
0683 0000 0000 028D          batas atas 653
```

## Tanggal {#날짜}

| Presisi | Format |
|---|---|
| Tanggal (kalender Gregorian) | GREGORIAN-DATE |
| Tahun·bulan, ketidakpastian (`1971~`), interval | EDTF |
| Notasi asli kalender lain (Julian dan sebagainya) | GEDCOM-DATE |
| Waktu | Timestamp POSIX·TAI·GPS |

- Tanggal yang dapat ditulis dengan GREGORIAN-DATE tidak ditulis dengan EDTF.

## Masalah terbuka {#열린-문제}

- Format media publik (JPEG, PNG, MP4, MOV, dan sebagainya) ditempatkan sebagai nomor Codec Issuer IANA (`0x00000008`). Cara mengelola tabel korespondensi tipe media dan nomor Codec.
- Daftar akhir kode langsung Value. Ditetapkan dengan mengukur frekuensi Value pada sampel peraturan perundang-undangan dan percakapan kerja (kandidat: jumlah uang, persentase, interval tanggal).
- Spesifikasi rinci dan penempatan 7 skalar kecil (ADHOC BFLOAT16, ONNX FP8 4 jenis, OCP FP8-E8M0FNU·FP4-E2M1FN). Belum ditetapkan apakah dipindahkan ke kode langsung. Saat ini hanya nomor Codec yang ditetapkan.
