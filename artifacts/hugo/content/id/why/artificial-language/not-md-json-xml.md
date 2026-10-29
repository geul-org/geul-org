---
title: "Mengapa MD/JSON/XML Tidak Bisa"
weight: 9
date: 2026-02-26T12:00:15+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["format", "JSON", "XML"]
summary: "Markdown, JSON, dan XML masing-masing dibuat untuk zaman dan tujuan yang berbeda. Mereka punya struktur tetapi tidak punya makna yang seragam, dan tidak ada tempat untuk sumber. Mengapa dibutuhkan format tersendiri untuk mencatat dan mengakumulasi penalaran AI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Format terstruktur sudah ada. Jadi mengapa bahasa baru diperlukan?

---

## Keberatan Paling Umum

Ketika seseorang pertama kali menemui ide bahasa penalaran AI, hal pertama yang mereka katakan adalah:

"Format terstruktur sudah ada, bukan?"

Mereka benar. Sudah ada. Banyak.

Ada Markdown. Ada JSON. Ada XML. YAML, TOML, Protocol Buffers, MessagePack, CSV...

Dunia dibanjiri format data. Jadi mengapa AI masih berpikir dalam bahasa alami?

Untuk menjawab pertanyaan ini, kita harus menentukan tepat apa yang dilakukan setiap format dengan baik dan apa yang tidak bisa dilakukannya.

---

## Markdown: Memori Saat Ini Agen AI

Per 2026, format yang paling banyak digunakan oleh agen AI adalah Markdown.

Claude Code mengingat dalam file `.md`. Agen berbasis GPT juga meninggalkan catatan dalam Markdown. CLAUDE.md, memory.md, notes.md. Memori jangka panjang AI berdiri di atas Markdown saat ini.

Mengapa Markdown? Alasannya sederhana. LLM membaca dan menulis Markdown dengan baik. Markdown melimpah dalam data pelatihan, dan strukturnya cukup sederhana untuk generasi dan parsing yang mudah.

Tetapi Markdown adalah **format dokumen yang dimaksudkan untuk dibaca manusia.**

```markdown
# Status Proyek
## Strategi Cache
- Bitmask SIMD diadopsi (diputuskan 1/28)
- Akselerasi GPU sedang ditinjau
## Belum Terselesaikan
- Metode pembuatan kueri TBD
```

Bagaimana mesin menginterpretasikan ini?

Ada heading bagian bernama "Strategi Cache." Di bawahnya, ada item "Bitmask SIMD diadopsi." Ada tanggal "(1/28)" dalam tanda kurung.

Mesin tidak bisa memahami ini secara struktural. Ia bisa tahu dari `##` bahwa "Strategi Cache" adalah heading bagian, tetapi hubungan semantik bahwa itu "subtopik arsitektur" tidak ada di Markdown. Manusia tahu "1/28" adalah tanggal, tetapi mesin harus menebak. 28 Januari, atau satu per dua puluh delapan?

Pada akhirnya, untuk "memahami" Markdown, LLM harus melakukan interpretasi bahasa alami. Markdown adalah bahasa alami dengan indentasi ditambahkan -- bukan data terstruktur.

---

## JSON: Struktur Tanpa Makna

JSON melangkah satu langkah lebih jauh dari Markdown.

```json
{
  "entity": "Yi Sun-sin",
  "birth": "1545",
  "death": "1598",
  "occupation": "naval_commander"
}
```

Ada struktur. Pasangan key-value eksplisit. Mesin bisa mem-parse-nya. Field bisa diakses.

Tetapi ada masalah.

**JSON tidak tahu apa arti key "entity".**

Orang yang membuat JSON ini tahu "entity" berarti "objek." Di JSON orang lain, konsep yang sama bisa "name," "subject," atau "item."

```json
{"name": "Yi Sun-sin"}
{"subject": "Yi Sun-sin"}
{"item": "Yi Sun-sin"}
{"entity": "Yi Sun-sin"}
```

Empat JSON mengekspresikan hal yang sama, tetapi mesin tidak bisa tahu bahwa mereka sama.

JSON tidak punya **semantik bersama.** Ada struktur, tetapi tidak ada kesepakatan tentang apa arti struktur itu.

Setiap proyek membuat skemanya sendiri. Setiap API menggunakan nama field-nya sendiri. Menghubungkan skema A ke skema B membutuhkan lapisan transformasi lain.

Ini adalah Menara Babel. Struktur ada, tetapi tidak ada yang memahami struktur satu sama lain.

---

## XML: Pajak Keverbosaan

XML mencoba menyelesaikan masalah JSON.

Namespace, definisi skema (XSD), definisi tipe dokumen (DTD). Ia menyediakan meta-struktur yang mendefinisikan makna struktur.

```xml
<entity xmlns="http://example.org/schema">
  <name>Yi Sun-sin</name>
  <birth>
    <year>1545</year>
    <calendar>lunar</calendar>
  </birth>
  <death>
    <year>1598</year>
    <cause>killed_in_action</cause>
  </death>
</entity>
```

Makna bisa didefinisikan. Struktur bisa dipaksakan dengan skema. Lebih ketat dari JSON.

Tetapi XML punya masalah fatal.

**Ia verbose.**

Dalam XML di atas, informasi aktualnya adalah "Yi Sun-sin, 1545, 1598, killed_in_action." Sisanya tag. Tag pembuka dan penutup melebihi jumlah informasi.

Mengapa ini masalah untuk AI?

Jendela konteks LLM terbatas. Jika menyampaikan informasi yang sama membutuhkan 3x token, jumlah informasi yang muat di konteks menyusut menjadi sepertiga.

XML verbose agar manusia bisa membacanya dengan mudah. Bahasa penalaran AI tidak boleh punya pemborosan ini. Bagi LLM, tag `<name>` adalah pemborosan.

Dan XML adalah desain dari akhir 1990-an.
Ia dibuat di zaman ketika LLM belum ada, untuk manusia dan perangkat lunak tradisional.
Ia tidak pernah dirancang sebagai bahasa penalaran AI.

---

## Keterbatasan Bersama

Markdown, JSON, XML.
Ketiga format punya kekuatan masing-masing, tetapi berbagi keterbatasan yang sama.

**Berbasis teks.**
Semuanya diserialisasi menjadi string.
Mesin harus mem-parse-nya untuk memprosesnya.
Parsing adalah biaya.

GEUL adalah deretan word 16-bit.
Word pertama setiap rekaman memberi tahu jenis dan panjangnya,
sehingga batas rekaman langsung diketahui tanpa menafsirkan string.

**Dirancang sebelum era LLM.**
Markdown dari 2004. JSON dari 2001. XML dari 1998.
Mereka dirancang di zaman ketika konsep LLM belum ada,
untuk manusia atau perangkat lunak tradisional.

Bahasa penalaran AI harus dirancang di era LLM, untuk LLM.
Menyesuaikan word 16-bit dengan ukuran kosakata LLM
mengandaikan keberadaan LLM.

**Sistem makna yang seragam tidak ada atau tidak lengkap.**
Markdown sama sekali tidak punya sistem makna.
JSON punya struktur tetapi tidak punya makna.
XML bisa mendefinisikan skema, tetapi tidak seragam.

GEUL menunjuk target dengan ID, bukan nama:
Reference seperti QID Wikidata atau ID dokumen yang diterbitkan Issuer.
Di mana pun dipakai, ID yang sama adalah target yang sama. Tidak perlu konversi.

---

## Ringkasan

| Format | Struktur | Makna | Ramah LLM | Biner | Tempat sumber | Kualifikasi |
|--------|-----------|---------|---------------|--------|---------------|----------------|
| Markdown | Lemah | Tidak ada | Tinggi | Tidak | Tidak ada | Tidak ada |
| JSON | Ada | Tidak ada | Sedang | Tidak | Tidak ada | Tidak ada |
| XML | Ada | Sebagian | Rendah | Tidak | Tidak ada | Tidak ada |
| **Bahasa Penalaran Ideal** | **Ada** | **Ada** | **Tinggi** | **Ya** | **Ada** | **Ada** |

Format baru diperlukan bukan karena format yang ada buruk. Tetapi karena format yang ada dibuat di era berbeda, untuk tujuan berbeda.

Markdown dibuat untuk dokumen yang dibaca manusia. JSON dibuat untuk pertukaran data di web API. XML dibuat untuk serialisasi dokumen dan data tujuan umum.

Format untuk mencatat dan mengakumulasi penalaran AI. Itu belum ada.

Ketika tujuan berbeda, alat harus berbeda.
