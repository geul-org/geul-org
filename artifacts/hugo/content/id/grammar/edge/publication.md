---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE adalah Edge pernyataan yang mencatat publikasi·anjuran penghentian pemakaian·penghapusan versi dokumen, dan halaman ini juga menetapkan spesifikasi dokumen daftar versi yang ditulis dengan Edge itu (Codec 0x18~0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge pernyataan yang mencatat publikasi·deprecate·penghapusan dokumen, serta spesifikasi dokumen daftar versi yang ditulis dengan Edge itu. Menetapkan format daftar versi pada [alamat publikasi dan daftar versi](/id/grammar/publishing/#daftar-versi).

## Kode

| Codec | Nama | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, hash isi |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, kategori alasan |

- Ketiga kode ditanamkan di decoder ([lapisan 0](/id/grammar/publishing/#lapisan)). Daftar versi diinterpretasikan tanpa mencari codebook.
- Tidak ada sub-format (TAG per Codec). Aturan [Edge](/id/grammar/edge/) bahwa elemen pertama Payload adalah Edge Id dipatuhi apa adanya.

## Layout

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length extension TAG]
Edge Id           record LOCAL Reference
Dokumen           record DOC-POINTER Reference (Issuer, ID dokumen, ID versi)
Hash isi          16 WORD   (PUBLICATION)
Kategori alasan   1 WORD    (TOMBSTONE)
```

| Field | Lebar | Penjelasan |
|---|---|---|
| Edge Id | record LOCAL Reference | Nomor urut dalam daftar. Diberi nomor mulai dari 1 dan disambung berurutan |
| Dokumen | record DOC-POINTER | Satu versi dokumen yang diterbitkan ([DOC-POINTER](/id/grammar/reference/doc-pointer/)). Issuer·ID dokumen sama dengan dokumen yang ditangani daftar itu. Membuat dokumen daftar menyatakan daftar tentang apa walaupun tanpa path. ID versi adalah nomor urut di dalam dokumen itu (versi [Dokumen](/id/grammar/document/)), dan `0` (terbaru) tidak dipakai |
| Hash isi | 16 WORD | Hash isi versi itu (SHA-256, hash isi [Dokumen](/id/grammar/document/)) |
| Kategori alasan | 1 WORD | Kode kategori alasan penghapusan. Tabel kode adalah masalah terbuka |

- Panjang setelah DOC-POINTER tetap per kode (16, 0, 1 WORD). Jika berbeda, ditolak.
- Waktu tidak dimasukkan ke dalam record. `RECORDED-AT` dokumen daftar tempat record itu pertama kali dimuat adalah waktu publikasi·deprecate·penghapusan.

## Dokumen daftar versi

Penerbit menulis berkelanjutan satu dokumen daftar versi per dokumen: `/<Issuer>/<ID dokumen>/versions.geul`. Semua versi dokumen itu yang diterbitkan oleh penerbit tersebut masuk dalam satu daftar.

```
DOC-1WORD/2WORD/4WORD     panjang total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash isi dokumen daftar sebelumnya (tidak ada jika daftar pertama)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Waktu daftar ini dikeluarkan
  NEXT-LOCAL-ID           LOCAL ID yang dialokasikan berikutnya (jika ada versi)
  SIGNATURE               Tanda tangan penerbit. Targetnya hash isi dokumen daftar ini
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- Meta HEAD: [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/), [PARENT](/id/grammar/meta/lineage/parent/), [RECORDED-AT](/id/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/), [SIGNATURE](/id/grammar/meta/verification/signature/).
- Dokumen daftar tidak menaruh `DOC-ID` (pengecualian dokumen yang namanya tidak diawali `0x`, [DOC-ID](/id/grammar/meta/declaration/doc-id/)). Daftar bukan dokumen terbitan, melainkan catatan yang melekat pada dokumen itu. Daftar tentang dokumen mana dinyatakan oleh ID dokumen pada record. Karena itu walaupun diterima tanpa path (`h/`, dump), diketahui daftar tentang apa.
- Semua ID dokumen pada record harus dokumen yang ditangani daftar itu. Record dokumen lain ditolak.
- Dokumen daftar tidak menaruh IMPORT dan hanya memakai Codec lapisan 0. Tidak dimuat pada daftar lain (tidak ada daftar dari daftar).
- Dokumen daftar baru menaruh BODY dokumen daftar sebelumnya apa adanya di depan, lalu menambahkan record. Tidak mengubah, menghapus, atau mengubah urutan.
- Penerbit menandatangani daftar. Untuk publikasi geul.org, geul.org (Issuer GEUL) yang menandatangani; untuk publikasi pribadi, Issuer itu.
- ID dokumen `0x0000000000000000` adalah dokumen indeks definisi istilah Issuer ([Issuer dan publikasi](/id/grammar/issuer/)). Issuer itu sendiri ditunjuk dengan [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/).

## Aturan

- ID versi PUBLICATION berurutan naik tanpa celah mulai dari 1. ID versi dialokasikan penerbit.
- Hash isi yang sama tidak diterbitkan ulang. Jika sudah ada, ID versi itu dikembalikan.
- DEPRECATION·TOMBSTONE hanya menunjuk ID versi PUBLICATION yang muncul sebelumnya. Jika menunjuk versi yang tidak ada, ditolak.
- Status versi dihitung dengan menerapkan record secara berurutan. Diterbitkan → deprecated → dihapus. Versi yang dihapus tidak diterbitkan ulang dan tidak diberikan.
- Versi terbaru adalah ID versi tertinggi yang tidak deprecated maupun dihapus.
- Jika ID versi mencapai ujung 2 WORD, dokumen itu tidak diterbitkan lagi dan dikeluarkan dengan ID dokumen baru.

## Nama dokumen

Nama untuk alamat dokumen diikat dengan [BIND](/id/grammar/edge/bind/) oleh indeks nama Issuer `/<Issuer>/documents.geul` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)). Penerjemah alamat hanya membaca indeks ini.

BIND yang sama juga boleh ditaruh pada dokumen daftar (opsional). Jika ditaruh, patuhi hal berikut.

- Subject adalah `DOC-POINTER` (Issuer, ID dokumen daftar itu, versi `0`). Nama diikat pada dokumen, bukan versi, sehingga versinya `0`.
- Hanya diikat pada dokumen yang PUBLICATION-nya muncul di depan. Nama tidak diikat pada dokumen yang belum pernah diterbitkan.
- Nama mengikuti aturan nama dokumen (slug ASCII huruf kecil) dan harus sama dengan BIND pada indeks nama.
- Jika nama diubah, tambahkan BIND baru. Nama lama tetap ada dan menunjuk dokumen yang sama. Nama utama adalah BIND terakhir.
- Di dalam dokumen, nama dirinya sendiri tidak ditulis.

## Alamat

```
/.well-known/geul/<Issuer>/<ID dokumen>/versions.geul             dokumen daftar terbaru (berubah)
/.well-known/geul/h/<hash isi>.geul                                dokumen daftar lama (tetap)
```

- Yang berubah hanya satu alamat daftar terbaru. Daftar yang diterima diverifikasi dengan tanda tangan, `RECORDED-AT`, dan rantai `PARENT`.
- Semua dokumen daftar lama tersimpan di `h/`. Dengan mengikuti rantai `PARENT`, daftar pada titik waktu mana pun dapat ditelusuri kembali.

## Verifikasi

- Dokumen daftar harus memiliki `SIGNATURE` dengan kunci penerbit yang ditetapkan.
- ID dokumen pada record harus sama dengan ID dokumen yang diminta.
- Hash isi daftar sebelumnya yang tersisa dalam catatan kunci harus ada dalam rantai `PARENT` daftar baru. BODY daftar itu harus sama dengan bagian depan BODY daftar baru.
- Hash isi dokumen yang diterima harus sama dengan nilai yang ditulis PUBLICATION ID versi itu, dan `DOC-ID` dokumen harus sama dengan Issuer·ID dokumen yang diminta.

## Masalah terbuka

- Tabel kode kategori alasan.
- Nilai default algoritma tanda tangan dan layout Payload `SIGNATURE`.
- Kapan dan dalam format apa berpindah ke log Merkle (bukti inklusi·konsistensi) saat daftar membesar.
- Apakah BIND pada daftar dan indeks nama `documents.geul` digabung menjadi satu, serta tanda tangan indeks.
- Pencegahan rollback per Issuer. Karena daftar membentuk rantai terpisah per dokumen, serangan yang menyodorkan daftar lama hanya untuk satu dokumen hanya terhalang oleh rantai dokumen itu.

## Halaman terkait

- [Edge](/id/grammar/edge/), [BIND](/id/grammar/edge/bind/), [DOC-POINTER](/id/grammar/reference/doc-pointer/)
- [Issuer dan publikasi](/id/grammar/issuer/), [alamat publikasi dan daftar versi](/id/grammar/publishing/), [Dokumen](/id/grammar/document/)
