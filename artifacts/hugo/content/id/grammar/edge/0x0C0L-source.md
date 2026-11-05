---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE adalah Edge dasar yang menautkan satu record (target) atau seluruh dokumen ke sumber asalnya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SOURCE` (dokumen spesifikasi BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000C00/` (target DECLARE `0C00`) |
| Bagian | 6 `0110` (Edge dasar), offset dalam bagian C = 0 |
| Kind | Edge · keluarga: dasar |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Menautkan satu record atau seluruh dokumen ke asalnya. Target (Edge Id BODY, di HEAD `0` = seluruh dokumen), Origin (Reference, ABSENT, atau UNKNOWN-VALUE). Sifat sumber ditulis dengan TRIPLE yang bersubjek sumber itu, sifat kutipan (tanggal akses, posisi, hash teks asli) dengan QUALIFIER yang menempel pada SOURCE. SOURCE untuk seluruh dokumen dan QUALIFIER-nya ditaruh di HEAD |
| Sisi Hugo | `edge/source.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan dengan FIELD.

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | record | `0050` LOCAL |  |
| 2 | `origin` | #3 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (field opsional) |  |

SOURCE adalah Edge dasar yang menautkan satu record (target) atau seluruh dokumen ke sumber asalnya. Codec `0x0C0L`. Ini satu-satunya kode langsung keluarga dasar (`01`).

Satu reference (kelompok asal-usul) Wikidata adalah satu SOURCE. Jika satu record punya beberapa asal-usul, SOURCE-nya juga beberapa.

## Layout {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Target            record LOCAL Reference (di BODY: Edge Id dari Edge tempat dasar ditempelkan; di HEAD: 0 = seluruh dokumen)
Origin            record Reference, atau penanda slot 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin menunjuk sumber. Jika ada Reference yang cocok dengan sumber, itulah yang dipakai (WIKIDATA-QID, DOC-POINTER·EXTERNAL-ISSUER dokumen GEUL, dan sebagainya); jika tidak ada, gunakan simpul LOCAL dokumen ini.
- Jika asal-usul tidak menguraikan sumber (misalnya asal-usul yang hanya berisi “imported from” (P143) Wikidata dan tanggal akses), Origin adalah [ABSENT](../slot-marker.md) (tidak ditulis). Penulis hanya tidak menuliskan sumber; ia tidak menegaskan apa pun tentang sumber itu. Sisa asal-usul tetap ada pada QUALIFIER.
- [UNKNOWN-VALUE](../slot-marker.md) dipakai hanya jika penulis menegaskan bahwa “sumber ada tetapi tidak diketahui apa” (catatan yang ditulis manusia, dan sebagainya). Konverter yang memindahkan dari data sumber tidak menegaskan hal yang tidak dikatakan sumber, sehingga memakai ABSENT.
- Origin berupa ABSENT·UNKNOWN-VALUE bersifat independen pada setiap kemunculan. Sumber dua SOURCE tidak dibaca sebagai sama.

## Dua lapis {#두-층}

Informasi tentang asal-usul terbagi dua. Keduanya tidak dicampur.

| Lapis | Apa | Cara menulis | Contoh |
|---|---|---|---|
| Sumber | Sifat sumber itu sendiri. Sama siapa pun yang mengutipnya | [TRIPLE](0x0AAL-triple.md) bersubjek sumber (rank normal) | URL (P854), judul (P1476), penulis (P50·P2093), tanggal terbit (P577), media terbit (P1433), penerbit (P123), bahasa (P407) |
| Kutipan | Sifat tindakan record ini mengutip sumber | [QUALIFIER](0x0ABL-qualifier.md) dengan Edge Id SOURCE sebagai Target | tanggal akses (P813), posisi dalam sumber (halaman P304, bagian P958, pengenal eksternal P227·P1417), asal pengambilan (P143), metode inferensi (P887), hash teks asli (P4092) |

- **Makna SOURCE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya.** Dua asal-usul yang mengakses sumber yang sama pada hari berbeda memiliki sumber yang sama tetapi QUALIFIER yang berbeda.
- TRIPLE sumber adalah pernyataan tentang sumber. Sifat yang lapisannya tidak dapat ditentukan ditaruh di sisi kutipan (QUALIFIER). Tidak menegaskan apa pun tentang sumber lebih aman.
- Dalam satu dokumen, sumber yang sama dideklarasikan sekali sebagai satu LOCAL, dan beberapa SOURCE menunjuknya bersama.
- Sumber yang hanya diuraikan dengan satu URL didefinisikan dengan [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI). Caranya sama dengan halaman dokumen sitelink.

## Interpretasi dan validitas {#해석과-유효성}

- Target dan Origin masing-masing tepat satu record yang lengkap. Kursor setelah membaca Origin harus tepat di akhir Edge.
- Target adalah Reference LOCAL. SOURCE di BODY menunjuk Edge Id di BODY dokumen yang sama. `0` (seluruh dokumen) hanya dipakai oleh SOURCE di HEAD ([sumber seluruh dokumen](#문서-전체의-출처)). Jika di BODY ada SOURCE dengan Target `0`, itu invalid. Untuk record dokumen lain, dasar ditempelkan di dalam dokumen itu.
- Origin adalah Reference. Penanda slot yang diterima hanya `0x0000` (ABSENT)·`0x0010` (UNKNOWN-VALUE). NO-VALUE (`0x0020`) dan Value tidak diterima.
- Dokumen spesifikasi geul.org `0x00000000/codecs/0x00000C00` (nama `source`) menaruh [CODEC](0x0BEL-codec.md) LOCAL (`0050`) pada Target, dan CODEC `000F`·`020F`·`040F` (Reference apa pun)·`0000` (ABSENT, opsional)·`0010` (UNKNOWN-VALUE) pada Origin.
- Urutan antar SOURCE dengan Target yang sama tidak bermakna. Urutan butir dalam satu asal-usul juga tidak bermakna (urutan nilai pada properti yang sama tetap sebagai urutan dokumen).
- SOURCE tidak mengubah benar-salahnya target. Ia hanya mencatat dari mana target berasal. Hasil penilaian menjadi tugas `VERDICT` [TOULMIN](../toulmin/_index.md).

## Sumber seluruh dokumen {#문서-전체의-출처}

Sumber seluruh dokumen (dump asli, edisi, berkas teks asli) ditulis sebagai **SOURCE dengan Target `0` di HEAD**. QUALIFIER yang menjadikan SOURCE itu Target-nya (hash teks asli P4092, waktu penerimaan P813, cakupan teks asli, dan sebagainya) juga ditaruh di HEAD ([dokumen](../document.md#head와-body)).

- Edge yang boleh ditaruh di HEAD hanya kedua ini. Edge lain ditaruh di BODY.
- QUALIFIER di HEAD ditaruh setelah SOURCE HEAD yang ditunjuknya. Dekoder membaca dari depan dan memisahkan HEAD dari BODY.
- Menaruh QUALIFIER yang bertarget SOURCE HEAD di BODY adalah invalid. SOURCE·QUALIFIER di BODY tidak menunjuk Edge di HEAD.
- **Edge Id memakai satu ruang nomor untuk HEAD dan BODY.** Unik dalam dokumen, diterima dari [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) seperti Edge lain, dan jika dibuat ulang dengan isi yang sama, nomor yang sama diwarisi. Pada versi tanpa Edge HEAD tertentu pun, nomor itu tidak dipakai lagi.
- Jika Origin adalah LOCAL, definisinya (REFERENCE-NODE, TRIPLE sumber) ditaruh di BODY. LOCAL berlingkup seluruh dokumen.
- Edge HEAD bukan Meta kelas verifikasi, sehingga masuk ke [hash isi](../document.md#내용-해시). Pada diff, ia berubah utuh bersama HEAD (tidak ditulis di `DELTA-REMOVE`).
- Tidak ada Meta tersendiri untuk sumber seluruh dokumen. Cakupan teks asli dan waktu perolehan yang ditulis sebagai Meta tidak dapat menentukan sumber mana yang dimaksud ketika sumbernya banyak. QUALIFIER yang menempel pada SOURCE menentukannya melalui Target.

Contoh: HEAD dokumen Q42 yang dipindahkan dari dump Wikidata (Edge Id hanya untuk penjelasan).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         versi entitas (revision)
#1741 SOURCE     #0     #1740                                         berkas dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            hash berkas
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    waktu penerimaan
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      waktu penyimpanan versi
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  alamat permanen versi
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- Versi dan dump adalah sumber yang berbeda sehingga ada dua SOURCE. Versi adalah sumber isi (isi yang sama dapat diterima kembali lewat alamat permanen), dan dump adalah berkas tempat versi itu diterima. Hash berkas dan waktu penerimaan adalah sifat sisi kutipan tentang berkas dump, sehingga ditempelkan pada SOURCE dump.

## Ungkapan dasar lain {#다른-근거의-표현}

Pada keluarga dasar hanya ada SOURCE. Dasar lain ditulis dengan QUALIFIER.

| Dasar | Cara menulis | Property |
|---|---|---|
| Cakupan dalam teks asli | QUALIFIER pada SOURCE. Satu SOURCE per satu cakupan | halaman P304, bagian P958, kutipan P1683. Cakupan karakter adalah istilah GEUL (belum ditetapkan) |
| Waktu data sumber diterima | QUALIFIER pada SOURCE | tanggal akses P813 |
| Hash byte teks asli (penguncian edisi) | QUALIFIER pada SOURCE | checksum P4092, nilainya [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) dan sebagainya |
| Pelaku pembuat (manusia, model, mesin aturan) | QUALIFIER pada SOURCE (pelaku pembuat kutipan) atau pada target | istilah GEUL (belum ditetapkan) |
| Tingkat keyakinan | QUALIFIER pada target | istilah GEUL (belum ditetapkan), nilainya 0~1 seperti Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| Masa berlaku per pasal | QUALIFIER pada target | mulai P580, akhir P582 |
| Record lama sebelum dipindah, dipecah, atau digabung | QUALIFIER pada target, nilainya Edge Id lama (LOCAL) | P1365 (replaces) |
| Versi yang pertama masuk | Tidak disimpan. Dihitung dari riwayat versi (git blame) | |

## Contoh (nonnormatif) {#예시-비규범}

Q42 P19 (tempat lahir) Q350, TRIPLE target `#178`. Dalam dump Wikidata 2026-10-19, proposisi ini memiliki lima asal-usul, tiga di antaranya ditunjukkan. ③ artikel Telegraph (`#1358`~`#1367`) berbentuk sama dengan ②, dan ⑤ Store norske leksikon (Q746368) sama dengan ①, sehingga dihilangkan.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: hanya satu P248 tanpa uraian sumber
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

- ① tidak punya uraian sumber dan P248 hanya satu, sehingga sumbernya adalah butir itu. `#1347` adalah TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- Asal-usul yang hanya satu URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Asal-usul yang hanya “imported from” Wikipedia bahasa Inggris: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` 1 WORD.

## Masalah terbuka {#열린-문제}

- Istilah GEUL untuk menyatakan cakupan karakter, pelaku pembuat, dan tingkat keyakinan (dokumen definisi istilah dan ID-nya).
- Jika uraian sumber tidak dapat mengidentifikasi sumber (asal-usul yang hanya berisi bahasa, dan sebagainya), berbagi uraian yang sama lewat satu LOCAL berarti menegaskan bahwa sumber yang berbeda adalah sama.
- Daftar properti sumber dan kutipan untuk asal-usul di luar Wikidata (undang-undang, kutipan web).
- Asal-usul dari asal-usul (rantai): apakah SOURCE ditempelkan lagi pada LOCAL sumber.

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [penanda slot](../slot-marker.md)
- [Dokumen](../document.md) (HEAD dan BODY), [Meta — asal-usul](../meta/_index.md#출처)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000C00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
