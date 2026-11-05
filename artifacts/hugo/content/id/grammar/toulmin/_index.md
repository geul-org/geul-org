---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Menulis graf penilaian dan eksekusi dengan model argumentasi Toulmin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menulis graf penilaian dan eksekusi dengan model argumentasi Toulmin. Ini adalah keluarga inti agar GEUL dapat menguraikan aturannya sendiri dalam GEUL dan memperbaikinya sendiri.

| Kelompok | Codec |
|---|---|
| Deklarasi | [CASE-DECLARE](0x100L-case-declare.md) (kasus), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (predikat), [SPEC-DECLARE](0x102L-spec-declare.md) (kriteria penilaian), [RULE-DECLARE](0x103L-rule-declare.md) (klaim), [COUNTER-DECLARE](0x104L-counter-declare.md) (sanggahan), [EXCEPT-DECLARE](0x105L-except-declare.md) (pengecualian) — [NODE](#node) |
| Relasi | [ATTACKS](0x108L-attacks.md) (serangan), [SUPERSEDES](0x109L-supersedes.md) (penyisihan) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (rantai prioritas, layout belum ditetapkan) |
| Eksekusi | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| Hasil | [VERDICT](0x118L-verdict.md) (hasil penilaian: Pass, Review, Fail), [EVIDENCE](0x119L-evidence.md) (bukti penilaian) — layout belum ditetapkan |

- Teks asli, pembagian, serta node dan relasi pembantu adalah kode langsung `0x120L~0x134L` keluarga format TOULMIN ([SOURCE dan pembagian](#source와-구획), [format TOULMIN](#toulmin-형식)).
- Hasil penilaian ditempatkan di dokumen yang berbeda dari sasaran penilaian. Dokumen hasil mengimpor dan menunjuk dokumen sasaran. Dengan demikian hash isi dokumen sasaran tidak berubah meskipun dinilai.

Edge keluarga TOULMIN (kode langsung `0x100L~0x11BL`, record pembantu adalah keluarga format TOULMIN `0x120L~0x134L`) menulis graf penilaian dan eksekusi dengan model argumentasi Toulmin. Deklarasi klaim, sanggahan, dan pengecualian, relasi serangan dan penyisihan, koneksi eksekusi, serta hasil penilaian semuanya adalah Edge. Satu dokumen TANGEUL (bahasa aturan mesin toulmin) menjadi satu dokumen GEUL. Ekstensi filenya sama dengan dokumen lain, yaitu `.geul`.

Hal yang tidak ditetapkan dokumen ini mengikuti aturan umum [Edge](../edge/_index.md) serta [record dan TAG WORD](../record.md).

## Metakognisi dan revisi diri {#메타-인지와-자기-개정}

TOULMIN adalah Codec GEUL agar GEUL dapat bermetakognisi terhadap dirinya sendiri. Aturan penilaian dan eksekusi pun harus diuraikan dalam GEUL agar TOULMIN dapat menjadikan aturan itu sasaran dan memperbaikinya sendiri. Karena itu TOULMIN bukan profil aplikasi, melainkan inti operasi GEUL, dan ditempatkan pada ruang kode langsung Edge (`0x100L~0x11BL`).

- Penguraian diri memungkinkan perbaikan diri, tetapi menanggung risiko kesalahan sirkular. Jika aturan menilai sendiri revisinya, revisi yang melonggarkan kriteria penilaian pun dapat lolos (tingkat kelulusan naik, tetapi akurasi sebenarnya turun).
- Sirkularitas diterima sebagai risiko, tetapi diputus secara struktural.
  - **Inti tetap**: Makna penilaian (Pass, Review, Fail, serangan, penyisihan, prioritas, evaluasi tiga nilai dan U → Review pada [Menilai di atas yang tidak diketahui](#미상-위에서-판정하기) di bawah) ditetapkan dalam spesifikasi ini. Ia tidak dapat diubah dengan dokumen TOULMIN. Posisinya sama dengan aturan yang tertanam di decoder (lapisan 0 pada [alamat publikasi dan daftar versi](../publishing.md#층)).
  - **Pemisahan versi**: Revisi dokumen aturan v(n) dinilai dengan aturan v(n−1) dan pemeriksaan eksternal. Aturan tidak menilai dirinya sendiri. Hasil penilaian ditempatkan di dokumen yang berbeda dari sasarannya (hash isi sasaran tidak berubah).
  - **Riwayat tak berubah**: Revisi menumpuk sebagai versi baru (`PARENT`, hash isi, tanda tangan). Karena versi lama tetap ada, kesalahan sirkular dapat ditemukan belakangan dan dibatalkan. Jaring pengaman revisi diri adalah model versi GEUL ([dokumen](../document.md#개정)).
  - **Kriteria luar**: Disediakan kumpulan kasus uji tersendiri yang tidak dapat disentuh jalur revisi. Penerimaan revisi dipastikan dengan hasil kumpulan ini.
- Uji falsifikasi: sengaja tanamkan satu aturan yang salah. Jika sistem memperbaikinya dan skor kriteria luar naik, perbaikan diri bekerja. Jika hanya tingkat kelulusan yang naik sementara skor kriteria luar turun, itu kesalahan sirkular.

## Kode {#코드}

Record TOULMIN memakai salah satu dari tiga layout. Layout ditetapkan oleh Codec.

| Layout | Kegunaan | Halaman |
|---|---|---|
| NODE | Node graf seperti kasus, aturan, definisi, titik masuk | [NODE](#node) |
| LINK | Relasi antarnode (serangan, penyisihan, eksekusi, definisi) | [LINK](#link) |
| EXPR | Ekspresi kondisi (predikat) | [EXPR](0x101L-predicate-declare.md) |

Record teks asli dan pembagian (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) ditetapkan oleh [SOURCE dan pembagian](#source와-구획).

### Kode langsung {#직접-코드}

| Codec | Nama | Layout | TANGEUL | Arti |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | Deklarasi kasus. Graf penilaian yang memuat node dan relasi |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Ekspresi kondisi Rules | Deklarasi predikat. Ekspresi penilaian |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Butir Definitions | Deklarasi kriteria penilaian (Backing). Bit role adalah jenis definisi |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, nama aturan pada Rules | Deklarasi klaim (Warrant). Dapat diserang |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | Deklarasi sanggahan. Menyerang dengan kesimpulannya sendiri. Level bawaan adalah Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | Deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level bawaan adalah Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | Relasi serangan. Penilaian penyerang mengurangi penilaian sasaran secara bertahap sebesar kekuatan serangan (0~1, bawaan 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | Relasi penyisihan. Jika penyerang Active, sasaran dikeluarkan dari agregasi secara deterministik. Rantai (`A > B > C`) ditulis satu per pasangan |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | Rantai prioritas `A > B > C`. Singkatan dari SUPERSEDES berpasangan. Hanya kode yang dialokasikan, layout belum ada |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | Komposisi eksekusi. Jika node Active, kasus bawahan dieksekusi (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | Aksi yang dilakukan jika node Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | Aksi yang dilakukan hanya sekali meskipun dicoba ulang |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | Aksi kompensasi (saga) untuk DO. Jika langkah berikutnya gagal, dilakukan dalam urutan terbalik |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | Koneksi yang hanya menilai tanpa efek samping |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | Titik masuk eksternal. Mengeksekusi atau menilai kasus |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | Titik masuk berbasis peristiwa atau berkala tanpa pemanggilan eksternal |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | Hasil penilaian node dan record. Hasil (Pass, Review, Fail), nilai penilaian, Activated, Excluded, Level. Hanya kode yang dialokasikan, layout belum ada |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | Bukti penilaian. Lokasi, nilai yang diharapkan, nilai sebenarnya (Fact). Hanya kode yang dialokasikan, layout belum ada |
| `0x11CL~0x11FL` | Reserved | | | |

- Kode langsung yang tidak ada dalam tabel (`0x106L`·`0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`·`0x11BL`) adalah Reserved.
- Kelompok: `0x100L~0x107L` deklarasi, `0x108L~0x10FL` relasi, `0x110L~0x117L` eksekusi, `0x118L~0x11FL` hasil (`0x11CL~0x11FL` Reserved).
- Penilaian seluruh dokumen ditangani oleh Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), dan penilaian node dan record oleh `VERDICT` TOULMIN (Edge `0x118L`). Keduanya adalah Codec terpisah dengan Kind yang berbeda.

### Format TOULMIN {#toulmin-형식}

Teks asli, pembagian, serta node dan relasi pembantu ditempatkan pada kode langsung `0x120L~0x134L` keluarga format Edge TOULMIN. Tidak ada kolom Issuer dan nomor Codec, dan Payload langsung mengikuti TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Kode lain di posisi yang sama
[Length TAG ekstensi]
Edge Id           record LOCAL Reference
komponen          layout yang ditetapkan format
```

| Codec | Nama | Layout | Arti |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, lebar SPAN WORD, UTF8 Value | Teks asli penulisan |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | Nama dan string |
| `0x122L` | [SECTION](0x122L-section.md) | ID, kode bagian 1 WORD | Awal bagian |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (kasus) | Awal lingkup kasus |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (kasus) | Akhir lingkup kasus |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | Paragraf uraian |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | Rujukan fungsi |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | Kelompok eksekusi berurutan |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | Kasus → field |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | Butir definisi → nilai atau tipe |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | Butir definisi → field |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | Titik masuk → kasus, eksekusi |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | Titik masuk → kasus, penilaian |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | Pemicu → kasus |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | Pemicu → kasus (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | Node → pengenal global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | Alias → path (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | Node → TEXT, penulisan nama |

## Dokumen {#문서}

Satu file `.geul` adalah satu DOC. Tidak ada byte lain di luar DOC.

```
DOC-1WORD/2WORD/4WORD     panjang total
  SPEC-VERSION            0x0001 (v1, bilangan bulat tanpa Value tertanam)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". Saat ini "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. Lokal penulisan ("en", "ko")
BODY
  SOURCE                  teks asli penulisan. Record pertama BODY
  record kalimat …        urutan deklarasi dokumen
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), opsional [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- Decoder menolak jika SPEC-VERSION berbeda atau major PROFILE berbeda. Jika hanya minor yang berbeda, dokumen tetap dibaca.
- Record pertama BODY adalah SOURCE. Semua SPAN adalah rentang di dalam teks asli ini.
- Urutan record kalimat sama dengan urutan deklarasi dokumen. Urutan eksekusi (pemicuan `do`·`run`, kompensasi `undo` dalam urutan terbalik) bersandar pada urutan ini. Pada dokumen TOULMIN, urutan Edge bermakna (pengecualian aturan urutan pada [layout Edge](../edge/_index.md#레이아웃)).
- Semua record BODY adalah Edge. Record Value mandiri tidak ditempatkan. Nilai ditanam dalam Payload Edge.
- Identitas kasus dan impor memakai Meta [DOC-ID](../meta/0x1C7L-doc-id.md) dan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject dan See pada TANGEUL).

## Field umum {#공통-필드}

| Field | Lebar | Penjelasan |
|---|---|---|
| ID | record LOCAL Reference | Edge Id record. Elemen pertama Payload semua record |
| REF | record LOCAL Reference | Edge Id yang menunjuk record lain dalam dokumen ini. `0` berarti tidak ada |
| SPAN | lebar yang ditentukan SOURCE × 2 | Rentang di dalam teks asli penulisan. Byte awal, jumlah byte |

- ID dan REF adalah record [LOCAL](../reference/0x005L-local.md) Reference tertanam (`0000 0000 0101 LLLL` + ID dengan lebar terpendek). Lebarnya ditentukan Length record tersebut dan tidak dideklarasikan per dokumen.
- REF `0` (LOCAL `0`) berarti "tidak ada". Ini aturan Codec yang memakai LOCAL `0` sebagai tidak ada ([LOCAL](../reference/0x005L-local.md)).
- Edge Id dialokasikan mulai dari 1 dan tidak duplikat di dalam dokumen. `0` tidak dipakai sebagai Edge Id karena berarti "tidak ada" pada REF.
- Node dirujuk maju oleh record lain, sehingga lebih dulu mendapat nomor menurut urutan deklarasi dokumen. Record lain (SOURCE, TEXT, LINK, FUNC, record pembagian) diberi nomor oleh encoder mulai dari nomor setelah node.
- Decoder hanya memeriksa bahwa Edge Id bukan 0 dan tidak duplikat. Urutan alokasi tidak dipakai dalam interpretasi.
- Node dan relasi dirujuk dengan Edge Id.
- Value tertanam adalah record Value lengkap dengan TAG WORD. Panjangnya ditentukan TAG tersebut.

## Numerik {#수치}

- Nilai penilaian (−1~1), Qualifier (0~1), dan kekuatan serangan (0~1) adalah Value [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md). Format titik tetap tidak disediakan tersendiri.
- Encoder menghapus nol di ujung koefisien. 0.8 adalah `C=8, E=−1`. Decoder menerima hingga empat angka desimal.
- Gerbang keyakinan (misalnya `at least 75%`) ditulis dengan 1 WORD operator perbandingan dan Value persen [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) (`E=0`) ([LINK](#link) F_GATE).
- Kekuatan serangan adalah field F_FORCE pada ATTACKS ([LINK](#공격-세기)). Di luar rentang ditolak.

## Sumbu deklarasi node {#노드-선언의-축}

- Deklarasi node (RULE·COUNTER·EXCEPT-DECLARE) memiliki peran (klaim, sanggahan, pengecualian), Qualifier (0~1), dan Level (Unset, Fail, Review). Peran dibawa oleh Codec dan role pada header NODE, Qualifier oleh F_QUAL, dan Level oleh level pada header ([NODE](#node)).
- Kekokohan (Strict, Defeasible, Defeater) adalah sumbu terpisah dari peran. Penempatan kekokohan belum ditetapkan.
- Kekuatan serangan (Force) bukan nilai node, melainkan nilai Edge ATTACKS ([LINK](#공격-세기) F_FORCE). Ini sumbu yang berbeda dari kekokohan.

## Menilai di atas yang tidak diketahui {#미상-위에서-판정하기}

Ketika graf penilaian menerima fakta GEUL sebagai masukan, tiga konsep [penanda slot](../slot-marker.md) (tidak ditulis, tidak diketahui, tidak ada) dievaluasi secara berbeda. Evaluasi operator perbandingan [EXPR](0x101L-predicate-declare.md) adalah sebagai berikut.

| Masukan | `is empty` | `is not empty` | `equals` / `is in` / perbandingan ukuran |
|---|---|---|---|
| Nilai v | salah | benar | dievaluasi dengan v |
| NO-VALUE (tidak ada) | **benar** | salah | salah |
| UNKNOWN-VALUE (tidak diketahui) | salah | **benar** | **tak tentu (U)** |
| ABSENT (tidak ditulis) / tanpa pernyataan | U (dunia terbuka) | U | U |

- Logika memakai tiga nilai kuat Kleene. `NOT U = U`, `salah AND U = salah`, `benar OR U = benar`. U pada kombinasi lainnya adalah U.
- `EXISTS any` benar jika salah satu elemen benar. Jika tidak ada yang benar dan ada U, hasilnya U; jika semuanya salah, hasilnya salah.
- **Jika predikat bernilai U, penilaian node itu adalah Review, bukan Pass atau Fail.** Jika tidak tahu, diserahkan kepada manusia (atau tahap berikutnya).
- Untuk memandang ABSENT sebagai empty, bukan U, sisi masukan harus **mendeklarasikan** dunia tertutup (disuntikkan sebagai kriteria penilaian SPEC, misalnya: "masukan kasus ini lengkap"). Tanpa deklarasi, hasilnya U.
- Tabel ini dan pemetaan U → Review adalah makna penilaian sehingga merupakan **inti tetap**. Tidak dapat diubah dengan dokumen TOULMIN.
- Contoh: aturan "hanya hitung perbatasan yang masih berlaku" (`P582 is empty`) mengecualikan jika P582 = UNKNOWN-VALUE karena salah, menyertakan jika P582 = NO-VALUE karena benar, dan mengirim ke Review jika P582 tidak ada karena U.

## Hasil penilaian {#판정-결과}

- Hasil penilaian (`VERDICT`, `EVIDENCE`) ditempatkan di dokumen yang berbeda dari sasaran penilaian. Dokumen hasil mengimpor dokumen sasaran dengan [IMPORT-DOC](../meta/0x1E4L-import-doc.md) dan menunjuknya dengan [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). Dengan demikian hash isi dokumen sasaran tidak berubah meskipun dinilai.
- Penilaian seluruh dokumen adalah `VERDICT` Meta, dan penilaian node dan record adalah `VERDICT` TOULMIN.
- Aturan pemilihan versi yang berlaku untuk revisi (aturan peralihan, pemilihan hukum saat perbuatan dan hukum baru) serta tafsir dan putusan juga dipakai sebagai aturan penilaian ([dokumen](../document.md#개정)).

## Masalah terbuka {#열린-문제}

- Layout SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`), dan EVIDENCE (`0x119L`). Apakah cara sekarang, menulis SUPERSEDES per pasangan, cukup untuk rantai.
- Penempatan kekokohan node (Strict, Defeasible, Defeater).
- ATTACKS yang menulis kekuatan serangan 1 dan yang tidak menulisnya memberi penilaian yang sama tetapi byte-nya berbeda. Kesamaan penilaian harus dibandingkan dengan nilai yang diinterpretasikan, bukan byte.
- Jumlah node, jumlah label, dan indeks label di dalam EXPR berukuran 1 WORD, dan jumlah anak 13 bit. Batas atasnya tetap.
- Layout PROVENANCE (asal-usul dan premis aturan).
- Apakah nama dalam backtick ditempatkan sebagai pernyataan [LABEL](../edge/0x0A4L-label.md) atau [BIND](../edge/0x0A3L-bind.md) alih-alih TEXT + LABEL (`0x134L`).
- Tabel nilai kode predicate dan mode pada Claim serta VerbCode pada FuncRef.
- Apakah deklarasi dunia tertutup (membaca ABSENT sebagai empty) dilakukan dengan kriteria penilaian (SPEC) atau per kasus.
- [Dokumen spesifikasi Codec](../codec-spec.md) untuk Codec TOULMIN. Field bersyarat NODE dan LINK serta lebar SPAN yang ditentukan SOURCE adalah layout yang tidak dapat dideklarasikan dengan FIELD.

## Halaman terkait {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE dan pembagian](#source와-구획)
- [Dokumen](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE adalah layout yang menulis node graf penilaian dan eksekusi TOULMIN. Jenis node ditetapkan oleh Codec, dan header 1 WORD menetapkan peran, Level, bentuk Claim, dan field bersyarat.

### Codec {#codec}

| Codec | Nama | TANGEUL | Node |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | Kasus |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Butir Definitions (`means`, `has`) | Kriteria penilaian (Backing). role adalah jenis definisi |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | Klaim (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | Sanggahan (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | Pengecualian (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | Titik masuk eksternal |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | Titik masuk peristiwa atau berkala |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | Namespace dokumen |
| `0x127L` | [FUNC](0x127L-func.md) | Rujukan fungsi | Fungsi luar (contoh: `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | Field wajib |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | Alias paket yang diimpor |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` daftar berurutan | Kelompok eksekusi berurutan |

`0x126L~0x12AL` adalah kode langsung keluarga format Edge TOULMIN ([TOULMIN](#toulmin-형식)).

### Layout {#레이아웃}

```
ID               record LOCAL Reference (Edge Id)
header 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | jenis object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 jika tidak ada) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF (kasus)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. Nilai awal penilaian
[F_WITH]         jumlah (UNSIGNED-INTEGER Value) + REF(TEXT) × jumlah
[F_GROUNDS]      jumlah (UNSIGNED-INTEGER Value) + REF(TEXT) × jumlah
SPAN             lebar yang ditentukan SOURCE × 2 (byte awal, jumlah byte)
```

#### WORD header {#헤더-word}

| Bit | Field | Nilai |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | Ada daftar dasar |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | jenis object | Bentuk object Claim. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | Tabel di bawah |

| Bit | flag | Arti |
|---|---|---|
| b0 | F_FUNC | Ada field FuncRef |
| b1 | F_QUAL | Ada field Qualifier |
| b2 | F_CHECK | Ada field kasus sasaran `checking` |
| b3 | F_CLAIM | Ada field Claim |
| b4 | F_VERDICT | Ada field nilai awal penilaian |
| b5 | F_STRIKE | Deklarasi yang dicoret. Tidak ada field |
| b6 | F_WITH | Ada field daftar kriteria |

- Field bersyarat ditempatkan menurut urutan flag (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Field yang flag-nya mati tidak menempati ruang.
- Jika flag menyala tetapi field tidak ada, ditolak. Posisi setelah membaca field secara berurutan harus tepat sama dengan akhir record setelah SPAN.

### Field {#필드}

| Field | Penjelasan |
|---|---|
| FuncRef | Posisi fungsi. REF adalah record ALIAS yang mengimpor fungsi itu, dan `0` jika fungsi milik dokumen ini. VerbCode adalah kode 1 WORD dan belum dialokasikan (`0x0000` diizinkan). Penulisan asli fungsi ditulis terpisah dengan TEXT + [LABEL](#link) |
| Qualifier | Tingkat keyakinan node (0~1) |
| Kasus | F_CHECK: kasus yang hanya dinilai oleh node ini (`checking c`) |
| Claim | Proposisi yang dimuat node. REF subject, predicate 1 WORD, object, mode 1 WORD. Bentuk object ditentukan jenis object pada header |
| Nilai penilaian | Nilai awal penilaian (−1~1) |
| F_WITH | Kriteria penilaian pada saat deklarasi (`기준으로 하는`, "yang berpatokan pada"). Daftar REF record TEXT |
| F_GROUNDS | Nama fakta eksternal yang diinterpretasikan pada saat evaluasi (`근거로 하는`, "yang berdasar pada"). Daftar REF record TEXT |
| SPAN | Rentang teks asli tempat deklarasi ini muncul |

- Penulisan nilai penilaian dan Qualifier mengikuti aturan numerik [TOULMIN](#수치).
- Jumlah dalam daftar adalah record [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value tertanam.
- Bentuk dasar Claim uraian adalah subject dan predicate `0` serta object berupa SPAN (jenis object 2). Dikunci pada penulisan teks asli.

### Interpretasi dan validitas {#해석과-유효성}

- role pada RULE·COUNTER·EXCEPT-DECLARE harus sama dengan Codec (0 general, 1 counter, 2 except). Pada SPEC-DECLARE, itu adalah jenis definisi. Pada Codec lain, 0.
- Jika level 0 (Unset), dipakai nilai bawaan mesin: Fail untuk COUNTER-DECLARE, Review untuk EXCEPT-DECLARE.
- Aturan fungsi host TANGEUL `tangl:규칙` (`쓰는 규칙이다`, "aturan yang memakai") ditulis sebagai NODE RULE-DECLARE di luar kasus. Fungsi adalah F_FUNC, kriteria adalah F_WITH, dan dasar adalah F_GROUNDS. Hanya aturan ekspresi kondisi yang didahului [PREDICATE-DECLARE](0x101L-predicate-declare.md).
- Bit Reserved (13–12) harus 0. Jika bit Reserved menyala atau role tidak cocok dengan Codec, ditolak.

### Halaman terkait {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE dan pembagian](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK adalah layout yang menulis relasi antarnode pada graf TOULMIN. Jenis relasi ditetapkan oleh Codec.

### Codec {#codec-1}

| Codec | Nama | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | aturan → aturan. Mengurangi penilaian secara bertahap sebesar kekuatan serangan |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | aturan → aturan. Jika Active, sasaran dikeluarkan dari agregasi |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | aturan → kasus |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | aturan → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | aturan → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | aturan → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | aturan → kasus. Penilaian tanpa efek samping |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | kasus → field |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | butir definisi → nilai atau tipe |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | butir definisi → field |
| `0x12EL` | [RUNS](0x12EL-runs.md) | titik masuk `run c` | titik masuk → kasus (eksekusi) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | titik masuk `check c` | titik masuk → kasus (penilaian) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | pemicu `run c` | pemicu → kasus |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | pemicu → kasus |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | node → pengenal global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | alias → path (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | nama dalam backtick | node → TEXT. Penulisan nama |

### Layout {#레이아웃-1}

```
ID               record LOCAL Reference (Edge Id)
src              REF
dst              REF. DO·DO-ONCE·UNDO adalah FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operator 1 WORD (2 bit atas) + UNSIGNED-DECIMAL Value (persen)
[F_FORCE]        SIGNED-DECIMAL Value. Kekuatan serangan (0~1). Hanya ATTACKS
SPAN             lebar yang ditentukan SOURCE × 2
```

| flag | Arti |
|---|---|
| b0 F_ONCE | Dilakukan hanya sekali (`once` pada UNDO) |
| b1 F_GATE | Ada field gerbang keyakinan |
| b2 F_STRIKE | Relasi yang dicoret |
| b3 F_ORDERED | Termasuk daftar berurutan `1.` |
| b4 F_FORCE | Ada field kekuatan serangan. Hanya ATTACKS |

| Operator gerbang | Arti |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Field bersyarat ditempatkan menurut urutan flag (F_GATE, F_FORCE). Field yang flag-nya mati tidak menempati ruang.

### Kekuatan serangan {#공격-세기}

Kekuatan serangan (F_FORCE) hanya dipakai oleh [ATTACKS](0x108L-attacks.md#공격-세기). Rumus penilaian, penulisan, dan contoh ada di halaman itu.

### Interpretasi dan validitas {#해석과-유효성-1}

- REF adalah Edge Id record dokumen ini (field umum [TOULMIN](#공통-필드)).
- Bentuk dst ditetapkan oleh Codec. DO·DO-ONCE·UNDO adalah FuncRef (REF(ALIAS, 0 jika tidak ada) + VerbCode 1 WORD, [NODE](#필드)), LABEL·IMPORTED-FROM adalah REF record TEXT, dan sisanya adalah REF node.
- `do … once` dinyatakan oleh Codec DO-ONCE. F_ONCE tidak dipakai pada flags DO-ONCE (ditolak jika aktif). `once` pada UNDO ditulis dengan F_ONCE.
- Operator gerbang adalah 2 bit atas WORD operator, dan 14 bit sisanya adalah 0. Persen adalah UNSIGNED-DECIMAL Value dengan `E=0` dan bernilai 0~100.
- b5~b15 pada flags adalah Reserved dan harus 0. Jika tidak, ditolak.
- F_FORCE hanya dipakai pada ATTACKS. Jika menyala pada Codec lain (SUPERSEDES, koneksi eksekusi dan penilaian, relasi format TOULMIN), ditolak.
- Jika kekuatan serangan bukan SIGNED-DECIMAL Value, di luar 0~1, atau tidak dapat dinyatakan secara tepat dengan empat angka desimal, ditolak.
- Rantai SUPERSEDES `A > B > C` ditulis dengan satu SUPERSEDES per pasangan.

### Halaman terkait {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE dan pembagian](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE dan pembagian {#source와-구획}

Record yang menulis teks asli dan pembagian dokumen TOULMIN. Semuanya adalah kode langsung `0x120L~0x125L` keluarga format Edge TOULMIN ([TOULMIN](#toulmin-형식)). Tidak ada kolom Issuer dan nomor Codec, dan Payload mengikuti TAG.

### Format {#형식}

| Codec | Nama | Layout |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, lebar SPAN WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, kode bagian 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (kasus) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (kasus) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](#공통-필드)).
- UTF8 Value adalah record [UTF8-TEXT](../value/0x072L-utf8-text.md) Value. Byte dimuat apa adanya.

### Halaman per format {#형식별-쪽}

Layout, tabel kode bagian, dan interpretasi memiliki halaman tersendiri untuk setiap format.

- [SOURCE](0x120L-source.md): teks asli penulisan. Record pertama BODY dan menetapkan lebar SPAN
- [TEXT](0x121L-text.md): nama dan string
- [SECTION](0x122L-section.md): awal bagian dan kode bagian
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): lingkup kasus
- [PROSE](0x125L-prose.md): paragraf uraian

### Halaman terkait {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
