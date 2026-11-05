---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER adalah Edge pernyataan yang menempelkan satu syarat yang membatasi proposisi yang dimuat Edge lain (terutama TRIPLE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `QUALIFIER` (BIND dokumen spesifikasi `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000AB0/` (target DECLARE `0AB0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 11 |
| Kind | Edge · keluarga: pernyataan, kelompok: proposisi |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Satu syarat yang membatasi proposisi Edge lain. Property, Target (Edge Id), Value (nilai atau penanda UNKNOWN-VALUE·NO-VALUE). Bagian dari proposisi |
| Sisi Hugo | `edge/qualifier.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `target` | #3 | record | `0050` LOCAL |  |
| 3 | `value` | #4 | record | `000F` seluruh bagian 0 (wildcard, Reference), `020F` seluruh bagian 1 (wildcard, Reference), `040F` seluruh bagian 2 (wildcard, Reference), `060F` seluruh bagian 3 (wildcard, Value), `080F` seluruh bagian 4 (wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER adalah Edge pernyataan yang menempelkan satu syarat yang membatasi proposisi yang dimuat Edge lain (terutama [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

Sama dengan satu qualifier (snak) Wikidata: satu properti dan satu nilai.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Property          record Reference (WIKIDATA-PID, dan lain-lain)
Target            record LOCAL Reference (Edge Id dari Edge yang dibatasi)
Value             record Reference atau Value, atau penanda slot 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- Urutan komponen sama dengan TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Decoder membacanya dengan jalur yang sama. Peran ditentukan oleh Codec.

## Interpretasi dan validitas {#해석과-유효성}

- Property dan Target adalah tepat satu record Reference yang lengkap, dan Target adalah LOCAL Reference. Dokumen spesifikasi geul.org menaruh [CODEC](0x0BEL-codec.md) LOCAL (`0050`) pada Target. Value adalah tepat satu record Reference atau Value yang lengkap, atau 1 WORD [penanda slot](../slot-marker.md) `0x0010` (UNKNOWN-VALUE)·`0x0020` (NO-VALUE). Dokumen spesifikasi menaruh CODEC `000F`, `020F`, `040F` (Reference apa saja), `060F`, `080F` (Value apa saja), `0010`, `0020` pada Value. ABSENT (`0x0000`) tidak diterima. Property·Target tidak menerima penanda slot. Kursor setelah membaca Value harus sama dengan akhir Edge.
- Target adalah Edge Id dalam dokumen yang sama. QUALIFIER ditaruh dalam dokumen yang sama dengan Edge yang dibatasinya.
- Jika Target adalah [SOURCE](0x0C0L-source.md#문서-전체의-출처) di HEAD (asal seluruh dokumen), QUALIFIER juga ditaruh di HEAD, setelah SOURCE itu. QUALIFIER lainnya ditaruh di BODY. Jika QUALIFIER dengan Target SOURCE HEAD berada di BODY, maka invalid.
- Target dapat berupa Edge selain TRIPLE. QUALIFIER yang ditempelkan pada [SOURCE](0x0C0L-source.md) membatasi tindakan pengutipan (tanggal akses, posisi dalam asal, dan lain-lain). Makna SOURCE pun adalah gabungan semua QUALIFIER yang menunjuknya.
- **QUALIFIER adalah bagian dari proposisi.** Ia bukan klaim terpisah tentang proposisi, melainkan membatasi syarat agar proposisi benar. Makna TRIPLE sasaran adalah gabungan semua QUALIFIER yang menunjuknya.
  - Asal-usul proposisi ditulis dengan [SOURCE](0x0C0L-source.md). Properti node asal (judul, penulis, dan lain-lain) ditulis sebagai TRIPLE dengan asal sebagai Subject.
- Pada Target yang sama dapat ada beberapa QUALIFIER dengan Property yang sama. Urutan QUALIFIER pada Target yang sama adalah urutan dalam dokumen (pengecualian yang memberi makna pada urutan Edge).

## Tidak diketahui dan tidak ada {#알-수-없음과-없음}

Jika Value QUALIFIER adalah penanda slot, makna pembatasnya berubah. Sebagai contoh, waktu berakhir (P582).

| Yang ditempelkan pada TRIPLE sasaran | Arti | Apakah proposisi masih berlaku sekarang |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | berakhir pada 1974 | tidak |
| `QUALIFIER P582 #n UNKNOWN` | sudah berakhir. Tidak diketahui kapan (`somevalue` Wikidata) | tidak |
| `QUALIFIER P582 #n NONE` | ditegaskan bahwa belum berakhir (`novalue` Wikidata) | ya |
| tanpa QUALIFIER P582 | tidak diketahui apakah sudah berakhir (dunia terbuka) | tidak diketahui |

- Jika `somevalue`·`novalue` qualifier Wikidata dibuang, proposisi menjadi melebar. TRIPLE perbatasan yang `somevalue` waktu berakhirnya dibuang akan terbaca sebagai "perbatasan yang masih berlaku sekarang". Karena itu saat dialihkan, ia dialihkan sebagai penanda.
- Antar UNKNOWN-VALUE tidak dianggap nilai yang sama. Hasil perbandingannya tak tentu.

## Contoh (non-normatif) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value adalah [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Perbatasan (P47) Q30 (Amerika Serikat)–Q34266 (Kekaisaran Rusia), waktu berakhir tidak diketahui. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (bagian 5): Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + penanda 1.

Menempelkan periode pada TRIPLE NO-VALUE bank sentral Q30 (P1304) `#3161`. Hanya tidak ada pada 1811~1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [penanda slot](../slot-marker.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000AB0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
