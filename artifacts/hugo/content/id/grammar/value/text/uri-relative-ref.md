---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF adalah Value yang memuat deretan byte ASCII tata bahasa relative-ref RFC 3986. Memakai nomor format 0x8000/0x8001 Issuer IETF."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF adalah Value yang memuat deretan byte ASCII tata bahasa `relative-ref` RFC 3986. Base URI dan hasil resolve tidak dimasukkan ke Payload.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, nomor format `0x8000` (byte genap)·`0x8001` (byte ganjil). Keluarga TEXT.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan nomor format dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0020 (IETF)
Nomor format      1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretasi dan validitas

- Deretan byte harus sesuai dengan tata bahasa `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` RFC 3986.
- Terminal tata bahasa URI adalah karakter US-ASCII. Karakter ASCII yang diizinkan disimpan apa adanya, dan saat octet di-percent-encode dipakai format `pct-encoded = "%" HEXDIG HEXDIG`. Karakter non-ASCII tidak boleh dimasukkan langsung sebagai byte literal.
- Karena `relative-part` dapat berupa `path-empty`, deretan byte kosong juga merupakan `relative-ref` yang valid secara tata bahasa.
- Base URI, resolution context, dan hasil resolve adalah konteks di luar format ini.
- Dalam WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah WORD terakhir yang tidak dipakai harus `00`.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar

- Tata bahasa `relative-ref`, karakter URI, dan percent-encoding mengikuti [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Pasangan kode genap·ganjil, zero padding, serta TAG/Length GEUL dan penataan WORD 16 bit adalah aturan framing format ini. Base URI dan hasil interpretasi referensi adalah konteks RFC tetapi tidak dimasukkan ke Payload.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).
- 0 byte secara makna diizinkan sebagai `relative-ref` kosong dan tidak memiliki WORD Payload. Penataan fisiknya ada pada masalah terbuka di bawah.

## Contoh

- `a/b?x=1` adalah 7 byte (ganjil) sehingga nomor format `0x8001`, Payload `612f 623f 783d 3100`. Total 7 WORD sehingga `LLLL=0110`. Seluruhnya adalah `0B7C 0020 8001 612f 623f 783d 3100`.

## Masalah terbuka

- Penataan fisik `relative-ref` kosong (0 byte). Belum ditetapkan karena record tanpa Payload tidak sesuai dengan aturan "Payload minimum 1 WORD".
