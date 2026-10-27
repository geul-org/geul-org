---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS adalah Edge pernyataan yang menghubungkan satu nama lain (alias) target Subject (Codec 0x05). Layout sama dengan LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS adalah Edge pernyataan yang menghubungkan satu nama lain (alias) target Subject sebagai Object. Codec `0x05`.

[LABEL](/id/grammar/edge/label/) adalah nama utama pada bahasa itu (paling banyak satu per bahasa), sedangkan ALIAS adalah nama lain dari target yang sama (beberapa per bahasa, "also known as" di Wikidata). Terutama dipakai untuk pencarian. Layout dan validitasnya sama dengan LABEL.

## Layout

```
TAG WORD          0001 0LLL L000 0101
[Length extension TAG]
Edge Id           1 record LOCAL Reference
Subject           1 record Reference
Object            Value UTF8-LANGUAGE-TEXT atau 1 record LOCAL Reference
```

## Interpretasi dan validitas

- Aturan Subject dan Object sama dengan [LABEL](/id/grammar/edge/label/) (Object adalah [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/) atau LOCAL yang menunjuk ke sana).
- Beberapa ALIAS boleh ditaruh pada Subject dan bahasa yang sama. Urutannya adalah urutan dalam dokumen.
- Teks yang sama dengan LABEL pada Subject dan bahasa yang sama tidak ditaruh sebagai ALIAS (nama utama cukup dengan satu LABEL). Aturan ini adalah anjuran.
- Dokumen spesifikasi geul.org membatasi Object dengan [CODEC](/id/grammar/edge/codec/) (`084A`·`084B`·`0008`, sama dengan LABEL).

## Contoh (non-normatif)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): record bahasa `08C6 656e` (BCP47 `en`) + teks 3 byte (ganjil) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG adalah `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [LABEL](/id/grammar/edge/label/), [DESCRIPTION](/id/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/)
