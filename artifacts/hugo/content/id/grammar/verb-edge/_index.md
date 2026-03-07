---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "13.767 kata kerja WordNet diklasifikasikan ke dalam 10 Primitive → 68 Sub-primitive, dan pengkodean Huffman menghasilkan codebook 16-bit. Tiga varian paket Tiny(2)/Short(3)/Full(5 word) mencapai kompresi rata-rata 2,16 word."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge adalah tipe Edge dalam aliran GEUL untuk menyatakan predikat/tindakan. 13.767 kata kerja WordNet diklasifikasikan ke dalam 10 Primitive → 68 Sub-primitive, dan **pengkodean Huffman per Sub-primitive** menghasilkan codebook 16-bit.

## Dokumen Turunan

| Dokumen | Deskripsi |
|---------|-----------|
| [Peran Partisipan](./semantic-role/) | 16 Semantic Role (encoding 4-bit) |
| [Kualifikator Semantik](./qualifier/) | 14 kualifikator: evidensialitas, modus, tense, aspek, dll. |

## Hierarki Kata Kerja

```
10 Primitive (kategori semantik teratas)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (klasifikasi menengah)
    → 559 Root Verb (kata kerja akar)
      → 13,767 Leaf Verb (semua kata kerja WordNet)
```

- Primitive (kategori besar) hanya bertugas **pengelompokan konseptual**, tanpa alokasi bit
- 68 Sub-primitive (subkategori) mendapat **kode panjang variabel berbasis frekuensi**
- Semakin tinggi frekuensi grup kata kerja, semakin pendek kode (4-8 bit)

## Tipe Paket Verb Edge

Ketiga tipe Tiny/Short/Full berbagi **badan kata kerja 16-bit** yang sama di word terakhir.

| | Tiny | Short | Full |
|--|------|-------|------|
| Word | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| Partisipan | 16 pola | 512 pola | 19bit flag |
| Kualifikator | 7 pola | 3.640 pola | 27bit |
| Badan kata kerja | 16bit | 16bit | 16bit |
| Perkiraan rasio | 90% | 7% | 3% |

**Ukuran paket rata-rata:** 0,9×2 + 0,07×3 + 0,03×5 = **2,16 word**

### Tiny Verb Edge (2 word)

```
1st WORD:  [Prefix 5bit] [Target×pola 11bit]
2nd WORD:  [badan kata kerja 16bit]
```

- Target×pola: 18 Target × 113 pola = 2.034 kombinasi
- Partisipan 16 pola × kualifikator 7 pola = 112 + 1 cadangan = 113
- Cakupan ~90%

### Short Verb Edge (3 word)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [pola partisipan 9bit]
2nd WORD:  [Target×pola kualifikator 16bit]
3rd WORD:  [badan kata kerja 16bit]
```

### Full Verb Edge (5 word)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target partisipan 5bit] [flag partisipan 4bit]
2nd+3rd:   [flag partisipan 15bit] [kualifikator 17bit]
4th WORD:  [kualifikator 10bit] [cadangan 6bit]
5th WORD:  [badan kata kerja 16bit]
```

## Badan Kata Kerja 16-bit

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     DFS index dalam tree   │
│   (4-8 bit, Huffman)    │     (8-12 bit)             │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4~8 bit variabel (kode Huffman)
- **DFS index:** identifikasi kata kerja individu dalam sub_primitive

### Distribusi Panjang Kode

| Panjang kode | Jumlah | Total kata kerja | Rasio |
|--------------|--------|-----------------|-------|
| 4 bit | 4 | 6.388 | 46,4% |
| 5 bit | 4 | 2.479 | 18,0% |
| 6 bit | 8 | 2.321 | 16,9% |
| 7 bit | 16 | 1.786 | 13,0% |
| 8 bit | 36 | 813 | 5,9% |

### Perhitungan Bit DFS index

| Jumlah kata kerja sub_primitive | Bit diperlukan |
|--------------------------------|----------------|
| 1~256 | 8 bit |
| 257~512 | 9 bit |
| 513~1024 | 10 bit |
| 1025~2048 | 11 bit |
| 2049~4096 | 12 bit |

Contoh: CHANGE-TRANSFORM = `0000`(4 bit) + 3.063 kata kerja (12 bit) = 16 bit.

### Panjang Kode Rata-rata

```
Rata-rata = Σ(panjang kode × jumlah kata kerja) / total kata kerja ≈ 5,14 bit
```

| Metode | Rata-rata bit |
|--------|---------------|
| Tetap 7 bit (68) | 7,00 |
| Pengkodean Huffman | 5,14 |
| **Penghematan** | **1,86 bit (27%)** |

## Primitive Kategori Besar (10)

| Primitive | Makna | Jumlah Sub-primitive | Jumlah kata kerja |
|-----------|-------|---------------------|-------------------|
| BE | Keadaan/keberadaan | 8 | 899 |
| PERCEIVE | Persepsi/kognisi | 4 | 218 |
| FEEL | Emosi | 6 | 204 |
| THINK | Pemikiran | 6 | 769 |
| CHANGE | Perubahan | 8 | 3.358 |
| CAUSE | Penyebab/tindakan | 14 | 3.739 |
| MOVE | Perpindahan | 6 | 2.182 |
| COMMUNICATE | Komunikasi | 6 | 586 |
| TRANSFER | Transfer | 4 | 530 |
| SOCIAL | Tindakan sosial | 6 | 387 |

## Sub-primitive Frekuensi Tertinggi (kode 4-bit)

| Sub-primitive | Kode | Kata kerja | Rasio | Contoh |
|---------------|------|-----------|-------|--------|
| CHANGE-TRANSFORM | `0000` | 3.063 | 22,2% | "berubah", "menjadi" |
| CAUSE-USE | `0001` | 1.358 | 9,9% | "menggunakan", "memakai" |
| MOVE-DISPLACE | `0010` | 1.025 | 7,4% | "memindahkan" |
| MOVE-GO | `0011` | 942 | 6,8% | "pergi" |

Empat Sub-primitive teratas mencakup 46,4% dari seluruh kata kerja.

## Filosofi Desain

### Alasan Memilih Pengkodean Huffman

- CHANGE-TRANSFORM (22,2%) sangat dominan
- **Penghematan 27% rata-rata bit** dibanding alokasi tetap
- Empat sub_primitive teratas = 46,4% total

### Alasan Menghapus Bit Primitive

- Sebelumnya: Primitive 3 bit + Sub_primitive 4 bit = 7 bit tetap
- Sekarang: pengkodean langsung Sub_primitive = 4~8 bit variabel
- Untuk kata kerja frekuensi tinggi — **penghematan hingga 4 bit**

### Mempertahankan Pengelompokan Semantik

Klasifikasi Primitive dipertahankan untuk keterbacaan manusia dan sebagai petunjuk klasterisasi semantik saat pelatihan LLM.
