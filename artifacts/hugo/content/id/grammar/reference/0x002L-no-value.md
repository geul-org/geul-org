---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE adalah penanda slot yang menyatakan 'tidak ada'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE adalah [penanda slot](../slot-marker.md) yang menyatakan "tidak ada". Ini adalah penegasan tentang dunia bahwa tidak ada nilai.

| Butir | Nilai |
|---|---|
| Nama | `NO-VALUE` (BIND `NO-VALUE` pada dokumen spesifikasi) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000020/` (target DECLARE `0020`) |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 2 |
| Kind | Reference · klasifikasi: penanda slot |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tidak ada. Tidak ada nilai (`novalue` Wikidata) |
| Sisi Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Tidak ada Payload. Tidak ada ID target dan tidak ada Quantifier ([penanda slot](../slot-marker.md#레이아웃)).
- Bentuk dengan Payload (L ≥ 1) pada `0x002L` adalah Reserved.
- Notasi teks `geul show`·`geul add`: `NONE`.

## Makna {#뜻}

| Butir | Tidak ada |
|---|---|
| Tentang apa | **Dunia**: tidak ada nilai |
| Logika | `¬∃x. P(s, x)` |
| Asumsi dunia | Dunia tertutup terhadap (s, P, syarat pembatas) |
| Wikidata | `novalue` |

## Penerimaan {#수용}

- Hanya diterima oleh field yang memiliki target CODEC `0020`. Field itu menerima penegasan "tidak ada". Contoh: Object pada [TRIPLE](../edge/0x0AAL-triple.md), Value pada [QUALIFIER](../edge/0x0ABL-qualifier.md).
- Tidak dapat dipakai pada wildcard, field tanpa CODEC, posisi record HEAD·BODY, posisi Edge Id, dan field nilai mentah (aturan umum [penanda slot](../slot-marker.md#수용-규칙)).

## Kewajiban pembaca {#읽는-쪽의-의무}

- **NO-VALUE tertutup di dalam syarat pembatas proposisi itu.** Jika QUALIFIER dilekatkan, ia hanya tertutup dalam lingkup itu. Q30 P1304 NO-VALUE(P580 1811, P582 1816) berarti hanya pada tahun 1811~1816 tidak ada bank sentral, dan tidak bertentangan dengan TRIPLE nilai pada properti yang sama (Sistem Federal Reserve, preferred).
- Jika NO-VALUE dan TRIPLE nilai berada bersama pada Subject·Predicate yang sama dengan rank yang sama tanpa syarat pembatas yang membedakan, itu kontradiksi. Pemeriksa mengeluarkan peringatan. Ia tidak menolak. Keadaan ini juga ada di Wikidata, dan pembaca memilih berdasarkan rank.
- **rank berlaku sama.** Saat memilih nilai representatif (truthy), TRIPLE NO-VALUE juga menjadi kandidat.
- **Jika dipakai sebagai nilai QUALIFIER, ia mengubah makna pembatasan itu.** `P582 = NONE` menegaskan bahwa belum berakhir. Jika QUALIFIER P582 sama sekali tidak ada, tidak diketahui apakah sudah berakhir.
- "Tidak ada" hanya dapat dinyatakan jika **ditulis** sebagai NO-VALUE. TRIPLE yang tidak ada di dokumen berarti tidak ditulis (dunia terbuka).

## Contoh {#예시}

`0x0020` 1 WORD. Contoh: tidak ada anak (P40) adalah `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, posisi Object adalah `0020`).

## Dokumen codec {#코덱-문서}

Dokumen codec hanya memiliki satu DECLARE (target `0020`). Karena tidak ada Payload, tidak ada FIELD. Decoder menanamkan makna penanda dan aturan penerimaannya ([lapisan 0](../publishing.md#층)). Dokumen codec tidak dirujuk untuk membaca penanda.

## Halaman terkait {#관련-페이지}

- [Penanda slot](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Dokumen spesifikasi Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000020/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
