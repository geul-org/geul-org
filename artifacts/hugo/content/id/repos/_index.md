---
title: "Repositori"
date: 2026-02-28T12:00:00+09:00
summary: "Repositori GitHub yang membentuk proyek GEUL. Spesifikasi bahasa, buku kode tata bahasa, pencarian, DSL, dan situs web."
image: "/images/og-default.webp"
---

Semua repositori berada di organisasi [geul-org](https://github.com/geul-org) GitHub.

---

## Bahasa

### geul

Bahasa buatan yang selaras secara semantik dan format aliran biner untuk AI.

Sistem bahasa 2 byte (65.536 simbol) yang dirancang untuk komunikasi tanpa ambiguitas antara manusia dan AI. Setiap pernyataan membawa sumber, stempel waktu, dan tingkat kepercayaannya. Setiap entitas memiliki pengenal unik. Format aliran beroperasi dalam unit 16 bit, mendefinisikan 10 jenis paket (Verb Edge, Entity Node, Triple Edge, dll.) di bawah skema prefiks 10 bit.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Bahasa | Go, Python |
| Lisensi | MIT |

---

## Tata Bahasa

### geul-verb

Buku kode kata kerja SIDX 16 bit (berbasis WordNet).

Memetakan synset kata kerja WordNet ke kode 16 bit untuk digunakan dalam paket GEUL Verb Edge. Menyediakan kosakata kata kerja yang dikonsumsi format aliran.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Bahasa | Python |
| Lisensi | MIT |

### geul-entity

Buku kode entitas SIDX 48 bit (berbasis Wikidata).

Mengkodekan entitas Wikidata menjadi pengenal terstruktur 48 bit. Mendefinisikan jenis entitas, mendesain skema atribut per jenis, dan membangun buku kode yang dikonsumsi oleh SILK.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Bahasa | Python |
| Lisensi | MIT |

### geul-quantities

Buku kode node kuantitas.

Mendefinisikan skema encoding untuk nilai kuantitas — angka dengan satuan, rentang, dan presisi — yang digunakan dalam paket GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Bahasa | Python |
| Lisensi | MIT |

### geul-ast

Buku kode edge AST.

Mendefinisikan skema encoding untuk edge pohon sintaksis abstrak, memungkinkan representasi kode terstruktur dalam format aliran GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Bahasa | Python |
| Lisensi | MIT |

---

## Pencarian

### silk

SILK (Symbolic Index for LLM Knowledge) — arsitektur pencarian neuro-simbolik.

Mencari dengan bilangan bulat 64 bit. Tidak memerlukan database vektor, graf ANN, maupun model embedding. Satu operasi AND bitwise NumPy mencari 100 juta rekaman, dan klaim utamanya adalah Python saja mengalahkan pencarian vektor C++/Rust yang telah dioptimalkan. Menyediakan pipeline kueri hibrida yang menggabungkan pencarian buku kode dengan bantuan LLM.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Bahasa | Python |
| Lisensi | MIT |

---

## DSL

### fullend

Full-stack SSOT Orchestrator — memvalidasi konsistensi 5 sumber SSOT (STML, OpenAPI, SSaC, SQL DDL, Terraform) dan menghasilkan kode darinya.

Memanggil alat validasi individual setiap lapisan, lalu melakukan validasi silang batas antar lapisan. Setelah validasi lolos, mengorkestrasi pembuatan kode dari sqlc, oapi-codegen, SSaC, dan STML, serta menghasilkan kode penghubung.

| | |
|---|---|
| GitHub | [geul-org/fullend](https://github.com/geul-org/fullend) |
| Bahasa | Go |
| Lisensi | MIT |

### ssac

Service Sequences as Code — mem-parsing logika layanan deklaratif dari komentar Go dan menghasilkan kode implementasi Go melalui CLI.

Mendefinisikan alur layanan sebagai komentar terstruktur dalam file sumber Go. CLI membaca deklarasi ini dan menghasilkan kode implementasi yang sesuai, menghilangkan boilerplate sambil menjaga logika tetap terbaca dan terkontrol versinya.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| Bahasa | Go |
| Lisensi | MIT |

### stml

SSOT Template Markup Language — pengikatan deklaratif UI-ke-API dengan atribut HTML5 data-*, validasi simbolik terhadap OpenAPI, dan pembuatan kode React.

Mengikat template UI ke skema API menggunakan atribut HTML5 data. Memvalidasi secara simbolik terhadap spesifikasi OpenAPI saat build, lalu menghasilkan komponen React yang aman tipe. Satu sumber kebenaran dari skema ke layar.

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| Bahasa | TypeScript |
| Lisensi | MIT |

---

## Situs Web

### geul-org

Kode sumber situs web ini.

Generator situs statis Hugo yang mendukung 12 bahasa. Di-deploy melalui S3 + CloudFront, dengan CloudFront Function untuk deteksi bahasa dan URL bersih.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Bahasa | Hugo (Go Templates), CSS |
| Lisensi | MIT |
