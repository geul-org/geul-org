---
title: "DOC-4WORD (0x1C2L)"
weight: 450
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD, dan DOC-4WORD adalah Meta struktur yang membuka dokumen dengan menetapkan jumlah WORD seluruh dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD, dan DOC-4WORD adalah Meta struktur yang membuka dokumen dengan menetapkan jumlah WORD seluruh dokumen.

| Butir | Nilai |
|---|---|
| Nama | `DOC-4WORD` (BIND `DOC-4WORD` pada dokumen spesifikasi) |
| TAG ID | `0x1C2L` |
| Codec ID | `0x00001C20` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C20/` (target DECLARE `1C20`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 2 |
| Kind | Meta · kelas: struktur |
| TAG WORD | `0001 1100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Awal dokumen dengan panjang total yang ditetapkan pada 4 WORD Payload |
| Sisi Hugo | `meta/structure/doc.md` (halaman itu juga membahas [DOC-1WORD](0x1C0L-doc-1word.md) dan [DOC-2WORD](0x1C1L-doc-2word.md)) |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | nilai mentah 4 WORD |  |  |

Record yang membuka dokumen. Jumlah WORD seluruh dokumen ditetapkan pada Payload. `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`), dan `DOC-4WORD` (`0x1C2L`) dibahas bersama di halaman ini.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[TAG ekstensi Length]
Payload           Jumlah WORD total. Codec menentukan lebarnya: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, kelas struktur
- Payload: nilai mentah (jumlah WORD seluruh dokumen, unsigned)
- Jumlah: satu per dokumen, di paling depan

## Interpretasi dan validitas {#해석과-유효성}

- Panjang dihitung dari awal record pembuka sampai akhir [END](0x1C4L-end.md).
- Gunakan lebar tersempit yang dapat memuat nilai. Pengodean dengan lebar yang lebih besar ditolak sebagai pengodean non-kanonis.
- Panjang harus sama dengan seluruh input. Satu dokumen adalah satu input.
- Dekoder dapat melompati seluruh dokumen dengan panjang ini. Tidak ada Codec pembuka yang panjangnya tidak diketahui.
- Saat menghitung hash isi, tulis ulang dengan panjang tanpa Meta kelas verifikasi dan lebar yang sesuai ([hash isi](../document.md#내용-해시)).

## Contoh {#예시}

- `0x1C01 0x0017`: DOC-1WORD, total 23 WORD

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C20/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C2000000000
BODY
#1 DECLARE 0x1C20
#2 FIELD #1 0x0004
#3 BIND #1 "DOC-4WORD"
#4 BIND #2 "count"
```
