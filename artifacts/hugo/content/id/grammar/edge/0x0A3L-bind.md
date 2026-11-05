---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND adalah Edge pernyataan yang mengikat nama yang dicocokkan mesin pada Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `BIND` (BIND dokumen spesifikasi `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A30/` (target DECLARE `0A30`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 3 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Mengikat nama yang dicocokkan mesin (`UTF8-TEXT-*`) pada Subject. Unik dalam cakupannya, harus cocok persis, dan tidak punya bahasa |
| Sisi Hugo | `edge/bind.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `name` | #3 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND adalah Edge pernyataan yang mengikat nama yang dicocokkan mesin pada Subject. Codec `0x0A3L`.

Ini adalah penamaan. Nama yang dibaca manusia (judul per bahasa) menjadi tugas [LABEL](0x0A4L-label.md). Nama simbol program dan nama domain daftar Issuer ditulis dengan record yang sama.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference, atau 1 WORD TAG WORD codec
Nama              1 Value UTF8-TEXT-*
```

## Interpretasi dan validitas {#해석과-유효성}

- Subject adalah tepat satu record [Reference](../reference/_index.md) yang lengkap. Jika LOCAL, itu objek dokumen ini (simbol, dan lain-lain); jika Reference penunjuk, itu objek dokumen lain. Dokumen itu sendiri adalah [DOC-POINTER](../reference/0x041L-doc-pointer.md), dan Issuer itu sendiri adalah [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Atau, Subject adalah satu TAG WORD codec (hanya Kind·Codec, `LLLL = 0`, tanpa Payload). Ini bukan record dengan Payload kosong, melainkan menunjuk kode langsung itu sendiri, yaitu dokumen spesifikasinya (codec Issuer GEUL `0x0000<TAG>`) ([dokumen spesifikasi Codec](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Contoh: `0B80` adalah PUBLICATION. Codec bentuk Issuer tidak ditunjuk dengan cara ini.
- Record lain (Value, dan lain-lain) tidak dapat menjadi Subject. FIELD dokumen spesifikasi BIND hanya mendeklarasikan Subject dengan lebar `0` (record), sehingga batasan ini adalah aturan isi BIND.
- Nama adalah tepat satu Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Tidak punya bahasa dan tidak dinormalisasi. Nama sama hanya jika byte-nya sama.
- Cakupan nama adalah dokumen yang memuat BIND. Dalam satu dokumen, nama yang sama tidak diikat pada Subject yang berbeda.
- Satu Subject dapat diikat dengan beberapa nama (alias, nama lama). Jika dokumen tidak menentukan lain, BIND terakhir adalah nama representatif.
- Record lain menunjuk objek dengan LOCAL ID, bukan dengan nama. Nama dipakai untuk mencocokkan dengan pihak luar (fungsi host, input alamat, manusia).
- Karakter yang boleh dipakai dalam nama ditentukan oleh penggunaannya. Nama domain daftar Issuer mengikuti aturan domain (huruf kecil, IDNA) ([alamat publikasi dan daftar versi](../publishing.md#issuer-목록)).
- Daftar versi tidak memuat BIND. Tidak ada alamat nama dokumen ([alamat publikasi dan daftar versi](../publishing.md#문서-이름)).

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Contoh (non-normatif) {#예시-비규범}

Simbol program: Edge Id `0003`, Subject LOCAL 7, nama `main`.

- Nama `main` adalah 4 byte (genap), sehingga `0722 6D61 696E`, 3 WORD.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + nama 3 = 8 WORD, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [alamat publikasi dan daftar versi](../publishing.md#issuer-목록) (nama domain daftar Issuer)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A30/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
