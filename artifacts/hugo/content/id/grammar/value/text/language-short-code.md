---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE adalah Value kode bahasa GEUL yang memuat dalam 1 WORD satu tag BCP 47 yang diberi nomor oleh GEUL Language Registry (Codec 0x48). Registri itu adalah ENUM dalam dokumen spesifikasi Codec ini."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE adalah kode bahasa terkompresi GEUL yang memuat dalam 1 WORD satu tag BCP 47 yang punya nomor di GEUL Language Registry. Payload tepat 1 WORD.

## Layout

- Kode: kode langsung Value `0x48`. Keluarga TEXT.
- Payload tepat 1 WORD berupa kode unsigned 16 bit.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  total 2 WORD
Payload WORD 1st (16 bit)           nomor GEUL Language Registry (uint16)
```

## Interpretasi dan validitas

- 1 WORD Payload dibaca sebagai bilangan bulat unsigned 16 bit.
- Nilai ini adalah satu tag yang dialokasikan oleh GEUL Language Registry. Bentuk normatif registri adalah dokumen spesifikasi Codec ini, `0x0000/0x0000000000000848`. Setiap nilai kode punya satu [ENUM](/id/grammar/edge/enum/) pada FIELD `code`, dan nama yang diikat dengan [BIND](/id/grammar/edge/bind/) ke Edge Id ENUM itu adalah tag BCP 47 dalam huruf besar-kecil kanonis.
- Registri adalah daftar tertutup. Nilai yang tidak punya ENUM dalam dokumen spesifikasi adalah invalid. Aturan Codec ini didahulukan atas aturan umum ENUM ("nilai kode yang tidak dideklarasikan bukan galat").
- Ada tiga jenis tag yang dialokasikan.
  - Record `Type: language` dari IANA Language Subtag Registry, kecuali `Scope: private-use` (`qaa..qtz`). Collection, macrolanguage, dan special (`mul`, `und`, `zxx`, `mis`) tidak dikecualikan.
  - Tag yang didaftarkan utuh oleh IANA: grandfathered dan redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, dan sebagainya).
  - Tag gabungan yang valid dan teramati di sumber publik CC0 (`pt-BR`, `en-GB`, `be-tarask`, dan sebagainya). Hanya terdiri dari subtag language, extlang, script, region, dan variant. Tag yang memuat extension (`-u-`, `-t-`) atau private-use (`-x-`) tidak diterima.
- Tag tanpa nomor tidak dapat ditulis dalam format ini. Tulislah sebagai [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). Di dalam SHORT-CODE tidak ada jalur escape.
- `0x0000` dan `0xffff` tidak pernah dialokasikan. Keduanya invalid dalam Value ini. Keduanya tidak dipakai dengan arti `null`, `unknown`, atau `und`.
- Rentang nilai adalah konvensi alokasi. Decoder tidak menebak jenis tag dari rentang nilai. Arti nilai hanya berasal dari dokumen spesifikasi.

| Rentang | Kegunaan |
|---|---|
| `0x0000` | Tidak dialokasikan (invalid) |
| `0x0001`–`0x3fff` | Tag yang terdiri dari satu language subtag |
| `0x4000`–`0x7fff` | Tag yang terdiri dari dua subtag atau lebih (tag utuh IANA, tag gabungan teramati) |
| `0x8000`–`0xfffe` | Luapan. Jika blok di atas penuh, alokasi berlanjut di sini |
| `0xffff` | Tidak dialokasikan (invalid) |

- Edisi awal memberi nomor di dalam tiap blok menurut urutan ASCII huruf kecil tag. Di blok `0x4000`, tag utuh IANA (grandfathered dan redundant dicampur, urutan ASCII) didahulukan, lalu tag gabungan teramati (urutan ASCII). Urutan fisik berkas IANA dan frekuensi pemakaian bukan aturan penomoran.
- Alokasi hanya menambah (append-only). Tag baru ditambahkan di akhir bloknya, dan jika blok penuh, di rentang luapan. Tag (tanpa membedakan huruf besar-kecil) dari nomor yang sudah diberikan tidak diubah, dihapus, atau dipakai ulang.
- Tag baru masuk dengan menambahkan ENUM dan BIND pada versi baru dokumen spesifikasi. ENUM dan BIND yang ada tidak diubah. Karena itu setiap versi adalah superset dari versi sebelumnya.
- Jika 65.534 nomor sudah habis, tidak ada lagi alokasi. Tag baru setelah itu ditulis sebagai LANGUAGE-BCP47-CODE. Daya ungkap tidak berkurang; hanya keuntungan kompresi yang hilang.
- Bahasa yang sama: SHORT-CODE `n` dan LANGUAGE-BCP47-CODE dari tag yang diikat registri ke `n` (tanpa membedakan huruf besar-kecil) adalah bahasa yang sama.
- Edisi registri adalah versi dokumen spesifikasi. Setiap edisi mencatat berkas registri IANA yang menjadi dasarnya (File-Date, SHA-256) sebagai [SOURCE](/id/grammar/edge/source/) di HEAD dokumen spesifikasi. Bila edisi yang dipakai untuk menafsirkan suatu nilai perlu dinyatakan, simpan versi itu (`0x0000/0x0000000000000848@n`) bersamanya.
- Spesifikasi Codec boleh memuat kode 1 WORD yang sama di field nilai mentah tanpa TAG ([CODEC](/id/grammar/codec-spec/#codec) pada field nilai mentah). Itu aturan spesifikasi Codec tersebut; wire form Value mandiri selalu TAG 1 WORD + Payload 1 WORD.

## Dasar standar

- Arti tag dan validitas subtag mengikuti [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) dan [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA dan IETF menempatkan hak mereka atas registri protokol di bawah CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Nomor registri (alokasi append-only urutan ASCII, susunan blok, `0x0000` dan `0xffff` tidak dialokasikan, daftar tertutup), ENUM dokumen spesifikasi sebagai bentuk normatif, dan pembedaan dari embedding tanpa TAG pada field nilai mentah adalah aturan GEUL.

## Panjang

- Total tepat 2 WORD, TAG 1 WORD ditambah Payload 1 WORD, dengan panjang langsung `LLLL=0001`. Tidak ada extension TAG Length, descriptor, atau padding.
- Jika Payload tidak tepat 1 WORD, tolak.

## Contoh

Nomor registri v2 (dokumen spesifikasi `0x0000/0x0000000000000848` versi 2, IANA File-Date 2026-09-17). Sebanyak 8.678 tag dialokasikan (language 8.275, grandfathered 26, redundant 67, gabungan teramati 310).

| tag | Kode | Seluruh WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- Dalam dokumen spesifikasi, `en` adalah `ENUM #2 0x0784` dan `BIND "en"` pada Edge Id-nya.
- `de-x-formal` (private-use) dan `nl-u-sd-bebru` (extension) tidak punya nomor sehingga ditulis sebagai LANGUAGE-BCP47-CODE.

## Masalah terbuka

- Pembacaan lintas edisi: apakah nomor yang lebih baru daripada edisi milik pembaca dibuang sebagai invalid atau disimpan dengan nilai mentahnya sebagai "kode tak dikenal". Karena append-only, edisi terbaru selalu cukup, tetapi decoder luring memerlukan aturan.
- Bentuk kanonis: apakah tag yang punya nomor harus (SHOULD/MUST) ditulis sebagai SHORT-CODE. Dengan MUST ejaannya tunggal, tetapi edisi baru akan membuat dokumen yang ditulis sebelumnya tidak kanonis.
- Cara menyatakan tag deprecated dan Preferred-Value dalam dokumen spesifikasi (edisi sekarang belum memuatnya).
- Prosedur menambah tag gabungan teramati (sumber, ambang pengamatan).

## Halaman terkait

- [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/), [LABEL](/id/grammar/edge/label/)
- [dokumen spesifikasi Codec](/id/grammar/codec-spec/), [ENUM](/id/grammar/edge/enum/), [BIND](/id/grammar/edge/bind/), [SOURCE](/id/grammar/edge/source/)
