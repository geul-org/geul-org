---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS adalah Value berlebar tetap yang memuat nilai alamat MAC IEEE 802 48-bit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS adalah Value berlebar tetap yang memuat nilai alamat MAC IEEE 802 48-bit. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, nomor Codec `0x0000C000`, keluarga BINARY. Payload tepat 3 WORD (6 octet, 48bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  total 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Nomor Codec       2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretasi dan validitas {#해석과-유효성}

- Keenam octet alamat MAC 48-bit dibiarkan dalam urutan octet pada string notasi dan transmisi LAN. Octet 0–1, 2–3, dan 4–5 masing-masing dikelompokkan dari octet atas ke octet bawah suatu WORD.
- Pada media IEEE 802, least-significant bit setiap octet ditransmisikan lebih dulu, tetapi bit di dalam octet tidak dibalik karena alasan itu. I/G dan U/L tetap berada pada least-significant bit octet 0 dan bit berikutnya.
- I/G=0 adalah alamat individual dan digunakan sebagai unicast pada destination, sedangkan I/G=1 adalah alamat group dan digunakan sebagai multicast atau broadcast. U/L=0 adalah alamat universally administered, dan U/L=1 adalah alamat locally administered.
- Tidak ada pola yang dikecualikan secara struktural berdasarkan nilai I/G atau U/L. Alamat universally/locally administered dan individual/group semuanya dapat dinyatakan, dan alamat MAC locally administered, randomized, spoofed, maupun virtual juga dapat dinyatakan sebagai nilai 48bit.
- Nilai ini hanya mempertahankan 48bit dari alamat yang teramati atau disajikan. Nilai ini tidak menjamin alamat permanen perangkat tertentu, keunikan global, autentikasi perangkat atau pengguna, kepemilikan, maupun keterikatan berkelanjutan dengan perangkat yang sama.
- Format ini hanya menangani alamat MAC IEEE 802 yang tepat 48bit. EUI-64 dan alamat MAC 64-bit lainnya tidak dimuat. IEEE RA menjelaskan istilah historis `MAC-48` sebagai obsolete, tetapi tidak semua alamat MAC 48-bit dapat disebut EUI-48, sehingga format ini tidak otomatis disamakan dengan EUI-48.
- Jika Payload tidak tepat 3 WORD, nilai ditolak.

## Dasar standar {#표준-근거}

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) dari IEEE Registration Authority menjelaskan bahwa alamat MAC LAN 48-bit dinotasikan sebagai enam octet dalam urutan transmisi, setiap octet ditransmisikan mulai dari least-significant bit, dan I/G serta U/L adalah dua least-significant bit octet pertama. Format ini mempertahankan posisi octet dan bit apa adanya.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) dari IEEE Registration Authority mendefinisikan I/G=0/1 sebagai individual/group dan U/L=0/1 sebagai universal/local administration, serta menjelaskan bahwa alamat local tidak unik secara global. Dokumen itu juga menjelaskan hubungan istilah historis `MAC-48` dengan EUI-48 beserta perbedaannya.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) menjelaskan bahwa EUI-48 dan EUI-64 dapat digunakan sebagai alamat MAC dan sebagainya. Ini tidak berarti EUI-64 dimasukkan ke dalam record 48-bit ini.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) dan [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) mencatat bahwa perangkat nyata dapat membangkitkan dan mengubah alamat MAC locally administered secara acak. Oleh karena itu, identity perangkat yang permanen tidak disimpulkan hanya dari nilai MAC.
- TAG GEUL, penetapan Issuer, Length langsung, dan framing WORD 16bit bukan bagian dari IEEE 802 maupun bahan di atas, melainkan aturan yang ditambahkan format ini.

## Panjang {#길이}

- Totalnya tepat 8 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 3 WORD, dengan panjang langsung `LLLL=0111`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 3 WORD, nilai ditolak.

## Contoh {#예시}

Alamat locally administered individual (unicast) `02:00:5e:10:00:00` (I/G=0 dan U/L=1 pada octet pertama `0x02`):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
