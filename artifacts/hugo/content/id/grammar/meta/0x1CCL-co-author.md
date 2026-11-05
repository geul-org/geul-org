---
title: "CO-AUTHOR (0x1CCL)"
weight: 460
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Mencatat pihak yang menulis dokumen bersama (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CO-AUTHOR` (BIND `CO-AUTHOR` pada dokumen spesifikasi) |
| TAG ID | `0x1CCL` |
| Codec ID | `0x00001CC0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001CC0/` (target DECLARE `1CC0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 12 |
| Kind | Meta · kelas: asal-usul |
| TAG WORD | `0001 1100 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Penulis bersama. Reference (git `Co-authored-by`) |
| Sisi Hugo | `meta/provenance/co-author.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | record | record apa pun (kecuali penanda slot) |  |

Mencatat pihak yang menulis dokumen bersama (git `Co-authored-by`).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1100 LLLL      Codec 0x1CCL
[TAG ekstensi Length]
Payload           satu record Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, dll.)
```

- Codec: Meta `0x1CCL`, kelas asal-usul
- Payload: Reference bawaan
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Reference tidak membatasi Codec. Bisa manusia, organisasi, model, maupun mesin aturan ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), dll.).
- Dokumen yang dipublikasikan geul.org tidak memuat Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](../issuer.md#geulorg-공표)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) diizinkan.
- Jika LOCAL, sasarannya diuraikan di BODY.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001CC0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CC000000000
BODY
#1 DECLARE 0x1CC0
#2 FIELD #1 record
#3 BIND #1 "CO-AUTHOR"
#4 BIND #2 "actor"
```
