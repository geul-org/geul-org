---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Mendeklarasikan kunci publik Issuer yang diterbitkan sendiri (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `ISSUER-KEY` (BIND `ISSUER-KEY` pada dokumen spesifikasi) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E50/` (target DECLARE `1E50`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 5 |
| Kind | Meta · kelas: verifikasi |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi ID algoritma tanda tangan dan kunci publik Issuer yang diterbitkan sendiri |
| Sisi Hugo | `meta/verification/issuer-key.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | nilai mentah 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

Mendeklarasikan kunci publik Issuer yang diterbitkan sendiri (16 WORD). ID Issuer = SHA-256("GEUL-ISSUER-v1" ‖ ID algoritma ‖ kunci publik) ([Issuer 16 WORD](../issuer.md#16-word-issuer)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[TAG ekstensi Length]
ID algoritma      1 WORD (0x0001 = Ed25519)
kunci publik      lebar yang ditentukan algoritma (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`, kelas verifikasi
- Payload: nilai mentah (ID algoritma + kunci publik)
- Jumlah: dapat lebih dari satu (penggantian kunci)

## Interpretasi dan validitas {#해석과-유효성}

- Karena kelas verifikasi, dikeluarkan dari hash isi.
- Issuer 2 dan 4 WORD memakai kunci yang didaftarkan di geul.org, sehingga tidak diperlukan.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E50/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
