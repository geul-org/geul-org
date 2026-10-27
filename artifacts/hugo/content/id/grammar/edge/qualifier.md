---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER adalah Edge pernyataan yang menempelkan satu syarat pembatas pada proposisi Edge lain (terutama TRIPLE) (Codec 0x0B). Pada Value, sebagai ganti nilai dapat dipakai tidak diketahui (UNKNOWN-VALUE) atau tidak ada (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER adalah Edge pernyataan yang menempelkan satu syarat pembatas pada proposisi yang dimuat Edge lain (terutama [TRIPLE](/id/grammar/edge/triple/)). Codec `0x0B`.

Sama dengan satu qualifier (snak) Wikidata: satu properti dan satu nilai.

## Layout

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           record LOCAL Reference
Property          record Reference (WIKIDATA-PID, dan lain-lain)
Target            record LOCAL Reference (Edge Id Edge yang dibatasi)
Value             record Reference atau Value, atau penanda slot 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
```

- Urutan komponen sama dengan TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Decoder membacanya dengan jalur yang sama. Peran ditetapkan oleh Codec.

## Interpretasi dan validitas

- Property dan Target adalah tepat satu record Reference yang lengkap, dan Target adalah LOCAL Reference. Dokumen spesifikasi geul.org menaruh [CODEC](/id/grammar/edge/codec/) LOCAL (`0008`) pada Target. Value adalah tepat satu record Reference atau Value yang lengkap, atau 1 WORD [penanda slot](/id/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE)·`0x0002` (NO-VALUE). Dokumen spesifikasi menaruh CODEC `0780`, `0F80`, `0001`, `0002` pada Value. ABSENT (`0x0000`) tidak diterima. Property·Target tidak menerima penanda slot. Kursor setelah membaca Value harus sesuai dengan akhir Edge.
- Target adalah Edge Id dalam dokumen yang sama. QUALIFIER ditaruh di dokumen yang sama dengan Edge yang dibatasi.
- Jika Target adalah [SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) di HEAD (sumber seluruh dokumen), QUALIFIER juga ditaruh di HEAD, setelah SOURCE itu. QUALIFIER lainnya ditaruh di BODY. Jika QUALIFIER yang Target-nya SOURCE HEAD ada di BODY, invalid.
- Target dapat berupa Edge selain TRIPLE. QUALIFIER yang menempel pada [SOURCE](/id/grammar/edge/source/) membatasi tindakan pengutipan (tanggal akses, posisi di dalam sumber, dan lain-lain). Makna SOURCE juga adalah gabungan semua QUALIFIER yang menunjuknya.
- **QUALIFIER adalah bagian dari proposisi.** Ia bukan klaim terpisah tentang proposisi, melainkan membatasi syarat agar proposisi benar. Makna TRIPLE target adalah gabungan semua QUALIFIER yang menunjuknya.
  - Asal proposisi ditulis dengan [SOURCE](/id/grammar/edge/source/). Atribut node sumber (judul, penulis, dan lain-lain) ditulis dengan TRIPLE yang Subject-nya sumber.
- Pada Target yang sama dapat ada beberapa QUALIFIER dengan Property yang sama. Urutan QUALIFIER dengan Target yang sama adalah urutan dalam dokumen (pengecualian yang memberi makna pada urutan Edge).

## Tidak diketahui dan tidak ada

Jika Value QUALIFIER adalah penanda slot, makna pembatas itu berubah. Contohnya waktu berakhir (P582).

| Yang menempel pada TRIPLE target | Arti | Apakah masih proposisi yang berlaku |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Berakhir pada 1974 | Tidak |
| `QUALIFIER P582 #n UNKNOWN` | Sudah berakhir. Kapan, tidak diketahui (`somevalue` Wikidata) | Tidak |
| `QUALIFIER P582 #n NONE` | Menegaskan belum berakhir (`novalue` Wikidata) | Ya |
| Tidak ada QUALIFIER P582 | Tidak diketahui apakah sudah berakhir (dunia terbuka) | Tidak diketahui |

- Jika `somevalue`·`novalue` pada qualifier Wikidata dibuang, proposisi menjadi lebih luas. TRIPLE perbatasan yang membuang somevalue waktu berakhir akan terbaca sebagai "perbatasan yang masih berlaku". Karena itu saat memindahkan, dipindahkan sebagai penanda.
- Sesama UNKNOWN-VALUE tidak dianggap nilai yang sama. Hasil perbandingan belum ditentukan.

## Contoh (non-normatif)

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value adalah [EDTF](/id/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Perbatasan (P47) Q30 (Amerika Serikat)–Q34266 (Kekaisaran Rusia), waktu berakhir tidak diketahui. Edge Id `2060`·`3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + penanda 1.

Menempelkan periode pada TRIPLE NO-VALUE `#3161` bank sentral Q30 (P1304). Hanya tidak ada pada 1811~1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [TRIPLE](/id/grammar/edge/triple/), [SOURCE](/id/grammar/edge/source/), [WIKIDATA-PID](/id/grammar/reference/wikidata-pid/), [EDTF](/id/grammar/value/time/edtf/), [Penanda slot](/id/grammar/reference/slot-marker/)
