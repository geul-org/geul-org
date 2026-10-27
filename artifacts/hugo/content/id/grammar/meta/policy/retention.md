---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION adalah Meta kebijakan yang mencatat batas retensi dokumen sebagai Value waktu kedaluwarsa atau durasi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat batas retensi dokumen.

## Layout

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length extension TAG]
Payload           waktu kedaluwarsa (GREGORIAN-DATE, dll.) atau durasi (DURATION-SECONDS)
```

- Codec: Meta `0x53`, kelas kebijakan (`101`)
- Payload: Value tersemat (keluarga TIME: [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/), dll., atau [DURATION-SECONDS](/id/grammar/value/time/duration-seconds/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Jika berupa durasi, dihitung mulai dari [RECORDED-AT](/id/grammar/meta/provenance/recorded-at/).
