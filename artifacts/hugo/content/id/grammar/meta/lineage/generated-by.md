---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY adalah Meta silsilah yang mencatat pelaku pembuat dokumen (manusia, model, mesin aturan) beserta versinya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat pelaku yang membuat dokumen. Bisa manusia, model, atau mesin aturan.

## Layout

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length extension TAG]
Pelaku pembuat    Reference (manusia, model, mesin aturan)
Versi             Value UTF8-TEXT, atau penanda pelepasan 0x0000 (field opsional)
```

- Codec: Meta `0x32`, kelas silsilah (`011`)
- Payload: Reference tersemat + teks versi (opsional)
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Jika pelakunya model, versi model dicatat bersamanya.
- Jika versi tidak diketahui atau tidak ditaruh, hilangkan tempat itu dan tulis ABSENT (`0x0000`) ([CODEC](/id/grammar/edge/codec/) field opsional). Spesifikasi geul.org `0x1832` adalah field dua record: agent (tanpa CODEC) dan version (`0840`·`0841`·`0000`).
- Versi sumber program (commit) lebih tepat dicatat dengan format [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/) (digest, wajib). Versi pada GENERATED-BY mencatat sebagai teks hal yang bukan ID commit, seperti nama dan versi model.
- Dokumen terbitan geul.org tidak menaruh Reference yang menunjuk orang perseorangan ([Issuer dan publikasi](/id/grammar/issuer/#publikasi-geulorg)). Yang ditunjuk adalah organisasi atau Issuer. Sebagai pengecualian, menunjuk orang perseorangan dengan [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) diizinkan.
