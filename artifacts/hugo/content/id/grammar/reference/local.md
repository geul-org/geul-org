---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL adalah Reference deklarasi yang menunjuk target dengan ID yang diterbitkan dokumen ini. Edge Id juga LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL adalah Reference deklarasi yang menunjuk target dengan ID yang diterbitkan dokumen ini. Ia merujuk target di dalam dokumen tanpa Issuer eksternal dan tidak bermakna di luar dokumen. Untuk menunjuk dari luar dokumen, taruh Meta [DOC-ID](/id/grammar/meta/declaration/doc-id/) pada dokumen, lalu dokumen lain menunjuknya dengan Reference penunjuk.

## Layout

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length extension TAG]
LOCAL ID          unsigned big-endian dengan lebar terpendek
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- TAG WORD adalah `0000 0 LLLL 0001 QQQ`. Untuk Identified (`000`), 7 bit bawahnya adalah `0x08`.
- Mengikuti aturan umum Reference yang menulis ID target dengan jumlah WORD terkecil.

## Edge Id

- LOCAL sebagai elemen pertama Payload Edge adalah deklarasi Edge Id Edge itu ([Edge](/id/grammar/edge/)). Quantifier LOCAL yang mendeklarasikan Edge Id hanya `000`.
- LOCAL pada posisi lain di Payload Edge adalah penyebutan. Target dokumen ini ditulis dengan LOCAL setiap kali disebut. Tidak ada kode penunjuk tersendiri untuk menunjuk target dokumen ini.

## Alokasi pengenal

- ID adalah bilangan bulat dan dialokasikan oleh encoder. Besar angka dan urutan alokasi tidak bermakna selain identitas.
- **UNIQUE (wajib).** Dalam satu dokumen, satu LOCAL ID hanya menunjuk satu target. Edge Id dideklarasikan hanya sekali per dokumen (Edge HEAD dan Edge BODY berbagi satu ruang nomor). Jika ada dua Edge atau lebih yang mendeklarasikan Edge Id yang sama, dokumen invalid.
- **AUTO INCREMENT (anjuran).** ID baru dialokasikan sebagai nilai maksimum ID yang sudah dialokasikan di dokumen itu + 1, dan bertambah menurut urutan dokumen. Berlaku juga lintas versi (dibuat baru dengan nilai lebih besar dari ID yang sudah dihapus). Ini hanya anjuran, bukan syarat validitas, dan dokumen yang tidak bertambah tetap valid. Decoder tidak bergantung pada besar atau kesinambungan ID.
- ID `0` tidak dialokasikan. Ia tidak menunjuk target apa pun dan tidak dipakai sebagai Edge Id. ID target dialokasikan mulai dari `1`.
- Dokumen, baik dari dalam maupun dari luar dokumen, hanya ditunjuk dengan satu [DOC-POINTER](/id/grammar/reference/doc-pointer/) (dokumen menunjuk dirinya dengan DOC-POINTER dari `DOC-ID`-nya sendiri). `BIND`, `LABEL`, dan Edge putusan juga dapat ditempelkan pada dokumen.
- Issuer itu sendiri ditunjuk dengan [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/). ID dokumen `0` adalah dokumen indeks definisi istilah Issuer.
- Codec yang memberi makna pada `0` di posisi komponen ("tidak ada" pada REF·Edge eksekusi [TOULMIN](/id/grammar/edge/toulmin/), "seluruh dokumen" pada Target [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) HEAD) mengikuti aturan Codec itu. Ini adalah ketentuan di dalam Codec tersebut, berbeda dari [penanda slot](/id/grammar/reference/slot-marker/).
- ID yang pernah dialokasikan tidak dipakai ulang dalam dokumen yang sama.
- Selalu pakai lebar minimum yang dapat menyatakan nilainya.

## Identitas dan cakupan

- Dalam satu dokumen, jika nilai bilangan bulat LOCAL ID sama, targetnya sama. Lebar encoding bukan bagian dari identitas.
- LOCAL Identified menyatakan target yang teridentifikasi. Ia tidak dipakai sebagai anonim·tak ditentukan·null·sentinel. Pernyataan bahwa nilai ada tetapi tidak diketahui (UNKNOWN-VALUE) atau tidak ada nilai (NO-VALUE) ditulis sebagai [penanda slot](/id/grammar/reference/slot-marker/) pada field yang menerima penanda itu.
- LOCAL ID yang berbeda hanyalah Reference yang berbeda, bukan berarti targetnya di dunia nyata juga berbeda.
- Identitas LOCAL tidak diperluas ke luar dokumen. Angka yang sama di dokumen lain tidak berkaitan.
- LOCAL Variable (`100`) adalah variabel wacana bernama ([Reference](/id/grammar/reference/) Variable).

## Penggabungan

Saat menggabungkan beberapa dokumen menjadi satu, buat tabel padanan `old ID → new ID` untuk setiap dokumen asal, alokasikan ulang semua LOCAL ID dengan ID dokumen baru, dan ubah semua referensi.

- ID yang sama di dokumen asal yang sama harus tetap sama setelah penggabungan.
- Angka yang sama di dokumen asal yang berbeda tidak berkaitan dan tidak otomatis digabung menjadi Reference yang sama.
- Jika ada satu saja LOCAL yang tidak dapat diubah, penggabungan ditolak.

## Validitas

Encoding atau alokasi berikut invalid.

- Encoding non-minimal dengan WORD `0x0000` di depan (pengecualian: 1 WORD `0x0000` untuk nilai 0)
- Quantifier pada posisi deklarasi Edge Id bukan `000`, atau ID-nya `0`
- Satu ID dialokasikan tumpang tindih ke target yang berbeda dalam dokumen yang sama
- Edge Id yang sama dideklarasikan dua kali atau lebih dalam dokumen yang sama

## Contoh

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [DOC-POINTER](/id/grammar/reference/doc-pointer/), [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/id/grammar/reference/external-pointer/)
- [Edge](/id/grammar/edge/)
