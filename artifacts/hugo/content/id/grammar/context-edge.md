---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "Edge ringan 3 word untuk menyatakan 'dalam pandangan dunia/konteks mana klaim ini benar'. 64 tipe — sumber, pandangan dunia, fiksi, perspektif — meng-encode kondisi kebenaran."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge menyatakan **"dalam pandangan dunia/konteks mana Claim ini benar"**.

Konsep ini bersesuaian dengan dunia-dunia yang mungkin (possible worlds) dalam logika modal: untuk Subject yang sama, fakta berbeda dapat eksis di pandangan dunia berbeda.

```
Context "realitas":         (Bumi, umur, 4,6 miliar tahun)
Context "bumi muda":        (Bumi, umur, 6000 tahun)
Context "Harry Potter":     (sihir, exists, true)
```

## Struktur Paket (3 word, 48 bit)

```
1st WORD (16 bit):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 bit        │     6 bit       │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bit)
3rd WORD: Target TID (16 bit)
```

| Field | Bit | Deskripsi |
|-------|-----|-----------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=tidak ditentukan, 1~62=tipe, 63=ekstensi (cadangan) |
| Context TID | 16 | ID unik Context ini |
| Target TID | 16 | Klaim target (TID [Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/)) |

## Context Type (6 bit = 64 tipe)

### Sumber (Source) — Code 1~20

| Code | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 1 | SYSTEM | Otomatis oleh sistem | Sinkronisasi Wikidata |
| 2 | USER | Input pengguna | Entri manual |
| 3 | DOCUMENT | Dokumen umum | PDF, Word |
| 4 | NEWS | Artikel berita | Reuters, AP |
| 5 | ACADEMIC | Makalah akademik | arXiv, Nature |
| 6 | GOVERNMENT | Pemerintah/lembaga publik | BPS, SEC |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | API eksternal | Keuangan, cuaca |
| 9 | ORG | Lembaga/organisasi | IR korporat |
| 10 | BOOK | Buku | Berbasis ISBN |
| 11 | INTERVIEW | Wawancara/kesaksian | Kutipan langsung |
| 12 | DATASET | Dataset | Kaggle |
| 13 | SOCIAL | Media sosial | Twitter |
| 14 | LEGAL | Hukum/yurisprudensi | Putusan pengadilan |
| 15 | ARCHIVE | Arsip | archive.org |
| 16 | MULTIMEDIA | Video/audio | YouTube |
| 17 | DATABASE | Database | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Ensiklopedia | Britannica |
| 19 | MANUAL | Manual/panduan | Dokumentasi teknis |
| 20 | STANDARD | Dokumen standar | ISO, RFC |

### Turunan/Inferensi (Derived) — Code 21~30

| Code | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 21 | MODEL | Generasi model AI | GPT, Claude |
| 22 | INFERENCE | Inferensi logis | Berbasis aturan |
| 23 | AGGREGATION | Agregasi/integrasi | Sintesis multi-sumber |
| 24 | CALCULATION | Hasil perhitungan | Penerapan rumus |
| 25 | TRANSLATION | Terjemahan | Asli→terjemahan |
| 26 | EXTRACTION | Ekstraksi | NER, RE |
| 27 | CORRECTION | Koreksi | Perbaikan kesalahan |
| 28 | HEARSAY | Kabar angin | Belum terverifikasi |
| 29 | ESTIMATION | Estimasi | Nilai perkiraan |
| 30 | PREDICTION | Prediksi | Prospek masa depan |

### Pandangan Dunia/Keyakinan (Worldview) — Code 31~45

| Code | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 31 | RELIGION | Pandangan religius | Islam, Buddhisme |
| 32 | PHILOSOPHY | Perspektif filosofis | Eksistensialisme |
| 33 | SCIENCE | Konsensus ilmiah | Fisika modern |
| 34 | POLITICS | Perspektif politik | Konservatif, progresif |
| 35 | CULTURE | Perspektif budaya | Timur, Barat |
| 36 | MYTHOLOGY | Sistem mitologi | Mitologi Yunani |
| 37 | FOLKLORE | Cerita rakyat | Legenda lokal |
| 38 | IDEOLOGY | Sistem ideologi | Kapitalisme |
| 39 | THEORY | Teori | Teori relativitas |
| 40 | HYPOTHESIS | Hipotesis | Sebelum verifikasi |
| 41 | TRADITION | Tradisi/adat | Tradisi Konfusianisme |
| 42 | CONSENSUS | Konsensus/arus umum | Paradigma akademik |
| 43 | MAINSTREAM | Pandangan arus utama | Pendapat mayoritas |
| 44 | ALTERNATIVE | Pandangan alternatif | Pendapat minoritas |
| 45 | FRINGE | Pinggiran/sesat | Pseudosains |

### Fiksi/Kreasi (Fiction) — Code 46~55

| Code | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 46 | NOVEL | Dunia novel | Lord of the Rings |
| 47 | FILM | Dunia film | MCU |
| 48 | GAME | Dunia game | Zelda |
| 49 | COMICS | Dunia komik | DC Universe |
| 50 | ANIMATION | Dunia animasi | Ghibli |
| 51 | DRAMA | Dunia drama | Game of Thrones |
| 52 | THEATER | Dunia teater | Hamlet |
| 53 | FANFIC | Fanfiksi | Kreasi penggemar |
| 54 | LEGEND | Legenda | Raja Arthur |
| 55 | FAIRYTALE | Dongeng | Cinderella |

### Perspektif/Narator (Perspective) — Code 56~62

| Code | Tipe | Deskripsi | Contoh |
|------|------|-----------|--------|
| 56 | NARRATOR | Perspektif narator | Narator mahatahu |
| 57 | PROTAGONIST | Perspektif protagonis | Sudut pandang pahlawan |
| 58 | ANTAGONIST | Perspektif antagonis | Sudut pandang penjahat |
| 59 | AUTHOR | Intensi penulis | Komentar penulis |
| 60 | EXPERT | Pendapat pakar | Opini ilmuwan |
| 61 | LAYMAN | Persepsi awam | Persepsi publik |
| 62 | SATIRICAL | Satir/ironi | Ekspresi ironis |

Code 0 adalah UNSPECIFIED (tidak ditentukan), Code 63 adalah EXTENDED (ekstensi, cadangan).

## Ekstensi Metadata

Informasi tambahan tentang Context itu sendiri (sumber, kepercayaan, nama dunia) dinyatakan melalui [Triple Edge](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)  - lembaga sumber
(Context TID, P:confidence, 0.95)               - kepercayaan
(Context TID, P:universe_name, "Harry Potter")  - nama dunia
(Context TID, P:perspective_holder, Villain_Entity)  - subjek perspektif
```

## Contoh

### Sumber: "Laporan Reuters"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

Triple tambahan:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Fiksi: "Dunia Harry Potter"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts is_a sekolah"

Triple tambahan:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### Inferensi AI: "Inferensi Claude"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

Triple tambahan:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Alasan Desain

- **Context Edge sebagai tipe tersendiri**: Pandangan dunia adalah lapisan meta yang berbeda dari Triple/Clause. Bersesuaian dengan G (Graph) di RDF Quad.
- **6-bit Context Type**: Klasifikasi instan tanpa Triple terpisah. 62 tipe mencakup sebagian besar kasus.
- **Struktur ringan 3 word**: Koneksi Context terjadi secara masif, sehingga ukuran minimal memastikan efisiensi penyimpanan.
