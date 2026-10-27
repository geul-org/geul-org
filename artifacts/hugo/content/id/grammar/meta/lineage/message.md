---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE adalah Meta silsilah yang mencatat alasan perubahan sebagai teks berbahasa (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat alasan perubahan (git commit message).

## Layout

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length extension TAG]
Pesan             1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x38`, kelas silsilah (`011`)
- Payload: Value tersemat ([UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/))
- Jumlah: paling banyak satu per bahasa

## Interpretasi dan validitas

- Pesan dan bahasa ditaruh dalam satu UTF8-LANGUAGE-TEXT. MESSAGE untuk bahasa yang sama hanya satu.
- Spesifikasi geul.org mencatatnya dengan [CODEC](/id/grammar/edge/codec/) `084A`·`084B`.
