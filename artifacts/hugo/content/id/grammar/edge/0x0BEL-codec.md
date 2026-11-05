---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC adalah Edge pernyataan yang menentukan satu Kind·Codec yang diterima satu FIELD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CODEC` (BIND dokumen spesifikasi `CODEC`) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000BE0/` (target DECLARE `0BE0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 30 |
| Kind | Edge · keluarga: pernyataan, kelompok: lainnya |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Satu Kind·Codec yang diterima bidang. Bidang, WORD sasaran (`000K KKKC CCCC LLLL`, LLLL 0000 persis·1111 wildcard (seluruh 32 slot bagian itu), penanda slot hanya sebagai sasaran persis `0000`·`0010`·`0020`). Bidang record boleh banyak (daftar tertutup), bidang nilai mentah satu (Value itu tanpa TAG) |
| Sisi Hugo | `edge/codec.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | record | `0050` LOCAL |  |
| 2 | `target` | #4 | nilai mentah 1 WORD |  |  |

CODEC adalah Edge pernyataan yang menentukan satu Kind·Codec yang diterima satu [FIELD](0x0BCL-field.md). Codec `0x0BEL`.

Seperti [ENUM](0x0BDL-enum.md) yang memberi makna pada satu nilai kode bidang nilai mentah, CODEC menempelkan satu bentuk pada bidang. Karena satu per Edge, beberapa dapat ditentukan. Layout tertanam di decoder ([dokumen spesifikasi Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Bidang            record LOCAL Reference yang menunjuk Edge FIELD
Sasaran           1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 persis, 1111 wildcard)
```

## WORD sasaran {#대상-word}

- Posisi Codec TAG WORD (bagian `KKKK` dan `CCCCC`) dibiarkan apa adanya. 3 bit atas adalah 0. `LLLL` adalah `0000` (persis) atau `1111` (wildcard), nilai lain invalid.
- Nilai sasaran persis (`LLLL = 0000`) yang ditulis dalam 32 bit adalah Codec ID Codec itu (contoh: LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). Karena itu sasaran langsung menunjuk dokumen spesifikasi Codec itu ([dokumen spesifikasi Codec](../codec-spec.md)).
- Pasangan kode genap·ganjil (teks·deret byte) juga ditentukan dengan kode persis. Untuk menerima genap dan ganjil, keduanya ditaruh. Tidak ada aturan yang menafsirkan pasangan sebagai satu kesatuan (ada kode bertetangga yang bukan pasangan, seperti NUMERIC `0x064L`/`0x065L`).

### Wildcard (`LLLL = 1111`) {#와일드카드-llll--1111}

- Jika `LLLL = 1111`, seluruh bagian `KKKK` (32 slot) dari WORD sasaran diterima, apa pun nilai `C`. Dalam bagian yang sama, `C` berapa pun bermakna sama. Yang dilihat hanya apakah bagian sasaran dan bagian record sama. Tidak menerima melintasi bagian.
- Jika `LLLL = 1111`, slot pertama bagian (`C = 0`) dianjurkan. Ini anjuran, bukan paksaan. `C` lain di bagian yang sama juga valid.
- Jika Kind mencakup beberapa bagian, CODEC dicantumkan per bagian.

| Sasaran | Arti |
|---|---|
| `000F`·`020F`·`040F` | Reference apa saja (bagian 0~2, termasuk REFERENCE-ISSUER) |
| `060F`·`080F` | Value apa saja (bagian 3·4, termasuk VALUE-ISSUER) |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | Edge apa saja (bagian 5~13, termasuk EDGE-ISSUER) |
| `1C0F`·`1E0F` | Meta apa saja (bagian 14·15) |

- Penanda slot Reference (`0x000L~0x002L`) tidak cocok dengan `LLLL = 1111` (`000F` tidak menerima ABSENT·UNKNOWN-VALUE·NO-VALUE). Sebaliknya, pada bagian yang slot pertamanya sudah dialokasikan seperti Value `0x060L` (BOOL) dan Edge `0x0A0L` (REFERENCE-NODE), `LLLL = 1111` mencakupnya (untuk menerima hanya BOOL, pakai `0600` dengan `LLLL = 0000`).
- Sasaran dengan `LLLL = 1111` tidak menunjuk dokumen spesifikasi.
- Penerimaan tanpa memandang kuantifikasi, atau berupa kelompok, hanya ditulis dengan daftar CODEC (`LLLL = 0000`). Contoh: WIKIDATA-QID tanpa memandang kuantifikasi adalah lima, yaitu `0140`, `0150`, `0160`, `0170`, `0180`.
- Kode sistem 5Q Reference sudah memuat kuantifikasi. Sasaran harus menentukan hingga kuantifikasinya secara persis. Untuk menerima beberapa Quantifier, ditaruh beberapa CODEC. Kuantifikasi REFERENCE-ISSUER ditentukan oleh dokumen Issuer.

### Penanda slot (sasaran `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

[Penanda slot](../slot-marker.md) adalah kelompok record 1 WORD yang dialokasikan pada tiga slot pertama bagian 0 Reference, `0x000L~0x002L`. Tidak punya kuantifikasi.

| Sasaran | Penanda | Arti |
|---|---|---|
| `0000` | ABSENT | tidak ditulis. Bidang itu adalah bidang opsional |
| `0010` | UNKNOWN-VALUE | tidak diketahui. Menerima penegasan bahwa ada nilai |
| `0020` | NO-VALUE | tidak ada. Menerima penegasan bahwa tidak ada nilai |

- **Aturan penerimaan:** penanda hanya valid jika WORD yang sama ada sebagai sasaran persis dalam daftar CODEC bidang itu. Wildcard dan bidang record tanpa CODEC ("record apa saja") tidak menerima penanda. Penanda pada posisi record HEAD·BODY dan posisi Edge Id adalah invalid.
- Daftar yang hanya berisi sasaran penanda (selalu penanda) adalah invalid (generalisasi aturan daftar yang hanya berisi `0000`). Dipakai bersama sasaran `LLLL = 1111` atau sasaran persis (`000F`·`020F`·`040F` + `0000` = Reference apa saja atau dihilangkan).
- Sasaran penanda tidak dapat ditaruh pada bidang nilai mentah. Nilai mentah tidak punya TAG dan lebarnya tetap, sehingga tidak ada tempat untuk penanda 1 WORD.
- Makna penanda ditentukan oleh spesifikasi Codec yang menerimanya.

### Bidang opsional (sasaran `0000`) {#선택-필드-대상-0000}

- Jika sasaran `0000` ditaruh pada daftar CODEC bidang record, bidang itu adalah **bidang opsional**. Saat dihilangkan, 1 WORD `0x0000` ditulis pada posisi itu. Record 1 WORD ini adalah penanda slot ABSENT (tidak ditulis).
- `0x0000` adalah Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (total 1 WORD). Tidak bertabrakan dengan record lain, dan decoder yang tidak mengetahui spesifikasi pun melompatinya sebagai record 1 WORD.
- Bidang opsional juga selalu menempati posisinya. Jika dihilangkan, `0x0000` wajib ditulis dan posisi tidak dikosongkan (sama untuk bidang di belakang). Karena itu notasi sebuah record hanya satu, dan penguraian ditentukan hanya oleh posisi. Tidak ada batasan pada posisi dan jumlah bidang opsional, maupun tumpang tindih daftarnya dengan bidang lain.
- ABSENT hanya valid pada posisi bidang opsional. `0x0000` pada posisi record HEAD·BODY, posisi bidang wajib, dan posisi Edge Id adalah invalid.
- Penghilangan bukan "tidak ada nilai" melainkan "tidak ditulis". Tidak menegaskan apa pun tentang dunia. "Tidak ada nilai" ditulis dengan NO-VALUE (`0020`). Apa arti penghilangan (contoh: jika tidak ada sasaran TAG, berarti versi ini) ditentukan oleh spesifikasi masing-masing bentuk.

## Interpretasi dan validitas {#해석과-유효성}

- Bidang adalah Edge FIELD dalam dokumen yang sama. Sasaran yang sama tidak ditaruh dua kali pada satu bidang.
- **Bidang record (lebar 0)**: jika tidak ada CODEC, menerima record apa saja selain penanda slot. Jika ada satu atau lebih, itu adalah daftar tertutup. Record bidang itu harus salah satu Kind·Codec dalam daftar (Reference termasuk Quantifier), jika tidak record itu tidak mengikuti spesifikasi. Berbeda dengan ENUM yang merupakan daftar terbuka.
- **Bidang nilai mentah (lebar n ≥ 1, atau sisa `0xFFFF`)**: CODEC hanya menaruh satu sasaran persis (wildcard tidak boleh). Nilai mentah itu adalah Payload Value tersebut tanpa TAG. Kind·Codec diberikan oleh CODEC, dan Length diberikan oleh lebar FIELD. Pada kode genap·ganjil, kode yang ditentukan menetapkan paritas jumlah byte. Jika nilai mentah tidak mengikuti aturan Value itu (termasuk panjang), record itu tidak mengikuti spesifikasi.
- Penanda slot dicocokkan hanya dengan sasaran persis dalam daftar. Jika `0x0000` muncul pada posisi bidang opsional (sasaran `0000`), itu penghilangan. Record lain dicocokkan dengan daftar tanpa sasaran penanda.
- Pada bidang nilai mentah, CODEC dan ENUM dapat ditaruh bersama. CODEC adalah bentuk, ENUM adalah nama nilai kode (contoh: rank sebagai UNSIGNED-INTEGER dan 0·1·2 sebagai ENUM).
- Nama dapat ditempelkan pada Edge Id CODEC dengan BIND, tetapi tidak wajib.
- Bidang "Reference atau Value" ditulis dengan 5 CODEC (`000F`, `020F`, `040F`, `060F`, `080F`).

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD jika Edge Id·bidang adalah ID LOCAL 1 WORD)
```

## Contoh {#예시}

Pada dokumen spesifikasi LABEL `0x00000000/codecs/0x00000A40/`, bidang Object (FIELD #3) menerima UTF8-LANGUAGE-TEXT (genap·ganjil) dan LOCAL. Edge Id 7~9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORD), Edge Id `0051 0007`, bidang `0051 0003`, sasaran `0780`.

## Halaman terkait {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [dokumen spesifikasi Codec](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000BE0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
