---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE adalah Edge pernyataan yang mendeklarasikan susunan Payload satu Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DECLARE` (BIND dokumen spesifikasi `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000BB0/` (target DECLARE `0BB0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 27 |
| Kind | Edge · keluarga: pernyataan, kelompok: lainnya |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi susunan Payload satu Codec. Kind·Codec sasaran |
| Sisi Hugo | `edge/declare.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | nilai mentah 1 WORD |  |  |
| 2 | `issuer` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

DECLARE adalah Edge pernyataan yang mendeklarasikan susunan Payload satu Codec. Codec `0x0BBL`.

Bersama [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`), dan [CODEC](0x0BEL-codec.md) (`0x0BEL`), ini adalah kosakata untuk menulis spesifikasi Codec ([dokumen spesifikasi Codec](../codec-spec.md)). Layout keempat Edge ini tertanam di decoder. Setiap dokumen spesifikasi Codec yang ditulis dengan kosakata ini adalah dokumen biasa. Satu spesifikasi dipakai bersama untuk verifikasi, penguraian, dan tampilan (viewer). Viewer tidak menaruh kode per Codec, melainkan menggambar sesuai spesifikasi.

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Sasaran           1 WORD. Dari TAG WORD Codec yang dideklarasikan hanya posisi Codec (bagian dan C) yang dipakai (LLLL = 0)
[Issuer·nomor Codec] Saat mendeklarasikan codec Issuer. Issuer dan nomor Codec 2 WORD. Layout sama dengan Codec extension TAG dan ketiga Kind sama
                  Dokumen spesifikasi kode ISSUER itu sendiri (GEUL Issuer) hanya memuat sasaran
```

- Daftar bidang tidak ditaruh di DECLARE. Setiap [FIELD](0x0BCL-field.md) menunjuk DECLARE-nya sendiri, dan urutan FIELD itu dalam dokumen adalah urutan bidang Payload.

## Aturan interpretasi {#해석-규칙}

Aturan untuk membaca dan menuliskan record dengan spesifikasi Codec.

- Bidang nilai mentah dibaca sebanyak jumlah WORD tetap yang dideklarasikan FIELD. Satu bidang boleh berupa sisa nilai mentah (lebar `0xFFFF`), yang dibaca sebanyak sisa WORD dikurangi lebar bidang tetap setelahnya. Setelah bidang sisa hanya boleh ada nilai mentah berlebar tetap.
- Bidang record dimulai dengan TAG WORD, dan dibaca sepanjang Length TAG itu.
- Bidang nilai mentah adalah bilangan bulat tak bertanda big-endian n WORD. Notasinya `0x` + hex sebanyak lebar×4 digit, dan jika ada ENUM untuk nilai yang sama, nama BIND-nya dicantumkan bersama.
- Makna bidang record ditentukan oleh spesifikasi Codec record itu. Nilai yang perlu ditafsirkan seperti tanda, pecahan, atau tanggal ditaruh sebagai record Value, bukan nilai mentah.

Tidak ada aturan batas lain. Codec yang punya dua atau lebih nilai mentah variabel, yang record atau bidang variabelnya datang setelah nilai mentah variabel, atau yang lebar nilai mentahnya berubah menurut nilai bidang lain atau keadaan dokumen, tidak dapat dideklarasikan dengan kosakata ini. Layout seperti itu membungkus bagian variabel dalam record sehingga hanya tersisa satu (contoh: penanda tangan SIGNATURE adalah record Reference).

## Validitas {#유효성}

- Kind sasaran adalah salah satu dari Reference, Value, Edge, Meta. Dokumen spesifikasi kode langsung GEUL ada satu per kode. Sistem 5Q Reference juga dideklarasikan terpisah per kode kuantifikasi (LOCAL Identified `0050`, Generic `0060`, …). Penunjuk (`0x040L`, `0x041L`, `0x042L`), penanda slot, dan kode ISSUER juga adalah kode itu sendiri. Codec Issuer yang ditentukan oleh Issuer·nomor Codec setelah kode ISSUER didefinisikan oleh dokumen Issuer tersebut.
- [Penanda slot](../slot-marker.md) (Reference `0x000L~0x002L`) juga sasaran DECLARE. Karena tidak punya Payload, hanya DECLARE yang ditaruh tanpa FIELD. Makna penanda dan aturan penerimaannya tertanam di decoder (lapisan 0). Codec yang layout-nya belum ditentukan (SUPERSEDE-CHAIN, VERDICT, EVIDENCE, dan lain-lain) juga hanya memuat DECLARE.
- Edge Id milik Edge tidak dideklarasikan sebagai FIELD. Karena merupakan elemen pertama semua Edge, ia implisit ([Edge](_index.md)). EDGE-ISSUER adalah elemen pertama setelah Issuer·nomor Codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Bidang DECLARE adalah FIELD yang menunjuknya, dan boleh 0. Satu FIELD hanya milik satu DECLARE. Meski bidang berbentuk sama, FIELD ditaruh terpisah untuk tiap DECLARE.
- DECLARE tidak memuat apa pun selain sasaran (dan Issuer·nomor Codec untuk sasaran bentuk Issuer).
- Kursor setelah membaca bidang secara berurutan harus tepat sama dengan akhir record. Jika berlebih atau kurang, record itu melanggar spesifikasi.
- Sasaran yang sama tidak dideklarasikan dua kali dalam satu dokumen.
- Varian dengan bidang ekor yang berbeda tidak dipakai sebagai percabangan. DECLARE ditaruh terpisah untuk tiap Codec.

## Dokumen spesifikasi {#규격-문서}

- Dokumen spesifikasi kode langsung adalah dokumen codec GEUL Issuer `0x00000000`. Codec ID adalah TAG WORD sasaran (L=0) yang ditulis dalam 32 bit (`0x0B80` → `0x00000B80`), dan dipublikasikan di `<Issuer>/codecs/<Codec ID>/` dengan ID versi dan `versions.geul` ([dokumen spesifikasi Codec](../codec-spec.md)).
- Dokumen codec dari codec Issuer ditaruh di `<Issuer>/codecs/<nomor Codec>/` Issuer tersebut. Nomor Codec tidak boleh bertabrakan di dalam Issuer itu, apa pun Kind-nya. Interpreter menganggap galat jika Kind record berbeda dengan Kind sasaran DECLARE ([alamat publikasi dan daftar versi](../publishing.md#id-표기)).
- Satu dokumen spesifikasi memuat satu DECLARE, dan sasarannya harus sama dengan TAG WORD Codec ID. `DOC-ID` adalah [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, Codec ID itu, `0`).

## Nama {#이름}

- Nama Codec diikat pada Edge Id DECLARE dengan [BIND](0x0A3L-bind.md) (contoh: `PUBLICATION`). UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC semuanya dengan BIND, tidak ditempelkan dengan Edge lain seperti LABEL.
- Nama bidang dan nama enum juga diikat pada FIELD·ENUM dengan cara yang sama.

## Contoh {#예시}

Dokumen spesifikasi `0x00000000/codecs/0x00000B80/` untuk PUBLICATION (Edge `0x0B8L`): setelah Edge Id ada record DOC-POINTER, lalu hash isi 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, record         (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (daftar versi codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, nilai mentah 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + sasaran 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + lebar 1 = 6 WORD (`LLLL = 0101`). Kind·Codec yang diterima ditaruh terpisah dengan [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- Bidang opsional dideklarasikan dengan sasaran CODEC `0000`. Posisi yang dihilangkan diisi ABSENT (`0x0000`) ([CODEC](0x0BEL-codec.md) bidang opsional).
- Urutan bidang adalah urutan FIELD #2, #4 ditaruh dalam dokumen. Edge Id tidak harus berurutan (LOCAL AUTO INCREMENT bersifat anjuran).

## Masalah terbuka {#열린-문제}

- Pengulangan. Susunan yang nilai mentah sebelumnya menentukan jumlah, seperti "argumen × jumlah argumen" pada `CALL`. Saat ini tidak dapat dideklarasikan.
- Cara mendeklarasikan Codec yang punya subbentuk (TAG per Codec), seperti WORLD.
- Versi dokumen spesifikasi kode langsung yang mana yang dimaksud oleh `SPEC-VERSION`.

## Halaman terkait {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [dokumen spesifikasi Codec](../codec-spec.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000BB0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
