---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat alasan perubahan (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `MESSAGE` (BIND `MESSAGE` pada dokumen spesifikasi) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D90/` (target DECLARE `1D90`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 25 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Alasan perubahan. Value UTF8-LANGUAGE-TEXT, satu per bahasa (git commit message) |
| Sisi Hugo | `meta/lineage/message.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Mencatat alasan perubahan (git commit message).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[TAG ekstensi Length]
pesan             1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x1D9L`, kelas silsilah
- Payload: Value bawaan ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Jumlah: paling banyak satu per bahasa

## Interpretasi dan validitas {#해석과-유효성}

- Pesan dan bahasa dimuat dalam satu UTF8-LANGUAGE-TEXT. MESSAGE untuk bahasa yang sama hanya satu.
- Dokumen spesifikasi geul.org menuliskannya dengan [CODEC](../edge/0x0BEL-codec.md) `0780` dan `0790`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
