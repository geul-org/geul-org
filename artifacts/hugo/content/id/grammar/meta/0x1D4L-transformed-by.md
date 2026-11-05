---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Mencatat cara mengubah representasi lain menjadi dokumen ini (contoh: konverter Wikidata, encoder bahasa alami)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `TRANSFORMED-BY` (BIND `TRANSFORMED-BY` pada dokumen spesifikasi) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001D40/` (target DECLARE `1D40`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 20 |
| Kind | Meta · kelas: silsilah |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Cara konversi. Alat, aturan, versi |
| Sisi Hugo | `meta/lineage/transformed-by.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | record | record apa pun (kecuali penanda slot) |  |
| 2 | `version` | #3 | record | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Mencatat cara mengubah representasi lain menjadi dokumen ini (contoh: konverter Wikidata, encoder bahasa alami). Tool adalah apa yang dipakai untuk mengubah; Version adalah sumber alat itu yang mana yang dipakai untuk mengubah. Dengan keduanya, dokumen yang sama dapat dibuat ulang dari input yang sama.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[TAG ekstensi Length]
Tool              1 record Reference (alat atau aturan konversi)
Version           1 record Value (SHA-256-DIGEST atau SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, kelas silsilah
- Payload: Reference bawaan (alat) + Value bawaan (digest versi sumber)
- Jumlah: dapat lebih dari satu (satu per alat)

## Interpretasi dan validitas {#해석과-유효성}

- Tool adalah tepat satu record Reference yang lengkap. Reference apa pun yang menunjuk alat dapat dipakai.
  - Alat dalam dokumen alat geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, ID dokumen `0x0001xxxx xxxxxxxx`, LOCAL-nya). Satu dokumen untuk satu alat (dokumen definisi istilah [Issuer](../issuer.md)).
  - Jika Codec adalah dokumen GEUL, dokumen Codec itu ditunjuk dengan [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version adalah tepat satu record Value yang lengkap dan merupakan ID objek manajemen versi dari sumber Tool. Untuk git, ini ID objek commit secara utuh.
  - Jika format objek repositori git adalah SHA-256, gunakan [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORD); jika SHA-1, gunakan [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORD). Format repositori diperiksa dengan `git rev-parse --show-object-format`.
  - Jangan memakai ID singkat (seperti `2bd496f`). Value digest tidak mengizinkan nilai terpotong.
  - Jangan menulis dengan teks hex (UTF8-TEXT). Nilai yang sama menjadi 22 WORD (biner 11) pada SHA-1 dan 34 WORD (biner 18) pada SHA-256.
- Version wajib. Catatan alat yang versi sumbernya tidak diketahui tidak dapat menjadi dasar reproduksi. Untuk alat di luar manajemen versi, gunakan SHA-256 dari artefak rilisnya (SHA-256-DIGEST).
- Version menunjuk sumber yang sudah di-commit. Untuk dokumen yang dibuat dari working tree dengan perubahan yang belum di-commit, ID commit itu tidak ditulis (disarankan alat menolak berjalan).
- Jika alat bergantung pada kode di luar repositori (contoh: pustaka lokal yang ditunjuk dengan `replace` Go), kode itu juga dicatat terpisah dengan TRANSFORMED-BY. ID commit alat saja tidak menentukan kode tersebut.
- Alat yang hanya memuat sumber tanpa kehilangan (contoh: alat yang memuat dump apa adanya ke DB) tidak menentukan isi dokumen, sehingga tidak dicatat. Pemuatan yang tidak lossless mengubah dokumen, sehingga dicatat sebagai alat.
- Dokumen spesifikasi geul.org (`0x1D40`) ditulis sebagai dua bidang record: Tool (lebar 0, Reference apa pun sehingga tanpa CODEC) dan Version (lebar 0, [CODEC](../edge/0x0BEL-codec.md) `07C0` dan `07D0`).

## Panjang {#길이}

```
total = 1 + N_len + N_tool + N_version WORD
```

- Kursor setelah semua record terakhir dibaca harus tepat berimpit dengan akhir Meta.
- Jika Tool adalah EXTERNAL-ISSUER-2WORD (8 WORD) dan Version adalah SHA1-DIGEST (11 WORD), total 1 + 1 + 8 + 11 = 21 WORD dan panjang ekstensi dipakai. Jika SHA-256-DIGEST (18 WORD), totalnya 28 WORD.

## Contoh {#예시}

Contoh non-normatif. Alatnya adalah LOCAL 2 pada dokumen alat geul.org `0x0001000000000001` (`02F7 0000 0000 0001 0000 0000 0001 0002`), dan sumbernya commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Masalah terbuka {#열린-문제}

- Apakah versi pada [GENERATED-BY](0x1D3L-generated-by.md) juga diubah dengan cara yang sama (digest wajib atau format lain). Versi model bukan ID commit.

## Halaman terkait {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001D40/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
