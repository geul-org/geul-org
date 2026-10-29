---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE adalah Edge dasar yang menghubungkan satu record atau seluruh dokumen dengan sumbernya (Codec 0x20). Sifat sumber ditulis dengan TRIPLE yang Subject-nya sumber, dan sifat kutipan (tanggal akses, posisi di dalam sumber, hash teks asli) dengan QUALIFIER yang menempel pada SOURCE. SOURCE untuk seluruh dokumen ditaruh di HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE adalah Edge dasar yang menghubungkan satu record (target) atau seluruh dokumen dengan sumber asalnya. Codec `0x20`. Ini satu-satunya kode langsung keluarga dasar (`01`).

Satu reference (kumpulan sumber) Wikidata adalah satu SOURCE. Jika satu record memiliki beberapa sumber, SOURCE-nya juga beberapa.

## Layout

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           record LOCAL Reference
Target            record LOCAL Reference (di BODY, Edge Id Edge yang diberi dasar; di HEAD, 0 = seluruh dokumen)
Origin            record Reference, atau penanda slot 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

- Origin menunjuk sumber. Jika ada Reference yang cocok untuk sumber, itulah yang dipakai (WIKIDATA-QID, DOC-POINTER·EXTERNAL-ISSUER dokumen GEUL, dan lain-lain); jika tidak ada, node LOCAL dokumen ini.
- Jika asal tidak menguraikan sumber (contoh: asal yang hanya memiliki "imported from" (P143) Wikidata dan tanggal akses), Origin adalah [ABSENT](/id/grammar/reference/slot-marker/) (tidak ditulis). Penulis hanya tidak menulis sumber dan tidak menegaskan apa pun tentang sumber itu. Sisa asal tetap ada pada QUALIFIER.
- [UNKNOWN-VALUE](/id/grammar/reference/slot-marker/) hanya dipakai saat penulis menegaskan "sumber ada tetapi tidak diketahui apa" (catatan yang ditulis manusia, dan lain-lain). Konverter yang memindahkan dari materi sumber tidak menegaskan hal yang tidak dikatakan sumber, sehingga memakai ABSENT.
- Origin yang ABSENT·UNKNOWN-VALUE independen pada setiap kemunculan. Sumber dua SOURCE tidak dibaca sama.

## Dua lapisan

Informasi tentang asal dibagi dua. Keduanya tidak dicampur.

| Lapisan | Apa | Cara menulis | Contoh |
|---|---|---|---|
| Sumber | Sifat sumber itu sendiri. Sama siapa pun yang mengutip | [TRIPLE](/id/grammar/edge/triple/) dengan sumber sebagai Subject (rank normal) | URL (P854), judul (P1476), penulis (P50·P2093), tanggal terbit (P577), media terbit (P1433), penerbit (P123), bahasa (P407) |
| Kutipan | Sifat tindakan record ini mengutip sumber | [QUALIFIER](/id/grammar/edge/qualifier/) dengan Edge Id SOURCE sebagai Target | tanggal akses (P813), posisi di dalam sumber (halaman P304, bagian P958, pengenal eksternal P227·P1417), sumber pengambilan (P143), metode inferensi (P887), hash teks asli (P4092) |

- **Makna SOURCE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya.** Dua asal yang mengakses sumber yang sama pada hari berbeda memiliki sumber yang sama dan QUALIFIER yang berbeda.
- TRIPLE sumber adalah penegasan tentang sumber. Sifat yang tidak dapat ditentukan lapisannya ditaruh di sisi kutipan (QUALIFIER). Tidak menegaskan apa pun tentang sumber lebih aman.
- Sumber yang sama dalam satu dokumen dideklarasikan sekali dengan satu LOCAL, dan ditunjuk bersama oleh beberapa SOURCE.
- Sumber yang hanya diuraikan oleh satu URL didefinisikan dengan [REFERENCE-NODE](/id/grammar/edge/reference-node/) (LOCAL → URI). Sama seperti halaman dokumen sitelink.

## Interpretasi dan validitas

- Target dan Origin masing-masing adalah tepat satu record yang lengkap. Kursor setelah membaca Origin harus sesuai dengan akhir Edge.
- Target adalah LOCAL Reference. SOURCE di BODY menunjuk Edge Id di BODY dokumen yang sama. `0` (seluruh dokumen) hanya dipakai oleh SOURCE di HEAD ([sumber seluruh dokumen](#sumber-seluruh-dokumen)). Jika SOURCE dengan Target `0` ada di BODY, invalid. Untuk record dokumen lain, dasar ditempelkan di dalam dokumen itu.
- Origin adalah Reference. Penanda slot hanya `0x0000` (ABSENT)·`0x0001` (UNKNOWN-VALUE) yang diterima. NO-VALUE (`0x0002`)·Value tidak diterima.
- Dokumen spesifikasi geul.org `0x0000/0x0000000000001020` (nama `source`) menaruh [CODEC](/id/grammar/edge/codec/) LOCAL (`0008`) pada Target, dan CODEC `0780` (Reference apa saja)·`0000` (ABSENT, opsional)·`0001` (UNKNOWN-VALUE) pada Origin.
- Urutan antar SOURCE dengan Target yang sama tidak bermakna. Urutan butir dalam satu asal juga tidak bermakna (urutan nilai properti yang sama tersisa sebagai urutan dokumen).
- SOURCE tidak mengubah benar·salahnya target. Ia hanya mencatat dari mana target berasal. Hasil putusan ditangani [TOULMIN](/id/grammar/edge/toulmin/) `VERDICT`.

## Sumber seluruh dokumen

Sumber seluruh dokumen (dump asli, edisi, file teks asli) ditulis dengan **SOURCE dengan Target `0` di HEAD**. QUALIFIER yang Target-nya SOURCE itu (hash teks asli P4092, waktu penerimaan P813, rentang teks asli, dan lain-lain) juga ditaruh di HEAD ([Dokumen](/id/grammar/document/#head-dan-body)).

- Edge yang boleh ditaruh di HEAD hanya dua ini. Edge lain ditaruh di BODY.
- QUALIFIER di HEAD ditaruh setelah SOURCE HEAD yang ditunjuknya. Decoder membaca dari depan dan memisahkan HEAD dan BODY.
- Jika QUALIFIER yang Target-nya SOURCE HEAD ditaruh di BODY, invalid. SOURCE·QUALIFIER di BODY tidak menunjuk Edge HEAD.
- **Edge Id memakai satu ruang nomor bersama HEAD dan BODY.** Unik dalam dokumen, diterima dari [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/) seperti Edge lain, dan saat dibuat ulang dengan isi yang sama nomor yang sama diwarisi. Nomor Edge HEAD tidak dipakai ulang bahkan pada versi tempat Edge itu tidak ada.
- Jika Origin adalah LOCAL, definisinya (REFERENCE-NODE, TRIPLE sumber) ditaruh di BODY. Cakupan LOCAL adalah seluruh dokumen.
- Edge HEAD bukan Meta kelas verifikasi sehingga masuk ke [hash isi](/id/grammar/document/#hash-isi). Pada diff, ia diganti seluruhnya bersama HEAD (tidak ditulis di `DELTA-REMOVE`).
- Tidak ada Meta tersendiri untuk sumber seluruh dokumen. Rentang teks asli·waktu perolehan yang ditulis sebagai Meta tidak dapat ditentukan milik sumber yang mana saat sumbernya banyak. QUALIFIER yang menempel pada SOURCE menentukannya dengan Target.

Contoh: HEAD dokumen Q42 yang dipindahkan dari dump Wikidata (Edge Id hanya untuk penjelasan).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         edisi (revision) entitas
#1741 SOURCE     #0     #1740                                         file dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            hash file
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    waktu penerimaan
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      waktu penyimpanan edisi
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  alamat permanen edisi
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- Edisi dan dump adalah sumber yang berbeda sehingga ada dua SOURCE. Edisi adalah sumber isi (isi yang sama dapat diterima lagi lewat alamat permanen), dan dump adalah file tempat edisi itu diterima. Hash file dan waktu penerimaan adalah sifat sisi kutipan pada file dump sehingga menempel pada SOURCE dump.

## Ungkapan dasar lain

Pada keluarga dasar hanya ada SOURCE. Dasar lain ditulis dengan QUALIFIER.

| Dasar | Cara menulis | Property |
|---|---|---|
| Rentang di dalam teks asli | QUALIFIER pada SOURCE. Satu SOURCE per rentang | halaman P304, bagian P958, kutipan P1683. Rentang karakter adalah istilah GEUL (belum ditetapkan) |
| Waktu menerima materi sumber | QUALIFIER pada SOURCE | tanggal akses P813 |
| Hash byte teks asli (penguncian edisi) | QUALIFIER pada SOURCE | checksum P4092, nilainya [SHA-256-DIGEST](/id/grammar/value/binary/sha-256-digest/), dan lain-lain |
| Pelaku pembuat (manusia, model, mesin aturan) | QUALIFIER pada SOURCE (pelaku pembuat kutipan) atau pada target | istilah GEUL (belum ditetapkan) |
| Tingkat kepercayaan | QUALIFIER pada target | istilah GEUL (belum ditetapkan), nilai 0~1 seperti Meta [CONFIDENCE](/id/grammar/meta/verification/confidence/) |
| Masa berlaku per pasal | QUALIFIER pada target | mulai P580, akhir P582 |
| Record lama sebelum dipindah·dipecah·digabung | QUALIFIER pada target, nilainya Edge Id lama (LOCAL) | P1365 (replaces) |
| Versi tempat pertama kali masuk | Tidak disimpan. Dihitung dari riwayat versi (git blame) | |

## Contoh (non-normatif)

Q42 P19 (tempat lahir) Q350, TRIPLE target `#178`. Dalam dump Wikidata 2026-10-19 pernyataan ini memiliki lima asal; tiga di antaranya ditampilkan. ③ artikel The Telegraph (`#1358`~`#1367`) berbentuk sama dengan ②, dan ⑤ Store norske leksikon (Q746368) sama dengan ①, sehingga dihilangkan.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: tanpa uraian sumber, hanya satu P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② artikel The Guardian #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 yang dideklarasikan sebelumnya (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① tidak memiliki uraian sumber dan P248-nya hanya satu sehingga sumbernya adalah item itu. `#1347` adalah TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- Asal yang hanya satu URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Asal yang hanya "imported from" Wikipedia bahasa Inggris: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` 1 WORD.

## Masalah terbuka

- Istilah GEUL (dokumen definisi istilah dan ID) untuk menyatakan rentang karakter, pelaku pembuat, dan tingkat kepercayaan.
- Jika uraian sumber tidak mengidentifikasi sumber (asal yang hanya berisi bahasa, dan lain-lain), berbagi uraian yang sama dengan satu LOCAL berarti menegaskan sumber yang berbeda sebagai sama.
- Daftar properti sumber·kutipan untuk asal di luar Wikidata (undang-undang, kutipan web).
- Asal dari asal (rantai): apakah SOURCE ditempelkan lagi pada LOCAL sumber.

## Halaman terkait

- [Edge](/id/grammar/edge/), [TRIPLE](/id/grammar/edge/triple/), [QUALIFIER](/id/grammar/edge/qualifier/), [REFERENCE-NODE](/id/grammar/edge/reference-node/), [Penanda slot](/id/grammar/reference/slot-marker/)
- [Dokumen](/id/grammar/document/) (HEAD dan BODY), [Meta — Asal-usul](/id/grammar/meta/provenance/)
