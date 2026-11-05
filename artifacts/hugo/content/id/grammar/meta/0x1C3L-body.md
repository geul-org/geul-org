---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Record yang mengakhiri HEAD dan memulai BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `BODY` (BIND `BODY` pada dokumen spesifikasi) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C30/` (target DECLARE `1C30`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 3 |
| Kind | Meta · kelas: struktur |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | 1 WORD. Mengakhiri HEAD dokumen dan memulai BODY. |
| Sisi Hugo | `meta/structure/body.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Dokumen spesifikasi tidak memiliki FIELD. Tidak ada bidang Payload yang dideklarasikan.

Record yang mengakhiri HEAD dan memulai BODY.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[TAG ekstensi Length]
```

- Codec: Meta `0x1C3L`, kelas struktur
- Payload: tidak ada (1 WORD)
- Jumlah: paling banyak satu per dokumen

## Interpretasi dan validitas {#해석과-유효성}

- Jika HEAD kosong, record ini dihilangkan. Dokumen tanpa `BODY` seluruhnya adalah BODY. Jika HEAD berisi Meta atau Edge HEAD ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) untuk seluruh dokumen beserta QUALIFIER-nya), record ini diletakkan.
- Tidak ada Payload. Totalnya 1 WORD.

## Contoh {#예시}

- `0x1C30`

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C30/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
