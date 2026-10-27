---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS adalah format Issuer IETF 11 WORD tetap yang memuat alamat IPv6 128 bit menurut urutannya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS adalah Value berlebar tetap yang memuat nilai 128 bit alamat IPv6. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, nomor format `0xC002`, keluarga BINARY. Payload tepat 8 WORD (128 bit).

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0020 (IETF)
Nomor format      1 WORD  0xC002
Payload           8 WORD (128 bit)  IPv6 address, high-order bit → low-order bit
```

## Interpretasi dan validitas

- Delapan WORD Payload disambung mulai dari WORD atas, dan 128 bit field alamat IPv6 dibaca menurut urutannya. Pada setiap WORD, octet yang datang lebih dulu adalah 8 bit atas.
- Payload hanya memuat 128 bit satu alamat. Panjang prefiks CIDR, port, dan protokol transport tidak dimuat.
- Zone identifier tidak ada di dalam 128 bit alamat sehingga tidak dimasukkan ke Payload. Scoped address yang memerlukan zone diberikan melalui konteks eksternal seperti interface atau Edge·Reference·Profile.
- Semua pola 128 bit dapat dinyatakan. Makna operasional dan ketersediaan pola unspecified·loopback·multicast·khusus·cadangan dinilai dari konteks eksternal dan tidak membatasi validitas struktural.
- IPV4-ADDRESS dan IPV6-ADDRESS adalah format terpisah. Alamat IPv6 IPv4-mapped juga dipertahankan sebagai nilai IPv6 128 bit dan tidak otomatis disamakan dengan IPV4-ADDRESS atau dinormalisasi satu sama lain.
- Value ini dapat dipakai sebagai komponen pengenal Reference, tetapi scope dan kebijakan acuan tidak ada di dalam pola bit alamat.

## Dasar standar

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) mendefinisikan alamat IPv6 sebagai pengenal 128 bit, dan menetapkan format bit alamat termasuk unicast·anycast·multicast serta IPv4-mapped IPv6. Format ini mempertahankan 128 bit itu tanpa menginterpretasikannya ulang.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) mendefinisikan Source Address dan Destination Address paket IPv6 masing-masing sebagai field 128 bit. WORD Payload mempertahankan urutan dari high-order bit sampai low-order bit field alamat itu.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) menyatakan bahwa zone alamat non-global tidak di-encode pada alamat itu sendiri melainkan ditetapkan oleh konteks. Karena itu zone identifier ditaruh di luar Payload.
- Notasi string RFC 4291 hanya dapat dipakai untuk penjelasan dan input/output. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) tidak menetapkan format penyimpanan internal sehingga kanonikalisasi string-nya tidak dipakai sebagai kanonikalisasi record biner ini.
- Framing TAG, alokasi Issuer, Length langsung, dan WORD 16 bit GEUL bukan bagian RFC-RFC ini melainkan aturan yang ditambahkan format ini.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

Alamat IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- Notasi singkat string tidak memengaruhi Payload.
