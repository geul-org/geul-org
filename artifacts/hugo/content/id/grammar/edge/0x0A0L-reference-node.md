---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE adalah Edge pernyataan berarah yang menghubungkan satu Reference dengan satu record Object untuk mendefinisikan atau mengikat apa Reference itu."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `REFERENCE-NODE` (BIND dokumen spesifikasi `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A00/` (target DECLARE `0A00`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 0 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Binding berarah: Subject, yaitu Reference, menunjuk Object |
| Sisi Hugo | `edge/reference-node.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `060F` seluruh bagian 3 (wildcard, Value), `080F` seluruh bagian 4 (wildcard, Value) |  |

REFERENCE-NODE adalah Edge pernyataan berarah yang menghubungkan satu Reference dengan satu record Object untuk mendefinisikan atau mengikat apa Reference itu. Codec `0x0A0L`.

Subject menunjuk Object. Binding ini bukan [SAME-NODE](0x0A1L-same-node.md) yang mengklaim identitas semantik, dan tidak berarti byte kedua record sama.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference atau Value
```

## Interpretasi dan validitas {#해석과-유효성}

- Subject harus tepat satu record [Reference](../reference/_index.md) yang lengkap. Batasnya ditemukan dengan Length Subject sendiri; jika bukan Reference atau tidak lengkap, maka invalid.
- Object harus tepat satu record Reference atau Value yang lengkap. Batasnya ditemukan dengan Length Object sendiri; jika berupa Edge·Meta atau tidak lengkap, maka invalid.
- Jika Object adalah Reference, rantai Reference yang diikuti lewat binding REFERENCE-NODE tidak boleh berputar, dan LOCAL harus akhirnya terselesaikan. Putaran resolusi dan LOCAL yang menggantung (dangling) adalah invalid.
- Jika satu LOCAL ID dalam dokumen yang sama diikat pada Object yang saling bertentangan, maka invalid. Cakupan LOCAL, ID, lebar minimum, dan aturan penggabungan mengikuti [LOCAL](../reference/0x005L-local.md).
- Tidak semua Reference harus diikat dengan REFERENCE-NODE.
- Pemakaian utamanya adalah `LOCAL → UTF8-LANGUAGE-TEXT`. Jika LOCAL ditaruh pada Object [LABEL](0x0A4L-label.md), teksnya diselesaikan dengan binding ini dalam dokumen yang sama.

Arah Subject menunjuk Object tidak boleh ditafsirkan terbalik. Makna dan aturan rinci SAME dan DIFFERENT ditentukan oleh masing-masing bentuk.

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` adalah jumlah WORD Length extension TAG, `N_id` adalah jumlah WORD record LOCAL Edge Id, dan `N_subject`·`N_object` adalah jumlah WORD keseluruhan masing-masing record. Kursor setelah membaca Subject dan Object harus tepat sama dengan akhir Edge.

## Contoh (non-normatif) {#예시-비규범}

Edge Id `0008`, Subject adalah LOCAL 1, Object adalah [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) `Donald Trump` (en).

- Edge Id adalah `0051 0008`, 2 WORD.
- Subject adalah `0051 0001`, 2 WORD.
- Object terdiri dari bahasa `0761 656E` (BCP47 `en`) + teks 12 byte (genap), sehingga `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), total 9 WORD. TAG-nya `0788`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG-nya `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
