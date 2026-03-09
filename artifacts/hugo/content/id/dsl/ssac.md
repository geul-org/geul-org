---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Mendeklarasikan logika layanan dalam komentar Go dan menghasilkan kode implementasi. 10 tipe sequence tetap mencakup semua operasi kontrak biner di layer layanan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — menghasilkan kode layanan dari DSL komentar Go.

Logika layanan adalah serangkaian keputusan: model mana yang di-query, apa yang dijaga, kapan menolak, apa yang dikembalikan. Keputusan ini milik orang yang memahami bisnis — tapi terkubur dalam boilerplate, tersebar di berbagai layer, dan hilang saat rewrite.

SSaC menyimpan keputusan ini sebagai spesifikasi deklaratif. Anda mendeklarasikan **apa** yang terjadi dan **dalam urutan apa**. Tool menghasilkan implementasinya.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Ide Inti

Setiap fungsi layanan adalah urutan langkah. Setiap langkah mengikuti kontrak biner: **berhasil → baris berikutnya, gagal → return**. Ini bukan abstraksi yang kami ciptakan — ini cara logika layanan sudah bekerja. SSaC membuatnya eksplisit.

10 tipe sequence tetap mencakup semua operasi layer layanan yang mengikuti kontrak ini. Yang tidak cocok, delegasikan ke `call`. Set ini tertutup secara desain.

Tanpa LLM, tanpa inferensi — codegen simbolik murni dari template. Spesifikasi adalah sumber kebenaran tunggal.

## Contoh

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

Deklarasi 10 baris ini menghasilkan kode berikut:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## Tipe Sequence (10)

| Tipe | Peran |
|---|---|
| `authorize` | Pemeriksaan izin (OPA, dll.) |
| `get` | Pencarian sumber daya |
| `guard nil` | Keluar jika null |
| `guard exists` | Keluar jika ada |
| `post` | Pembuatan sumber daya |
| `put` | Pembaruan sumber daya |
| `delete` | Penghapusan sumber daya |
| `password` | Perbandingan kata sandi |
| `call` | Panggilan eksternal (@component / @func) |
| `response` | Mengembalikan respons (json) |

## Fitur Codegen

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
      allowed: [room, user]
```

## Lisensi

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
