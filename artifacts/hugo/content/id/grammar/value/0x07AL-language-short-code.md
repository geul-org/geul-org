---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE adalah kode bahasa terkompresi GEUL yang memuat satu tag BCP 47 bernomor di GEUL Language Registry dalam 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `LANGUAGE-SHORT-CODE` (dokumen spesifikasi BIND `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000007A0/` (sasaran DECLARE `07A0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 26 |
| Kind | Value · keluarga: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tag BCP 47 yang ditulis dengan nomor GEUL Language Registry (Payload 1 WORD) |
| Sisi Hugo | `value/text/language-short-code.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | nilai mentah 1 WORD |  | 8678 ENUM. Contoh: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE adalah kode bahasa terkompresi GEUL yang memuat satu tag BCP 47 bernomor di GEUL Language Registry dalam 1 WORD. Payload tepat 1 WORD.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x07AL`. Keluarga TEXT.
- Payload adalah kode unsigned 16 bit tepat 1 WORD.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  total 2 WORD
Payload WORD 1st (16 bit)           nomor GEUL Language Registry (uint16)
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload 1 WORD dibaca sebagai bilangan bulat unsigned 16 bit.
- Nilai ini adalah satu tag yang ditetapkan GEUL Language Registry. Representasi resmi registry adalah dokumen spesifikasi Codec ini, `0x00000000/codecs/0x000007A0`. Untuk setiap nilai kode ada satu [ENUM](../edge/0x0BDL-enum.md) pada FIELD `code`, dan nama yang diikat dengan [BIND](../edge/0x0A3L-bind.md) ke Edge Id ENUM itu adalah tag BCP 47 dengan casing normal.
- Registry adalah daftar tertutup. Nilai yang tidak punya ENUM di dokumen spesifikasi adalah invalid. Aturan Codec ini diutamakan di atas aturan umum ENUM (“kode yang tidak dideklarasikan bukan kesalahan”).
- Sasaran penetapan ada tiga.
  - Record `Type: language` pada IANA Language Subtag Registry, kecuali yang `Scope: private-use` (`qaa..qtz`). collection, macrolanguage, special (`mul`·`und`·`zxx`·`mis`) tidak dikecualikan.
  - Tag yang didaftarkan IANA secara utuh: grandfathered dan redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, dan sebagainya).
  - Tag kombinasi valid yang teramati dari sumber CC0 terbuka (`pt-BR`, `en-GB`, `be-tarask`, dan sebagainya). Tag yang hanya terdiri dari subtag language·extlang·script·region·variant. Tag yang memuat extension (`-u-`·`-t-`) dan private-use (`-x-`) tidak diterima.
- Tag yang tidak bernomor tidak dapat ditulis dengan format ini. Tulis dengan [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Di dalam SHORT-CODE tidak ada jalur escape.
- `0x0000` dan `0xFFFF` tidak pernah ditetapkan. Keduanya invalid pada Value ini. Keduanya tidak dipakai dengan arti `null`·`unknown`·`und`.
- Rentang nilai adalah konvensi penetapan. Dekoder tidak menduga jenis tag dari rentang nilai. Arti nilai hanya berasal dari dokumen spesifikasi.

| Rentang | Pemakaian |
|---|---|
| `0x0000` | tidak ditetapkan (invalid) |
| `0x0001`–`0x3FFF` | tag dengan satu subtag language |
| `0x4000`–`0x7FFF` | tag dengan dua subtag atau lebih (tag utuh IANA, tag kombinasi teramati) |
| `0x8000`–`0xFFFE` | limpahan. Jika blok di atas penuh, penetapan dilanjutkan di sini |
| `0xFFFF` | tidak ditetapkan (invalid) |

- Edisi awal memberi nomor dalam blok menurut urutan ASCII huruf kecil tag. Blok `0x4000` berisi tag utuh IANA (grandfathered dan redundant dicampur dalam urutan ASCII) diikuti tag kombinasi teramati (urutan ASCII). Urutan fisik berkas IANA dan frekuensi pemakaian bukan aturan penomoran.
- Penetapan hanya menambah (append-only). Tag baru ditambahkan di akhir blok, dan jika blok penuh ditambahkan di rentang limpahan. Tag (tanpa membedakan huruf besar-kecil) yang sudah diberi nomor tidak diubah, tidak dihapus, dan nomornya tidak dipakai ulang.
- Tag baru dimasukkan dengan menambahkan ENUM dan BIND pada versi baru dokumen spesifikasi. ENUM·BIND yang ada tidak diubah. Karena itu versi mana pun adalah superset versi sebelumnya.
- Jika 65.534 nomor sudah penuh, tidak ada penetapan lagi. Tag baru sesudahnya ditulis dengan LANGUAGE-BCP47-CODE. Daya ekspresi tidak berkurang, hanya keuntungan kompresi yang hilang.
- Bahasa yang sama: SHORT-CODE `n` dan LANGUAGE-BCP47-CODE dari tag yang diikat registry ke `n` (tanpa membedakan huruf besar-kecil) adalah bahasa yang sama.
- Edisi registry adalah versi dokumen spesifikasi. Setiap edisi mencatat berkas IANA registry yang menjadi dasarnya (File-Date, SHA-256) sebagai [SOURCE](../edge/0x0C0L-source.md) pada HEAD dokumen spesifikasi. Jika edisi yang menafsirkan nilai perlu disebutkan, sertakan versinya ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, ID versi `n`)).
- Spesifikasi Codec dapat memuat kode 1 WORD yang sama sebagai field nilai mentah tanpa TAG ([CODEC](../codec-spec.md#codec) pada field nilai mentah). Itu adalah aturan spesifikasi Codec tersebut, dan wire form Value mandiri selalu TAG 1 WORD + Payload 1 WORD.

## Dasar standar {#표준-근거}

- Arti tag dan validitas subtag mengikuti [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) dan [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA·IETF menempatkan hak atas registry protokol di bawah CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Nomor registry (penetapan append-only menurut urutan ASCII, susunan blok, `0x0000`·`0xFFFF` tidak ditetapkan, daftar tertutup), bahwa ENUM dokumen spesifikasi adalah representasi resmi, dan pembedaan dari embedding field nilai mentah tanpa TAG adalah aturan GEUL.

## Panjang {#길이}

- Total adalah tepat 2 WORD, yaitu TAG 1 WORD ditambah Payload 1 WORD, dan memakai panjang langsung `LLLL=0001`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 1 WORD, ditolak.

## Contoh {#예시}

Nomor registry v2 (dokumen spesifikasi `0x00000000/codecs/0x000007A0` versi 2, IANA File-Date 2026-09-17). Sebanyak 8.678 nomor ditetapkan (language 8.275, grandfathered 26, redundant 67, kombinasi teramati 310).

| tag | kode | Total WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- Dalam dokumen spesifikasi, `en` adalah `ENUM #2 0x0784` dan `BIND "en"` yang diikat ke Edge Id-nya.
- `de-x-formal` (private-use) dan `nl-u-sd-bebru` (extension) tidak bernomor sehingga ditulis dengan LANGUAGE-BCP47-CODE.

## Masalah terbuka {#열린-문제}

- Penafsiran antar-edisi: ketika pembaca menemui nomor yang lebih baru daripada edisi yang dimilikinya, apakah dibuang sebagai invalid, atau nilai aslinya dipertahankan dan diperlakukan sebagai “kode tak dikenal”. Karena append-only, satu edisi terbaru selalu cukup, tetapi aturan untuk dekoder offline diperlukan.
- Bentuk normal: apakah tag yang bernomor harus (SHOULD/MUST) ditulis dengan SHORT-CODE. Jika MUST, penulisannya menjadi satu, tetapi saat edisi baru terbit dokumen yang ditulis sebelumnya bukan lagi bentuk normal.
- Cara menyatakan tag deprecated dan Preferred-Value dalam dokumen spesifikasi (tidak ada di edisi sekarang).
- Prosedur menambahkan tag kombinasi teramati (sumber, batas bawah pengamatan).

## Halaman terkait {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [dokumen spesifikasi Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000007A0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 baris ENUM·BIND dihilangkan)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
