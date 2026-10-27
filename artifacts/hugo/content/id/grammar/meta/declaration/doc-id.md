---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID adalah Meta definisi yang menyatakan pengenal dokumen dengan DOC-POINTER (Issuer, ID dokumen, versi 0) yang menunjuk dokumen itu sendiri."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan pengenal dokumen ini. Diperlukan agar dokumen lain dapat menunjuk dokumen ini dan target di dalamnya.

## Layout

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length extension TAG]
Dokumen           record Reference DOC-POINTER. (Issuer, ID dokumen, versi 0)
```

- Codec: Meta `0x12`, kelas definisi (`001`)
- Payload: satu Reference [DOC-POINTER](/id/grammar/reference/doc-pointer/) tersemat (Issuer, ID dokumen, versi 0)
- Jumlah: paling banyak satu. Wajib untuk dokumen yang namanya diawali `0x`

## Interpretasi dan validitas

- Payload adalah tepat satu record Reference `DOC-POINTER` (Issuer, ID dokumen, versi `0`). ID versi hanya memakai `0`. Versi dialokasikan oleh daftar versi, bukan oleh dokumen. Quantifier adalah `000`.
- Karena itu notasi yang menunjuk "dokumen ini" sama pada DOC-ID, Subject [BIND](/id/grammar/edge/bind/) di `documents.geul`, dan kutipan dari dokumen lain.
- Dokumen yang sama selalu memiliki `DOC-ID` yang sama terlepas dari versi. ID versi dan hash isi tidak ditulis di dokumen ([versi](/id/grammar/document/#versi)).
- Nama untuk alamat ditangani oleh pernyataan `BIND` di indeks nama `documents.geul` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)), dan judul yang dibaca manusia ditangani oleh pernyataan [LABEL](/id/grammar/edge/label/).
- Jika tidak ada, itu dokumen tanpa nama dan hanya dapat ditunjuk dengan hash isi. Diperlukan agar dokumen lain dapat menunjuk LOCAL dokumen ini dengan Reference penunjuk.
- Pihak yang mengimpor dokumen memverifikasi bahwa `DOC-ID` dokumen yang diterima sama dengan Issuer dan ID dokumen yang diminta.
- ID dokumen `0x0000000000000000` adalah dokumen indeks definisi istilah Issuer ([Issuer](/id/grammar/issuer/)). Karena namanya juga diawali `0x`, dokumen ini menaruh DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). Issuer itu sendiri diwakili oleh [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/).
- Dokumen yang namanya diawali `0x` di bawah `.well-known/geul/` (dokumen versi `<ID versi>.geul`, dokumen spesifikasi) wajib memiliki `DOC-ID`.
- Dokumen yang namanya tidak diawali `0x` dikecualikan dan tidak menaruh `DOC-ID`: daftar versi `versions.geul` ([PUBLICATION](/id/grammar/edge/publication/)), indeks nama dokumen `documents.geul`, dan indeks nama Issuer `issuers.geul` ([alamat publikasi dan daftar versi](/id/grammar/publishing/)). Penyimpanan hash isi `h/` adalah salinan dokumen di atas sehingga mengikuti aslinya.
- Dokumen spesifikasi Codec adalah dokumen Issuer GEUL `0x0000`. ID dokumennya adalah nilai TAG WORD Kind·Codec yang diperpanjang menjadi 4 WORD (`0x1018` → `0x0000000000001018`). Reference `0000` dicadangkan sehingga tidak pernah menjadi ID dokumen `0` ([dokumen spesifikasi](/id/grammar/codec-spec/)).

## Contoh

- Issuer `0x0001`, dokumen `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG Meta 1 + TAG Reference 1 + Issuer 1 + ID dokumen 4 + versi 2 = 9 WORD)
