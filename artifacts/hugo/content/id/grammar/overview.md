---
title: "Ikhtisar"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 adalah rangkaian record yang terdiri dari kata 16-bit. Record ada empat jenis: Reference, Value, Edge, dan Meta, dan record dimuat dalam satu dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) adalah bahasa buatan sekaligus format biner agar manusia dan AI saling bertukar informasi tanpa ambiguitas. Dokumen ini mendefinisikan tata bahasa GEUL v1.

## Sekilas

- Semua data adalah rangkaian **kata 16-bit (WORD)**. Ditulis dalam big-endian.
- Satuan data adalah **record**. Record dimulai dengan satu TAG WORD, dan TAG WORD itu menyatakan jenis dan panjang record.
- Record ada empat jenis (**Kind**).

| Kind | Fungsi | Contoh |
|---|---|---|
| Reference | Menunjuk target | Wikidata Q42, #7 di dalam dokumen ini |
| Value | Memuat nilai itu sendiri | Tanggal, kuantitas, teks dengan bahasa |
| Edge | Mengikat record lain untuk menyatakan sesuatu | "Q42 adalah manusia", "Nama Inggris Q42 adalah Douglas Adams" |
| Meta | Berbicara tentang dokumen | Edisi spesifikasi, ID dokumen, penulis, tanda tangan |

- Record dimuat dalam satu **dokumen**. Seperti HTML, dokumen terbagi atas HEAD (Meta, serta SOURCE sumber seluruh dokumen dan QUALIFIER-nya) dan BODY (Reference·Value·Edge).
- Dokumen diterbitkan oleh **Issuer** (penerbit), dan setiap versi dikunci dengan hash isi. Versi yang sudah diterbitkan tidak diubah.

## Prinsip desain

1. **Dapat dilompati tanpa codebook.** Jenis dan panjang record ada di TAG WORD 16 bit. Decoder yang tidak mengetahui cara interpretasi (codebook) pun dapat menghitung dan melompati record.
2. **Memuat pernyataan, bukan fakta.** Dokumen mencatat dengan Meta dan Edge dasar siapa, kapan, dan dari apa sebuah pernyataan berasal.
3. **Identifikasi dengan Reference.** Menunjuk dengan ID, bukan nama. Nama ditempelkan dengan Edge.
4. **Yang sudah diterbitkan tidak diubah.** Perbaikan dikeluarkan sebagai versi baru. ID di dalam dokumen menunjuk target yang sama lintas versi.
5. **Dibiarkan kosong.** Sebagian besar ruang bit disisakan untuk masa depan. Kode langsung tidak dapat ditarik kembali sehingga hanya yang frekuensinya sudah terkonfirmasi yang dialokasikan.

## Struktur area

Bit atas TAG WORD membagi area.

| Prefix | Area | Proporsi | Definisi |
|---|---|---|---|
| `1` | Masa depan jauh | 50% | Cadangan untuk masa depan jauh. Tidak dipakai |
| `01` | Masa depan | 25% | Cadangan untuk masa depan dekat. Tidak dipakai |
| `001` | Standar | 12.5% | Tata bahasa yang diadopsi secara resmi dan dioperasikan |
| `000` | Bebas·usulan | 12.5% | Tata bahasa saat ini. Jika diadopsi, layout dibiarkan dan hanya Prefix dipindah ke `001` |

Tata bahasa saat ini seluruhnya berada di area `000`. Semua TAG WORD spesifikasi ini diawali `000`.

- Decoder v1 menolak TAG WORD yang Prefix-nya bukan `000`. Area lain ditetapkan oleh edisi berikutnya.
- Area `000` adalah ruang usulan. Saat ini pendaftaran dan perlindungan belum berlaku. Namun layout format Issuer dicadangkan dengan prasyarat sistem pendaftaran setelah standar resmi diluncurkan.

## Yang dapat diketahui tanpa codebook

| Informasi | Tanpa codebook | Dasar |
|---|---|---|
| Kind | Tahu | TAG WORD |
| Panjang total record, posisi record berikutnya | Tahu | Length pada TAG WORD |
| Nomor Codec | Tahu | TAG WORD (jika format Issuer, Issuer dan nomor format pada extension TAG) |
| Keluarga·kelas | Tahu | Bit atas nomor Codec atau nomor format |
| Edge Id sebuah Edge | Tahu | Komponen pertama Edge selalu LOCAL Reference |
| Penanda slot (tidak ditulis·tidak diketahui·tidak ada) | Tahu | Nilai WORD `0`~`7` (Codec Reference `0000`, 1 WORD). [Penanda slot](/id/grammar/reference/slot-marker/) |
| Panjang TAG per Codec, posisi awal Payload | Tidak tahu | Codebook |
| Interpretasi Payload, peran komponen Edge | Tidak tahu | Codebook |

- Decoder tanpa codebook dapat melompati record dan menghitung per Kind dan Codec, tetapi tidak dapat mengikuti struktur graf.
- Semua decoder harus menangani kelas struktur·definisi·IMPORT Meta. Codec ini termasuk dalam codebook inti GEUL ([Meta](/id/grammar/meta/)).

Codebook diterbitkan sebagai dokumen GEUL ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)). Karena itu decoder cukup menerima dan membaca dokumen spesifikasi yang diperlukan.

## Dokumen turunan

| Dokumen | Isi |
|---|---|
| [Record dan TAG WORD](/id/grammar/record/) | Layout TAG WORD, Length, Codec, extension TAG |
| [Dokumen](/id/grammar/document/) | DOC·HEAD·BODY·END, ID dokumen, hash isi, versi dan revisi |
| [Reference](/id/grammar/reference/) | Identifikasi target, LOCAL, referensi eksternal, Quantifier, penanda slot |
| [Value](/id/grammar/value/) | Keluarga nilai, kode langsung, teks·kuantitas·tanggal |
| [Edge](/id/grammar/edge/) | Keluarga pernyataan·dasar·eksekusi·TOULMIN, TRIPLE·QUALIFIER·LABEL |
| [Meta](/id/grammar/meta/) | Struktur·definisi·asal-usul·silsilah·verifikasi·kebijakan·IMPORT |
| [Issuer dan publikasi](/id/grammar/issuer/) | Tingkat Issuer, tabel alokasi 1 WORD, cara publikasi, tanda tangan, kunci verifikasi |
| [Alamat publikasi dan daftar versi](/id/grammar/publishing/) | Notasi ID, alamat publikasi, penetapan format, indeks nama, daftar versi, lapisan kepercayaan |
| [Dokumen spesifikasi Codec](/id/grammar/codec-spec/) | Codebook yang ditulis dengan DECLARE·FIELD·ENUM·CODEC |
| [Contoh: item Wikidata](/id/grammar/example/) | Membaca satu dokumen per WORD |

## Masalah terbuka

- Kind kasus batas. Kasus yang terbelah antara Reference·Value·Edge·Meta, seperti pernyataan tentang pernyataan.
