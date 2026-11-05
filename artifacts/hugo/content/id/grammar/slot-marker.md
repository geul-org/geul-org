---
title: "Penanda slot"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Penanda slot (slot marker) adalah record 1 WORD yang mengisi posisi field record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Penanda slot (slot marker) adalah record 1 WORD yang mengisi posisi field record. Tidak menunjuk apa pun. Kode yang ditetapkan pada tiga slot pertama bagian 0 Reference, `0x000L~0x002L`. Setiap penanda memiliki halaman: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

Ada tiga hal yang dapat berada di posisi nilai. Nilai tidak ditulis, nilai ada tetapi tidak diketahui apa, nilai tidak ada. Ketiganya berbeda. Penanda slot menuliskan ketiganya dengan tiga WORD yang bersebelahan.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, bagian 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | Nama | Arti | Notasi |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | Tidak ditulis | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Tidak diketahui: nilai ada. Tidak diketahui apa | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | Tidak ada: nilai tidak ada | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | Bentuk TAG ini (penanda yang memiliki Payload) tidak ditetapkan | |

- Penanda **tidak memiliki Quantifier.** Kuantifikasi hanya dibaca dari sistem 5Q (`5 <= C < 30` pada bagian 0, `C < 30` pada bagian 1). `0x0010` UNKNOWN-VALUE tidak dibaca dengan `C % 5` dan ditafsirkan sebagai Generic ([Reference](reference/_index.md) Quantifier).
- Tidak ada Payload. ID objek juga tidak ada.
- Decoder tanpa codebook pun mengetahui dari TAG WORD saja bahwa itu Kind Reference, 1 WORD, lalu melewatinya. “Jika nilai WORD adalah `0x0000`, `0x0010`, `0x0020` maka penanda slot” diketahui dengan `w & 0xF == 0 && w <= 0x0020`.
- Notasi `ABSENT`·`UNKNOWN`·`NONE` adalah notasi teks `geul show`·`geul add`.

## Tiga pembedaan {#세-가지-구분}

| | Tidak ditulis (ABSENT) | Tidak diketahui (UNKNOWN-VALUE) | Tidak ada (NO-VALUE) |
|---|---|---|---|
| Pernyataan tentang apa | **Dokumen**: posisi ini tidak diisi | **Dunia**: nilai ada. Tidak diketahui apa | **Dunia**: nilai tidak ada |
| Logika | Tidak menyatakan apa pun | `∃x. P(s, x)`, x tidak teridentifikasi | `¬∃x. P(s, x)` |
| Asumsi dunia | Dunia terbuka (tanpa informasi) | Keberadaan tertutup, identitas terbuka | Dunia tertutup untuk (s, P, kondisi pembatas) |
| Wikidata | Snak yang bersangkutan tidak ada | `somevalue` | `novalue` |
| Dipakai di mana | Field opsional dengan target CODEC `0000` (SOURCE Origin dan sebagainya) | Field dengan target CODEC `0010` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Field dengan target CODEC `0020` (TRIPLE Object, QUALIFIER Value) |
| “Berapa anak (P40)” | Tidak tahu | Satu atau lebih | 0 |
| “Apakah ada waktu berakhir (P582)” | Tidak tahu → tidak diketahui apakah masih berlaku | Sudah berakhir. Tidak diketahui kapan | Belum berakhir (pernyataan) |

Pembedaan yang sama berlaku pada tingkat proposisi. **TRIPLE tidak ada di dokumen** berarti tidak ditulis. Karena dokumen GEUL adalah dunia terbuka, tidak adanya pernyataan tidak berarti fakta tidak ada. “Tidak ada” hanya dapat dikatakan dengan **menulis** NO-VALUE.

## Aturan penerimaan {#수용-규칙}

- Penanda slot hanya valid jika **WORD yang sama ada sebagai target yang tepat** dalam daftar [CODEC](edge/0x0BEL-codec.md) field itu. Target `0000` berarti “field opsional”, `0010` berarti “menerima tidak diketahui”, `0020` berarti “menerima tidak ada”.
- Wildcard (`000F`, `060F` dan sebagainya, `L=1111`) tidak menerima penanda. Reference apa saja (`000F`·`020F`·`040F`) juga tidak tumpang tindih dengan penanda.
- Field record tanpa CODEC (“record apa saja”) juga tidak menerima penanda.
- Penanda di posisi record HEAD·BODY dan posisi Edge Id adalah invalid.
- Penanda tidak dapat dipakai pada field nilai mentah. Nilai mentah tidak memiliki TAG sehingga tidak ada tempat untuk penanda 1 WORD.
- Daftar CODEC yang hanya berisi target penanda (selalu penanda) adalah invalid.
- Arti penanda (apa yang ada dan apa yang tidak ada) ditetapkan oleh spesifikasi Edge yang menerima penanda itu. Sama dengan prinsip bahwa kuantifikasi dan negasi ditetapkan oleh Edge, bukan Reference.
- Arti dan aturan penerimaan penanda berada di [lapisan 0](publishing.md#층) (tertanam di decoder). Ketiganya tidak memiliki Payload sehingga biaya penanaman juga tidak ada. Meski begitu, dokumen codec tetap ditaruh per kode. Dokumen codec hanya meletakkan DECLARE dan tidak ada FIELD.

## Kewajiban pihak pembaca {#읽는-쪽의-의무}

Ditulis pada halaman masing-masing penanda. Intinya sebagai berikut.

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) bukan nilai melainkan pernyataan keberadaan. Tidak sama maupun berbeda dengan nilai apa pun, dan TRIPLE-nya tidak digabungkan sebagai duplikat.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) tertutup di dalam kondisi pembatas proposisi itu.
- Pada kedua penanda, rank berlaku sama, dan jika dipakai sebagai nilai QUALIFIER, mengubah arti pembatasan itu.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) tidak menyatakan apa pun tentang dunia. Nilai yang tidak dapat dipindahkan tidak ditulis sebagai UNKNOWN-VALUE.

## Perbedaan dengan “tidak ada” lainnya {#다른-없음과의-차이}

- Aturan Codec yang memakai [LOCAL](reference/0x005L-local.md) `0` sebagai “tidak ada” ([TOULMIN](toulmin/_index.md) REF dan sebagainya) adalah perjanjian di dalam Codec itu. Berbeda dengan penanda slot.
- LOCAL Identified tidak dipakai sebagai null·sentinel. Untuk menulis tidak diketahui·tidak ada, pakai penanda pada field yang menerima penanda slot.

## Contoh {#예시}

Perbatasan Q30 (Amerika Serikat)–Q34266 (Kekaisaran Rusia), waktu berakhirnya tidak diketahui. Edge Id hanya untuk penjelasan.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Bank sentral Q30, tidak ada pada tahun 1811~1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- Posisi penanda adalah 1 WORD. TRIPLE menjadi 9 WORD (`0AA8`), QUALIFIER menjadi 8 WORD (`0AB7`).
- Dalam bentuk sederhana, “tidak punya anak (P40)” adalah `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Halaman terkait {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [dokumen spesifikasi Codec](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
