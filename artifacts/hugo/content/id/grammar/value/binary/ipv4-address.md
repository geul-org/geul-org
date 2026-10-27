---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS adalah format Issuer IETF 5 WORD tetap yang memuat alamat IPv4 32 bit apa adanya dalam network byte order."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS adalah Value berlebar tetap yang memuat nilai 32 bit alamat IPv4. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, nomor format `0xC001`, keluarga BINARY. Payload tepat 2 WORD (32 bit).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Nomor format      1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretasi dan validitas

- Octet alamat ditaruh apa adanya dalam network byte order. Pada setiap WORD, octet yang datang lebih dulu adalah 8 bit atas, dan octet berikutnya adalah 8 bit bawah.
- Payload hanya memuat 32 bit satu alamat. Panjang prefiks CIDR, port, dan protokol transport tidak dimuat.
- Semua pola 32 bit dapat dinyatakan. Makna operasional dan ketersediaan pola seperti unspecified·khusus·cadangan·multicast dinilai dari konteks eksternal dan tidak membatasi validitas struktural.
- IPV4-ADDRESS dan IPV6-ADDRESS adalah format terpisah. Alamat IPv6 IPv4-mapped tidak dikonversi otomatis ke format ini atau dinormalisasi menjadi nilai yang sama.
- Value ini dapat dipakai sebagai komponen pengenal Reference, tetapi kebijakan acuan dan masa berlakunya tidak ada di dalam pola bit alamat.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Dasar standar

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) mendefinisikan alamat IPv4 sebagai 4 octet (32 bit) berpanjang tetap, serta Source Address dan Destination Address masing-masing sebagai field 32 bit. Urutan pengiriman octet pada Appendix B dan aturan most-significant-bit-first setiap octet dipertahankan pada Payload.
- Framing TAG, alokasi Issuer, pengelompokan WORD 16 bit, dan Length GEUL bukan bagian RFC 791 melainkan aturan framing yang ditambahkan format ini.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Contoh

Alamat IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
