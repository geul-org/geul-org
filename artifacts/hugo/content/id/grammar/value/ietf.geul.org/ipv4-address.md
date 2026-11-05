---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS adalah Value berlebar tetap yang memuat nilai 32bit alamat IPv4."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS adalah Value berlebar tetap yang memuat nilai 32bit alamat IPv4. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000007` IETF, nomor Codec `0x0000C001`, keluarga BINARY. Payload tepat 2 WORD (32bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Nomor Codec       2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretasi dan validitas {#해석과-유효성}

- Octet alamat dibiarkan dalam network byte order. Pada setiap WORD, octet yang datang lebih dulu adalah 8bit atas dan octet berikutnya adalah 8bit bawah.
- Payload hanya memuat 32bit dari satu alamat. Panjang prefix CIDR, port, dan protokol transport tidak dimuat.
- Semua pola 32bit dapat dinyatakan. Makna operasional dan kelayakan pakai pola seperti unspecified, khusus, reserved, dan multicast dinilai dalam konteks eksternal dan tidak membatasi validitas struktural.
- IPV4-ADDRESS dan IPV6-ADDRESS adalah format yang terpisah. Alamat IPv6 IPv4-mapped tidak otomatis dikonversi ke format ini atau dinormalisasi menjadi nilai yang sama.
- Value ini dapat dipakai sebagai komponen identifier pada Reference, tetapi kebijakan acuan dan masa berlakunya tidak termuat dalam pola bit alamat.
- Jika Payload tidak tepat 2 WORD, nilai ditolak.

## Dasar standar {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) mendefinisikan alamat IPv4 sebagai 4 octet (32bit) dengan panjang tetap, serta Source Address dan Destination Address masing-masing sebagai field 32bit. Urutan transmisi octet pada Appendix B dan aturan most-significant-bit-first setiap octet dipertahankan pada Payload.
- TAG GEUL, penetapan Issuer, pengelompokan WORD 16bit, dan Length bukan bagian dari RFC 791, melainkan aturan framing yang ditambahkan format ini.

## Panjang {#길이}

- Totalnya tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 2 WORD, nilai ditolak.

## Contoh {#예시}

Alamat IPv4 `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
