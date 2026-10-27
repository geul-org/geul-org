---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE adalah Edge pernyataan identitas tak berarah yang menyatakan bahwa dua Reference menunjuk target yang sama (Codec 0x01)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE adalah Edge pernyataan identitas tak berarah yang menyatakan bahwa dua Reference menunjuk referent yang sama. Codec `0x01`.

Ini tidak berarti encoding byte, Codec, atau ID kedua record Reference sama. Berbeda dengan [REFERENCE-NODE](/id/grammar/edge/reference-node/) yang merupakan pengikatan berarah `Reference → record`, SAME-NODE menyatakan identitas (referential identity) antara dua Reference.

## Layout

```
TAG WORD          0001 0LLL L000 0001
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference
```

## Interpretasi dan validitas

- Subject dan Object diserialisasi dalam urutan ini, dan masing-masing harus tepat satu record [Reference](/id/grammar/reference/) yang lengkap. Batasnya ditemukan dengan Length setiap record.
- Jika Subject atau Object adalah Value, Edge, atau record yang tidak lengkap, invalid.
- Relasi SAME-NODE bersifat refleksif·simetris·transitif. Urutan Subject/Object pada wire adalah untuk framing dan tidak membuat arah makna. Implementasi harus dapat menelusuri relasi ini dua arah.
- [LOCAL](/id/grammar/reference/local/) ID yang berbeda hanyalah Reference yang berbeda, bukan bukti bahwa referent-nya sama atau berbeda. Bahwa dua Reference menunjuk referent yang sama dinyatakan dengan SAME-NODE.
- Interpretasi dan inferensi harus mempertahankan sumber, waktu, world, dan policy scope dokumen yang memuat Edge itu dan graf putusan. SAME-NODE tidak dipakai sebagai dasar penggabungan global yang lepas dari konteks.
- Walaupun ada SAME-NODE, record Reference asli atau silsilahnya tidak dihapus atau ditimpa.
- Jika SAME-NODE dan [DIFFERENT-NODE](/id/grammar/edge/different-node/) ada bersama pada pasangan yang sama, wire tidak otomatis invalid. Konteks setiap klaim dipertahankan dan dievaluasi sebagai konflik.
- Variable Reference dihubungkan dengan Identified Reference melalui SAME-NODE untuk menyelesaikan variabel ([Reference](/id/grammar/reference/) Variable).

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Contoh (non-normatif)

Edge Id `0009`, Subject adalah LOCAL 1, Object adalah LOCAL 2.

- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG adalah `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [REFERENCE-NODE](/id/grammar/edge/reference-node/), [DIFFERENT-NODE](/id/grammar/edge/different-node/)
- [Reference](/id/grammar/reference/), [LOCAL](/id/grammar/reference/local/)
