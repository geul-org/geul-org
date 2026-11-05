---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH adalah Value koordinat yang menyatakan satu titik di Bumi dengan lintang, bujur, dan ketidakpastian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `COORDINATE-EARTH` (dokumen spesifikasi BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000640/` (sasaran DECLARE `0640`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 4 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | lintang dan bujur Bumi (WGS 84) binary64, ketidakpastian binary32, dan Reference satuannya (ABSENT = tidak diketahui) |
| Sisi Hugo | `value/numeric/coordinate-earth.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | nilai mentah 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | nilai mentah 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | nilai mentah 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0000` ABSENT (field opsional) |  |

COORDINATE-EARTH adalah Value koordinat yang menyatakan satu titik di Bumi dengan lintang, bujur, dan ketidakpastian. Kode langsung Value `0x064L`, keluarga NUMERIC. Maknanya sama dengan `geo:lintang,bujur;u=ketidakpastian` (sistem koordinat WGS 84) pada [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), dan disimpan sebagai nilai numerik berlebar tetap, bukan string. Ketidakpastian ditulis bersama satuannya. Koordinat benda langit di luar Bumi ditulis dengan [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Longitude         4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Uncertainty       2 WORD nilai mentah, IEEE 754 binary32 (satuan Unit)
Unit              1 record Reference, atau penanda slot 0x0000 ABSENT
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload terdiri dari Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD, lalu tepat satu record Unit. Kursor setelah membaca Unit harus berhenti tepat di akhir record.
- Sistem koordinatnya WGS 84 (`crs=wgs84` bawaan RFC 5870).
- Latitude dan Longitude adalah IEEE 754 binary64 dari WORD Payload yang disambung dengan urutan big-endian (tata letak bit sama dengan binary64 pada [BINARY-FLOAT](0x063L-binary-float.md)). Satuannya derajat (°).
  - Harus berupa nilai berhingga. NaN dan ±Infinity adalah invalid.
  - Latitude `-90 ≤ φ ≤ 90` (utara positif), Longitude `-180 ≤ λ ≤ 180` (timur positif).
  - Urutan sumbu adalah lintang, bujur (sama dengan RFC 5870 dan ISO 6709). Bukan urutan x (bujur), y (lintang) seperti pada WKB dan GeoJSON.
- Uncertainty adalah IEEE 754 binary32 dari 2 WORD yang disambung secara big-endian (tata letak bit sama dengan binary32 pada BINARY-FLOAT). Artinya posisi sebenarnya berada dalam radius ini, dan nilainya dibaca dalam satuan Unit.
  - Harus berhingga dan `+0` atau lebih besar. Nilai negatif, `-0` (`8000 0000`), NaN, dan ±Infinity adalah invalid.
  - `0` (ketika Unit ada): koordinat yang tepat. Sama saja ditulis dalam satuan apa pun.
- Unit adalah Reference yang menunjuk satuan Uncertainty. Value tidak diterima. Quantifier-nya Identified.
  - Dianjurkan memakai butir satuan Wikidata [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md): derajat Q28390, menit busur Q209426, detik busur Q829073, meter Q11573, milimeter Q174789, dan sebagainya. Satuan yang tidak punya QID ditunjuk dengan Reference lain (LOCAL, GEUL, dan sebagainya). Jika ada beberapa Reference yang menunjuk satuan yang sama, QID adalah bentuk kanonik.
  - Jika Unit adalah meter (Q11573), Uncertainty sama dengan `u` pada RFC 5870.
- **Tidak diketahui**: tulis [ABSENT](../slot-marker.md) (`0x0000`) pada posisi Unit dan isi Uncertainty dengan `+0` (`0000 0000`). Sama dengan kasus `u` dihilangkan pada RFC 5870. Jika ABSENT tetapi Uncertainty bukan `+0`, itu invalid (representasi dikunci menjadi satu).
- Ketinggian tidak dimuat. Jika diperlukan, ditetapkan dengan format tersendiri. Altitude Wikidata tidak dipakai pada sampel (0/23.066), dan jika ada nilainya, tidak dikonversi dan teks aslinya disimpan sebagai UTF8-TEXT.
- Untuk koordinat Bumi, dianjurkan memakai format ini. Koordinat yang menuliskan Bumi (Q2) pada COORDINATE-GEO juga bukan invalid, dan pihak pembanding mencocokkannya sebagai koordinat yang sama.
- Dokumen spesifikasi geul.org `0x00000000/codecs/0x00000640` menaruh [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) pada field nilai mentah Latitude, Longitude, dan Uncertainty (4 WORD = binary64, 2 WORD = binary32), dan menaruh CODEC `000F`, `020F`, `040F` (Reference apa pun) dan `0000` (ABSENT) pada field record Unit.

## Panjang {#길이}

- Total adalah TAG 1 WORD + 10 WORD + record Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| Jika QID muat dalam 1 WORD (2 WORD, mis. derajat Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| Jika QID 2 WORD (3 WORD, mis. menit busur Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Record Unit 4 WORD atau lebih | 15 WORD atau lebih | panjang perluasan ([Record dan TAG WORD](../record.md)) |

- Pasangan Codec genap-ganjil tidak disediakan.

## Padanan Wikidata {#위키데이터-대응}

Globecoordinate Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | format ini (Bumi). Benda langit lain memakai COORDINATE-GEO |
| latitude, longitude | binary64 apa adanya (nilai Wikidata semula binary64 sehingga tidak ada kehilangan) |
| precision (derajat) | Uncertainty dan Unit. Lihat "Presisi" di bawah |
| precision null atau tidak ada | Unit = ABSENT, Uncertainty = `+0` (tidak diketahui) |
| altitude | dibuang (selalu null) |

- Precision Wikidata bukan galat pengukuran, melainkan **resolusi pencatatan** (koordinat ditulis dalam satuan berapa derajat, menit, atau detik). Uncertainty GEUL memindahkan nilai itu tanpa mengubahnya. Ini bukan radius yang ditambah galat pengukuran atau galat sistem koordinat.

### Presisi {#정밀도}

Precision dipindahkan tanpa konversi. Dipilih satuan pertama di antara derajat, menit busur, dan detik busur yang memulihkan penulisan aslinya.

| Teks asli precision (contoh) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k derajat) | derajat Q28390 | binary32 dari nilai itu |
| penulisan desimal pendek seperti `0.0166667` | derajat Q28390 | binary32 dari nilai itu |
| `0.016666666666667` (1/60°) | menit busur Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | detik busur Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | detik busur Q829073 | `0.1` |

- Konversi maju: berurutan derajat, menit busur (×60), detik busur (×3600); binary32 yang paling dekat dengan hasil perkalian precision dengan jumlah satuan dijadikan Uncertainty, dan dipakai satuan pertama yang konversi baliknya di bawah ini mengembalikan teks asli precision persis.
- Konversi balik: penulisan desimal terpendek dari Uncertainty (bilangan terpendek yang terbaca kembali menjadi binary32 itu) dibagi jumlah satuan untuk diubah ke derajat, lalu ditulis dengan cara yang dipakai Wikibase pada dump (14 angka signifikan, notasi eksponen `1.0e-6`·`2.7777777777778e-5` untuk nilai di bawah `1e-4`). DB pemuat (jsonb) menyimpannya dalam notasi desimal `0.0000010`·`0.000027777777777778`.
- Jika tidak ada satuan yang mengembalikan teks asli (penulisan 17 angka signifikan `0.0002777777777777778`, nilai ganjil yang tampak seperti hasil perhitungan, dan sebagainya), seluruh koordinat tidak dikonversi dan teks aslinya disimpan sebagai UTF8-TEXT. Precision negatif dan nilai dengan benda langit kosong juga sama.
- Sampel Wikidata Q1–Q10000 (7.026 klaim koordinat, 6.824 dengan precision): yang teks aslinya dikembalikan 5.933 (86,9%; derajat 4.104, detik busur 1.370, menit busur 459). Dari 891 yang tidak dikembalikan, 753 adalah deret 1/3600 dan 1/60 dengan penulisan 17 angka signifikan.

## Contoh {#예시}

Berlin 52.516666666667, 13.383333333333, precision 1/60° (menit busur 1):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, menit busur).
- Notasi teks: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Titik yang sama dengan ketidakpastian tidak diketahui: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Dasar standar {#표준-근거}

- Makna: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — urutan lintang, bujur, ketidakpastian `u` (meter), sistem koordinat bawaan WGS 84. Jika Unit adalah meter, Uncertainty = `u`.
- Numerik: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (lintang, bujur), binary32 (ketidakpastian).
- Urutan sumbu dan rentang: ISO 6709 (Standard representation of geographic point location by coordinates).
- Satuan: butir satuan Wikidata (QID). Tata letak berlebar tetap, field Unit, dan representasi tidak diketahui adalah aturan GEUL.

## Masalah terbuka {#열린-문제}

1. Ketinggian.
2. Format yang menyimpan teks asli string ISO 6709 (COORDINATE-ISO6709) akan ditetapkan jika ada kebutuhan pemakaiannya.
3. Cara memindahkan penulisan 17 angka signifikan pada precision Wikidata (sekitar 11% sampel) tanpa kehilangan.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [penanda slot](../slot-marker.md)
- Format Issuer [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) adalah titik dua dimensi umum yang menyerahkan sistem koordinat, satuan, dan makna sumbu kepada konteks eksternal, sedangkan format ini adalah koordinat geografis di Bumi.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000640/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
