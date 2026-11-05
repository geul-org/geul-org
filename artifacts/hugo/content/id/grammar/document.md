---
title: "Dokumen"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "Satuan data GEUL adalah satu dokumen (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Satuan data GEUL adalah satu dokumen (DOC). Satu berkas (`.geul`, tipe media `application/vnd.geul`) adalah satu dokumen.

## Struktur {#구조}

```
DOC-*            ← membuka dokumen (panjang total)
  Meta …         ← HEAD: record tentang dokumen
  SOURCE …       ←   (asal-usul seluruh dokumen dan QUALIFIER-nya)
BODY             ← mengakhiri HEAD dan membuka BODY
  Reference, Value, Edge …
END              ← menutup dokumen
```

| Record | TAG | Arti |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | membuka dokumen dengan panjang total 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | panjang total 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | panjang total 4 WORD |
| BODY | `1C30` | 1 WORD. Mengakhiri HEAD dan memulai BODY |
| END | `1C40` | 1 WORD. Menutup dokumen |

- Nilai DOC-* adalah jumlah total WORD dari awal record pembuka sampai akhir END. Dipakai lebar tersempit yang memuat nilainya.
- END wajib. Jika posisi END tidak cocok dengan panjang DOC-*, ditolak. Jika input berakhir tanpa END, dokumen terpotong.
- Decoder dapat melewati seluruh dokumen sekaligus dengan panjang DOC-*.
- Tidak ada cara membuka dokumen tanpa mengetahui panjangnya. Data waktu nyata yang ujungnya tidak dapat diketahui sebelumnya dipotong menjadi satuan yang panjangnya diketahui dan dikirim sebagai beberapa dokumen.
- Jika HEAD kosong, BODY dihilangkan. Dokumen tanpa record BODY seluruhnya adalah BODY. BODY hanya diletakkan sekali. Jika HEAD memiliki paling sedikit satu record (Meta atau HEAD Edge), BODY diletakkan.
- Dokumen tidak bersarang. Dokumen lain ditunjuk dengan [IMPORT](meta/_index.md) atau Reference penunjuk.

## HEAD dan BODY {#head와-body}

- Di HEAD hanya ada dua jenis: Meta dan **HEAD Edge**. Keduanya adalah pernyataan tentang **dokumen** yang memuatnya.
  - Meta: struktur, definisi, asal-usul, silsilah, verifikasi, kebijakan, dan IMPORT dokumen.
  - HEAD Edge: Edge dasar [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) yang mencatat sumber asli seluruh dokumen, dan [QUALIFIER](edge/0x0ABL-qualifier.md) yang menjadikan SOURCE itu Target (hash teks asli, waktu penerimaan, rentang teks asli, dan sebagainya). QUALIFIER diletakkan setelah SOURCE tersebut.
- Di BODY hanya ada Reference, Value, dan Edge. Asal-usul setiap record ditulis dengan Edge dasar [SOURCE](edge/0x0C0L-source.md) di dalam BODY, dan dasar lain seperti tingkat kepercayaan ditulis dengan QUALIFIER yang melekat pada record itu. SOURCE dengan Target `0` dan QUALIFIER yang menjadikan SOURCE HEAD sebagai Target tidak boleh diletakkan di BODY.
- Decoder membaca HEAD dari depan sambil memilahnya. Meta adalah HEAD. SOURCE dengan Target `0` adalah HEAD dan Edge Id-nya diingat. QUALIFIER yang menjadikan SOURCE yang diingat itu Target adalah HEAD. Jika datang record lain, bila HEAD kosong maka BODY dihilangkan (BODY dimulai dari record itu), selain itu invalid karena BODY hilang.
- **Edge Id memakai satu ruang nomor bersama untuk HEAD dan BODY.** Unik dalam dokumen, dan seperti Edge di BODY diterima dari [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md). Jika Origin HEAD Edge adalah LOCAL, definisinya diletakkan di BODY (cakupan LOCAL adalah seluruh dokumen).
- Meta dapat memuat record Value di dalam Payload. Value yang dimuat bukan record mandiri, melainkan bagian dari Meta itu.
- Cakupan deklarasi (kelas definisi Meta) adalah dokumen itu.

## Deklarasi dasar {#기본-선언}

Kedua deklarasi paling banyak satu. Dokumen mana yang harus memilikinya ditetapkan oleh syarat di bawah.

| Meta | Arti | Dokumen yang harus memilikinya |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Edisi spesifikasi yang diikuti. Menetapkan cara membaca record lainnya. Jika edisi tidak dikenal, ditolak atau diberi peringatan. Nilai dokumen v1 adalah `0x0001` | Dokumen publikasi. Jika tidak ada, dibaca dengan edisi yang dikenal decoder |
| [DOC-ID](meta/0x1C7L-doc-id.md) | Pengenal dokumen itu sendiri. Harus ada agar dokumen ini dan objek di dalamnya dapat ditunjuk dari luar dokumen | Dokumen versi `docs/<ID dokumen>/`·`codecs/<Codec ID>/` di bawah `.well-known/geul/` (termasuk dokumen spesifikasi). Tidak diletakkan di daftar versi `versions.geul` dan dokumen daftar (`issuers/`) |

- `SPEC-VERSION` hanya memuat satu bilangan bulat agar dapat dibaca decoder edisi mana pun (v1 adalah `1C51 0001`). Tidak bergantung pada kode Value.
- `DOC-ID` adalah DOC-POINTER (Issuer, ID dokumen, versi `0`) yang menunjuk dirinya sendiri. ID dokumen berukuran 4 WORD. Dokumen codec tidak memiliki ID dokumen sehingga memakai [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, versi `0`). Setiap Issuer mencadangkan ID dokumen `0x0000000000000000` dan `0xFFFFFFFFFFFFFFFF` ([Issuer dan publikasi](issuer.md#용어-정의-문서)).
- Dokumen tanpa `DOC-ID` adalah dokumen tanpa nama. Hanya dapat ditunjuk dengan hash isi.

## Hash isi {#내용-해시}

Satu salinan dokumen ditunjuk dengan **hash isi** (berperan sama seperti ID commit di git).

- SHA-256 dari record pembuka (DOC-*) sampai tepat sebelum END. 16 WORD.
- Meta kelas verifikasi (tanda tangan dan sebagainya, record dengan `C >= 5` di bagian 15, yaitu `w >= 0x1E50`) dikeluarkan dari perhitungan. Karena itu tidak terjadi sirkularitas meski tanda tangan diletakkan di dalam dokumen.
- Saat menghitung, panjang DOC-* diganti dengan panjang tanpa record verifikasi, dan lebarnya juga diganti dengan lebar tersempit yang sesuai dengan panjang itu. Karena itu hash isi sebelum dan sesudah tanda tangan ditambahkan sama.
- Hash isi tidak dicatat di dokumen, melainkan dihitung. Nilainya hanya ditulis saat menunjuk versi lain (`PARENT` dan sebagainya).
- `PARENT` dalam dokumen juga masuk perhitungan, sehingga hash isi menjadi rantai hash yang menghubungkan seluruh riwayat.
- Meta yang ditambahkan kemudian dari luar dokumen (anotasi di penyimpanan terpisah dan sebagainya) tidak mengubah hash isi (seperti git notes).
- Biner adalah bentuk kanonis dokumen. Hash isi dan tanda tangan dihitung hanya dari biner.

## Versi {#버전}

Dokumen bernama (dokumen yang memiliki `DOC-ID`) memiliki versi.

- **ID versi** adalah bilangan bulat 2 WORD yang dinomori mulai 1 menurut urutan publikasi dalam satu dokumen. `0` berarti "versi tidak ditulis" dan diperlakukan sebagai versi terbaru.
- ID versi ditetapkan oleh penerbit saat menerbitkan. Korespondensi ID versi dengan hash isi ditaruh di daftar versi yang ditandatangani penerbit ([alamat publikasi dan daftar versi](publishing.md#버전-목록)).
- Isi yang sama tidak diterbitkan ulang. Jika hash isi sudah ada, ID versinya dikembalikan.
- Jika 2 WORD habis, dikeluarkan dengan ID dokumen baru.
- Versi v2 dan seterusnya menulis `PARENT` (hash isi versi sebelumnya) di HEAD. Karena masuk ke hash isi, versi-versi terhubung sebagai rantai hash. Tidak diletakkan pada versi pertama.

## Revisi {#개정}

Dokumen GEUL direvisi seperti undang-undang.

- **Versi tidak dapat diubah.** Versi yang telah diterbitkan tidak diubah atau dihapus. Pengecualiannya hanya penghapusan hukum dan penghapusan oleh otoritas ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- Riwayat tidak dihapus. Isi yang diperbaiki dikeluarkan sebagai versi baru, dan versi asli tidak ditimpa (pelestarian undang-undang lama). Versi yang ditulis ulang menghubungkan versi asli dengan [REPLACES](meta/0x1D7L-replaces.md).
- Penunjuk yang berubah seperti branch, HEAD, dan reflog tidak diletakkan di dokumen. Dikelola di luar dokumen (repositori, indeks).
- Versi baru dapat membuat, merevisi, dan menghapus definisi. Kompatibilitas dengan versi sebelumnya tidak dijanjikan. Perubahan definisi istilah yang sama juga merupakan revisi (contoh: usia dewasa dalam KUH Perdata Korea 20 tahun → 19 tahun, objek tindak pidana pemerkosaan dalam KUHP Korea “부녀” (perempuan) → “사람” (orang)).
- **LOCAL ID adalah identitas lintas versi** (seperti nomor pasal). LOCAL ID yang sama menunjuk objek yang sama meski versinya berbeda.
  - Pembuatan baru: menerima LOCAL ID baru. Karena ID tidak memiliki makna urutan, penyisipan seperti “Pasal X-2” tidak diperlukan. Nomor baru diterima dari `NEXT-LOCAL-ID` di daftar versi (auto increment).
  - Revisi: mengubah isi LOCAL ID yang sama.
  - Penghapusan: mengeluarkan LOCAL ID itu dari versi baru. **ID yang telah dihapus tidak dipakai lagi.**
  - Pemindahan, pemisahan, penggabungan: menerima LOCAL ID baru, dan menghubungkan ID lama dengan menempelkan QUALIFIER P1365 (replaces, nilainya LOCAL ID lama) pada record baru. Karena ID lama tidak dipakai lagi, ia menunjuk record itu pada versi sebelumnya.
- Alat yang membuat ulang dokumen dari bahan sumber juga mematuhi aturan ini. Pernyataan yang sama dengan versi sebelumnya diberi LOCAL ID yang sama, dan nomor baru hanya diberikan pada pernyataan yang berubah atau baru. Tidak boleh menomori ulang dari 1 setiap kali.
- Kutipan menunjuk edisi tertentu. Kutipan yang mengunci versi terikat pada versi itu, dan kutipan terbaru (versi `0`) terikat pada versi yang berlaku saat penafsiran. Dokumen yang membahas peristiwa masa lalu mengutip dengan mengunci versi yang berlaku pada saat itu.
- Publikasi dan pemberlakuan berbeda. Waktu publikasi dicatat daftar versi, periode pemberlakuan dicatat dokumen.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md)·[EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md): periode pemberlakuan seluruh versi
  - QUALIFIER P580 (mulai)·P582 (akhir) pada Edge pasal: jika tanggal pemberlakuan berbeda untuk tiap pasal
- **Edisi yang berlaku pada waktu T adalah versi tertinggi yang tanggal pemberlakuannya T atau sebelumnya.** Jika ada QUALIFIER P580·P582 per pasal, itu diutamakan. Edisi yang masa berlakunya (`EFFECTIVE-UNTIL`) telah lewat tidak berlaku.
- Aturan yang menetapkan edisi mana yang diterapkan, seperti ketentuan peralihan (“berlaku aturan yang lama”) serta pemilihan antara hukum pada saat perbuatan dan hukum baru yang menguntungkan terdakwa, ditangani oleh penilaian ([TOULMIN](toulmin/_index.md)). Informasi pemberlakuan adalah bahan untuk itu.
- Penafsiran resmi dan putusan yang mempersempit atau memperluas penafsiran suatu istilah bukan revisi dokumen, melainkan aturan penilaian. Jika penafsiran ditetapkan melalui perundang-undangan (contoh: penetapan definisi baru “1주” (satu minggu) dalam Undang-Undang Standar Ketenagakerjaan), itu adalah revisi.
- Layout biner (wire) Codec dan nomor Codec tidak direvisi. Alasannya, record yang dienkode dengan nomor Codec dapat dibaca tanpa mengunci versi codebook. Untuk mengubah layout, tetapkan nomor baru. Nomor Codec yang telah dihapus tidak dipakai lagi untuk format lain.

## Penyimpanan diff {#diff-저장}

Versi selalu didefinisikan sebagai seluruh dokumen (snapshot). Diff hanyalah format untuk menyimpan dan mengirim snapshot itu secara lebih ringkas.

- Hanya dokumen yang memiliki `DOC-ID` dan seluruh BODY-nya Edge yang dapat dijadikan diff. Daftar versi `versions.geul` yang tidak memiliki `DOC-ID`, dokumen daftar (versi `issuers/`), dan dokumen tanpa nama tidak memiliki diff.
- Dokumen diff adalah dokumen GEUL biasa, dan di HEAD diletakkan [DELTA-BASE](meta/0x1DBL-delta-base.md) (ID versi dasar).
- Penghapusan ditulis dengan [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (daftar LOCAL ID yang dikeluarkan), dan penambahan serta revisi ditulis dengan Edge di BODY. Tidak ada penanda terpisah untuk penambahan·revisi. Jika Edge Id ada di dasar maka revisi, jika tidak maka penambahan.
- Pemulihan snapshot harus deterministik (agar hash cocok).
  1. Pulihkan snapshot versi dasar. Jika dasarnya juga diff, pulihkan secara rekursif.
  2. HEAD diganti seluruhnya dengan HEAD diff tanpa `DELTA-BASE`·`DELTA-REMOVE`. HEAD Edge ikut berubah (tidak ditulis di `DELTA-REMOVE`).
  3. BODY mempertahankan urutan dasar. ID `DELTA-REMOVE` dikeluarkan, dan jika Edge Id BODY diff ada di dasar, diganti di tempat itu.
  4. Edge Id yang tidak ada di dasar ditambahkan di akhir menurut urutan kemunculan di diff.
  5. Hash isi hasilnya harus sama dengan hash versi ini di daftar versi. Jika berbeda, invalid.
- Jika LOCAL ID yang telah dihapus dipakai lagi di diff, invalid. Edge Id HEAD Edge yang dikeluarkan juga tidak dipakai lagi.
- Hash isi, daftar versi, dan tanda tangan semuanya berdasarkan snapshot yang dipulihkan.
