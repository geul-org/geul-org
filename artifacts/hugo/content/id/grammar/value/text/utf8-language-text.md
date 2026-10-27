---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT adalah teks dengan bahasa yang memuat satu record Value bahasa dan teks UTF-8 dalam satu Value (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT adalah teks dengan bahasa. Memuat satu record Value bahasa dan deretan byte UTF-8 dalam satu Value.

[UTF8-TEXT](/id/grammar/value/text/utf8-text/) adalah string tanpa bahasa (pengenal, kode, nama file, byte teks asli), sedangkan format ini adalah teks dengan bahasa (nama, judul, slogan, kalimat). Keduanya adalah nilai yang berbeda walaupun byte-nya sama. "Paris" (string) dan "Paris" (bahasa Prancis) tidak sama. Sama seperti RDF membedakan `xsd:string` dan `rdf:langString`.

## Layout

- Kode: kode langsung Value `0x4A` (byte teks genap)·`0x4B` (byte teks ganjil). Keluarga TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = byte teks ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Language          1 record Value LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE (termasuk TAG)
Text WORD 1st ... Nth             UTF-8 bytes / 0x00 terakhir jika ganjil
```

## Interpretasi dan validitas

- Payload dimulai dengan record bahasa. WORD pertama Payload dibaca sebagai TAG dan sepanjang Length-nya adalah record bahasa, dan sisanya adalah byte teks. Record bahasa wajib. Jika tidak ada bahasa, pakai UTF8-TEXT, bukan format ini.
- Record bahasa adalah tepat satu record [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/) (`0x48`) atau [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`) yang lengkap. Jika Codec lain atau tidak lengkap, invalid. Validitas record bahasa mengikuti aturan format itu.
- Kedua format bahasa dapat dipakai. Aturan membandingkan apakah bahasa sama sama dengan [LABEL](/id/grammar/edge/label/). SHORT-CODE dan tag BCP 47 yang hanya satu primary subtag yang berpadanan dengannya adalah bahasa yang sama.
- `zxx` (tanpa konten bahasa) tidak dipakai. String seperti itu adalah UTF8-TEXT. `und` (bahasa belum ditentukan) dan `mul` (beberapa bahasa) adalah teks dengan bahasa sehingga dapat dipakai.
- Byte teks mengikuti aturan yang sama dengan UTF8-TEXT. Harus UTF-8 well-formed, BOM di depan dilarang, normalisasi tidak dipaksakan dan teks asli dipertahankan apa adanya. Pihak yang membandingkan·mengindeks menyamakan dengan NFC saat membandingkan.
- Jumlah byte teks adalah `2 × (jumlah WORD Payload − jumlah WORD record bahasa) − P`. P (bit paling tidak signifikan Codec) hanya menyatakan genap-ganjilnya byte teks. Jika ganjil, byte bawah WORD terakhir harus `00`.
- Teks kosong (0 byte) menaruh hanya record bahasa pada kode genap.

## Tempat pemakaian

- Nilai monolingualtext Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` menjadi satu format ini. Masuk apa adanya ke Object [TRIPLE](/id/grammar/edge/triple/) dan Value [QUALIFIER](/id/grammar/edge/qualifier/). Properti·rank·qualifier ditangani TRIPLE.
- Object [LABEL](/id/grammar/edge/label/)·[ALIAS](/id/grammar/edge/alias/). Satu nilai ini memuat nama dan bahasa.
- Teks yang bahasanya sudah ditentukan seperti judul undang-undang·makalah.

## Padanan kode bahasa (Wikidata)

- Kode bahasa Wikidata·Wikimedia tidak semuanya BCP 47 (contoh: `simple`, `map-bms`). Dipindahkan ke tag BCP 47 dengan tabel padanan. Kode yang tidak dapat dipindahkan ditangani berbeda menurut pemakaian.
  - Nilai (monolingualtext): teks asli datavalue dipertahankan sebagai UTF8-TEXT. Nilai adalah bagian proposisi sehingga jika dibuang proposisi berubah.
  - Label·deskripsi·alias: dilewati dan dicatat dalam laporan. Edge ini hanya berdiri jika ada bahasa (teks tanpa bahasa adalah invalid), dan teks aslinya tetap ada di data sumber.
- Sampai GEUL Language Registry terbentuk, dipakai LANGUAGE-BCP47-CODE.

## Panjang

- Total adalah jumlah TAG 1 WORD, Length extension TAG (jika ada), record bahasa, dan WORD teks. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension ([Length](/id/grammar/record/)).
- Record bahasa adalah 2 WORD jika SHORT-CODE, dan `ceil(byte tag/2) + 1` WORD jika BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Contoh

Karena registri bahasa belum ada, semuanya LANGUAGE-BCP47-CODE.

| Nilai | Byte teks | WORD total |
|---|---|---|
| "Paris" (fr) | 5 (ganjil) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (genap) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, total 6 WORD), bahasa `08C6 6672` (BCP 47 `fr`), teks `5061 7269 7300` (5 byte, `00` terakhir).
- Yang ketiga total 17 WORD sehingga memakai Length extension (`LLLL=1110` pada `0F4A`, extension TAG `0011`).

## Dasar standar

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`·`und`·`mul` adalah kode special pada IANA Language Subtag Registry.
- Teks: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Pembedaan string dan teks dengan bahasa: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Masalah terbuka

- Pemeriksaan tata bahasa tag BCP 47 pada schema. Saat ini hanya memeriksa ASCII dan tidak kosong.

## Halaman terkait

- [Value](/id/grammar/value/), [UTF8-TEXT](/id/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/), [LABEL](/id/grammar/edge/label/)
