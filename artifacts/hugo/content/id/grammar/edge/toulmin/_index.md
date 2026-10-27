---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Edge TOULMIN (Codec 0x60~0x7B) menulis graf putusan·eksekusi dengan model argumen Toulmin. Halaman ini menetapkan aturan dokumen TOULMIN, field umum, tabel kode, aturan numerik, dan inti tetap revisi mandiri."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge keluarga TOULMIN (2 bit atas Codec `11`, kode langsung `0x60`~`0x7B`) menulis graf putusan·eksekusi dengan model argumen Toulmin. Deklarasi klaim·sanggahan·pengecualian, relasi serangan·pengesampingan, sambungan eksekusi, dan hasil putusan semuanya adalah Edge. Satu dokumen TANGEUL (bahasa aturan mesin toulmin) menjadi satu dokumen GEUL. Ekstensi file sama dengan dokumen lain, `.geul`.

Hal yang tidak ditetapkan halaman ini mengikuti aturan umum [Edge](/id/grammar/edge/) dan [Record dan TAG WORD](/id/grammar/record/).

## Meta-kognisi dan revisi mandiri

Alasan TOULMIN adalah Codec GEUL adalah agar GEUL dapat bermeta-kognisi tentang dirinya sendiri. Aturan putusan·eksekusi pun harus dinyatakan dalam GEUL agar TOULMIN dapat menjadikan aturan itu objek dan memperbaikinya sendiri. Karena itu TOULMIN bukan profil aplikasi melainkan inti operasi GEUL, dan ditaruh di ruang kode langsung Edge (`0x60`~`0x7B`).

- Pernyataan mandiri memungkinkan perbaikan mandiri, tetapi menanggung risiko kesalahan melingkar. Jika aturan memutuskan revisinya sendiri, revisi yang melonggarkan kriteria putusan pun dapat lolos (tingkat kelulusan naik, akurasi sebenarnya turun).
- Sirkularitas diterima sebagai risiko tetapi diputus dengan struktur.
  - **Inti tetap**: makna putusan (Pass·Review·Fail, serangan·pengesampingan·prioritas, evaluasi 3 nilai dan U → Review pada [memutuskan di atas ketidaktahuan](#memutuskan-di-atas-ketidaktahuan) di bawah) ditetapkan tetap dalam spesifikasi ini. Tidak dapat diubah dengan dokumen TOULMIN. Posisinya sama dengan aturan yang ditanamkan di decoder (lapisan 0 pada [alamat publikasi dan daftar versi](/id/grammar/publishing/#lapisan)).
  - **Pemisahan edisi**: revisi dokumen aturan v(n) diputuskan dengan aturan v(n−1) dan pemeriksaan eksternal. Aturan tidak memutuskan dirinya sendiri. Hasil putusan ditaruh di dokumen yang berbeda dari objeknya (hash isi objek tidak berubah).
  - **Riwayat tak berubah**: revisi bertumpuk sebagai versi baru (`PARENT`, hash isi, tanda tangan). Karena versi lama tersisa, kesalahan melingkar dapat ditemukan setelah kejadian dan dibatalkan. Jaring pengaman revisi mandiri adalah model edisi GEUL ([Dokumen](/id/grammar/document/#revisi)).
  - **Kriteria luar**: sediakan kumpulan kasus uji terpisah yang tidak dapat disentuh jalur revisi. Penerimaan revisi dikonfirmasi dengan hasil kumpulan ini.
- Uji sanggah: sengaja menanamkan satu aturan yang salah. Jika sistem memperbaikinya dan skor kriteria luar naik, perbaikan mandiri bekerja. Jika hanya tingkat kelulusan yang naik sementara skor kriteria luar turun, itu kesalahan melingkar.

## Kode

Record TOULMIN memakai salah satu dari tiga layout. Layout ditetapkan oleh Codec (atau nomor format).

| Layout | Pemakaian | Halaman |
|---|---|---|
| NODE | Node graf seperti kasus·aturan·definisi·titik masuk | [NODE](/id/grammar/edge/toulmin/node/) |
| LINK | Relasi antar node (serangan, pengesampingan, eksekusi, definisi) | [LINK](/id/grammar/edge/toulmin/link/) |
| EXPR | Ekspresi kondisi (predikat) | [EXPR](/id/grammar/edge/toulmin/expr/) |

Record teks asli dan bagian (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) ditetapkan oleh [SOURCE dan bagian](/id/grammar/edge/toulmin/source/).

### Kode langsung

| Codec | Nama | Layout | TANGEUL | Arti |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/id/grammar/edge/toulmin/node/) | NODE | `in case of` | Deklarasi kasus. Graf putusan yang memuat node dan relasi |
| `0x61` | [PREDICATE-DECLARE](/id/grammar/edge/toulmin/expr/) | EXPR | Ekspresi kondisi pada Rules | Deklarasi predikat. Ekspresi putusan |
| `0x62` | [SPEC-DECLARE](/id/grammar/edge/toulmin/node/) | NODE | Butir Definitions | Deklarasi kriteria penilaian (Backing). Bit role adalah jenis definisi |
| `0x63` | [RULE-DECLARE](/id/grammar/edge/toulmin/node/) | NODE | general rule, nama aturan pada Rules | Deklarasi klaim (Warrant). Dapat diserang |
| `0x64` | [COUNTER-DECLARE](/id/grammar/edge/toulmin/node/) | NODE | counter rule | Deklarasi sanggahan. Menyerang dengan kesimpulannya sendiri. Level default Fail |
| `0x65` | [EXCEPT-DECLARE](/id/grammar/edge/toulmin/node/) | NODE | except rule | Deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level default Review |
| `0x68` | [ATTACKS](/id/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Relasi serangan. Putusan penyerang mengurangi putusan target secara bertahap |
| `0x69` | [SUPERSEDES](/id/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Relasi pengesampingan. Jika penyerang Active, target dikeluarkan dari agregasi secara pasti. Rantai (`A > B > C`) ditulis satu per pasangan |
| `0x6A` | SUPERSEDE-CHAIN | — | | Rantai prioritas `A > B > C`. Singkatan SUPERSEDES per pasangan. Hanya kodenya yang dialokasikan dan layout belum ada |
| `0x70` | [RUN](/id/grammar/edge/toulmin/link/) | LINK | `run c when n` | Komposisi eksekusi. Jika node Active, kasus turunan dieksekusi (DAG) |
| `0x71` | [DO](/id/grammar/edge/toulmin/link/) | LINK | `do fn when n` | Tindakan yang dilakukan jika node Active |
| `0x72` | [DO-ONCE](/id/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | Tindakan yang dilakukan hanya sekali walaupun dicoba ulang |
| `0x73` | [UNDO](/id/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | Tindakan kompensasi DO (saga). Dilakukan berurutan terbalik jika tahap berikutnya gagal |
| `0x74` | [CHECKING](/id/grammar/edge/toulmin/link/) | LINK | `checking c` | Sambungan yang hanya memutuskan tanpa efek samping |
| `0x75` | [ENTRY](/id/grammar/edge/toulmin/node/) | NODE | `provides x` | Titik masuk eksternal. Mengeksekusi atau memutuskan kasus |
| `0x76` | [TRIGGER](/id/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | Titik masuk peristiwa·periodik tanpa panggilan eksternal |
| `0x78` | VERDICT | — | | Hasil putusan node·record. Hasil (Pass, Review, Fail), nilai putusan, Activated, Excluded, Level. Hanya kodenya yang dialokasikan dan layout belum ada |
| `0x79` | EVIDENCE | — | | Bukti putusan. Posisi, nilai yang diharapkan, nilai sebenarnya (Fact). Hanya kodenya yang dialokasikan dan layout belum ada |
| `0x7C`~`0x7F` | ISSUER-* | | | Format yang didefinisikan Issuer. Format ISSUER di bawah |

- Kode langsung yang tidak ada di tabel (`0x66`·`0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`·`0x7B`) adalah cadangan.
- 2 bit atas dari 5 bit bawah Codec adalah kelompoknya: `00` deklarasi, `01` relasi, `10` eksekusi, `11` hasil (`0x7C`~`0x7F` adalah ISSUER).
- Putusan seluruh dokumen ditangani Meta [VERDICT](/id/grammar/meta/verification/verdict/) (`0x44`), dan putusan node·record oleh TOULMIN `VERDICT` (Edge `0x78`). Keduanya adalah Codec terpisah dengan Kind yang berbeda.

### Format ISSUER

Record TOULMIN yang kekurangan kode langsung ditaruh dengan `ISSUER-1WORD` (`0x7C`), sebagai nomor format di bawah Issuer `0x0000` (GEUL). Nomor format adalah keluarga TOULMIN (`0xC000`~`0xFFFF`, 2 bit atas `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length extension TAG]
Issuer            0x0000
Nomor format      0xC000~0xC029
Edge Id           record LOCAL Reference
Komponen          layout yang ditetapkan format
```

| Nomor format | Nama | Layout | Arti |
|---|---|---|---|
| `0xC000` | [SOURCE](/id/grammar/edge/toulmin/source/) | ID, WORD lebar SPAN, Value UTF8 | Teks asli tulisan |
| `0xC001` | [TEXT](/id/grammar/edge/toulmin/source/) | ID, Value UTF8 | Nama·string |
| `0xC002` | [SECTION](/id/grammar/edge/toulmin/source/) | ID, kode bagian 1 WORD | Awal bagian |
| `0xC003` | [CASE-BEGIN](/id/grammar/edge/toulmin/source/) | ID, REF (kasus) | Awal cakupan kasus |
| `0xC004` | [CASE-END](/id/grammar/edge/toulmin/source/) | ID, REF (kasus) | Akhir cakupan kasus |
| `0xC005` | [PROSE](/id/grammar/edge/toulmin/source/) | ID, SPAN | Paragraf uraian |
| `0xC010` | [NAMESPACE](/id/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/id/grammar/edge/toulmin/node/) | NODE | Referensi fungsi |
| `0xC012` | [FIELD](/id/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/id/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/id/grammar/edge/toulmin/node/) | NODE | Kelompok eksekusi berurutan |
| `0xC020` | [REQUIRES](/id/grammar/edge/toulmin/link/) | LINK | Kasus → field |
| `0xC021` | [MEANS](/id/grammar/edge/toulmin/link/) | LINK | Butir definisi → nilai·tipe |
| `0xC022` | [HAS](/id/grammar/edge/toulmin/link/) | LINK | Butir definisi → field |
| `0xC023` | [RUNS](/id/grammar/edge/toulmin/link/) | LINK | Titik masuk → kasus, eksekusi |
| `0xC024` | [EVALUATES](/id/grammar/edge/toulmin/link/) | LINK | Titik masuk → kasus, putusan |
| `0xC025` | [TRIGGERS](/id/grammar/edge/toulmin/link/) | LINK | Trigger → kasus |
| `0xC026` | [UNTIL](/id/grammar/edge/toulmin/link/) | LINK | Trigger → kasus (`every … until`) |
| `0xC027` | [SAME-AS](/id/grammar/edge/toulmin/link/) | LINK | Node → pengenal global |
| `0xC028` | [IMPORTED-FROM](/id/grammar/edge/toulmin/link/) | LINK | Alias → path (TEXT) |
| `0xC029` | [LABEL](/id/grammar/edge/toulmin/link/) | LINK | Node → TEXT, penulisan nama |

- Ruang nomor format terpisah per Kind. Format GEUL `0xC000` pada Value (OPAQUE-BYTES-EVEN) dan `0xC000` pada Edge (SOURCE) adalah format yang berbeda.
- Nomor format hanya ditambah. Nomor yang sudah dialokasikan tidak dipakai ulang untuk format lain.

## Dokumen

Satu file `.geul` adalah satu DOC. Tidak ada byte lain di luar DOC.

```
DOC-1WORD/2WORD/4WORD     panjang total
  SPEC-VERSION            0x0001 (v1, bilangan bulat tanpa Value tersemat)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Saat ini "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Lokal penulisan ("en", "ko")
BODY
  SOURCE                  Teks asli tulisan. Record pertama BODY
  Record kalimat …         Urutan deklarasi dokumen
END
```

- HEAD: [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/), [PROFILE](/id/grammar/meta/declaration/profile/), opsional [DEFAULT-LANGUAGE](/id/grammar/meta/declaration/default-language/).
- Decoder menolak jika SPEC-VERSION berbeda atau major PROFILE berbeda. Walaupun minor berbeda, dokumen tetap dibaca.
- Record pertama BODY adalah SOURCE. Semua SPAN adalah rentang di dalam teks asli ini.
- Urutan record kalimat sama dengan urutan deklarasi dokumen. Urutan eksekusi (pemicuan `do`·`run`, kompensasi terbalik `undo`) bergantung pada urutan ini. Dokumen TOULMIN memberi makna pada urutan Edge (pengecualian aturan urutan [Edge](/id/grammar/edge/)).
- Semua record BODY adalah Edge. Record Value mandiri tidak ditaruh. Nilai disematkan dalam Payload Edge.
- Identitas kasus dan impor memakai Meta [DOC-ID](/id/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/id/grammar/meta/import/import-doc/) (Subject·See pada TANGEUL).

## Field umum

| Field | Lebar | Penjelasan |
|---|---|---|
| ID | record LOCAL Reference | Edge Id record. Elemen pertama Payload semua record |
| REF | record LOCAL Reference | Edge Id yang menunjuk record lain dokumen ini. `0` berarti tidak ada |
| SPAN | lebar yang ditetapkan SOURCE × 2 | Rentang di dalam teks asli tulisan. Byte awal, jumlah byte |

- ID dan REF adalah record [LOCAL](/id/grammar/reference/local/) Reference tersemat (`0000 0LLL L000 1000` + ID dengan lebar terpendek). Lebar ditetapkan oleh Length record itu dan tidak dideklarasikan per dokumen.
- REF `0` (LOCAL `0`) berarti "tidak ada". Ini aturan Codec yang memakai LOCAL `0` sebagai tidak ada ([LOCAL](/id/grammar/reference/local/)).
- Edge Id dialokasikan mulai dari 1 dan tidak boleh duplikat dalam dokumen. `0` adalah "tidak ada" pada REF sehingga tidak dipakai sebagai Edge Id.
- Node diacu maju oleh record lain sehingga menerima nomor lebih dulu menurut urutan deklarasi dokumen. Record lain (SOURCE, TEXT, LINK, FUNC, record bagian) dialokasikan encoder mulai dari nomor setelah node.
- Decoder hanya memeriksa bahwa Edge Id bukan 0 dan tidak ada duplikat. Urutan alokasi tidak dipakai dalam interpretasi.
- Node dan relasi ditunjuk dengan Edge Id.
- Value tersemat adalah record Value apa adanya termasuk TAG WORD. Panjangnya ditetapkan TAG itu.

## Numerik

- Nilai putusan (−1~1) dan Qualifier (0~1) adalah Value [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/). Format titik tetap tidak disediakan terpisah.
- Encoder menghapus angka 0 di ujung koefisien. 0.8 adalah `C=8, E=−1`. Decoder menerima sampai 4 digit desimal.
- Gerbang keyakinan (contoh: `at least 75%`) ditulis dengan 1 WORD operator perbandingan dan Value persen [UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/) (`E=0`) ([LINK](/id/grammar/edge/toulmin/link/) F_GATE).

## Sumbu deklarasi node

- Deklarasi node (RULE·COUNTER·EXCEPT-DECLARE) memiliki peran (klaim·sanggahan·pengecualian), Qualifier (0~1), dan Level (Unset, Fail, Review). Peran dimuat oleh Codec dan role pada header NODE, Qualifier oleh F_QUAL, dan Level oleh level pada header ([NODE](/id/grammar/edge/toulmin/node/)).
- Kekuatan (Strict, Defeasible, Defeater) adalah sumbu terpisah dari peran. Penempatan kekuatan belum ditetapkan.

## Memutuskan di atas ketidaktahuan

Saat graf putusan menerima fakta GEUL sebagai input, tiga konsep [penanda slot](/id/grammar/reference/slot-marker/) (tidak ditulis, tidak diketahui, tidak ada) dievaluasi secara berbeda. Evaluasi operator perbandingan [EXPR](/id/grammar/edge/toulmin/expr/) adalah sebagai berikut.

| Input | `is empty` | `is not empty` | `equals` / `is in` / perbandingan ukuran |
|---|---|---|---|
| Nilai v | salah | benar | dievaluasi dengan v |
| NO-VALUE (tidak ada) | **benar** | salah | salah |
| UNKNOWN-VALUE (tidak diketahui) | salah | **benar** | **belum ditentukan (U)** |
| ABSENT (tidak ditulis) / tanpa pernyataan | U (dunia terbuka) | U | U |

- Logika memakai Kleene kuat 3 nilai. `NOT U = U`, `salah AND U = salah`, `benar OR U = benar`. U pada kombinasi lain adalah U.
- `EXISTS any` benar jika salah satu elemen benar. Jika tidak ada yang benar dan ada U, hasilnya U; jika semuanya salah, hasilnya salah.
- **Jika predikat U, putusan node itu bukan Pass·Fail melainkan Review.** Jika tidak tahu, diserahkan kepada manusia (atau tahap berikutnya).
- Untuk memandang ABSENT sebagai empty, bukan U, sisi input harus **mendeklarasikan** dunia tertutup (disuntikkan sebagai kriteria penilaian SPEC, contoh: "input kasus ini lengkap"). Tanpa deklarasi, hasilnya U.
- Tabel ini dan padanan U → Review adalah makna putusan sehingga merupakan **inti tetap**. Tidak dapat diubah dengan dokumen TOULMIN.
- Contoh: aturan "hitung hanya perbatasan yang masih berlaku" (`P582 is empty`) mengecualikan jika P582 = UNKNOWN-VALUE karena salah, menyertakan jika P582 = NO-VALUE karena benar, dan mengirim ke Review jika P582 tidak ada karena U.

## Hasil putusan

- Hasil putusan (`VERDICT`, `EVIDENCE`) ditaruh di dokumen yang berbeda dari objek putusan. Dokumen hasil mengimpor dokumen objek dengan [IMPORT-DOC](/id/grammar/meta/import/import-doc/) dan menunjuknya dengan [EXTERNAL-POINTER-*](/id/grammar/reference/external-pointer/). Karena itu hash isi dokumen objek tidak berubah walaupun diputuskan.
- Putusan seluruh dokumen adalah Meta `VERDICT`, dan putusan node·record adalah TOULMIN `VERDICT`.
- Aturan pemilihan edisi penerapan revisi (aturan peralihan, pemilihan antara hukum saat perbuatan dan hukum baru), serta interpretasi dan preseden, juga ditulis sebagai aturan putusan ([Dokumen](/id/grammar/document/#revisi)).

## Masalah terbuka

- Layout SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`), EVIDENCE (`0x79`). Apakah cara saat ini yang menulis SUPERSEDES per pasangan cukup untuk rantai.
- Penempatan kekuatan node (Strict, Defeasible, Defeater).
- Jumlah node, jumlah label, dan indeks label dalam EXPR adalah 1 WORD dan jumlah anak adalah 13 bit. Batas atasnya tetap.
- Layout PROVENANCE (asal·premis aturan).
- Apakah nama backtick ditaruh dengan [LABEL](/id/grammar/edge/label/)·[BIND](/id/grammar/edge/bind/) pernyataan, bukan TEXT + LABEL (`0xC029`).
- Tabel nilai kode predicate·mode Claim dan nilai kode VerbCode FuncRef.
- Apakah deklarasi dunia tertutup (membaca ABSENT sebagai empty) dilakukan sebagai kriteria penilaian (SPEC) atau per kasus.
- [Dokumen spesifikasi Codec](/id/grammar/codec-spec/) Codec TOULMIN. Field bersyarat NODE·LINK dan lebar SPAN yang ditetapkan SOURCE adalah layout yang tidak dapat dideklarasikan dengan FIELD.

## Halaman terkait

- [NODE](/id/grammar/edge/toulmin/node/), [LINK](/id/grammar/edge/toulmin/link/), [EXPR](/id/grammar/edge/toulmin/expr/), [SOURCE dan bagian](/id/grammar/edge/toulmin/source/)
- [Edge](/id/grammar/edge/), [Dokumen](/id/grammar/document/), [PROFILE](/id/grammar/meta/declaration/profile/)
