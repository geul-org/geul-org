---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat cakupan dan dasar persetujuan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CONSENT` (BIND `CONSENT` pada dokumen spesifikasi) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E20/` (target DECLARE `1E20`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 2 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Cakupan dan dasar persetujuan |
| Sisi Hugo | `meta/policy/consent.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Mencatat cakupan dan dasar persetujuan.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[TAG ekstensi Length]
Payload           Reference atau teks yang menunjuk dasar persetujuan
```

- Codec: Meta `0x1E2L`, kelas kebijakan
- Payload: Reference atau Value bawaan
- Jumlah: dapat lebih dari satu

## Masalah terbuka {#열린-문제}

- Struktur representasi cakupan (tujuan, jangka waktu, penyediaan kepada pihak ketiga).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E20/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
