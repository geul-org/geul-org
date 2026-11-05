---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Mencatat pihak yang menulis isi dokumen (git author)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `AUTHOR` (BIND `AUTHOR` pada dokumen spesifikasi) |
| TAG ID | `0x1CBL` |
| Codec ID | `0x00001CB0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001CB0/` (target DECLARE `1CB0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 11 |
| Kind | Meta · kelas: asal-usul |
| TAG WORD | `0001 1100 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Penulis. Reference (git author) |
| Sisi Hugo | `meta/provenance/author.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | record | record apa pun (kecuali penanda slot) |  |

Mencatat pihak yang menulis isi dokumen (git author).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[TAG ekstensi Length]
Payload           satu record Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, dll.)
```

- Codec: Meta `0x1CBL`, kelas asal-usul
- Payload: Reference bawaan
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Reference tidak membatasi Codec. Bisa manusia, organisasi, model, maupun mesin aturan ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), dll.).
- Dokumen yang dipublikasikan geul.org tidak memuat Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](../issuer.md#geulorg-공표)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) diizinkan.
- Jika LOCAL, sasarannya diuraikan di BODY.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001CB0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
