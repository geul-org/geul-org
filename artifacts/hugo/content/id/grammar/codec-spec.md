---
title: "Dokumen spesifikasi Codec"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Codebook juga adalah dokumen GEUL. Empat Edge DECLARE·FIELD·ENUM·CODEC mendeklarasikan susunan Payload satu Codec, dan satu dokumen itu sekaligus melakukan validasi, penguraian, dan tampilan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Bagaimana Codec menyusun Payload ditetapkan oleh codebook. Codebook GEUL bukan format terpisah, melainkan **dokumen GEUL**. Satu Codec, satu dokumen spesifikasi.

## Lokasi dokumen spesifikasi

Dokumen spesifikasi kode langsung diterbitkan oleh Issuer GEUL (`0x0000`). ID dokumennya adalah TAG WORD Codec itu (hanya posisi Kind·Codec, Length 0) yang diperlebar menjadi 4 WORD.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Dokumen spesifikasi |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

Decoder membuat alamat dokumen spesifikasi hanya dari TAG WORD. Saat menemui Codec yang tidak dikenal, cukup menerima dan membaca dokumennya.

- `<TAG>` adalah hex 4 digit TAG WORD target. Posisi Length adalah `0000`, dan pada Reference bit Quantifier dibiarkan `000` (LOCAL adalah `0008`).
- Codec Reference `0000` adalah cadangan sehingga tidak ada dokumen spesifikasi dengan TAG WORD target `0x0000`. Karena itu dokumen spesifikasi tidak tumpang tindih dengan dokumen indeks definisi istilah Issuer GEUL (ID dokumen `0`, [Issuer dan publikasi](/id/grammar/issuer/#dokumen-definisi-istilah)). [Penanda slot](/id/grammar/reference/slot-marker/) (`0x0000`~`0x0002`) Codec `0000` juga tidak memiliki dokumen spesifikasi. Ia ditanamkan di decoder ([lapisan 0](/id/grammar/publishing/#lapisan)).
- Dokumen spesifikasi menaruh DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`) sebagai `DOC-ID`. Record daftar versi juga memakai DOC-POINTER ini.
- Dokumen spesifikasi juga, seperti dokumen lain, mengikat nama slug huruf kecil pada indeks nama Issuer GEUL `0x0000/documents.geul`. Contoh: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)).
- Aturan versi·alamat kanonik·tanda tangan sama dengan dokumen terbitan biasa.

### ID dokumen Issuer GEUL

| ID dokumen | Pemakaian |
|---|---|
| `0x0000000000000000` | Dokumen indeks definisi istilah |
| `0x00000000 0000xxxx` | Dokumen spesifikasi Codec. `xxxx` adalah TAG WORD target |
| `0x0001xxxx xxxxxxxx` | Dokumen definisi istilah geul.org. Satu istilah, satu dokumen ([Issuer dan publikasi](/id/grammar/issuer/#dokumen-definisi-istilah)) |

- `0x00000000 0000xxxx` dicadangkan untuk dokumen spesifikasi Codec. Dokumen lain Issuer GEUL (dokumen format ISSUER khas GEUL yang ditaruh saat kode langsung kurang, dan lain-lain) tidak memakai rentang ini.

### Codebook dan edisi spesifikasi

- Dokumen codebook tidak diimpor dengan `IMPORT-DOC`. [SPEC-VERSION](/id/grammar/meta/declaration/spec-version/) pada HEAD dokumen menetapkan codebook mana yang diikuti.
- Semua decoder menanamkan codebook inti atau menerimanya dari alamat ini.
- Jika usulan (Prefix `000`) diadopsi sebagai standar, layout dibiarkan dan hanya Prefix berubah menjadi `001` ([Ikhtisar](/id/grammar/overview/#struktur-area)). Karena TAG WORD target berubah, edisi yang diadopsi menjadi dokumen spesifikasi baru dengan ID dokumen yang berbeda, dan dokumen usulan tetap tak berubah.

## Empat kosakata

| Edge | Codec | Fungsi |
|---|---|---|
| DECLARE | `0x1B` | Mendeklarasikan susunan Payload satu Codec. TAG WORD target 1 WORD |
| FIELD | `0x1C` | Satu field Payload. DECLARE tempatnya berada dan lebar |
| ENUM | `0x1D` | Memberi makna pada satu nilai kode field nilai mentah |
| CODEC | `0x1E` | Menetapkan satu Kind·Codec yang diterima field |

- Layout keempat Edge ditanamkan di decoder ([lapisan 0](/id/grammar/publishing/#lapisan)). Karena dokumen spesifikasi harus dapat dibaca tanpa codebook. Untuk membaca dokumen spesifikasi tidak diperlukan dokumen spesifikasi lain.
- Nama (nama Codec, nama field, nama nilai kode) semuanya diikat dengan BIND.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (DECLARE tempat field ini berada)
Lebar             1 WORD: 0 = record, n = nilai mentah n WORD, 0xFFFF = nilai mentah sisa
```

- **Urutan dalam dokumen** FIELD-FIELD yang menunjuk DECLARE yang sama adalah urutan field Payload.
- Field record dimulai dengan TAG WORD dan dibaca sebanyak Length-nya.
- Field nilai mentah adalah bilangan bulat tanpa tanda yang dibaca sebanyak jumlah WORD yang ditetapkan. Nilai yang memerlukan interpretasi seperti tanda·desimal·tanggal ditaruh sebagai record Value, bukan nilai mentah.
- Nilai mentah sisa (`0xFFFF`) hanya boleh satu, dan setelahnya hanya nilai mentah berlebar tetap.
- Edge Id sebuah Edge tidak dideklarasikan dengan FIELD. Ia implisit karena elemen pertama setiap Edge.
- Posisi setelah membaca field secara berurutan harus tepat sama dengan akhir record.

### CODEC

Menetapkan format yang diterima field. WORD target memakai posisi Kind·Codec TAG WORD apa adanya.

| Posisi Length | Arti | Contoh |
|---|---|---|
| `0000` | Codec yang tepat | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | Wildcard: bit Codec yang bernilai 0 cocok dengan apa pun | `0780` Reference apa saja, `0F80` Value apa saja, `07A0` QID Wikidata (kuantifikasi apa saja) |

- Jika field record tidak memiliki CODEC, ia menerima record apa saja (kecuali penanda slot). Jika ada satu atau lebih, harus salah satunya (daftar tertutup).
- Jika satu CODEC ditaruh pada field nilai mentah, nilai mentah itu diinterpretasikan sebagai Value tersebut tanpa TAG.

### Field opsional dan penanda slot

[Penanda slot](/id/grammar/reference/slot-marker/) adalah kelompok record 1 WORD pada Codec Reference cadangan `0000`. Ia hanya dapat berada pada posisi itu jika daftar CODEC field menaruh WORD itu sebagai target yang tepat.

| Target CODEC | Penanda | Field itu |
|---|---|---|
| `0000` | ABSENT, tidak ditulis | Adalah **field opsional**. Boleh dihilangkan |
| `0001` | UNKNOWN-VALUE, tidak diketahui | Menerima penegasan bahwa nilai ada tetapi tidak diketahui apa |
| `0002` | NO-VALUE, tidak ada | Menerima penegasan bahwa tidak ada nilai |

- **Aturan penerimaan:** penanda valid hanya jika daftar CODEC field itu memuat WORD yang sama sebagai target yang tepat. Wildcard (`0780`, `0781`, `0F80` …) dan field tanpa CODEC ("record apa saja") tidak menerima penanda. Pada posisi record HEAD·BODY dan posisi Edge Id, penanda invalid.
- Saat menghilangkan field opsional, tulis satu WORD `0x0000` (ABSENT) pada posisi itu. Field opsional juga selalu menempati posisinya. Karena itu notasi satu record hanya satu, dan pemecahannya ditentukan hanya oleh posisi.
- Penanda adalah Codec Reference cadangan sehingga tidak tumpang tindih dengan record lain, dan decoder yang tidak mengetahui spesifikasi pun melompatinya sebagai record 1 WORD.
- Ketiga penanda adalah pernyataan yang berbeda. ABSENT adalah pernyataan tentang dokumen (slot ini tidak diisi) sehingga tidak menegaskan apa pun tentang dunia. UNKNOWN-VALUE adalah penegasan bahwa nilai ada (`∃x`), NO-VALUE adalah penegasan bahwa nilai tidak ada (`¬∃x`, dalam syarat pembatas). Penghilangan bukan "tidak ada nilai" melainkan "tidak ditulis".
- Apa arti penanda ditetapkan oleh spesifikasi Codec yang menerimanya ([TRIPLE](/id/grammar/edge/triple/), [QUALIFIER](/id/grammar/edge/qualifier/)).

## Contoh: dokumen spesifikasi TRIPLE

BODY `0x0000/0x000000000000100A`.

| Edge | Isi | Nama (BIND) |
|---|---|---|
| #1 DECLARE | Target `100A` | `TRIPLE` |
| #2 FIELD | Field #1, record | `predicate` |
| #3 FIELD | Field #1, record | `subject` |
| #4 FIELD | Field #1, record | `object` |
| #5 FIELD | Field #1, nilai mentah 1 WORD | `rank` |
| #6~#8 ENUM | Nilai kode 0, 1, 2 dari #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 diinterpretasikan sebagai UNSIGNED-INTEGER (`0802`) | |
| #18, #19 CODEC | #4 adalah Reference apa saja (`0780`) atau Value apa saja (`0F80`) | |
| #20, #21 CODEC | #4 juga menerima UNKNOWN-VALUE (`0001`), NO-VALUE (`0002`) | |

Dengan satu dokumen ini, decoder membagi record TRIPLE menjadi field, menampilkannya dengan nama field, dan memeriksa kesesuaian formatnya.

## Contoh: dokumen spesifikasi QUANTITY

Value QUANTITY (`0806`) memiliki empat field yang semuanya record.

| Field | CODEC |
|---|---|
| `amount` | `0810` SIGNED-DECIMAL |
| `unit` | `0780` Reference apa saja, `0000` opsional |
| `lower` | `0810` SIGNED-DECIMAL, `0000` opsional |
| `upper` | `0810` SIGNED-DECIMAL, `0000` opsional |

## Aturan

- Satu dokumen spesifikasi memiliki satu DECLARE. Target DECLARE sama dengan TAG WORD pada ID dokumen.
- Target yang sama tidak dideklarasikan dua kali dalam satu dokumen.
- Varian yang susunan fieldnya berbeda tidak dipakai sebagai cabang. Dideklarasikan terpisah per Codec.
- Layout yang nilai mentah variabelnya dua atau lebih, atau lebar nilai mentahnya berubah menurut nilai lain, tidak dapat dideklarasikan. Bagian seperti itu dibungkus dengan record.
- Dokumen spesifikasi diterbitkan sebagai versi seperti dokumen lain. Namun layout biner Codec tidak direvisi. Untuk mengubahnya, alokasikan Codec baru.

## Masalah terbuka

- Padanan dari nilai `SPEC-VERSION` (v1 adalah `0x0001`) ke versi dokumen codebook. Meta silsilah yang menghubungkan edisi yang diadopsi dan edisi usulan.
