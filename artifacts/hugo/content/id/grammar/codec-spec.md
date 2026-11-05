---
title: "Dokumen spesifikasi Codec"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Bagaimana Codec menyusun Payload ditetapkan oleh codebook."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Bagaimana Codec menyusun Payload ditetapkan oleh codebook. Codebook GEUL bukan format terpisah, melainkan **dokumen GEUL**. Satu Codec, satu dokumen spesifikasi.

## Lokasi dokumen spesifikasi {#규격-문서의-위치}

Dokumen spesifikasi kode langsung diterbitkan oleh Issuer GEUL (`0x00000000`). Dokumen spesifikasi adalah dokumen codec dan tidak memiliki ID dokumen. Codec ID adalah nilai 32 bit dari TAG WORD Codec itu (hanya bagian dan posisi Codec `C`, Length 0).

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<ID versi>.geul
```

| Codec | TAG | Dokumen spesifikasi |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

Decoder membuat alamat dokumen spesifikasi hanya dari TAG WORD. Saat menemui Codec yang tidak dikenal, cukup menerima dan membaca dokumennya.

- `<TAG>` adalah 4 digit hex (huruf besar) dari TAG WORD target. Posisi Length adalah `0000`. Dokumen codec dibuat satu per kode. Sistem Reference 5Q juga memiliki dokumen sendiri untuk setiap kode kuantifikasi (LOCAL Identified `0050`, LOCAL Generic `0060`). Kode langsung dan codec Issuer memakai aturan alamat yang sama, `<Issuer>/codecs/<Codec ID>/` ([alamat publikasi dan daftar versi](publishing.md#공표-주소)).
- [Penanda slot](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) juga memiliki dokumen spesifikasi. Karena tidak ada Payload, hanya DECLARE yang ada dan tidak ada FIELD. Arti dan aturan penerimaan penanda tertanam di decoder ([lapisan 0](publishing.md#층)). Codec yang layout-nya belum ditetapkan juga dimulai dari dokumen spesifikasi yang hanya berisi DECLARE.
- Dokumen spesifikasi menaruh [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`) sebagai `DOC-ID`. Record daftar versi juga memakai CODEC-POINTER ini.
- Aturan versi, alamat kanonis, dan tanda tangan sama dengan dokumen publikasi umum.

### Codebook dan edisi spesifikasi {#코덱북과-명세-판}

- Dokumen codec juga dapat diimpor dengan [IMPORT-DOC](meta/0x1E4L-import-doc.md). Dalam hal itu, di posisi dokumen dipakai [CODEC-POINTER](reference/0x042L-codec-pointer.md), bukan DOC-POINTER. [SPEC-VERSION](meta/0x1C5L-spec-version.md) pada HEAD dokumen menetapkan codebook mana yang diikuti.
- Setiap decoder menyertakan codebook inti atau menerimanya dari alamat ini.
- Jika sebuah usulan (Prefix `000`) diadopsi sebagai standar, layout tetap sama dan hanya Prefix yang berubah menjadi `001` ([ikhtisar](_index.md#영역-구조)). Karena TAG WORD target berubah, versi yang diadopsi menjadi dokumen spesifikasi baru dengan Codec ID lain, dan dokumen usulan tetap tidak berubah.

## Empat kosakata {#네-어휘}

| Edge | Codec | Fungsi |
|---|---|---|
| DECLARE | `0x0BBL` | Mendeklarasikan susunan Payload satu Codec. TAG WORD target, 1 WORD |
| FIELD | `0x0BCL` | Satu field Payload. DECLARE tempatnya berada dan lebarnya |
| ENUM | `0x0BDL` | Memberi arti pada satu nilai kode field nilai mentah |
| CODEC | `0x0BEL` | Menetapkan satu Kind·Codec yang diterima field |

- Layout keempat Edge tertanam di decoder ([lapisan 0](publishing.md#층)). Alasannya, dokumen spesifikasi harus dapat dibaca tanpa codebook. Membaca dokumen spesifikasi tidak memerlukan dokumen spesifikasi lain.
- Nama (nama Codec, nama field, nama nilai kode) semuanya diikat dengan BIND.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (DECLARE tempat field ini berada)
lebar             1 WORD: 0 = record, n = nilai mentah n WORD, 0xFFFF = sisa nilai mentah
```

- **Urutan dalam dokumen** FIELD-FIELD yang menunjuk DECLARE yang sama adalah urutan field Payload.
- Field record dimulai dengan TAG WORD dan dibaca sepanjang Length-nya.
- Field nilai mentah adalah bilangan bulat tak bertanda yang dibaca sebanyak jumlah WORD yang ditetapkan. Nilai yang memerlukan penafsiran, seperti tanda, pecahan, atau tanggal, tidak dijadikan nilai mentah, melainkan ditaruh sebagai record Value.
- Sisa nilai mentah (`0xFFFF`) hanya boleh satu, dan setelahnya hanya boleh ada nilai mentah berlebar tetap.
- Edge Id milik Edge tidak dideklarasikan sebagai FIELD. Karena merupakan elemen pertama semua Edge, ia implisit. EDGE-ISSUER adalah elemen pertama setelah Issuer dan nomor Codec ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- Posisi setelah membaca field secara berurutan harus tepat sama dengan akhir record.

### CODEC {#codec}

Menetapkan bentuk yang diterima field. WORD target memakai posisi Codec TAG WORD (bagian `KKKK` dan `C`) apa adanya.

| Posisi Length | Arti | Contoh |
|---|---|---|
| `0000` | Codec yang tepat | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Wildcard: terlepas dari nilai `C`, seluruh bagian `KKKK` itu (32 slot). Disarankan slot pertama bagian (`C = 0`) | `000F` seluruh bagian 0, `060F` seluruh bagian 3 |

- Jika Kind mencakup beberapa bagian, CODEC dicantumkan untuk setiap bagian. Reference apa saja adalah `000F`·`020F`·`040F`, Value apa saja adalah `060F`·`080F`.
- Kelompok yang tidak peduli kuantifikasi mencantumkan Codec yang tepat. QID Wikidata (tidak peduli kuantifikasi) berjumlah lima: `0140`, `0150`, `0160`, `0170`, `0180`.

- Jika field record tidak memiliki CODEC, record apa saja diterima (kecuali penanda slot). Jika ada satu atau lebih, harus salah satu darinya (daftar tertutup).
- Jika field nilai mentah diberi satu CODEC, nilai mentah itu ditafsirkan sebagai Value tersebut tanpa TAG.

### Field opsional dan penanda slot {#선택-필드와-자리-표지}

[Penanda slot](slot-marker.md) adalah kelompok record 1 WORD yang ditetapkan pada tiga slot pertama bagian 0 Reference, `0x000L~0x002L`. Penanda hanya dapat muncul di posisi itu jika daftar CODEC field menjadikan WORD tersebut target yang tepat.

| Target CODEC | Penanda | Field itu |
|---|---|---|
| `0000` | ABSENT, tidak ditulis | **field opsional**. Dapat dihilangkan |
| `0010` | UNKNOWN-VALUE, tidak diketahui | menerima pernyataan bahwa nilai ada tetapi tidak diketahui |
| `0020` | NO-VALUE, tidak ada | menerima pernyataan bahwa nilai tidak ada |

- **Aturan penerimaan:** penanda hanya valid jika WORD yang sama ada sebagai target yang tepat dalam daftar CODEC field itu. Wildcard (`000F`, `060F` ...) dan field tanpa CODEC ("record apa saja") tidak menerima penanda. Di posisi record HEAD·BODY dan posisi Edge Id, penanda invalid.
- Saat menghilangkan field opsional, tulis satu WORD `0x0000` (ABSENT) di posisinya. Field opsional pun selalu menempati posisinya. Karena itu notasi sebuah record hanya satu, dan penguraian ditentukan oleh posisi saja.
- Penanda memiliki kode Reference sendiri sehingga tidak tumpang tindih dengan record lain, dan decoder yang tidak mengetahui spesifikasinya melewatinya sebagai record 1 WORD.
- Ketiga penanda adalah pernyataan yang berbeda. ABSENT adalah pernyataan tentang dokumen (posisi ini tidak diisi), sehingga tidak menyatakan apa pun tentang dunia. UNKNOWN-VALUE adalah pernyataan bahwa nilai ada (`∃x`), NO-VALUE adalah pernyataan bahwa nilai tidak ada (`¬∃x`, dalam kondisi pembatas). Penghilangan berarti "tidak ditulis", bukan "tidak ada nilai".
- Arti penanda ditetapkan oleh spesifikasi Codec yang menerimanya ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Contoh: dokumen spesifikasi TRIPLE {#예-triple-규격-문서}

BODY dari `0x00000000/codecs/0x00000AA0`.

| Edge | Isi | Nama (BIND) |
|---|---|---|
| #1 DECLARE | target `0AA0` | `TRIPLE` |
| #2 FIELD | field #1, record | `predicate` |
| #3 FIELD | field #1, record | `subject` |
| #4 FIELD | field #1, record | `object` |
| #5 FIELD | field #1, nilai mentah 1 WORD | `rank` |
| #6~#8 ENUM | nilai kode 0, 1, 2 dari #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 ditafsirkan sebagai UNSIGNED-INTEGER (`0620`) | |
| #18, #22, #23, #19, #24 CODEC | #4 adalah Reference apa saja (`000F`·`020F`·`040F`) atau Value apa saja (`060F`·`080F`) | |
| #20, #21 CODEC | #4 juga menerima UNKNOWN-VALUE (`0010`), NO-VALUE (`0020`) | |
| #25~#27 CODEC | #2 adalah Reference apa saja (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 adalah Reference apa saja (`000F`·`020F`·`040F`) | |

Dengan satu dokumen ini, decoder membagi record TRIPLE menjadi field, menampilkannya dengan nama field, dan memeriksa apakah bentuknya benar.

## Contoh: dokumen spesifikasi QUANTITY {#예-quantity-규격-문서}

Pada Value QUANTITY (`0660`), keempat field semuanya record.

| Field | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (hanya nilai terhingga), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` Reference apa saja, `0000` opsional |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (sama dengan amount), `0000` opsional |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (sama dengan amount), `0000` opsional |

## Aturan {#규칙}

- Satu dokumen spesifikasi memiliki satu DECLARE. Target DECLARE sama dengan TAG WORD Codec ID.
- Target yang sama tidak dideklarasikan dua kali dalam satu dokumen.
- Varian dengan susunan field berbeda tidak dibuat sebagai percabangan. Dideklarasikan terpisah untuk setiap Codec.
- Layout yang memiliki dua nilai mentah variabel atau lebih, atau yang lebar nilai mentahnya bergantung pada nilai lain, tidak dapat dideklarasikan. Bagian seperti itu dibungkus sebagai record.
- Dokumen spesifikasi diterbitkan dengan versi seperti dokumen lain. Namun layout biner Codec tidak direvisi. Untuk mengubahnya, tetapkan Codec baru.

## Masalah terbuka {#열린-문제}

- Korespondensi dari nilai `SPEC-VERSION` (v1 adalah `0x0001`) ke versi dokumen codebook. Meta silsilah yang menghubungkan versi yang diadopsi dan versi usulan.
