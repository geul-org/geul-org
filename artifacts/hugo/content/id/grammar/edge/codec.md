---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC adalah Edge pernyataan yang menetapkan satu Kind·Codec yang diterima sebuah FIELD (Codec 0x1E). Wildcard dan penanda slot (0x0000 tidak ditulis, 0x0001 tidak diketahui, 0x0002 tidak ada) juga dideklarasikan dengan ini."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC adalah Edge pernyataan yang menetapkan satu Kind·Codec yang diterima sebuah [FIELD](/id/grammar/edge/field/). Codec `0x1E`.

Seperti [ENUM](/id/grammar/edge/enum/) memberi makna pada satu nilai kode field nilai mentah, CODEC memberi satu format pada sebuah field. Karena satu Edge satu format, beberapa format dapat ditetapkan. Layoutnya ditanamkan di decoder ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1110
[Length extension TAG]
Edge Id           record LOCAL Reference
Field             record LOCAL Reference yang menunjuk Edge FIELD
Target            1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 tepat, 1111 wildcard)
```

## WORD target

- Posisi Kind (`KK`) dan Codec (`CCCCCCC`) TAG WORD dibiarkan apa adanya. 3 bit atas adalah 0. `LLLL` adalah `0000` (tepat) atau `1111` (wildcard), dan nilai lain invalid.
- Target tepat (`LLLL = 0000`) bernilai sama dengan ID dokumen spesifikasi Codec (contoh: LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). Karena itu target langsung menunjuk dokumen spesifikasi Codec itu.
- Pasangan kode genap·ganjil (teks·deretan byte) juga ditetapkan dengan kode yang tepat. Untuk menerima genap dan ganjil, taruh keduanya. Tidak ada aturan yang menginterpretasikan pasangan sebagai satu (ada kode bersebelahan yang bukan pasangan seperti NUMERIC `0x04`/`0x05`).

### Wildcard (`LLLL = 1111`)

- Kind harus sama, dan **kelompok bit Codec yang bernilai 0 cocok dengan apa pun**. Pada Reference, `CCCC` (Codec) dan `QQQ` (Quantifier) adalah kelompok terpisah, sedangkan pada Kind lain seluruh 7 bit adalah satu kelompok.

| Target | Arti |
|---|---|
| `0780` | Reference apa saja |
| `07A0` | WIKIDATA-QID, Quantifier apa saja |
| `0781` | Codec Reference apa saja, Quantifier Generic (`001`) |
| `0F80` | Value apa saja |
| `1780`, `1F80` | Edge apa saja, Meta apa saja |

- Wildcard yang tidak ada yang dicocokkan adalah invalid. Pada Value·Edge·Meta, Codec harus 0, dan pada Reference salah satu dari `CCCC` atau `QQQ` harus 0. Reference `CCCC = 0000` (penanda slot) adalah Codec cadangan sehingga **tidak cocok dengan wildcard mana pun** (`0780` tidak menerima ABSENT·UNKNOWN-VALUE·NO-VALUE). Sebaliknya, pada Kind yang Codec 0-nya sudah dialokasikan seperti Value `0x00` (BOOL) dan Edge `0x00` (REFERENCE-NODE), wildcard juga mencakupnya (untuk menerima hanya BOOL, pakai `LLLL = 0000`).
- Wildcard tidak menunjuk dokumen spesifikasi.
- Tidak ada ungkapan yang mengunci hanya satu kelompok bukan-0 sambil mengunci kelompok 0, seperti "Reference apa saja khusus Identified". Daftar seperti itu menyebutkan target yang tepat satu per satu.
- 7 bit Codec Reference memuat Quantifier (`QQQ`). Target menetapkan Quantifier dengan tepat. Untuk menerima beberapa Quantifier, taruh beberapa CODEC.

### Penanda slot (target `0000`~`0002`)

[Penanda slot](/id/grammar/reference/slot-marker/) adalah kelompok record 1 WORD pada Codec Reference cadangan `0000`. 3 bit bawah adalah nomor penanda (bukan Quantifier).

| Target | Penanda | Arti |
|---|---|---|
| `0000` | ABSENT | Tidak ditulis. Field itu adalah field opsional |
| `0001` | UNKNOWN-VALUE | Tidak diketahui. Menerima penegasan bahwa nilai ada |
| `0002` | NO-VALUE | Tidak ada. Menerima penegasan bahwa tidak ada nilai |
| `0003`~`0007` | Cadangan | |

- **Aturan penerimaan:** penanda valid hanya jika daftar CODEC field itu memuat WORD yang sama sebagai target yang tepat. Wildcard dan field record tanpa CODEC ("record apa saja") tidak menerima penanda. Penanda pada posisi record HEAD·BODY dan posisi Edge Id adalah invalid.
- Daftar yang hanya berisi target penanda (selalu penanda) adalah invalid (generalisasi aturan daftar yang hanya berisi `0000`). Pakai bersama wildcard atau target yang tepat (`0780` + `0000` = Reference apa saja atau dihilangkan).
- Target penanda tidak dapat ditaruh pada field nilai mentah. Nilai mentah tidak memiliki TAG dan lebarnya tetap sehingga tidak ada tempat untuk penanda 1 WORD.
- Arti penanda ditetapkan oleh spesifikasi Codec yang menerimanya.

### Field opsional (target `0000`)

- Jika target `0000` ditaruh pada daftar CODEC field record, field itu adalah **field opsional**. Saat dihilangkan, tulis 1 WORD `0x0000` pada posisi itu. Record 1 WORD ini adalah penanda slot ABSENT (tidak ditulis).
- `0x0000` adalah Codec Reference `0000` (cadangan), nomor penanda `000`, `LLLL = 0000` (total 1 WORD). Ia tidak tumpang tindih dengan record lain, dan decoder yang tidak mengetahui spesifikasi pun melompatinya sebagai record 1 WORD.
- Field opsional tetap selalu menempati posisinya. Jika dihilangkan, selalu tulis `0x0000` dan jangan mengosongkan posisi (sama untuk field di belakang). Karena itu notasi satu record hanya satu, dan pemecahannya ditentukan hanya oleh posisi. Tidak ada batasan pada posisi dan jumlah field opsional, maupun tumpang tindih daftar dengan field lain.
- ABSENT hanya valid pada posisi field opsional. `0x0000` pada posisi record HEAD·BODY, posisi field wajib, dan posisi Edge Id adalah invalid.
- Penghilangan bukan "tidak ada nilai" melainkan "tidak ditulis". Tidak menegaskan apa pun tentang dunia. "Tidak ada nilai" ditulis dengan NO-VALUE (`0002`). Apa arti penghilangan (contoh: jika tidak ada target pada TAG maka versi ini) ditetapkan oleh spesifikasi setiap format.

## Interpretasi dan validitas

- Field adalah Edge FIELD dalam dokumen yang sama. Target yang sama tidak ditaruh dua kali pada satu field.
- **Field record (lebar 0)**: jika tidak ada CODEC, field menerima record apa saja kecuali penanda slot. Jika ada satu atau lebih, itu adalah daftar tertutup. Record field itu harus memiliki Kind·Codec (untuk Reference termasuk Quantifier) yang ada di daftar, jika tidak record itu tidak mengikuti spesifikasi. Berbeda dari ENUM yang daftar terbuka.
- **Field nilai mentah (lebar n ≥ 1, atau sisa `0xFFFF`)**: CODEC hanya menaruh satu target yang tepat (wildcard tidak boleh). Nilai mentah itu adalah Payload Value tersebut tanpa TAG. Kind·Codec ditentukan CODEC dan Length ditentukan lebar FIELD. Pada kode genap·ganjil, kode yang ditetapkan menentukan paritas jumlah byte. Jika nilai mentah tidak mengikuti aturan Value itu (termasuk panjang), record itu tidak mengikuti spesifikasi.
- Penanda slot hanya dicocokkan dengan target tepat pada daftar. Jika `0x0000` datang pada posisi field opsional (target `0000`), itu adalah penghilangan. Record lain dicocokkan dengan daftar tanpa target penanda.
- Pada field nilai mentah, CODEC dan ENUM dapat ditaruh bersama. CODEC adalah format, ENUM adalah nama nilai kode (contoh: rank sebagai UNSIGNED-INTEGER dengan 0·1·2 sebagai ENUM).
- Nama dapat ditempelkan pada Edge Id CODEC dengan BIND, tetapi tidak wajib.
- Field "Reference atau Value" ditulis dengan 2 CODEC (`0780`, `0F80`).

## Panjang

```
Total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD jika Edge Id·field adalah ID LOCAL 1 WORD)
```

## Contoh

Pada dokumen spesifikasi LABEL `geul.org/label`, field Object (FIELD #3) menerima UTF8-LANGUAGE-TEXT (genap·ganjil) dan LOCAL. Edge Id 7~9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORD), Edge Id `0088 0007`, field `0088 0003`, target `084A`.

## Halaman terkait

- [FIELD](/id/grammar/edge/field/), [ENUM](/id/grammar/edge/enum/), [DECLARE](/id/grammar/edge/declare/), [BIND](/id/grammar/edge/bind/)
- [Dokumen spesifikasi Codec](/id/grammar/codec-spec/), [LABEL](/id/grammar/edge/label/)
