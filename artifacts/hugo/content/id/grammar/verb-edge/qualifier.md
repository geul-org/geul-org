---
title: "Kualifikator Semantik"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Kualifikator semantik Verb Edge. 14 kategori — evidensialitas, modus, modalitas, tense, aspek, kesopanan, polaritas, dan lainnya — meng-encode informasi gramatikal dan pragmatik predikat."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge meng-encode berbagai kualifikator semantik selain badan kata kerja. Bersama dengan [peran partisipan](../semantic-role/), mereka membentuk semantik lengkap predikat.

## Daftar Kualifikator

| Kategori | Nama Inggris | Tipe Data | Pemetaan Nilai |
|----------|-------------|-----------|----------------|
| Kata kerja inti | Core Verb | Identifier | ID absolut penyelarasan semantik |
| Daftar [partisipan](../semantic-role/) | Participant List | Tipe komposit list | {entitas, peran gramatikal, peran semantik} |
| Pembicara | Speaker | Referensi | Subjek ujaran (wajib) |
| Pendengar | Listener | Referensi | Target ujaran (Nullable) |
| Evidensialitas | Evidentiality | Float [-1.0~1.0] | -1=inferensi, 0=pengalaman langsung, 1=laporan |
| Modus | Mood | Float [-1.0~1.0] | -1=andaikan, 0=deklaratif, 1=imperatif |
| Modalitas | Modality | Float [0.0~1.0] | Tingkat kehendak |
| Tense | Tense | Float [-1.0~1.0] | -1=lampau, 0=kini, 1=depan |
| Aspek | Aspect | Bitmask | 1:progresif, 2:perfektif, 4:resultatif |
| Kesopanan | Politeness | Float [-1.0~1.0] | -1=kasual, 0=netral, 1=formal |
| Polaritas | Polarity | Float [-1.0~1.0] | -1=negatif, 0=tak tahu, 1=positif |
| Kesengajaan | Volitionality | Float [-1.0~1.0] | -1=tak sengaja, 0=tak tahu, 1=sengaja |
| Keyakinan | Confidence | Float [-1.0~1.0] | -1=dugaan, 0=tak tahu, 1=yakin |
| Iterativitas | Iterativity | Integer | 0=tak tahu, 1=sekali, MAX=tak terbatas |

## Evidensialitas (Evidentiality)

Menyatakan sumber informasi.

| Nilai | Makna | Contoh |
|-------|-------|--------|
| -1.0 | Inferensi | "sepertinya..." |
| 0.0 | Pengalaman langsung | "saya lihat" |
| 1.0 | Laporan/katanya | "katanya..." |

## Modus (Mood)

Menyatakan fungsi ujaran.

| Nilai | Makna | Contoh |
|-------|-------|--------|
| -1.0 | Andaikan/kontrafaktual | "seandainya..." |
| 0.0 | Deklaratif/faktual | "begitulah" |
| 1.0 | Imperatif/permintaan | "lakukan!" |

## Tense

Menyatakan posisi temporal peristiwa.

| Nilai | Makna | Contoh |
|-------|-------|--------|
| -1.0 | Lampau | "sudah melakukan" |
| 0.0 | Kini | "sedang melakukan" |
| 1.0 | Depan | "akan melakukan" |

## Aspek (Aspect)

Struktur temporal internal peristiwa, dinyatakan dengan bitmask.

| Bit | Makna | Contoh |
|-----|-------|--------|
| 001 | Progresif | "sedang melakukan" |
| 010 | Perfektif | "sudah melakukan" |
| 100 | Resultatif | "sudah dilakukan" |
| 011 | Progresif+perfektif | "sudah lama melakukan" |

## Kesopanan (Politeness)

Menyatakan hubungan sosial antara pembicara dan pendengar.

| Nilai | Makna | Contoh |
|-------|-------|--------|
| -1.0 | Kasual/akrab | bahasa sehari-hari |
| 0.0 | Netral | bahasa standar |
| 1.0 | Formal/hormat | bahasa resmi |

## Prinsip Desain

- **Nilai kontinu:** Menggunakan Float alih-alih klasifikasi diskret, memungkinkan ekspresi gradasi
- **Bipolar:** Sebagian besar parameter dalam rentang [-1.0, 1.0] mewakili dua kutub
- **Tak teridentifikasi:** 0.0 dapat berarti bukan hanya "netral" tetapi juga "tidak dapat ditentukan" (Polarity, Volitionality, Confidence)
- **Kombinasi:** Gabungan bitmask (Aspect) + Float memungkinkan ekspresi makna komposit
