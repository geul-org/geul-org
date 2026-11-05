---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS adalah Value berlebar tetap yang memuat nilai 128bit alamat IPv6."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS adalah Value berlebar tetap yang memuat nilai 128bit alamat IPv6. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000007` IETF, nomor Codec `0x0000C002`, keluarga BINARY. Payload tepat 8 WORD (128bit).

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Nomor Codec       2 WORD  0x0000C002
Payload           8 WORD (128bit)  IPv6 address, high-order bit → low-order bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Kedelapan WORD Payload disambung mulai dari WORD teratas, dan 128bit field alamat IPv6 dibaca sesuai urutannya. Pada setiap WORD, octet yang datang lebih dulu adalah 8bit atas.
- Payload hanya memuat 128bit dari satu alamat. Panjang prefix CIDR, port, dan protokol transport tidak dimuat.
- Zone identifier tidak termasuk dalam 128bit alamat sehingga tidak dimasukkan ke Payload. Scoped address yang memerlukan zone diberikan melalui konteks eksternal seperti interface, Edge, Reference, atau Profile.
- Semua pola 128bit dapat dinyatakan. Makna operasional dan kelayakan pakai pola seperti unspecified, loopback, multicast, khusus, dan reserved dinilai dalam konteks eksternal dan tidak membatasi validitas struktural.
- IPV4-ADDRESS dan IPV6-ADDRESS adalah format yang terpisah. Alamat IPv6 IPv4-mapped juga dipertahankan sebagai nilai IPv6 128bit, dan tidak otomatis disamakan dengan IPV4-ADDRESS maupun dinormalisasi satu sama lain.
- Value ini dapat dipakai sebagai komponen identifier pada Reference, tetapi scope dan kebijakan acuan tidak termuat dalam pola bit alamat.

## Dasar standar {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) mendefinisikan alamat IPv6 sebagai identifier 128bit dan menetapkan format bit alamat, termasuk unicast, anycast, multicast, dan IPv4-mapped IPv6. Format ini mempertahankan 128bit tersebut tanpa menafsirkannya ulang.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) mendefinisikan Source Address dan Destination Address pada paket IPv6 masing-masing sebagai field 128bit. WORD Payload mempertahankan urutan dari high-order bit hingga low-order bit field alamat tersebut.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) menyatakan bahwa zone pada non-global address tidak di-encode dalam alamat itu sendiri, melainkan ditentukan oleh context. Karena itu zone identifier ditempatkan di luar Payload.
- Notasi string pada RFC 4291 hanya dapat dipakai untuk penjelasan serta input dan output. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) tidak menetapkan format penyimpanan internal, sehingga kanonikalisasi string-nya tidak dipakai sebagai kanonikalisasi record biner ini.
- TAG GEUL, penetapan Issuer, Length langsung, dan framing WORD 16bit bukan bagian dari RFC tersebut, melainkan aturan yang ditambahkan format ini.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

Alamat IPv6 `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- Notasi string yang disingkat tidak memengaruhi Payload.
