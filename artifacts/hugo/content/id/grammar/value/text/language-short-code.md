---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE adalah Value kode bahasa GEUL yang mengompresi hanya primary language subtag menjadi 1 WORD (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE adalah kode bahasa terkompresi GEUL yang hanya memuat primary language subtag, bukan tag BCP 47 lengkap. Payload tepat 1 WORD.

## Layout

- Kode: kode langsung Value `0x48`. Keluarga TEXT.
- Payload adalah kode unsigned 16 bit tepat 1 WORD.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  total 2 WORD
Payload WORD 1st (16 bit)           GEUL language code (uint16)
```

## Interpretasi dan validitas

- 1 WORD Payload dibaca sebagai bilangan bulat unsigned 16 bit.
- Nilai ini adalah kode terkompresi primary language subtag. Script, region, variant, extension, dan private-use tidak dimuat. Jika informasi itu diperlukan, pakai [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`).
- `0x0000..0xfffe` adalah rentang alokasi GEUL Language Registry. Bahkan di dalam rentang ini, nilai yang sebenarnya belum dialokasikan pada versi registri tersebut adalah invalid.
- Objek alokasi awal adalah catatan publik `Type: language` pada snapshot IANA Language Subtag Registry tertentu, kecuali yang `Scope: private-use`. collections, macrolanguage, dan special tidak dikecualikan.
- Alokasi awal mengurutkan catatan publik itu menurut subtag ASCII lalu memberi ID. Urutan fisik file IANA bukan aturan ID.
- Subtag `Type: language` baru berikutnya ditambahkan di akhir tanpa mengubah nomor yang ada (append-only).
- ID subtag language deprecated tidak dihapus atau dipakai ulang. Hubungan Preferred-Value dan status deprecated dipertahankan sebagai metadata registri.
- `0xffff` dicadangkan sebagai escape perluasan. Sampai format perluasan didefinisikan terpisah, ia invalid pada Value LANGUAGE-SHORT-CODE mandiri. Tidak dipakai dengan makna seperti `null`, `unknown`, `und`.
- Di masa depan, spesifikasi Codec lain dapat mendefinisikan aturan interpretasi setelah `0xffff`. Namun aturan itu tidak berarti memperpanjang Payload format ini atau mengizinkan Payload yang mengikuti.
- Spesifikasi Codec dapat menaruh kode 1 WORD yang sama di field nilai mentah tanpa TAG ([CODEC](/id/grammar/codec-spec/#codec) pada field nilai mentah). Itu adalah aturan spesifikasi Codec tersebut, dan wire form Value mandiri selalu TAG 1 WORD + Payload 1 WORD.
- Untuk menilai makna nilai, versi GEUL Language Registry yang dipakai dan tanggal snapshot registri IANA yang dikunci versi itu harus dipertahankan bersamanya.

## Dasar standar

- Registri asal primary language subtag serta metadata deprecated/Preferred-Value mengikuti [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Makna dasar sistem language subtag BCP 47 mengikuti [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Pemberian ID append-only berurutan ASCII, pencadangan `0xffff`, dan pembedaan dari penyematan tanpa TAG di field nilai mentah adalah aturan GEUL.

## Panjang

- Total tepat 2 WORD, yaitu jumlah TAG 1 WORD dan Payload 1 WORD, dengan panjang langsung `LLLL=0001`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 1 WORD, ditolak.

## Contoh

- Karena snapshot registri dan tabel kode sebenarnya belum ditetapkan, contoh ID numerik bahasa tertentu tidak dicantumkan.

## Masalah terbuka

- Tanggal snapshot IANA awal, nama versi GEUL Language Registry, dan seluruh tabel pemetaan. Sampai ditetapkan, contoh numerik konkret atau tabel kode tidak ditetapkan.
