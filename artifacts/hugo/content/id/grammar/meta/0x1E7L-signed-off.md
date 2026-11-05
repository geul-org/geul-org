---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Konfirmasi hak kontribusi (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SIGNED-OFF` (BIND `SIGNED-OFF` pada dokumen spesifikasi) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E70/` (target DECLARE `1E70`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 7 |
| Kind | Meta · kelas: verifikasi |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Konfirmasi hak kontribusi. Reference (git `Signed-off-by`, DCO) |
| Sisi Hugo | `meta/verification/signed-off.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | record | record apa pun (kecuali penanda slot) |  |

Konfirmasi hak kontribusi (git `Signed-off-by`, DCO).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[TAG ekstensi Length]
Payload           satu Reference
```

- Codec: Meta `0x1E7L`, kelas verifikasi
- Payload: Reference bawaan
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Dokumen yang dipublikasikan geul.org tidak memuat Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](../issuer.md#geulorg-공표)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) diizinkan.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E70/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
