---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT adalah penanda slot yang menyatakan 'tidak ditulis'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT adalah [penanda slot](../slot-marker.md) yang menyatakan "tidak ditulis". Ini adalah pernyataan tentang dokumen bahwa slot ini tidak diisi, dan tidak menegaskan apa pun tentang dunia.

| Butir | Nilai |
|---|---|
| Nama | `ABSENT` (BIND `ABSENT` pada dokumen spesifikasi) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000000/` (target DECLARE `0000`) |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 0 |
| Kind | Reference · klasifikasi: penanda slot |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tidak ditulis. Field opsional dihilangkan. Tidak menegaskan apa pun tentang dunia |
| Sisi Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Tidak ada Payload. Tidak ada ID target dan tidak ada Quantifier ([penanda slot](../slot-marker.md#레이아웃)).
- Bentuk dengan Payload (L ≥ 1) pada `0x000L` adalah Reserved.
- Notasi teks `geul show`·`geul add`: `ABSENT`.

## Makna {#뜻}

| Butir | Tidak ditulis |
|---|---|
| Tentang apa | **Dokumen**: slot ini tidak diisi |
| Logika | Tidak menegaskan apa pun |
| Asumsi dunia | Dunia terbuka (tanpa informasi) |
| Wikidata | Snak yang bersangkutan tidak ada |

## Penerimaan {#수용}

- Hanya diterima oleh field yang memiliki target CODEC `0000`. Field itu adalah **field opsional**. Saat field opsional dihilangkan, satu WORD `0x0000` ditulis pada posisinya. Field opsional pun tetap menempati posisinya ([Dokumen spesifikasi Codec](../codec-spec.md#선택-필드와-자리-표지)). Contoh: Origin pada [SOURCE](../edge/0x0C0L-source.md), satuan·batas bawah·batas atas pada [QUANTITY](../value/0x066L-quantity.md).
- Tidak dapat dipakai pada wildcard, field tanpa CODEC, posisi record HEAD·BODY, posisi Edge Id, dan field nilai mentah (aturan umum [penanda slot](../slot-marker.md#수용-규칙)).

## Kewajiban pembaca {#읽는-쪽의-의무}

- **ABSENT tidak mengatakan apa pun tentang dunia.** Jangan membacanya sebagai UNKNOWN-VALUE atau NO-VALUE.
- Dilarang menulis nilai yang gagal dipindahkan oleh konverter (nilainya ada di sumber) sebagai UNKNOWN-VALUE, karena di sumber nilainya diketahui. Posisi yang tidak dinyatakan oleh sumber (misalnya Origin pada [SOURCE](../edge/0x0C0L-source.md) untuk asal-usul yang tidak dijelaskan sumber) juga ditulis konverter sebagai ABSENT.
- Pada graf penilaian, ABSENT dan ketiadaan pernyataan membuat semua operator pembanding menjadi tak tentu (U). Untuk membaca ABSENT sebagai empty, sisi masukan harus menyatakan dunia tertutup ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Contoh {#예시}

`0x0000` 1 WORD. Contoh: posisi satuan pada QUANTITY yang satuannya tidak ditulis.

## Dokumen codec {#코덱-문서}

Dokumen codec hanya memiliki satu DECLARE (target `0000`). Karena tidak ada Payload, tidak ada FIELD. Decoder menanamkan makna penanda dan aturan penerimaannya ([lapisan 0](../publishing.md#층)). Dokumen codec tidak dirujuk untuk membaca penanda.

## Halaman terkait {#관련-페이지}

- [Penanda slot](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Dokumen spesifikasi Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000000/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
