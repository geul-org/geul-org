---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "Node panjang variabel 4~7 word untuk besaran fisik, bilangan, mata uang, dan literal. 6-bit Unit meng-encode satuan dasar/turunan SI, mata uang, dan literal khusus, serta 4-bit Scale mewakili prefiks SI."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node adalah tipe Node panjang variabel untuk menyatakan **besaran fisik, bilangan, mata uang, dan literal**.

| Karakteristik | Deskripsi |
|---------------|-----------|
| **Panjang variabel** | 4~N word (tergantung ukuran nilai) |
| **Satuan eksplisit** | Dasar/turunan SI + non-SI (mata uang, waktu, dll.) |
| **Dukungan skala** | Prefiks melalui pangkat 10 |
| **Literal khusus** | Waktu (timestamp), string (UTF-16), warna (RGBA) |
| **TID di akhir** | Karakteristik Node (konsistensi dengan [Entity Node](../entity-node/)) |

**Kegunaan:** Object [Triple Edge](../triple-edge/), partisipan Verb Edge, partisipan [Event6](../event6-edge/), nama/label entitas, representasi waktu, dll.

## Struktur Paket

```
1st WORD (16 bit)
┌────────────────────┬────────────────────┐
│      Prefix        │       Unit         │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bit)
┌──────┬──────┬──────┬────────────────────┐
│ Sign │ Size │ Type │      Scale         │
│ 1bit │ 2bit │ 1bit │       4bit         │
├──────┴──────┴──────┴────────────────────┤
│              Reserved (8bit)            │
└─────────────────────────────────────────┘

3rd+ WORD: Value (variabel, 1/2/4 word sesuai Size)

Last WORD (16 bit)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Field | Bit | Ukuran | Deskripsi |
|-------|-----|--------|-----------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 kode satuan |
| Sign | 17 | 1 | 0=positif, 1=negatif |
| Size | 18-19 | 2 | Jumlah word Value |
| Type | 20 | 1 | 0=integer, 1=floating point |
| Scale | 21-24 | 4 | Pangkat 10 (offset 8) |
| Reserved | 25-32 | 8 | Cadangan (kode mata uang jika CURRENCY) |

### Ukuran Paket per Size

| Size | Word Value | Total word |
|------|------------|------------|
| 00 | 1 (16 bit) | 4 |
| 01 | 2 (32 bit) | 5 |
| 10 | 4 (64 bit) | 7 |

## Kode Satuan (6 bit = 64)

### Satuan Dasar SI (0x00~0x06)

| Kode | Satuan | Simbol | Besaran |
|------|--------|--------|---------|
| 0x00 | meter | m | Panjang |
| 0x01 | kilogram | kg | Massa |
| 0x02 | second | s | Waktu |
| 0x03 | ampere | A | Arus listrik |
| 0x04 | kelvin | K | Suhu |
| 0x05 | mole | mol | Jumlah zat |
| 0x06 | candela | cd | Intensitas cahaya |

### Satuan Turunan SI (0x07~0x1C)

| Kode | Satuan | Simbol | Besaran |
|------|--------|--------|---------|
| 0x07 | hertz | Hz | Frekuensi |
| 0x08 | newton | N | Gaya |
| 0x09 | pascal | Pa | Tekanan |
| 0x0A | joule | J | Energi |
| 0x0B | watt | W | Daya |
| 0x0C | coulomb | C | Muatan listrik |
| 0x0D | volt | V | Tegangan |
| 0x0E | farad | F | Kapasitansi |
| 0x0F | ohm | Ω | Hambatan |
| 0x10 | siemens | S | Konduktansi |
| 0x11 | weber | Wb | Fluks magnetik |
| 0x12 | tesla | T | Medan magnet |
| 0x13 | henry | H | Induktansi |
| 0x14 | celsius | °C | Suhu |
| 0x15 | lumen | lm | Fluks cahaya |
| 0x16 | lux | lx | Iluminansi |
| 0x17 | becquerel | Bq | Radioaktivitas |
| 0x18 | gray | Gy | Dosis serap |
| 0x19 | sievert | Sv | Dosis ekivalen |
| 0x1A | katal | kat | Aktivitas katalitik |
| 0x1B | radian | rad | Sudut datar |
| 0x1C | steradian | sr | Sudut ruang |

### Satuan Non-SI (0x20~0x2F)

| Kode | Satuan | Kegunaan |
|------|--------|----------|
| 0x20 | CURRENCY | Mata uang (ekstensi kode) |
| 0x21 | percent | % (rasio) |
| 0x22 | degree | ° (sudut) |
| 0x23~0x28 | minute~year | Satuan waktu |
| 0x29 | bit | Informasi |
| 0x2A | byte | Informasi |
| 0x2B~0x2F | COUNT~INDEX | Bilangan tanpa satuan |

### Literal Khusus (0x30~0x3F)

| Kode | Tipe | Payload | Kegunaan |
|------|------|---------|----------|
| 0x30 | TIMESTAMP_SEC | 2/4 word | Unix timestamp (detik) |
| 0x31 | TIMESTAMP_MS | 4 word | Unix timestamp (milidetik) |
| 0x32 | UTF16 | 2+N word | String UTF-16 |
| 0x33 | RGBA | 2 word | Warna (32 bit) |

## Scale (4 bit)

Pangkat 10. Offset 8 diterapkan. **Rumus:** `nilai aktual = Value × 10^(Scale - 8)`

| Kode | Nilai | Prefiks | Kode | Nilai | Prefiks |
|------|-------|---------|------|-------|---------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (default)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Ekstensi Mata Uang (Unit = 0x20)

Jika CURRENCY, 8 bit Reserved digunakan sebagai kode mata uang.

| Kode | Mata uang | ISO | Kode | Mata uang | ISO |
|------|-----------|-----|------|-----------|-----|
| 0x00 | Dolar AS | USD | 0x05 | Won Korea | KRW |
| 0x01 | Euro | EUR | 0x06 | Franc Swiss | CHF |
| 0x02 | Yen Jepang | JPY | 0x07 | Dolar Australia | AUD |
| 0x03 | Poundsterling | GBP | 0x08 | Dolar Kanada | CAD |
| 0x04 | Yuan Tiongkok | CNY | 0x80 | Bitcoin | BTC |

## Contoh

### "100 kg" → 4 word

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 word, int, ×1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretasi: +100 × 10⁰ kg = 100 kg
```

### "$2.500.000" → 4 word (dengan skala)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 word, int, ×10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretasi: +2500 × 10³ USD = $2.500.000
```
