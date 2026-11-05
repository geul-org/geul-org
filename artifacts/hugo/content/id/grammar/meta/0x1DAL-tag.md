---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat nama imutabel yang diberikan pada sebuah versi (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `TAG` (BIND `TAG` pada dokumen spesifikasi) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DA0/` (target DECLARE `1DA0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 26 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Nama imutabel yang diberikan pada versi. Value TEXT dan hash isi (git annotated tag) |
| Sisi Hugo | `meta/lineage/tag.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | record | `07C0` SHA-256-DIGEST, `0000` ABSENT (bidang opsional) |  |

Mencatat nama imutabel yang diberikan pada sebuah versi (git annotated tag).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[TAG ekstensi Length]
nama              Value UTF8-TEXT-*
sasaran           Value SHA-256-DIGEST, atau penanda penghilangan 0x0000 (bidang opsional). Jika dihilangkan, versi ini
```

- Codec: Meta `0x1DAL`, kelas silsilah
- Payload: Value bawaan (teks + hash isi opsional)
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Nama adalah [UTF8-TEXT](../value/0x072L-utf8-text.md), sasaran adalah [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- Jika sasaran dihilangkan (ABSENT `0x0000`, bidang opsional [CODEC](../edge/0x0BEL-codec.md)), nama itu diberikan pada dokumen ini sendiri. Hash isi sendiri tidak dapat ditulis di dalam dirinya sendiri. Spesifikasi geul.org `0x1DA0` adalah dua bidang record: name (`0720`, `0730`) dan target (`07C0`, `0000`).
- Nama yang sama tidak dipakai ulang untuk versi lain.

## Contoh {#예시}

- Nama `v1`, versi ini: `1DA3 0721 7631 0000`

## Masalah terbuka {#열린-문제}

- Apakah TAG tetap diperlukan padahal sudah ada ID versi (nomor urut).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DA0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
