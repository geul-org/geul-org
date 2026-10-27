---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID adalah Value 9 WORD tetap yang memuat nilai 128 bit UUID RFC 9562 apa adanya dalam 16 octet kanonik."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID adalah Value berlebar tetap yang memuat nilai 128 bit UUID RFC 9562. Kode langsung Value `0x60`, keluarga BINARY. Payload tepat 8 WORD (16 octet, 128 bit).

## Layout

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  total 9 WORD
Payload           8 WORD (128 bit)  UUID octet 0 → octet 15
```

## Interpretasi dan validitas

- Octet 0 sampai octet 15 UUID kanonik RFC 9562 dikelompokkan berurutan dua octet. Octet yang datang lebih dulu adalah 8 bit atas WORD. Field, bit version, dan bit variant UUID tidak disusun ulang atau di-encode ulang.
- String hex-dan-dash `8-4-4-4-12` hanya representasi input/output. Huruf besar-kecil atau dash tidak masuk ke Payload, dan yang disimpan hanya 16 octet hasil parsing.
- Value UUID ini mempertahankan pola 128 bit tanpa kehilangan. Pada variant RFC 9562 `10xx`, version 1, 3, 4, 5, 6, 7 adalah layout standar dan version 8 adalah format UUID kustom. Version 2 dicadangkan untuk DCE Security sehingga RFC tidak menetapkan layout-nya, version 0 adalah unused, dan version 9–15 dicadangkan untuk definisi masa depan. Variant lain juga dicadangkan untuk kompatibilitas atau definisi masa depan.
- Nil UUID adalah nilai khusus 128 bit semuanya nol, dan Max UUID adalah 128 bit semuanya satu. Pola 128 bit termasuk version/variant cadangan·unused tidak dikecualikan secara struktural, dan makna serta interoperabilitas pola itu dinilai dari standar yang berlaku dan konteks eksternal.
- Identitas UUID dinilai dari apakah nilai 128 bit Payload sama. Fakta bahwa nilainya sama tidak menjamin autentikasi, kepemilikan, keberadaan saat ini, kemampuan diselesaikan, atau hak akses target.
- Saat menyimpan GUID COM Microsoft, representasi memori·serialisasi mixed-endian tidak disalin apa adanya. Ubah lebih dulu menjadi 16 octet dalam urutan field/octet kanonik RFC 9562.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Dasar standar

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) mendefinisikan UUID sebagai 16 octet (128 bit), dan meng-encode field most-significant-byte-first sehingga disambung dalam urutan field big-endian pada format biner. Variant ada di bit atas octet 8 dan version di 4 bit atas octet 6, dan format ini mempertahankan posisi itu apa adanya.
- RFC 9562 Sections 4.1–5.10 membedakan variant dan version 1–8, Nil, Max, serta rentang cadangan. RFC 9562 menggantikan RFC 4122 sehingga norma berlaku format ini adalah RFC 9562.
- ABNF hex-dan-dash RFC 9562 adalah representasi teks, dan caveat little-endian GUID COM juga dinyatakan terpisah. GEUL hanya memasukkan 16 octet kanonik UUID RFC ke Payload.
- Framing TAG, Length langsung, dan WORD 16 bit GEUL bukan bagian RFC 9562 melainkan aturan yang ditambahkan format ini.

## Panjang

- Total tepat 9 WORD, yaitu jumlah TAG 1 WORD dan Payload 8 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

Test vector UUIDv7 `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` dari RFC 9562 Appendix A.6:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
