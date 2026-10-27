---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH adalah Value yang memuat satu titik di Bumi (WGS 84) dengan lintang·bujur binary64, ketidakpastian binary32, dan Reference satuan ketidakpastian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH adalah Value koordinat yang menyatakan satu titik di Bumi dengan lintang·bujur dan ketidakpastian. Kode langsung Value `0x04`, keluarga NUMERIC. Maknanya sama dengan `geo:lintang,bujur;u=ketidakpastian` (sistem koordinat WGS 84) pada [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI), dan dimuat sebagai nilai numerik berlebar tetap, bukan string. Ketidakpastian ditulis bersama satuannya. Koordinat benda langit di luar Bumi ditulis dengan [COORDINATE-GEO](/id/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Layout

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Longitude         4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Uncertainty       2 WORD nilai mentah, IEEE 754 binary32 (satuan Unit)
Unit              1 record Reference, atau penanda slot 0x0000 ABSENT
```

## Interpretasi dan validitas

- Payload adalah Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD, lalu tepat satu record Unit. Kursor setelah membaca Unit harus sesuai dengan akhir record.
- Sistem koordinat adalah WGS 84 (`crs=wgs84` default RFC 5870).
- Latitude·Longitude adalah IEEE 754 binary64 dari WORD Payload yang disambung dalam urutan big-endian (penataan bit yang sama dengan binary64 pada [BINARY-FLOAT](/id/grammar/value/numeric/binary-float/)). Satuannya derajat (°).
  - Harus berupa nilai berhingga. NaN dan ±Infinity adalah invalid.
  - Latitude `-90 ≤ φ ≤ 90` (utara positif), Longitude `-180 ≤ λ ≤ 180` (timur positif).
  - Urutan sumbu adalah lintang, bujur (sama dengan RFC 5870·ISO 6709). Bukan urutan x (bujur)·y (lintang) pada WKB·GeoJSON.
- Uncertainty adalah IEEE 754 binary32 dari 2 WORD yang disambung big-endian (penataan bit yang sama dengan binary32 pada BINARY-FLOAT). Artinya posisi sebenarnya berada dalam radius ini, dan nilainya dibaca dalam satuan Unit.
  - Harus berhingga dan `+0` atau lebih. Negatif, `-0` (`8000 0000`), NaN, dan ±Infinity adalah invalid.
  - `0` (saat Unit ada): koordinat tepat. Sama walaupun ditulis dalam satuan mana pun.
- Unit adalah Reference yang menunjuk satuan Uncertainty. Value tidak diterima. Quantifier adalah Identified (`000`).
  - Dianjurkan memakai item satuan Wikidata [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/): derajat Q28390, menit busur Q209426, detik busur Q829073, meter Q11573, milimeter Q174789, dan lain-lain. Satuan yang tidak memiliki QID ditunjuk dengan Reference lain (LOCAL, GEUL, dan lain-lain). Jika ada beberapa Reference yang menunjuk satuan yang sama, QID adalah bentuk kanonik.
  - Jika Unit adalah meter (Q11573), Uncertainty sama dengan `u` RFC 5870.
- **Tidak diketahui**: pada posisi Unit tulis [ABSENT](/id/grammar/reference/slot-marker/) (`0x0000`) dan Uncertainty dibiarkan `+0` (`0000 0000`). Sama dengan saat `u` dihilangkan pada RFC 5870. Jika ABSENT tetapi Uncertainty bukan `+0`, invalid (representasi dikunci menjadi satu).
- Ketinggian tidak dimuat. Jika diperlukan, ditetapkan dengan format terpisah. altitude Wikidata tidak dipakai pada sampel (0/23,066), dan jika ada nilainya tidak dikonversi dan teks aslinya dipertahankan sebagai UTF8-TEXT.
- Untuk koordinat Bumi dianjurkan memakai format ini. Koordinat yang menulis Bumi (Q2) pada COORDINATE-GEO juga bukan invalid, dan pihak yang membandingkan menyamakannya sebagai koordinat yang sama.
- Dokumen spesifikasi geul.org `0x0000/0x0000000000000804` menaruh [CODEC](/id/grammar/edge/codec/) BINARY-FLOAT (`0803`) pada field nilai mentah Latitude·Longitude·Uncertainty (4 WORD = binary64, 2 WORD = binary32), dan CODEC `0780` (Reference apa saja)·`0000` (ABSENT) pada field record Unit.

## Panjang

- Total adalah TAG 1 WORD + 10 WORD + record Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| Jika QID muat dalam 1 WORD (2 WORD, contoh: derajat Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| Jika QID 2 WORD (3 WORD, contoh: menit busur Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Record Unit 4 WORD atau lebih | 15 WORD atau lebih | Panjang extension ([Record dan TAG WORD](/id/grammar/record/)) |

- Pasangan Codec genap·ganjil tidak disediakan.

## Padanan Wikidata

globecoordinate Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | Format ini (Bumi). Benda langit lain adalah COORDINATE-GEO |
| latitude, longitude | binary64 apa adanya (nilai Wikidata aslinya binary64 sehingga tidak ada kehilangan) |
| precision (derajat) | Uncertainty dan Unit. "Presisi" di bawah |
| precision null atau tidak ada | Unit = ABSENT, Uncertainty = `+0` (tidak diketahui) |
| altitude | Dibuang (selalu null) |

- precision Wikidata bukan galat pengukuran melainkan **resolusi pencatatan** (koordinat dicatat dalam satuan berapa derajat·menit·detik). Uncertainty GEUL memindahkan nilai itu tanpa mengubahnya. Ini bukan radius yang menambahkan galat pengukuran·sistem koordinat.

### Presisi

precision dipindahkan tanpa konversi. Dipilih satuan pertama di antara derajat·menit busur·detik busur yang memulihkan notasi aslinya.

| Contoh teks asli precision | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k derajat) | derajat Q28390 | binary32 dari nilai itu |
| Notasi desimal pendek seperti `0.0166667` | derajat Q28390 | binary32 dari nilai itu |
| `0.016666666666667` (1/60°) | menit busur Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | detik busur Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | detik busur Q829073 | `0.1` |

- Konversi maju: dalam urutan derajat, menit busur (×60), detik busur (×3600), binary32 terdekat dengan nilai precision dikalikan jumlah satuan dijadikan Uncertainty, dan dipakai satuan pertama yang konversi baliknya di bawah memulihkan teks asli precision apa adanya.
- Konversi balik: notasi desimal terpendek Uncertainty (bilangan terpendek yang terbaca kembali menjadi binary32 itu) dibagi jumlah satuan lalu diubah ke derajat, dan ditulis dengan cara Wikibase menulis di dump (14 digit signifikan, di bawah `1e-4` memakai notasi eksponen `1.0e-6`·`2.7777777777778e-5`). DB termuat (jsonb) menyimpannya dengan notasi desimal `0.0000010`·`0.000027777777777778`.
- Jika tidak ada satuan yang memulihkan teks asli (notasi 17 digit signifikan `0.0002777777777777778`, nilai ganjil yang tampak seperti hasil perhitungan, dan lain-lain), seluruh koordinat tidak dikonversi dan teks aslinya dipertahankan sebagai UTF8-TEXT. Sama dengan precision negatif dan nilai yang benda langitnya kosong.
- Sampel Q1–Q10000 Wikidata (7,026 klaim koordinat, 6,824 dengan precision): yang teks aslinya dipulihkan 5,933 (86.9%; derajat 4,104, detik busur 1,370, menit busur 459). Dari 891 yang tidak dipulihkan, 753 adalah keluarga 1/3600·1/60 dengan notasi 17 digit signifikan.

## Contoh

Berlin 52.516666666667, 13.383333333333, precision 1/60° (menit busur 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, menit busur).
- Notasi teks: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Titik yang sama dengan ketidakpastian tidak diketahui: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Dasar standar

- Makna: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — urutan lintang·bujur, ketidakpastian `u` (meter), sistem koordinat default WGS 84. Jika Unit adalah meter, Uncertainty = `u`.
- Numerik: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (lintang·bujur), binary32 (ketidakpastian).
- Urutan sumbu dan rentang: ISO 6709 (Standard representation of geographic point location by coordinates).
- Satuan: item satuan Wikidata (QID). Penataan berlebar tetap, field Unit, dan representasi tidak diketahui adalah aturan GEUL.

## Masalah terbuka

1. Ketinggian.
2. Format yang mempertahankan string asli ISO 6709 (COORDINATE-ISO6709) ditetapkan jika muncul kegunaannya.
3. Cara memindahkan tanpa kehilangan notasi 17 digit signifikan precision Wikidata (sekitar 11% sampel).

## Halaman terkait

- [Value](/id/grammar/value/), [COORDINATE-GEO](/id/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/id/grammar/value/numeric/binary-float/), [Penanda slot](/id/grammar/reference/slot-marker/)
- Format Issuer [POINT2-BINARY64](/id/grammar/value/vector/point2-binary64/) adalah titik 2 dimensi umum yang menyerahkan sistem koordinat·satuan·makna sumbu pada konteks eksternal, sedangkan format ini adalah koordinat geografis di Bumi.
