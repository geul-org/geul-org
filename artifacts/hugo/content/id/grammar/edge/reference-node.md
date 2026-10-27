---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE adalah Edge pernyataan berarah yang mengikat satu Reference pada satu record Object untuk mendefinisikan apa Reference itu (Codec 0x00)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE adalah Edge pernyataan berarah yang menghubungkan satu Reference ke satu record Object untuk mendefinisikan atau mengikat apa Reference itu. Codec `0x00`.

Subject menunjuk Object. Pengikatan ini bukan [SAME-NODE](/id/grammar/edge/same-node/) yang mengklaim identitas semantik, dan tidak berarti byte kedua record sama.

## Layout

```
TAG WORD          0001 0LLL L000 0000
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference atau Value
```

## Interpretasi dan validitas

- Subject harus tepat satu record [Reference](/id/grammar/reference/) yang lengkap. Batasnya ditemukan dengan Length Subject itu sendiri, dan jika bukan Reference atau tidak lengkap, invalid.
- Object harus tepat satu record Reference atau Value yang lengkap. Batasnya ditemukan dengan Length Object itu sendiri, dan jika berupa Edge·Meta atau tidak lengkap, invalid.
- Jika Object adalah Reference, rantai Reference yang diikuti melalui pengikatan REFERENCE-NODE tidak boleh melingkar dan LOCAL harus akhirnya terselesaikan. Lingkaran penyelesaian dan LOCAL yang menggantung (dangling) adalah invalid.
- Jika satu LOCAL ID dalam satu dokumen diikat pada Object yang saling bertentangan, invalid. Cakupan LOCAL, ID, lebar minimum, dan aturan penggabungan mengikuti [LOCAL](/id/grammar/reference/local/).
- Tidak semua Reference harus diikat dengan REFERENCE-NODE.
- Pemakaian utama adalah `LOCAL → UTF8-LANGUAGE-TEXT`. Jika LOCAL ditaruh pada Object [LABEL](/id/grammar/edge/label/), teks diselesaikan dengan pengikatan ini dalam dokumen yang sama.

Arah Subject menunjuk Object tidak boleh diinterpretasikan terbalik. Makna dan aturan rinci SAME dan DIFFERENT ditetapkan terpisah oleh masing-masing format.

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` adalah jumlah WORD Length extension TAG, `N_id` adalah jumlah WORD record LOCAL Edge Id, dan `N_subject`·`N_object` adalah jumlah WORD total setiap record. Kursor setelah membaca Subject dan Object harus tepat sama dengan akhir Edge.

## Contoh (non-normatif)

Edge Id `0008`, Subject adalah LOCAL 1, Object adalah [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/) `Donald Trump` (en).

- Edge Id adalah `0088 0008`, 2 WORD.
- Subject adalah `0088 0001`, 2 WORD.
- Object adalah record bahasa `08C6 656e` (BCP47 `en`) + teks 12 byte (genap) sehingga `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), total 9 WORD. TAG adalah `0C4A`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG adalah `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [SAME-NODE](/id/grammar/edge/same-node/), [DIFFERENT-NODE](/id/grammar/edge/different-node/), [LABEL](/id/grammar/edge/label/)
- [Reference](/id/grammar/reference/), [LOCAL](/id/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/)
