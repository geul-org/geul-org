---
title: "Struktur record"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Data GEUL adalah rangkaian record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Data GEUL adalah rangkaian record. Setiap record dimulai dengan satu TAG WORD.

## Layout record {#레코드-레이아웃}

```
TAG WORD (16 bit)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[TAG ekstensi Length]
[TAG ekstensi Codec]
[TAG per Codec]
Payload
```

- TAG WORD adalah `000K KKKC CCCC LLLL`. 4 bit atas `KKKK` adalah bagian `S = w >> 9`, dan satu bagian terdiri dari 32 slot. `C` adalah offset 5 bit dalam bagian `(w >> 4) & 0x1F`.
- TAG ID ditulis `0x000L`. Tiga digit depan adalah posisi Codec 9 bit (`w >> 4`) yang menggabungkan bagian dan `C`, dan `L` adalah posisi Length. Nilai WORD sebenarnya menulis angka di posisi L (contoh: TRIPLE adalah `0x0AAL`, dan TAG WORD TRIPLE 10 WORD adalah `0x0AA9`).
- TAG ekstensi hanya diletakkan menurut urutan di atas. TAG ekstensi Length selalu tepat setelah TAG WORD.
- Susunan TAG per Codec dan Payload ditetapkan oleh spesifikasi masing-masing Codec. Panjang TAG per Codec tidak ditulis di TAG WORD. Karena untuk menafsirkan Payload pun codebook tetap diperlukan.
- Codec yang memiliki subformat menetapkan subformat dengan 1 WORD TAG per Codec (Edge WORLD dan sebagainya).

## Urutan byte {#바이트-순서}

- Serialisasi kanonis adalah big endian.
- Bit field ditata mulai dari bit tertinggi.
- Dalam WORD, byte atas ditulis lebih dahulu, dan untuk nilai yang terdiri dari beberapa WORD, WORD atas ditulis lebih dahulu.
- Representasi dalam memori bebas ditetapkan implementasi.

## Kind (rentang bagian) {#kind-섹션-구간}

| Bagian | Kind | TAG ID | Definisi |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Menunjuk objek. Mengidentifikasi objek dengan Codec dan ID objek |
| 3·4 | Value | `0x060L~0x09FL` | Memuat nilai itu sendiri. Codec menetapkan penafsiran Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Mengikat record lain sebagai komponen. Codec menetapkan peran dan urutan komponen |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Berbicara tentang dokumen dan record |

- Kind ditentukan oleh satu rentang bagian: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, sisanya Meta. Tidak ada pengecualian.

- Kind adalah atribut Codec yang tidak berubah. Codec yang sekali ditetapkan tidak dipindahkan Kind-nya.
- Value dan Edge memiliki format “Codec + Payload” yang sama. Hanya Edge yang memiliki record lain sebagai komponen.
- Reference membagi penanda, penunjuk, sistem 5Q, dan REFERENCE-ISSUER dalam tabel kode. Kuantifikasi ada pada kode sistem. Kuantifikasi REFERENCE-ISSUER ditetapkan oleh dokumen Issuer ([Reference](reference/_index.md)).

## Length (4 bit) {#length-4비트}

Length adalah **jumlah total WORD** yang ditempati record. Mencakup TAG WORD, TAG ekstensi, Payload, dan padding WORD terakhir.

| Nilai | Arti |
|---|---|
| `0000`~`1101` | 1~14 WORD (nilai + 1) |
| `1110` | Panjang ekstensi 1: jumlah total WORD pada 1 WORD berikutnya (15~65.535) |
| `1111` | Panjang ekstensi 2: jumlah total WORD pada 2 WORD berikutnya (65.536~2³²−1) |

- 1~14 WORD harus ditulis dengan panjang langsung. Penulisan yang lebih lebar bukan bentuk kanonis.
- Jumlah total WORD panjang ekstensi juga mencakup TAG ekstensi Length itu sendiri.
- Tidak ada record yang melebihi 2³²−1 WORD.
- Record 1 WORD adalah satu TAG WORD tanpa Payload. Dipakai hanya jika spesifikasi Codec mengizinkan (contoh: Meta `BODY`, `END`, deret byte kosong, penanda slot).
- Meski tidak ada codebook, record dapat dilewati dengan `posisi record berikutnya = awal record saat ini + Length`.

## Codec (bagian dan C, 9 bit) {#codec-섹션과-c-9비트}

| TAG ID | Nama | Arti |
|---|---|---|
| Bagian depan tiap zona Kind | Kode langsung | Codec ditetapkan hanya oleh TAG WORD |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Issuer 2 WORD dan nomor Codec 2 WORD pada TAG ekstensi Codec |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Issuer 4 WORD dan nomor Codec 2 WORD pada TAG ekstensi Codec |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Issuer 16 WORD dan nomor Codec 2 WORD pada TAG ekstensi Codec |

- **Tiga slot terakhir tiap zona Kind adalah ISSUER.** Lebar Issuer adalah 2 bit bawah C (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta tidak memiliki format Issuer.
- `C` kode langsung ada terpisah untuk setiap bagian. Meski nilai `C` sama, jika bagiannya berbeda maka Codec berbeda. Codec ID kode langsung adalah seluruh TAG WORD (L=0) sehingga memuat Kind.
- Nomor Codec Issuer adalah satu ruang per Issuer terlepas dari Kind. Issuer menetapkannya agar tidak tumpang tindih di dalam `codecs/` miliknya ([alamat publikasi dan daftar versi](publishing.md#id-표기)).
- Codec yang bukan kode langsung adalah pasangan `(Issuer, nomor Codec)`. Nomor Codec didefinisikan oleh Issuer itu ([Issuer dan publikasi](issuer.md)). Format ekstensi ditaruh di bawah Issuer badan yang menetapkan format itu.
- Codec yang memiliki kode langsung tidak didaftarkan terpisah sebagai format Issuer.
- Format Issuer ada pada Reference, Value, dan Edge. Meta adalah spesifikasi umum yang hanya didefinisikan GEUL.
- Bagian kode langsung Edge (`w >> 9`) adalah keluarga. Kode langsung Value dan Meta tidak menyatakan keluarga·kelas dengan bit. Arti nomor Codec ditetapkan Issuer.
- Kode langsung tidak dapat ditarik kembali. Hanya format yang frekuensinya terkonfirmasi yang ditaruh sebagai kode langsung.

## Record format Issuer {#issuer-형식-레코드}

```
TAG WORD          kode ISSUER (tiga slot terakhir tiap zona Kind)
[TAG ekstensi Length]
Issuer            2/4/16 WORD (lebar ditetapkan Codec)
nomor Codec       2 WORD. Didefinisikan Issuer
Payload           ditetapkan dokumen Codec yang diterbitkan Issuer
```

- Layout ketiga Kind sama. Jika nomor tidak cukup, minta Issuer lain.
- Payload Edge (EDGE-ISSUER) dimulai dengan Edge Id seperti Edge lain. Karena itu urutannya TAG, Issuer, nomor Codec, Edge Id, sisa Payload.
- Decoder yang tidak mengenal format mengetahui hingga Issuer dan nomor Codec lalu melewatinya dengan Length.

## Deret byte panjang variabel {#가변-길이-바이트열}

Nilai yang panjangnya dalam satuan byte, seperti teks, URI, tag bahasa, dan deret byte opaque, menetapkan Codec (atau nomor Codec) sebagai **pasangan genap·ganjil**.

- Jika bit terendah Codec (pada kode langsung, bit terendah C) adalah `0`, jumlah byte genap, dan jika `1`, ganjil.
- Jumlah byte = `2 × jumlah WORD Payload − bit terendah`. Tidak ada field Byte Count.
- Jika ganjil, byte bawah WORD terakhir adalah padding `0x00`. Jika bukan `0x00`, ditolak.
- Deret byte kosong adalah record 1 WORD (hanya TAG WORD) dari Codec genap.
- Nilai berukuran tetap seperti UUID, digest, dan alamat tidak memiliki pasangan.

## Contoh: membaca TAG WORD {#예-tag-word-읽기}

Mari baca `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, bagian 0101(5, Edge), C 01010, Codec 0x0AAL(TRIPLE), Length 1001(10 WORD)
```

Record ini adalah Edge 10 WORD dan Codec-nya TRIPLE. Meski tidak ada codebook, diketahui bahwa record berikutnya ada setelah 10 WORD.

## Penanda slot {#자리-표지}

TAG WORD `0x0000`, `0x0010`, `0x0020` adalah record 1 WORD penanda slot Reference. Tidak menunjuk objek, melainkan mengisi posisi field record ([penanda slot](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, bagian 0(Reference), C 0~2, LLLL 0000(1 WORD)
```

| WORD | Nama | Arti | Pernyataan tentang apa | Logika | Asumsi dunia | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Tidak ditulis | Dokumen: posisi ini tidak diisi | Tanpa pernyataan | Dunia terbuka | tanpa snak |
| `0x0010` | UNKNOWN-VALUE | Tidak diketahui | Dunia: nilai ada. Tidak diketahui apa | `∃x. P(s, x)` | Keberadaan tertutup, identitas terbuka | `somevalue` |
| `0x0020` | NO-VALUE | Tidak ada | Dunia: nilai tidak ada | `¬∃x. P(s, x)` | Tertutup untuk (s, P, kondisi pembatas) | `novalue` |

- Contoh: jika anak (P40) adalah ABSENT, tidak diketahui berapa; jika UNKNOWN-VALUE, satu atau lebih; jika NO-VALUE, nol. Jika waktu berakhir (P582) adalah ABSENT, tidak diketahui apakah masih berlaku; jika UNKNOWN-VALUE, sudah berakhir tetapi tidak diketahui kapan; jika NO-VALUE, belum berakhir.
- Penanda hanya valid jika daftar CODEC field menaruh WORD itu secara tepat. Pada wildcard, field tanpa CODEC, posisi record HEAD·BODY, dan posisi Edge Id, invalid ([CODEC](edge/0x0BEL-codec.md)).
- Kewajiban pihak pembaca:
  1. UNKNOWN-VALUE bukan nilai melainkan pernyataan keberadaan. Tidak sama maupun berbeda dengan nilai apa pun, dan dua UNKNOWN-VALUE pun tidak dianggap nilai yang sama. TRIPLE yang memuat UNKNOWN-VALUE tidak digabungkan sebagai duplikat.
  2. NO-VALUE tertutup di dalam kondisi pembatas proposisi itu. Jika bersama TRIPLE nilai yang kondisi pembatasnya tidak dapat dibedakan pada Subject·Predicate·rank yang sama, itu kontradiksi, dan pemeriksa memberi peringatan (tidak menolak).
  3. rank berlaku sama. Saat memilih nilai representatif (truthy), TRIPLE dengan kedua penanda juga kandidat.
  4. Jika dipakai sebagai nilai QUALIFIER, mengubah arti pembatasan itu (`P582 = UNKNOWN`: sudah berakhir, waktu tidak diketahui. `P582 = NONE`: belum berakhir).
  5. ABSENT tidak menyatakan apa pun tentang dunia. Nilai yang tidak dapat dipindahkan tidak ditulis sebagai UNKNOWN-VALUE.

## Bentuk kanonis {#정규형}

Isi yang sama harus menjadi byte yang sama. Dengan begitu hash isi dan tanda tangan ditetapkan menjadi satu.

- Panjang memakai penulisan terpendek (1~14 WORD adalah panjang langsung).
- Bilangan bulat ditulis dengan lebar tersempit. Mengikuti bentuk kanonis yang ditetapkan spesifikasi setiap Codec.
- Record yang bukan bentuk kanonis ditolak.
- Pengecualian: `L=1111` pada WORD target [CODEC](edge/0x0BEL-codec.md) hanya melihat bagian `KKKK`, terlepas dari nilai `C`. Slot pertama bagian (`C = 0`) dianjurkan, dan `C` lain dalam bagian yang sama pun tidak ditolak.
