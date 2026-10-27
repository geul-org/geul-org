---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY adalah Meta verifikasi yang menyatakan ID algoritma tanda tangan dan kunci publik dari Issuer yang menerbitkan sendiri (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan kunci publik Issuer yang menerbitkan sendiri (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID algoritma ‖ kunci publik) ([Issuer 16 WORD](/id/grammar/issuer/#issuer-16-word)).

## Layout

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length extension TAG]
ID algoritma      1 WORD (0x0001 = Ed25519)
Kunci publik      lebar yang ditentukan algoritma (Ed25519 16 WORD)
```

- Codec: Meta `0x40`, kelas verifikasi (`100`)
- Payload: nilai mentah (ID algoritma + kunci publik)
- Jumlah: boleh lebih dari satu (penggantian kunci)

## Interpretasi dan validitas

- Karena kelas verifikasi, dikeluarkan dari hash isi.
- Issuer 1·2·4 WORD memakai kunci yang terdaftar di geul.org, sehingga tidak diperlukan.
