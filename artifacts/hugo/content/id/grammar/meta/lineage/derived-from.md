---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM adalah Meta silsilah yang mencatat dokumen atau materi dari silsilah lain tempat dokumen ini diturunkan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat bahwa dokumen ini diturunkan dari dokumen atau materi pada silsilah lain.

## Layout

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length extension TAG]
Payload           Reference, atau SHA-256-DIGEST (hash isi), atau Value URI
```

- Codec: Meta `0x31`, kelas silsilah (`011`)
- Payload: Reference atau Value tersemat
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Jika diturunkan dari dokumen GEUL, taruh hash isinya ([SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/)); jika dari materi eksternal, taruh [URI](/id/grammar/value/text/uri/). Untuk mengunci edisi materi eksternal dengan hash, tempelkan QUALIFIER hash teks asli (P4092) pada [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) di HEAD.
- Sumber pada tingkat record ditangani oleh Edge dasar [SOURCE](/id/grammar/edge/source/), dan record lama sebelum dipindah, dipecah, atau digabung ditangani oleh QUALIFIER P1365 pada Edge target (nilainya Edge Id lama).
