---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE adalah penanda slot yang menyatakan 'tidak diketahui'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE adalah [penanda slot](../slot-marker.md) yang menyatakan "tidak diketahui". Ini adalah penegasan tentang dunia bahwa nilainya ada tetapi tidak diketahui apa.

| Butir | Nilai |
|---|---|
| Nama | `UNKNOWN-VALUE` (BIND `UNKNOWN-VALUE` pada dokumen spesifikasi) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000010/` (target DECLARE `0010`) |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 1 |
| Kind | Reference · klasifikasi: penanda slot |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tidak diketahui. Nilainya ada tetapi tidak diketahui apa (`somevalue` Wikidata) |
| Sisi Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Tidak ada Payload. Tidak ada ID target dan tidak ada Quantifier ([penanda slot](../slot-marker.md#레이아웃)).
- Bentuk dengan Payload (L ≥ 1) pada `0x001L` adalah Reserved.
- Notasi teks `geul show`·`geul add`: `UNKNOWN`.

## Makna {#뜻}

| Butir | Tidak diketahui |
|---|---|
| Tentang apa | **Dunia**: nilainya ada. Tidak diketahui apa |
| Logika | `∃x. P(s, x)`, x tidak teridentifikasi |
| Asumsi dunia | Keberadaan tertutup, identitas terbuka |
| Wikidata | `somevalue` |

## Penerimaan {#수용}

- Hanya diterima oleh field yang memiliki target CODEC `0010`. Field itu menerima penegasan "tidak diketahui". Contoh: Object pada [TRIPLE](../edge/0x0AAL-triple.md), Value pada [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin pada [SOURCE](../edge/0x0C0L-source.md).
- Tidak dapat dipakai pada wildcard, field tanpa CODEC, posisi record HEAD·BODY, posisi Edge Id, dan field nilai mentah (aturan umum [penanda slot](../slot-marker.md#수용-규칙)).

## Kewajiban pembaca {#읽는-쪽의-의무}

- **UNKNOWN-VALUE bukan nilai, melainkan penegasan keberadaan.** Ia tidak sama dan tidak berbeda dengan nilai mana pun (hasil perbandingan tak tentu). Dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. Setiap kemunculan adalah kuantifikasi eksistensial yang independen (seperti blank node Wikidata).
- Karena itu dua TRIPLE yang byte-nya sama (`P40 Q… UNKNOWN` ×2) bukan duplikat. Anaknya bisa dua, bisa satu. TRIPLE yang memuat UNKNOWN-VALUE tidak digabung sebagai duplikat.
- Jika identitasnya kemudian terungkap, terbitkan versi baru TRIPLE itu yang telah diperbaiki. UNKNOWN-VALUE tidak dapat ditunjuk. Jika diperlukan ko-referensi, gunakan Variable LOCAL (Variable pada [Reference](_index.md#quantifier)).
- **rank berlaku sama.** Saat memilih nilai representatif (truthy), TRIPLE UNKNOWN-VALUE juga menjadi kandidat.
- **Jika dipakai sebagai nilai QUALIFIER, ia mengubah makna pembatasan itu.** `P582 = UNKNOWN` berarti telah berakhir dan waktunya tidak diketahui. Jangan membacanya sebagai proposisi yang masih berlaku.
- UNKNOWN-VALUE adalah penegasan "ada", sehingga hanya dipakai ketika sumber menyatakannya demikian. Nilai yang gagal dipindahkan tidak ditulis sebagai UNKNOWN-VALUE.

## Contoh {#예시}

`0x0010` 1 WORD. Contoh: waktu berakhir (P582) perbatasan Q30–Q34266 tidak diketahui: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, posisi Value adalah `0010`).

## Dokumen codec {#코덱-문서}

Dokumen codec hanya memiliki satu DECLARE (target `0010`). Karena tidak ada Payload, tidak ada FIELD. Decoder menanamkan makna penanda dan aturan penerimaannya ([lapisan 0](../publishing.md#층)). Dokumen codec tidak dirujuk untuk membaca penanda.

## Halaman terkait {#관련-페이지}

- [Penanda slot](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Dokumen spesifikasi Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000010/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
