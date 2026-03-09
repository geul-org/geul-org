---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "Edge panjang variabel untuk mengelompokkan beberapa Node ke dalam 7 tipe: AND, OR, LIST, SET, dll. 13-bit Prefix dan marker terminasi (0x0000) mendukung anggota tanpa batas."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge adalah tipe Edge untuk **mengelompokkan beberapa Node menjadi satu grup**.

## Struktur Paket

```
1st WORD (16 bit)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 bit         │   3 bit   │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 bit)
3rd+ WORD: TID anggota (variabel)
WORD terakhir: marker terminasi (0x0000)
```

| Field | Bit | Deskripsi |
|-------|-----|-----------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Jenis grup (8 macam) |
| Edge TID | 16 | ID unik Edge ini |
| TID anggota | 16×N | Referensi anggota grup |
| Marker terminasi | 16 | `0x0000` |

Minimal 4 word (1 anggota), umumnya 5~6 (2~3 anggota), maksimal tanpa batas.

## GroupType (3 bit = 8 tipe)

| Kode | Tipe | Makna | Jumlah anggota |
|------|------|-------|----------------|
| 000 | **AND** | Konjungsi | 2+ |
| 001 | **OR** | Disjungsi | 2+ |
| 010 | **XOR** | Pilihan eksklusif | 2+ |
| 011 | **LIST** | Daftar berurutan | 1+ |
| 100 | **SET** | Himpunan tanpa urutan | 1+ |
| 101 | **RANGE** | Rentang (awal~akhir) | tepat 2 |
| 110 | **PAIR** | Pasangan berurutan | tepat 2 |
| 111 | Ekstensi | Ekstensi masa depan | - |

## Detail GroupType

### AND

Semua anggota berpartisipasi secara bersamaan. Contoh: "Budi **dan** Sari **dan** Andi mengadakan rapat"

### OR

Satu atau lebih anggota berlaku (inclusive or). Contoh: "Pesan kopi **atau** teh"

### XOR

Tepat satu dari anggota (exclusive or). Contoh: "Lulus atau gagal (salah satu)"

### LIST

Daftar berurutan di mana urutan bermakna. Peringkat, sekuens. Contoh: "Juara 1 Budi, juara 2 Sari, juara 3 Andi"

### SET

Himpunan tanpa urutan. Hanya keanggotaan yang penting. Contoh: "Peserta: Budi, Sari, Andi"

### RANGE

Rentang kontinu termasuk nilai antara. Anggota tepat 2 (awal, akhir). Contoh: "dari 1 sampai 10"

### PAIR

Pasangan berurutan sederhana. Anggota tepat 2. Koordinat, key-value, dll. Contoh: "koordinat (3, 5)"

### RANGE vs PAIR

| Tipe | Makna | Nilai antara |
|------|-------|--------------|
| RANGE | Rentang kontinu | Termasuk |
| PAIR | Pasangan sederhana | Tidak ada |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (ada nilai antara). `PAIR [1, 5]` → (1, 5) (hanya dua nilai).

## Contoh

### "Budi dan Sari bertemu"

```
1. Entity Node: Budi (TID=0x0001)
2. Entity Node: Sari (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = Budi
   4th: [0x0002]                 = Sari
   5th: [0x0000]                 = terminasi

4. Verb Edge: meet
   Subject: 0x0100 (referensi grup)

Total: 5 word
```

### "Koordinat (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = pertama (x)
   4th: [0x0002]                 = kedua (y)
   5th: [0x0000]

Total: 5 word
```

## Batasan

| GroupType | Min | Maks |
|-----------|-----|------|
| AND / OR / XOR | 2 | tak terbatas |
| LIST / SET | 1 | tak terbatas |
| RANGE / PAIR | 2 | 2 |

- TID anggota harus merujuk Node/Edge yang sudah dideklarasikan
- Referensi diri (siklus) tidak diizinkan
- TID=0x0000 dicadangkan sebagai marker terminasi
