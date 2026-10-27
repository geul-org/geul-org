---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD adalah Edge pernyataan yang mendeklarasikan satu field Payload Codec (Codec 0x1C). Menulis DECLARE tempatnya berada dan lebar (record, nilai mentah n WORD, nilai mentah sisa)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD adalah Edge pernyataan yang mendeklarasikan satu field Payload Codec. Codec `0x1C`.

FIELD menunjuk [DECLARE](/id/grammar/edge/declare/)-nya sendiri. FIELD-FIELD yang menunjuk satu DECLARE menyusun Payload menurut urutan dalam dokumen. Layoutnya ditanamkan di decoder ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1100
Edge Id           record LOCAL Reference
DECLARE           record LOCAL Reference. Edge DECLARE tempat field ini berada
Lebar             1 WORD. 0 = record, n (1~65534) = nilai mentah n WORD, 0xFFFF = nilai mentah sisa
```

## Interpretasi dan validitas

- DECLARE menunjuk Edge DECLARE dalam dokumen yang sama. Satu FIELD hanya milik satu DECLARE. Urutan tidak ditulis terpisah, melainkan urutan record FIELD ditaruh di dokumen.
- Dokumen spesifikasi FIELD mendeklarasikan DECLARE sebagai field berlebar `0` (record) dengan CODEC `0008` (LOCAL). Karena itu pada graf viewer ia digambar sebagai sambungan FIELD → DECLARE.
- Lebar `0` adalah field record. Dimulai dengan TAG WORD dan dibaca sebanyak Length TAG itu (aturan interpretasi [DECLARE](/id/grammar/edge/declare/)).
- Lebar `n` (1~65534) adalah field nilai mentah. Selalu tepat n WORD.
- Lebar `0xFFFF` adalah nilai mentah sisa. Hanya satu per DECLARE dan boleh di depan, tengah, atau akhir. Lebarnya adalah WORD tersisa yang ditetapkan Length TAG record luar dikurangi lebar field di belakangnya. Karena itu semua field setelah field sisa harus berupa nilai mentah berlebar tetap (record hanya dapat diketahui ujungnya jika dibaca dari depan). Boleh 0 WORD. ENUM tidak ditempelkan.
- Kind·Codec yang diterima field ditetapkan dengan [CODEC](/id/grammar/edge/codec/). Field record menerima record apa saja jika tidak ada CODEC, dan jika ada harus salah satunya. Jika satu CODEC ditaruh pada field nilai mentah, nilai mentah itu diinterpretasikan sebagai Value tersebut tanpa TAG.
- Nama field diikat pada Edge Id FIELD dengan [BIND](/id/grammar/edge/bind/) (contoh: `doc`, `hash`). Semua UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC memakai BIND, dan tidak ditempelkan dengan Edge lain seperti LABEL.
- Makna nilai kode field nilai mentah ditempelkan dengan [ENUM](/id/grammar/edge/enum/).
- Field yang menunjuk node lain pada graf tidak ditandai terpisah. Jika field record adalah Reference, itulah sambungannya.

## Panjang

```
Total = 1 + 2 + 2 + 1 WORD   (jika Edge Id·DECLARE adalah ID LOCAL 1 WORD)
```

## Contoh (non-normatif)

- Field record: Edge Id 7, DECLARE #1, lebar `0`. TAG 1 + Edge Id 2 + DECLARE 2 + lebar 1 = 6 WORD. Untuk menerima hanya LOCAL, lihat contoh [CODEC](/id/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- Untuk field nilai mentah seperti hash isi, lihat contoh [DECLARE](/id/grammar/edge/declare/).

## Halaman terkait

- [DECLARE](/id/grammar/edge/declare/), [ENUM](/id/grammar/edge/enum/), [CODEC](/id/grammar/edge/codec/), [BIND](/id/grammar/edge/bind/)
- [Dokumen spesifikasi Codec](/id/grammar/codec-spec/)
