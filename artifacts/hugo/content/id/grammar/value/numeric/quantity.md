---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY adalah Value yang memuat satu kuantitas sebagai empat record: kuantitas berupa record Value numerik (bilangan bulat·BINARY-FLOAT·desimal·pecahan), Reference satuan, batas bawah·atas."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY adalah Value yang menyatakan satu kuantitas dengan bilangan, satuan, dan batas bawah·atas. Kode langsung Value `0x06`, keluarga NUMERIC. Keempat bagian masing-masing adalah record lengkap. Satuan dan batas adalah [field opsional](/id/grammar/codec-spec/) sehingga jika dihilangkan ditulis ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] jika total 15 WORD atau lebih
amount            record Value numerik (bilangan bulat·BINARY-FLOAT·desimal·pecahan)
unit              record Reference (item satuan), 0x0000 jika tanpa satuan
lower             record Value numerik, 0x0000 ABSENT jika dihilangkan
upper             record Value numerik, 0x0000 ABSENT jika dihilangkan
```

## Interpretasi dan validitas

- amount adalah tepat satu record Value numerik yang lengkap. Codec yang diterima ada enam: [SIGNED-INTEGER](/id/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/id/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/id/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/) (`0x10`), [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/) (`0x11`). Ini daftar tertutup, bukan wildcard. BOOL, COORDINATE-EARTH·COORDINATE-GEO, QUANTITY itu sendiri (dilarang bersarang, kedalaman tetap), dan Value lainnya tidak diterima. amount tidak boleh berisi penanda slot (`0x0000` dan sebagainya).
- Record di dalamnya juga mengikuti bentuk kanonis masing-masing Codec (WORD minimum untuk bilangan bulat·koefisien, 1/2/4/8 WORD untuk BINARY-FLOAT, FRACTION menurut aturannya). Jika ada record dalam yang tidak kanonis, seluruh QUANTITY adalah invalid.
- Jika amount·lower·upper berupa BINARY-FLOAT, nilainya harus hingga. NaN dan ±Infinity adalah invalid (aturan yang sama dengan lintang·bujur [COORDINATE-EARTH](/id/grammar/value/numeric/coordinate-earth/)).
- Format bilangan mengikuti notasi asli apa adanya. Asli bilangan bulat dimuat sebagai INTEGER, asli pecahan desimal sebagai DECIMAL, asli pecahan biasa sebagai FRACTION, dan nilai biner IEEE 754 sebagai BINARY-FLOAT; encoder tidak menormalkan dengan mengganti format. C dan E pada DECIMAL memuat jumlah digit notasi asli apa adanya: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Keduanya bilangan yang sama tetapi angka signifikannya berbeda sehingga merupakan Value yang berbeda. Tidak ada batas atas jumlah digit bilangan bulat dan koefisien (WORD minimum, panjang variabel).
- unit adalah tepat satu record Reference yang lengkap atau `0x0000`. Reference apa pun yang menunjuk item satuan dapat dipakai (satuan Wikidata adalah WIKIDATA-QID). `0x0000` berarti tanpa satuan (jumlah, rasio, penduduk, dan lain-lain).
- lower·upper masing-masing adalah record dari salah satu enam Codec yang sama dengan amount atau `0x0000` ABSENT. Penanda slot yang diterima hanya penghilangan ABSENT. Boleh hanya salah satunya. Codec ketiga bilangan tidak harus sama. Rentang simetris (`652 ± 1`) juga ditulis dengan batas bawah·atas (`651`, `653`). Karena ada rentang asimetris sehingga dua nilai tetap diperlukan, format yang diringkas menjadi satu ± tidak disediakan.
- lower ≤ amount ≤ upper dibandingkan menurut nilai numerik, bukan byte atau Codec. Meskipun tipenya berbeda, dibandingkan sebagai bilangan (contoh: SIGNED-INTEGER `652` dan SIGNED-DECIMAL `651.5`). FRACTION dibandingkan sebagai bilangan rasional yang eksak.
- Satuan adalah bagian dari nilai. Satuan tidak dilepas dengan QUALIFIER dan sebagainya (jika dilepas, tidak diketahui apakah `652` itu km atau m).
- Jika record amount diambil keluar, record itu apa adanya adalah record Value mandiri. Jika diperlukan bilangan tanpa satuan, record itu dipakai tanpa encoding ulang.
- Nilai yang dikonversi ke satuan SI tidak dimuat. Itu nilai turunan yang dapat dihitung dari satuan dan tabel konversi.
- Kursor setelah membaca keempat record harus tepat sama dengan akhir Payload. Bentuk lain adalah invalid.
- Dokumen spesifikasi geul.org menulis empat field record: amount (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`), unit (`0780`·`0000`), lower·upper (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`) ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).

## Panjang

- Total adalah TAG 1 WORD + (Length extension TAG) + empat record. Record bilangan bulat adalah TAG 1 + Payload 1 WORD atau lebih, record BINARY-FLOAT adalah 2·3·5·9 WORD, dan record desimal adalah TAG 1 + eksponen 2 + koefisien 1 WORD atau lebih. Record FRACTION adalah 5 WORD atau lebih.
- Bilangan bulat kecil tanpa satuan·tanpa batas adalah 6 WORD, desimal kecil 8 WORD. Jika 15 WORD atau lebih, dipakai panjang extension ([Record dan TAG WORD](/id/grammar/record/)).

## Contoh

`1.20` tanpa satuan:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

Bilangan bulat `42` tanpa satuan:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit·lower·upper `0000`.

Pecahan `2/3` tanpa satuan (dua pertiga hak suara yang hadir):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/id/grammar/value/numeric/fraction/) 2/3), unit·lower·upper `0000`.

`652 km`, rentang `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- Total 17 WORD sehingga `LLLL=1110`, extension TAG `0011`.

## Padanan Wikidata

- datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. String amount dan batas (`+1.20`, termasuk notasi eksponen) dipindahkan ke C dan E dengan jumlah digit apa adanya.
- amount dan batas Wikidata adalah string desimal sehingga meskipun berbentuk bilangan bulat (`+652`) tetap dipindahkan sebagai SIGNED-DECIMAL. Konversi Wikidata tidak memakai Codec numerik lain.
- unit `"1"` adalah tanpa satuan (`0x0000`), dan `http://www.wikidata.org/entity/Qn` adalah WIKIDATA-QID. Satuan lain serta bilangan·batas yang formatnya tidak sesuai tidak dikonversi dan teks aslinya dipertahankan sebagai UTF8-TEXT.
- Sampel Wikidata (sekitar 42 ribu quantity di bagian awal dump): tanpa satuan 61%, ada batas 13% (di antaranya simetris 93%), amount terpanjang 31 karakter.

## Dasar standar

- Notasi desimal dan pelestarian jumlah digit: konsep coefficient·exponent·quantum decimal [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL GEUL).
- Model kuantitas Wikidata: `QuantityValue` pada Wikibase DataModel.

## Halaman terkait

- [Value](/id/grammar/value/), [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/id/grammar/value/numeric/coordinate-geo/), [CODEC](/id/grammar/edge/codec/), [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/)
