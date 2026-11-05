---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen codec yang dipublikasikan Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen codec yang dipublikasikan Issuer. Dokumen codec tidak memiliki ID dokumen, dan menunjuk dirinya serta versinya dengan CODEC-POINTER.

| Butir | Nilai |
|---|---|
| Nama | `CODEC-POINTER` (BIND `CODEC-POINTER` pada dokumen spesifikasi) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000420/` (target DECLARE `0420`) |
| Bagian | 2 `0010` (Reference lainnya), offset C dalam bagian = 2 |
| Kind | Reference · klasifikasi: penunjuk-deklarasi |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Satu versi codec Issuer. Issuer + Codec ID 2 WORD + ID versi 2 WORD, tanpa ID target |
| Sisi Hugo | `reference/codec-pointer.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | nilai mentah 2 WORD |  |  |
| 3 | `version` | #4 | nilai mentah 2 WORD |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[TAG ekstensi Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID versi          2 WORD
```

## Interpretasi dan validitas {#해석과-유효성}

- Lebar Issuer adalah sisa Payload setelah dikurangi 4 WORD untuk Codec ID dan ID versi. Payload adalah salah satu dari 6, 8, 20 WORD, dan panjang lain adalah invalid. Jika nilai Issuer muat dalam lebar yang lebih sempit, itu invalid (bentuk kanonik Issuer).
- Jika Issuer 16 WORD, totalnya 21 WORD sehingga 1 WORD ekstensi Length ditambahkan.
- Codec ID berukuran 32 bit. Codec ID kode langsung GEUL adalah nilai TAG WORD-nya (L=0) yang ditulis dalam 32 bit (TRIPLE `0x0AAL` → `0x00000AA0`). Codec ID codec Issuer adalah nomor Codec pada record, dan Issuer menetapkannya agar tidak tumpang tindih di dalam `codecs/` miliknya, tanpa memandang Kind ([alamat publikasi dan daftar versi](../publishing.md#id-표기)).
- ID versi `0` adalah versi terbaru. Nilai lainnya terkunci pada versi itu.
- Satu slot Codec `0x042L`. Tidak ada kuantifikasi (Identified). Karena bagian 2, ia tidak dibaca sebagai kuantifikasi·sistem.
- Tempat pemakaian: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) dokumen codec, [PUBLICATION](../edge/0x0B8L-publication.md)·DEPRECATION·TOMBSTONE pada daftar versi codec, dan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) yang mengimpor dokumen codec. Pada posisi-posisi ini ia menggantikan DOC-POINTER.
- Alamat publikasi adalah `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID versi>.geul` ([alamat publikasi dan daftar versi](../publishing.md#공표-주소)).

## Contoh {#예시}

Codec TRIPLE (Codec ID `0x00000AA0`) milik Issuer GEUL `0x00000000`.

| Versi | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| Terbaru (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID versi 2 = 7 WORD, `LLLL=0110`. TAG adalah `0000 0100 0010 0110` = `0426`.

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Dokumen spesifikasi Codec](../codec-spec.md)
- [Alamat publikasi dan daftar versi](../publishing.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000420/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
