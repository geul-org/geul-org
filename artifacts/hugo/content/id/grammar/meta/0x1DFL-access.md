---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Mencatat cakupan keterbukaan dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `ACCESS` (BIND `ACCESS` pada dokumen spesifikasi) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DF0/` (target DECLARE `1DF0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 31 |
| Kind | Meta · kelas: kebijakan |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Cakupan keterbukaan |
| Sisi Hugo | `meta/policy/access.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | nilai mentah 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Mencatat cakupan keterbukaan dokumen.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[TAG ekstensi Length]
tingkat           1 WORD (0 publik, 1 internal, 2 rahasia, selain itu Reserved)
```

- Codec: Meta `0x1DFL`, kelas kebijakan
- Payload: nilai mentah (tingkat 1 WORD)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Dokumen rahasia tidak dipublikasikan ([Issuer](../issuer.md)).
- Tidak mengubah interpretasi. Hanya menentukan penanganan.

## Masalah terbuka {#열린-문제}

- Tabel kode tingkat.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DF0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
