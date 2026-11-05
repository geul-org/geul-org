---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE adalah Edge pernyataan yang memuat satu proposisi (Predicate, Subject, Object) dan tingkatannya (rank)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `TRIPLE` (BIND dokumen spesifikasi `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000AA0/` (target DECLARE `0AA0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 10 |
| Kind | Edge · keluarga: pernyataan, kelompok: proposisi |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Proposisi dengan urutan Predicate, Subject, Object dan rank. Object adalah nilai atau penanda UNKNOWN-VALUE·NO-VALUE. Maknanya adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya |
| Sisi Hugo | `edge/triple.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference) |  |
| 2 | `subject` | #3 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference) |  |
| 3 | `object` | #4 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `060F` seluruh bagian 3 (wildcard, Value), `080F` seluruh bagian 4 (wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | nilai mentah 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE adalah Edge pernyataan yang memuat satu proposisi (Predicate, Subject, Object) dan tingkatannya (rank). Codec `0x0AAL`.

Syarat yang membatasi proposisi (waktu mulai·berakhir, cakupan penerapan, dan lain-lain) ditempelkan dengan [QUALIFIER](0x0ABL-qualifier.md) yang menunjuk Edge Id TRIPLE. Asal-usul (references Wikidata) ditempelkan dengan Edge dasar [SOURCE](0x0C0L-source.md) yang menunjuk Edge Id TRIPLE.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Predicate         record Reference (WIKIDATA-PID, dan lain-lain)
Subject           record Reference
Object            record Reference atau Value, atau penanda slot 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Kode | Nama | Arti |
|---|---|---|
| `0` | normal | default |
| `1` | preferred | nilai saat ini, nilai paling otoritatif |
| `2` | deprecated | nilai yang dinilai salah atau usang tetapi tetap dicatat |

- Sama dengan statement rank Wikidata. Nilai representatif (truthy Wikidata) dari Subject·Predicate yang sama adalah preferred jika ada, dan normal jika tidak ada.
- Sumber yang tidak memberi rank memakai `0` (normal).
- Kode lain adalah invalid.

## Interpretasi dan validitas {#해석과-유효성}

- Predicate dan Subject adalah tepat satu record Reference yang lengkap.
- Object adalah tepat satu record Reference atau Value yang lengkap, atau 1 WORD [penanda slot](../slot-marker.md) `0x0010` (UNKNOWN-VALUE)·`0x0020` (NO-VALUE). ABSENT (`0x0000`) tidak diterima. Object bukan bidang opsional.
- Setelah membaca Object, harus tersisa tepat 1 WORD (Rank).
- Dokumen spesifikasi geul.org menaruh [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) dan [ENUM](0x0BDL-enum.md) 0·1·2 pada bidang nilai mentah Rank. Pada bidang Object ditaruh CODEC `000F`·`020F`·`040F` (Reference apa saja), `060F`·`080F` (Value apa saja), `0010` (UNKNOWN-VALUE), `0020` (NO-VALUE). Pada bidang Predicate·Subject ditaruh CODEC `000F`·`020F`·`040F` (Reference apa saja). Karena wildcard, penanda slot tidak diterima.
- **Makna TRIPLE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya dalam dokumen yang sama.** Pembaca mengumpulkan QUALIFIER sebelum menafsirkan TRIPLE. TRIPLE yang dibaca tanpa QUALIFIER dapat berupa proposisi yang kehilangan pembatasnya (contoh: "kepala pemerintahan" tanpa pembatas waktu).

## Tidak diketahui dan tidak ada {#알-수-없음과-없음}

Penanda slot pada posisi Object bukan nilai, melainkan penegasan tentang proposisi.

| Object | Arti | Logika |
|---|---|---|
| nilai v | salah satu nilai Predicate dari Subject adalah v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | ada nilai. Tidak diketahui apa (`somevalue` Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | tidak ada nilai (`novalue` Wikidata) | `¬∃x. P(s, x)` |
| tanpa TRIPLE | tidak menegaskan apa pun (dunia terbuka) | |

- **Dibaca di dalam syarat pembatas.** Cakupan `∃`·`¬∃` ditentukan oleh QUALIFIER yang menunjuk TRIPLE itu. Jika QUALIFIER ditempelkan, ia hanya tertutup dalam cakupan itu. "Pada 1811~1816 tidak ada bank sentral" ditulis dengan menempelkan QUALIFIER P580·P582 pada TRIPLE NO-VALUE. Ini tidak bertentangan dengan TRIPLE nilai pada periode lain untuk Predicate yang sama.
- **rank berlaku sama.** Saat memilih nilai representatif (truthy), TRIPLE UNKNOWN-VALUE·NO-VALUE juga menjadi kandidat. Jika ada preferred, hanya preferred yang tersisa.
- **Antar UNKNOWN-VALUE tidak sama.** UNKNOWN-VALUE tidak sama maupun berbeda dengan nilai apa pun (hasil perbandingan tak tentu), dan dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. Setiap kemunculan adalah kuantifikasi eksistensial yang independen. Karena itu dua TRIPLE UNKNOWN-VALUE dengan byte yang sama bukan duplikat dan tidak digabungkan (anak bisa dua, bisa satu).
- Jika pada Subject·Predicate·rank yang sama TRIPLE NO-VALUE dan TRIPLE nilai (atau UNKNOWN-VALUE) hadir bersama tanpa syarat pembatas yang membedakan, itu kontradiksi. Pemeriksa memberi peringatan. Tidak menolak (keadaan ini ada juga di Wikidata).
- Nilai yang tidak dapat dialihkan (sumber punya nilainya) tidak ditulis sebagai UNKNOWN-VALUE.

## Contoh (non-normatif) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG-nya `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (Amerika Serikat) P1304 (bank sentral) NO-VALUE, normal. Pada 1811~1816 tidak ada bank sentral (QUALIFIER P580·P582 ada pada contoh [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. TAG-nya `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "Tidak punya anak (P40)" adalah `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Masalah terbuka {#열린-문제}

- scope (konteks klaim: dunia, sudut pandang): ditentukan ketika kebutuhan pemakaiannya muncul.
- Bentuk singkat yang melipat TRIPLE dan QUALIFIER dalam satu record: setelah deklarasi bidang berulang ada ([DECLARE](0x0BBL-declare.md) masalah terbuka).

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [penanda slot](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000AA0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
