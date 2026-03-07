---
title: "Repositori"
date: 2026-02-28T12:00:00+09:00
summary: "Repositori GitHub yang membentuk proyek GEUL. Desain bahasa, pipeline encoding, mesin pencari, dan situs web."
image: "/images/og-default.webp"
---

Proyek GEUL terdiri dari empat repositori.

Mendesain bahasa (geul), mengkodekan entitas dunia ke dalam 64 bit (geul-sidx), mencari di atas indeks tersebut (silk), dan menjelaskan mengapa semua ini diperlukan (geul-org).

---

## geul

Bahasa buatan yang selaras secara semantik dan format aliran biner untuk AI.

Sistem bahasa 2 byte (65.536 simbol) yang dirancang untuk komunikasi tanpa ambiguitas antara manusia dan AI. Setiap pernyataan membawa sumber, stempel waktu, dan tingkat kepercayaannya. Setiap entitas memiliki pengenal unik. Format aliran beroperasi dalam unit 16 bit, mendefinisikan 10 jenis paket (Verb Edge, Entity Node, Triple Edge, dll.) di bawah skema prefiks 10 bit.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Bahasa | Go, Python |
| Lisensi | MIT |

---

## geul-sidx

Pembangun buku kode dan pipeline encoding SIDX (Semantic-aligned Index).

Mengkodekan 108,8 juta entitas Wikidata menjadi pengenal terstruktur 64 bit. Mendefinisikan 63 jenis entitas, mendesain skema atribut 48 bit per jenis, membangun buku kode, dan memvalidasi hasil encoding (VALID). Produsen indeks dan buku kode yang dikonsumsi oleh SILK.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Bahasa | Python |
| Lisensi | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — arsitektur pencarian neuro-simbolik.

Mencari dengan bilangan bulat 64 bit. Tidak memerlukan database vektor, graf ANN, maupun model embedding. Satu operasi AND bitwise NumPy mencari 100 juta rekaman, dan klaim utamanya adalah Python saja mengalahkan pencarian vektor C++/Rust yang telah dioptimalkan. Menyediakan pipeline kueri hibrida yang menggabungkan pencarian buku kode dengan bantuan LLM.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Bahasa | Python |
| Lisensi | MIT |

---

## geul-org

Kode sumber situs web ini.

Generator situs statis Hugo yang mendukung 12 bahasa. Di-deploy melalui S3 + CloudFront, dengan CloudFront Function untuk deteksi bahasa dan URL bersih.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Bahasa | Hugo (Go Templates), CSS |
| Lisensi | MIT |
