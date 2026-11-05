---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Mencatat pihak yang merekam dokumen (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `RECORDED-BY` (BIND `RECORDED-BY` pada dokumen spesifikasi) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001CF0/` (target DECLARE `1CF0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 15 |
| Kind | Meta · kelas: asal-usul |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pihak perekam. Reference (git committer) |
| Sisi Hugo | `meta/provenance/recorded-by.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | record | record apa pun (kecuali penanda slot) |  |

Mencatat pihak yang merekam dokumen (git committer).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[TAG ekstensi Length]
Payload           satu record Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, dll.)
```

- Codec: Meta `0x1CFL`, kelas asal-usul
- Payload: Reference bawaan
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Reference tidak membatasi Codec. Bisa manusia, organisasi, model, maupun mesin aturan ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), dll.).
- Dokumen yang dipublikasikan geul.org tidak memuat Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](../issuer.md#geulorg-공표)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) diizinkan.
- Jika LOCAL, sasarannya diuraikan di BODY.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001CF0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
