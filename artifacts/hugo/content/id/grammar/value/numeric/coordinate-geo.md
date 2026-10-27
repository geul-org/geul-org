---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO adalah Value yang memuat satu titik pada benda langit seperti planet·satelit dengan Reference benda langit, lintang·bujur binary64, ketidakpastian binary32, dan Reference satuannya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO adalah Value koordinat yang menyatakan satu titik pada benda langit yang ditentukan (planet, satelit, asteroid, dan lain-lain) dengan lintang·bujur dan ketidakpastian. Kode langsung Value `0x05`, keluarga NUMERIC. Ini adalah format yang menambahkan Reference benda langit (Globe) di depan [COORDINATE-EARTH](/id/grammar/value/numeric/coordinate-earth/) (`0x04`), dan aturan lintang·bujur·ketidakpastian·satuan sama dengan COORDINATE-EARTH.

## Layout

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length extension TAG] jika total 15 WORD atau lebih
Globe             1 record Reference (Reference yang menunjuk benda langit, Quantifier Identified)
Latitude          4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Longitude         4 WORD nilai mentah, IEEE 754 binary64 (derajat)
Uncertainty       2 WORD nilai mentah, IEEE 754 binary32 (satuan Unit)
Unit              1 record Reference, atau penanda slot 0x0000 ABSENT
```

## Interpretasi dan validitas

- Payload dimulai dengan record Globe. Globe adalah tepat satu record Reference yang lengkap dengan Quantifier Identified (`000`). Reference apa pun yang menunjuk benda langit dapat dipakai: [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) (benda langit bernama), [GEUL](/id/grammar/reference/geul/), [LOCAL](/id/grammar/reference/local/) dokumen yang sama (benda langit yang didefinisikan dalam dokumen), benda langit pada dokumen lain ([EXTERNAL-POINTER](/id/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/)), dan lain-lain. Benda langit tak terhitung banyaknya dan yang memiliki QID hanyalah sebagian.
- Setelah Globe datang 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) dan satu record Unit. Kursor setelah membaca Unit harus sesuai dengan akhir record.
- Latitude `-90 ≤ φ ≤ 90`, Longitude `-180 ≤ λ ≤ 360`. `(180, 360]` diizinkan agar nilai sistem koordinat benda langit yang menghitung bujur 0~360° dapat dimuat apa adanya. Aturan lain (binary64, nilai berhingga, urutan sumbu, makna Uncertainty·Unit, representasi tidak diketahui) sama dengan COORDINATE-EARTH.
- Sistem koordinat mengikuti konvensi benda langit masing-masing (lintang planetosentris, bujur timur atau barat 0~360°, dan lain-lain). Sistem koordinat per benda langit ditetapkan dengan dokumen GEUL terpisah.
- Uncertainty dengan satuan jarak (meter, dan lain-lain) adalah jarak di permukaan benda langit. Satuan sudut (derajat·menit busur·detik busur) adalah radius sudut lintang·bujur tanpa kaitan dengan ukuran benda langit.
- Untuk koordinat Bumi (Q2) dianjurkan memakai COORDINATE-EARTH. Menulis Bumi pada format ini juga bukan invalid, dan pihak yang membandingkan menyamakannya sebagai koordinat yang sama.
- Dokumen spesifikasi geul.org `0x0000/0x0000000000000805` menaruh [CODEC](/id/grammar/edge/codec/) BINARY-FLOAT (`0803`) pada field nilai mentah Latitude·Longitude·Uncertainty, dan CODEC `0780` (Reference apa saja)·`0000` (ABSENT) pada field record Unit.

## Panjang

- Total adalah TAG 1 WORD + (Length extension TAG) + record Globe + 10 WORD + record Unit.
- Jika Globe 2 WORD (QID muat dalam 1 WORD) dan Unit ABSENT, 14 WORD, `LLLL=1101`, TAG `0E85`. Jika Unit adalah Reference (2 WORD atau lebih), melebihi 15 WORD sehingga memakai panjang extension: TAG `0F05`, jumlah WORD total pada WORD berikutnya ([Record dan TAG WORD](/id/grammar/record/)).

## Padanan Wikidata

- globecoordinate yang globe-nya bukan Bumi (Q2) ditulis dengan format ini. Globe = WIKIDATA-QID (item globe). Padanan lintang·bujur dan precision → Uncertainty·Unit sama dengan COORDINATE-EARTH (precision adalah resolusi pencatatan dalam derajat sehingga dipindahkan apa adanya tanpa kaitan dengan ukuran benda langit).
- Benda langit selain Bumi pada sampel Wikidata (sekitar 24 ribu klaim koordinat): 23 kasus seperti Mars (Q111), Ceres (Q596), Bulan (Q405), Merkurius (Q308), Venus (Q313). 41 kasus yang globe-nya kosong tidak dikonversi dan teks aslinya dipertahankan sebagai UTF8-TEXT.

## Contoh

Mars (Q111) 4.5, 137.4, ketidakpastian tidak diketahui:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, tidak diketahui).
- Notasi teks: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Titik yang sama, precision 0.1° (Unit derajat Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, panjang extension), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Dasar standar

- Makna: lintang·bujur·`u` (saat Unit adalah meter) pada [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). Sistem koordinat yang terdaftar pada `crs` RFC 5870 hanya `wgs84` sehingga benda langit di luar Bumi ditentukan dengan Reference Globe GEUL.
- Numerik: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (lintang·bujur), binary32 (ketidakpastian).

## Masalah terbuka

1. Dokumen sistem koordinat per benda langit: definisi lintang (planetosentris·planetografis) dan arah serta rentang bujur untuk setiap benda langit.

## Halaman terkait

- [Value](/id/grammar/value/), [COORDINATE-EARTH](/id/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/), [GEUL](/id/grammar/reference/geul/), [LOCAL](/id/grammar/reference/local/)
