---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END adalah Meta struktur 1 WORD yang menutup dokumen. Wajib pada semua dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Record yang menutup dokumen.

## Layout

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length extension TAG]
```

- Codec: Meta `0x0F`, kelas struktur (`000`)
- Payload: tidak ada (1 WORD)
- Jumlah: satu per dokumen, di paling akhir

## Interpretasi dan validitas

- Wajib. Posisinya diperiksa dengan panjang [DOC](/id/grammar/meta/structure/doc/) (`DOC-*`).
- Jika input berakhir tanpa END, itu dokumen yang terpotong. Apakah isi dokumen terpotong dianggap valid adalah kebijakan decoder.
- Tidak ada apa pun setelahnya.

## Contoh

- `0x180F`
