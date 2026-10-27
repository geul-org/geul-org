---
title: "Meta — Struktur"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Kelas struktur Meta (3 bit atas `000`, `0x00`~`0x0F`) menetapkan batas dan panjang dokumen. Dibuka dengan DOC-1WORD/2WORD/4WORD, HEAD diakhiri dengan BODY, dan ditutup dengan END."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Kelas struktur Meta (3 bit atas `000`, Codec `0x00`~`0x0F`) menetapkan batas dan panjang dokumen. Satuan data GEUL adalah satu dokumen.

```
DOC-*                  ← awal HEAD
  Meta definisi·asal-usul·silsilah·verifikasi·kebijakan·IMPORT
  SOURCE untuk seluruh dokumen beserta QUALIFIER-nya
BODY                   ← awal BODY
  Reference, Value, Edge
END                    ← menutup dokumen
```

- Setiap dokumen dibuka dengan `DOC-1WORD/2WORD/4WORD` yang menetapkan panjang total. Dengan panjang ini, decoder dapat melompati seluruh dokumen sekaligus.
- `BODY` dan `END` adalah record 1 WORD tanpa Payload. `END` wajib.
- Dokumen tidak bersarang. Dokumen lain ditunjuk dengan IMPORT.
- Jika HEAD (Meta, SOURCE untuk seluruh dokumen beserta QUALIFIER-nya) kosong, `BODY` dihilangkan. `BODY` hanya boleh ada sekali per dokumen.

Struktur dokumen lengkap ada di [Dokumen](/id/grammar/document/).
