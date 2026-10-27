---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF adalah Meta verifikasi yang mencatat konfirmasi hak kontribusi sebagai Reference (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Konfirmasi hak kontribusi (git `Signed-off-by`, DCO).

## Layout

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length extension TAG]
Payload           satu Reference
```

- Codec: Meta `0x42`, kelas verifikasi (`100`)
- Payload: Reference tersemat
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Dokumen terbitan geul.org tidak menaruh Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](/id/grammar/issuer/#publikasi-geulorg)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) diizinkan.
