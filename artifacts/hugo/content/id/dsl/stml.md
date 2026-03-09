---
title: "STML — SSOT Template Markup Language"
weight: 1
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "Bahasa deklarasi UI yang independen dari framework. Mendefinisikan apa yang ditampilkan dan dilakukan halaman dengan atribut HTML5 data-*, memvalidasi secara simbolik terhadap OpenAPI, dan menghasilkan kode React."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — deklarasi UI yang independen dari framework.

Kode frontend mencampur dua hal: **keputusan Anda** dan **wiring framework**. API mana yang dipanggil, field mana yang ditampilkan, dalam urutan apa, dalam kondisi apa — keputusan ini terkubur dalam React hooks atau Vue composables. Saat mengganti framework atau refactoring, keputusan diinterpretasi ulang atau hilang.

STML memisahkannya. Keputusan tetap dalam HTML standar dengan atribut `data-*`. Wiring framework dihasilkan atau didelegasikan.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">Repositori GitHub</a>

## Struktur

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  Keputusan Anda. Independen framework.
│  Apa yang diambil, ditampilkan, │  Bertahan dari rewrite apapun.
│  dikirim                        │
├─────────────────────────────────┤
│  Codegen / LLM                  │  Menghasilkan wiring framework.
│  React, Vue, Svelte, apapun    │  Dapat diganti.
├─────────────────────────────────┤
│  Runtime (artifacts/)           │  React TSX, Vue SFC, dll.
│  Hooks, state, rendering       │  Dihasilkan. Jangan diedit.
└─────────────────────────────────┘
```

## Yang Dipertahankan

Semua dalam HTML STML adalah keputusan pengguna:

- **Endpoint API mana** yang dipanggil (`data-fetch`, `data-action`)
- **Field mana** yang ditampilkan atau dikumpulkan (`data-bind`, `data-field`)
- **Urutan** kemunculan elemen (struktur DOM)
- **Tampilan** (kelas Tailwind, tag HTML)
- **Teks** yang dilihat pengguna (judul, placeholder, label tombol)
- **Kondisi** yang mengontrol visibilitas (`data-state`)
- **Komponen** yang menangani UX khusus (`data-component`)
- **Perilaku daftar** — paginasi, pengurutan, pemfilteran

Bukan React. Bukan Vue. Ini apa yang dilakukan halaman Anda, dideklarasikan dalam HTML5 standar.

## Validasi

Validator bawaan memeriksa silang STML terhadap OpenAPI sebelum kode dihasilkan:

- Apakah operationId ada? Apakah metode HTTP benar?
- Apakah field request, response, dan parameter cocok dengan schema?
- Apakah kolom sort/filter/include ada dalam daftar yang diizinkan?
- Apakah komponen yang direferensikan ada?

Menangkap ketidakcocokan frontend-API saat CI, bukan saat runtime.

```bash
stml validate specs/my-project    # 12 pemeriksaan simbolik terhadap OpenAPI
```

## Atribut data-*

| Atribut | Yang dideklarasikan |
|---|---|
| `data-fetch` | Memuat data dari endpoint GET |
| `data-action` | Mengirim data ke endpoint POST/PUT/DELETE |
| `data-field` | Mengumpulkan field body request |
| `data-bind` | Menampilkan field response |
| `data-param-*` | Operasi membutuhkan parameter path/query |
| `data-each` | Mengulang field array |
| `data-state` | Ditampilkan secara kondisional |
| `data-component` | Mendelegasikan ke komponen kustom |
| `data-paginate` | Daftar berpaginasi |
| `data-sort` | Daftar yang dapat diurutkan (kolom dan arah default) |
| `data-filter` | Daftar yang dapat difilter (kolom mana) |
| `data-include` | Menyertakan sumber daya terkait |

## Lisensi

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
