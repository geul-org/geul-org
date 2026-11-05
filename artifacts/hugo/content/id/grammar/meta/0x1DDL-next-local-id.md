---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat LOCAL ID yang akan diberikan versi berikutnya dokumen itu kepada pernyataan baru (auto increment pada DBMS, AUTO_INCREMENT MySQL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `NEXT-LOCAL-ID` (BIND `NEXT-LOCAL-ID` pada dokumen spesifikasi) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001DD0/` (target DECLARE `1DD0`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 29 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | LOCAL ID yang akan dialokasikan berikutnya (auto increment). Ditaruh pada HEAD daftar versi `versions.geul` |
| Sisi Hugo | `meta/lineage/next-local-id.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

Mencatat LOCAL ID yang akan diberikan versi berikutnya dokumen itu kepada pernyataan baru (auto increment pada DBMS, `AUTO_INCREMENT` MySQL). Semua LOCAL ID yang dialokasikan pada versi mana pun dari dokumen lebih kecil daripada nilai ini.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           LOCAL ID yang akan dialokasikan berikutnya, bilangan bulat unsigned dengan lebar tersempit
```

- Codec: Meta `0x1DDL`, kelas silsilah
- Payload: nilai mentah (bilangan bulat unsigned dengan lebar tersempit)
- Jumlah: paling banyak satu
- Tempat: HEAD dokumen daftar versi `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interpretasi dan validitas {#해석과-유효성}

- LOCAL ID (termasuk Id Edge) adalah identitas yang melintasi versi ([revisi](../document.md#개정)). Pernyataan baru menerima nilai ini, lalu nilainya bertambah 1. LOCAL ID yang sudah dihapus tidak dipakai lagi. Karena itu, meskipun pernyataan bernilai maksimum dihapus, nilai ini tidak berkurang.
- LOCAL ID `0` tidak dialokasikan, sehingga nilai awalnya `1`. Jika belum ada versi, Meta ini tidak ditaruh dan nomor berikutnya adalah `1`.
- Pihak penerbit menuliskan nilai yang diperbarui pada dokumen daftar baru saat mempublikasikan versi. Nilainya harus lebih besar daripada LOCAL ID mana pun yang dipakai pada versi yang dipublikasikan. Jika lebih kecil atau sama, tidak valid.
- Nilainya hanya bertambah. Jika lebih kecil daripada nilai pada dokumen daftar sebelumnya ([PARENT](0x1D1L-parent.md)), tidak valid.
- Tidak ada pada dokumen yang tidak dikelola versinya (dokumen tanpa `versions.geul`, dokumen tanpa nama). Dokumen seperti itu juga tidak memakai diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- Tidak ditaruh pada isi dokumen (dokumen versi). Pengingat nomor bukan isi dokumen, melainkan keadaan pihak penerbit yang melanjutkan dokumen (di sisi refs git, bukan commit git).

## Contoh {#예시}

Nomor alokasi berikutnya 524:

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001DD0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
