---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat lisensi dokumen ini dan karya yang ada di dalam rangkaian byte."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `LICENSE` (BIND `LICENSE` pada dokumen spesifikasi) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DE0/` (target DECLARE `1DE0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 30 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Lisensi. Reference |
| Sisi Hugo | `meta/policy/license.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Mencatat lisensi dokumen ini dan karya yang ada di dalam rangkaian byte.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[TAG ekstensi Length]
Payload           Reference yang menunjuk lisensi, atau UTF8-TEXT pengenal SPDX, atau Value URI
```

- Codec: Meta `0x1DEL`, kelas kebijakan
- Payload: Reference atau Value bawaan ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Dokumen yang dipublikasikan geul.org berlisensi CC0. Publikasi privat ditentukan oleh Issuer ([Issuer](../issuer.md)).
- Catat lisensi asli dari karya sumber.

## Masalah terbuka {#열린-문제}

- Apakah pengenal SPDX ditaruh sebagai teks atau sebagai Reference entitas GEUL.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DE0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
