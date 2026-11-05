---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER adalah Reference penunjuk-deklarasi yang mengutip LOCAL ID pada dokumen yang dipublikasikan Issuer dengan satu record, tanpa IMPORT."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER adalah Reference penunjuk-deklarasi yang mengutip LOCAL ID pada dokumen yang dipublikasikan Issuer dengan satu record, tanpa IMPORT.

| Butir | Nilai |
|---|---|
| Nama | `EXTERNAL-ISSUER-2WORD` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x02FL~0x033L` |
| Bagian | 1 `0001` (Reference EXTERNAL), offset C dalam bagian = 15~19 |
| Kind | Reference · klasifikasi: penunjuk-deklarasi |
| Sisi Hugo | `reference/external-issuer.md` (halaman itu juga membahas [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md) dan [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | nilai mentah 2 WORD |  |  |
| 2 | `doc` | #3 | nilai mentah 4 WORD |  |  |
| 3 | `target-id` | #4 | sisa nilai mentah (`0xFFFF`) |  |  |

EXTERNAL-ISSUER adalah Reference penunjuk-deklarasi yang mengutip LOCAL ID pada dokumen yang dipublikasikan Issuer tanpa IMPORT. Maknanya lengkap dengan satu record dan mengikuti versi terbaru.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (bagian 1)
[TAG ekstensi Length]
Issuer            lebar yang ditetapkan Codec (2/4/16 WORD)
ID dokumen        4 WORD
ID target         seluruh sisanya. LOCAL ID pada dokumen itu, lebar terpendek
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nama | Lebar Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (terdaftar di geul.org, bukti domain) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (terdaftar di geul.org, tanpa bukti) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (dihitung dari kunci publik) |

- Lebar ditentukan oleh nomor sistem: jika sistem − 9 (`C / 5 − 3` dari offset `C` dalam bagian) bernilai 0, 1, 2, maka lebarnya 2, 4, 16 WORD. Kuantifikasi adalah `C % 5`.
- ID Issuer adalah nilai bilangan bulat. Nilai yang sama berarti Issuer yang sama. Issuer ditulis dengan lebar terpendek yang dapat memuat nilainya, dan Codec dengan lebar itu yang dipilih (4 WORD hanya jika `2^32` atau lebih, 16 WORD hanya jika `2^64` atau lebih). Notasi dengan lebar yang lebih besar adalah invalid ([Issuer](../issuer.md)).
- Pendaftaran dan pengelolaan Issuer ditangani geul.org.
- Versi tidak ditulis dan mengikuti versi terbaru. Untuk mengunci versi, gunakan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) dan [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- Lokasi ditemukan dengan aturan alamat publikasi ([alamat publikasi dan daftar versi](../publishing.md)).
- LOCAL ID yang sama pada dokumen itu adalah target yang sama, baik ditulis sebagai LOCAL di dalam dokumen itu, sebagai EXTERNAL-ISSUER di dokumen lain (maupun sebagai EXTERNAL-POINTER setelah IMPORT).
- Hanya menunjuk LOCAL dari dokumen. Dokumen itu sendiri ditunjuk dengan [DOC-POINTER](0x041L-doc-pointer.md), dan Issuer itu sendiri dengan [ISSUER-POINTER](0x040L-issuer-pointer.md). Karena itu ID target bukan `0`. ID dokumen `0` adalah dokumen indeks definisi istilah Issuer.

## Validitas {#유효성}

- Jika lebar Issuer tidak sesuai dengan Codec, atau nilainya muat dalam lebar yang lebih sempit, itu invalid.
- Jika ID target `0`, itu invalid. ID target `0` (dokumen itu sendiri) ditangani DOC-POINTER.
- WORD `0x0000` di depan pada ID target dilarang.

## Contoh {#예시}

| Target | WORD sequence |
|---|---|
| Issuer `0x00000002`, dokumen `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, dokumen `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000002F0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Di atas adalah dokumen codec `EXTERNAL-ISSUER-2WORD-IDENTIFIED` (`0x02FL`). Dokumen codec anggota lain (`EXTERNAL-ISSUER-2WORD-GENERIC`, `EXTERNAL-ISSUER-2WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-2WORD-UNIVERSAL`, `EXTERNAL-ISSUER-2WORD-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
