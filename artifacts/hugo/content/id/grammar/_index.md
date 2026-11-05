---
title: "Tata Bahasa GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Spesifikasi tata bahasa GEUL v1. Mendefinisikan record di atas WORD 16 bit, empat Kind, struktur dokumen, serta aturan Issuer dan publikasi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) adalah bahasa buatan sekaligus format biner agar manusia dan AI dapat saling bertukar informasi tanpa ambiguitas.

Dokumen-dokumen ini mendefinisikan tata bahasa GEUL v1. Edisi saat ini adalah draf sebelum publikasi dan dapat berubah. Spesifikasi dirilis di bawah [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Sekilas {#한눈에-보기}

- Semua data adalah rangkaian **WORD 16 bit**. Ditulis dalam big endian.
- Satuan data adalah **record**. Sebuah record diawali satu TAG WORD, dan TAG WORD itu menyatakan jenis serta panjang record.
- Record ada empat jenis (**Kind**).

| Kind | Fungsi | Contoh |
|---|---|---|
| Reference | Menunjuk sebuah objek | Wikidata Q42, #7 di dalam dokumen ini |
| Value | Memuat nilai itu sendiri | tanggal, kuantitas, teks berbahasa |
| Edge | Mengikat record lain untuk menyatakan sesuatu | "Q42 adalah manusia", "Nama Inggris Q42 adalah Douglas Adams" |
| Meta | Berbicara tentang dokumen | edisi spesifikasi, ID dokumen, penulis, tanda tangan |

- Record-record dimuat dalam satu **dokumen**. Seperti HTML, dokumen terbagi menjadi HEAD (Meta, serta SOURCE untuk asal-usul seluruh dokumen beserta QUALIFIER-nya) dan BODY (Reference, Value, Edge).
- Dokumen diterbitkan oleh **Issuer** (pihak penerbit), dan setiap versinya dikunci dengan hash isi. Versi yang telah dipublikasikan tidak diubah.

## Prinsip desain {#설계-원칙}

1. **Record dapat dilewati tanpa codebook.** Jenis dan panjang record ada dalam 16 bit TAG WORD. Decoder yang tidak mengetahui cara menafsirkan (codebook) tetap dapat menghitung dan melewati record.
2. **Yang dimuat adalah pernyataan, bukan fakta.** Dokumen mencatat siapa, kapan, dan dari apa pernyataan itu berasal, melalui Meta dan Edge dasar.
3. **Identifikasi dilakukan dengan Reference.** Objek ditunjuk dengan ID, bukan nama. Nama dilekatkan melalui Edge.
4. **Yang telah dipublikasikan tidak diubah.** Perbaikan diterbitkan sebagai versi baru. ID di dalam dokumen menunjuk objek yang sama lintas versi.
5. **Dibiarkan kosong.** Sebagian besar ruang bit disisakan untuk masa depan. Kode langsung tidak dapat ditarik kembali, sehingga hanya yang frekuensinya terbukti yang dialokasikan.

## Dokumen turunan {#하위-문서}

Jika Anda membaca untuk pertama kali, bacalah berurutan dari atas tabel.

| Dokumen | Isi |
|---|---|
| [Struktur record](record.md) | tata letak TAG WORD, Length, Codec, TAG ekstensi |
| [Issuer dan publikasi](issuer.md) | tingkat Issuer, tabel alokasi 2 WORD, cara publikasi, tanda tangan, kunci verifikasi |
| [Alamat publikasi dan daftar versi](publishing.md) | notasi ID, alamat publikasi, penentuan format, daftar Issuer, daftar versi, lapisan kepercayaan |
| [Dokumen spesifikasi Codec](codec-spec.md) | codebook yang ditulis dengan DECLARE, FIELD, ENUM, CODEC |
| [Dokumen umum](document.md) | DOC, HEAD, BODY, END, ID dokumen, hash isi, versi dan revisi |
| [Indeks kode](codec-index.md) | seluruh 227 slot alokasi, tabel Codec per Kind dan keluarga |
| [Tata letak bagian](layout.md) | 16 bagian dan penempatan slot, rentang alokasi dan Reserved |
| [Penanda slot](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, aturan penerimaan |
| [Reference](reference/_index.md) | identifikasi objek, LOCAL, rujukan eksternal, Quantifier, penanda slot |
| [Value](value/_index.md) | keluarga nilai, kode langsung, teks, kuantitas, tanggal |
| [Meta](meta/_index.md) | struktur, definisi, asal-usul, silsilah, verifikasi, kebijakan, IMPORT |
| [Edge](edge/_index.md) | keluarga pernyataan, dasar, eksekusi, TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | keluarga graf penilaian dan eksekusi, tata letak NODE, LINK, SOURCE |
| [Contoh: entri Wikidata](example.md) | membaca satu dokumen per WORD |

## Yang dapat diketahui tanpa codebook {#코덱북-없이-알-수-있는-것}

| Informasi | Tanpa codebook | Dasar |
|---|---|---|
| Kind | Diketahui | rentang bagian `w >> 9` pada TAG WORD (Reference 0~2, Value 3·4, Edge 5~13, Meta 14·15) |
| Panjang total record, posisi record berikutnya | Diketahui | Length pada TAG WORD |
| Nomor Codec | Diketahui | TAG WORD (untuk format Issuer, Issuer dan nomor Codec pada TAG ekstensi) |
| Keluarga, kelas | Sebagian diketahui | Hanya keluarga kode langsung Edge yang diketahui dari bit. Kode langsung Value, keluarga format Issuer, dan kelas Meta tidak diketahui dari bit. Format Issuer diketahui sampai Issuer dan nomor Codec. Kelas verifikasi Meta diketahui dari `C >= 5` (`w >= 0x1E50`) pada bagian 15 |
| Edge Id milik Edge | Diketahui | Komponen pertama Edge (bagian 5~13) selalu Reference LOCAL |
| Penanda slot (tidak ditulis, tidak diketahui, tidak ada) | Diketahui | Nilai WORD `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Penanda slot](slot-marker.md) |
| Quantifier | Diketahui | Dari offset `C` dalam bagian: jika `5 <= C < 30` pada bagian 0, atau `C < 30` pada bagian 1, maka `C % 5` |
| Panjang TAG per Codec, posisi awal Payload | Tidak diketahui | codebook |
| Tafsir Payload, peran komponen Edge | Tidak diketahui | codebook |

- Decoder tanpa codebook dapat melewati record dan menghitungnya per Kind dan Codec, tetapi tidak dapat menelusuri struktur graf.
- Semua decoder harus menangani kelas struktur, definisi, dan IMPORT pada Meta. Codec-codec ini termasuk codebook inti GEUL, dan decoder mengetahuinya dari tabel nomor bawaan ([Meta](meta/_index.md)).

Codebook dipublikasikan sebagai dokumen GEUL ([Dokumen spesifikasi Codec](codec-spec.md)). Karena itu decoder cukup mengambil dan membaca dokumen spesifikasi yang diperlukan.

## Struktur wilayah {#영역-구조}

Bit teratas TAG WORD membagi wilayah.

| Prefix | Wilayah | Proporsi | Definisi |
|---|---|---|---|
| `1` | Masa depan jauh | 50% | Reserved (masa depan jauh). Tidak digunakan |
| `01` | Masa depan | 25% | Reserved (masa depan dekat). Tidak digunakan |
| `001` | Standar | 12.5% | Tata bahasa yang secara resmi diadopsi dan dioperasikan |
| `000` | Bebas·usulan | 12.5% | Tata bahasa saat ini. Jika diadopsi, tata letak dibiarkan dan hanya Prefix dipindah ke `001` |

Seluruh tata bahasa saat ini berada di wilayah `000`. Semua TAG WORD dalam spesifikasi ini diawali `000`.

- Decoder v1 menolak TAG WORD yang Prefix-nya bukan `000`. Wilayah lain ditentukan oleh edisi berikutnya.
- Wilayah `000` adalah ruang usulan. Saat ini tidak berlaku pendaftaran maupun perlindungan.
