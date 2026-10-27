---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY adalah Meta struktur 1 WORD yang mengakhiri HEAD dokumen dan memulai BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Record yang mengakhiri HEAD dan memulai BODY.

## Layout

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length extension TAG]
```

- Codec: Meta `0x0E`, kelas struktur (`000`)
- Payload: tidak ada (1 WORD)
- Jumlah: paling banyak satu per dokumen

## Interpretasi dan validitas

- Dihilangkan jika HEAD kosong. Dokumen tanpa `BODY` seluruhnya adalah BODY. Ditaruh jika HEAD berisi Meta atau Edge HEAD ([SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) untuk seluruh dokumen beserta QUALIFIER-nya).
- Tidak ada Payload. Total 1 WORD.

## Contoh

- `0x180E`
