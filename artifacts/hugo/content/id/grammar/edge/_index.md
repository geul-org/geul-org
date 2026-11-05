---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge adalah record yang menyatakan sesuatu dengan menggabungkan record lain sebagai komponen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge adalah record yang menyatakan sesuatu dengan menggabungkan record lain sebagai komponen. Pernyataan seperti "Q42 adalah manusia" atau "Nama bahasa Inggris Q42 adalah Douglas Adams" masing-masing adalah satu Edge.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      bagian 5~13 (0x0A0L~0x1BFL)
[Length extension TAG]
[Codec extension TAG]  jika berbentuk Issuer
Edge Id           LOCAL Reference record
Komponen          urutan ditentukan Codec
```

- `LLLL` adalah jumlah seluruh WORD termasuk TAG WORD dikurangi 1. Decoder dapat melompat ke record berikutnya hanya dengan Length, tanpa mengetahui Codec.
- **Komponen pertama selalu Edge Id (LOCAL Reference).** Karena berupa LOCAL Reference (`0051` + ID, Identified `0x005L`), Edge Id dapat dibaca tanpa mengetahui codec.
- Setiap komponen menemukan batasnya dengan Length-nya sendiri. Posisi setelah komponen terakhir dibaca harus tepat sama dengan akhir Edge.
- Susunan komponen (Payload) ditentukan oleh dokumen Edge Codec masing-masing.
- Codec yang punya subbentuk (WORLD, TIMELINE, SCENE) menentukan subbentuk dengan 1 WORD TAG per Codec.
- Urutan antar-record Edge tidak bermakna (kecuali jika Codec menentukan lain. Contoh: dokumen [TOULMIN](../toulmin/_index.md)).
- Edge lain ditunjuk dengan Edge Id. Edge dalam dokumen ini ditunjuk sebagai LOCAL, Edge dalam dokumen lain ditunjuk dengan Reference penunjuk (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Keluarga {#계열}

Zona Edge adalah `0x0A0L~0x1BFL`. Keluarga kode langsung adalah `(kode − 0xA0) >> 5` (kode adalah tiga digit pertama TAG ID). Keluarga berukuran 32 slot dan sama dengan nilai bagian `w >> 9` dikurangi 5. Edge menempati bagian 5~13.

| Bagian | Keluarga | Kode langsung | Fungsi |
|---|---|---|---|
| 5 | pernyataan | `0x0A0L~0x0BFL` | menyusun isi tentang dunia dan peristiwa |
| 6 | dasar | `0x0C0L~0x0DFL` | dari mana record dan dokumen berasal ([SOURCE](0x0C0L-source.md)) |
| 7 | eksekusi | `0x0E0L~0x0FFL` | struktur program yang dapat dieksekusi (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | graf argumentasi: klaim, sanggahan, pengecualian, relasi serangan, eksekusi, hasil penilaian |
| 9 | bentuk [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | teks asli, segmen, node pendukung, dan relasi dokumen TOULMIN |

- Kode langsung yang sudah dialokasikan adalah kelima keluarga ini. `0x11CL~0x11FL` adalah Reserved, dan `0x135L~0x1BCL` adalah Reserved (bagian 10~12 seluruhnya Reserved).
- `0x1BDL~0x1BFL` (tiga slot terakhir bagian 13) adalah EDGE-ISSUER (Edge bentuk Issuer di bawah). Bentuk Issuer tidak punya aturan keluarga.

## Edge pernyataan {#서술-edge}

| Codec | Nama | Komponen |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | binding berarah: Subject (Reference) menunjuk Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | dua Reference menunjuk objek yang sama |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | dua Reference menunjuk objek yang berbeda |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | mengikat nama untuk mesin (UTF8-TEXT) pada Subject |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | nama Subject per bahasa (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | nama lain Subject. Layout sama dengan LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | deskripsi Subject per bahasa. Layout sama dengan LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | pernyataan verba |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | satu proposisi (Predicate, Subject, Object) dan rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | satu syarat yang membatasi proposisi Edge lain |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | pandangan dunia, urutan peristiwa, struktur adegan |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | publikasi, rekomendasi penghentian, dan penghapusan versi dokumen ([alamat publikasi dan daftar versi](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | kosakata untuk menulis spesifikasi Codec ([dokumen spesifikasi Codec](../codec-spec.md)) |

- `-SHORT` dan bentuk biasa dipasangkan sebagai genap·ganjil (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). LABEL menerima bahasa sebagai record bahasa di dalam Object (UTF8-LANGUAGE-TEXT), sehingga hanya memakai satu `0x0A4L`.
- PUBLICATION·DEPRECATION·TOMBSTONE dipakai oleh dokumen daftar versi. Karena daftar versi harus dapat dibaca tanpa codebook, ketiganya tertanam di decoder ([alamat publikasi dan daftar versi](../publishing.md#층), lapisan 0).
- DECLARE·FIELD·ENUM·CODEC adalah kosakata untuk menulis spesifikasi Codec. Karena dokumen spesifikasi harus dapat dibaca tanpa codebook, layout-nya tertanam di decoder (lapisan 0). Setiap dokumen spesifikasi Codec yang ditulis dengan kosakata itu adalah dokumen biasa.

### TRIPLE {#triple}

Selengkapnya: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (properti Wikidata, dan lain-lain)
Subject           Reference
Object            Reference atau Value
Rank              1 WORD
```

| Rank | Nama | Arti |
|---|---|---|
| `0` | normal | default |
| `1` | preferred | nilai saat ini, nilai paling otoritatif |
| `2` | deprecated | nilai yang dinilai salah atau usang tetapi tetap dicatat |

- Rank sama dengan statement rank Wikidata. Sumber yang tidak memberi rank memakai `0`.
- **Makna TRIPLE adalah gabungan semua QUALIFIER yang menunjuk Edge Id-nya.** Pembaca mengumpulkan QUALIFIER sebelum menafsirkan TRIPLE.

Contoh: Q42 — P31 (instance of) — Q5 (manusia), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Selengkapnya: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id dari Edge yang dibatasi)
Value             Reference atau Value
```

- QUALIFIER adalah bagian dari proposisi. Ia bukan klaim terpisah tentang proposisi, melainkan membatasi syarat agar proposisi benar (waktu mulai·berakhir, cakupan penerapan, dan lain-lain).
- Klaim terpisah tentang proposisi (misalnya siapa yang mengklaim) ditulis sebagai TRIPLE.
- Target adalah Edge dalam dokumen yang sama. Urutan QUALIFIER dengan Target yang sama adalah urutan dalam dokumen.

Contoh: Q42 — P69 (educated at) — Q691283, mulai (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Selengkapnya: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Nama dan bahasa dimuat dalam satu Object (UTF8-LANGUAGE-TEXT).
- LABEL untuk Subject dan bahasa yang sama paling banyak satu. Nama lain ditulis sebagai ALIAS.
- Nama untuk mesin tanpa bahasa ditulis sebagai BIND. LABEL harus punya bahasa.

### BIND {#bind}

Selengkapnya: [BIND](0x0A3L-bind.md)

- Mengikat nama yang dicocokkan mesin (UTF8-TEXT) pada Subject. Tidak punya bahasa dan tidak dinormalisasi. Nama sama hanya jika byte-nya sama.
- Cakupan nama adalah dokumen yang memuat BIND. Dalam satu dokumen, nama yang sama tidak diikat pada Subject yang berbeda.
- Record lain tidak menunjuk dengan nama, melainkan dengan LOCAL ID. Nama dipakai untuk mencocokkan dengan pihak luar (fungsi host, input alamat, manusia).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Selengkapnya: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE adalah identitas: dua Reference menunjuk objek yang sama. Bersifat refleksif, simetris, dan transitif.
- DIFFERENT-NODE adalah non-identitas: dua Reference adalah objek yang berbeda.
- REFERENCE-NODE adalah binding berarah yang mendefinisikan dengan Object apa Subject (Reference) itu. Bukan klaim identitas. Contoh: mendefinisikan URI yang ditunjuk node LOCAL.

## Edge dasar {#근거-edge}

Menempelkan dasar pada record individual di dalam BODY, atau pada seluruh dokumen (HEAD). Kode langsung keluarga dasar hanya satu, yaitu [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Nama | Komponen |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id Edge BODY yang diberi dasar, pada HEAD `0` = seluruh dokumen), Origin (Reference asal, ABSENT atau UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Sifat asal itu sendiri (URL, judul, penulis, tanggal terbit …) ditulis sebagai TRIPLE dengan asal sebagai Subject, dan sifat kutipan (tanggal akses, posisi dalam asal …) ditulis sebagai QUALIFIER dengan Edge Id SOURCE sebagai Target.
- Asal seluruh dokumen ditulis di HEAD sebagai SOURCE dengan Target `0`, dan QUALIFIER yang menjadikannya Target juga ditaruh di HEAD. Hanya kedua jenis ini yang boleh muncul di HEAD, dan Edge Id memakai satu ruang nomor yang sama untuk HEAD dan BODY ([asal-usul seluruh dokumen](0x0C0L-source.md#문서-전체의-출처)).
- Dasar lain (rentang teks asli, pembuat, tingkat kepercayaan, masa berlaku per pasal, record lama) ditulis sebagai QUALIFIER, dan versi tempat pertama kali masuk dihitung dari riwayat versi ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- Hasil penilaian per record ditangani oleh TOULMIN `VERDICT`.

### SOURCE {#source}

Selengkapnya: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id Edge BODY yang diberi dasar, pada HEAD 0 = seluruh dokumen)
Origin            Reference atau penanda slot 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Contoh: asal TRIPLE Q42 P19 `#178` adalah Britannica (Q5375741), dengan pengenal di dalamnya P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge eksekusi {#실행-edge}

Struktur program yang tidak terikat pada bahasa pemrograman tertentu. Komponen ditunjuk dengan LOCAL ID dokumen ini.

| Kelompok | Codec |
|---|---|
| deklarasi | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| ekspresi | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| pernyataan (statement) | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| galat | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- Ini bukan bentuk yang memuat kode bahasa luar apa adanya. Kode bahasa luar ditempatkan dalam bentuk Issuer.
- Komponen ditunjuk dengan LOCAL ID dokumen ini (REF). Pada posisi ekspresi ditaruh Edge ekspresi atau simbol. REF `0` berarti tidak ada.
- Ekspresi menghasilkan nilai, statement tidak. Ekspresi boleh ditaruh pada posisi statement BLOCK (nilainya dibuang).
- `for` gaya C ditulis sebagai BLOCK (inisialisasi, WHILE), dan `else if` sebagai IF pada posisi salah.
- Simbol adalah LOCAL ID, dan namanya diikat dengan BIND. Record lain menunjuk simbol dengan LOCAL ID, bukan nama. Meski namanya sama, jika LOCAL ID berbeda maka simbolnya berbeda.
- Apa simbol itu (variabel, parameter, fungsi, tipe) ditentukan oleh record yang menunjuknya. Simbol yang tidak punya definisi dalam dokumen disediakan oleh pihak luar (host), dan jika menjadi target CALL maka itu fungsi host.

Masalah terbuka: kode operator, representasi tipe, layout Payload setiap Codec.

## Edge TOULMIN {#toulmin-edge}

Menulis graf penilaian·eksekusi dengan model argumentasi Toulmin. Kode langsung `0x100L~0x11BL`, record pendukung adalah keluarga bentuk TOULMIN `0x120L~0x134L`. Selengkapnya: [TOULMIN](../toulmin/_index.md)

## Edge bentuk Issuer {#issuer-형식-edge}

Issuer dapat mendefinisikan dan memakai bentuk Edge-nya sendiri ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)·[4WORD](0x1BEL-edge-issuer-4word.md)·[16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). Ini adalah tiga slot terakhir zona Edge. Codec extension TAG memuat Issuer dan nomor Codec sebanyak 2 WORD. Edge Id adalah elemen pertama Payload setelahnya (TAG, Issuer, nomor Codec, Edge Id, sisa Payload). Nomor Codec ditentukan Issuer dan tidak punya aturan keluarga. Apa pun Kind-nya, nomor itu tidak boleh bertabrakan di dalam `codecs/` Issuer tersebut. Dokumen codec ditaruh di bawah `codecs/` Issuer itu dengan nomor Codec record ([alamat publikasi dan daftar versi](../publishing.md)).

- Saat ini tidak ada bentuk ISSUER Edge yang terdaftar.
