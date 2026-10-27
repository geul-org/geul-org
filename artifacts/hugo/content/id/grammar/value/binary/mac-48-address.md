---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS adalah format Issuer IEEE 6 WORD tetap yang memuat alamat MAC IEEE 802 48 bit apa adanya menurut urutan octet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS adalah Value berlebar tetap yang memuat nilai alamat MAC IEEE 802 48 bit. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, nomor format `0xC000`, keluarga BINARY. Payload tepat 3 WORD (6 octet, 48 bit).

## Layout

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  total 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
Nomor format      1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretasi dan validitas

- Enam octet alamat MAC 48 bit ditaruh apa adanya menurut urutan octet pada string notasi dan transmisi LAN. Octet 0–1, 2–3, dan 4–5 masing-masing dikelompokkan dari octet atas ke octet bawah WORD.
- Pada media IEEE 802, bit paling tidak signifikan setiap octet dikirim lebih dulu, tetapi dengan alasan itu bit di dalam octet tidak dibalik. I/G dan U/L tetap berada pada bit paling tidak signifikan octet 0 dan bit berikutnya.
- I/G=0 adalah alamat individual dan dipakai sebagai unicast pada tujuan, sedangkan I/G=1 adalah alamat group dan dipakai sebagai multicast atau broadcast. U/L=0 adalah alamat universally administered, dan U/L=1 adalah alamat locally administered.
- Tidak ada pola yang dikecualikan secara struktural karena nilai I/G atau U/L. Alamat universally/locally administered dan individual/group semuanya dapat dinyatakan, dan alamat MAC locally administered·randomized·spoofed·virtual juga dapat dinyatakan sebagai nilai 48 bit.
- Nilai ini hanya mempertahankan 48 bit alamat yang diamati atau disajikan. Tidak menjamin alamat permanen perangkat tertentu, keunikan global, autentikasi perangkat·pengguna, kepemilikan, maupun keterikatan berkelanjutan dengan perangkat yang sama.
- Format ini hanya menangani alamat MAC IEEE 802 tepat 48 bit. EUI-64 dan alamat MAC 64 bit lain tidak dimuat. IEEE RA menjelaskan istilah historis `MAC-48` sebagai obsolete, tetapi tidak semua alamat MAC 48 bit dapat disebut EUI-48, sehingga format ini tidak otomatis disamakan dengan EUI-48.
- Jika Payload bukan tepat 3 WORD, ditolak.

## Dasar standar

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) dari IEEE Registration Authority menuliskan alamat MAC LAN 48 bit sebagai enam octet dalam urutan transmisi, dan menjelaskan bahwa setiap octet dikirim mulai dari bit paling tidak signifikan serta I/G dan U/L adalah dua bit paling tidak signifikan octet pertama. Format ini mempertahankan posisi octet dan bit apa adanya.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) dari IEEE Registration Authority mendefinisikan I/G=0/1 sebagai individual/group dan U/L=0/1 sebagai universal/local administration, serta menjelaskan bahwa alamat local tidak unik secara global. Dokumen itu juga menjelaskan hubungan istilah historis dan perbedaan `MAC-48` dengan EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) menjelaskan bahwa EUI-48·EUI-64 dapat dipakai sebagai alamat MAC dan sebagainya. Ini tidak berarti EUI-64 dimasukkan ke record 48 bit ini.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) dan [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) mencatat bahwa perangkat nyata dapat membuat dan mengganti alamat MAC locally administered secara acak. Karena itu identity perangkat yang permanen tidak disimpulkan hanya dari nilai MAC.
- Framing TAG, alokasi Issuer, Length langsung, dan WORD 16 bit GEUL bukan bagian IEEE 802 atau materi di atas melainkan aturan yang ditambahkan format ini.

## Panjang

- Total tepat 6 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 3 WORD, dengan panjang langsung `LLLL=0101`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 3 WORD, ditolak.

## Contoh

Alamat individual (unicast) locally administered `02:00:5e:10:00:00` (I/G=0, U/L=1 pada octet pertama `0x02`):

```
0afc 0040 c000 0200 5e10 0000
```
