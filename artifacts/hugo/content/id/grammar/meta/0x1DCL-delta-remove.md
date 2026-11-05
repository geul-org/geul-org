---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat LOCAL ID (Id Edge) record yang dibuang dari BODY snapshot dasar pada diff (DELTA-BASE), seperti “Pasal X dihapus”."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DELTA-REMOVE` (BIND `DELTA-REMOVE` pada dokumen spesifikasi) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DC0/` (target DECLARE `1DC0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 28 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Daftar LOCAL ID (Id Edge) yang dibuang dari BODY dasar pada diff |
| Sisi Hugo | `meta/lineage/delta-remove.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

Mencatat LOCAL ID (Id Edge) record yang dibuang dari BODY snapshot dasar pada diff ([DELTA-BASE](0x1DBL-delta-base.md)), seperti "Pasal X dihapus".

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[TAG ekstensi Length]
LOCAL ID dihapus  record Reference LOCAL × 1 atau lebih
```

- Codec: Meta `0x1DCL`, kelas silsilah
- Payload: satu record Reference [LOCAL](../reference/0x005L-local.md) atau lebih
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Hanya ditempatkan pada dokumen yang memiliki `DELTA-BASE`.
- Setiap LOCAL ID harus berupa Id Edge yang ada pada BODY snapshot dasar. Jika tidak ada, tidak valid. Menaruh ID yang sama dua kali juga tidak valid.
- Menaruh Id Edge yang sama lagi pada BODY diff yang sama tidak valid (penghapusan dan revisi tidak dapat dilakukan bersamaan).
- LOCAL ID yang sudah dihapus tidak dialokasikan ulang ke sasaran lain pada versi berikutnya ([revisi](../document.md#개정)).
- Ketiadaan record pada BODY diff berarti "tidak berubah". Karena itu penghapusan hanya dinyatakan dengan Meta ini.
- Edge HEAD ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) untuk seluruh dokumen beserta QUALIFIER-nya) tidak ditulis. HEAD diganti seluruhnya dengan HEAD dari diff ([penyimpanan diff](../document.md#diff-저장)).

## Contoh {#예시}

Menghapus LOCAL `#7` dan `#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), Reference LOCAL `0051 0007`, `0051 000C`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DC0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
