---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SHA1-DIGEST` (dokumen spesifikasi BIND `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000007D0/` (sasaran DECLARE `07D0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 29 |
| Kind | Value · keluarga: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hasil SHA-1 dengan Payload tetap 10 WORD. Hanya untuk keperluan identifikasi seperti ID objek git |
| Sisi Hugo | `value/binary/sha1-digest.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | nilai mentah 10 WORD |  |  |

SHA1-DIGEST adalah Value berlebar tetap yang memuat seluruh hasil SHA-1. Kode langsung Value `0x07DL`, keluarga BINARY. Payload tepat 10 WORD (160 bit) dan pemotongan (truncation) tidak diizinkan.

**Hanya dipakai untuk identifikasi.** Ketahanan tabrakan SHA-1 telah runtuh (SHAttered 2017). Sebagai dasar integritas·tanda tangan, pakai [SHA-256-DIGEST](0x07CL-sha-256-digest.md). Format ini disediakan untuk memuat apa adanya pengenal yang sudah ditetapkan dengan SHA-1, terutama ID objek (ID commit) repositori git SHA-1. Misalnya, Version (ID commit) pada [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) dimuat dalam 11 WORD, bukan teks hex (22 WORD).

## Layout {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretasi dan validitas {#해석과-유효성}

- 20 octet Payload dibaca dalam urutan keluaran SHA-1 apa adanya. Pada setiap WORD, octet atas datang lebih dulu (framing yang sama dengan SHA-256-DIGEST).
- Representasi yang Payload-nya bukan 10 WORD atau hasilnya dipotong sembarangan (ID singkat git dan sebagainya) ditolak. Tidak ada descriptor maupun padding.
- ID objek git adalah nilai yang dihitung git apa adanya. SHA-1 pada git adalah varian dengan deteksi tabrakan (SHA-1DC), tetapi untuk masukan yang bukan serangan tabrakan hasilnya sama dengan SHA-1.

## Dasar standar {#표준-근거}

- Algoritma SHA-1 dan hasil 160 bit mengikuti NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG GEUL dan framing WORD 16 bit adalah aturan yang ditambahkan format ini.

## Panjang {#길이}

- Total adalah tepat 11 WORD, yaitu TAG 1 WORD ditambah Payload 10 WORD, dan memakai `LLLL=1010`. Tidak ada Length extension.

## Contoh {#예시}

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000007D0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
