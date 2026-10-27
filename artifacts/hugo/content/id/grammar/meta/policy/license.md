---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE adalah Meta kebijakan yang mencatat lisensi dokumen ini dan karya di dalam deretan byte."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat lisensi dokumen ini dan karya di dalam deretan byte.

## Layout

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length extension TAG]
Payload           Reference yang menunjuk lisensi, atau UTF8-TEXT berisi pengenal SPDX, atau Value URI
```

- Codec: Meta `0x50`, kelas kebijakan (`101`)
- Payload: Reference atau Value tersemat ([UTF8-TEXT](/id/grammar/value/text/utf8-text/), [URI](/id/grammar/value/text/uri/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Dokumen terbitan geul.org berlisensi CC0. Untuk publikasi privat, Issuer yang menentukan ([Issuer](/id/grammar/issuer/)).
- Mencatat lisensi asli dari karya sumber.

## Masalah terbuka

- Apakah pengenal SPDX ditaruh sebagai teks atau sebagai Reference ke entitas GEUL.
