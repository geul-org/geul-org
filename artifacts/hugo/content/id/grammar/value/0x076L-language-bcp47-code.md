---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE adalah Value yang memuat language tag BCP 47 lengkap sebagai deret byte ASCII."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE adalah Value yang memuat language tag BCP 47 lengkap sebagai deret byte ASCII. Memakai pasangan kode jumlah byte genap·ganjil 0x076L/0x077L.

| Butir | Nilai |
|---|---|
| Nama | `LANGUAGE-BCP47-CODE` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x076L`·`0x077L` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 22~23 |
| Kind | Value · keluarga: TEXT |
| Deskripsi indeks | Deret byte ASCII language tag BCP 47 lengkap dengan canonical casing. Jumlah byte genap·ganjil |
| Sisi Hugo | `value/text/language-bcp47-code.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | genap | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | ganjil | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE adalah Value yang memuat language tag BCP 47 lengkap. Dipakai untuk menuliskan bahasa secara tepat sampai script, region, dan variant.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x076L` (jumlah byte genap)·`0x077L` (jumlah byte ganjil). Keluarga TEXT.
- Jumlah byte ditentukan oleh bit paling rendah Codec dan jumlah Payload WORD. Rumusnya `2 × jumlah Payload WORD − bit paling rendah`, dan Byte Count tidak dipakai ([Value](_index.md)).
- Payload bukan teks UTF-8, melainkan deret byte ASCII tag BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretasi dan validitas {#해석과-유효성}

- Deret byte harus berupa language tag BCP 47 well-formed menurut RFC 5646. String kosong tidak diizinkan.
- Payload hanya memakai huruf ASCII, angka, dan hyphen-minus `-`. Pemisahnya harus ASCII `-`, dan `_`, spasi, serta karakter non-ASCII tidak diizinkan.
- Perbandingan tag BCP 47 tidak membedakan huruf besar-kecil. Profil canonical GEUL memakai `-` untuk semua pemisah, dan menyerialisasi subtag language/extlang/variant/extension/private-use dengan huruf kecil, script dengan Titlecase, dan region dengan huruf besar.
- Well-formed saja tidak cukup. Validitas registered subtag dan grandfathered tag ditentukan berdasarkan snapshot IANA Language Subtag Registry tertentu, dan tanggal snapshot atau versi registry itu harus disimpan bersamanya.
- Tag private-use dan subtag private-use diizinkan jika well-formed menurut tata bahasa RFC 5646. Namun maknanya bergantung pada kesepakatan para pihak dan tidak didefinisikan registry IANA, sehingga interoperabilitas umum tidak dijamin.
- Jika pada snapshot yang sama subtag deprecated atau grandfathered tag memiliki Preferred-Value, bentuk GEUL canonical menulis nilai pengganti itu dengan canonical casing. Tag dalam notasi deprecated apa adanya dapat ditafsirkan sebagai masukan, tetapi bukan bentuk simpan yang canonical.
- BCP 47 adalah profil ASCII sehingga tuntutan Unicode normalization seperti UTF-8 NFC tidak berlaku.
- Dalam satu WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah yang tidak terpakai pada WORD terakhir harus `00`.
- Jumlah Payload WORD adalah `ceil(jumlah byte/2)`. Jika kode ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar {#표준-근거}

- Tata bahasa language tag, penafsiran tanpa membedakan huruf besar-kecil, dan konsep deprecated/Preferred-Value mengikuti [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Registry yang menentukan validitas tag adalah [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Pasangan kode genap-ganjil, zero padding, kebijakan penyimpanan canonical casing, dan perhitungan Length adalah aturan framing GEUL.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Length](../record.md)).

## Hubungan dengan LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Tag yang bernomor di GEUL Language Registry dapat ditulis dengan [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) 1 WORD.
- Tag yang tidak bernomor di registry (termasuk tag yang memuat extension·private-use) ditulis dengan LANGUAGE-BCP47-CODE. LANGUAGE-BCP47-CODE juga dipakai jika teks asli full tag perlu dipertahankan.
- SHORT-CODE `n` dan LANGUAGE-BCP47-CODE dari tag yang diikat registry ke `n` (tanpa membedakan huruf besar-kecil) menyatakan bahasa yang sama.

## Contoh {#예시}

- `ko-KR` adalah ASCII 5 byte (ganjil) sehingga `LANGUAGE-BCP47-CODE-ODD` (`0x077L`), Payload-nya `6B6F 2D4B 5200`.
- TAG 1 WORD dan Payload 3 WORD menjadi total 4 WORD dengan `LLLL=0011`. Totalnya `0773 6B6F 2D4B 5200`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000760/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Di atas adalah dokumen Codec untuk `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). Dokumen Codec anggota lain (`LANGUAGE-BCP47-CODE-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
