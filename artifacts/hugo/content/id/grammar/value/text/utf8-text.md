---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT adalah Value yang memuat string UTF-8 tanpa bahasa. Memakai pasangan kode byte genap·ganjil 0x40/0x41."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT adalah Value yang memuat deretan byte UTF-8 valid menurut RFC 3629. Dipakai untuk string tanpa bahasa seperti pengenal, kode, dan nama file.

## Layout

- Kode: kode langsung Value `0x40` (byte genap)·`0x41` (byte ganjil). Keluarga TEXT.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretasi dan validitas

- Deretan byte harus UTF-8 well-formed shortest-form yang sesuai dengan tata bahasa RFC 3629. Hasil dekode hanya memuat Unicode scalar value dalam rentang `U+0000..U+10FFFF`, dan tidak memuat rentang surrogate `U+D800..U+DFFF`.
- RFC 3629 menjelaskan penanganan signature U+FEFF di depan menurut konteks. Profil kanonik GEUL di samping itu melarang deretan byte BOM UTF-8 `EF BB BF` di awal Payload. U+FEFF di posisi lain adalah karakter, bukan BOM, sehingga tidak dilarang oleh aturan ini.
- Normalisasi Unicode tidak dipaksakan. Urutan scalar teks asli hasil dekode dipertahankan apa adanya.
- Deretan byte UTF-8 yang valid ditaruh pada Payload tanpa konversi. Dalam WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah WORD terakhir yang tidak dipakai harus `00`.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar

- Rentang scalar UTF-8, deretan byte well-formed, dan makna penanganan BOM mengikuti [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Larangan BOM, pasangan kode genap·ganjil, zero padding, serta TAG/Length GEUL dan penataan WORD 16 bit adalah aturan framing kanonik format ini.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).
- String 0 byte ditulis sebagai record 1 WORD (hanya TAG WORD) dari kode genap ([Value](/id/grammar/value/)).

## Contoh

- `A` (`41`) adalah 1 byte (ganjil) sehingga `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, total 2 WORD, `LLLL=0001`. Seluruhnya adalah `08C1 4100`.
- String kosong adalah 1 WORD `0840` (`UTF8-TEXT-EVEN`, hanya TAG WORD).
