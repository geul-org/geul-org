---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST adalah Value 11 WORD tetap yang memuat seluruh 160 bit hasil SHA-1, dan hanya dipakai untuk keperluan identifikasi seperti ID objek git."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-1. Kode langsung Value `0x62`, keluarga BINARY. Payload tepat 10 WORD (160 bit) dan pemotongan (truncation) tidak diizinkan.

**Hanya dipakai untuk keperluan identifikasi.** Ketahanan tumbukan SHA-1 sudah rusak (SHAttered 2017). Sebagai dasar integritas·tanda tangan, pakai [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/). Format ini disediakan untuk memuat apa adanya pengenal yang sudah ditetapkan dengan SHA-1, yaitu terutama ID objek (ID commit) repositori git SHA-1. Misalnya, Version (ID commit) pada [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/) dimuat dalam 11 WORD, bukan teks hex (22 WORD).

## Layout

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretasi dan validitas

- 20 octet Payload dibaca apa adanya menurut urutan output SHA-1. Pada setiap WORD, octet atas datang lebih dulu (framing yang sama dengan SHA-256-DIGEST).
- Representasi yang Payload-nya bukan 10 WORD, atau yang hasilnya dipotong sembarangan (ID singkat git, dan lain-lain), ditolak. Tidak ada descriptor dan padding.
- ID objek git adalah nilai yang dihitung git apa adanya. SHA-1 git adalah varian yang menambahkan deteksi tumbukan (SHA-1DC), tetapi untuk input yang bukan serangan tumbukan hasilnya sama dengan SHA-1.

## Dasar standar

- Algoritma SHA-1 dan hasil 160 bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- Framing TAG dan WORD 16 bit GEUL adalah aturan yang ditambahkan format ini.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD dan Payload 10 WORD, dengan `LLLL=1010`. Tidak ada Length extension.

## Contoh

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Halaman terkait

- [Value](/id/grammar/value/), [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/)
