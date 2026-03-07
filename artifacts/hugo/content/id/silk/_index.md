---
title: "SILK — Indeks Simbolik untuk Pengetahuan LLM"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "Arsitektur pencarian neuro-simbolik menggunakan bilangan bulat 64-bit. Mencari 100 juta entitas Wikidata dalam waktu sub-detik dengan memori 1,3 GB, tanpa vector DB, graf ANN, atau model embedding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — arsitektur pencarian neuro-simbolik.

Mencari dengan bilangan bulat 64-bit. Tidak memerlukan vector DB, graf ANN, maupun model embedding.

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">Repositori GitHub</a>

## Tesis Utama

Pencarian bukanlah masalah yang sulit — ia adalah **gejala data tanpa struktur**.
Jika struktur 64-bit diberikan pada saat pencatatan, gejalanya menghilang.

```python
results = index[(index & mask) == pattern]
```

Pencarian 100 juta entitas Wikidata dalam memori 1,3 GB dengan waktu sub-detik.
Python (NumPy) saja mengalahkan vector DB C++/Rust yang sudah dioptimasi — kemenangan arsitektur.

## Mengapa Bukan Embedding Vektor?

Embedding vektor menghancurkan struktur.

```
"Diponegoro adalah panglima perang Jawa pada abad ke-19"
 → Manusia langsung memahami: orang Jawa, militer, abad ke-19

Model embedding:
 [0.234, -0.891, 0.445, ..., 0.112] (384 dimensi float)
 → Struktur hilang. Tidak bisa dibaca apakah person atau location.

Untuk memulihkan struktur yang hancur:
 Graf ANN (HNSW, IVF-PQ), cross-encoder, reranker, filter metadata...
```

SILK mempertahankan struktur.

```
SIDX: [Human / military / southeast_asia / early_modern]
 → Struktur hidup di dalam bit. Bisa dibaca.
 → Tidak perlu dipulihkan. Karena tidak pernah dihancurkan.
```

Intinya adalah pembalikan urutan.

```
Konvensional: tulis dulu → strukturkan kemudian (indexing)
SILK: strukturkan saat menulis → pencarian gratis
```

## Tata Letak Bit SIDX

SIDX mengikuti spesifikasi Entity Node dalam [tata bahasa GEUL](/id/grammar/).

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Field | Bit | Ukuran | Deskripsi |
|-------|-----|--------|-----------|
| prefix | 63-57 | 7 | Header protokol GEUL (tetap `0001001`, diabaikan saat pencarian) |
| mode | 56-54 | 3 | Mode kuantisasi/jumlah (entitas terdaftar=0, definit, universal, eksistensial, dsb. — 8 mode) |
| entity_type | 53-48 | 6 | 64 tipe teratas (Human=0 ~ Election=62, belum diklasifikasi=63) |
| attrs | 47-0 | 48 | Encoding atribut per tipe (didefinisikan oleh codebook) |

Cakupan pencarian: entity_type 6 bit + attrs 48 bit = **54 bit**.
QID tidak termasuk dalam SIDX dan disimpan dalam array terpisah.

### attrs 48 bit — Skema per Tipe

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Saat ini tata letak atribut untuk 5 tipe telah didefinisikan. Sisanya hanya di-encode berdasarkan entity_type.

## Arsitektur

SILK memiliki dua pipeline: **encoding** (saat menulis) dan **pencarian** (saat mencari).
Keduanya dengan prinsip yang sama: simbolik menangani struktur, LLM memproses makna.

```
Pipeline Encoding (saat menulis)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Tagging LLM │──►│  Validasi    │──►│ Encoding     │
│  dokumen →   │   │  VALID       │   │ codebook     │
│  JSON        │   │ nilai valid  │   │ JSON → SIDX  │
│  (klasifikasi│   │ cek konsist. │   │ (rakit bit)  │
│   semantik)  │   │ halusinasi → │   │              │
│              │   │ tolak        │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
   LLM men-tag      kode memvalidasi  encoding berbasis codebook
```

```
Pipeline Pencarian (saat mencari)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Interpretasi│──►│ Filter       │──►│  Keputusan   │
│  kueri       │   │ bit AND      │   │  LLM         │
│  lookup      │   │  NumPy SIMD  │   │ hanya kandidat│
│  codebook    │   │100M → puluhan│   │ puluhan →    │
│  + bantu LLM │   │              │   │ jawaban      │
└──────────────┘   └──────────────┘   └──────────────┘
   ekstraksi makna   filter luas       keputusan presisi
```

Strategi utama: **filter luas dengan bit AND pada SIDX tanpa kehilangan**, kemudian **LLM memutuskan hanya pada kandidat yang sedikit**.

```
Masing-masing melakukan yang terbaik:
 Manusia: desain struktur (codebook)
 LLM:  klasifikasi semantik (tagging) + keputusan semantik (pencarian)
 Kode: validasi aturan (VALID) + perakitan bit
 CPU:  perbandingan massal (NumPy SIMD)
```

### Encoding: Tagging LLM → Validasi VALID

LLM membaca dokumen dan men-tag ke JSON. VALID melakukan pemeriksaan mekanis berdasarkan codebook.
Nilai yang tidak ada di codebook, pelanggaran konsistensi antar-tipe, dan pelanggaran constraint **secara fisik tidak bisa masuk ke indeks.**

```
Tagging LLM: {"type": "Human", "occupation": "military", "country": "indonesia"}
VALID:    occupation="military" ∈ codebook? ✓  country="indonesia" ∈ codebook? ✓
          Human dengan field constellation? ✗ ditolak
Encoding:   "military"→6 bit, "indonesia"→8 bit dari codebook → rakit bit → SIDX uint64
```

LLM bisa berhalusinasi. Tapi VALID berperan sebagai penjaga gerbang sehingga kemungkinan kontaminasi indeks adalah nol.
Hanya JSON yang lolos VALID yang di-encode menjadi bilangan bulat SIDX 64-bit berdasarkan codebook.

### Pencarian: Filter Luas, LLM Mempersempit

```
1. Ekstraksi makna kueri     lookup codebook 80% / bantuan LLM 20%
2. Perakitan bitmask         deterministik — algoritma
3. bit AND via NumPy         deterministik — full scan 100M dalam 20ms
4. Keputusan akhir LLM       hanya kandidat sedikit — keputusan semantik presisi
```

### 80% Pencarian adalah Kueri Struktural

```
"Diponegoro"      → Q484523 exact match. bit AND. Selesai.
"berita Samsung"   → org/company + doc_meta/news. bit AND. Selesai.
"KTT Biden-Xi"    → Q6279 ∩ Q15031 ∩ meeting. Irisan. Selesai.
```

```
Kueri struktural (80%): bit AND SILK sudah cukup. LLM tidak diperlukan.
Kueri semantik (15%): SILK mempersempit kandidat → LLM memutuskan 5-10 kasus.
Kueri generatif  (5%): SILK mengidentifikasi dokumen → LLM menghasilkan.
```

## Multi-SIDX

Satu dokumen/peristiwa membawa beberapa SIDX.

```
Artikel berita "Pertemuan pimpinan Samsung, NVIDIA, dan Hyundai":

SIDX[0]: [Human / business / east_asia ]  Lee Jae-yong
SIDX[1]: [Org   / company / east_asia ]  Samsung
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Chung Eui-sun
SIDX[5]: [Org   / company / east_asia ]  Hyundai
SIDX[6]: [Event / meeting / east_asia ]  pertemuan
```

Semua SIDX 64-bit yang sama. Indeks yang sama. bit AND yang sama untuk pencarian.
Field entity_type membedakan entitas (Human, Org) dari peristiwa (Event).

## Struktur Indeks

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Total ~1,3 GB memori
```

```
Pembangunan indeks:
 Elasticsearch: tokenisasi → analisis → inverted index → merge segmen
 Pinecone:      embedding → graf HNSW → clustering
 SILK:          sort
```

Tanpa struktur data. Satu array terurut.

## Perbandingan dengan Vector DB

|  | SILK | Vector DB |
|------|------|---------|
| Ukuran indeks (1 triliun record) | 12TB | 1,5PB (125 kali lipat) |
| Pembangunan indeks | sort | HNSW berhari-hari |
| Cold start | buka file langsung jalan | pembangunan graf berjam-jam |
| Scan terbagi | bisa (hasil identik) | tidak bisa (graf terputus) |
| Kondisi kompleks | irisan (tepat) | kompresi ke satu vektor (aproksimasi) |
| Hasil | tepat (operasi himpunan) | aproksimasi (peringkat kemiripan) |
| Audit | JSON (white box) | tidak bisa (black box) |

```
bit AND tidak bergantung urutan, tanpa state, bisa diagregasi.
Vector DB: seluruh graf harus di memori. Pembagian = kehancuran.
SILK:    potong di mana saja tetap berjalan. Pembagian = hanya lebih lambat. Hasil identik.
```

## Pipeline Audit

Embedding vektor adalah black box yang tidak bisa diaudit. SIDX adalah JSON yang bisa diaudit.

```
Tahap 1 — Tagging LLM kecil     Llama 8B / GPT-4o-mini. Akurasi 85-90%.
Tahap 2 — Pemeriksaan VALID mekanis  nilai valid, konsistensi, constraint. Biaya $0.
Tahap 3 — Audit LLM besar       hanya confidence=low. Akurasi 99%+.

VALID adalah penjaga gerbang: halusinasi di luar nilai valid codebook secara fisik tidak bisa masuk ke indeks.
```

## Lisensi

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">Repositori GitHub</a>
