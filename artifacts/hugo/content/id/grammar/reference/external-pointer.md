---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER adalah Reference penunjuk yang menunjuk LOCAL ID dalam dokumen yang diimpor dengan IMPORT-DOC di HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER adalah Reference penunjuk yang menunjuk LOCAL ID dalam dokumen yang diimpor dengan [IMPORT-DOC](/id/grammar/meta/import/import-doc/) di HEAD.

## Layout

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length extension TAG]
IMPORT ID         lebar yang ditetapkan WW (00=1, 01=2, 10=4, 11=8 WORD)
ID target         seluruh sisanya. LOCAL ID dokumen yang diimpor, lebar terpendek
```

| CCCC | Nama | Lebar IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Pakai Codec tersempit tempat nilai IMPORT ID muat.
- IMPORT ID adalah nilai yang dialokasikan `IMPORT-DOC` dokumen ini dan hanya valid di dalam dokumen ini. Issuer tidak ditulis pada EXTERNAL-POINTER. Issuer dan ID dokumen diperoleh dari `IMPORT-DOC` itu. Versi juga ditetapkan `IMPORT-DOC` itu (dikunci atau terbaru).
- Jika LOCAL ID dokumen yang diimpor sama, targetnya sama, baik dipakai sebagai LOCAL di dalam dokumen itu maupun sebagai EXTERNAL-POINTER di sini.
- Jika Variable, itu adalah variabel LOCAL pada dokumen yang diimpor.

## Validitas

- Jika tidak ada `IMPORT-DOC` yang mengalokasikan IMPORT ID itu di dokumen ini, record invalid.
- Jika IMPORT ID muat pada Codec yang lebih sempit tetapi dipakai Codec yang lebih lebar, record ditolak sebagai non-minimal.
- Jika ID target `0`, record invalid. Dokumen yang diimpor itu sendiri ditunjuk dengan [DOC-POINTER](/id/grammar/reference/doc-pointer/).
- WORD `0x0000` di depan ID target dilarang.

## Contoh

| Target | WORD sequence |
|---|---|
| LOCAL 5 pada IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 pada IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 pada IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [LOCAL](/id/grammar/reference/local/), [EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/), [DOC-POINTER](/id/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/id/grammar/meta/import/import-doc/)
