---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE adalah Meta kebijakan yang mencatat batasan penggunaan seperti larangan pelatihan dan larangan penggunaan komersial."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat batasan penggunaan (misalnya larangan pelatihan, larangan penggunaan komersial).

## Layout

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length extension TAG]
Payload           teks atau Reference yang menyatakan batasan penggunaan
```

- Codec: Meta `0x55`, kelas kebijakan (`101`)
- Payload: Value atau Reference tersemat
- Jumlah: boleh lebih dari satu

## Masalah terbuka

- Tabel kode jenis batasan.
