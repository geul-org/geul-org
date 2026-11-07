---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference adalah record yang menunjuk target."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference adalah record yang menunjuk target. Targetnya dapat berupa entitas, konsep, dokumen, atau Edge lain. Ia menunjuk dengan ID, bukan dengan nama.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      bagian 0~2 (0x000L~0x05FL)
[TAG ekstensi Length]
[IMPORT ID]       jika EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          jika EXTERNAL-ISSUER (2/4/16 WORD)
[ID dokumen]      jika EXTERNAL-ISSUER (4 WORD)
ID target         seluruh sisanya
```

- `LLLL` adalah jumlah total WORD termasuk TAG WORD dikurangi 1 ([record dan TAG WORD](../record.md)).
- Reference berjumlah 96 slot pada bagian 0~2 (`w < 0x0600`). Bagian 0 entitas `0x000L~0x01FL`, bagian 1 EXTERNAL `0x020L~0x03FL`, bagian 2 lainnya `0x040L~0x05FL`.
- Codec ditulis sebagai tabel kode (tabel di bawah). Pada sistem 5Q, satu kode memuat sistem identifikasi dan kuantifikasi sekaligus. Kuantifikasi REFERENCE-ISSUER ditetapkan dokumen Issuer.
- ID target adalah bilangan bulat tak bertanda big-endian dan ditulis dengan **lebar terpendek**. Lebarnya adalah sisa Length setelah dikurangi field-field sebelumnya.
- ID target `0` ditulis sebagai 1 WORD `0x0000`. Selain itu, WORD `0x0000` tidak ditambahkan di depan.
- Nilai bilangan bulat yang sama adalah ID yang sama. Lebar bukan bagian dari ID.
- Semua Codec memakai lebar terpendek. Codec tidak mengunci lebar ID target.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md), [CODEC-POINTER](0x042L-codec-pointer.md) tidak mengikuti layout ini. Mereka tidak punya ID target dan hanya memuat Issuer (serta ID dokumen·Codec ID·ID versi).
- [REFERENCE-ISSUER](#reference-issuer) juga tidak mengikuti layout ini. Isinya TAG, Issuer, nomor Codec 2 WORD, dan Payload. Payload ditetapkan dokumen Codec yang diterbitkan Issuer.

## Codec {#codec}

| TAG ID | Nama | Klasifikasi | Target |
|---|---|---|---|
| `0x000L~0x002L` | [Penanda slot](../slot-marker.md) | penanda slot | Tidak menunjuk target. Hanya memakai penanda 1 WORD: `0x0000` ABSENT (tidak ditulis), `0x0010` UNKNOWN-VALUE (tidak diketahui), `0x0020` NO-VALUE (tidak ada) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | deklarasi | ID yang diterbitkan dokumen ini |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | deklarasi | Entitas yang diterbitkan geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | deklarasi | Pengenal selaras-makna yang memuat makna pada bit |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | deklarasi | Item Wikidata. Bilangan bulat setelah `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | deklarasi | Properti Wikidata. Bilangan bulat setelah `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | penunjuk | LOCAL ID pada dokumen yang diimpor dengan IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | penunjuk-deklarasi | LOCAL ID pada dokumen yang dipublikasikan Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | penunjuk-deklarasi | Issuer itu sendiri |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | penunjuk-deklarasi | Satu versi dokumen yang dipublikasikan Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | penunjuk-deklarasi | Satu versi codec yang dipublikasikan Issuer |
| `0x043L~0x044L` | [TOKEN-0·TOKEN-1](0x043L-token.md) | deklarasi | Satu entri kosakata token GEUL. ID token 1 WORD, total 2 WORD |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | format Issuer | Didefinisikan Issuer. Klasifikasi dan slot ID target ditetapkan dokumen Issuer |

- Reserved adalah `0x003L~0x004L`, `0x01EL~0x01FL` (bagian 0), `0x03EL~0x03FL` (bagian 1), `0x045L~0x05CL` (bagian 2, ruang untuk sistem identifikasi baru).
- Nomor sistem dibaca dari offset dalam bagian `C`. Pada bagian 0, jika `5 <= C < 30`, sistemnya `C / 5` (1~5); pada bagian 1, jika `C < 30`, sistemnya `6 + C / 5` (6~11).

| Sistem | Nama | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **Deklarasi** mengidentifikasi target secara langsung dengan ID yang ditetapkan pihak penerbit.
- **Penunjuk** menunjuk LOCAL di dalam dokumen yang diimpor dengan IMPORT ID. Lebar IMPORT ID ditentukan oleh sistem: jika sistem − 6 bernilai 0, 1, 2, maka lebarnya 1, 2, 4 WORD.
- **Penunjuk-deklarasi** menunjuk dokumen lain dan target di dalamnya dengan satu record tanpa IMPORT. Lebar Issuer pada EXTERNAL-ISSUER adalah 2, 4, 16 WORD jika sistem − 9 bernilai 0, 1, 2.
- `0x020L~0x03DL` (bagian 1, sistem 6~11) menunjuk LOCAL dokumen lain. Sistem deklarasi selain itu mengidentifikasi target secara langsung (LOCAL dokumen ini, ID terbitan). Penunjuk (bagian 2, `0x040L~0x042L`) menunjuk Issuer·dokumen·codec itu sendiri. REFERENCE-ISSUER berada di luar pembagian ini.
- `0x000L~0x002L` adalah kode yang ditetapkan untuk penanda slot dan tidak dipakai sebagai Reference yang menunjuk target. WORD `0x0000`, `0x0010`, `0x0020` (L 0, 1 WORD) adalah [penanda slot](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). Penanda hanya berlaku pada posisi field record yang menjadikan WORD itu target CODEC secara tepat. Wildcard dan field tanpa CODEC tidak menerimanya, dan pada posisi record HEAD·BODY serta posisi Edge Id ia invalid. Bentuk TAG dengan Payload pada C 0~2 (L ≥ 1) adalah Reserved.
- Hanya kode langsung dan hasil publikasi yang disediakan geul.org yang CC0. Sistem identifikasi non-CC0 (WordNet, dsb.) tidak dijadikan kode langsung. Lisensi format Issuer ditetapkan oleh Issuer itu.

### TAG yang sering dipakai {#자주-쓰는-tag}

| Record | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (manusia) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instans dari) | `0191 001F` |
| Penanda slot ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL adalah ID yang diterbitkan dokumen ini.

- **Unik.** Dalam satu dokumen, satu LOCAL ID hanya menunjuk satu target.
- **0 tidak ditetapkan.** ID target ditetapkan mulai dari 1.
- **Dianjurkan ditetapkan secara bertambah** (auto increment). Besar kecilnya ID tidak bermakna.
- Menunjuk target yang sama lintas versi. ID yang dihapus tidak dipakai lagi (revisi [dokumen](../document.md)).
- Agar dapat ditunjuk dari luar dokumen, dokumen harus memiliki `DOC-ID`.
- LOCAL ID yang berbeda tidak berarti target di dunia nyata berbeda. Jika sama, sambungkan dengan Edge `SAME-NODE`; jika berbeda, dengan Edge `DIFFERENT-NODE`.

### Edge Id {#edge-id}

Setiap Edge menaruh Reference LOCAL sebagai elemen pertama Payload. LOCAL ID itu adalah **Edge Id**.

- Edge Id dapat dibaca tanpa mengetahui codebook.
- LOCAL pada posisi Edge Id adalah deklarasi, dan LOCAL pada posisi lain Edge adalah penyebutan.
- LOCAL yang mendeklarasikan Edge Id hanya memakai Identified (`0x005L`).
- Edge lain ditunjuk dengan Edge Id. Edge dokumen ini ditunjuk dengan LOCAL, dan Edge dokumen lain dengan Reference penunjuk.

## Menunjuk dokumen lain {#다른-문서-가리키기}

| Apa | Bagaimana |
|---|---|
| Issuer itu sendiri | `ISSUER-POINTER` (Issuer) |
| Satu versi dokumen | `DOC-POINTER` (Issuer, ID dokumen 4 WORD, ID versi 2 WORD). Versi `0` adalah yang terbaru |
| Satu versi codec | `CODEC-POINTER` (Issuer, Codec ID 2 WORD, ID versi 2 WORD). Versi `0` adalah yang terbaru |
| Target di dalam dokumen yang dipublikasikan (terbaru) | `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, LOCAL ID) |
| Target di dalam dokumen yang diimpor (edisi terkunci) | Tetapkan IMPORT ID dengan Meta `IMPORT-DOC`, lalu `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Dokumen itu sendiri, baik dari dalam maupun dari luar dokumen, hanya ditunjuk dengan satu DOC-POINTER. Dirinya sendiri adalah DOC-POINTER dari `DOC-ID`-nya sendiri. Dokumen codec adalah pengecualian dan ditunjuk dengan CODEC-POINTER (`DOC-ID` pun CODEC-POINTER).
- EXTERNAL-ISSUER mengikuti versi terbaru. Untuk mengunci edisi, gunakan IMPORT.
- Issuer ditulis dengan lebar terpendek yang dapat memuat nilainya (2/4/16 WORD), dan Codec yang sesuai dengan lebar itu yang dipilih. Sama pada EXTERNAL-ISSUER dan REFERENCE-ISSUER.
- ID dokumen `0` setiap Issuer dicadangkan sebagai dokumen indeks istilah yang didefinisikan Issuer itu (alat, peran, dsb.). Dokumen indeks dianjurkan untuk semua Issuer dan tidak wajib ([Issuer dan publikasi](../issuer.md#용어-정의-문서)).

Contoh: LOCAL 7 di dalam dokumen `0x0000000000000002` milik Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Nama | Makna | Contoh |
|---|---|---|---|
| `0` | Identified | Individu yang teridentifikasi | Elon Musk, Korea Selatan |
| `1` | Generic | Pernyataan umum tentang seluruh jenis. Mengizinkan pengecualian | Prajurit mematuhi perintah |
| `2` | Free-choice | Target sembarang yang memenuhi syarat | Prajurit mana pun |
| `3` | Universal | Semua target dalam lingkup | Semua prajurit |
| `4` | Variable | Variabel wacana | orang itu, perempuan ini |

- **Kuantifikasi hanya dibaca pada sistem 5Q (sistem 1~11).** Dengan offset dalam bagian `C`, kuantifikasinya `C % 5` jika bagian 0 `5 <= C < 30` dan bagian 1 `C < 30`. Karena satu bagian berisi 32 slot, membagi slot Codec 9 bit (`w >> 4`) dengan 5 akan menggeser bagian 1. Penanda (bagian 0, `C < 3`) dan bagian 2 (penunjuk, REFERENCE-ISSUER) tidak memiliki kuantifikasi. Penanda `0x0010` UNKNOWN-VALUE bukan Generic. Kuantifikasi REFERENCE-ISSUER ditetapkan dokumen Codec yang diterbitkan Issuer.
- Generic, berbeda dari Universal, tidak berarti berlaku tanpa pengecualian pada setiap target individual. Ungkapan definisional seperti `apa itu prajurit` dapat ditulis sebagai Generic. Jika diperlukan definisi konsep·klasifikasi yang ketat, konkretkan dengan relasi tersendiri.
- Cakupan dan negasi kuantifikasi ditetapkan oleh Edge yang memakainya, bukan oleh Reference.
- **Variable** adalah target dalam wacana yang jenisnya diketahui tetapi belum teridentifikasi.
  - Variabel bernama dibuat dengan melekatkan Variable pada LOCAL. LOCAL ID yang sama adalah variabel yang sama. Jenisnya dihubungkan dengan Edge.
  - Variabel anonim dibuat dengan melekatkan Variable pada Codec deklarasi yang menunjuk jenis (GEUL, WIKIDATA-*) (misalnya "presiden" Wikidata + Variable). Ko-referensi tidak dilacak dan tidak dapat ditunjuk lagi. Variabel anonim tidak dianggap sebagai variabel yang sama satu sama lain.
  - Jika target kemudian dipastikan, hubungkan variabel itu dengan target tersebut melalui `SAME-NODE`. Semua ungkapan yang menunjuk variabel yang sama diinterpretasikan bersama sebagai target itu.
  - Meskipun variabelnya berbeda, tidak berarti target sebenarnya berbeda. Jika sama, hubungkan dengan `SAME-NODE`; jika berbeda, dengan `DIFFERENT-NODE`.
  - Variable pada Codec penunjuk eksternal (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) adalah variabel LOCAL dari dokumen yang ditunjuk.
  - Contoh: pada `Presiden berpidato`, jika orangnya belum dipastikan, gunakan Variable 'presiden'. Untuk menyebutnya lagi, taruh LOCAL Variable dan hubungkan jenis 'presiden' dengan Edge. Jika kemudian dipastikan Obama, hubungkan variabel itu dengan Obama Identified melalui `SAME-NODE`. Semua ungkapan yang menunjuk variabel yang sama diinterpretasikan bersama sebagai Obama.
- Contoh: jika Q5 (manusia) Wikidata dipakai sebagai Generic, hasilnya `0151 0005` ("manusia adalah …").

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER adalah format Reference yang didefinisikan Issuer. Ia adalah tiga slot terakhir wilayah Reference. Layout-nya sama dengan ISSUER pada Value·Edge ([record dan TAG WORD](../record.md#issuer-형식-레코드)).

### Layout {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = lebar Issuer: 01 2, 10 4, 11 16 WORD)
[TAG ekstensi Length]
Issuer            2/4/16 WORD (Codec menetapkan lebar)
Nomor Codec       2 WORD. Didefinisikan Issuer
Payload           Ditetapkan dokumen Codec yang diterbitkan Issuer
```

| Codec | Nama | Lebar Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Setiap kode memiliki halaman: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- Dokumen codec Issuer GEUL ada satu per kode dan memiliki tiga FIELD: Issuer (2·4·16 WORD), nomor Codec (2 WORD), Payload (ditetapkan codec Issuer).

### Interpretasi dan validitas {#해석과-유효성}

- GEUL hanya mengetahui batas Payload melalui Length. Payload tidak diinterpretasikan tanpa codebook.
- Makna dan kuantifikasi nomor Codec ditetapkan Issuer. Apa yang ditunjuk juga ditetapkan dokumen Codec yang diterbitkan Issuer.
- Aturan umum Reference tidak berlaku: lebar terpendek ID target, penulisan 1 WORD untuk ID target `0`, Quantifier, pembacaan kuantifikasi·sistem dari offset dalam bagian, klasifikasi deklarasi·penunjuk, dan target yang ditunjuk.
- Nomor Codec 2 WORD sama dengan ISSUER pada Value·Edge. Jika nomor tidak cukup, ajukan penerbitan satu Issuer lagi.
- Decoder yang tidak mengetahui formatnya mengetahui sampai Kind, Length, Issuer, dan nomor Codec, lalu melompatinya dengan Length.
- Lisensi format Issuer ditetapkan oleh Issuer itu ([Issuer dan publikasi](../issuer.md#라이선스)).

### Halaman terkait {#관련-페이지}

- [Record dan TAG WORD](../record.md), [Issuer dan publikasi](../issuer.md)
