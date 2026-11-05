---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat pihak yang membuat dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `GENERATED-BY` (BIND `GENERATED-BY` pada dokumen spesifikasi) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D30/` (target DECLARE `1D30`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 19 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pihak pembuat. Manusia, model, mesin aturan |
| Sisi Hugo | `meta/lineage/generated-by.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | record | record apa pun (kecuali penanda slot) |  |
| 2 | `version` | #5 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (bidang opsional) |  |

Mencatat pihak yang membuat dokumen. Bisa manusia, model, atau mesin aturan.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[TAG ekstensi Length]
pihak pembuat     Reference (manusia, model, mesin aturan)
versi             Value UTF8-TEXT, atau penanda penghilangan 0x0000 (bidang opsional)
```

- Codec: Meta `0x1D3L`, kelas silsilah
- Payload: Reference bawaan + teks versi (opsional)
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Jika berupa model, tulis juga versi modelnya.
- Jika versi tidak diketahui atau tidak dicantumkan, hilangkan bagian itu dan gunakan ABSENT (`0x0000`) (bidang opsional [CODEC](../edge/0x0BEL-codec.md)). Spesifikasi geul.org `0x1D30` adalah dua bidang record: agent (tanpa CODEC) dan version (`0720`, `0730`, `0000`).
- Versi sumber program (commit) lebih tepat dicatat dengan format [TRANSFORMED-BY](0x1D4L-transformed-by.md) (digest, wajib). Versi pada GENERATED-BY dipakai untuk hal yang bukan ID commit, seperti nama dan versi model, dalam bentuk teks.
- Dokumen yang dipublikasikan geul.org tidak memuat Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](../issuer.md#geulorg-공표)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) diizinkan.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D30/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
