---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER adalah Value yang menyatakan bilangan bulat tak bertanda."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `UNSIGNED-INTEGER` (dokumen spesifikasi BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000620/` (sasaran DECLARE `0620`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 2 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | bilangan bulat unsigned magnitude big-endian dengan WORD minimum |
| Sisi Hugo | `value/numeric/unsigned-integer.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

UNSIGNED-INTEGER adalah Value yang menyatakan bilangan bulat tak bertanda. Kode langsung Value `0x062L`, keluarga NUMERIC. Seluruh Payload dibaca sebagai unsigned magnitude berpresisi sembarang dengan urutan WORD big-endian. Payload minimal 1 WORD dan hanya representasi kanonik dengan WORD minimum yang diizinkan.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD bawah)  Unsigned Magnitude Nth
```

## Interpretasi {#해석}

- WORD Payload pertama adalah posisi tertinggi, WORD terakhir posisi terendah.
- Jika Payload N WORD, dibaca sebagai satu unsigned magnitude `16N` bit.
- Lebar ini bukan lebar penyimpanan yang dideklarasikan, dan tidak ada bit width descriptor.

## Representasi kanonik {#정규-표현}

- 0 adalah Payload 1 WORD `0000`.
- Jika Payload 2 WORD atau lebih dan WORD pertama `0000`, nilainya sama bila WORD itu dihapus, sehingga tidak kanonik.
- Decoder harus menolak representasi dengan WORD nol di depan yang tidak perlu.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, 15 WORD atau lebih memakai panjang perluasan `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Record dan TAG WORD](../record.md)).
- Lebar yang dideklarasikan seperti UINT8·UINT16·UINT32 tidak dipertahankan; hanya nilai angkanya yang dipertahankan.

## Contoh {#예시}

| Nilai | WORD Payload | Penilaian |
|---:|---|---|
| 0 | `0000` | kanonik |
| 1 | `0001` | kanonik |
| 65535 | `FFFF` | kanonik |
| 65536 | `0001 0000` | kanonik |
| 1 | `0000 0001` | tidak kanonik: `0000` di depan tidak perlu |
| Payload 7 WORD | 7 WORD setelah TAG `0627` (panjang langsung `LLLL=0111`, total 8 WORD) | kanonik |
| Payload 7 WORD | 7 WORD setelah Length extension TAG dan nilai perluasan `0009` | tidak kanonik: 14 WORD atau kurang ditulis dengan panjang langsung |

## Status format {#형식-지위}

- Representasi yang menormalkan unsigned magnitude berpresisi sembarang menjadi deret WORD minimal 16 bit dan menggabungkannya dengan TAG GEUL ini adalah profil scalar khas GEUL.
- Saat bertukar dengan tipe eksternal berlebar tetap seperti UINT8/16/32/64, diperlukan pemeriksaan rentang dan konversi lebar yang eksplisit.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000620/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
