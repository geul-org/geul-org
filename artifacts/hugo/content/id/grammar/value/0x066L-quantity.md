---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY adalah Value yang menyatakan satu kuantitas dengan bilangan, satuan, batas bawah, dan batas atas."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `QUANTITY` (dokumen spesifikasi BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000660/` (sasaran DECLARE `0660`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 6 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | amount berupa Value numerik (bilangan bulat, BINARY-FLOAT, desimal, pecahan), Reference satuan, batas bawah dan atas. Satuan dan batas dapat dihilangkan (ABSENT `0x0000`) |
| Sisi Hugo | `value/numeric/quantity.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | record | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0000` ABSENT (field opsional) |  |
| 3 | `lower` | #4 | record | `0680` SIGNED-DECIMAL, `0000` ABSENT (field opsional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | record | `0680` SIGNED-DECIMAL, `0000` ABSENT (field opsional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY adalah Value yang menyatakan satu kuantitas dengan bilangan, satuan, batas bawah, dan batas atas. Kode langsung Value `0x066L`, keluarga NUMERIC. Keempat bagiannya masing-masing adalah record yang lengkap. Satuan dan batas adalah [field opsional](../codec-spec.md), sehingga jika dihilangkan dipakai ABSENT (`0x0000`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length extension TAG] jika total 15 WORD atau lebih
amount            record Value numerik (bilangan bulat, BINARY-FLOAT, desimal, pecahan)
unit              record Reference (butir satuan), 0x0000 jika tanpa satuan
lower             record Value numerik, 0x0000 ABSENT jika dihilangkan
upper             record Value numerik, 0x0000 ABSENT jika dihilangkan
```

## Interpretasi dan validitas {#해석과-유효성}

- amount adalah tepat satu record Value numerik yang lengkap. Codec penerimanya enam: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`), [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). Daftar ini tertutup dan bukan wildcard. BOOL, COORDINATE-EARTH·COORDINATE-GEO, QUANTITY itu sendiri (bersarang dilarang, kedalaman tetap), dan Value lain tidak diterima. Penanda slot (`0x0000` dan sebagainya) tidak boleh dipakai pada amount.
- Record di dalamnya juga mengikuti bentuk kanonik masing-masing Codec (bilangan bulat dan coefficient dengan WORD minimum, BINARY-FLOAT 1/2/4/8 WORD, FRACTION menurut aturannya). Jika ada record dalam yang tidak kanonik, seluruh QUANTITY invalid.
- Jika amount, lower, atau upper adalah BINARY-FLOAT, nilainya harus berhingga. NaN dan ±Infinity adalah invalid (aturan yang sama dengan lintang dan bujur pada [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- Format bilangan mengikuti penulisan aslinya apa adanya. Teks asli bilangan bulat disimpan sebagai INTEGER, bilangan desimal sebagai DECIMAL, pecahan sebagai FRACTION, dan nilai binary IEEE 754 sebagai BINARY-FLOAT; encoder tidak mengubah format untuk menormalkan. C dan E pada DECIMAL menyimpan jumlah digit penulisan aslinya apa adanya: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Kedua nilai itu bilangan yang sama tetapi angka signifikannya berbeda, sehingga merupakan Value yang berbeda. Tidak ada batas atas jumlah digit bilangan bulat dan coefficient (WORD minimum, panjang variabel).
- unit adalah tepat satu record Reference yang lengkap, atau `0x0000`. Reference apa pun yang menunjuk butir satuan dapat dipakai (satuan Wikidata memakai WIKIDATA-QID). `0x0000` berarti tanpa satuan (jumlah, rasio, populasi, dan sebagainya).
- lower dan upper masing-masing adalah record dari salah satu dari enam Codec yang sama dengan amount, atau `0x0000` ABSENT. Untuk penanda slot hanya penghilangan ABSENT yang diterima. Boleh hanya salah satu yang ada. Codec ketiga bilangan tidak perlu sama.
- lower ≤ amount ≤ upper dibandingkan sebagai nilai numerik, bukan sebagai byte atau Codec. Walau tipenya berbeda, dibandingkan sebagai bilangan (mis. SIGNED-INTEGER `652` dan SIGNED-DECIMAL `651.5`). FRACTION dibandingkan sebagai bilangan rasional yang tepat. Rentang simetris (`652 ± 1`) juga ditulis dengan batas bawah dan atas (`651`, `653`). Karena ada rentang asimetris sehingga bagaimanapun diperlukan dua nilai, tidak disediakan format yang meringkasnya menjadi satu ±.
- Satuan adalah bagian dari nilai. Satuan tidak dipisahkan dengan QUALIFIER dan sebagainya (jika dipisahkan, tidak diketahui apakah `652` itu km atau m).
- Record amount yang diambil keluar tetap merupakan record Value yang berdiri sendiri. Jika diperlukan bilangan tanpa satuan, dipakai record itu tanpa pengodean ulang.
- Nilai yang dikonversi ke satuan SI tidak dimuat. Itu adalah nilai turunan yang dapat dihitung dari satuan dan tabel konversi.
- Kursor setelah membaca keempat record harus berhenti tepat di akhir Payload. Bentuk lain adalah invalid.
- Dokumen spesifikasi geul.org menuliskannya sebagai empat field record: amount (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`), unit (`000F`·`020F`·`040F`·`0000`), lower dan upper (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`) ([dokumen spesifikasi Codec](../codec-spec.md)).

## Panjang {#길이}

- Total adalah TAG 1 WORD + (Length extension TAG) + empat record. Record bilangan bulat adalah TAG 1 + Payload 1 WORD atau lebih, record BINARY-FLOAT 2·3·5·9 WORD, record desimal TAG 1 + eksponen 2 + coefficient 1 WORD atau lebih, record FRACTION 5 WORD atau lebih.
- Bilangan bulat kecil tanpa satuan dan tanpa batas adalah 6 WORD, desimal kecil 8 WORD. Jika 15 WORD atau lebih dipakai panjang perluasan ([Record dan TAG WORD](../record.md)).

## Contoh {#예시}

`1.20` tanpa satuan:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

Bilangan bulat `42` tanpa satuan:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit·lower·upper `0000`.

Pecahan `2/3` tanpa satuan (dua pertiga hak suara yang hadir):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit·lower·upper `0000`.

`652 km`, rentang `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- Total 17 WORD sehingga `LLLL=1110`, extension TAG `0011`.

## Padanan Wikidata {#위키데이터-대응}

- Datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. String amount dan batas (`+1.20`, termasuk notasi eksponen) dipindahkan ke C dan E dengan jumlah digit apa adanya.
- Amount dan batas Wikidata adalah string desimal, sehingga walau berbentuk bilangan bulat (`+652`) tetap dipindahkan sebagai SIGNED-DECIMAL. Konversi Wikidata tidak memakai Codec numerik lain.
- unit `"1"` adalah tanpa satuan (`0x0000`), `http://www.wikidata.org/entity/Qn` adalah WIKIDATA-QID. Satuan lain, serta bilangan dan batas yang bentuknya tidak sesuai, tidak dikonversi dan teks aslinya disimpan sebagai UTF8-TEXT.
- Sampel Wikidata (sekitar 42 ribu quantity di bagian awal dump): tanpa satuan 61%, dengan batas 13% (di antaranya simetris 93%), amount terpanjang 31 karakter.

## Dasar standar {#표준-근거}

- Penulisan desimal dan pelestarian jumlah digit: konsep coefficient, exponent, dan quantum pada decimal [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL GEUL).
- Model kuantitas Wikidata: `QuantityValue` pada Wikibase DataModel.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000660/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
