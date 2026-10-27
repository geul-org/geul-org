---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT adalah Meta kebijakan yang mencatat cakupan dan dasar persetujuan sebagai Reference atau teks."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat cakupan dan dasar persetujuan.

## Layout

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length extension TAG]
Payload           Reference atau teks yang menunjuk dasar persetujuan
```

- Codec: Meta `0x54`, kelas kebijakan (`101`)
- Payload: Reference atau Value tersemat
- Jumlah: boleh lebih dari satu

## Masalah terbuka

- Struktur ekspresi cakupan (tujuan, jangka waktu, penyediaan kepada pihak ketiga).
