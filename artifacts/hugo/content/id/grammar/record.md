---
title: "Record dan TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Setiap record dimulai dengan TAG WORD 16 bit. Prefix 3 bit, Kind 2 bit, Length 4 bit, dan Codec 7 bit menetapkan jenis dan panjang record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Data GEUL adalah rangkaian record. Setiap record dimulai dengan satu TAG WORD.

## Layout record

```
TAG WORD (16 bit)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length extension TAG]
[Codec extension TAG]
[TAG per Codec]
Payload
```

- TAG WORD adalah `000K KLLL LCCC CCCC`.
- Extension TAG hanya ditaruh dalam urutan di atas. Length extension TAG selalu tepat setelah TAG WORD.
- Susunan TAG per Codec dan Payload ditetapkan spesifikasi setiap Codec. Panjang TAG per Codec tidak ditulis di TAG WORD. Karena untuk menginterpretasikan Payload, codebook diperlukan bagaimanapun.
- Codec yang memiliki sub-format menetapkan sub-format dengan 1 WORD TAG per Codec (Edge WORLD, dan lain-lain).

## Urutan byte

- Serialisasi kanonik adalah big-endian.
- Field bit ditata mulai dari bit paling signifikan.
- Dalam WORD, byte atas ditulis lebih dulu, dan untuk nilai yang terdiri dari beberapa WORD, WORD atas ditulis lebih dulu.
- Representasi di dalam memori bebas ditentukan implementasi.

## Kind (2 bit)

| Nilai | Kind | TAG WORD | Definisi |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Menunjuk target. Mengidentifikasi target dengan Codec dan ID target |
| `01` | Value | `0000 1LLL LCCC CCCC` | Memuat nilai itu sendiri. Codec menetapkan interpretasi Payload |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Mengikat record lain sebagai komponen. Codec menetapkan peran dan urutan komponen |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Berbicara tentang dokumen dan record |

- Kind adalah atribut tetap Codec. Codec yang sudah dialokasikan tidak dipindah Kind-nya.
- Value dan Edge berformat sama "Codec + Payload". Hanya Edge yang memiliki record lain sebagai komponen.
- Reference membagi 7 bit Codec menjadi 4 bit Codec dan 3 bit Quantifier ([Reference](/id/grammar/reference/)).

## Length (4 bit)

Length adalah **jumlah WORD total** yang ditempati record. Mencakup TAG WORD, extension TAG, Payload, dan padding WORD terakhir.

| Nilai | Arti |
|---|---|
| `0000`~`1101` | 1~14 WORD (nilai + 1) |
| `1110` | Panjang extension 1: jumlah WORD total pada 1 WORD berikutnya (15~65,535) |
| `1111` | Panjang extension 2: jumlah WORD total pada 2 WORD berikutnya (65,536~2³²−1) |

- 1~14 WORD harus ditulis sebagai panjang langsung. Notasi yang lebih lebar bukan bentuk kanonik.
- Jumlah WORD total pada panjang extension juga mencakup Length extension TAG itu sendiri.
- Tidak ada record yang melebihi 2³²−1 WORD.
- Record 1 WORD adalah satu TAG WORD tanpa Payload. Hanya dipakai jika spesifikasi Codec mengizinkan (contoh: Meta `BODY`, `END`, deretan byte kosong, penanda slot).
- Walaupun tanpa codebook, record dapat dilompati dengan `posisi record berikutnya = awal record saat ini + Length`.

## Codec (7 bit)

| Nilai | Nama | Arti |
|---|---|---|
| `0x00`~`0x7B` | Kode langsung | Codec ditetapkan hanya oleh TAG WORD |
| `0x7C` | ISSUER-1WORD | Issuer 1 WORD dan nomor format 1 WORD pada Codec extension TAG |
| `0x7D` | ISSUER-2WORD | Issuer 2 WORD dan nomor format 1 WORD pada Codec extension TAG |
| `0x7E` | ISSUER-4WORD | Issuer 4 WORD dan nomor format 1 WORD pada Codec extension TAG |
| `0x7F` | ISSUER-16WORD | Issuer 16 WORD dan nomor format 1 WORD pada Codec extension TAG |

- Ruang nomor Codec terpisah per Kind. Nomor yang sama dengan Kind berbeda adalah Codec yang berbeda.
- Codec yang bukan kode langsung adalah pasangan `(Issuer, nomor format)`. Nomor format didefinisikan oleh Issuer itu ([Issuer dan publikasi](/id/grammar/issuer/)). Format perluasan ditaruh di bawah Issuer lembaga yang menetapkan format itu.
- Codec yang memiliki kode langsung tidak didaftarkan terpisah sebagai format Issuer.
- Format Issuer hanya ada pada Value dan Edge. Reference memakai 4 bit Codec, dan Meta adalah spesifikasi umum yang hanya didefinisikan GEUL.
- Bit atas Codec dan nomor format menyatakan keluarga (Value·Edge) atau kelas (Meta). Keluarga diketahui tanpa codebook.
- Kode langsung tidak dapat ditarik kembali. Hanya format yang frekuensinya sudah terkonfirmasi yang ditaruh pada kode langsung.

## Record format Issuer

```
TAG WORD          Codec = 0x7C~0x7F
[Length extension TAG]
Issuer            1/2/4/16 WORD (Codec menetapkan lebar)
Nomor format      1 WORD. Bit atas adalah keluarga
Payload           nilai yang ditetapkan format
```

- Decoder yang tidak mengenal format hanya mengetahui keluarga dari nomor format dan melompati Payload.

## Deretan byte panjang variabel

Nilai yang panjangnya dalam satuan byte, seperti teks, URI, tag bahasa, dan deretan byte tak dikenal, dialokasikan Codec (atau nomor format) sebagai **pasangan genap·ganjil**.

- Jika bit paling tidak signifikan Codec `0`, jumlah byte genap; jika `1`, ganjil.
- Jumlah byte = `2 × jumlah WORD Payload − bit paling tidak signifikan`. Tidak ada field Byte Count.
- Jika ganjil, byte bawah WORD terakhir adalah padding `0x00`. Jika bukan `0x00`, ditolak.
- Deretan byte kosong adalah record 1 WORD (hanya TAG WORD) dari Codec genap.
- Nilai berukuran tetap seperti UUID·digest·alamat tidak memiliki pasangan.

## Contoh: membaca TAG WORD

Mari baca `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10 (Edge), Length 1001 (10 WORD), Codec 0x0A (TRIPLE)
```

Record ini adalah Edge sebesar 10 WORD dan Codec-nya TRIPLE. Walaupun tanpa codebook, diketahui bahwa record berikutnya ada 10 WORD setelahnya.

## Penanda slot

TAG WORD `0x0000`~`0x0007` adalah record 1 WORD dari Codec Reference cadangan `0000`. Ia tidak menunjuk target dan mengisi posisi field record ([Penanda slot](/id/grammar/reference/slot-marker/)).

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = nomor penanda
```

| WORD | Nama | Arti | Tentang apa | Logika | Asumsi dunia | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Tidak ditulis | Dokumen: slot ini tidak diisi | Tanpa penegasan | Dunia terbuka | Tanpa snak |
| `0x0001` | UNKNOWN-VALUE | Tidak diketahui | Dunia: nilai ada. Tidak diketahui apa | `∃x. P(s, x)` | Keberadaan tertutup, identitas terbuka | `somevalue` |
| `0x0002` | NO-VALUE | Tidak ada | Dunia: nilai tidak ada | `¬∃x. P(s, x)` | Tertutup untuk (s, P, syarat pembatas) | `novalue` |
| `0x0003`~`0x0007` | Cadangan | | | | | |

- Contoh: jika anak (P40) adalah ABSENT, jumlahnya tidak diketahui; jika UNKNOWN-VALUE, 1 atau lebih; jika NO-VALUE, 0. Jika waktu berakhir (P582) adalah ABSENT, tidak diketahui apakah masih berlaku; jika UNKNOWN-VALUE, sudah berakhir tetapi waktunya tidak diketahui; jika NO-VALUE, belum berakhir.
- 3 bit bawah `MMM` bukan Quantifier melainkan nomor penanda ([Reference](/id/grammar/reference/) pengecualian Quantifier).
- Penanda valid hanya jika daftar CODEC field menaruh WORD itu secara tepat. Pada wildcard, field tanpa CODEC, posisi record HEAD·BODY, dan posisi Edge Id, penanda invalid ([CODEC](/id/grammar/edge/codec/)).
- Kewajiban pihak pembaca:
  1. UNKNOWN-VALUE bukan nilai, melainkan penegasan keberadaan. Ia tidak sama dan tidak berbeda dengan nilai apa pun, dan dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. TRIPLE yang memuat UNKNOWN-VALUE tidak digabung sebagai duplikat.
  2. NO-VALUE tertutup dalam syarat pembatas proposisinya. Jika ada bersama TRIPLE nilai dengan Subject·Predicate·rank yang sama tanpa syarat pembatas yang membedakan, itu kontradiksi dan pemeriksa memberi peringatan (tidak menolak).
  3. rank berlaku sama. Saat memilih nilai representatif (truthy), TRIPLE kedua penanda juga menjadi kandidat.
  4. Jika dipakai sebagai nilai QUALIFIER, ia mengubah makna pembatas itu (`P582 = UNKNOWN`: sudah berakhir, waktunya tidak diketahui. `P582 = NONE`: belum berakhir).
  5. ABSENT tidak mengatakan apa pun tentang dunia. Nilai yang tidak dapat dipindahkan tidak ditulis sebagai UNKNOWN-VALUE.

## Bentuk kanonik

Isi yang sama harus menjadi byte yang sama. Dengan begitu hash isi dan tanda tangan ditentukan secara tunggal.

- Panjang memakai notasi terpendek (1~14 WORD sebagai panjang langsung).
- Bilangan bulat ditulis dengan lebar terpendek. Mengikuti bentuk kanonik yang ditetapkan spesifikasi setiap Codec.
- Record yang bukan bentuk kanonik ditolak.
