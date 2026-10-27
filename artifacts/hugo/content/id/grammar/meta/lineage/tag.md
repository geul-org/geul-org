---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG adalah Meta silsilah yang mencatat nama tetap yang diberikan pada sebuah versi (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat nama tetap yang diberikan pada sebuah versi (git annotated tag).

## Layout

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length extension TAG]
Nama              Value UTF8-TEXT-*
Target            Value SHA-256-DIGEST, atau penanda pelepasan 0x0000 (field opsional). Jika dilepas, versi ini
```

- Codec: Meta `0x39`, kelas silsilah (`011`)
- Payload: Value tersemat (teks + hash isi opsional)
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Nama adalah [UTF8-TEXT](/id/grammar/value/text/utf8-text/), target adalah [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/).
- Jika target dilepas (ABSENT `0x0000`, field opsional [CODEC](/id/grammar/edge/codec/)), itu nama yang diberikan pada dokumen ini sendiri. Hash isi sendiri tidak dapat ditulis di dalam dirinya sendiri. Spesifikasi geul.org `0x1839` adalah field dua record: name (`0840`·`0841`) dan target (`0861`·`0000`).
- Nama yang sama tidak dipakai ulang pada versi lain.

## Contoh

- Nama `v1`, versi ini: `19B9 08C0 7631 0000`

## Masalah terbuka

- Apakah TAG masih diperlukan padahal sudah ada ID versi (nomor urut), dan pembagian peran dengan nama dokumen (`BIND`).
