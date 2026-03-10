---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Satu komentar Go adalah satu sequence. 10 tipe sequence tetap mencakup setiap cabang biner di service layer, dan codegen simbolik menghasilkan handler gin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — satu komentar Go adalah satu sequence. Deklarasikan, dan handler gin akan dihasilkan.

Logika layanan adalah serangkaian keputusan: model mana yang di-query, apa yang dijaga, kapan menolak, apa yang dikembalikan. Keputusan ini milik orang yang memahami bisnis — tetapi terkubur dalam boilerplate, tersebar di berbagai layer, dan hilang saat rewrite.

SSaC menyimpan keputusan ini sebagai spesifikasi deklaratif. Deklarasikan **apa** yang terjadi dan **dalam urutan apa**, satu baris per waktu, dan tool menghasilkan implementasinya.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (komentar DSL)        (validasi)       (codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositori GitHub</a>

## Ide Inti

Setiap fungsi layanan adalah urutan langkah. Setiap langkah mengikuti kontrak biner: **berhasil → baris berikutnya, gagal → return**. Ini bukan abstraksi yang kami ciptakan — ini cara logika layanan sudah bekerja. SSaC membuatnya eksplisit.

10 tipe sequence tetap mencakup setiap operasi service layer yang mengikuti kontrak ini. Yang tidak cocok didelegasikan ke `@call`. Set ini tertutup secara desain.

Tanpa LLM, tanpa inferensi — codegen simbolik murni berbasis template. Spesifikasi adalah sumber kebenaran tunggal.

## Sintaks — Satu Baris, Satu Sequence

Mulai v2, setiap sequence adalah satu baris komentar. Hanya `@response` yang menggunakan blok multi-baris.

**CRUD — Operasi Model**

```go
// @get Type var = Model.Method(args...)        — baca (hasil wajib)
// @post Type var = Model.Method(args...)       — buat (hasil wajib)
// @put Model.Method(args...)                   — perbarui (tanpa hasil)
// @delete Model.Method(args...)                — hapus (tanpa hasil)
```

Format argumen: `source.Field` atau `"literal"`

- `request.CourseID` — dari permintaan HTTP
- `course.InstructorID` — dari variabel hasil sebelumnya
- `currentUser.ID` — dari konteks autentikasi
- `"cancelled"` — string literal

**Guard**

```go
// @empty target "message"                      — gagal jika nil/zero (404)
// @exists target "message"                     — gagal jika bukan nil/zero (409)
```

Target: variabel (`course`) atau variabel.field (`course.InstructorID`)

**Transisi Status**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Otorisasi — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Panggilan Eksternal**

```go
// @call Type var = package.Func(args...)       — dengan hasil
// @call package.Func(args...)                  — tanpa hasil
```

**Respons — Blok Pemetaan Field**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Contoh

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "tidak memiliki izin"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "reservasi tidak ditemukan"
// @state reservation {status: reservation.Status} "cancel" "tidak dapat dibatalkan"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

Deklarasi 10 baris. Setiap baris adalah satu sequence, dieksekusi dari atas ke bawah secara berurutan. Auth → baca → guard → transisi status → panggilan eksternal → perbarui → baca ulang → respons.

## Tipe Sequence (10)

| Tipe | Peran |
|---|---|
| `@auth` | Pemeriksaan otorisasi (kebijakan OPA) |
| `@get` | Pembacaan sumber daya |
| `@empty` | Keluar jika nil/zero (404) |
| `@exists` | Keluar jika bukan nil/zero (409) |
| `@post` | Pembuatan sumber daya |
| `@put` | Pembaruan sumber daya |
| `@delete` | Penghapusan sumber daya |
| `@state` | Validasi transisi status |
| `@call` | Panggilan fungsi paket eksternal |
| `@response` | Mengembalikan respons (pemetaan field) |

## Validasi

Validasi internal (selalu):
- Argumen wajib hilang per tipe
- Format `Model.Method`
- Alur variabel (referensi sebelum deklarasi)

Validasi silang SSOT eksternal (saat struktur proyek terdeteksi):
- Keberadaan model/metode (query sqlc, interface Go)
- Keberadaan field request/response (OpenAPI)
- Keberadaan paket/fungsi (interface Go)
- Peringatan data basi: response setelah put/delete tanpa pengambilan ulang (WARNING)
- Keberadaan diagram status dan validitas transisi
- Keberadaan file kebijakan OPA

## Fitur Codegen

Ketika SSOT eksternal (tabel simbol) tersedia, `ssac gen` menyediakan fitur tambahan. Kode yang dihasilkan menggunakan framework gin.

- **Konversi tipe**: Tipe kolom DDL → `strconv.ParseInt`, `time.Parse`, return awal 400 Bad Request
- **Tipe nilai guard**: Pemeriksaan zero berdasarkan tipe (`int` → `== 0`/`> 0`, pointer → `== nil`/`!= nil`)
- **Derivasi interface model**: Referensi silang 3 sumber SSOT → `<outDir>/model/models_gen.go`
- **Codegen @state**: Memanggil `CanTransition` dari paket diagram status
- **Codegen @auth**: Memanggil `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **Codegen @call**: Gaya guard (401) tanpa hasil, gaya nilai (500) dengan hasil
- **Struktur folder domain**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## Ekstensi OpenAPI x-

Parameter infrastruktur (paginasi, pengurutan, pemfilteran, penyertaan relasi) dideklarasikan dalam ekstensi OpenAPI `x-`. Hanya parameter bisnis yang dideklarasikan dalam spesifikasi SSaC. Code generator membaca ekstensi `x-` dan menyusun `QueryOpts` secara otomatis.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## Lisensi

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositori GitHub</a>
