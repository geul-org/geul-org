---
title: "Peran Partisipan"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "16 peran Participant yang mendefinisikan peran semantik dalam peristiwa. Encoding 4-bit mencakup peran inti Agent, Theme, Recipient hingga peran tambahan Cause dan Purpose."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Participant (partisipan)** adalah Edge yang menentukan **peran semantik** entitas yang terlibat dalam peristiwa predikat.

```
Event Node (kata kerja)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Prinsip Desain

### Prinsip Pemisahan

| Kategori | Milik | Contoh |
|----------|-------|--------|
| **Partisipan** | Level Event | Agent, Theme, Recipient |
| **Info pragmatik** | Level Context/Claim | Speaker, Listener, Evidentiality |

Speaker (pembicara), Listener (pendengar), Source (sumber informasi) diproses bukan sebagai partisipan, melainkan di **[kualifikator semantik](../qualifier/)** atau Context/Claim.

### Encoding

- **4 bit** (0x0~0xF), maksimum 16 peran semantik
- Pattern matching melalui operasi bit SIMD

## Daftar Peran Semantik (16)

### Partisipan Inti (Core Participants)

| ID | Kode | Peran | Definisi | Contoh |
|----|------|-------|----------|--------|
| 0x0 | **AGT** | Agent (pelaku) | Subjek yang sengaja melakukan tindakan | "**Budi** menendang bola" |
| 0x1 | **EXP** | Experiencer (pengalami) | Subjek yang mengalami emosi/persepsi | "**Sari** sedih" |
| 0x2 | **THM** | Theme (tema) | Objek yang dipindahkan atau dideskripsikan | "Budi menendang **bola**" |
| 0x3 | **PAT** | Patient (pasien) | Objek yang keadaannya berubah | "**Kaca** pecah" |
| 0x4 | **RCP** | Recipient (penerima) | Yang menerima sesuatu | "Memberi buku **kepada Sari**" |
| 0x5 | **BNF** | Beneficiary (penerima manfaat) | Yang mendapat keuntungan | "Membuat **untuk anak**" |

### Alat dan Cara (Instruments & Means)

| ID | Kode | Peran | Definisi | Contoh |
|----|------|-------|----------|--------|
| 0x6 | **INS** | Instrument (alat) | Alat yang digunakan | "Memaku **dengan palu**" |
| 0x7 | **MNR** | Manner (cara) | Cara tindakan dilakukan | "Berlari **dengan cepat**" |

### Spasial (Spatial)

| ID | Kode | Peran | Definisi | Contoh |
|----|------|-------|----------|--------|
| 0x8 | **LOC** | Location (lokasi) | Tempat peristiwa terjadi | "Tinggal **di Jakarta**" |
| 0x9 | **SRC** | Source (asal) | Titik awal perpindahan | "Berangkat **dari rumah**" |
| 0xA | **DST** | Destination (tujuan) | Titik akhir perpindahan | "Pergi **ke sekolah**" |
| 0xB | **PTH** | Path (jalur) | Titik yang dilalui | "Melewati **taman**" |

### Kausal (Causal)

| ID | Kode | Peran | Definisi | Contoh |
|----|------|-------|----------|--------|
| 0xC | **CAU** | Cause (sebab) | Penyebab peristiwa | "Dibatalkan **karena hujan**" |
| 0xD | **PRP** | Purpose (tujuan) | Tujuan tindakan | "Pergi **untuk berolahraga**" |

### Lainnya (Others)

| ID | Kode | Peran | Definisi | Contoh |
|----|------|-------|----------|--------|
| 0xE | **COM** | Comitative (pendamping) | Objek yang menemani | "Pergi **bersama teman**" |
| 0xF | **ATR** | Attribute (atribut) | Deskripsi keadaan/sifat | "Langit **biru**" |

## Struktur Participant Edge

```
PARTICIPANT Edge {
    source:     Event SIDX       // node kata kerja
    target:     Entity SIDX      // node entitas
    role:       4-bit            // peran semantik (0x0~0xF)
    gram_role:  2-bit (optional) // peran gramatikal (subjek/objek/predikatif)
    focus:      4-bit (optional) // tingkat penekanan (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // referensi kualifikator
}
```

| Field | Bit | Deskripsi |
|-------|-----|-----------|
| role | 4 | Peran semantik (wajib) |
| gram_role | 2 | 0=tidak ditentukan, 1=subjek, 2=objek, 3=predikatif |
| focus | 4 | Kepentingan informasional (0=latar belakang, 15=penekanan utama) |
| quant_ref | 16 | TID kualifikator "semua", "sebagian besar", dll. |

## Theme vs Patient

| Peran | Perubahan keadaan | Contoh |
|-------|-------------------|--------|
| Theme | Tidak (perpindahan/deskripsi) | "**Melempar** bola" (bola tidak berubah) |
| Patient | Ya (terpengaruh) | "**Memecahkan** kaca" (kaca berubah keadaan) |

Secara praktis, bisa digabungkan ke Theme dan dibedakan berdasarkan semantik kata kerja jika diperlukan.

## Contoh

### Kalimat sederhana: "Budi memberikan buku kepada Sari"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → Budi
├─ PARTICIPANT (THM) → buku
└─ PARTICIPANT (RCP) → Sari
```

### Kalimat kompleks: "Karena hujan, berlari cepat bersama teman dari rumah ke sekolah"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [pembicara]
├─ PARTICIPANT (CAU) → hujan
├─ PARTICIPANT (COM) → teman
├─ PARTICIPANT (SRC) → rumah
├─ PARTICIPANT (DST) → sekolah
└─ PARTICIPANT (MNR) → cepat
```

### Deskripsi keadaan: "Langit sangat biru"

```
Event: be.v.01
├─ PARTICIPANT (THM) → langit
└─ PARTICIPANT (ATR) → biru (focus=15)
```

## Normalisasi Aktif/Pasif

| Bentuk permukaan | Agent | Theme |
|------------------|-------|-------|
| "Apple mengakuisisi Tesla" | Apple | Tesla |
| "Tesla diakuisisi oleh Apple" | Apple | Tesla |

Pada tahap parsing, bentuk dinormalisasi ke pola yang sama.
