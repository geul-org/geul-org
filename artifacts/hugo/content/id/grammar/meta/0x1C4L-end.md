---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Record yang menutup dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `END` (BIND `END` pada dokumen spesifikasi) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C40/` (target DECLARE `1C40`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 4 |
| Kind | Meta · kelas: struktur |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | 1 WORD. Menutup dokumen. |
| Sisi Hugo | `meta/structure/end.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Dokumen spesifikasi tidak memiliki FIELD. Tidak ada bidang Payload yang dideklarasikan.

Record yang menutup dokumen.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[TAG ekstensi Length]
```

- Codec: Meta `0x1C4L`, kelas struktur
- Payload: tidak ada (1 WORD)
- Jumlah: satu per dokumen, di paling akhir

## Interpretasi dan validitas {#해석과-유효성}

- Wajib. Posisinya diperiksa dengan panjang [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- Jika input berakhir tanpa END, dokumen itu terpotong. Apakah isi dokumen terpotong dianggap valid adalah kebijakan dekoder.
- Tidak ada apa pun setelahnya.

## Contoh {#예시}

- `0x1C40`

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C40/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
