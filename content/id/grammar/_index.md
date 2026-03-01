---
title: "Tata Bahasa GEUL"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Spesifikasi format aliran biner berbasis SIDX — pengidentifikasi semantik global 64-bit. Prinsip desain, sistem Prefix, 9 tipe paket, dan aturan encoding."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Tata bahasa GEUL adalah format aliran biner yang berbasis pada SIDX (Semantic-aligned Index) — pengidentifikasi semantik global 64-bit.

## Prinsip Desain

1. **Skalabilitas jangka panjang:** Bit cadangan tidak digunakan untuk tujuan sementara. Ruang dipertahankan untuk generasi mendatang.
2. **Keabadian makna:** Makna pola bit yang sudah didefinisikan tidak pernah diubah. Jika diperlukan makna baru, pola baru dialokasikan.
3. **Kompatibilitas mundur:** Setiap versi GEUL harus dapat menginterpretasikan semua versi sebelumnya secara lengkap.
4. **Kompleksitas linier:** Pemrosesan simbolik GEUL mempertahankan O(n) terhadap panjang.

## Gambaran SIDX

SIDX adalah pengidentifikasi semantik global 64-bit. Area ditentukan melalui percabangan berurutan dari bit tertinggi.

| Prefix | Area | Rasio | Kegunaan |
|--------|------|-------|----------|
| `1` | Far Future | 50% | Cadangan untuk masa depan jauh |
| `01` | Future | 25% | Cadangan untuk masa depan dekat |
| `001` | Standard | 12.5% | Area standar resmi |
| `000` | Free | 12.5% | Sepenuhnya bebas |

`0001` adalah ruang konvensional spesifikasi ini di dalam area bebas (000).

## Sistem Prefix

```
bit1
├─ 1: Far Future
│
└─ 0
    └─ bit2
        ├─ 1 (01): Future
        │
        └─ 0
            └─ bit3
                ├─ 1 (001): Standard
                │     └─ bit4~
                │         ├─ 1           (001 1)        → Tiny Verb Edge
                │         ├─ 01          (001 01)       → Verb Edge
                │         ├─ 001         (001 001)      → Entity Node
                │         └─ 000         (001 000)      → Area terpadu 9-bit
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (cermin Standard)
```

## Tipe Paket

Aliran GEUL terdiri dari 9 tipe paket. Berikut diurutkan berdasarkan prioritas (alokasi bit Prefix = tingkat kepentingan).

| Tipe | Prefix | Word | Deskripsi |
|------|--------|------|-----------|
| Tiny Verb Edge | `0001 1` | 2 | Predikat sederhana frekuensi tinggi |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 root → 13.767 kata kerja WordNet |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, atribut 48-bit |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Properti/relasi, Top63 + ekstensi |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | 16 relasi diskursif berbasis RST |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | Peristiwa 5W1H |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | 64 tipe pandangan dunia/konteks |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 kode satuan, SI/mata uang/timestamp |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 bahasa pemrograman, 256 tipe node AST |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | 7 tipe himpunan/grup |

### Spesifikasi Umum

| Dokumen | Deskripsi |
|---------|-----------|
| [Format Aliran](../stream-format/) | Aturan format aliran, scoping TID, urutan paket |

## Aturan Encoding

| Item | Aturan |
|------|--------|
| Byte order | Big Endian |
| Bit order | MSB First (bit1 = MSB) |
| Ukuran word | 16-bit (2 byte) |

Semua field disejajarkan pada batas word 16-bit, dan ukuran paket selalu kelipatan word (2 byte). Jika perlu padding, diisi dengan 0x00.
