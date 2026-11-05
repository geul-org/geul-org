---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF adalah Value yang memuat byte string ASCII sesuai tata bahasa relative-ref RFC 3986."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF adalah Value yang memuat byte string ASCII sesuai tata bahasa `relative-ref` RFC 3986. Base URI dan hasil resolve tidak dimasukkan ke Payload.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000007` IETF, nomor Codec `0x00008000` (jumlah byte genap) dan `0x00008001` (jumlah byte ganjil). Keluarga TEXT.
- Jumlah byte ditentukan oleh bit paling bawah nomor Codec dan jumlah WORD Payload, yaitu `2 × jumlah WORD Payload − bit paling bawah`, dan Byte Count tidak disediakan ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000007 (IETF)
Nomor Codec       2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretasi dan validitas {#해석과-유효성}

- Byte string harus sesuai dengan tata bahasa `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` pada RFC 3986.
- Terminal pada tata bahasa URI adalah karakter US-ASCII. Karakter ASCII yang diizinkan disimpan apa adanya, dan saat octet di-percent-encode dipakai bentuk `pct-encoded = "%" HEXDIG HEXDIG`. Karakter non-ASCII tidak boleh dimasukkan langsung sebagai literal byte.
- Karena `relative-part` dapat berupa `path-empty`, byte string kosong juga merupakan `relative-ref` yang valid secara tata bahasa.
- Base URI, resolution context, dan hasil resolve merupakan konteks di luar format ini.
- Di dalam WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah yang tidak terpakai pada WORD terakhir harus `00`.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, nilai ditolak.

## Dasar standar {#표준-근거}

- Tata bahasa `relative-ref`, karakter URI, dan percent-encoding mengikuti [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Pasangan kode genap-ganjil, zero padding, serta TAG/Length GEUL dan penempatan WORD 16 bit adalah aturan framing format ini. Base URI dan hasil interpretasi acuan merupakan konteks RFC, tetapi tidak dimasukkan ke Payload.

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi juga dihitung dalam total ([Length](../../record.md)).
- 0 byte secara makna diizinkan sebagai `relative-ref` kosong dan tidak memiliki WORD Payload. Penempatan fisiknya adalah masalah terbuka di bawah.

## Contoh {#예시}

- `a/b?x=1` terdiri atas 7 byte (ganjil) sehingga nomor Codec-nya `0x00008001` dan Payload-nya `612F 623F 783D 3100`. Totalnya 9 WORD sehingga `LLLL=1000`. Keseluruhannya adalah `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Masalah terbuka {#열린-문제}

- Penempatan fisik `relative-ref` kosong (0 byte). Record tanpa Payload tidak sesuai dengan aturan 'Payload minimum 1 WORD', sehingga belum ditetapkan.
