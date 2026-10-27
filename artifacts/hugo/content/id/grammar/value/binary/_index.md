---
title: "Value — Biner"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "Format keluarga BINARY (Codec `0x60`~`0x7B`, nomor format `0xC000`~`0xFFFF`): UUID, digest, CRC, alamat jaringan, deretan byte tak dikenal, vektor bit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Keluarga BINARY adalah format deretan byte. Ditaruh pada kode langsung `0x60`~`0x7B` dan nomor format Issuer `0xC000`~`0xFFFF`.

- UUID, SHA-256, dan SHA-1 adalah kode langsung. Digest lain, CRC32C, alamat IPv4·IPv6·MAC, deretan byte tak dikenal, dan vektor bit adalah format Issuer.
- Nilai berukuran tetap (UUID, digest, alamat) ukurannya sudah ditetapkan sehingga tidak memiliki pasangan genap·ganjil.
- Media publik seperti gambar·video ditaruh sebagai format BINARY Issuer IANA (`0x0021`). Nomor format dialokasikan sebagai pasangan genap·ganjil dan Payload-nya adalah deretan byte. Batas atas Length adalah 2^32−1 WORD. Untuk nilai besar, dianjurkan merujuk dengan URI dan SHA-256 daripada memasukkannya langsung.
- Karya yang ada di dalam deretan byte mengikuti lisensi aslinya. Sumber dan lisensi dicatat dengan Meta.
