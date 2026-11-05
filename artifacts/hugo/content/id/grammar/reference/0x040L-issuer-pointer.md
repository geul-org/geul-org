---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER adalah Reference penunjuk-deklarasi yang menunjuk Issuer itu sendiri."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `ISSUER-POINTER` (BIND `ISSUER-POINTER` pada dokumen spesifikasi) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000400/` (target DECLARE `0400`) |
| Bagian | 2 `0010` (Reference lainnya), offset C dalam bagian = 0 |
| Kind | Reference · klasifikasi: penunjuk-deklarasi |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Sisi Hugo | `reference/issuer-pointer.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

ISSUER-POINTER adalah Reference penunjuk-deklarasi yang menunjuk Issuer itu sendiri. Ia menjadi target `BIND` nama Issuer, `LABEL`, dan Edge penilaian.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[TAG ekstensi Length]
Issuer            2/4/16 WORD
```

- Lebar Issuer adalah seluruh Payload. Codec tidak membagi lebar. Jika lebar bukan 2, 4, 16 WORD, atau nilai Issuer muat dalam lebar yang lebih sempit, itu invalid (bentuk kanonik Issuer).
- Jika Issuer 16 WORD, totalnya 17 WORD sehingga 1 WORD ekstensi Length ditambahkan.
- Satu slot Codec `0x040L`. Tidak ada kuantifikasi (Identified).
- Nilai Issuer mengikuti penetapan [Issuer](../issuer.md).
- Pemakaian: Subject BIND pada `issuers/` daftar Issuer ([alamat publikasi dan daftar versi](../publishing.md#issuer-목록)), LABEL nama tampilan Issuer, penilaian terhadap Issuer, penanda tangan, dan posisi lain tempat Issuer itu sendiri menjadi target.
- Bentuk untuk menunjuk Issuer itu sendiri hanya satu, yaitu ISSUER-POINTER. Menunjuk Issuer dengan `EXTERNAL-ISSUER-*` memakai ID dokumen `0` dan ID target `0` adalah invalid.

## Contoh {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000400/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
