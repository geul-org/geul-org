---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI yang memvalidasi silang 10 SSOT dan menghasilkan kode. Menambal retakan vibe coding dengan struktur."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI yang memvalidasi silang 10 SSOT sekaligus dan menghasilkan kode.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositori GitHub</a>

## Retakan dalam Vibe Coding

Seiring populernya vibe coding, sebuah pola mulai terlihat.

Minta AI "buatkan fitur reservasi" dan ia membuatnya. Minta "tambahkan fitur pembatalan" dan ia menambahkannya. Saat fitur kelima selesai, fitur kedua rusak. Anda mengubah skema API tapi lupa memperbarui frontend. Menambahkan kolom database tapi lapisan layanan tidak mengetahuinya.

Penyebabnya sederhana: AI tidak mampu mengingat seluruh codebase.

Maka yang dilakukan orang: ketika sesuatu rusak, mereka bilang ke AI "perbaiki ini juga." Diperbaiki, lalu bagian lain rusak. "Perbaiki itu juga." Loop berulang. Semakin besar proyek, semakin panjang loop-nya, hingga akhirnya "memulai dari awal lebih cepat."

## Mengapa Kode Membengkak?

Dalam kode, dua hal bercampur jadi satu.

**Keputusan**: apa yang ditampilkan, API mana yang dipanggil, urutan pemrosesan, apa yang disimpan.
**Wiring**: kode yang mengimplementasikan keputusan tersebut dalam framework tertentu.

Misalkan Anda membangun sistem reservasi.

```
Keputusan: "Saat membatalkan reservasi: periksa otoritas → cari → validasi transisi status → hitung pengembalian dana → ubah status → respons"
```

Satu keputusan ini tersebar ke React hooks, Go handlers, query SQL, skema API, dan resource Terraform. Masing-masing dibungkus sintaks framework-nya, ditambah penanganan error dan konversi tipe.

Dari 100.000 baris kode, keputusan hanya 12.500 baris. Sisanya 87.500 baris adalah wiring.

Agen AI memiliki context window yang terbatas. Saat menambahkan fitur kesepuluh, mereka tidak mengingat sembilan fitur sebelumnya. Mereka tidak bisa membaca 100.000 baris sekaligus.

Pisahkan keputusan saja dan hasilnya 12.500 baris. Itu 55% dari konteks 200K token. Cukup kecil untuk dibaca AI dalam sekali jalan.

## 10 SSOT

Fullend memisahkan semua keputusan perangkat lunak menjadi 10 spesifikasi deklaratif. Setiap spesifikasi menjadi sumber kebenaran tunggal (SSOT) untuk aspek yang bersangkutan.

| Aspek | SSOT | Apa yang Dideklarasikan |
|---|---|---|
| Konfigurasi proyek | fullend.yaml | Tech stack, middleware, path modul |
| Antarmuka | [STML](/id/dsl/stml/) (HTML5 + data-*) | Apa yang ditampilkan dan apa yang dilakukan |
| Kontrak API | OpenAPI 3.x | Permintaan apa yang diterima dan respons apa yang dikembalikan |
| Alur layanan | [SSaC](/id/dsl/ssac/) (.ssac DSL) | Urutan pemrosesan |
| Struktur data | SQL DDL + sqlc | Apa yang disimpan |
| Fungsi eksternal | Func Spec (Go) | Antarmuka dan implementasi logika kustom |
| Transisi status | Mermaid stateDiagram | Status apa saja yang dilalui resource |
| Kebijakan otorisasi | OPA Rego | Siapa yang boleh melakukan apa |
| Skenario | Gherkin (.feature) | Verifikasi alur bisnis antar-endpoint |
| Infrastruktur | Terraform HCL | Di mana dijalankan |

OpenAPI, SQL DDL, dan Terraform adalah standar industri. Aspek lainnya belum memiliki DSL SSOT yang sesuai. Alur layanan tersebar di Go handlers, keputusan antarmuka terbenam di React hooks, transisi status tersembunyi di percabangan if-else, dan otorisasi di-hardcode di middleware. Karena itu dirancang STML, SSaC, Func Spec, integrasi stateDiagram, integrasi OPA, dan integrasi Gherkin.

```
specs/my-project/
├── fullend.yaml             → Konfigurasi proyek
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (ekstensi .ssac)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` adalah kebenaran. `artifacts/` bisa diregenerasi kapan saja.

## Validasi Individual Sudah Ada

Alat validasi untuk beberapa lapisan sudah tersedia.

- sqlc memeriksa konsistensi antara DDL dan query.
- Validator OpenAPI memeriksa validitas skema.
- Terraform memeriksa sintaks dan dependensi HCL.

Validator bawaan juga dibuat untuk STML dan SSaC. SSaC memeriksa konsistensi internal alur layanan; STML memeriksa kesesuaian antara deklarasi UI dan OpenAPI.

Setiap SSOT bisa divalidasi sendiri-sendiri. Masalahnya muncul **di antara** mereka.

Frontend menampilkan field dengan `data-bind="memo"`, tapi skema respons API tidak memiliki `memo`. SSaC memanggil `@delete Reservation.SoftDelete(request.ReservationID)`, tapi tidak ada metode `SoftDelete` di query sqlc. State diagram mendefinisikan transisi `PublishCourse`, tapi tidak ada fungsi SSaC yang sesuai. Kebijakan OPA memeriksa kepemilikan resource `course` melalui `courses.instructor_id`, tapi DDL tidak memiliki kolom tersebut.

Alat individual hanya melihat lapisannya sendiri. Mereka tidak bisa melihat retakan antar-lapisan.

## Menyembunyikan Struktur

"Tapi bukankah harus belajar 10 DSL?"

Benar. Tapi struktur tidak perlu ditampilkan kepada pengguna.

Jika Anda memasukkan tech stack dan aturan SSOT ke system prompt agen, pengguna cukup berkata "buatkan fitur reservasi." Agen menambahkan endpoint di OpenAPI, membuat tabel di DDL, mendeklarasikan alur layanan di SSaC, menggambar state diagram, menulis kebijakan OPA, menggambar layar di STML, dan menjalankan `fullend validate` untuk memverifikasi konsistensi.

Pengguna hanya melihat hasilnya. Struktur dikonsumsi oleh agen, bukan dipelajari oleh pengguna.

Pengalaman vibe coding tetap sama. Yang berubah adalah tidak ada yang rusak di balik layar.

## Peran Fullend

Fullend adalah validator silang. Ia tidak menemukan ulang alat individual. Ia memanggil setiap alat dan memeriksa batas antar-SSOT.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Memvalidasi masing-masing dari 10 SSOT secara individual, lalu melakukan validasi silang di antara mereka. Func hanya divalidasi ketika direktori `func/` ada. Gunakan `--skip` untuk mengecualikan SSOT tertentu.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
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

Ketika validasi lolos, kode dihasilkan. Opsi `--skip` bekerja sama seperti pada validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc menghasilkan model DB, oapi-codegen menghasilkan tipe API, SSaC menghasilkan gin handler, STML menghasilkan komponen React, paket state machine dan OPA Authorizer dihasilkan, tes Hurl dihasilkan dari Gherkin, dan Fullend menghasilkan glue code yang menghubungkan semuanya.

### gen-model

Menghasilkan file model Go (interface + types + HTTP client) dari dokumen OpenAPI eksternal. Menerima path file lokal atau URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Melacak semua node SSOT yang terhubung ke satu operasi API. Satu operationId masuk, peta file:line lintas-lapisan keluar.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

Menampilkan ringkasan SSOT yang terdeteksi beserta statistiknya.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## Fungsi dan Model Bawaan

Fullend menyertakan implementasi fungsi umum dan antarmuka model. Keduanya bisa dipanggil melalui `@call` di SSaC.

### Fungsi Default (pkg/)

| Paket | Fungsi | Deskripsi |
|---|---|---|
| `auth` | `hashPassword` | Hashing password dengan bcrypt |
| `auth` | `verifyPassword` | Verifikasi password bcrypt |
| `auth` | `issueToken` | Pembuatan access token JWT (24 jam) |
| `auth` | `verifyToken` | Verifikasi token JWT + ekstraksi claims |
| `auth` | `refreshToken` | Pembuatan refresh token (7 hari) |
| `auth` | `generateResetToken` | Token hex acak untuk reset password |
| `crypto` | `encrypt` | Enkripsi simetris AES-256-GCM |
| `crypto` | `decrypt` | Dekripsi AES-256-GCM |
| `crypto` | `generateOTP` | Secret TOTP + URL provisioning QR |
| `crypto` | `verifyOTP` | Verifikasi kode TOTP |
| `storage` | `uploadFile` | Upload file kompatibel S3 |
| `storage` | `deleteFile` | Penghapusan file kompatibel S3 |
| `storage` | `presignURL` | URL download presigned S3 |
| `mail` | `sendEmail` | Email teks biasa SMTP |
| `mail` | `sendTemplateEmail` | Email HTML template Go melalui SMTP |
| `text` | `generateSlug` | Unicode ke slug URL-safe |
| `text` | `sanitizeHTML` | Sanitasi HTML pencegahan XSS |
| `text` | `truncateText` | Pemotongan teks aman Unicode |
| `image` | `ogImage` | Pembuatan gambar OG (1200x630, PNG) |
| `image` | `thumbnail` | Pembuatan thumbnail (200x200, PNG) |

Proyek dapat meng-override fungsi ini dengan menyediakan implementasi kustom di `specs/<project>/func/<pkg>/`.

### Model Bawaan (pkg/)

Antarmuka @model dengan prefix paket untuk I/O non-DDL. Dikonfigurasi melalui `fullend.yaml`.

| Paket | Antarmuka | Backend | Penggunaan SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (Dihasilkan)

Fullend menghasilkan `internal/middleware/bearerauth.go` khusus proyek dari konfigurasi claims di `fullend.yaml`.

| Middleware | Pemicu | Deskripsi |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Mengekstrak JWT dan menyetel `*model.CurrentUser` di konteks gin |

Pengelompokan rute ditentukan oleh field `security` di OpenAPI. Operasi dengan `security: [{bearerAuth: []}]` masuk ke grup auth; operasi tanpa field tersebut masuk ke grup publik.

## Aturan Validasi Silang

Nilai unik Fullend terletak pada validasi silang. Setelah alat individual memvalidasi lapisannya masing-masing, Fullend menangkap ketidakcocokan antar-SSOT.

**fullend.yaml ↔ OpenAPI**
| Target | Aturan |
|---|---|
| Nama middleware | Apakah cocok dengan kunci securitySchemes? |

**OpenAPI ↔ DDL**
| Target | Aturan |
|---|---|
| x-sort.allowed | Apakah kolom ada di tabel? |
| x-sort ↔ DDL index | Apakah kolom memiliki indeks? (WARNING) |
| x-filter.allowed | Apakah kolom ada di tabel? |
| x-include.allowed | Apakah tabel terhubung melalui FK? |

**SSaC ↔ DDL**
| Target | Aturan |
|---|---|
| Model.Method | Apakah metode ada di query sqlc? |
| @result Type | Apakah cocok dengan tipe turunan dari tabel DDL? |
| Field argumen | Apakah bisa dipetakan ke kolom DDL? |

**SSaC ↔ OpenAPI**
| Target | Aturan |
|---|---|
| Nama fungsi | Apakah cocok dengan operationId? |
| Argumen request | Apakah field ada di skema permintaan? |
| Field @response | Apakah field ada di skema respons? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| Target | Aturan |
|---|---|
| Event transisi | Apakah cocok dengan nama fungsi SSaC? |
| Event transisi | Apakah cocok dengan operationId OpenAPI? |
| SSaC @state | Apakah stateDiagram yang direferensikan ada? |
| Field @state | Apakah ada sebagai kolom DDL? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| Target | Aturan |
|---|---|
| allow (action, resource) | Apakah cocok dengan @auth SSaC? |
| @ownership table.column | Apakah ada di DDL? |
| @ownership via join | Apakah FK tabel join ada di DDL? |
| Event transisi status | Apakah ada aturan Rego yang sesuai untuk transisi dengan @auth? |

**Func ↔ SSaC**
| Target | Aturan |
|---|---|
| Referensi @call | Apakah ada implementasi Func yang sesuai? |
| Jumlah argumen | Apakah jumlah argumen @call cocok dengan jumlah field Request? |
| Tipe argumen | Apakah tipe posisional cocok melalui DDL/OpenAPI? |
| Result/response | Apakah result/response konsisten? |
| Body fungsi | Bukan stub TODO? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| Target | Aturan |
|---|---|
| operationId | Apakah ada di OpenAPI? |
| HTTP method | Apakah cocok dengan metode OpenAPI? |
| Field JSON | Apakah ada di skema permintaan? |
| Urutan langkah | Apakah mengikuti aturan transisi status? |

**Queue (Pub/Sub)**
| Target | Aturan |
|---|---|
| @publish topic | Apakah ada fungsi @subscribe yang sesuai? |
| Field payload/message | Apakah konsisten? |
| Konfigurasi queue | Apakah fullend.yaml memiliki konfigurasi queue? |

**STML ↔ SSaC** — Keduanya merujuk operationId OpenAPI yang sama. Jika kedua validasi lolos, konsistensi antara API yang dipanggil frontend dan API yang ditangani backend otomatis terjamin.

## Pengujian Runtime

`fullend gen` menghasilkan tes [Hurl](https://hurl.dev) dari spesifikasi OpenAPI dan skenario Gherkin.

```bash
# Setelah memulai server:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Tes yang dihasilkan:
- **smoke.hurl** — Tes smoke endpoint OpenAPI (dihasilkan otomatis)
- **scenario-*.hurl** — Tes skenario bisnis (dari file .feature)
- **invariant-*.hurl** — Tes invarian antar-endpoint (dari file .feature)

## Dirancang untuk Agen

Fullend dirancang untuk agen AI.

Agar agen bisa menulis spec, ia perlu mengetahui 10 tipe sequence SSaC, atribut data-* STML, ekstensi x- OpenAPI, aturan stateDiagram, pola kebijakan OPA, sintaks skenario Gherkin, aturan Func Spec, dan aturan pencocokan nama. Manual AI sekitar 830 baris disediakan. Cukup ditambahkan sekali ke system prompt agen.

Loop validasi setelah penulisan spec sangat sederhana.

```
Alur kerja agen:
1. Modifikasi specs/
2. fullend validate specs/my-project
3. Jika ada error → perbaiki SSOT terkait → kembali ke 2
4. Nol error → fullend gen specs/my-project artifacts/my-project
```

Tidak perlu memahami keseluruhan sistem. Cukup perbaiki apa yang ditunjuk validate dan konsistensi pulih. Model pintar berhasil sekali coba; model kecil berhasil tiga kali coba. Hasilnya sama.

## Ukuran SSOT Berdasarkan Skala

| Skala | Contoh | SSOT | Kode Implementasi | Penggunaan Konteks |
|---|---|---|---|---|
| Kecil | Reservasi salon kecantikan | ~1.500 baris | ~10.000 baris | ~8% |
| Menengah | Setara Jira/Notion | ~12.500 baris | ~100.000 baris | ~55% |
| Besar | Setara Shopify | ~30.000 baris | ~300.000 baris | ~90% |

Berdasarkan konteks 200K token. Hingga SaaS skala menengah, agen bisa membaca seluruh desain dalam sekali jalan.

## Mengubah Pengecualian Menjadi Pola

Yang tidak bisa ditangani 10 tipe sequence dialihkan ke `@call`. Yang tidak bisa ditangani atribut data-* dialihkan ke `custom.ts`. Jika escape hatch ini melebihi 20% dari total, strukturisasi kehilangan maknanya.

Namun pengecualian menjadi bisa diamati begitu diisolasi. Seiring banyak proyek mengadopsi Fullend, pola berulang akan muncul di `@call` dan `custom.ts`.

10 tipe sequence SSaC tidak dirancang dari awal. Mereka konvergen menjadi 10 setelah mengamati ratusan contoh kode layanan. Prinsip yang sama diharapkan berulang pada escape hatch. Pola `@call` yang sering muncul menjadi tipe sequence baru; pola `custom.ts` yang sering muncul menjadi atribut data-* baru.

Pengecualian tidak berkurang — struktur tumbuh darinya.

## Perluasan Tech Stack

Saat ini Fullend terpaku pada Go(gin) + React + PostgreSQL + Terraform. Ini disengaja. Pada tahap PoC, menembus satu stack secara menyeluruh lebih diutamakan.

Namun banyak dari 10 SSOT (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) sudah independen dari bahasa pemrograman. 10 tipe sequence SSaC adalah pola yang tidak terikat bahasa — hanya diekspresikan sebagai komentar Go. STML menggunakan atribut HTML5 data-* dan independen dari framework.

Perluasan adalah masalah menambahkan backend generasi kode. Logika validasi dan aturan validasi silang tetap tidak berubah.

## Hubungan dengan GEUL

10 SSOT membentuk keseluruhan keputusan perangkat lunak. SSOT adalah data terstruktur. Data terstruktur adalah graf. Graf bisa dikodekan dalam GEUL.

`data-fetch="ListReservations"` di STML adalah relasi antar-entitas. `@get → @empty → @state → @call → @put → @response` di SSaC adalah sequence peristiwa. Transisi stateDiagram adalah graf status. Kebijakan OPA adalah relasi otorisasi. Definisi endpoint OpenAPI adalah kontrak. Semuanya adalah struktur semantik yang bisa diekspresikan dengan triple edge, event6 edge, dan entity node di GEUL.

Cara Fullend melakukan validasi silang antar 10 SSOT — pencocokan simbolik, pemeriksaan konsistensi tipe, verifikasi integritas referensial — beroperasi pada prinsip yang sama dengan verifikasi mekanis dalam stream GEUL.

## Lisensi

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
