---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT adalah teks berbahasa yang memuat satu record Value bahasa dan teks UTF-8 dalam satu Value (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT adalah teks berbahasa yang memuat satu record Value bahasa dan teks UTF-8 dalam satu Value (Codec 0x078L/0x079L).

| Butir | Nilai |
|---|---|
| Nama | `UTF8-LANGUAGE-TEXT` (kelompok genap-ganjil. Nama tiap kode ada di tabel anggota di bawah) |
| TAG ID | `0x078L`·`0x079L` |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 24~25 |
| Kind | Value · keluarga: TEXT |
| Deskripsi indeks | Teks berbahasa. Record Value bahasa (LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE) dan byte UTF-8. Genap·ganjil dari byte teks |
| Sisi Hugo | `value/text/utf8-language-text.md` |

## Anggota {#구성원}

Halaman ini membahas dua kode pasangan genap-ganjil sekaligus. Kode genap adalah nilai dengan jumlah byte genap, kode ganjil dengan jumlah byte ganjil ([Record dan TAG WORD](../record.md#가변-길이-바이트열)). Dokumen Codec ada satu per kode. Field pada kedua dokumen Codec sama, hanya sasaran DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Jumlah byte | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | genap | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | ganjil | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT adalah teks berbahasa. Satu record Value bahasa dan deret byte UTF-8 dimuat dalam satu Value.

[UTF8-TEXT](0x072L-utf8-text.md) adalah string tanpa bahasa (pengenal, kode, nama berkas, byte asli), sedangkan format ini adalah teks yang memiliki bahasa (nama, judul, slogan, kalimat). Keduanya nilai yang berbeda meskipun byte-nya sama. "Paris" (string) dan "Paris" (bahasa Prancis) tidak sama. Ini sama seperti RDF yang memisahkan `xsd:string` dan `rdf:langString`.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x078L` (byte teks genap)·`0x079L` (byte teks ganjil). Keluarga TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = teks berjumlah byte ganjil)
[Length extension TAG] jika total 15 WORD atau lebih
Language          1 record Value LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE (termasuk TAG)
Text WORD 1st ... Nth             UTF-8 bytes / jika ganjil, 0x00 di akhir
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload diawali record bahasa. WORD pertama Payload dibaca sebagai TAG, sepanjang Length-nya adalah record bahasa, dan sisanya adalah byte teks. Record bahasa wajib ada. Jika tidak ada bahasa, pakai UTF8-TEXT, bukan format ini.
- Record bahasa adalah tepat satu record lengkap [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) atau [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Jika Codec lain atau tidak lengkap, invalid. Validitas record bahasa mengikuti aturan formatnya.
- Kedua format bahasa dapat dipakai. Aturan untuk membandingkan apakah dua bahasa sama identik dengan [LABEL](../edge/0x0A4L-label.md). SHORT-CODE dan tag BCP 47 yang diikat registry ke nomor itu adalah bahasa yang sama.
- `zxx` (tanpa konten bahasa) tidak dipakai. String seperti itu adalah UTF8-TEXT. `und` (bahasa tak ditentukan) dan `mul` (banyak bahasa) adalah teks berbahasa sehingga dapat dipakai.
- Byte teks mengikuti aturan yang sama dengan UTF8-TEXT. Harus UTF-8 well-formed, U+FEFF di awal juga diizinkan sebagai karakter, normalisasi tidak dipaksakan dan disimpan apa adanya. Pihak yang membandingkan·mengindeks menyamakannya dengan NFC saat membandingkan.
- Jumlah byte teks adalah `2 × (jumlah Payload WORD − jumlah WORD record bahasa) − P`. P (bit paling rendah Codec) hanya menyatakan genap-ganjilnya byte teks. Jika ganjil, byte bawah WORD terakhir harus `00`.
- Teks kosong (0 byte) menempatkan hanya record bahasa pada kode genap.

## Tempat pemakaian {#쓰는-곳}

- Nilai monolingualtext Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` menjadi satu format ini. Masuk apa adanya sebagai Object [TRIPLE](../edge/0x0AAL-triple.md) dan Value [QUALIFIER](../edge/0x0ABL-qualifier.md). Properti, rank, dan qualifier ditangani TRIPLE.
- Object [LABEL](../edge/0x0A4L-label.md)·[ALIAS](../edge/0x0A5L-alias.md). Satu nilai ini memuat nama dan bahasa.
- Teks yang bahasanya sudah ditentukan, seperti judul peraturan perundang-undangan dan makalah.

## Pemetaan kode bahasa (Wikidata) {#언어-코드-대응-위키데이터}

- Kode bahasa Wikidata·Wikimedia tidak semuanya BCP 47 (contoh: `simple`, `map-bms`). Dipindahkan ke tag BCP 47 dengan tabel pemetaan. Kode yang tidak dapat dipindahkan ditangani berbeda sesuai pemakaiannya.
  - Nilai (monolingualtext): teks asli datavalue disimpan sebagai UTF8-TEXT. Nilai adalah bagian dari proposisi sehingga jika dibuang, proposisinya berubah.
  - Label·deskripsi·alias: dilewati dan dicatat dalam laporan. Edge-edge ini hanya berlaku jika ada bahasa (teks tanpa bahasa invalid), dan teks asli tetap ada di data sumber.
- Jika tag hasil pemindahan bernomor di GEUL Language Registry, pakai LANGUAGE-SHORT-CODE; jika tidak, pakai LANGUAGE-BCP47-CODE.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), record bahasa, dan WORD teks. Sampai 14 WORD memakai panjang langsung, 15 WORD atau lebih memakai panjang ekstensi ([Length](../record.md)).
- Record bahasa adalah 2 WORD untuk SHORT-CODE, dan `ceil(byte tag/2) + 1` WORD untuk BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Contoh {#예시}

Semua bahasa adalah contoh format LANGUAGE-BCP47-CODE. `fr`·`ko`·`de` bernomor di registry sehingga dapat juga ditulis dengan SHORT-CODE (2 WORD).

| Nilai | Byte teks | Total WORD |
|---|---|---|
| "Paris" (fr) | 5 (ganjil) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (genap) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795` (Codec `0x079L`, `LLLL=0101`, total 6 WORD), bahasa `0761 6672` (BCP 47 `fr`), teks `5061 7269 7300` (5 byte, `00` di akhir).
- Yang ketiga total 17 WORD sehingga memakai Length extension (`LLLL=1110` pada `078E`, extension TAG `0011`).

## Dasar standar {#표준-근거}

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`·`und`·`mul` adalah kode special pada IANA Language Subtag Registry.
- Teks: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Pembedaan string dan teks berbahasa: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Masalah terbuka {#열린-문제}

- Pemeriksaan tata bahasa tag BCP 47 pada schema. Saat ini hanya diperiksa bahwa isinya ASCII dan tidak kosong.

## Halaman terkait {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000780/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

Di atas adalah dokumen Codec untuk `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). Dokumen Codec anggota lain (`UTF8-LANGUAGE-TEXT-ODD`) hanya berbeda pada Codec ID di DOC-ID, sasaran DECLARE, dan nama yang diikat pada `#1` (BIND).
