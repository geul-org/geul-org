---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY adalah Meta asal-usul yang mencatat pelaku perekam sebagai dokumen dalam Reference (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat pelaku yang merekam sebagai dokumen (git committer).

## Layout

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length extension TAG]
Payload           satu record Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, dll.)
```

- Codec: Meta `0x24`, kelas asal-usul (`010`)
- Payload: Reference tersemat
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Reference tidak membatasi Codec. Bisa manusia, organisasi, model, atau mesin aturan ([EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/), [GEUL](/id/grammar/reference/geul/), [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/), [LOCAL](/id/grammar/reference/local/), dll.).
- Dokumen terbitan geul.org tidak menaruh Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](/id/grammar/issuer/#publikasi-geulorg)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) diizinkan.
- Jika LOCAL, target itu dijelaskan di BODY.
