---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION adalah Value yang menyatakan pecahan yang tertulis pada teks asli sesuai penulisannya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `FRACTION` (dokumen spesifikasi BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000670/` (sasaran DECLARE `0670`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 7 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | pecahan yang mempertahankan penulisan asli: pembilang bilangan bulat atau desimal, penyebut bilangan bulat atau desimal tak bertanda. Tidak disederhanakan |
| Sisi Hugo | `value/numeric/fraction.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | record | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | record | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION adalah Value yang menyatakan pecahan yang tertulis pada teks asli sesuai penulisannya. Kode langsung Value `0x067L`, keluarga NUMERIC. Pembilang dan penyebut masing-masing adalah record Value yang lengkap. Tidak disederhanakan. Format ini memuat pecahan yang penulisan aslinya itulah catatannya, seperti "dua pertiga" dan "lima per seratus" pada peraturan perundang-undangan, dan bagian kepemilikan desimal pada pendaftaran `23.45/1256.1`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[Length extension TAG] jika total 15 WORD atau lebih
numerator         1 record Value: SIGNED-INTEGER atau SIGNED-DECIMAL
denominator       1 record Value: UNSIGNED-INTEGER atau UNSIGNED-DECIMAL
```

## Interpretasi dan validitas {#해석과-유효성}

- numerator adalah tepat satu record [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) atau [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`).
- denominator adalah tepat satu record [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) atau [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`).
- Daftar ini tertutup. Value lain, FRACTION itu sendiri (bersarang dilarang), dan penanda slot (`0x0000` dan sebagainya) tidak diterima.
- Kedua record masing-masing punya panjang sendiri sehingga batasnya tidak ditulis terpisah. Kursor setelah membaca kedua record harus berhenti tepat di akhir Payload.
- Record di dalamnya juga mengikuti bentuk kanonik masing-masing Codec (bilangan bulat dan coefficient dengan WORD minimum). Jika ada record dalam yang tidak kanonik, seluruh FRACTION invalid.
- Nilainya adalah `numerator / denominator`.

### Pelestarian penulisan {#표기-보존}

- **Bilangan bulat dan desimal**: jika komponen pada teks asli adalah bilangan bulat (tanpa titik desimal), dipakai record INTEGER; jika ada titik desimal, dipakai record DECIMAL. Menulis komponen sebagai DECIMAL dengan eksponen `E = 0` adalah invalid. Dengan begitu penulisan yang sama menghasilkan satu deret byte.
- C dan E pada komponen DECIMAL adalah jumlah digit teks asli apa adanya. `23.450` adalah `23450×10^-3` dan merupakan Value yang berbeda dari `23.45`.
- **Tidak disederhanakan.** `2/4` dan "lima per seratus" (`5/100`) ditulis apa adanya. Jika byte-nya sama, penulisan aslinya sama.
- Pecahan berpenyebut 1 (`3/1`) juga ditulis apa adanya jika teks aslinya menulis demikian. Jika teks aslinya bilangan bulat, dipakai Codec bilangan bulat, bukan FRACTION. Jika teks aslinya bilangan desimal (`0.5`, `5%`), dipakai DECIMAL.
- Tanda hanya diletakkan pada pembilang. Penyebut adalah Codec tak bertanda.
- Jika nilai penyebut 0, itu invalid (baik `0` maupun `0.0`).

### Perbandingan {#비교}

- Lapisan perbandingan menghitung FRACTION sebagai bilangan rasional yang tepat `(C1 × 10^E1) / (C2 × 10^E2)` (komponen INTEGER dengan `E = 0`). Tidak diaproksimasi dengan bilangan titik mengambang.
- Perbandingan, pengurutan, dan penentuan duplikat dilakukan dengan nilai ini, sedangkan penyimpanan, tanda tangan, dan hash isi dilakukan dengan penulisan (byte). `2/4`, `1/2`, dan `0.5` bernilai sama dan byte-nya berbeda.
- Penentuan kuorum ("dua pertiga atau lebih hak suara pemegang saham yang hadir") dibandingkan dengan nilai yang tepat ini.

## Panjang {#길이}

- Total adalah TAG 1 WORD + (Length extension TAG) + dua record. Record bilangan bulat adalah TAG 1 + Payload 1 WORD atau lebih, record desimal TAG 1 + eksponen 2 + coefficient 1 WORD atau lebih.
- Pecahan bilangan bulat kecil adalah 5 WORD, pecahan desimal kecil 9 WORD. Jika 15 WORD atau lebih dipakai panjang perluasan ([Record dan TAG WORD](../record.md)).

| Teks asli | Komponen | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Contoh {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Hubungan dengan format lain {#다른-형식과의-관계}

- amount, lower, dan upper pada [QUANTITY](0x066L-quantity.md) menerima FRACTION. "Dua pertiga hak suara yang hadir" dapat ditulis sebagai amount `2/3`, QUANTITY tanpa satuan.
- Dokumen spesifikasi geul.org `0x00000000/codecs/0x00000670` menuliskannya sebagai dua field record: numerator (`0610`·`0680`) dan denominator (`0620`·`0690`) ([dokumen spesifikasi Codec](../codec-spec.md)).
- Jika diperlukan pecahan int64 berlebar tetap yang memaksa penyederhanaan, dipakai format Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## Masalah terbuka {#열린-문제}

1. Pelestarian penulisan pecahan campuran (`1 dan 2/3`).
2. Format yang memuat pecahan yang komponennya bersatuan (luas/luas) dengan dua QUANTITY. FRACTION tidak memuat satuan.
3. Kriteria penulisan apakah persentase dan permil (`5%`, `5‰`) ditaruh sebagai DECIMAL dengan satuan, atau sebagai FRACTION (`5/100`).
4. Pecahan bersusun (FRACTION pada pembilang dan penyebut). Untuk sekarang dilarang.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000670/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
