---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Mengimpor dokumen eksternal dengan IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `IMPORT-DOC` (BIND `IMPORT-DOC` pada dokumen spesifikasi) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001E40/` (target DECLARE `1E40`) |
| Bagian | 15 `1111` (Meta), offset C dalam bagian = 4 |
| Kind | Meta · kelas: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Mengimpor dokumen eksternal dengan IMPORT ID. Reference bawaan `DOC-POINTER` (`CODEC-POINTER` untuk dokumen Codec) + IMPORT ID |
| Sisi Hugo | `meta/import/import-doc.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

Mengimpor dokumen eksternal dengan IMPORT ID. Dokumen yang diimpor ditunjuk oleh [DOC-POINTER](../reference/0x041L-doc-pointer.md), dan lebar Issuer juga dimuat oleh DOC-POINTER.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[TAG ekstensi Length]
dokumen           record Reference DOC-POINTER (Issuer, ID dokumen, ID versi. Versi 0 berarti terbaru). Dokumen Codec: CODEC-POINTER
IMPORT ID         seluruh sisanya. unsigned dengan lebar tersempit
```

- Codec: Meta `0x1E4L`, kelas IMPORT
- Payload: Reference bawaan `DOC-POINTER` (Issuer, ID dokumen, ID versi) + nilai mentah IMPORT ID
- Jumlah: dapat lebih dari satu (satu per IMPORT ID)

## Interpretasi dan validitas {#해석과-유효성}

- Dokumen adalah tepat satu record DOC-POINTER. Saat mengimpor dokumen Codec, berupa record [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID versi). Record itu berakhir dengan Length-nya sendiri, dan sisanya adalah IMPORT ID.
- IMPORT ID selebar 1 WORD atau lebih, dengan lebar tersempit. Lebar IMPORT ID di sini ditentukan oleh panjang record, sedangkan pada [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) ditentukan oleh Codec.
- IMPORT ID yang sama tidak dialokasikan dua kali dalam satu dokumen.
- Jika ID versi dicantumkan, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru pada saat interpretasi (atau edisi yang berlaku pada titik waktu yang ditentukan) ([revisi](../document.md#개정)).
- [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) di BODY menunjuk LOCAL dari dokumen yang diimpor dengan IMPORT ID. Dokumen yang diimpor itu sendiri ditunjuk dengan DOC-POINTER.
- HEAD dari dokumen yang diimpor tidak ikut diimpor. Sasaran dokumen itu ditafsirkan sesuai deklarasi dokumen itu.
- Pencarian lintas dokumen tidak dapat dilakukan dengan IMPORT ID. Penyimpanan yang memuat banyak dokumen menyimpan IMPORT ID dengan menguraikannya menjadi jalur lengkap (Issuer, ID dokumen, ID versi, ID LOCAL).

## Contoh {#예시}

- IMPORT ID 1, Issuer `0x00000002`, dokumen `0x…0002`, terbaru: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001E40/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
