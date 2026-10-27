---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY adalah Meta silsilah yang mencatat alat yang mengubah representasi lain menjadi dokumen ini beserta versi sumbernya (digest commit)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat cara representasi lain diubah menjadi dokumen ini (misalnya konverter Wikidata, encoder bahasa alami). Tool adalah apa yang dipakai untuk mengubah, dan Version adalah sumber mana dari alat itu yang dipakai. Keduanya diperlukan agar dokumen yang sama dapat dibuat ulang dari input yang sama.

## Layout

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length extension TAG]
Tool              1 record Reference (alat atau aturan konversi)
Version           1 record Value (SHA-256-DIGEST atau SHA1-DIGEST)
```

- Codec: Meta `0x33`, kelas silsilah (`011`)
- Payload: Reference tersemat (alat) + Value tersemat (digest versi sumber)
- Jumlah: boleh lebih dari satu (satu per alat)

## Interpretasi dan validitas

- Tool adalah tepat satu record Reference yang lengkap. Reference apa pun yang menunjuk alat dapat dipakai.
  - Alat pada dokumen alat geul.org: [EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/) (`0x0000`, ID dokumen `0x0001xxxx xxxxxxxx`, LOCAL-nya). Satu dokumen untuk satu alat (dokumen definisi istilah [Issuer](/id/grammar/issuer/)).
  - Jika codec-nya adalah dokumen GEUL, dokumen itu ditunjuk dengan [DOC-POINTER](/id/grammar/reference/doc-pointer/).
- Version adalah tepat satu record Value yang lengkap, yaitu ID objek manajemen versi dari sumber Tool. Untuk git, itu seluruh ID objek commit.
  - Jika format objek repositori git adalah SHA-256, pakai [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD); jika SHA-1, pakai [SHA1-DIGEST](/id/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). Format repositori diperiksa dengan `git rev-parse --show-object-format`.
  - ID singkat (`2bd496f` dan sejenisnya) tidak dipakai. Value digest tidak mengizinkan nilai yang dipotong.
  - Tidak ditulis sebagai teks hex (UTF8-TEXT). Nilai yang sama menjadi 22 WORD pada SHA-1 (biner 11) dan 34 WORD pada SHA-256 (biner 18).
- Version wajib. Catatan alat yang versi sumbernya tidak diketahui tidak dapat menjadi dasar reproduksi. Untuk alat di luar manajemen versi, pakai SHA-256 dari artefak distribusi (SHA-256-DIGEST).
- Version menunjuk sumber yang sudah di-commit. Pada dokumen yang dibuat dari working tree yang memiliki perubahan belum di-commit, ID commit itu tidak dipakai (disarankan agar alat menolak berjalan).
- Jika alat bergantung pada kode di luar repositori (misalnya pustaka lokal yang ditunjuk dengan `replace` Go), kode itu juga dicatat terpisah dengan TRANSFORMED-BY. ID commit alat saja tidak menentukan kode tersebut.
- Alat yang hanya memindahkan sumber tanpa kehilangan (misalnya alat yang memuat dump apa adanya ke DB) tidak menentukan isi dokumen, sehingga tidak dicatat. Pemuatan yang tidak lossless mengubah dokumen, sehingga dicatat sebagai alat.
- Spesifikasi geul.org (`0x1833`) mencatatnya sebagai field dua record: Tool (lebar 0, Reference apa pun sehingga tanpa CODEC) dan Version (lebar 0, [CODEC](/id/grammar/edge/codec/) `0861`·`0862`).

## Panjang

```
total = 1 + N_len + N_tool + N_version WORD
```

- Kursor setelah membaca record terakhir harus tepat sama dengan akhir Meta.
- Jika Tool adalah EXTERNAL-ISSUER-1WORD (7 WORD) dan Version adalah SHA1-DIGEST (11 WORD), totalnya 1 + 1 + 7 + 11 = 20 WORD dengan Length extension. Dengan SHA-256-DIGEST (18 WORD), totalnya 27 WORD.

## Contoh

Contoh non-normatif. Alatnya adalah LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) dari dokumen alat geul.org `0x0001000000000001`, dan sumbernya adalah commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Masalah terbuka

- Apakah versi pada [GENERATED-BY](/id/grammar/meta/lineage/generated-by/) juga diubah dengan cara yang sama (digest wajib atau format lain). Versi model bukan ID commit.

## Halaman terkait

- [Meta](/id/grammar/meta/), [GENERATED-BY](/id/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/id/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/), [DOC-POINTER](/id/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/id/grammar/value/binary/sha1-digest/), [CODEC](/id/grammar/edge/codec/)
