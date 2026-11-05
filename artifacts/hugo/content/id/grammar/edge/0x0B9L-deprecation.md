---
title: "DEPRECATION (0x0B9L)"
weight: 185
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE adalah Edge pernyataan yang mencatat publikasi, rekomendasi penghentian pemakaian, dan penghapusan versi dokumen, dan halaman ini juga menetapkan spesifikasi dokumen daftar versi yang ditulis dengan Edge tersebut (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION·DEPRECATION·TOMBSTONE adalah Edge pernyataan yang mencatat publikasi, rekomendasi penghentian pemakaian, dan penghapusan versi dokumen, dan halaman ini juga menetapkan spesifikasi dokumen daftar versi yang ditulis dengan Edge tersebut (Codec 0x0B8L~0x0BAL).

| Butir | Nilai |
|---|---|
| Nama | `DEPRECATION` (BIND dokumen spesifikasi `DEPRECATION`) |
| TAG ID | `0x0B9L` |
| Codec ID | `0x00000B90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000B90/` (target DECLARE `0B90`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 25 |
| Kind | Edge · keluarga: pernyataan, kelompok: lainnya |
| TAG WORD | `0000 1011 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deprecate versi yang dipublikasikan. DOC-POINTER |
| Sisi Hugo | `edge/publication.md` (halaman itu juga membahas [PUBLICATION](0x0B8L-publication.md) dan [TOMBSTONE](0x0BAL-tombstone.md)) |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Ini adalah Edge pernyataan yang mencatat publikasi, deprecate, dan penghapusan dokumen, sekaligus spesifikasi dokumen daftar versi yang ditulis dengan Edge itu. Menetapkan format daftar versi pada [alamat publikasi dan daftar versi](../publishing.md#버전-목록).

## Kode {#코드}

| Codec | Nama | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, hash isi |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, kategori alasan |

- Ketiga kode ini tertanam di decoder ([lapisan 0](../publishing.md#층)). Daftar versi ditafsirkan tanpa merujuk codebook.
- Tidak ada subbentuk (TAG per Codec). Aturan [Edge](_index.md) bahwa elemen pertama Payload adalah Edge Id dipatuhi apa adanya.

## Layout {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length extension TAG]
Edge Id           record LOCAL Reference
Dokumen           record DOC-POINTER Reference (Issuer, ID dokumen, ID versi). Daftar versi codec memakai CODEC-POINTER
Hash isi          16 WORD   (PUBLICATION)
Kategori alasan   1 WORD    (TOMBSTONE)
```

| Bidang | Lebar | Penjelasan |
|---|---|---|
| Edge Id | record LOCAL Reference | Nomor urut dalam daftar. Diberi nomor berurutan mulai dari 1 |
| Dokumen | record DOC-POINTER | Satu versi dokumen yang dipublikasikan ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). Issuer·ID dokumen sama dengan dokumen yang ditangani daftar itu. Dengan begitu dokumen daftar menyatakan daftar milik dokumen apa meski tanpa jalur. ID versi adalah nomor urut dalam dokumen itu (versi [dokumen](../document.md)), dan `0` (terbaru) tidak dipakai. Daftar versi codec memakai [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID versi) |
| Hash isi | 16 WORD | Hash isi versi itu (SHA-256, hash isi [dokumen](../document.md)) |
| Kategori alasan | 1 WORD | Kode kategori alasan penghapusan. Tabel kode adalah masalah terbuka |

- Panjang setelah DOC-POINTER tetap untuk tiap kode (16, 0, 1 WORD). Jika berbeda, ditolak.
- Waktu tidak dimasukkan ke record. `RECORDED-AT` dokumen daftar tempat record itu pertama kali dimuat adalah waktu publikasi·deprecate·penghapusan.

## Dokumen daftar versi {#버전-목록-문서}

Penerbit terus menambahkan record ke satu dokumen daftar versi per dokumen: `/<Issuer>/docs/<ID dokumen>/versions.geul` (codec: `/<Issuer>/codecs/<Codec ID>/versions.geul`, daftar Issuer [di bawah](#목록-문서의-버전-목록)). Semua versi dokumen itu yang dipublikasikan oleh penerbit tersebut masuk ke dalam satu daftar.

```
DOC-1WORD/2WORD/4WORD     panjang total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash isi dokumen daftar sebelumnya (tidak ada jika daftar pertama)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Waktu daftar ini dikeluarkan
  NEXT-LOCAL-ID           LOCAL ID berikutnya yang akan diberikan (jika ada versi)
  SIGNATURE               tanda tangan penerbit. Sasarannya adalah hash isi dokumen daftar ini
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- Meta HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- Dokumen daftar versi tidak memuat `DOC-ID` (pengecualian dokumen daftar, [DOC-ID](../meta/0x1C7L-doc-id.md)). Daftar bukan dokumen yang dipublikasikan, melainkan catatan yang melekat pada dokumen itu. Daftar milik dokumen mana dinyatakan oleh DOC-POINTER (ID dokumen) pada record. Karena itu, meskipun diterima tanpa jalur (`hashes/`, dump), tetap diketahui daftar milik dokumen apa.
- ID dokumen pada record harus semuanya dokumen yang ditangani daftar itu. Record dokumen lain ditolak.
- Dokumen daftar versi tidak memuat IMPORT dan hanya memakai Codec lapisan 0. BODY hanya memuat PUBLICATION·DEPRECATION·TOMBSTONE. BIND nama dokumen tidak ditaruh ([alamat publikasi dan daftar versi](../publishing.md#문서-이름)).
- Dokumen daftar baru menaruh BODY dokumen daftar sebelumnya apa adanya di depan, lalu menambahkan record. Tidak mengubah, menghapus, atau menukar urutan.
- Penerbit menandatangani daftar. Publikasi geul.org ditandatangani geul.org (GEUL Issuer), dan publikasi privat ditandatangani Issuer tersebut.
- ID dokumen `0x0000000000000000` adalah dokumen indeks definisi istilah Issuer ([Issuer dan publikasi](../issuer.md)). Issuer itu sendiri ditunjuk dengan [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## Daftar versi dokumen daftar {#목록-문서의-버전-목록}

Dokumen daftar adalah satu daftar Issuer `issuers/` ([alamat publikasi dan daftar versi](../publishing.md#목록-문서)). Daftar Issuer juga dimulai dari versi 1 dan memiliki daftar versi `issuers/versions.geul`. Record menunjuk versi daftar dengan DOC-POINTER ID dokumen yang dicadangkan (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID versi).

- Format record sama seperti di atas. Karena itu, meskipun diterima lewat `hashes/`, tetap diketahui daftar milik dokumen apa.
- Dokumen daftar itu sendiri (`<ID versi>.geul`) juga tidak memuat `DOC-ID`.
- ID dokumen `0xFFFFFFFFFFFFFFFF` tidak diterima dari Issuer mana pun lewat alamat `<Issuer>/docs/<ID dokumen>/` (404).
- `latest.geul` daftar adalah alias yang tidak disimpan. Ia mencari versi terbaru dalam daftar versi ini dan mengeluarkan byte-nya.

## Aturan {#규칙}

- ID versi PUBLICATION adalah urutan menaik mulai dari 1 tanpa celah. ID versi diberikan oleh penerbit.
- Hash isi yang sama tidak dipublikasikan ulang. Jika sudah ada, ID versi itu dikembalikan.
- DEPRECATION·TOMBSTONE hanya menunjuk ID versi PUBLICATION yang muncul sebelumnya. Jika menunjuk versi yang tidak ada, ditolak.
- Status versi dihitung dengan menerapkan record secara berurutan. Dipublikasikan → deprecated → dihapus. Versi yang dihapus tidak dipublikasikan ulang dan tidak diberikan.
- Versi terbaru adalah ID versi tertinggi yang tidak deprecated dan tidak dihapus.
- Jika ID versi mencapai batas 2 WORD, dokumen itu tidak dipublikasikan lagi dan dikeluarkan dengan ID dokumen baru.

## Alamat {#주소}

```
/.well-known/geul/<Issuer>/docs/<ID dokumen>/versions.geul        dokumen daftar terbaru (berubah)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul      dokumen daftar terbaru codec (berubah)
/.well-known/geul/issuers/versions.geul                       daftar versi terbaru daftar Issuer (berubah)
/.well-known/geul/<Issuer>/hashes/<hash isi>.geul             dokumen daftar lama (tetap)
```

- Yang berubah adalah alamat daftar terbaru. Daftar yang diterima diverifikasi dengan tanda tangan, `RECORDED-AT`, dan rantai `PARENT`.
- Semua dokumen daftar lama disimpan di `<Issuer>/hashes/`. Dengan mengikuti rantai `PARENT`, daftar pada titik waktu mana pun dapat ditelusuri kembali.

## Verifikasi {#검증}

- Dokumen daftar harus memiliki `SIGNATURE` dengan kunci penerbit yang ditentukan.
- ID dokumen pada record harus sama dengan ID dokumen yang diminta.
- Hash isi daftar sebelumnya yang tersisa dalam catatan kunci harus ada dalam rantai `PARENT` daftar baru. BODY daftar itu harus sama dengan bagian depan BODY daftar baru.
- Hash isi dokumen yang diterima harus sama dengan nilai yang ditulis PUBLICATION untuk ID versi itu, dan `DOC-ID` dokumen harus sama dengan Issuer·ID dokumen yang diminta. Dokumen daftar tidak punya `DOC-ID`.

## Masalah terbuka {#열린-문제}

- Tabel kode kategori alasan.
- Algoritma tanda tangan default dan layout Payload `SIGNATURE`.
- Kapan dan dalam format apa beralih ke log Merkle (bukti inklusi·konsistensi) ketika daftar membesar.
- Pencegahan rollback per Issuer. Karena daftar membentuk rantai terpisah untuk tiap dokumen, serangan menyodorkan daftar lama hanya untuk satu dokumen hanya dapat dicegah oleh rantai dokumen itu.

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer dan publikasi](../issuer.md), [alamat publikasi dan daftar versi](../publishing.md), [dokumen](../document.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000B90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B9000000000
BODY
#1 DECLARE 0x0B90
#2 FIELD #1 record
#6 CODEC #2 0x0410
#4 BIND #1 "DEPRECATION"
#5 BIND #2 "doc"
#7 CODEC #2 0x0420
```
