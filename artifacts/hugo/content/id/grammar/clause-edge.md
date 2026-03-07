---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "Edge tetap 4 word untuk relasi logis dan diskursif antar predikat, peristiwa, dan relasi. 16 tipe relasi berbasis RST meng-encode hubungan kausal, temporal, kontras, dan argumentatif."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge adalah tipe Edge untuk menyatakan **relasi logis/diskursif** antar predikat ([Verb Edge](../verb-edge/)), peristiwa ([Event6 Edge](../event6-edge/)), relasi ([Triple Edge](../triple-edge/)), atau Clause lainnya.

Didesain berdasarkan relasi diskursif RST (Rhetorical Structure Theory).

## Struktur Paket (4 word, 64 bit)

```
1st WORD (16 bit):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │ Tipe relasi│Cadangan│
│       10 bit        │   4 bit    │ 2 bit  │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 bit)
3rd WORD: TID 1 (16 bit) - klausa pertama
4th WORD: TID 2 (16 bit) - klausa kedua
```

| Field | Bit | Deskripsi |
|-------|-----|-----------|
| Prefix | 10 | `1100 000 010` |
| Tipe relasi | 4 | 16 relasi diskursif RST |
| Cadangan | 2 | Ekstensi masa depan |
| Edge TID | 16 | ID unik Edge ini |
| TID 1 | 16 | Referensi klausa pertama |
| TID 2 | 16 | Referensi klausa kedua |

## Tipe Relasi (4 bit = 16)

### Relasi Kausal

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 0000 | CAUSE | Sebab→akibat | "Karena hujan, tinggal di rumah" |
| 0001 | RESULT | Akibat←sebab | "Tinggal di rumah, karena hujan" |
| 0010 | CONDITION | Syarat→konsekuensi | "Kalau hujan, tidak pergi" |
| 0011 | PURPOSE | Tujuan | "Makan untuk hidup" |

### Relasi Temporal/Urutan

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 0100 | SEQUENCE | Kronologis | "Makan lalu tidur" |
| 0101 | PARALLEL | Simultan | "Berbicara sambil tersenyum" |

### Relasi Kontras/Konsesi

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 0110 | CONTRAST | Kontras | "A besar dan B kecil" |
| 0111 | CONCESSION | Konsesi | "Sulit tapi berhasil" |

### Relasi Elaborasi/Latar

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 1000 | ELABORATION | Perincian | "Lebih spesifik lagi" |
| 1001 | BACKGROUND | Informasi latar | "Untuk informasi, situasinya..." |

### Relasi Argumentasi

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 1010 | EVIDENCE | Bukti | "Karena... itulah sebabnya" |
| 1011 | EVALUATION | Evaluasi | "Ini baik/buruk" |

### Relasi Lainnya

| Kode | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 1100 | SOLUTIONHOOD | Masalah→solusi | "Masalah X, solusi Y" |
| 1101 | ALTERNATIVE | Alternatif | "Pergi atau tidak" |
| 1110 | MEANS | Sarana | "Dengan cara ini tercapai" |
| 1111 | RESERVED | Cadangan | Ekstensi masa depan |

## Aturan Urutan TID

Arah ditentukan oleh urutan TID.

| Relasi | TID 1 | TID 2 |
|--------|-------|-------|
| CAUSE | Sebab | Akibat |
| RESULT | Akibat | Sebab |
| CONDITION | Syarat | Konsekuensi |
| PURPOSE | Tindakan | Tujuan |
| SEQUENCE | Pendahulu | Penerus |
| EVIDENCE | Bukti | Klaim |
| ELABORATION | Inti | Perincian |

## Multinuclear vs Nucleus-Satellite

Mengikuti pembedaan RST.

### Nucleus-Satellite (asimetris)

| Relasi | TID 1 | TID 2 |
|--------|-------|-------|
| CAUSE | Sebab (Satellite) | Akibat (Nucleus) |
| CONDITION | Syarat (Satellite) | Konsekuensi (Nucleus) |
| EVIDENCE | Bukti (Satellite) | Klaim (Nucleus) |
| ELABORATION | Inti (Nucleus) | Perincian (Satellite) |

### Multinuclear (simetris)

| Relasi | TID 1 | TID 2 |
|--------|-------|-------|
| SEQUENCE | Pendahulu | Penerus |
| PARALLEL | Pertama | Kedua |
| CONTRAST | Pertama | Kedua |
| ALTERNATIVE | Pertama | Kedua |

Dalam relasi simetris, urutan TID tidak menunjukkan prioritas semantik.

## Contoh

### Kausal sederhana: "Karena hujan, tinggal di rumah"

```
Verb Edge E01: rain(hujan) | TID=0x0001
Verb Edge E02: stay(saya, rumah) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + cadangan
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (sebab: E01)
  4th: [0x0002]                    - TID 2 (akibat: E02)
```

### Clause bersarang: "Karena hujan tinggal di rumah, dan karena itu belajar"

```
Verb Edge E01: rain(hujan) | TID=0x0001
Verb Edge E02: stay(saya, rumah) | TID=0x0002
Verb Edge E03: study(saya) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (referensi ke Clause TID!)
  4th: [0x0003]                    - E03
```

## Alasan Desain

### Mengapa RST

- Lebih dari 30 tahun penelitian
- Tervalidasi di berbagai korpus
- Tersedia alat parsing diskursif
- Independen bahasa

### Mengapa 4 bit (16 tipe)

- Mencakup 12+ relasi inti RST
- Cadangan untuk ekstensi
- 3 bit (8 tipe) tidak cukup

### Mengapa penyederhanaan ke 4 word

- Arah: ditentukan oleh urutan TID (bit tambahan tidak perlu)
- Keyakinan: ditangani metadata terpisah
- 2 bit cadangan: untuk ekstensi masa depan
