---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Penanda bahwa file versi ini bukan snapshot, melainkan diff terhadap versi dasar dokumen yang sama (delta pada git packfile)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DELTA-BASE` (BIND `DELTA-BASE` pada dokumen spesifikasi) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DB0/` (target DECLARE `1DB0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 27 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | File versi ini adalah diff terhadap versi dasar (ID versi 2 WORD) dokumen yang sama (git packfile delta) |
| Sisi Hugo | `meta/lineage/delta-base.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | nilai mentah 2 WORD | `0620` UNSIGNED-INTEGER |  |

Penanda bahwa file versi ini bukan snapshot, melainkan **diff** terhadap versi dasar dokumen yang sama (delta pada git packfile). Versi itu sendiri tetap didefinisikan sebagai snapshot. Hash isi, daftar versi, dan tanda tangan semuanya mengacu pada snapshot yang dipulihkan dengan menerapkan diff ([penyimpanan diff](../document.md#diff-저장)).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
ID versi          2 WORD unsigned (versi dasar dokumen yang sama)
```

- Codec: Meta `0x1DBL`, kelas silsilah
- Payload: ID versi 2 WORD (nilai mentah)
- Jumlah: paling banyak satu

## Interpretasi dan validitas {#해석과-유효성}

- Hanya dipakai pada dokumen yang memiliki [DOC-ID](0x1C7L-doc-id.md). Daftar versi `versions.geul` yang tidak memiliki `DOC-ID`, dokumen daftar (versi dari `issuers/`), dan dokumen tanpa nama tidak memakai diff.
- Versi dasar adalah versi terpublikasi dengan `DOC-ID` yang sama dan lebih awal dari versi ini. `0` (tanpa versi) tidak valid.
- Hash isi snapshot yang dipulihkan harus sama dengan hash versi ini pada daftar versi ([PUBLICATION](../edge/0x0B8L-publication.md)). Jika berbeda, diff ini tidak valid. Karena itu hash hasil tidak dicatat terpisah di dalam diff.
- Hanya dokumen yang seluruh record BODY-nya adalah Edge (record yang memiliki Id Edge) yang dapat dijadikan diff. Sebab satuan diff adalah ID LOCAL (Id Edge).
- Aturan pemulihan snapshot mengikuti [penyimpanan diff](../document.md#diff-저장). Penghapusan menjadi tugas [DELTA-REMOVE](0x1DCL-delta-remove.md).
- Tidak ada penanda terpisah untuk penambahan atau revisi. Jika Id Edge pada BODY diff sudah ada di dasar, itu revisi; jika belum, itu penambahan. Penambahan menerima nomor mulai dari [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) pada daftar versi. Memakai ulang ID LOCAL yang sudah dihapus tidak valid ([revisi](../document.md#개정)).

## Contoh {#예시}

Diff terhadap versi dasar 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), ID versi `0000 0003`.

## Masalah terbuka {#열린-문제}

1. Interval snapshot: setiap berapa versi snapshot penuh ditempatkan (panjang rantai diff dan biaya pemulihan).
2. Apakah versi dasar dibatasi pada versi sebelumnya langsung.
3. Lokasi penyimpanan file diff: apakah pada posisi file versi (`<ID versi>.geul`), dan hubungannya dengan alamat hash isi `<Issuer>/hashes/` (`hashes/` dicari dengan hash isi snapshot).

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DB0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
