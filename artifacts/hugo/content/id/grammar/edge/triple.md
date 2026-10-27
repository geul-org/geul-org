---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE adalah Edge pernyataan yang memuat satu proposisi (Predicate, Subject, Object) dan tingkatannya (rank) (Codec 0x0A). Pada Object, sebagai ganti nilai dapat dipakai tidak diketahui (UNKNOWN-VALUE) atau tidak ada (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE adalah Edge pernyataan yang memuat satu proposisi (Predicate, Subject, Object) dan tingkatannya (rank). Codec `0x0A`.

Syarat yang membatasi proposisi (waktu mulai·berakhir, cakupan penerapan, dan lain-lain) ditempelkan dengan [QUALIFIER](/id/grammar/edge/qualifier/) yang menunjuk Edge Id TRIPLE. Asal (references Wikidata) ditempelkan dengan Edge dasar [SOURCE](/id/grammar/edge/source/) yang menunjuk Edge Id TRIPLE.

## Layout

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           record LOCAL Reference
Predicate         record Reference (WIKIDATA-PID, dan lain-lain)
Subject           record Reference
Object            record Reference atau Value, atau penanda slot 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Kode | Nama | Arti |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | Nilai saat ini, nilai paling berotoritas |
| `2` | deprecated | Nilai yang dinilai salah atau usang tetapi dicatat |

- Sama dengan statement rank Wikidata. Nilai representatif (truthy Wikidata) adalah preferred jika ada pada Subject·Predicate yang sama, jika tidak ada maka normal.
- Sumber yang tidak memberi rank memakai `0` (normal).
- Kode lain adalah invalid.

## Interpretasi dan validitas

- Predicate dan Subject adalah tepat satu record Reference yang lengkap.
- Object adalah tepat satu record Reference atau Value yang lengkap, atau 1 WORD [penanda slot](/id/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE)·`0x0002` (NO-VALUE). ABSENT (`0x0000`) tidak diterima. Object bukan field opsional.
- Setelah membaca Object, harus tersisa tepat 1 WORD (Rank).
- Dokumen spesifikasi geul.org menaruh [CODEC](/id/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) dan [ENUM](/id/grammar/edge/enum/) 0·1·2 pada field nilai mentah Rank. Pada field Object ditaruh CODEC `0780` (Reference apa saja), `0F80` (Value apa saja), `0001` (UNKNOWN-VALUE), `0002` (NO-VALUE). Predicate·Subject tidak menerima penanda slot.
- **Makna TRIPLE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya dalam dokumen yang sama.** Pihak pembaca mengumpulkan QUALIFIER sebelum menginterpretasikan TRIPLE. TRIPLE yang dibaca tanpa QUALIFIER dapat berupa proposisi yang kehilangan pembatas (contoh: "kepala pemerintahan" tanpa pembatas waktu).

## Tidak diketahui dan tidak ada

Penanda slot pada posisi Object bukan nilai, melainkan penegasan tentang proposisi.

| Object | Arti | Logika |
|---|---|---|
| Nilai v | Salah satu nilai Predicate Subject adalah v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | Nilai ada. Tidak diketahui apa (`somevalue` Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | Nilai tidak ada (`novalue` Wikidata) | `¬∃x. P(s, x)` |
| Tidak ada TRIPLE | Tidak menegaskan apa pun (dunia terbuka) | |

- **Dibaca dalam syarat pembatas.** Cakupan `∃`·`¬∃` ditentukan oleh QUALIFIER yang menunjuk TRIPLE itu. Jika ada QUALIFIER, ia hanya tertutup pada cakupan itu. "Pada 1811~1816 tidak ada bank sentral" ditulis dengan menempelkan QUALIFIER P580·P582 pada TRIPLE NO-VALUE. Tidak bertentangan dengan TRIPLE nilai pada periode lain untuk Predicate yang sama.
- **rank berlaku sama.** Saat memilih nilai representatif (truthy), TRIPLE UNKNOWN-VALUE·NO-VALUE juga menjadi kandidat. Jika ada preferred, hanya preferred yang tersisa.
- **Sesama UNKNOWN-VALUE tidak sama.** UNKNOWN-VALUE tidak sama maupun berbeda dengan nilai apa pun (hasil perbandingan belum ditentukan), dan dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. Setiap kemunculan adalah kuantifikasi eksistensial yang independen. Karena itu dua TRIPLE UNKNOWN-VALUE dengan byte yang sama bukan duplikat dan tidak digabung (anaknya bisa dua, bisa satu).
- Jika NO-VALUE dan TRIPLE nilai (atau UNKNOWN-VALUE) ada bersama pada Subject·Predicate·rank yang sama tanpa syarat pembatas yang membedakan, itu kontradiksi. Pemeriksa memberi peringatan. Tidak menolak (keadaan ini ada juga di Wikidata).
- Nilai yang tidak dapat dipindahkan (di sumber nilainya ada) tidak ditulis sebagai UNKNOWN-VALUE.

## Contoh (non-normatif)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG adalah `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (Amerika Serikat) P1304 (bank sentral) NO-VALUE, normal. Pada 1811~1816 tidak ada bank sentral (QUALIFIER P580·P582 ada pada contoh [QUALIFIER](/id/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. TAG adalah `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "Tidak punya anak (P40)" adalah `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Masalah terbuka

- scope (konteks klaim: dunia, sudut pandang): ditetapkan saat ada kegunaannya.
- Bentuk singkat yang melipat TRIPLE dan QUALIFIER ke satu record: setelah ada deklarasi field berulang (masalah terbuka [DECLARE](/id/grammar/edge/declare/)).

## Halaman terkait

- [Edge](/id/grammar/edge/), [QUALIFIER](/id/grammar/edge/qualifier/), [SOURCE](/id/grammar/edge/source/), [LABEL](/id/grammar/edge/label/), [ALIAS](/id/grammar/edge/alias/), [Penanda slot](/id/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/)
