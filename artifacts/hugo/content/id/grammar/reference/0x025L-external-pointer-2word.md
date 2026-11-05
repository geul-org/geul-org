---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER adalah Reference penunjuk yang menunjuk LOCAL ID pada dokumen yang diimpor dengan IMPORT-DOC milik HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER adalah Reference penunjuk yang menunjuk LOCAL ID pada dokumen yang diimpor dengan IMPORT-DOC milik HEAD.

| Butir | Nilai |
|---|---|
| Nama | `EXTERNAL-POINTER-2WORD` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x025L~0x029L` |
| Bagian | 1 `0001` (Reference EXTERNAL), offset C dalam bagian = 5~9 |
| Kind | Reference · klasifikasi: penunjuk |
| Sisi Hugo | `reference/external-pointer.md` (halaman itu juga membahas [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) dan [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | nilai mentah 2 WORD |  |  |
| 2 | `target-id` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

EXTERNAL-POINTER adalah Reference penunjuk yang menunjuk LOCAL ID pada dokumen yang diimpor dengan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) milik HEAD.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (bagian 1)
[TAG ekstensi Length]
IMPORT ID         lebar yang ditetapkan Codec (1/2/4 WORD)
ID target         seluruh sisanya. LOCAL ID pada dokumen yang diimpor, lebar terpendek
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nama | Lebar IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- Lebar ditentukan oleh nomor sistem: jika sistem − 6 (`C / 5` dari offset `C` dalam bagian) bernilai 0, 1, 2, maka lebarnya 1, 2, 4 WORD. Kuantifikasi adalah `C % 5`.

- Gunakan Codec tersempit yang dapat memuat nilai IMPORT ID.
- IMPORT ID adalah nilai yang ditetapkan oleh `IMPORT-DOC` dokumen ini. Issuer tidak ditulis pada EXTERNAL-POINTER. Issuer dan ID dokumen diperoleh dari `IMPORT-DOC` itu. Versi juga ditentukan oleh `IMPORT-DOC` itu (tetap atau terbaru).
- LOCAL ID yang sama pada dokumen yang diimpor adalah target yang sama, baik ditulis sebagai LOCAL di dalam dokumen itu maupun sebagai EXTERNAL-POINTER di sini.
- Jika Variable, ia adalah variabel LOCAL dari dokumen yang diimpor.

## Validitas {#유효성}

- Jika tidak ada `IMPORT-DOC` yang menetapkan IMPORT ID itu pada dokumen ini, itu invalid.
- Jika IMPORT ID muat dalam Codec yang lebih sempit tetapi dipakai Codec yang lebih lebar, ditolak sebagai non-minimal.
- Jika ID target `0`, itu invalid. Dokumen yang diimpor itu sendiri ditunjuk dengan [DOC-POINTER](0x041L-doc-pointer.md).
- WORD `0x0000` di depan pada ID target dilarang.

## Contoh {#예시}

| Target | WORD sequence |
|---|---|
| LOCAL 5 pada IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 pada IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 pada IMPORT ID 70000 | `0253 0001 1170 0005` |

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000250/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Di atas adalah dokumen codec `EXTERNAL-POINTER-2WORD-IDENTIFIED` (`0x025L`). Dokumen codec anggota lain (`EXTERNAL-POINTER-2WORD-GENERIC`, `EXTERNAL-POINTER-2WORD-FREE-CHOICE`, `EXTERNAL-POINTER-2WORD-UNIVERSAL`, `EXTERNAL-POINTER-2WORD-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
