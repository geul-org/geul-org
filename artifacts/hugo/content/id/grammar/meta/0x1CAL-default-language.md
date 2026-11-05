---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan bahasa default teks dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DEFAULT-LANGUAGE` (BIND `DEFAULT-LANGUAGE` pada dokumen spesifikasi) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001CA0/` (target DECLARE `1CA0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 10 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Bahasa default |
| Sisi Hugo | `meta/declaration/default-language.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Mendeklarasikan bahasa default teks dokumen. Teks yang bahasanya tidak ditulis terpisah berbahasa ini.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[TAG ekstensi Length]
Payload           satu Value bahasa
```

- Codec: Meta `0x1CAL`, kelas definisi
- Payload: Value bawaan ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) atau [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Dokumen TANGEUL mencantumkan locale penulisan (contoh: `en`, `ko`).

## Contoh {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001CA0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
