---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE adalah Edge pernyataan identitas tak berarah yang menyatakan bahwa dua Reference menunjuk referent yang sama."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SAME-NODE` (BIND dokumen spesifikasi `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A10/` (target DECLARE `0A10`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 1 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Identitas: dua Reference menunjuk objek yang sama |
| Sisi Hugo | `edge/same-node.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | record apa saja (kecuali penanda slot) |  |

SAME-NODE adalah Edge pernyataan identitas tak berarah yang menyatakan bahwa dua Reference menunjuk referent yang sama. Codec `0x0A1L`.

Ini tidak berarti encoding byte, Codec, atau ID kedua record Reference sama. Berbeda dengan [REFERENCE-NODE](0x0A0L-reference-node.md) yang merupakan binding berarah `Reference → record`, SAME-NODE menyatakan identitas (referential identity) antara dua Reference.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference
```

## Interpretasi dan validitas {#해석과-유효성}

- Subject dan Object diserialisasi dalam urutan ini, dan masing-masing harus tepat satu record [Reference](../reference/_index.md) yang lengkap. Batasnya ditemukan dengan Length tiap record.
- Jika Subject atau Object adalah Value, Edge, atau record yang tidak lengkap, maka invalid.
- Relasi SAME-NODE bersifat refleksif, simetris, dan transitif. Urutan Subject/Object pada wire hanya untuk framing dan tidak menciptakan arah makna. Implementasi harus dapat menelusuri relasi ini ke kedua arah.
- [LOCAL](../reference/0x005L-local.md) ID yang berbeda hanyalah Reference yang berbeda, bukan bukti bahwa referent-nya sama atau berbeda. Bahwa dua Reference menunjuk referent yang sama dinyatakan dengan SAME-NODE.
- Interpretasi dan inferensi harus mempertahankan asal-usul, waktu, world, dan policy scope dari dokumen yang memuat Edge itu dan dari graf penilaian. SAME-NODE tidak dipakai sebagai dasar penggabungan global yang tidak bergantung pada konteks.
- Meskipun ada SAME-NODE, record Reference asli maupun silsilahnya tidak dihapus atau ditimpa.
- Jika SAME-NODE dan [DIFFERENT-NODE](0x0A2L-different-node.md) ada bersama pada pasangan yang sama, wire tidak otomatis invalid. Konteks setiap klaim dipertahankan dan keduanya dievaluasi sebagai konflik.
- Variable Reference dihubungkan dengan Identified Reference lewat SAME-NODE untuk menyelesaikan variabel ([Reference](../reference/_index.md) Variable).

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Contoh (non-normatif) {#예시-비규범}

Edge Id `0009`, Subject adalah LOCAL 1, Object adalah LOCAL 2.

- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG-nya `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A10/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
