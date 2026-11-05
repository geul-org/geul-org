---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta bukan tentang isi dunia, melainkan record tentang dokumen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta bukan tentang isi dunia, melainkan record tentang dokumen. Kecuali record struktur dokumen (DOC, BODY, END), semuanya ditaruh di HEAD dokumen. Selain Meta, di HEAD juga ada Edge dasar untuk seluruh dokumen [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) beserta QUALIFIER-nya.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      bagian 14 dan 15 (0x1C0L~0x1FFL)
[TAG ekstensi Length]
Payload           nilai mentah, atau record Value atau Reference bawaan
```

- Meta tidak memiliki format Issuer. Meta adalah spesifikasi bersama yang diikuti semua Issuer, dan hanya GEUL yang mendefinisikannya.
- `LLLL` adalah jumlah WORD total termasuk TAG WORD dikurangi 1. Codec yang tidak ada di tabel adalah Reserved.

## Format Payload {#payload-형식}

| Format | Kapan | Contoh |
|---|---|---|
| nilai mentah | Bila formatnya tunggal. Tidak bergantung pada Codec record lain | panjang `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value bawaan | Bila memilih di antara beberapa format. TAG Value memberi tahu formatnya | `PROFILE`, `EFFECTIVE-*`, waktu, hash isi |
| Reference bawaan | Bila menunjuk sasaran seperti orang, organisasi, alat, atau dokumen | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, penanda tangan pada `SIGNATURE` |
| tidak ada | Penanda 1 WORD | `BODY`, `END` |

- Record bawaan bukan record mandiri, melainkan bagian dari Meta itu. Masing-masing menemukan batasnya dengan Length, dan posisi setelah membaca record terakhir harus tepat sama dengan akhir Meta.
- Meta yang hanya boleh satu dalam satu dokumen dan Meta yang boleh banyak ditentukan oleh "Jumlah" pada dokumen tiap Codec.

## Kelas {#클래스}

Nomor Meta berlanjut dari `0x1C0L` tanpa Reserved. Bit nomor tidak menunjukkan kelas. Kelas diketahui dari tabel rentang di bawah.

| Kelas | Kode langsung | Yang dicakup |
|---|---|---|
| struktur | `0x1C0L~0x1C4L` | batas dan panjang dokumen |
| definisi | `0x1C5L~0x1CAL` | deklarasi interpretasi |
| asal-usul | `0x1CBL~0x1D0L` | siapa, kapan, di mana |
| silsilah | `0x1D1L~0x1DDL` | berasal dari apa dan bagaimana |
| kebijakan | `0x1DEL~0x1E3L` | bagaimana ditangani |
| IMPORT | `0x1E4L` | mengimpor dokumen eksternal |
| verifikasi | `0x1E5L~0x1E9L` | apakah dapat dipercaya |
| Reserved (khusus verifikasi) | `0x1EAL~0x1FFL` | |

- Kelas verifikasi adalah record dengan `C >= 5` pada bagian 15, yaitu `w >= 0x1E50`. Dengan ini kelas verifikasi diketahui tanpa buku Codec dan dikeluarkan dari hash isi.
- Reserved belakang `0x1EAL~0x1FFL` khusus verifikasi. Meta baru di luar verifikasi tidak dapat ditaruh sebelum verifikasi, dan jika ditaruh di Reserved belakang, ia dikeluarkan dari hash isi.
- Kelas struktur, definisi, dan IMPORT tidak dibaca dengan bit. Dekoder mengetahuinya dari tabel nomor bawaan.
- **Meta yang diperlukan untuk interpretasi**: struktur, definisi, IMPORT. Jika dihapus, record tidak dapat dibaca atau interpretasinya berubah. Semua dekoder harus menanganinya. Codec ini termasuk dalam **buku Codec inti GEUL**.
- **Meta yang tidak mengubah interpretasi**: asal-usul, silsilah, verifikasi, kebijakan. Jika dihapus, isi pernyataan tetap sama. Hanya bahan untuk menilai kepercayaan dan penanganan yang hilang.
- Dasar ditulis bukan dengan Meta, melainkan dengan Edge dasar [SOURCE](../edge/0x0C0L-source.md) dan QUALIFIER. Dasar untuk record individual ditaruh di BODY, sedangkan sumber asal seluruh dokumen ditaruh di HEAD sebagai SOURCE dengan Target `0` ([dokumen](../document.md#head와-body)).

## Struktur {#구조}

Kelas struktur Meta (Codec `0x1C0L~0x1C4L`) menentukan batas dan panjang dokumen. Satuan data GEUL adalah satu dokumen.

```
DOC-*                  ← awal HEAD
  Meta definisi, asal-usul, silsilah, verifikasi, kebijakan, IMPORT
  SOURCE untuk seluruh dokumen dan QUALIFIER-nya
BODY                   ← awal BODY
  Reference, Value, Edge
END                    ← menutup dokumen
```

- Setiap dokumen dibuka dengan `DOC-1WORD/2WORD/4WORD` yang menetapkan panjang total. Dengan panjang ini dekoder dapat melompati seluruh dokumen sekaligus.
- `BODY` dan `END` adalah record 1 WORD tanpa Payload. `END` wajib.
- Dokumen tidak bersarang. Dokumen lain ditunjuk dengan IMPORT.
- Jika HEAD (Meta, serta SOURCE untuk seluruh dokumen dan QUALIFIER-nya) kosong, `BODY` dihilangkan. `BODY` hanya boleh ditaruh sekali per dokumen.

Struktur dokumen selengkapnya ada di [dokumen](../document.md).

| Codec | Nama | Arti |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Membuka dokumen dengan menetapkan panjang total |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Mengakhiri HEAD dan membuka BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Menutup dokumen |

Aturan terperinci ada di [dokumen](../document.md).

## Definisi {#정의}

Kelas definisi Meta (Codec `0x1C5L~0x1CAL`) adalah deklarasi interpretasi. Deklarasi mengubah aturan interpretasi sehingga semua dekoder harus menanganinya. Cakupan deklarasi adalah dokumen itu.

- `SPEC-VERSION` menentukan cara membaca record lainnya, sehingga hanya berupa bilangan bulat tanpa Value bawaan. GEUL v1 adalah `0x0001` (record `1C51 0001`).
- `DOC-ID` adalah `DOC-POINTER` (Issuer, ID dokumen, versi `0`) yang menunjuk dokumen itu sendiri. Dokumen Codec memakai `CODEC-POINTER` (Issuer, Codec ID, versi `0`). Jika tidak ada, dokumen itu tidak bernama dan hanya dapat ditunjuk dengan hash isi.
- Tidak ada alamat nama dokumen. Judul yang dapat dibaca manusia dilekatkan dengan `LABEL` pernyataan ([alamat publikasi dan daftar versi](../publishing.md#문서-이름)).

| Codec | Nama | Arti |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | Edisi spesifikasi yang diikuti. Satu bilangan bulat |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | Profil yang diterapkan |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | Pengenal dokumen ini. DOC-POINTER yang menunjuk dirinya sendiri (versi 0). Dokumen Codec: CODEC-POINTER (versi 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | Tanggal mulai berlaku versi ini. Jika tidak ada, waktu publikasi |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | Akhir masa berlaku versi ini (undang-undang berjangka waktu). Jika tidak ada, sampai versi berikutnya mulai berlaku |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | Bahasa default |

- Tidak ada alamat nama dokumen ([alamat publikasi dan daftar versi](../publishing.md#문서-이름)). Judul yang dapat dibaca manusia dilekatkan dengan LABEL pada BODY.

## Asal-usul {#출처}

Kelas asal-usul Meta (Codec `0x1CBL~0x1D0L`) mencatat siapa yang membuat dan merekam dokumen, dan kapan.

- Penulis, perekam, dan waktunya mengikuti model author dan committer pada git (`AUTHOR` dan `CREATED-AT`, `RECORDED-BY` dan `RECORDED-AT`).
- Jika asal-usul dihapus, isi pernyataan tidak berubah. Hanya bahan penilaian kepercayaan yang hilang.
- Bahan sumber tidak ada di kelas ini. Sumber asal seluruh dokumen ditulis di HEAD, dan sumber asal record individual ditulis di BODY, dengan Edge dasar [SOURCE](../edge/0x0C0L-source.md). Rentang yang sesuai dalam teks asli, waktu perolehan, dan hash teks asli adalah QUALIFIER yang dilekatkan pada SOURCE itu (halaman P304 dan bagian P958, tanggal akses P813, checksum P4092).
- Jika sifat yang melekat pada sumber (rentang teks asli, waktu perolehan) dijadikan Meta, tidak dapat ditentukan milik sumber yang mana ketika sumbernya banyak. Karena itu ditulis sebagai QUALIFIER yang menjadikan SOURCE sebagai Target.

| Codec | Nama | Arti |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | Penulis (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | Penulis bersama |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Waktu penulisan |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Waktu perubahan |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | Pihak perekam |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Waktu perekaman |

- Bahan sumber ditulis bukan dengan Meta, melainkan dengan Edge dasar [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) di HEAD (Target `0`), dan rentang teks asli, waktu perolehan, serta hash teks asli ditulis sebagai QUALIFIER yang dilekatkan pada SOURCE itu.

## Silsilah {#계보}

Kelas silsilah Meta (Codec `0x1D1L~0x1DDL`) mencatat dari apa dan bagaimana dokumen berasal. Silsilah mengikuti model commit git, dan satuan yang setara dengan commit adalah dokumen.

- **Hash isi** menunjuk isi satu salinan dokumen (git commit id). Berupa SHA-256 dari record pembuka (`DOC-*`) sampai tepat sebelum `END`, dan record kelas verifikasi (`C >= 5` pada bagian 15, `w >= 0x1E50`) dikeluarkan dari perhitungan.
- **ID versi** adalah bilangan bulat 2 WORD yang bernomor mulai dari 1 menurut urutan publikasi dalam dokumen bernama. `0` berarti versi tidak dicantumkan.
- Meta silsilah menunjuk versi dengan hash isi. `PARENT` di dalam dokumen juga termasuk dalam hash, sehingga hash isi menjadi rantai hash yang menyambung seluruh riwayat.
- Riwayat tidak dihapus. Isi yang diperbaiki diterbitkan sebagai versi baru. Pointer yang berubah seperti branch tidak ditaruh di dokumen.
- `DELTA-BASE` dan `DELTA-REMOVE` adalah format yang menyimpan versi sebagai diff terhadap versi dasar. Versi selalu didefinisikan sebagai snapshot.

Aturan revisi ada di [dokumen](../document.md).

Silsilah mengikuti model commit git. Satuan yang setara dengan commit adalah dokumen.

| Codec | Nama | Arti |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | Hash isi versi sebelumnya. Jika lebih dari satu, penggabungan |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Diturunkan dari bahan silsilah lain |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | Pihak pembuat (manusia, model, mesin aturan) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | Alat konversi dan versi sumbernya (digest commit) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | Versi asal perubahan yang diambil |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | Versi target yang dibatalkan |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | Versi target yang ditulis ulang. Versi asli tidak dihapus |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | Versi-versi asal yang digabung menjadi satu |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | Alasan perubahan. Satu per bahasa |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | Nama imutabel yang diberikan pada versi |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | File ini adalah diff terhadap versi dasar |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | Daftar LOCAL ID yang dibuang dari diff |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | LOCAL ID yang akan dialokasikan berikutnya. Ditaruh pada dokumen daftar versi |

- Riwayat tidak dihapus. Isi yang diperbaiki diterbitkan sebagai versi baru.
- Pointer yang berubah seperti branch tidak ditaruh di dokumen. Penyimpanan dan indeks yang mengelolanya.

## Verifikasi {#검증}

Kelas verifikasi Meta (Codec `0x1E5L~0x1E9L`) mencatat bahan untuk menilai apakah dokumen dapat dipercaya. Yaitu kunci publik Issuer yang diterbitkan sendiri, tanda tangan, konfirmasi hak kontribusi, tingkat keyakinan, dan hasil penilaian seluruh dokumen.

- Kelas verifikasi dikeluarkan dari perhitungan hash isi. Karena itu meskipun tanda tangan ditaruh di dalam dokumen, atau tanda tangan ditambah banyak, hash isi tidak berubah (sama seperti `gpgsig` git).
- Kelas verifikasi adalah record dengan `C >= 5` pada bagian 15, yaitu `w >= 0x1E50`, sehingga hash dapat dihitung tanpa buku Codec. Reserved belakang `0x1EAL~0x1FFL` juga khusus verifikasi sehingga dikeluarkan dari hash.
- Penilaian per node atau record menjadi tugas Edge [TOULMIN](../toulmin/_index.md) `VERDICT` (`0x118L`).

| Codec | Nama | Arti |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | Algoritma tanda tangan dan kunci publik Issuer yang diterbitkan sendiri |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | Tanda tangan atas hash isi. Algoritma, penanda tangan, tanda tangan |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Konfirmasi hak kontribusi |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Tingkat keyakinan |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | Hasil penilaian seluruh dokumen (Pass, Review, Fail) |

- Kelas verifikasi dikeluarkan dari perhitungan hash isi. Karena itu meskipun tanda tangan ditaruh di dalam dokumen, atau tanda tangan ditambah banyak, hash isi tidak berubah.

## Kebijakan {#정책}

Kelas kebijakan Meta (Codec `0x1DEL~0x1E3L`) menentukan bagaimana dokumen ditangani. Yaitu lisensi, cakupan keterbukaan, tingkat data pribadi, batas waktu penyimpanan, persetujuan, dan pembatasan penggunaan.

- Kebijakan tidak mengubah interpretasi, melainkan menentukan cara penanganan.
- Lisensi asli dari karya di dalam rangkaian byte dicatat dengan `LICENSE`.

| Codec | Nama | Arti |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | Lisensi |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Cakupan keterbukaan |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Tingkat data pribadi |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Batas waktu penyimpanan |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Cakupan dan dasar persetujuan |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Pembatasan penggunaan |

- Kebijakan tidak mengubah interpretasi, melainkan menentukan cara penanganan.

## IMPORT {#import}

Kelas IMPORT Meta (Codec `0x1E4L`) mengimpor dokumen eksternal dengan IMPORT ID. Codec-nya hanya satu, `IMPORT-DOC` (`0x1E4L`).

- IMPORT hanya mengimpor dokumen. Sasaran di dalam dokumen yang diimpor ditunjuk dengan Reference `EXTERNAL-POINTER-*` (IMPORT ID, ID LOCAL) di BODY ([Reference](../reference/_index.md)).
- Jika ID versi dicantumkan, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru saat interpretasi. Dokumen yang dipublikasikan mencantumkan versi.
- HEAD dari dokumen yang diimpor tidak ikut diimpor. Record Reference dan Value tidak diimpor, melainkan disalin.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[TAG ekstensi Length]
dokumen           record DOC-POINTER (Issuer, ID dokumen, ID versi). Dokumen Codec: CODEC-POINTER
IMPORT ID         sisanya. Bilangan bulat dengan lebar tersempit
```

- Hanya [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`) yang dipakai. IMPORT hanya mengimpor dokumen. Sasaran di dalam dokumen yang diimpor ditunjuk dengan `EXTERNAL-POINTER-*` (IMPORT ID, ID LOCAL) di BODY.
- Jika ID versi dicantumkan, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru saat interpretasi. Dokumen yang dipublikasikan mencantumkan versi.
- IMPORT ID yang sama tidak dialokasikan dua kali dalam satu dokumen.
- HEAD dari dokumen yang diimpor tidak ikut diimpor. Sasaran dokumen itu ditafsirkan sesuai deklarasi dokumen itu.

Contoh: mengimpor versi terbaru dokumen `0x0000000000000002` milik Issuer `0x00000002` dengan IMPORT ID 1.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
