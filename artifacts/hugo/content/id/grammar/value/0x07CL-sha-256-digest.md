---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-256 dari keluarga SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SHA-256-DIGEST` (dokumen spesifikasi BIND `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000007C0/` (sasaran DECLARE `07C0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 28 |
| Kind | Value · keluarga: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hasil SHA-256 dengan Payload tetap 16 WORD |
| Sisi Hugo | `value/binary/sha-256-digest.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | nilai mentah 16 WORD |  |  |

SHA-256-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-256 dari keluarga SHA-2. Kode langsung Value `0x07CL`, keluarga BINARY. Payload tepat 16 WORD (256 bit) dan pemotongan (truncation) tidak diizinkan.

## Layout {#레이아웃}

```
TAG WORD              0x07CE (0000 0111 1100 1110)  LLLL=1110
Length extension TAG  1 WORD  0x0012 (total 18 WORD)
Payload               16 WORD  SHA-256 Digest
```

## Interpretasi dan validitas {#해석과-유효성}

- 32 octet Payload dibaca dalam urutan keluaran SHA-256 apa adanya. Pada setiap WORD, octet atas datang lebih dulu.
- Konversi endian GEUL tidak diterapkan terpisah pada bit string digest. Urutan octet keluaran hanya dikelompokkan dua octet demi dua octet menjadi WORD big-endian 16 bit.
- Representasi yang Payload-nya bukan 16 WORD atau hasilnya dipotong sembarangan ditolak. Tidak ada descriptor maupun padding.

## Dasar standar {#표준-근거}

- Algoritma SHA-256 dan hasil 256 bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG GEUL, Length, dan framing WORD 16 bit adalah aturan yang ditambahkan format ini dan bukan bagian algoritma SHA-2.

## Panjang {#길이}

- Total adalah tepat 18 WORD, yaitu TAG 1 WORD, Length extension TAG 1 WORD, dan Payload 16 WORD, dan memakai `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload bukan tepat 16 WORD, ditolak.

## Contoh {#예시}

- Octet digest `d[0]` sampai `d[31]` ditempatkan berurutan sebagai WORD Payload `(d[0]<<8)|d[1]` sampai `(d[30]<<8)|d[31]`. Length total selalu 18 WORD.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000007C0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
