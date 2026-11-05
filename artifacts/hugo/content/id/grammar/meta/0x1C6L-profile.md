---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan profil yang diterapkan pada dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `PROFILE` (BIND `PROFILE` pada dokumen spesifikasi) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C60/` (target DECLARE `1C60`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 6 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Profil yang diterapkan |
| Sisi Hugo | `meta/declaration/profile.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

Mendeklarasikan profil yang diterapkan pada dokumen. Record yang sama ditafsirkan sebagai dokumen Codec yang ditetapkan profil (contoh: jika `tangeul-1.0`, maka [TOULMIN](../toulmin/_index.md)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[TAG ekstensi Length]
Payload           Value UTF8-TEXT "<nama>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, kelas definisi
- Payload: Value bawaan ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Profil dengan major berbeda ditolak. Perbedaan minor diizinkan (hanya perubahan penambahan).
- Jika tidak ada profil, dokumen dibaca hanya dengan tata bahasa dasar GEUL dan spesifikasi kode langsung.

## Contoh {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Masalah terbuka {#열린-문제}

- Registri nama profil (geul.org) dan aturan penamaannya.
- Apakah profil ditunjuk dengan ID dokumen (IMPORT) atau ditaruh sebagai teks.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C60/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
