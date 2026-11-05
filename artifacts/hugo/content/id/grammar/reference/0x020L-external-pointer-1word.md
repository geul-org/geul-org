---
title: "EXTERNAL-POINTER-1WORD (0x020L~0x024L)"
weight: 32
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
| Nama | `EXTERNAL-POINTER-1WORD` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x020L~0x024L` |
| Bagian | 1 `0001` (Reference EXTERNAL), offset C dalam bagian = 0~4 |
| Kind | Reference · klasifikasi: penunjuk |
| Sisi Hugo | `reference/external-pointer.md` (halaman itu juga membahas [EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md) dan [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x020L` | `EXTERNAL-POINTER-1WORD-IDENTIFIED` | Identified | `0x00000200` | `0x00000000/codecs/0x00000200/` | `0000 0010 0000 LLLL` |
| `0x021L` | `EXTERNAL-POINTER-1WORD-GENERIC` | Generic | `0x00000210` | `0x00000000/codecs/0x00000210/` | `0000 0010 0001 LLLL` |
| `0x022L` | `EXTERNAL-POINTER-1WORD-FREE-CHOICE` | Free-choice | `0x00000220` | `0x00000000/codecs/0x00000220/` | `0000 0010 0010 LLLL` |
| `0x023L` | `EXTERNAL-POINTER-1WORD-UNIVERSAL` | Universal | `0x00000230` | `0x00000000/codecs/0x00000230/` | `0000 0010 0011 LLLL` |
| `0x024L` | `EXTERNAL-POINTER-1WORD-VARIABLE` | Variable | `0x00000240` | `0x00000000/codecs/0x00000240/` | `0000 0010 0100 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | nilai mentah 1 WORD |  |  |
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

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000200/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000020000000000
BODY
#1 DECLARE 0x0200
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-1WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Di atas adalah dokumen codec `EXTERNAL-POINTER-1WORD-IDENTIFIED` (`0x020L`). Dokumen codec anggota lain (`EXTERNAL-POINTER-1WORD-GENERIC`, `EXTERNAL-POINTER-1WORD-FREE-CHOICE`, `EXTERNAL-POINTER-1WORD-UNIVERSAL`, `EXTERNAL-POINTER-1WORD-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
