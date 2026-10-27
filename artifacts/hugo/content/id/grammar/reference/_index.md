---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference adalah record yang menunjuk target. Codec 4 bit menentukan sistem identifikasi (LOCAL, Wikidata, dokumen eksternal, dan lain-lain), Quantifier 3 bit menentukan kuantifikasi (teridentifikasi, generik, universal, variabel, dan lain-lain). Codec cadangan 0000 adalah kelompok penanda slot."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference adalah record yang menunjuk target. Target dapat berupa entitas, konsep, dokumen, atau Edge lain. Target ditunjuk dengan ID, bukan dengan nama.

## Layout

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length extension TAG]
[IMPORT ID]       jika EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          jika EXTERNAL-ISSUER (1/2/4/16 WORD)
[ID dokumen]      jika EXTERNAL-ISSUER (4 WORD)
ID target         seluruh sisanya
```

- `LLLL` adalah jumlah WORD total termasuk TAG WORD dikurangi 1 ([Record dan TAG WORD](/id/grammar/record/)).
- Codec adalah 4 bit `CCCC`, Quantifier adalah 3 bit `QQQ`. 7 bit bawah TAG WORD adalah `CCCC << 3 | QQQ`.
- ID target adalah bilangan bulat tanpa tanda big-endian dan ditulis dengan **lebar terpendek**. Lebarnya adalah sisa Length setelah dikurangi field-field di depannya.
- ID target `0` ditulis sebagai 1 WORD `0x0000`. Selain itu, WORD `0x0000` tidak ditambahkan di depan.
- Jika nilai bilangan bulatnya sama, ID-nya sama. Lebar bukan bagian dari ID.
- Semua Codec memakai lebar terpendek. Codec tidak mengunci lebar ID target.
- [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/) dan [DOC-POINTER](/id/grammar/reference/doc-pointer/) tidak mengikuti layout ini. Keduanya tidak memiliki ID target dan hanya berisi Issuer (serta ID dokumen dan ID versi).

## Codec (`CCCC`)

| CCCC | Nama | Kategori | Target |
|---|---|---|---|
| `0000` | [Penanda slot](/id/grammar/reference/slot-marker/) | Cadangan | Tidak menunjuk target. Hanya penanda 1 WORD yang 3 bit bawahnya adalah nomor penanda: `0x0000` ABSENT (tidak ditulis), `0x0001` UNKNOWN-VALUE (tidak diketahui), `0x0002` NO-VALUE (tidak ada) |
| `0001` | [LOCAL](/id/grammar/reference/local/) | Deklarasi | ID yang diterbitkan dokumen ini |
| `0010` | [GEUL](/id/grammar/reference/geul/) | Deklarasi | Entitas yang diterbitkan geul.org |
| `0011` | [GEUL-SIDX](/id/grammar/reference/geul-sidx/) | Deklarasi | Pengenal terurut semantik yang bitnya memuat makna |
| `0100` | [WIKIDATA-QID](/id/grammar/reference/wikidata-qid/) | Deklarasi | Item Wikidata. Bilangan bulat setelah `Q` |
| `0101` | [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/) | Deklarasi | Properti Wikidata. Bilangan bulat setelah `P` |
| `0110` | [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/) | Penunjuk-deklarasi | Issuer itu sendiri |
| `0111` | [DOC-POINTER](/id/grammar/reference/doc-pointer/) | Penunjuk-deklarasi | Satu versi dokumen yang diterbitkan Issuer |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/id/grammar/reference/external-pointer/) | Penunjuk | LOCAL ID dalam dokumen yang diimpor dengan IMPORT |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/id/grammar/reference/external-issuer/) | Penunjuk-deklarasi | LOCAL ID dalam dokumen yang diterbitkan Issuer |

- **Deklarasi** mengidentifikasi target secara langsung dengan ID yang ditetapkan penerbit.
- **Penunjuk** menunjuk LOCAL di dalam dokumen yang diimpor dengan IMPORT ID. 2 bit bawah adalah lebar IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- **Penunjuk-deklarasi** menunjuk dokumen lain dan target di dalamnya dengan satu record, tanpa IMPORT.
- Jika bit teratas `0`, target diidentifikasi langsung (LOCAL dokumen ini, ID terbitan, Issuer atau dokumen itu sendiri); jika `1`, record menunjuk LOCAL di dokumen lain.
- Codec `0000` adalah cadangan dan tidak dipakai sebagai Reference yang menunjuk target. Satu-satunya pengecualian adalah satu kelompok: WORD `0x0000`~`0x0007` (Codec `0000`, 1 WORD) adalah [penanda slot](/id/grammar/reference/slot-marker/). Saat ini tiga yang dipakai (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). Penanda hanya valid pada posisi field record yang menaruh WORD itu persis sebagai target CODEC. Wildcard dan field tanpa CODEC tidak menerimanya, dan pada posisi record HEAD·BODY serta posisi Edge Id penanda invalid. `0x0003`~`0x0007` dan Codec `0000` yang memiliki Payload adalah cadangan.
- Sistem identifikasi non-CC0 (WordNet dan sejenisnya) tidak dijadikan Codec Reference. Reference juga tidak memiliki kode ISSUER, sehingga tidak ada tempat untuk memindahkannya ke format Issuer.

### TAG yang sering dipakai

| Record | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Wikidata Q5 (manusia) | `00A0 0005` |
| Wikidata Q691283 | `0120 000a 8c53` |
| Wikidata P31 (instance of) | `00A8 001f` |
| Penanda slot ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL adalah ID yang diterbitkan dokumen ini. Maknanya hanya ada di dalam dokumen.

- **Unik.** Dalam satu dokumen, satu LOCAL ID hanya menunjuk satu target.
- **0 tidak dialokasikan.** ID target dialokasikan mulai dari 1.
- **Dianjurkan dialokasikan secara bertambah** (auto increment). Besar kecilnya ID tidak bermakna.
- Menunjuk target yang sama lintas versi. ID yang sudah dihapus tidak dipakai lagi (revisi [Dokumen](/id/grammar/document/)).
- Agar dapat ditunjuk dari luar dokumen, dokumen harus memiliki `DOC-ID`.
- LOCAL ID yang berbeda tidak berarti target yang berbeda di dunia nyata. Jika sama, hubungkan dengan Edge `SAME-NODE`; jika berbeda, dengan `DIFFERENT-NODE`.

### Edge Id

Setiap Edge menaruh LOCAL Reference sebagai elemen pertama Payload. LOCAL ID itu adalah **Edge Id**.

- Edge Id dapat dibaca tanpa mengetahui codebook.
- LOCAL pada posisi Edge Id adalah deklarasi, sedangkan LOCAL pada posisi lain di Edge adalah penyebutan.
- Quantifier LOCAL yang mendeklarasikan Edge Id hanya `000`.
- Edge lain ditunjuk dengan Edge Id. Edge dokumen ini ditunjuk dengan LOCAL, Edge dokumen lain dengan Reference penunjuk.

## Menunjuk dokumen lain

| Apa | Bagaimana |
|---|---|
| Issuer itu sendiri | `ISSUER-POINTER` (Issuer) |
| Satu versi dokumen | `DOC-POINTER` (Issuer, ID dokumen 4 WORD, ID versi 2 WORD). Versi `0` adalah yang terbaru |
| Target di dalam dokumen terbitan (terbaru) | `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, LOCAL ID) |
| Target di dalam dokumen yang diimpor (edisi dikunci) | Alokasikan IMPORT ID dengan Meta `IMPORT-DOC`, lalu `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Dokumen itu sendiri, baik dari dalam maupun dari luar dokumen, hanya ditunjuk dengan satu DOC-POINTER. Dokumen menunjuk dirinya dengan DOC-POINTER dari `DOC-ID`-nya sendiri.
- EXTERNAL-ISSUER mengikuti versi terbaru. Untuk mengunci edisi, pakai IMPORT.
- Issuer ditulis dengan lebar terpendek tempat nilainya muat (1/2/4/16 WORD), dan Codec dipilih sesuai lebar itu.
- ID dokumen `0` setiap Issuer dicadangkan untuk dokumen indeks istilah (alat, peran, dan sebagainya) yang didefinisikan Issuer itu. Dokumen indeks dianjurkan untuk semua Issuer, tetapi tidak wajib ([Issuer dan publikasi](/id/grammar/issuer/#dokumen-definisi-istilah)).

Contoh: LOCAL 7 di dalam dokumen `0x0000000000000002` milik Issuer `0x0001`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Nama | Arti | Contoh |
|---|---|---|---|
| `000` | Identified | Individu yang teridentifikasi | Elon Musk, Korea Selatan |
| `001` | Generic | Pernyataan umum tentang seluruh jenis. Mengizinkan pengecualian | Prajurit mematuhi perintah |
| `010` | Free-choice | Target apa saja yang memenuhi syarat | Prajurit mana pun |
| `011` | Universal | Semua target dalam cakupan | Semua prajurit |
| `100` | Variable | Variabel wacana | orang itu, perempuan ini |
| `101`~`111` | Cadangan | | |

- **Pengecualian: pada Codec `0000` (penanda slot), 3 bit bawah bukan Quantifier melainkan nomor penanda.** Nomor penanda dan arti Quantifier tidak berkaitan (`0x0001` UNKNOWN-VALUE bukan Generic). Quantifier pada tabel ini hanya berlaku untuk Codec `0001`~`1111`.
- Generic, tidak seperti Universal, tidak berarti berlaku tanpa pengecualian pada setiap target individual. Ungkapan definisional seperti `apa itu prajurit` dapat memakai Generic. Jika diperlukan definisi konsep atau klasifikasi yang ketat, konkretkan dengan relasi tersendiri.
- Cakupan penerapan dan negasi kuantifikasi ditentukan oleh Edge yang memakainya, bukan oleh Reference.
- **Variable** adalah target dalam wacana yang jenisnya diketahui tetapi belum teridentifikasi.
  - Variabel bernama diberi Variable pada LOCAL. LOCAL ID yang sama adalah variabel yang sama. Jenisnya dihubungkan dengan Edge.
  - Variabel anonim memberi Variable pada Codec deklarasi yang menunjuk jenis (GEUL, WIKIDATA-*), misalnya "presiden" Wikidata + Variable. Koreferensi tidak dilacak dan tidak dapat ditunjuk lagi. Variabel anonim tidak dianggap sebagai variabel yang sama satu sama lain.
  - Jika target kemudian terkonfirmasi, hubungkan variabel itu dengan target tersebut memakai `SAME-NODE`. Semua ungkapan yang menunjuk variabel yang sama ikut diinterpretasikan sebagai target itu.
  - Variabel yang berbeda tidak berarti target sebenarnya berbeda. Jika sama, hubungkan dengan `SAME-NODE`; jika berbeda, dengan `DIFFERENT-NODE`.
  - Variabel hanya valid di dalam dokumennya dan tidak dipakai sebagai pengenal permanen.
  - Variable pada Codec penunjuk eksternal (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) adalah variabel LOCAL pada dokumen yang ditunjuk.
  - Contoh: pada `Presiden berpidato`, jika orangnya belum pasti, pakai Variable "presiden". Untuk menyebutnya lagi, taruh LOCAL Variable dan hubungkan jenis "presiden" dengan Edge. Jika kemudian terkonfirmasi sebagai Obama, hubungkan variabel itu dengan Obama Identified memakai `SAME-NODE`. Semua ungkapan yang menunjuk variabel yang sama ikut diinterpretasikan sebagai Obama.
- Contoh: jika Wikidata Q5 (manusia) dipakai sebagai Generic, hasilnya `00A1 0005` ("manusia itu ...").
