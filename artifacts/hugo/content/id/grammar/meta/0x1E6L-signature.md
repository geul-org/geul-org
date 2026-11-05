---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Tanda tangan atas hash isi dokumen (commit dan tag bertanda tangan pada git)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SIGNATURE` (BIND `SIGNATURE` pada dokumen spesifikasi) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E60/` (target DECLARE `1E60`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 6 |
| Kind | Meta · kelas: verifikasi |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Tanda tangan atas sasaran. Tanda tangan atas dokumen menandatangani hash isi (commit dan tag bertanda tangan pada git) |
| Sisi Hugo | `meta/verification/signature.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | nilai mentah 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | record | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | sisa nilai mentah (`0xFFFF`) |  |  |

Tanda tangan atas hash isi dokumen (commit dan tag bertanda tangan pada git).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[TAG ekstensi Length]
ID algoritma      1 WORD (0x0001 = Ed25519)
penanda tangan    record Reference ISSUER-POINTER (Issuer)
tanda tangan      seluruh sisanya. Lebarnya ditentukan algoritma (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`, kelas verifikasi
- Payload: ID algoritma (nilai mentah 1 WORD) + penanda tangan (Reference bawaan) + tanda tangan (nilai mentah, sisanya)
- Jumlah: dapat lebih dari satu

## Interpretasi dan validitas {#해석과-유효성}

- Sasaran tanda tangan adalah hash isi. BODY saja tidak ditandatangani ([tanda tangan](../issuer.md#서명)).
- Karena kelas verifikasi, dikeluarkan dari hash isi. Menambahkan tanda tangan tidak mengubah hash.
- Verifikasinya bukan "periksa jika ada tanda tangan", melainkan "harus ada tanda tangan dari kunci yang ditentukan".
- Dokumen daftar versi ditandatangani oleh pihak penerbit.
- Penanda tangan adalah [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) yang menunjuk Issuer itu sendiri. Karena record Reference berakhir dengan Length-nya sendiri, tata letaknya tetap satu meskipun lebar tanda tangan berbeda per algoritma ([DECLARE](../edge/0x0BBL-declare.md) bidang sisa).
- Jika jumlah WORD tanda tangan berbeda dari lebar yang ditentukan algoritma, tidak valid.

## Masalah terbuka {#열린-문제}

- Apakah waktu penandatanganan ikut ditandatangani.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E60/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
