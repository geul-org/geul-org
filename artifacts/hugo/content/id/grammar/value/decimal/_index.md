---
title: "Value — Desimal"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Format desimal eksak keluarga DECIMAL (Codec `0x10`~`0x1F`, nomor format `0x2000`~`0x3FFF`): SIGNED·UNSIGNED-DECIMAL dan IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Keluarga DECIMAL adalah format desimal eksak. Ditaruh pada kode langsung `0x10`~`0x1F` (3 bit atas Codec `001`) dan nomor format Issuer `0x2000`~`0x3FFF`.

- SIGNED-DECIMAL·UNSIGNED-DECIMAL kode langsung ditulis sebagai `C × 10^E` dan memuat jumlah digit notasi asli apa adanya. `1.20` (`C=120, E=−2`) dan `1.2` (`C=12, E=−1`) adalah record yang berbeda. Kesetaraan nilai dan pelestarian quantum adalah masalah terbuka pada [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/#masalah-terbuka).
- Encoding DPD·BID IEEE 754 decimal32/64/128 adalah format Issuer IEEE (`0x0040`).
