---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO adalah Value koordinat yang menyatakan satu titik pada benda langit yang ditentukan (planet, satelit, asteroid, dan sebagainya) dengan lintang, bujur, dan ketidakpastian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `COORDINATE-GEO` (dokumen spesifikasi BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000650/` (sasaran DECLARE `0650`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 5 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Reference benda langit, lintang dan bujur binary64, ketidakpastian binary32, dan Reference satuannya |
| Sisi Hugo | `value/numeric/coordinate-geo.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | record | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | nilai mentah 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | nilai mentah 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | nilai mentah 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0000` ABSENT (field opsional) |  |

COORDINATE-GEO adalah Value koordinat yang menyatakan satu titik pada benda langit yang ditentukan (planet, satelit, asteroid, dan sebagainya) dengan lintang, bujur, dan ketidakpastian. Kode langsung Value `0x065L`, keluarga NUMERIC. Ini adalah format [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) dengan Reference benda langit (Globe) di depannya, dan aturan lintang, bujur, ketidakpastian, serta satuan sama dengan COORDINATE-EARTH.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length extension TAG] jika total 15 WORD atau lebih
Globe             1 record Reference (Reference yang menunjuk benda langit, Quantifier Identified)
Latitude          4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Longitude         4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Uncertainty       2 WORD nilai mentah, IEEE 754 binary32 (satuan Unit)
Unit              1 record Reference, atau penanda slot 0x0000 ABSENT
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload diawali record Globe. Globe adalah tepat satu record Reference yang lengkap, dengan Quantifier Identified. Reference apa pun yang menunjuk benda langit dapat dipakai: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (benda langit bernama), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) dalam dokumen yang sama (benda langit yang didefinisikan di dalam dokumen), benda langit pada dokumen lain ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)), dan sebagainya. Benda langit jumlahnya tak terhingga, dan yang punya QID hanya sebagian.
- Setelah Globe datang 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) dan satu record Unit. Kursor setelah membaca Unit harus berhenti tepat di akhir record.
- Latitude `-90 ≤ φ ≤ 90`, Longitude `-360 ≤ λ ≤ 360`. Rentang dibuat lebih lebar daripada Bumi agar nilai pada sistem koordinat benda langit yang menghitung bujur 0~360° (bujur timur, bujur barat) dan nilai negatif yang ditulis berlawanan arah dapat dimuat tanpa diubah. Rentang ini sama dengan model data globecoordinate Wikidata (`LatLongValue` Wikibase). `λ` dan `λ ± 360` adalah meridian yang sama dan GEUL tidak menormalkannya. Aturan lainnya (binary64, nilai berhingga, urutan sumbu, makna Uncertainty dan Unit, representasi tidak diketahui) sama dengan COORDINATE-EARTH.
- Sistem koordinat mengikuti konvensi masing-masing benda langit (lintang planetosentris, bujur timur atau barat 0~360°, dan sebagainya). Sistem koordinat per benda langit ditetapkan dengan dokumen GEUL tersendiri.
- Uncertainty dengan satuan jarak (meter dan sebagainya) adalah jarak di permukaan benda langit. Satuan sudut (derajat, menit busur, detik busur) adalah radius sudut lintang dan bujur, terlepas dari ukuran benda langit.
- Untuk koordinat Bumi (Q2), dianjurkan memakai COORDINATE-EARTH. Menuliskan Bumi pada format ini juga bukan invalid, dan pihak pembanding mencocokkannya sebagai koordinat yang sama.
- Dokumen spesifikasi geul.org `0x00000000/codecs/0x00000650` menaruh [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) pada field nilai mentah Latitude, Longitude, dan Uncertainty, dan menaruh CODEC `000F`, `020F`, `040F` (Reference apa pun) dan `0000` (ABSENT) pada field record Unit.

## Panjang {#길이}

- Total adalah TAG 1 WORD + (Length extension TAG) + record Globe + 10 WORD + record Unit.
- Jika Globe 2 WORD (QID muat dalam 1 WORD) dan Unit ABSENT, totalnya 14 WORD, `LLLL=1101`, TAG `065D`. Jika Unit adalah Reference (2 WORD atau lebih), totalnya melebihi 15 WORD dan memakai panjang perluasan: TAG `065E`, WORD berikutnya berisi jumlah WORD total ([Record dan TAG WORD](../record.md)).

## Padanan Wikidata {#위키데이터-대응}

- Globecoordinate Wikidata dengan globe selain Bumi (Q2) ditulis dengan format ini. Globe = WIKIDATA-QID (butir globe). Padanan lintang, bujur, serta precision → Uncertainty·Unit sama dengan COORDINATE-EARTH (precision adalah resolusi pencatatan dalam derajat, sehingga dipindahkan apa adanya terlepas dari ukuran benda langit).
- Benda langit selain Bumi pada sampel Wikidata (sekitar 24 ribu klaim koordinat): Mars (Q111), Ceres (Q596), Bulan (Q405), Merkurius (Q308), Venus (Q313), dan sebagainya, 23 buah. 41 yang globe-nya kosong tidak dikonversi dan teks aslinya disimpan sebagai UTF8-TEXT.

## Contoh {#예시}

Mars (Q111) 4.5, 137.4, ketidakpastian tidak diketahui:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, tidak diketahui).
- Notasi teks: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Titik yang sama, precision 0,1° (Unit derajat Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, panjang perluasan), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Dasar standar {#표준-근거}

- Makna: lintang, bujur, dan `u` (jika Unit adalah meter) dari [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). Satu-satunya sistem koordinat yang terdaftar pada `crs` RFC 5870 adalah `wgs84`, sehingga benda langit di luar Bumi ditentukan dengan Reference Globe GEUL.
- Numerik: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (lintang, bujur), binary32 (ketidakpastian).
- Rentang bujur: `-360 ≤ λ ≤ 360` pada [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo), model data globecoordinate Wikidata.

## Masalah terbuka {#열린-문제}

1. Dokumen sistem koordinat per benda langit: definisi lintang (planetosentris, planetografis) serta arah dan rentang bujur untuk tiap benda langit.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000650/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
