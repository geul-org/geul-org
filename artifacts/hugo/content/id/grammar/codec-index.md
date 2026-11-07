---
title: "Indeks Kode"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Halaman ini adalah indeks seluruh Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Halaman ini adalah indeks seluruh Codec. Klik sebuah nama untuk menuju dokumen rincian Codec itu. Kode langsung yang tidak ada dalam tabel adalah Reserved.

## Kind {#kind}

TAG WORD berbentuk `000K KKKC CCCC LLLL`. 4 bit atas `KKKK` adalah bagian, `C` adalah offset 5 bit dalam bagian, dan `LLLL` adalah Length. 9 bit gabungan bagian dan `C` adalah posisi Codec. TAG ID ditulis sebagai `0x000L`. Tiga digit depan adalah 9 bit ini (`w >> 4`), dan `L` adalah posisi Length ([Record dan TAG WORD](record.md)).

| Bagian | TAG ID | Klasifikasi | Penjelasan |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | record yang menunjuk objek |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | record nilai |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | record penyusun |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | record tentang dokumen dan record |

- Bagian adalah `S = w >> 9` (4 bit), dan satu bagian terdiri dari 32 slot.
- Kind ditentukan oleh satu rentang bagian: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, sisanya Meta. Tidak ada pengecualian.
- Tiga slot terakhir pada wilayah Reference, Value, dan Edge adalah ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta tidak memiliki ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Nama | Klasifikasi | ID objek |
|---|---|---|---|
| `0x000L~0x002L` | [Penanda slot](slot-marker.md) | penanda slot | kelompok penanda 1 WORD yang tidak menunjuk objek (tabel di bawah) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | deklarasi | ID yang diterbitkan dokumen ini |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | deklarasi | entitas yang diterbitkan geul.org sebagai CC0. Nomor kecil dialokasikan untuk entitas berfrekuensi tinggi |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | deklarasi | GEUL SIDX (Semantic-aligned Index). Pengenal yang bit-nya memuat makna |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | deklarasi | entri Wikidata. Bilangan bulat setelah `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | deklarasi | properti Wikidata. Bilangan bulat setelah `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | penunjuk | ID LOCAL dokumen yang diambil dengan `IMPORT-DOC`. ID IMPORT 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | penunjuk | sama seperti di atas. ID IMPORT 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | penunjuk | sama seperti di atas. ID IMPORT 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | penunjuk-deklarasi | ID LOCAL dokumen Issuer 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | penunjuk-deklarasi | ID LOCAL dokumen Issuer 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | penunjuk-deklarasi | ID LOCAL dokumen Issuer 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | penunjuk-deklarasi | Issuer itu sendiri. Payload hanya Issuer (2/4/16 WORD) dan tidak ada ID objek |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | penunjuk-deklarasi | satu versi dokumen Issuer. Issuer + ID dokumen 4 WORD + ID versi 2 WORD, tidak ada ID objek |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | penunjuk-deklarasi | satu versi Codec Issuer. Issuer + ID Codec 2 WORD + ID versi 2 WORD, tidak ada ID objek |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | deklarasi | satu entri kosakata token GEUL (ID token 0~65.535). Payload 1 WORD, total 2 WORD |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | deklarasi | sama seperti di atas. ID token 65.536~131.071 (65.536 + Payload) |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | format Issuer | Issuer 2 WORD dan nomor Codec 2 WORD. Klasifikasi dan objek ditentukan dokumen Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | format Issuer | Issuer 4 WORD dan nomor Codec 2 WORD. Sama seperti di atas |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | format Issuer | Issuer 16 WORD dan nomor Codec 2 WORD. Sama seperti di atas |

- Reference terdiri dari tiga bagian. Bagian 0 entitas `0x000L~0x01FL` (penanda slot, sistem 5Q), bagian 1 EXTERNAL `0x020L~0x03FL`, bagian 2 lainnya `0x040L~0x05FL` (penunjuk, REFERENCE-ISSUER). Reserved adalah `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL`, `0x045L~0x05CL`.
- Kelompok 5 slot (dari LOCAL sampai EXTERNAL-ISSUER-16WORD) masing-masing satu slot menurut urutan Quantifier di bawah. Contoh: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Penanda slot (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Penanda slot](slot-marker.md). Hanya muncul pada suatu posisi jika daftar CODEC pada field mencantumkan WORD itu secara persis.

| WORD | Nama | Arti | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | tidak ditulis. Field opsional dihilangkan. Tidak menyatakan apa pun tentang dunia | tidak ada snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | tidak diketahui. Nilainya ada tetapi tidak diketahui | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | tidak ada. Tidak ada nilai | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Nama | Makna | Contoh |
|---|---|---|---|
| `0` | Identified | entitas yang teridentifikasi | Elon Musk, Korea Selatan |
| `1` | Generic | pernyataan umum atau definitif tentang seluruh jenis. Mengizinkan pengecualian. | prajurit mematuhi perintah |
| `2` | Free-choice | objek mana pun yang memenuhi syarat | prajurit mana saja |
| `3` | Universal | semua objek dalam cakupan yang diberikan | semua prajurit |
| `4` | Variable | variabel wacana | orang itu, perempuan ini |

- Kuantifikasi dibaca dari offset `C` dalam bagian. Pada bagian 0, jika `5 <= C < 30`, kuantifikasi adalah `C % 5` dan sistem adalah `C / 5` (1~5). Pada bagian 1, jika `C < 30`, kuantifikasi adalah `C % 5` dan sistem adalah `6 + C / 5` (6~11). Tidak dipakai untuk penanda (bagian 0, `C < 3`) dan bagian 2 (penunjuk, REFERENCE-ISSUER).
- ISSUER-POINTER, DOC-POINTER, dan CODEC-POINTER adalah satu slot tanpa kuantifikasi. Kuantifikasi REFERENCE-ISSUER ditentukan oleh dokumen Codec yang diterbitkan Issuer.

## Issuer {#issuer}

Issuer adalah pihak yang mendefinisikan dokumen dan format — [Issuer dan publikasi](issuer.md)

| Posisi | Arti |
|---|---|
| Kode ISSUER Reference·Value·Edge (tiga slot terakhir tiap wilayah) | format yang didefinisikan Issuer itu |
| Meta `DOC-ID` | Issuer yang menerbitkan dokumen ini |
| Meta `IMPORT-DOC` | Issuer yang menerbitkan dokumen yang diambil |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | Issuer yang menerbitkan dokumen atau Codec yang ditunjuk (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Issuer yang ditunjuk itu sendiri (2/4/16 WORD) |

| Lebar Issuer | Penerbitan |
|---|---|
| 2 WORD | terdaftar di geul.org. Issuer yang telah melalui bukti kepemilikan domain (mis. company.com). Nomor yang dialokasikan geul.org kepada lembaga penetap standar dan lembaga utama juga berlebar ini ([tabel alokasi 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | terdaftar di geul.org. Issuer yang didaftarkan tanpa bukti kepemilikan |
| 16 WORD | diterbitkan sendiri. Dihitung dari kunci publik tanpa pendaftaran. Mengikuti aturan pembentukan di bawah. |

### Algoritma tanda tangan Issuer 16 WORD {#16-word-issuer-서명-알고리즘}

| ID algoritma tanda tangan | Algoritma |
|---|---|
| `0x0001` | Ed25519 |
| Lainnya | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

Keluarga kode langsung adalah `(kode − 0xA0) >> 5` (kode adalah tiga digit depan TAG ID). Satu keluarga terdiri dari 32 slot dan sama dengan bagian `w >> 9` dikurangi 5. Kode langsung yang dialokasikan adalah lima keluarga di bawah. `0x135L~0x1BCL` adalah Reserved (bagian 10~12 seluruhnya Reserved). Format Issuer tidak memiliki aturan keluarga.

| Bagian | Keluarga | Kode langsung |
|---|---|---|
| 5 | pernyataan | `0x0A0L~0x0BFL` |
| 6 | dasar | `0x0C0L~0x0DFL` |
| 7 | eksekusi | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | format [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` adalah Reserved.
- `0x1BDL~0x1BFL` (tiga slot terakhir bagian 13) adalah EDGE-ISSUER (format ISSUER Edge di bawah).

### Pernyataan (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Nama | Subformat | Penjelasan |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | pengikatan berarah yang Subject-nya berupa Reference menunjuk Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | identitas: dua Reference menunjuk objek yang sama |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | non-identitas: dua Reference menunjuk objek yang berbeda |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | mengikat nama yang dicocokkan mesin (`UTF8-TEXT-*`) pada Subject. Unik dalam cakupan dan harus cocok persis, tanpa bahasa |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | menghubungkan nama berbahasa (label) Subject. Object adalah UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | menghubungkan nama lain (alias) Subject. Tata letaknya sama dengan LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | menghubungkan deskripsi (description) berbahasa Subject. Tata letaknya sama dengan LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | pernyataan verba ringkas |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | pernyataan verba |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | proposisi berurutan Predicate, Subject, Object beserta rank. Object adalah nilai atau penanda UNKNOWN-VALUE·NO-VALUE. Maknanya adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | satu syarat yang membatasi proposisi Edge lain. Property, Target (Edge Id), Value (nilai atau penanda UNKNOWN-VALUE·NO-VALUE). Bagian dari proposisi |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | ada | struktur untuk menyatakan pandangan dunia |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | ada | struktur yang menyatakan urutan dunia dan peristiwa |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | ada | struktur adegan untuk menyatakan karakteristik skenario |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | publikasi dokumen. DOC-POINTER, hash isi |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | deprecate versi yang telah dipublikasikan. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | penghapusan (nisan) versi yang telah dipublikasikan. DOC-POINTER, kategori alasan |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | deklarasi komposisi Payload satu Codec. Kind·Codec sasaran |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | satu field Payload. DECLARE tempatnya, lebar: record (Length TAG) atau nilai mentah n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | satu nilai kode pada field nilai mentah. Field, nilai kode |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | satu Kind·Codec yang diterima field. Field, WORD sasaran (`000K KKKC CCCC LLLL`, LLLL 0000 persis, 1111 wildcard (seluruh 32 slot bagian itu), penanda slot hanya sebagai sasaran persis `0000`·`0010`·`0020`). Field record boleh berjumlah banyak (daftar tertutup), field nilai mentah satu (Value tanpa TAG itu) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Kelompok |
|---|---|
| `0x0A0L~0x0A7L` | penunjukan dan nama |
| `0x0A8L~0x0AFL` | proposisi |
| `0x0B0L~0x0B7L` | struktur |
| `0x0B8L~0x0BFL` | lainnya |

### Dasar (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Nama | Subformat | Penjelasan |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | menghubungkan satu record atau seluruh dokumen dengan sumbernya. Target (Edge Id BODY, pada HEAD `0` = seluruh dokumen), Origin (Reference, ABSENT atau UNKNOWN-VALUE). Sifat sumber ditulis dengan TRIPLE yang Subject-nya sumber, sifat kutipan (tanggal akses, posisi, hash teks asli) dengan QUALIFIER yang melekat pada SOURCE. SOURCE untuk seluruh dokumen beserta QUALIFIER-nya ditaruh di HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- Rentang teks asli, pembuat, tingkat kepercayaan, masa berlaku per pasal, dan record lama ditulis dengan QUALIFIER, sedangkan versi yang pertama masuk dihitung dari riwayat versi ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Eksekusi (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | deklarasi fungsi. Simbol, daftar simbol parameter, tipe kembalian, badan (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | deklarasi tipe. Simbol dan komposisi (daftar simbol field, nilai enumerasi, sasaran alias) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | ekspresi konstanta. Satu Value tertanam |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | ekspresi unar. Operator 1 WORD, operan |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | ekspresi biner. Operator 1 WORD, kiri, kanan |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | pemanggilan. Fungsi sasaran, jumlah argumen, argumen × jumlah argumen |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | akses anggota. Sasaran, simbol field |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | akses indeks. Sasaran, indeks |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | pembuatan nilai majemuk (daftar, record). Tipe, jumlah elemen, elemen × jumlah elemen |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | ekspresi kondisional. Kondisi, nilai jika benar, nilai jika salah |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | kelompok pernyataan berurutan. Jumlah pernyataan, pernyataan × jumlah pernyataan |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | penugasan. Sasaran (simbol, MEMBER, INDEX), nilai |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | percabangan kondisional. Kondisi, BLOCK jika benar, cabang salah (BLOCK·IF, 0 jika tidak ada) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | percabangan majemuk. Sasaran, jumlah cabang, (nilai, BLOCK) × jumlah cabang, BLOCK default (0 jika tidak ada) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | pengulangan bersyarat. Kondisi, BLOCK badan |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | pengulangan iterasi. Simbol elemen, sasaran, BLOCK badan |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | kendali pengulangan. Jenis 1 WORD (break, continue), pengulangan sasaran |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | kembalian. Nilai (0 jika tidak ada) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | memunculkan kesalahan. Nilai kesalahan |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | penanganan kesalahan. BLOCK badan, simbol kesalahan, BLOCK penanganan, BLOCK penutup (0 jika tidak ada) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Kelompok |
|---|---|
| `0x0E0L~0x0E7L` | deklarasi |
| `0x0E8L~0x0EFL` | ekspresi |
| `0x0F0L~0x0F7L` | pernyataan |
| `0x0F8L~0x0FFL` | kesalahan |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

Selengkapnya: [TOULMIN](toulmin/_index.md)

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | deklarasi kasus. Graf penilaian yang memuat node dan relasi |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | deklarasi predikat. Fungsi·ekspresi penilaian, kriteria penilaian (Spec), kontrak fakta (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | deklarasi kriteria penilaian. Konstanta·daftar (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | deklarasi klaim. Menempatkan predikat dalam kasus sebagai aturan umum (Warrant). Dapat diserang. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | deklarasi sanggahan. Menyerang dengan kesimpulannya sendiri. Level default adalah Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level default adalah Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | relasi serangan. Penilaian penyerang mengurangi penilaian sasaran secara bertahap. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | relasi penyisihan. Jika penyerang Active, sasaran dikeluarkan secara pasti dari agregasi. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | rantai prioritas `A > B > C`. Singkatan dari SUPERSEDES berpasangan. Tata letak belum ditentukan |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | komposisi eksekusi. Jika node Active, kasus bawahan dieksekusi (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | aksi yang dilakukan jika node Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | aksi yang dilakukan hanya sekali meskipun dicoba ulang |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | aksi kompensasi DO (saga). Jika langkah berikutnya gagal, dilakukan dalam urutan terbalik. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | koneksi yang hanya menilai tanpa efek samping |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | titik masuk eksternal. Mengeksekusi atau menilai kasus |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | titik masuk peristiwa·periodik tanpa pemanggilan eksternal |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | hasil penilaian node·record. Hasil (Pass, Review, Fail), nilai penilaian, Activated, Excluded, Level. Tata letak belum ditentukan. Penilaian seluruh dokumen ada pada Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | bukti penilaian. Posisi, nilai yang diharapkan, nilai aktual (Fact). Tata letak belum ditentukan |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Kelompok |
|---|---|
| `0x100L~0x107L` | deklarasi |
| `0x108L~0x10FL` | relasi |
| `0x110L~0x117L` | eksekusi |
| `0x118L~0x11FL` | hasil (`0x11CL~0x11FL` adalah Reserved) |

### Format TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

Node dan relasi pembantu, pembagian, dan teks asli dokumen [TOULMIN](toulmin/_index.md).

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | teks asli penulisan. Lebar SPAN dan Value UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | nama·string |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | awal bagian. Kode bagian |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | awal rentang kasus |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | akhir rentang kasus |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | paragraf uraian (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. rujukan fungsi |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. kelompok eksekusi berurutan |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. kasus → field |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. butir definisi → nilai·tipe |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. butir definisi → field |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. titik masuk → kasus, eksekusi |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. titik masuk → kasus, penilaian |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. trigger → kasus |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. trigger → kasus (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. node → pengenal global |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. alias → path (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. node → TEXT, penulisan nama |

- `0x135L~0x1BCL` adalah Reserved.

### Format ISSUER Edge {#edge-issuer-형식}

Setelah `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)), TAG ekstensi Codec menempatkan Issuer dan nomor Codec 2 WORD. Saat ini tidak ada format ISSUER Edge yang terdaftar.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Nomor Value tidak menyatakan keluarga. Kode langsung ditempatkan tanpa Reserved pada `0x060L~0x081L`. `0x082L~0x09CL` adalah Reserved, dan `0x09DL~0x09FL` adalah VALUE-ISSUER. Nama keluarga (NUMERIC, DECIMAL, TIME, TEXT, BINARY) adalah kelompok topik. Pasangan genap·ganjil dimulai dari kode genap.

| Keluarga | Kode langsung |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Kode langsung {#직접-코드}

| Codec | Nama | Keluarga | Penjelasan |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false atau true, tetap 1 WORD |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | bilangan bulat bertanda komplemen dua WORD minimum |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | bilangan bulat unsigned magnitude big-endian WORD minimum |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | scalar IEEE 754 binary16/32/64/128 dengan Payload 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | lintang·bujur Bumi (WGS 84) binary64, ketidakpastian binary32 dan Reference satuannya (ABSENT = tidak diketahui) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference benda langit dan lintang·bujur binary64, ketidakpastian binary32 dan Reference satuannya |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | Value numerik amount (bilangan bulat·BINARY-FLOAT·desimal·pecahan), Reference satuan, batas bawah·atas. Satuan·batas boleh dihilangkan (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | pecahan yang mempertahankan notasi asli: pembilang bilangan bulat·desimal, penyebut bilangan bulat unsigned·desimal. Tidak disederhanakan |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` dari signed exponent `E` dan coefficient `C` komplemen dua WORD minimum |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` dari signed exponent `E` dan coefficient unsigned `C` WORD minimum |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | jumlah hari bertanda berdasarkan `1970-01-01` proleptic Gregorian |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | hitungan nanosecond unsigned setelah tengah malam hari sipil |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | hitungan detik bertanda sejak epoch Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | waktu berlalu SI-second bertanda tanpa epoch |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | string tanggal EDTF (ISO 8601-2). Byte genap·ganjil. Tanggal yang dapat ditulis sebagai GREGORIAN-DATE tidak ditulis dengan ini |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | string nilai tanggal GEDCOM 7. Mempertahankan notasi asli kalender lain (Julian dll.). Byte genap·ganjil |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | deretan byte UTF-8 valid tanpa implikasi normalisasi. Byte genap |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | sama seperti di atas. Byte ganjil |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | deretan byte ASCII production `URI` RFC 3986. Byte genap |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | sama seperti di atas. Byte ganjil |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | deretan byte ASCII tag bahasa BCP 47 lengkap dengan canonical casing. Byte genap |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | sama seperti di atas. Byte ganjil |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | teks berbahasa. Record Value bahasa (LANGUAGE-SHORT-CODE atau LANGUAGE-BCP47-CODE) dan byte UTF-8. Genap·ganjil menurut byte teks |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | tag BCP 47 yang ditulis dengan nomor GEUL Language Registry (Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID 128 bit RFC 9562 dengan Payload tetap 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | hasil SHA-256 dengan Payload tetap 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | hasil SHA-1 dengan Payload tetap 10 WORD. Hanya untuk keperluan identifikasi seperti ID objek git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | deretan byte yang makna·formatnya tidak diketahui. Byte genap |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | sama seperti di atas. Byte ganjil |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N bit yang disimpan MSB-first setelah bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | waktu berlalu nanosecond bertanda tanpa epoch |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | format yang didefinisikan Issuer. Lihat format ISSUER Value di bawah |

### Format ISSUER Value {#value-issuer-형식}

Setelah `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)), TAG ekstensi Codec menempatkan Issuer dan nomor Codec 2 WORD. Dokumen Codec ditaruh di bawah `codecs/` milik Issuer itu dengan nomor Codec record. Contoh: IETF CRC32C berada di `0x00000007/codecs/0x0000C000/` ([Alamat publikasi dan daftar versi](publishing.md)).

| Issuer | Nomor Codec | Nama | Penjelasan |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | BF16 interchange bits dengan Payload tetap 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | vector int16 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | vector uint16 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | vector int32 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | vector uint32 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | vector int64 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | vector uint64 big-endian kontigu |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | vector IEEE 754 binary16 kontigu |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | vector BF16 kontigu |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | vector IEEE 754 binary32 kontigu |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | vector IEEE 754 binary64 kontigu |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | vector 2 dimensi IEEE binary64 berurutan `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | vector 3 dimensi IEEE binary64 berurutan `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | vector IEEE binary64 berurutan `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format·rank·shape dan payload dense C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format·rank·shape dan payload packed low-bit-first dalam octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | dua binary32 berurutan `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | dua binary64 berurutan `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | numerator int64 ternormalisasi dan denominator int64 positif |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | interval tertutup binary64 dengan `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | empat binary32 berurutan `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | hasil BLAKE3 default dengan Payload tetap 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | deretan byte ASCII relative-ref RFC 3986. Byte genap |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | sama seperti di atas. Byte ganjil |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | hasil CRC-32C Castagnoli dengan Payload tetap 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | alamat IPv4 32 bit dengan Payload tetap 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | alamat IPv6 128 bit dengan Payload tetap 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD dengan Payload tetap 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD dengan Payload tetap 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD dengan Payload tetap 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID dengan Payload tetap 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID dengan Payload tetap 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID dengan Payload tetap 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | hitungan nanosecond bertanda sejak epoch Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | alamat MAC IEEE 802 48 bit dengan Payload tetap 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | packed vector 4×UNORM8 tetap berurutan R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | packed vector 4×UNORM8 tetap berurutan B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | scalar ONNX E4M3FN pada octet atas Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | scalar ONNX E4M3FNUZ pada octet atas Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | scalar ONNX E5M2 pada octet atas Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | scalar ONNX E5M2FNUZ pada octet atas Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | scalar E8M0FNU unsigned exponent-only pada octet atas Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | scalar ONNX/DLPack E2M1FN pada nibble atas Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | hitungan SI-second bertanda sejak `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | hitungan nanosecond bertanda sejak epoch TAI yang sama |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | hasil SHA-512 dengan Payload tetap 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | hasil SHA3-256 dengan Payload tetap 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | hitungan second bertanda sejak epoch GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | hitungan nanosecond bertanda sejak epoch GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Nomor Meta tidak menyatakan kelas lewat bit. Kelas diketahui dari tabel rentang di bawah. Kelas verifikasi adalah record pada bagian 15 dengan `C >= 5`, yaitu `w >= 0x1E50`, yang diketahui tanpa codebook. Meta tidak memiliki kode ISSUER.

| Kelas | Kode langsung | Yang ditangani |
|---|---|---|
| [struktur](meta/_index.md#구조) | `0x1C0L~0x1C4L` | batas dan panjang dokumen |
| [definisi](meta/_index.md#정의) | `0x1C5L~0x1CAL` | deklarasi penafsiran |
| [asal-usul](meta/_index.md#출처) | `0x1CBL~0x1D0L` | siapa, kapan, di mana |
| [silsilah](meta/_index.md#계보) | `0x1D1L~0x1DDL` | berasal dari apa dan bagaimana |
| [kebijakan](meta/_index.md#정책) | `0x1DEL~0x1E3L` | bagaimana diperlakukan |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | mengambil dokumen eksternal dengan ID IMPORT (`IMPORT-DOC`) |
| [verifikasi](meta/_index.md#검증) | `0x1E5L~0x1E9L` | dapatkah dipercaya |
| Reserved (khusus verifikasi) | `0x1EAL~0x1FFL` |  |

- Nomor berlanjut dari `0x1C0L` tanpa Reserved. Meta baru di luar verifikasi tidak dapat disisipkan sebelum verifikasi. Reserved di belakang `0x1EAL~0x1FFL` khusus verifikasi. Jika Meta di luar verifikasi ditaruh di sini, ia terlewat dari hash isi.

### Struktur (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | awal dokumen dengan panjang total ditetapkan pada Payload 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | awal dokumen dengan panjang total ditetapkan pada Payload 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | awal dokumen dengan panjang total ditetapkan pada Payload 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Mengakhiri HEAD dokumen dan memulai BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Menutup dokumen. |

### Definisi (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | edisi spesifikasi GEUL yang diikuti. Payload itu sendiri adalah bilangan bulat unsigned dengan lebar terpendek. v1 adalah `0x0001` (record `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | profil yang diterapkan |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | pengenal dokumen ini. Reference tertanam `DOC-POINTER` (Issuer, ID dokumen, versi 0). Dokumen Codec memakai `CODEC-POINTER` (Issuer, ID Codec, versi 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | tanggal berlaku versi ini. Value GREGORIAN-DATE atau POSIX-TIMESTAMP. Jika tidak ada, waktu publikasi |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | akhir masa berlaku versi ini (peraturan berjangka). Jika tidak ada, sampai versi berikutnya berlaku |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | bahasa default |

### Asal-usul (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | penulis. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | penulis bersama. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | waktu penulisan. Value TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | waktu modifikasi. Value TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | pihak yang mencatat. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | waktu pencatatan. Value TIME (git commit date) |

- Bahan sumber beserta rentang, waktu perolehan, dan hash-nya ditulis bukan dengan Meta, melainkan dengan Edge dasar [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) pada HEAD (Target `0`) dan QUALIFIER-nya.

### Silsilah (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | hash isi versi sebelumnya (git parent). Jika tidak ada, ini versi pertama, dan jika banyak, ini penggabungan (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | diturunkan dari record·bahan garis silsilah lain. Untuk mengunci pada versi tertentu bahan eksternal, lekatkan QUALIFIER hash teks asli (P4092) pada [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) di HEAD (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | pihak pembuat. Manusia, model, mesin aturan |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | metode transformasi. Alat·aturan·versi |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | hash isi versi asal yang perubahannya diambil dari garis silsilah lain (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | hash isi versi sasaran yang perubahannya dibatalkan (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | hash isi versi sasaran yang ditulis ulang (git amend·rebase). Versi asal tidak dihapus. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | hash isi versi-versi asal yang digabung menjadi satu (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | alasan perubahan. Value UTF8-LANGUAGE-TEXT, satu per bahasa (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | nama tak berubah yang dilekatkan pada versi. Value TEXT dan hash isi (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | file versi ini adalah diff terhadap versi dasar dokumen yang sama (ID versi 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | daftar ID LOCAL (Edge Id) yang dikeluarkan dari BODY dasar pada diff |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | ID LOCAL yang akan dialokasikan berikutnya (auto increment). Ditaruh di HEAD daftar versi `versions.geul` |

### Kebijakan (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | lisensi. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | cakupan publik |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | tingkat data pribadi |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | batas penyimpanan |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | cakupan dan dasar persetujuan |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | pembatasan penggunaan |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | mengambil dokumen eksternal dengan ID IMPORT. Reference tertanam `DOC-POINTER` (dokumen Codec memakai `CODEC-POINTER`) + ID IMPORT |

### Verifikasi (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Nama | Penjelasan |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | deklarasi ID algoritma tanda tangan dan kunci publik Issuer yang diterbitkan sendiri |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | tanda tangan atas sasaran. Tanda tangan atas dokumen menandatangani hash isi (git signed commit·tag) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | konfirmasi hak kontribusi. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | tingkat kepercayaan |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | hasil penilaian seluruh dokumen. Pass, Review, Fail. Satuan node·record adalah `VERDICT` [TOULMIN](toulmin/_index.md) (Edge `0x118L`) |

## Tabel alokasi lengkap {#전체-배정표}

227 slot dialokasikan, 176 md. Sistem 5Q dan pasangan genap-ganjil masing-masing satu baris per anggota, dan md adalah md kepala kelompok.

| TAG ID | ID Codec | Nama | Kind | Bagian | md | Kelompok |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Pasangan `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | Pasangan `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | genap-ganjil `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | genap-ganjil `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | genap-ganjil `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | genap-ganjil `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | genap-ganjil `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | genap-ganjil `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | genap-ganjil `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | genap-ganjil `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | genap-ganjil `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | genap-ganjil `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | genap-ganjil `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | genap-ganjil `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | genap-ganjil `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | genap-ganjil `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
