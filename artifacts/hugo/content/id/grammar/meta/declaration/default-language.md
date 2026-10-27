---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE adalah Meta definisi yang menyatakan bahasa default teks dokumen sebagai Value bahasa."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan bahasa default teks dokumen. Teks yang bahasanya tidak ditulis terpisah memakai bahasa ini.

## Layout

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length extension TAG]
Payload           satu Value bahasa
```

- Codec: Meta `0x16`, kelas definisi (`001`)
- Payload: Value tersemat ([LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/) atau [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Dokumen TANGEUL menulis locale penulisan (misalnya `en`, `ko`).

## Contoh

- `en`: `0x1916 0x08C6 0x656E`
