---
title: "Dokumen"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "Satuan data GEUL adalah dokumen. Dokumen dibuka dengan menetapkan panjang dan ditutup dengan END, serta terbagi atas HEAD (Meta dan sumber seluruh dokumen) dan BODY (Reference·Value·Edge). Setiap versi dikunci dengan hash isi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Satuan data GEUL adalah satu dokumen (DOC). Satu file (`.geul`, media type `application/vnd.geul`) adalah satu dokumen.

## Struktur

```
DOC-*            ← membuka dokumen (panjang total)
  Meta …         ← HEAD: record tentang dokumen
  SOURCE …       ←   (sumber seluruh dokumen dan QUALIFIER-nya)
BODY             ← mengakhiri HEAD dan membuka BODY
  Reference, Value, Edge …
END              ← menutup dokumen
```

| Record | TAG | Arti |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | Membuka dokumen dengan panjang total 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | Panjang total 2 WORD |
| DOC-4WORD | `1A02` + 4 WORD | Panjang total 4 WORD |
| BODY | `180E` | 1 WORD. Mengakhiri HEAD dan memulai BODY |
| END | `180F` | 1 WORD. Menutup dokumen |

- Nilai DOC-* adalah jumlah WORD total dari awal record pembuka sampai akhir END. Pakai lebar tersempit tempat nilainya muat.
- END wajib. Jika posisi END tidak sesuai dengan panjang DOC-*, ditolak. Jika input berakhir tanpa END, itu dokumen yang terpotong.
- Decoder dapat melompati seluruh dokumen sekaligus dengan panjang DOC-*.
- Tidak ada cara membuka dokumen tanpa mengetahui panjangnya. Data waktu nyata yang akhirnya tidak diketahui sebelumnya dipotong menjadi satuan yang panjangnya diketahui dan dikirim sebagai beberapa dokumen.
- Jika HEAD kosong, BODY dihilangkan. Dokumen tanpa record BODY seluruhnya adalah BODY. BODY hanya ditaruh sekali. Jika HEAD memiliki satu saja record (Meta atau Edge HEAD), BODY ditaruh.
- Dokumen tidak bersarang. Dokumen lain ditunjuk dengan [IMPORT](/id/grammar/meta/) atau Reference penunjuk.

## HEAD dan BODY

- Di HEAD hanya ditaruh Meta dan **Edge HEAD**. Keduanya adalah pernyataan tentang **dokumen** yang memuatnya.
  - Meta: struktur·definisi·asal-usul·silsilah·verifikasi·kebijakan·IMPORT dokumen.
  - Edge HEAD: Edge dasar [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) (Target `0`) yang menulis sumber seluruh dokumen, serta [QUALIFIER](/id/grammar/edge/qualifier/) yang Target-nya SOURCE itu (hash teks asli, waktu penerimaan, rentang teks asli, dan lain-lain). QUALIFIER ditaruh setelah SOURCE itu.
- Di BODY hanya ditaruh Reference, Value, dan Edge. Asal setiap record ditulis dengan Edge dasar [SOURCE](/id/grammar/edge/source/) di dalam BODY, dan dasar lain seperti tingkat kepercayaan ditulis dengan QUALIFIER yang menempel pada record itu. SOURCE dengan Target `0` dan QUALIFIER yang Target-nya SOURCE HEAD tidak dapat ditaruh di BODY.
- Decoder memisahkan HEAD sambil membaca dari depan. Meta adalah HEAD. SOURCE dengan Target `0` adalah HEAD dan Edge Id-nya diingat. QUALIFIER yang Target-nya SOURCE yang diingat adalah HEAD. Jika datang record lain, jika HEAD kosong maka BODY dihilangkan (BODY dimulai dari record itu), jika tidak maka invalid karena BODY hilang.
- **Edge Id memakai satu ruang nomor bersama HEAD dan BODY.** Unik dalam dokumen, dan diterima dari [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/) seperti Edge BODY. Jika Origin Edge HEAD adalah LOCAL, definisinya ditaruh di BODY (cakupan LOCAL adalah seluruh dokumen).
- Meta dapat memuat record Value di dalam Payload. Value yang dimuat bukan record mandiri melainkan bagian dari Meta itu.
- Cakupan deklarasi (kelas definisi Meta) adalah dokumen itu.

## Deklarasi dasar

Kedua deklarasi paling banyak satu. Dokumen mana yang wajib memilikinya ditetapkan oleh syarat di bawah.

| Meta | Arti | Dokumen yang harus memilikinya |
|---|---|---|
| [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/) | Edisi spesifikasi yang diikuti. Menetapkan cara membaca record lainnya. Jika edisi tidak dikenal, ditolak atau diberi peringatan. Nilai dokumen v1 adalah `0x0001` | Dokumen terbitan. Jika tidak ada, dibaca dengan edisi yang diketahui decoder |
| [DOC-ID](/id/grammar/meta/declaration/doc-id/) | Pengenal dokumen itu sendiri. Harus ada untuk menunjuk dokumen ini dan target di dalamnya dari luar dokumen | Dokumen yang namanya diawali `0x` di bawah `.well-known/geul/` (dokumen versi, dokumen spesifikasi). Tidak ditaruh pada daftar versi·indeks nama |

- `SPEC-VERSION` hanya memuat satu bilangan bulat agar dapat dibaca decoder edisi mana pun (v1 adalah `1890 0001`). Tidak bergantung pada kode Value.
- `DOC-ID` adalah DOC-POINTER yang menunjuk dirinya sendiri (Issuer, ID dokumen, versi `0`). ID dokumen adalah 4 WORD.
- Dokumen tanpa `DOC-ID` adalah dokumen tanpa nama. Hanya dapat ditunjuk dengan hash isi.

## Hash isi

Satu salinan dokumen ditunjuk dengan **hash isi** (peran yang sama dengan ID commit git).

- Adalah SHA-256 dari record pembuka (DOC-*) sampai tepat sebelum END. 16 WORD.
- Meta kelas verifikasi (tanda tangan, dan lain-lain) dikeluarkan dari perhitungan. Karena itu tidak terjadi sirkularitas walaupun tanda tangan ditaruh di dalam dokumen.
- Saat menghitung, panjang DOC-* diganti dengan panjang tanpa record verifikasi, dan lebarnya juga diganti dengan lebar tersempit yang sesuai dengan panjang itu. Karena itu hash isi sebelum dan sesudah menempelkan tanda tangan sama.
- Hash isi tidak dicatat dalam dokumen melainkan dihitung. Ia ditulis sebagai nilai hanya saat menunjuk versi lain (`PARENT`, dan lain-lain).
- `PARENT` di dalam dokumen juga masuk perhitungan sehingga hash isi menjadi rantai hash yang menyambung seluruh riwayat.
- Meta yang ditempelkan belakangan di luar dokumen (anotasi di penyimpanan terpisah, dan lain-lain) tidak mengubah hash isi (seperti git notes).
- Biner adalah bentuk kanonik dokumen. Hash isi dan tanda tangan dihitung hanya dari biner.

## Versi

Dokumen bernama (dokumen yang memiliki `DOC-ID`) memiliki versi.

- **ID versi** adalah bilangan bulat 2 WORD yang diberi nomor mulai dari 1 menurut urutan publikasi dalam satu dokumen. `0` berarti "versi tidak ditulis" dan diperlakukan sebagai versi terbaru.
- ID versi dialokasikan penerbit saat menerbitkan. Padanan ID versi dan hash isi ditaruh pada daftar versi yang ditandatangani penerbit ([alamat publikasi dan daftar versi](/id/grammar/publishing/#daftar-versi)).
- Isi yang sama tidak diterbitkan ulang. Jika hash isinya sudah ada, ID versi itu dikembalikan.
- Jika 2 WORD habis, dikeluarkan dengan ID dokumen baru.
- Versi v2 dan sesudahnya menulis `PARENT` (hash isi versi sebelumnya) di HEAD. Karena masuk hash isi, versi-versi tersambung sebagai rantai hash. Tidak ditaruh pada versi pertama.

## Revisi

Dokumen GEUL direvisi seperti undang-undang.

- **Versi tidak berubah.** Versi yang sudah diterbitkan tidak diubah atau dihapus. Pengecualiannya hanya penghapusan hukum dan penghapusan atas kewenangan ([TOMBSTONE](/id/grammar/edge/publication/)).
- Riwayat tidak dihapus. Perbaikan dikeluarkan sebagai versi baru dan versi asal tidak ditimpa (pelestarian hukum lama). Versi yang ditulis ulang menyambung ke versi asal dengan [REPLACES](/id/grammar/meta/lineage/replaces/).
- Pointer yang berubah seperti branch, HEAD, dan reflog tidak ditaruh di dokumen. Dikelola di luar dokumen (repositori·indeks).
- Versi baru dapat membuat·merevisi·menghapus definisi. Kompatibilitas dengan versi sebelumnya tidak dijanjikan. Perubahan definisi istilah yang sama juga adalah revisi (contoh: "dewasa" dalam KUH Perdata 20 tahun → 19 tahun, objek tindak pidana pemerkosaan dalam hukum pidana "perempuan" → "orang").
- **LOCAL ID adalah identitas lintas versi** (seperti nomor pasal). LOCAL ID yang sama menunjuk target yang sama walaupun versinya berbeda.
  - Pembuatan: menerima LOCAL ID baru. ID tidak bermakna urutan sehingga penyisipan seperti "Pasal X bis" tidak diperlukan. Nomor baru diterima dari `NEXT-LOCAL-ID` pada daftar versi (auto increment).
  - Revisi: mengubah isi LOCAL ID yang sama.
  - Penghapusan: mengeluarkan LOCAL ID itu dari versi baru. **ID yang dihapus tidak dipakai lagi.**
  - Pemindahan·pemecahan·penggabungan: menerima LOCAL ID baru, dan menyambung ID lama dengan menempelkan QUALIFIER P1365 (replaces, nilainya LOCAL ID lama) pada record baru. ID lama tidak dipakai ulang sehingga menunjuk record itu pada versi sebelumnya.
- Alat yang membuat ulang dokumen dari materi sumber juga mematuhi aturan ini. Pernyataan yang sama dengan versi sebelumnya diberi LOCAL ID yang sama, dan nomor baru hanya diberikan pada pernyataan yang berubah atau baru. Tidak boleh menomori ulang dari 1 setiap kali.
- Kutipan menentukan edisi. Kutipan yang mengunci versi terikat pada versi itu, dan kutipan terbaru (versi `0`) terikat pada versi yang berlaku saat interpretasi. Dokumen yang menangani peristiwa masa lalu mengunci dan mengutip versi yang berlaku pada saat itu.
- Penerbitan dan pemberlakuan berbeda. Waktu penerbitan dicatat daftar versi, dan masa berlaku dicatat dokumen.
  - [EFFECTIVE-FROM](/id/grammar/meta/declaration/effective-from/)·[EFFECTIVE-UNTIL](/id/grammar/meta/declaration/effective-until/): masa berlaku seluruh versi
  - QUALIFIER P580 (mulai)·P582 (akhir) pada Edge pasal: jika tanggal berlaku berbeda per pasal
- **Edisi yang berlaku pada waktu T adalah versi tertinggi yang tanggal berlakunya T atau sebelumnya.** Jika ada QUALIFIER P580·P582 per pasal, itu diutamakan. Edisi yang masa berlakunya (`EFFECTIVE-UNTIL`) sudah lewat tidak berlaku.
- Aturan yang menetapkan edisi mana yang diterapkan, seperti ketentuan peralihan ("tunduk pada ketentuan yang lama") dan pilihan antara hukum saat perbuatan dan hukum baru yang menguntungkan terdakwa, ditangani putusan ([TOULMIN](/id/grammar/edge/toulmin/)). Informasi pemberlakuan adalah bahannya.
- Interpretasi dan preseden yang mempersempit atau memperluas interpretasi istilah bukan revisi dokumen melainkan aturan putusan. Jika interpretasi ditetapkan dengan legislasi (contoh: pembuatan definisi "1 minggu" dalam UU Ketenagakerjaan), itu adalah revisi.
- Layout biner (wire) Codec dan nomor format tidak direvisi. Karena record yang di-encode dengan nomor format dibaca tanpa mengunci versi codebook. Untuk mengubah layout, alokasikan nomor baru. Nomor format yang dihapus tidak dipakai ulang untuk format lain.

## Penyimpanan diff

Versi selalu didefinisikan sebagai dokumen utuh (snapshot). Diff hanyalah format untuk menyimpan·mengirim snapshot itu dalam ukuran lebih kecil.

- Hanya dokumen yang memiliki `DOC-ID` dan seluruh BODY-nya Edge yang dapat dijadikan diff. `versions.geul`·`documents.geul`·`issuers.geul` yang tidak dikelola versinya, serta dokumen tanpa nama, tidak dijadikan diff.
- Dokumen diff adalah dokumen GEUL biasa, dan menaruh [DELTA-BASE](/id/grammar/meta/lineage/delta-base/) (ID versi dasar) di HEAD.
- Penghapusan ditulis dengan [DELTA-REMOVE](/id/grammar/meta/lineage/delta-remove/) (daftar LOCAL ID yang dikeluarkan), sedangkan penambahan dan revisi ditulis dengan Edge di BODY. Tidak ada penanda penambahan·revisi tersendiri. Jika Edge Id ada pada dasar, itu revisi; jika tidak, penambahan.
- Pemulihan snapshot harus deterministik (agar hash cocok).
  1. Pulihkan snapshot versi dasar. Jika dasar juga diff, pulihkan secara rekursif.
  2. HEAD diganti seluruhnya dengan HEAD diff tanpa `DELTA-BASE`·`DELTA-REMOVE`. Edge HEAD juga ikut berubah (tidak ditulis di `DELTA-REMOVE`).
  3. BODY mempertahankan urutan dasar. ID pada `DELTA-REMOVE` dikeluarkan, dan jika Edge Id pada BODY diff ada pada dasar, diganti di posisi itu.
  4. Edge Id yang tidak ada pada dasar ditambahkan di akhir menurut urutan kemunculan di diff.
  5. Hash isi hasilnya harus sama dengan hash versi ini pada daftar versi. Jika berbeda, invalid.
- Jika LOCAL ID yang dihapus dipakai lagi dalam diff, invalid. Edge Id Edge HEAD yang hilang juga tidak dipakai lagi.
- Hash isi, daftar versi, dan tanda tangan semuanya berdasarkan snapshot yang dipulihkan.
