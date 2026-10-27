---
title: "SOURCE dan bagian"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Format ISSUER GEUL 0xC000~0xC005 yang menulis teks asli tulisan dokumen TOULMIN (SOURCE), string (TEXT), pembagian bagian·kasus (SECTION, CASE-BEGIN, CASE-END), dan paragraf uraian (PROSE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Record yang menulis teks asli dan pembagian dokumen TOULMIN. Semuanya adalah Edge yang memakai nomor format di bawah Issuer `0x0000` (GEUL) dengan `ISSUER-1WORD` (`0x7C`) ([TOULMIN](/id/grammar/edge/toulmin/#format-issuer)).

## Format

| Nomor format | Nama | Layout |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD lebar SPAN, Value UTF8 |
| `0xC001` | TEXT | ID, Value UTF8 |
| `0xC002` | SECTION | ID, kode bagian 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (kasus) |
| `0xC004` | CASE-END | ID, REF (kasus) |
| `0xC005` | PROSE | ID, SPAN |

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](/id/grammar/edge/toulmin/#field-umum)).
- Value UTF8 adalah record Value [UTF8-TEXT](/id/grammar/value/text/utf8-text/). Byte dimuat apa adanya.

## SOURCE

Seluruh teks asli tulisan. Semua SPAN adalah rentang byte di dalam teks asli ini.

```
ID
WORD lebar SPAN  2 bit atas = lebar (00=1, 01=2, 10=4, 11=8 WORD), 14 bit sisanya = 0
Teks asli        record Value UTF8-TEXT
```

- SOURCE adalah record pertama BODY. Satu per dokumen.
- SPAN terdiri dari dua field: byte awal dan jumlah byte. Setiap field adalah bilangan bulat tanpa tanda dengan lebar (1/2/4/8 WORD) yang ditetapkan WORD lebar SPAN.

## TEXT

Satu nama·string. Ditunjuk dengan REF oleh daftar F_WITH·F_GROUNDS pada NODE serta LABEL·IMPORTED-FROM pada LINK.

## SECTION

Awal bagian. Kode bagian adalah 1 WORD.

| Kode | Bagian | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | Aturan ekspresi kondisi |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` tidak dipakai. Bagian dideklarasikan menurut urutan kode ini.
- Judul bagian adalah PROSE tepat setelah SECTION.

## CASE-BEGIN, CASE-END

- Cakupan kasus adalah antara CASE-BEGIN dan CASE-END yang menunjuk kasus yang sama (NODE CASE-DECLARE).

## PROSE

Paragraf uraian yang bukan aturan. Hanya menunjuk rentang teks asli (SPAN).

## Halaman terkait

- [TOULMIN](/id/grammar/edge/toulmin/), [NODE](/id/grammar/edge/toulmin/node/), [LINK](/id/grammar/edge/toulmin/link/)
