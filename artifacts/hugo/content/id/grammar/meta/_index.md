---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta bukan tentang dunia, melainkan record tentang dokumen. Terbagi atas tujuh kelas: struktur, definisi, asal-usul, silsilah, verifikasi, kebijakan, dan IMPORT, dan ditaruh di HEAD dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta bukan isi tentang dunia, melainkan record tentang dokumen. Kecuali record struktur dokumen (DOC·BODY·END), semuanya ditaruh di HEAD dokumen. Selain Meta, di HEAD juga dapat ada Edge dasar [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) untuk seluruh dokumen beserta QUALIFIER-nya.

## Layout

```
TAG WORD          0001 1LLL LCCC CCCC
[Length extension TAG]
Payload           nilai mentah atau record Value·Reference tersemat
```

- Meta tidak memiliki format Issuer. Meta adalah spesifikasi umum yang diikuti semua Issuer dan hanya didefinisikan oleh GEUL.
- `LLLL` adalah jumlah WORD total termasuk TAG WORD dikurangi 1. Codec yang tidak ada di tabel adalah cadangan.

## Format Payload

| Format | Kapan | Contoh |
|---|---|---|
| Nilai mentah | Saat format sudah tunggal. Tidak bergantung pada Codec record lain | panjang `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value tersemat | Saat memilih dari beberapa format. TAG Value menunjukkan formatnya | `PROFILE`, `EFFECTIVE-*`, waktu, hash isi |
| Reference tersemat | Saat menunjuk target seperti orang, organisasi, alat, atau dokumen | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, penanda tangan pada `SIGNATURE` |
| Tidak ada | Penanda 1 WORD | `BODY`, `END` |

- Record tersemat bukan record mandiri dan menjadi bagian dari Meta-nya. Masing-masing menemukan batasnya dengan Length, dan posisi setelah membaca record terakhir harus tepat sama dengan akhir Meta.
- Meta yang hanya boleh ada satu dalam satu dokumen dan Meta yang boleh lebih dari satu ditentukan oleh "Jumlah" pada dokumen setiap Codec.

## Kelas

3 bit atas Codec adalah kelasnya.

| 3 bit atas | Kelas | Kode langsung | Yang ditangani |
|---|---|---|---|
| `000` | Struktur | `0x00`~`0x0F` | Batas dan panjang dokumen |
| `001` | Definisi | `0x10`~`0x1F` | Deklarasi interpretasi |
| `010` | Asal-usul | `0x20`~`0x2F` | Siapa, kapan, di mana |
| `011` | Silsilah | `0x30`~`0x3F` | Dari apa dan bagaimana dihasilkan |
| `100` | Verifikasi | `0x40`~`0x4F` | Apakah dapat dipercaya |
| `101` | Kebijakan | `0x50`~`0x5F` | Bagaimana diperlakukan |
| `110` | IMPORT | `0x60`~`0x6F` | Mengimpor dokumen eksternal |
| `111` | Cadangan | `0x70`~`0x7F` | |

- **Meta yang diperlukan untuk interpretasi**: struktur, definisi, IMPORT. Jika dihapus, record tidak dapat dibaca atau interpretasinya berubah. Semua decoder harus memprosesnya. Codec ini termasuk dalam **codebook inti GEUL**.
- **Meta yang tidak mengubah interpretasi**: asal-usul, silsilah, verifikasi, kebijakan. Walaupun dihapus, isi pernyataan tetap sama. Hanya bahan untuk menilai kepercayaan dan penanganan yang hilang.
- Dasar tidak ditulis dengan Meta, melainkan dengan Edge dasar [SOURCE](/id/grammar/edge/source/) dan QUALIFIER. Dasar setiap record ditaruh di BODY, sedangkan sumber seluruh dokumen ditaruh di HEAD sebagai SOURCE dengan Target `0` ([Dokumen](/id/grammar/document/#head-dan-body)).

## Struktur

Dokumen kelompok: [Meta — Struktur](/id/grammar/meta/structure/)

| Codec | Nama | Arti |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/id/grammar/meta/structure/doc/) | Membuka dokumen dengan menetapkan panjang total |
| `0x0E` | [BODY](/id/grammar/meta/structure/body/) | Mengakhiri HEAD dan membuka BODY |
| `0x0F` | [END](/id/grammar/meta/structure/end/) | Menutup dokumen |

Aturan rinci ada di [Dokumen](/id/grammar/document/).

## Definisi

Dokumen kelompok: [Meta — Definisi](/id/grammar/meta/declaration/)

| Codec | Nama | Arti |
|---|---|---|
| `0x10` | [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/) | Edisi spesifikasi yang diikuti. Satu bilangan bulat |
| `0x11` | [PROFILE](/id/grammar/meta/declaration/profile/) | Profil yang diterapkan |
| `0x12` | [DOC-ID](/id/grammar/meta/declaration/doc-id/) | Pengenal dokumen ini. DOC-POINTER yang menunjuk dirinya sendiri (versi 0) |
| `0x13` | [EFFECTIVE-FROM](/id/grammar/meta/declaration/effective-from/) | Tanggal berlaku versi ini. Jika tidak ada, waktu publikasi |
| `0x14` | [EFFECTIVE-UNTIL](/id/grammar/meta/declaration/effective-until/) | Akhir masa berlaku versi ini (berlaku terbatas). Jika tidak ada, sampai versi berikutnya berlaku |
| `0x16` | [DEFAULT-LANGUAGE](/id/grammar/meta/declaration/default-language/) | Bahasa default |

- Nama untuk alamat dokumen tidak ditaruh sebagai Meta. Indeks nama Issuer `documents.geul` menempelkannya dengan BIND ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)). Judul yang dibaca manusia ditempelkan dengan LABEL di BODY.

## Asal-usul

Dokumen kelompok: [Meta — Asal-usul](/id/grammar/meta/provenance/)

| Codec | Nama | Arti |
|---|---|---|
| `0x20` | [AUTHOR](/id/grammar/meta/provenance/author/) | Penulis (Reference) |
| `0x21` | [CO-AUTHOR](/id/grammar/meta/provenance/co-author/) | Penulis bersama |
| `0x22` | [CREATED-AT](/id/grammar/meta/provenance/created-at/) | Waktu penulisan |
| `0x23` | [MODIFIED-AT](/id/grammar/meta/provenance/modified-at/) | Waktu modifikasi |
| `0x24` | [RECORDED-BY](/id/grammar/meta/provenance/recorded-by/) | Pelaku perekam |
| `0x25` | [RECORDED-AT](/id/grammar/meta/provenance/recorded-at/) | Waktu perekaman |
| `0x26`~`0x2F` | Reserved | |

- Materi sumber tidak ditulis sebagai Meta, melainkan sebagai Edge dasar [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) (Target `0`) di HEAD. Rentang teks asli, waktu perolehan, dan hash teks asli ditulis sebagai QUALIFIER yang menempel pada SOURCE itu.

## Silsilah

Dokumen kelompok: [Meta — Silsilah](/id/grammar/meta/lineage/)

Silsilah mengikuti model commit git. Satuan yang setara dengan commit adalah dokumen.

| Codec | Nama | Arti |
|---|---|---|
| `0x30` | [PARENT](/id/grammar/meta/lineage/parent/) | Hash isi versi sebelumnya. Jika beberapa, merge |
| `0x31` | [DERIVED-FROM](/id/grammar/meta/lineage/derived-from/) | Diturunkan dari materi silsilah lain |
| `0x32` | [GENERATED-BY](/id/grammar/meta/lineage/generated-by/) | Pelaku pembuat (manusia, model, mesin aturan) |
| `0x33` | [TRANSFORMED-BY](/id/grammar/meta/lineage/transformed-by/) | Alat konversi dan versi sumbernya (digest commit) |
| `0x34` | [CHERRY-PICKED-FROM](/id/grammar/meta/lineage/cherry-picked-from/) | Versi asal perubahan yang diambil |
| `0x35` | [REVERTS](/id/grammar/meta/lineage/reverts/) | Versi target yang dibatalkan |
| `0x36` | [REPLACES](/id/grammar/meta/lineage/replaces/) | Versi target yang ditulis ulang. Versi asal tidak dihapus |
| `0x37` | [SQUASHED-FROM](/id/grammar/meta/lineage/squashed-from/) | Versi-versi asal yang digabung menjadi satu |
| `0x38` | [MESSAGE](/id/grammar/meta/lineage/message/) | Alasan perubahan. Satu per bahasa |
| `0x39` | [TAG](/id/grammar/meta/lineage/tag/) | Nama tetap yang diberikan pada versi |
| `0x3A` | [DELTA-BASE](/id/grammar/meta/lineage/delta-base/) | File ini adalah diff terhadap versi dasar |
| `0x3B` | [DELTA-REMOVE](/id/grammar/meta/lineage/delta-remove/) | Daftar LOCAL ID yang dikeluarkan dari diff |
| `0x3C` | [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/) | LOCAL ID yang dialokasikan berikutnya. Ditaruh di dokumen daftar versi |

- Riwayat tidak dihapus. Perbaikan diterbitkan sebagai versi baru.
- Pointer yang berubah seperti branch tidak ditaruh di dokumen. Repositori dan indeks yang mengelolanya.

## Verifikasi

Dokumen kelompok: [Meta — Verifikasi](/id/grammar/meta/verification/)

| Codec | Nama | Arti |
|---|---|---|
| `0x40` | [ISSUER-KEY](/id/grammar/meta/verification/issuer-key/) | Algoritma tanda tangan dan kunci publik Issuer yang menerbitkan sendiri |
| `0x41` | [SIGNATURE](/id/grammar/meta/verification/signature/) | Tanda tangan atas hash isi. Algoritma, penanda tangan, tanda tangan |
| `0x42` | [SIGNED-OFF](/id/grammar/meta/verification/signed-off/) | Konfirmasi hak kontribusi |
| `0x43` | [CONFIDENCE](/id/grammar/meta/verification/confidence/) | Tingkat kepercayaan |
| `0x44` | [VERDICT](/id/grammar/meta/verification/verdict/) | Hasil putusan seluruh dokumen (Pass, Review, Fail) |

- Kelas verifikasi dikeluarkan dari perhitungan hash isi. Karena itu hash isi tidak berubah walaupun tanda tangan ditaruh di dalam dokumen atau ditambah beberapa kali.

## Kebijakan

Dokumen kelompok: [Meta — Kebijakan](/id/grammar/meta/policy/)

| Codec | Nama | Arti |
|---|---|---|
| `0x50` | [LICENSE](/id/grammar/meta/policy/license/) | Lisensi |
| `0x51` | [ACCESS](/id/grammar/meta/policy/access/) | Cakupan publikasi |
| `0x52` | [PRIVACY](/id/grammar/meta/policy/privacy/) | Tingkat data pribadi |
| `0x53` | [RETENTION](/id/grammar/meta/policy/retention/) | Batas retensi |
| `0x54` | [CONSENT](/id/grammar/meta/policy/consent/) | Cakupan dan dasar persetujuan |
| `0x55` | [USAGE](/id/grammar/meta/policy/usage/) | Batasan penggunaan |

- Kebijakan tidak mengubah interpretasi, melainkan menetapkan cara penanganan.

## IMPORT

Dokumen kelompok: [Meta — IMPORT](/id/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length extension TAG]
Dokumen           record DOC-POINTER (Issuer, ID dokumen, ID versi)
IMPORT ID         sisanya. Bilangan bulat dengan lebar terpendek
```

- Hanya [IMPORT-DOC](/id/grammar/meta/import/import-doc/) (`0x60`) yang dipakai. IMPORT hanya mengimpor dokumen. Target di dalam dokumen yang diimpor ditunjuk dengan `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) di BODY.
- Jika ID versi ditulis, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru pada saat interpretasi. Dokumen terbitan menulis versi.
- IMPORT ID yang sama tidak dialokasikan dua kali dalam satu dokumen.
- HEAD dokumen yang diimpor tidak ikut diimpor. Target dokumen itu diinterpretasikan menurut deklarasi dokumen itu.

Contoh: mengimpor versi terbaru dokumen `0x0000000000000002` dari Issuer `0x0001` dengan IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
