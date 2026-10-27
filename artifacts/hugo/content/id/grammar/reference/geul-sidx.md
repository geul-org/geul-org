---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX adalah Reference deklarasi yang menunjuk target dengan GEUL SIDX (Semantic-aligned Index), yang bitnya sendiri memuat makna."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX adalah Reference deklarasi yang menunjuk target dengan GEUL SIDX (Semantic-aligned Index). SIDX adalah pengenal yang bitnya sendiri memuat makna (jenis, atribut).

## Layout

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length extension TAG]
SIDX              seluruh sisanya
```

- Quantifier sama seperti Codec deklarasi lain. Jika Variable, itu adalah variabel anonim dari jenis tersebut ([Reference](/id/grammar/reference/) Variable). Kuantifikasi hanya dengan `QQQ`. Kuantifikasi tidak dimasukkan ke dalam nilai SIDX.
- Dokumen spesifikasi mendeklarasikan SIDX sebagai satu field nilai mentah selebar sisa. Akan diubah setelah aturan lebar ditetapkan.

## Contoh

| SIDX | WORD sequence |
|---|---|
| (non-normatif) 64 bit `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Kebijakan alokasi

- Perannya berbeda dari [GEUL](/id/grammar/reference/geul/). GEUL adalah ID identitas yang pada umumnya dialokasikan berurutan (auto increment), sedangkan GEUL-SIDX adalah alamat semantik yang memberi nilai berdekatan pada target yang maknanya berdekatan.
- Tingkat kedekatan ditentukan secara statistik dari data pemakaian yang terkumpul. Sebelum statistik terkumpul, pakai GEUL ID; setelah SIDX dialokasikan, hubungkan GEUL dan GEUL-SIDX dari target yang sama dengan [SAME-NODE](/id/grammar/edge/same-node/).

## Masalah terbuka

- **Lebar.** Ditentukan setelah melihat statistik. Sedang dipertimbangkan 4 WORD (64 bit), 16 WORD, dan lain-lain. Makna SIDX ada pada bit atas, sehingga aturan "lebar terpendek" Codec deklarasi lain (larangan `0x0000` di depan) tidak dapat dipakai begitu saja. Karena itu kemungkinan akan menjadi lebar tetap (atau lebar tetap per sub-format). Sampai ditetapkan, dokumen spesifikasi mendeklarasikan SIDX sebagai nilai mentah selebar sisa.
- **Stabilitas alokasi.** Pada Reference, jika nilai bilangan bulatnya sama, targetnya sama, dan ID yang sudah dialokasikan tidak dipakai ulang. Agar SIDX yang sudah dialokasikan tidak berpindah walaupun statistik berubah, diperlukan alokasi append-only (alokasi jarang yang menyisakan ruang di dekat makna yang berdekatan). Jika perpindahan sering terjadi, tentukan apakah SIDX didefinisikan bukan sebagai pengenal permanen, melainkan indeks yang terikat pada edisi registri.
- **Keunikan.** Jika SIDX dihasilkan dari makna bit sehingga dapat bertabrakan, hal itu tidak sesuai dengan prasyarat "nilai bilangan bulat sama berarti target sama". Tabrakan diselesaikan saat alokasi untuk menjamin keunikan.
- Format publik codebook dan registri.

## Halaman terkait

- [Reference](/id/grammar/reference/), [GEUL](/id/grammar/reference/geul/)
