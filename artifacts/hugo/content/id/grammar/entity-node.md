---
title: "Entity Node"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "Node panjang tetap 4 word (64-bit) untuk mengidentifikasi entitas: orang, tempat, benda, dan organisasi. 3-bit Mode untuk kuantifikasi/bilangan, 6-bit EntityType untuk 64 tipe atas, dan 48-bit Attributes untuk atribut semantik per tipe."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** adalah **paket panjang tetap 4 word (64-bit)** dalam aliran GEUL yang mengidentifikasi entitas (orang, tempat, benda, organisasi, konsep, dll.).

## Esensi SIDX

| Karakteristik | Deskripsi |
|---------------|-----------|
| **Non-unique** | Satu SIDX dapat memetakan beberapa entitas |
| **Multi-SIDX** | Satu entitas dapat memiliki beberapa SIDX (per waktu/peran) |
| **Bit = makna** | Posisi bit itu sendiri mewakili atribut |
| **Spektrum abstrak/konkret** | Dibedakan oleh tingkat pengisian Mode dan Attributes |

**Contoh:**
- Trump (pengusaha properti) → SIDX_A
- Trump (presiden) → SIDX_B (SIDX berbeda)
- "Human + Male + Korea" → abstrak "pria Korea"
- "Human + Male + Korea + 1946 + Business + ..." → hampir individu tertentu

## Prinsip Desain

**Penghapusan Q-ID bawaan:**
- Semua bit diinvestasikan untuk penyelarasan semantik murni
- Maksimalisasi kinerja SIMD filtering WMS
- Q-ID dihubungkan secara terpisah melalui [Triple Edge](../triple-edge/): `(Entity_SIDX, P-externalID, "Q12345")`

**Serial bit tidak diperlukan:**
- Query WMS dua tahap: penyempitan SIMD → pemeriksaan detail dalam rentang
- Serial adalah angka tanpa makna yang tidak berkontribusi pada SIMD
- Menginvestasikan bit tersebut untuk penyelarasan semantik mempersempit rentang di tahap pertama

## Tata Letak Bit (4 word = 64 bit)

```
1st WORD (16 bit)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 bit)
┌─────────────────────────────┐
│     Attributes 16 bit atas  │
└─────────────────────────────┘

3rd WORD (16 bit)
┌─────────────────────────────┐
│     Attributes 16 bit tengah│
└─────────────────────────────┘

4th WORD (16 bit)
┌─────────────────────────────┐
│     Attributes 16 bit bawah │
└─────────────────────────────┘
```

| Field | Bit | Ukuran | Deskripsi |
|-------|-----|--------|-----------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 mode kuantifikasi/bilangan |
| EntityType | 11-16 | 6 | 64 tipe atas |
| Attributes | 17-64 | **48** | Skema variabel per tipe |

## Mode (3 bit)

Mode mengintegrasikan **kuantifikasi (Quantification) dan bilangan (Number)** entitas dalam 3 bit.

| Kode | Biner | Makna | Contoh |
|------|-------|-------|--------|
| 0 | 000 | **Entitas terdaftar** | Soekarno, Samsung, BTS |
| 1 | 001 | Tunggal tertentu | "orang itu" |
| 2 | 010 | Beberapa tertentu | "beberapa orang itu" |
| 3 | 011 | Banyak tertentu | "orang-orang itu" |
| 4 | 100 | Universal | "semua ~" |
| 5 | 101 | Eksistensial | "suatu ~" |
| 6 | 110 | Tak tentu | "siapa saja ~" |
| 7 | 111 | Generik | "~ secara umum" |

### Entitas Terdaftar (Mode=0)

- Entitas yang dipetakan ke ID eksternal: Wikidata Q-ID, WordNet Synset, dll.
- Q-ID dihubungkan melalui Triple: `(Entity_SIDX, P-externalID, "Q12345")`
- **Tidak terkait konsep bilangan**: Samsung adalah "satu" tapi sulit disebut tunggal, BTS adalah grup tapi satu entitas

### Pronomina/Abstraksi (Mode=1~7)

- Rentang semantik ditentukan oleh EntityType + Attributes
- Semakin banyak bit terisi, semakin spesifik
- Contoh: Human(Type) + Male(Attr) + Korea(Attr) = "pria Korea"

## EntityType (6 bit = 64 tipe)

64 tipe atas dialokasikan berdasarkan statistik frekuensi Wikidata P31 (instance of). Subklasifikasi ditangani oleh bit subkelas dalam Attributes.

| Rentang | Kategori | Jumlah | Tipe Representatif |
|---------|----------|--------|---------------------|
| 0x00-0x07 | Biologi/tokoh | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | Kimia/material | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | Benda langit | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | Geografi/alam | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | Tempat/administratif | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | Bangunan | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | Organisasi | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | Karya | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | Peristiwa/lainnya | 4 | SportsSeason, Event, Election, Other |

### Tabel Kode (64 lengkap)

| Kode | Tipe | Q-ID | Jumlah |
|------|------|------|--------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | Untuk ekstensi |

## Attributes (48 bit)

**Skema variabel per tipe** yang diinterpretasikan berbeda untuk setiap EntityType. Atribut frekuensi tinggi mendapat alokasi bit lebih banyak. Digunakan langsung dalam SIMD filtering WMS.

### Attributes Human (0x00)

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ Subkelas │Profesi │Kewarga.│ Era  │ Dekade │Kelamin │Ketenaran│  Bahasa  │ Wil. lahir │Bid. aktiv│
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Attributes Star (0x0C)

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Rasi bintang│Tipe spektral│Kelas lum.│Mag. semu │RA      │ Dekl.  │  Flag    │Kec.radial│Redshift│Paralaks│
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**Definisi bit flag:**
- bit0: IR (sumber inframerah)
- bit1: Radio (sumber radio)
- bit2: X-ray (sumber sinar-X)
- bit3: Binary (bintang ganda)
- bit4: Variable (bintang variabel)
- bit5: HighPM (gerak diri tinggi)

## Operasi

### Pembuatan Entity

```python
def make_entity(
    mode: int,           # 3 bit
    entity_type: int,    # 6 bit
    attrs: int           # 48 bit
) -> bytes:
    PREFIX = 0b0001001   # 7 bit (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### Parsing Entity

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## Contoh

### Entitas Terdaftar: Soekarno

```python
# Soekarno (Q4224)
soekarno = make_entity(
    mode=0,              # Entitas terdaftar
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # Subkelas: Political
        (0x01 << 37) |   # Profesi: President
        (0x52 << 29) |   # Kewarganegaraan: Indonesia
        (0x5 << 25) |    # Era: Modern
        (0x0 << 21) |    # Dekade: 1900s
        (0x01 << 19) |   # Kelamin: Male
        (0x7 << 16)      # Ketenaran: 1000+
    )
)
# Koneksi Q-ID: Triple(soekarno_SIDX, P-externalID, "Q4224")
```

### Abstraksi: "semua pria Indonesia"

```python
all_indonesian_men = make_entity(
    mode=4,              # Universal (semua)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Kewarganegaraan: Indonesia
        (0x01 << 19)     # Kelamin: Male
    )
)
```

## Pemetaan Subtipe

Banyak tipe Wikidata merupakan subtipe dari 64 EntityType. Encoder merutekan nilai P31 ke tipe atas yang sesuai.

| Subtipe (P31) | Tipe Atas | Jumlah |
|---------------|-----------|--------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## Cakupan

| Item | Nilai |
|------|-------|
| Total entitas Wikidata | 117.419.925 |
| Internal Wikimedia (dikecualikan) | 8.565.353 (7,3%) |
| Target SIDX | 108.854.572 (92,7%) |
| Cakupan langsung 64 tipe | 36.295.074 (33,3%) |
| Penyerapan subtipe | 71.842.429 (66,0%) |
| Fallback Other | 717.069 (0,7%) |
| **Cakupan akhir** | **100%** |
| **Tingkat tabrakan** | **< 0,01%** |

## Koneksi Q-ID

Entity Node tidak menyertakan Q-ID secara internal, melainkan dihubungkan melalui [Triple Edge](../triple-edge/).

```
Subject:  Entity_SIDX (64 bit)
Property: P-externalID (mis. P-Wikidata)
Object:   "Q12345" (string atau integer)
```
