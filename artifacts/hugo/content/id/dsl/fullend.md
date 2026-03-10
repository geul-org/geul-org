---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI yang memvalidasi konsistensi silang 10 SSOT dan menghasilkan kode. Menambal retakan struktural dalam vibe coding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI yang memvalidasi konsistensi 10 SSOT sekaligus dan menghasilkan kode.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositori GitHub</a>

## Retakan dalam vibe coding

Seiring populernya vibe coding, pola-pola mulai terlihat.

Anda meminta AI "buatkan fitur reservasi" dan ia membuatnya. "Tambahkan fitur pembatalan" dan ia menambahkannya. Saat menambahkan fitur kelima, fitur kedua rusak. Anda mengubah skema API tapi frontend tidak diperbarui. Menambahkan kolom di database tapi lapisan layanan tidak mengetahuinya.

Penyebabnya sederhana: AI tidak mampu mengingat seluruh kode.

Maka yang dilakukan orang: menemukan bagian yang rusak dan berkata kepada AI "perbaiki ini juga". Diperbaiki, tapi bagian lain rusak. "Perbaiki itu juga." Loop ini berulang. Semakin besar proyek, semakin panjang loop-nya, hingga pada titik tertentu "memulai dari awal lebih cepat".

## Mengapa kode membengkak?

Dalam kode, dua hal bercampur:

**Keputusan**: apa yang ditampilkan, API mana yang dipanggil, urutan pemrosesan, apa yang disimpan.
**Wiring**: kode yang mengimplementasikan keputusan tersebut dalam framework tertentu.

Misalkan kita membangun sistem reservasi.

```
Keputusan: "Saat membatalkan reservasi, periksa otoritas → cari → validasi transisi status → hitung pengembalian dana → ubah status → respons"
```

Satu baris keputusan ini tersebar ke React hooks, Go handlers, query SQL, skema API, dan resource Terraform. Masing-masing dibungkus sintaks framework-nya, ditambah penanganan error dan konversi tipe.

Dari 100.000 baris kode, keputusan hanya 12.500 baris. Sisanya 87.500 baris adalah wiring.

Agen AI memiliki context window yang terbatas. Saat menambahkan fitur kesepuluh, mereka tidak mengingat sembilan fitur sebelumnya karena tidak bisa membaca 100.000 baris sekaligus.

Jika kita memisahkan keputusan saja, jumlahnya 12.500 baris — 55% dari konteks 200K token. Ukuran yang bisa dibaca AI sekaligus.

## 10 SSOT

Fullend memisahkan semua keputusan perangkat lunak menjadi 10 spesifikasi deklaratif. Setiap spesifikasi menjadi sumber kebenaran tunggal (SSOT) untuk aspek yang bersangkutan.

| Aspek | SSOT | Apa yang dideklarasikan |
|---|---|---|
| Pengaturan proyek | fullend.yaml | Tech stack, middleware, path modul |
| Antarmuka | [STML](/id/dsl/stml/) (HTML5 + data-*) | Apa yang ditampilkan dan apa yang dilakukan |
| Kontrak API | OpenAPI 3.x | Permintaan apa yang diterima dan respons apa yang diberikan |
| Alur layanan | [SSaC](/id/dsl/ssac/) (Go comment DSL) | Urutan pemrosesan |
| Struktur data | SQL DDL + sqlc | Apa yang disimpan |
| Fungsi eksternal | Func Spec (Go) | Antarmuka dan implementasi logika kustom |
| Transisi status | Mermaid stateDiagram | Status apa saja yang dilalui resource |
| Kebijakan otorisasi | OPA Rego | Siapa yang boleh melakukan apa |
| Skenario | Gherkin (.feature) | Validasi alur bisnis antar-endpoint |
| Infrastruktur | Terraform HCL | Di mana dijalankan |

OpenAPI, SQL DDL, dan Terraform adalah standar industri. Aspek lainnya belum memiliki DSL SSOT yang sesuai. Alur layanan tersebar di Go handlers, keputusan antarmuka terbenam di React hooks, transisi status tersembunyi di percabangan if-else, dan otorisasi di-hardcode di middleware. Karena itu kami merancang STML, SSaC, Func Spec, integrasi stateDiagram, integrasi OPA, dan integrasi Gherkin. Ini adalah DSL dan integrasi yang dibuat oleh proyek ini.

```
specs/my-project/
├── fullend.yaml           → Pengaturan proyek
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
├── func/<pkg>/*.go        → Func Spec
├── states/*.md            → Mermaid stateDiagram
├── policy/*.rego          → OPA Rego
├── scenario/*.feature     → Gherkin
└── terraform/*.tf         → HCL
```

`specs/` adalah kebenaran. `artifacts/` bisa diregenerasi kapan saja.

## Validasi individual sudah ada

Alat validasi untuk beberapa lapisan sudah tersedia:

- sqlc memeriksa konsistensi DDL dan query.
- Validator OpenAPI memeriksa validitas skema.
- Terraform memeriksa sintaks dan dependensi HCL.

Kami juga membuat validator bawaan untuk STML dan SSaC. SSaC memeriksa konsistensi internal alur layanan, dan STML memeriksa kesesuaian deklarasi UI dengan OpenAPI.

Setiap SSOT bisa memvalidasi dirinya sendiri. Masalahnya muncul **di antara** SSOT-SSOT tersebut.

Frontend menampilkan field dengan `data-bind="memo"`, tapi skema respons API tidak memiliki `memo`. SSaC memanggil `@delete Reservation.SoftDelete(request.ReservationID)`, tapi query sqlc tidak memiliki metode `SoftDelete`. State diagram mendefinisikan transisi `PublishCourse`, tapi SSaC tidak memiliki fungsi yang sesuai. Kebijakan OPA memeriksa kepemilikan resource `course` melalui `courses.instructor_id`, tapi DDL tidak memiliki kolom tersebut.

Alat individual hanya melihat lapisannya sendiri. Retakan antar-lapisan tetap tidak terlihat.

## Menyembunyikan struktur

"Tapi bukankah harus belajar 10 DSL?"

Benar. Tapi struktur tidak perlu ditampilkan kepada pengguna.

Jika kita memasukkan tech stack dan aturan SSOT terlebih dahulu ke system prompt agen, pengguna cukup berkata "buatkan fitur reservasi". Agen secara otomatis menambahkan endpoint di OpenAPI, membuat tabel di DDL, mendeklarasikan alur layanan di SSaC, menggambar state diagram, menulis kebijakan OPA, menggambar antarmuka di STML, dan menjalankan `fullend validate` untuk memverifikasi konsistensi.

Yang dilihat pengguna hanyalah hasilnya. Struktur adalah sesuatu yang dikonsumsi agen, bukan sesuatu yang harus dipelajari pengguna.

Pengalaman vibe coding tetap sama. Yang berubah adalah tidak ada yang rusak di balik layar.

## Peran Fullend

Fullend adalah validator silang. Ia tidak menemukan ulang alat-alat individual. Ia memanggil setiap alat dan memeriksa batas antar-SSOT.

```bash
fullend validate specs/my-project
```

```
✓ Config       fullend.yaml valid
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ States       2 diagrams
✓ Policy       3 rules
✓ Scenario     2 features
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

Jika ada yang gagal:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Ketika validasi lolos, kode dihasilkan.

```bash
fullend gen specs/my-project artifacts/my-project
```

sqlc menghasilkan model database, oapi-codegen menghasilkan tipe API, SSaC menghasilkan gin handler, STML menghasilkan komponen React, paket state machine dan OPA Authorizer dihasilkan, tes Hurl dihasilkan dari Gherkin, dan Fullend menghasilkan glue code yang menghubungkan semuanya.

## Aturan validasi silang

Nilai inti Fullend ada pada validasi silang. Setelah alat individual memvalidasi lapisannya masing-masing, Fullend menangkap ketidakcocokan antar-SSOT.

**OpenAPI ↔ DDL**

| Target validasi | Aturan |
|---|---|
| x-sort.allowed | Apakah kolom terkait ada di tabel? |
| x-sort ↔ DDL index | Apakah kolom terkait memiliki indeks? (WARNING) |
| x-filter.allowed | Apakah kolom terkait ada di tabel? |
| x-include.allowed | Apakah tabel terhubung melalui relasi FK? |

**SSaC ↔ DDL**

| Target validasi | Aturan |
|---|---|
| Model.Method | Apakah metode terkait ada di query sqlc? |
| @result Type | Apakah cocok dengan tipe turunan dari tabel DDL? |
| Field argumen | Apakah bisa dikonversi ke kolom DDL? |

**SSaC ↔ OpenAPI**

| Target validasi | Aturan |
|---|---|
| Nama fungsi | Apakah cocok dengan operationId? |
| Argumen request | Apakah field ada di skema permintaan? |
| Field @response | Apakah field ada di skema respons? |

**States ↔ SSaC ↔ OpenAPI**

| Target validasi | Aturan |
|---|---|
| Event transisi | Apakah cocok dengan nama fungsi SSaC? |
| Event transisi | Apakah cocok dengan operationId OpenAPI? |
| SSaC @state | Apakah stateDiagram yang direferensikan ada? |
| Field @state | Apakah ada sebagai kolom DDL? |

**Policy ↔ SSaC ↔ DDL**

| Target validasi | Aturan |
|---|---|
| allow (action, resource) | Apakah cocok dengan @auth SSaC? |
| @ownership table.column | Apakah ada di DDL? |
| @ownership via join | Apakah FK tabel join ada di DDL? |

**Func ↔ SSaC**

| Target validasi | Aturan |
|---|---|
| Referensi @call | Apakah ada implementasi Func yang sesuai? |
| Jumlah/tipe argumen | Apakah argumen @call dan field Request cocok? |
| Body fungsi | Bukan stub TODO? (WARNING) |

**Scenario ↔ OpenAPI**

| Target validasi | Aturan |
|---|---|
| operationId | Apakah ada di OpenAPI? |
| HTTP method | Apakah cocok dengan metode OpenAPI? |
| Field JSON | Apakah ada di skema permintaan? |

**STML ↔ SSaC** — Keduanya merujuk operationId OpenAPI yang sama. Ketika validasi keduanya lolos, kesesuaian antara API yang dipanggil frontend dan API yang diproses backend otomatis terjamin.

## Dirancang untuk agen

Fullend dirancang untuk agen AI.

Agar agen bisa menulis spec, ia perlu mengetahui 10 tipe sequence SSaC, atribut data-* STML, ekstensi x- OpenAPI, aturan stateDiagram, pola kebijakan OPA, sintaks skenario Gherkin, aturan Func Spec, dan aturan pencocokan nama. Untuk itu kami menyediakan manual AI sekitar 830 baris. Cukup dimasukkan sekali ke system prompt agen.

Loop validasi setelah penulisan spec sederhana:

```
Alur kerja agen:
1. Modifikasi specs/
2. fullend validate specs/my-project
3. Jika ada error → perbaiki SSOT terkait → kembali ke 2
4. Nol error → fullend gen specs/my-project artifacts/my-project
```

Tidak perlu memahami keseluruhan sistem. Cukup perbaiki apa yang ditunjuk validate untuk memulihkan konsistensi. Model pintar berhasil sekali coba, model kecil berhasil tiga kali coba. Hasilnya sama.

## Ukuran SSOT berdasarkan skala

| Skala | Contoh | SSOT | Kode implementasi | Okupasi konteks |
|---|---|---|---|---|
| Kecil | Reservasi salon kecantikan | ~1.500 baris | ~10.000 baris | ~8% |
| Menengah | Setara Jira atau Notion | ~12.500 baris | ~100.000 baris | ~55% |
| Besar | Setara Shopify | ~30.000 baris | ~300.000 baris | ~90% |

Berdasarkan konteks 200K token. Hingga SaaS skala menengah, agen bisa membaca seluruh desain sekaligus.

## Pemolaan pengecualian

Yang tidak bisa diekspresikan dengan 10 tipe sequence dialihkan ke `@call`. Yang tidak bisa diekspresikan dengan atribut data-* dialihkan ke `custom.ts`. Jika escape hatch ini melebihi 20% dari total, strukturisasi kehilangan maknanya.

Namun, pengecualian begitu diisolasi menjadi bisa diamati. Ketika banyak proyek distrukturisasi dengan Fullend, pola berulang akan muncul di `@call` dan `custom.ts`.

10 tipe sequence SSaC tidak dirancang sejak awal. Mereka konvergen menjadi 10 setelah mengamati ratusan kode layanan. Kami berharap prinsip yang sama berulang pada escape hatch. Pola `@call` yang sering muncul menjadi tipe sequence baru, dan pola `custom.ts` yang sering muncul menjadi atribut data-* baru.

Pengecualian tidak berkurang — struktur tumbuh dari pengecualian.

## Perluasan tech stack

Saat ini Fullend terpaku pada Go(gin) + React + PostgreSQL + Terraform. Ini disengaja. Pada tahap proof of concept, prioritasnya adalah menembus satu stack secara menyeluruh.

Namun, sebagian besar dari 10 SSOT (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) sudah independen dari bahasa pemrograman. 10 tipe sequence SSaC adalah pola yang tidak terikat bahasa — hanya diekspresikan sebagai komentar Go. STML menggunakan atribut HTML5 data-* sehingga independen dari framework.

Perluasan adalah masalah menambahkan backend generasi kode. Logika validasi dan aturan validasi silang tetap tidak berubah.

## Hubungan dengan GEUL

10 SSOT membentuk keseluruhan keputusan perangkat lunak. SSOT adalah data terstruktur. Data terstruktur adalah graf. Graf bisa dikodekan dalam GEUL.

`data-fetch="ListReservations"` di STML adalah relasi antar-entitas. `@get → @empty → @state → @call → @put → @response` di SSaC adalah sequence peristiwa. Transisi di stateDiagram adalah graf status. Kebijakan OPA adalah relasi otorisasi. Definisi endpoint di OpenAPI adalah kontrak. Semuanya adalah struktur semantik yang bisa diekspresikan dengan triple edge, event6 edge, dan entity node di GEUL.

Cara Fullend melakukan validasi silang antar 10 SSOT — pencocokan simbolik, pemeriksaan konsistensi tipe, verifikasi integritas referensi — adalah prinsip yang sama dengan verifikasi mekanis dalam stream GEUL.

## Lisensi

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
