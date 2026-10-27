---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD, dan DOC-4WORD adalah Meta struktur yang membuka dokumen dengan menetapkan jumlah WORD total dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Record yang membuka dokumen. Jumlah WORD total dokumen ditetapkan pada Payload. `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`), dan `DOC-4WORD` (`0x02`) dibahas bersama di halaman ini.

## Layout

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length extension TAG]
Payload           jumlah WORD total. Codec menentukan lebarnya: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, kelas struktur (`000`)
- Payload: nilai mentah (jumlah WORD total dokumen, unsigned)
- Jumlah: satu per dokumen, di paling depan

## Interpretasi dan validitas

- Panjang dihitung dari awal record pembuka sampai akhir [END](/id/grammar/meta/structure/end/).
- Pakai lebar tersempit yang dapat memuat nilai. Encoding dengan lebar yang lebih lebar ditolak sebagai encoding non-kanonik.
- Panjang harus sama dengan seluruh input. Satu dokumen adalah satu input.
- Decoder dapat melompati seluruh dokumen dengan panjang ini. Tidak ada Codec pembuka yang tidak mengetahui panjangnya.
- Saat menghitung hash isi, panjang ditulis ulang tanpa Meta kelas verifikasi, dengan lebar yang sesuai ([hash isi](/id/grammar/document/#hash-isi)).

## Contoh

- `0x1880 0x0017`: DOC-1WORD, total 23 WORD
