---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD adalah Edge pernyataan yang mendeklarasikan satu bidang Payload Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `FIELD` (BIND dokumen spesifikasi `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000BC0/` (target DECLARE `0BC0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 28 |
| Kind | Edge · keluarga: pernyataan, kelompok: lainnya |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Satu bidang Payload. DECLARE tempatnya berada, lebar: record (Length TAG) atau nilai mentah n WORD |
| Sisi Hugo | `edge/field.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | record | `0050` LOCAL |  |
| 2 | `width` | #3 | nilai mentah 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD adalah Edge pernyataan yang mendeklarasikan satu bidang Payload Codec. Codec `0x0BCL`.

FIELD menunjuk [DECLARE](0x0BBL-declare.md)-nya sendiri. Semua FIELD yang menunjuk satu DECLARE menyusun Payload sesuai urutan dalam dokumen. Layout tertanam di decoder ([dokumen spesifikasi Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           record LOCAL Reference
DECLARE           record LOCAL Reference. Edge DECLARE tempat bidang ini berada
Lebar             1 WORD. 0 = record, n (1~65534) = nilai mentah n WORD, 0xFFFF = sisa nilai mentah
```

## Interpretasi dan validitas {#해석과-유효성}

- DECLARE menunjuk Edge DECLARE dalam dokumen yang sama. Satu FIELD hanya milik satu DECLARE. Urutan tidak ditulis terpisah, melainkan urutan record FIELD ditaruh dalam dokumen.
- Dokumen spesifikasi FIELD mendeklarasikan DECLARE sebagai bidang berlebar `0` (record), CODEC `0050` (LOCAL). Karena itu pada graf viewer ia digambar sebagai hubungan FIELD → DECLARE.
- Lebar `0` adalah bidang record. Dimulai dengan TAG WORD dan dibaca sepanjang Length TAG itu ([DECLARE](0x0BBL-declare.md) aturan interpretasi).
- Lebar `n` (1~65534) adalah bidang nilai mentah. Selalu tepat n WORD.
- Lebar `0xFFFF` adalah sisa nilai mentah. Hanya satu dalam DECLARE, dan boleh di depan, tengah, atau akhir. Lebarnya adalah sisa WORD yang ditentukan Length TAG record luar dikurangi lebar bidang setelahnya. Karena itu semua bidang setelah bidang sisa harus nilai mentah berlebar tetap (record harus dibaca dari depan agar akhirnya diketahui). Boleh 0 WORD. ENUM tidak ditempelkan.
- Kind·Codec yang diterima bidang ditentukan dengan [CODEC](0x0BEL-codec.md). Bidang record menerima record apa saja jika tidak ada CODEC, dan jika ada harus salah satunya. Jika satu CODEC ditaruh pada bidang nilai mentah, nilai mentah itu ditafsirkan sebagai Value tersebut tanpa TAG.
- Nama bidang diikat pada Edge Id FIELD dengan [BIND](0x0A3L-bind.md) (contoh: `doc`, `hash`). UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC semuanya dengan BIND, tidak ditempelkan dengan Edge lain seperti LABEL.
- Makna nilai kode bidang nilai mentah ditempelkan dengan [ENUM](0x0BDL-enum.md).
- Bidang yang menunjuk node lain pada graf tidak ditandai terpisah. Jika bidang record adalah Reference, itulah hubungannya.

## Panjang {#길이}

```
total = 1 + 2 + 2 + 1 WORD   (jika Edge Id·DECLARE adalah ID LOCAL 1 WORD)
```

## Contoh (non-normatif) {#예시-비규범}

- Bidang record: Edge Id 7, DECLARE #1, lebar `0`. TAG 1 + Edge Id 2 + DECLARE 2 + lebar 1 = 6 WORD. Untuk membuatnya hanya menerima LOCAL, lihat contoh [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- Untuk bidang nilai mentah seperti hash isi, lihat contoh [DECLARE](0x0BBL-declare.md).

## Halaman terkait {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [dokumen spesifikasi Codec](../codec-spec.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000BC0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
