---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Tipe Edge untuk menyatakan relasi dan properti dalam bentuk (Subject, Property, Object). Struktur ganda mode dasar 4 word dan mode ekstensi 5 word mengoptimalkan Top 63 properti frekuensi tinggi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge adalah tipe Edge untuk menyatakan **relasi/properti** dalam bentuk `(Subject, Property, Object)`.

## Desain Mode Ganda

- **Mode dasar (4 word):** PropCode 0~62 (Top 63 properti)
- **Mode ekstensi (5 word):** PropCode=63 mencakup semua P-ID (penyelarasan semantik 16-bit)

## Mode Dasar (4 word = 64 bit)

```
1st WORD (16 bit)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 bit)
3rd WORD: Subject TID (16 bit)
4th WORD: Object TID (16 bit)
```

| Field | Bit | Deskripsi |
|-------|-----|-----------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 properti, 63: mode ekstensi |
| Edge TID | 16 | TID Edge ini |
| Subject TID | 16 | TID subjek Entity/Node |
| Object TID | 16 | TID objek Entity/Node/Quantity |

## Mode Ekstensi (5 word = 80 bit)

Jika PropCode = 63, word ke-3 berisi P-ID 16-bit.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bit)
3rd WORD: P-ID penyelarasan semantik (16 bit)
4th WORD: Subject TID (16 bit)
5th WORD: Object TID (16 bit)
```

## Top 63 Properti (PropCode 0~62)

Properti dipilih berdasarkan frekuensi penggunaan Wikidata.

### Klasifikasi/tipe (Code 0~7)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 0 | P31 | instance of | Instansi dari |
| 1 | P279 | subclass of | Subkelas dari |
| 2 | P361 | part of | Bagian dari |
| 3 | P527 | has part | Memiliki bagian |
| 4 | P1552 | has quality | Kualitas/sifat |
| 5 | P460 | same as | Sama dengan |
| 6 | P1889 | different from | Berbeda dari |
| 7 | P156 | followed by | Diikuti oleh |

### Spasial/lokasi (Code 8~15)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 8 | P17 | country | Negara |
| 9 | P131 | located in | Lokasi (wilayah administratif) |
| 10 | P276 | location | Lokasi (tempat) |
| 11 | P625 | coordinate | Koordinat |
| 12 | P30 | continent | Benua |
| 13 | P36 | capital | Ibu kota |
| 14 | P150 | contains | Berisi (wilayah) |
| 15 | P206 | located next to | Perairan berdekatan |

### Waktu (Code 16~23)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 16 | P569 | date of birth | Tanggal lahir |
| 17 | P570 | date of death | Tanggal wafat |
| 18 | P571 | inception | Tanggal pendirian |
| 19 | P576 | dissolved | Tanggal pembubaran |
| 20 | P577 | publication date | Tanggal publikasi |
| 21 | P580 | start time | Waktu mulai |
| 22 | P582 | end time | Waktu selesai |
| 23 | P585 | point in time | Titik waktu |

### Data dasar individu (Code 24~31)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 24 | P19 | place of birth | Tempat lahir |
| 25 | P20 | place of death | Tempat wafat |
| 26 | P21 | sex or gender | Jenis kelamin |
| 27 | P27 | citizenship | Kewarganegaraan |
| 28 | P735 | given name | Nama depan |
| 29 | P734 | family name | Nama keluarga |
| 30 | P1559 | name in native language | Nama asli |
| 31 | P742 | pseudonym | Nama samaran |

### Relasi/keanggotaan (Code 32~39)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 32 | P22 | father | Ayah |
| 33 | P25 | mother | Ibu |
| 34 | P26 | spouse | Pasangan |
| 35 | P40 | child | Anak |
| 36 | P3373 | sibling | Saudara kandung |
| 37 | P463 | member of | Anggota dari |
| 38 | P108 | employer | Pemberi kerja |
| 39 | P1027 | conferred by | Diberikan oleh (lembaga) |

### Profesi/aktivitas (Code 40~47)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 40 | P106 | occupation | Profesi |
| 41 | P39 | position held | Jabatan |
| 42 | P69 | educated at | Pendidikan |
| 43 | P101 | field of work | Bidang kerja |
| 44 | P1344 | participant in | Partisipasi (peristiwa) |
| 45 | P166 | award received | Penghargaan |
| 46 | P800 | notable work | Karya utama |
| 47 | P1412 | languages spoken | Bahasa yang digunakan |

### Media/identifikasi (Code 48~55)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 48 | P18 | image | Gambar |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Bendera |
| 51 | P373 | Commons category | Wikimedia |
| 52 | P856 | official website | Situs resmi |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Karya/kreasi (Code 56~62)

| Code | P-ID | Properti | Deskripsi |
|------|------|----------|-----------|
| 56 | P50 | author | Penulis |
| 57 | P57 | director | Sutradara |
| 58 | P86 | composer | Komposer |
| 59 | P175 | performer | Pemain/penyanyi |
| 60 | P136 | genre | Genre |
| 61 | P364 | original language | Bahasa asli |
| 62 | P123 | publisher | Penerbit |

Code 63 dicadangkan sebagai **penanda mode ekstensi**.

## Ringkasan PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   Klasifikasi/tipe (P31, P279, ...)  │
│  8~15:  Spasial/lokasi (P17, P131, ...)    │
│  16~23: Waktu (P569, P570, ...)            │
│  24~31: Data individu (P19, P20, ...)      │
│  32~39: Relasi/keanggotaan (P22, P25, ...) │
│  40~47: Profesi/aktivitas (P106, P39, ...) │
│  48~55: Media/identifikasi (P18, P856, ...)│
│  56~62: Karya/kreasi (P50, P57, ...)       │
├─────────────────────────────────────────────┤
│  63: Penanda mode ekstensi                  │
└─────────────────────────────────────────────┘
```

## Contoh

### Mode dasar: "Apple adalah perusahaan"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - perusahaan (Object)

Total: 4 word
```

### Mode ekstensi: "Tinggi Menara Eiffel adalah 330 m"

```
P2048 (height) → di luar Top 63 → mode ekstensi

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - penyelarasan semantik P2048
  4th: [TID: 0x0030]              - Menara Eiffel (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 word
```

## Parsing

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Mode dasar (4 word)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Mode ekstensi (5 word)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
