---
title: "Penanda slot"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Penanda slot adalah kelompok record 1 WORD pada Codec Reference cadangan 0000. 0x0000 ABSENT (tidak ditulis), 0x0001 UNKNOWN-VALUE (tidak diketahui), dan 0x0002 NO-VALUE (tidak ada) mengisi posisi field record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Penanda slot (slot marker) adalah record 1 WORD yang mengisi posisi field record. Ia tidak menunjuk apa pun. Ia ditaruh pada Codec Reference cadangan `0000`.

Ada tiga hal yang dapat berada di posisi nilai: nilai tidak ditulis, nilai ada tetapi tidak diketahui, dan nilai tidak ada. Ketiganya berbeda. Penanda slot membedakan ketiganya dengan tiga WORD yang bersebelahan.

## Layout

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = nomor penanda
```

| WORD | Nama | Arti | Notasi |
|---|---|---|---|
| `0x0000` | ABSENT | Tidak ditulis | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | Tidak diketahui: nilai ada. Tidak diketahui apa | `UNKNOWN` |
| `0x0002` | NO-VALUE | Tidak ada: tidak ada nilai | `NONE` |
| `0x0003`~`0x0007` | Cadangan | | |
| CCCC `0000`, LLLL ≥ `0001` | Cadangan | Penanda yang memiliki Payload ditetapkan kemudian | |

- 3 bit bawah `MMM` adalah **nomor penanda, bukan Quantifier**. Posisinya hanya bernama sama dengan `QQQ` pada Codec Reference lain dan maknanya tidak berkaitan ([Reference](/id/grammar/reference/) pengecualian Quantifier).
- Tidak ada Payload. Tidak ada ID target.
- Decoder tanpa codebook pun mengetahui dari TAG WORD saja bahwa ini Reference Kind dan 1 WORD, lalu melompatinya. "Jika nilai WORD `0`~`7`, itu penanda slot" diketahui dengan satu pemeriksaan bit (`w & 0xFFF8 == 0`).
- Notasi `ABSENT`·`UNKNOWN`·`NONE` adalah notasi teks `geul show`·`geul add`.

## Tiga pembedaan

| | Tidak ditulis (ABSENT) | Tidak diketahui (UNKNOWN-VALUE) | Tidak ada (NO-VALUE) |
|---|---|---|---|
| Tentang apa | **Dokumen**: slot ini tidak diisi | **Dunia**: nilai ada. Tidak diketahui apa | **Dunia**: nilai tidak ada |
| Logika | Tidak menegaskan apa pun | `∃x. P(s, x)`, x tidak teridentifikasi | `¬∃x. P(s, x)` |
| Asumsi dunia | Dunia terbuka (tanpa informasi) | Keberadaan tertutup, identitas terbuka | Dunia tertutup untuk (s, P, syarat pembatas) |
| Wikidata | Snak terkait tidak ada | `somevalue` | `novalue` |
| Dipakai di mana | Field opsional yang menaruh target CODEC `0000` (SOURCE Origin, dan lain-lain) | Field yang menaruh target CODEC `0001` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Field yang menaruh target CODEC `0002` (TRIPLE Object, QUALIFIER Value) |
| "Berapa anak (P40)" | Tidak tahu | 1 atau lebih | 0 |
| "Apakah ada waktu berakhir (P582)" | Tidak tahu → tidak diketahui apakah masih berlaku | Sudah berakhir. Kapan, tidak diketahui | Belum berakhir (ditegaskan) |

Pembedaan yang sama berlaku pada tingkat proposisi. **TRIPLE tidak ada di dokumen** adalah tidak ditulis. Dokumen GEUL adalah dunia terbuka, sehingga tidak adanya pernyataan tidak berarti faktanya tidak ada. "Tidak ada" hanya dapat dikatakan jika **ditulis** sebagai NO-VALUE.

## Aturan penerimaan

- Penanda slot valid hanya jika daftar [CODEC](/id/grammar/edge/codec/) field itu **memuat WORD yang sama sebagai target yang persis**. Target `0000` berarti "field opsional", `0001` berarti "menerima tidak diketahui", `0002` berarti "menerima tidak ada".
- Wildcard (`0780`, `0781`, `0F80`, dan lain-lain) tidak menerima penanda. Wildcard Reference juga tidak tumpang tindih dengan Codec `0000`.
- Field record tanpa CODEC ("record apa saja") juga tidak menerima penanda.
- Penanda pada posisi record HEAD·BODY dan posisi Edge Id adalah invalid.
- Penanda tidak dapat dipakai pada field nilai mentah. Nilai mentah tidak memiliki TAG sehingga tidak ada tempat untuk penanda 1 WORD.
- Daftar CODEC yang hanya berisi target penanda (selalu penanda) adalah invalid.
- Arti penanda (apa yang ada dan apa yang tidak ada) ditetapkan oleh spesifikasi Edge yang menerima penanda itu. Ini sejalan dengan prinsip bahwa kuantifikasi dan negasi ditentukan oleh Edge, bukan Reference.
- Penanda slot tidak memiliki dokumen spesifikasi Codec. Ia berada pada [lapisan 0](/id/grammar/publishing/#lapisan) (tertanam di decoder). Target Reference pada DECLARE menaruh posisi Quantifier sebagai 0, sehingga dokumen spesifikasi untuk `0x0001`·`0x0002` tidak dapat dibuat, dan karena ketiganya tidak memiliki Payload, tidak ada biaya penanaman.

## Kewajiban pihak pembaca

1. **UNKNOWN-VALUE bukan nilai, melainkan penegasan keberadaan.** Ia tidak sama dengan nilai apa pun dan tidak pula berbeda (hasil perbandingan belum ditentukan). Dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. Setiap kemunculan adalah kuantifikasi eksistensial yang independen (seperti blank node Wikidata).
   - Karena itu dua TRIPLE yang byte-nya sama (`P40 Q… UNKNOWN` ×2) bukan duplikat. Anaknya bisa dua, bisa satu. TRIPLE yang memuat UNKNOWN-VALUE tidak digabung sebagai duplikat.
   - Jika identitasnya kemudian terungkap, terbitkan versi baru yang memperbaiki TRIPLE itu. UNKNOWN-VALUE tidak dapat ditunjuk. Jika koreferensi diperlukan, pakai LOCAL Variable ([Reference](/id/grammar/reference/) Variable).
2. **NO-VALUE tertutup dalam syarat pembatas proposisinya.** Jika ada QUALIFIER, ia hanya tertutup pada cakupan itu. Q30 P1304 NO-VALUE (P580 1811, P582 1816) berarti hanya pada 1811~1816 tidak ada bank sentral, dan tidak bertentangan dengan TRIPLE nilai pada properti yang sama (Federal Reserve, preferred).
   - Jika NO-VALUE dan TRIPLE nilai ada bersama pada Subject·Predicate yang sama dengan rank yang sama tanpa syarat pembatas yang membedakan, itu kontradiksi. Pemeriksa mengeluarkan peringatan. Tidak menolak. Keadaan ini ada juga di Wikidata, dan pihak pembaca memilih dengan rank.
3. **rank berlaku sama.** Saat memilih nilai representatif (truthy), TRIPLE UNKNOWN-VALUE·NO-VALUE juga menjadi kandidat. Jika ada preferred, hanya preferred yang tersisa.
4. **Jika dipakai sebagai nilai QUALIFIER, ia mengubah makna pembatas itu.** `P582 = UNKNOWN` berarti sudah berakhir dan waktunya tidak diketahui. Tidak dibaca sebagai proposisi yang masih berlaku. `P582 = NONE` menegaskan belum berakhir. Jika QUALIFIER P582 sama sekali tidak ada, tidak diketahui apakah sudah berakhir.
5. **ABSENT tidak mengatakan apa pun tentang dunia.** Ia tidak dibaca sebagai UNKNOWN-VALUE atau NO-VALUE. Sebaliknya, konverter dilarang menulis nilai yang tidak dapat dipindahkannya (nilai yang ada di sumber) sebagai UNKNOWN-VALUE, karena di sumber nilainya diketahui. Posisi yang tidak disebutkan sumber (misalnya Origin [SOURCE](/id/grammar/edge/source/) dari sumber yang tidak menguraikan asalnya) juga ditulis konverter sebagai ABSENT. UNKNOWN-VALUE adalah penegasan "ada", sehingga hanya ditulis jika sumber mengatakannya.

## Perbedaan dengan "tidak ada" lain

- Aturan Codec yang memakai [LOCAL](/id/grammar/reference/local/) `0` sebagai "tidak ada" ([TOULMIN](/id/grammar/edge/toulmin/) REF, dan lain-lain) adalah ketentuan di dalam Codec itu. Berbeda dari penanda slot.
- LOCAL Identified tidak dipakai sebagai null·sentinel. Untuk menulis tidak diketahui·tidak ada, tulis penanda pada field yang menerima penanda slot.

## Contoh

Perbatasan Q30 (Amerika Serikat) dengan Q34266 (Kekaisaran Rusia), waktu berakhir tidak diketahui. Edge Id hanya untuk penjelasan.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Bank sentral Q30, tidak ada pada 1811~1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- Slot penanda berukuran 1 WORD. TRIPLE menjadi 9 WORD (`140A`), QUALIFIER 8 WORD (`138B`).
- Dalam bentuk sederhana, "tidak punya anak (P40)" adalah `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Halaman terkait

- [Reference](/id/grammar/reference/), [CODEC](/id/grammar/edge/codec/), [Dokumen spesifikasi Codec](/id/grammar/codec-spec/)
- [TRIPLE](/id/grammar/edge/triple/), [QUALIFIER](/id/grammar/edge/qualifier/), [TOULMIN](/id/grammar/edge/toulmin/)
