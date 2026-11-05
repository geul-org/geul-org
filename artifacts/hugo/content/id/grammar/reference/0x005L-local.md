---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL adalah Reference deklarasi yang menunjuk target dengan ID yang diterbitkan dokumen ini."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `LOCAL` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x005L~0x009L` |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 5~9 |
| Kind | Reference · klasifikasi: deklarasi |
| Sisi Hugo | `reference/local.md` |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

LOCAL adalah Reference deklarasi yang menunjuk target dengan ID yang diterbitkan dokumen ini. Ia merujuk target di dalam dokumen tanpa Issuer eksternal. Untuk menunjuk dari luar dokumen, taruh Meta [DOC-ID](../meta/0x1C7L-doc-id.md) pada dokumen, lalu dokumen lain menunjuknya dengan Reference penunjuk.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[TAG ekstensi Length]
LOCAL ID          unsigned big-endian dengan lebar terpendek
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Codec adalah `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal), `0x009L` (Variable). TAG WORD Identified adalah `0000 0000 0101 LLLL`.
- Berlaku aturan umum Reference untuk menulis ID target dengan jumlah WORD sesedikit mungkin.

## Edge Id {#edge-id}

- LOCAL yang menjadi elemen pertama Payload Edge adalah deklarasi Edge Id dari Edge itu ([Edge](../edge/_index.md)). LOCAL yang mendeklarasikan Edge Id hanya memakai Identified (`0x005L`).
- LOCAL di posisi lain pada Payload Edge adalah penyebutan. Target dokumen ini ditulis sebagai LOCAL setiap kali disebut. Tidak ada kode penunjuk tersendiri untuk menunjuk target dokumen ini.

## Penetapan pengenal {#식별자-할당}

- ID adalah bilangan bulat dan ditetapkan oleh encoder. Besar angka dan urutan penetapan tidak bermakna selain identitas.
- **UNIQUE (wajib).** Dalam satu dokumen, satu LOCAL ID hanya menunjuk satu target. Edge Id dideklarasikan hanya sekali per dokumen (Edge HEAD dan Edge BODY berbagi satu ruang nomor). Jika ada dua Edge atau lebih yang mendeklarasikan Edge Id yang sama, itu invalid.
- **AUTO INCREMENT (anjuran).** ID baru ditetapkan sebagai nilai maksimum ID yang telah ditetapkan di dokumen itu + 1, dan bertambah sesuai urutan dokumen. Sama halnya lintas versi (dibuat dengan nilai yang lebih besar daripada ID yang dihapus). Ini hanya anjuran dan bukan syarat validitas; dokumen yang tidak bertambah pun valid. Decoder tidak bergantung pada besar atau kesinambungan ID.
- ID `0` tidak ditetapkan. Ia tidak menunjuk target apa pun dan tidak dipakai sebagai Edge Id. ID target ditetapkan mulai dari `1`.
- Dokumen, baik dari dalam maupun dari luar dokumen itu, hanya ditunjuk dengan satu [DOC-POINTER](0x041L-doc-pointer.md) (dirinya sendiri dengan DOC-POINTER dari `DOC-ID`-nya sendiri). `BIND`·`LABEL`·Edge penilaian dapat dilekatkan pada dokumen.
- Issuer sendiri ditunjuk dengan [ISSUER-POINTER](0x040L-issuer-pointer.md). ID dokumen `0` adalah dokumen indeks definisi istilah Issuer.
- Pada Codec yang memberi makna pada `0` di posisi komponen ("tidak ada" pada REF·Edge eksekusi [TOULMIN](../toulmin/_index.md), "seluruh dokumen" pada Target [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) HEAD), berlaku aturan Codec itu. Ini adalah ketentuan di dalam Codec itu, berbeda dari [penanda slot](../slot-marker.md).
- ID yang sudah ditetapkan tidak dipakai ulang dalam dokumen yang sama.
- Selalu gunakan lebar minimum yang dapat menyatakan nilai.

## Identitas dan cakupan {#동일성과-범위}

- Dalam satu dokumen, LOCAL ID dengan nilai bilangan bulat yang sama adalah target yang sama. Lebar encoding bukan bagian dari identitas.
- LOCAL Identified menyatakan target yang teridentifikasi. Ia tidak dipakai untuk anonim·tak ditentukan·null·sentinel. Pernyataan bahwa nilai ada tetapi tidak diketahui (UNKNOWN-VALUE) atau nilai tidak ada (NO-VALUE) ditulis sebagai [penanda slot](../slot-marker.md) pada field yang menerima penanda itu.
- LOCAL ID yang berbeda hanyalah Reference yang berbeda, dan tidak berarti target di dunia nyata pun berbeda.
- Identitas LOCAL tidak diperluas ke luar dokumen. Angka yang sama di dokumen lain tidak berkaitan.
- LOCAL Variable (`0x009L`) adalah variabel wacana bernama ([Reference](_index.md) Variable).

## Penggabungan {#병합}

Saat menggabungkan beberapa dokumen menjadi satu, buat tabel padanan `old ID → new ID` untuk setiap dokumen asal, tetapkan ulang semua LOCAL ID menjadi ID dokumen baru, lalu ganti seluruh rujukan.

- ID yang sama pada dokumen asal yang sama harus tetap sama setelah penggabungan.
- Angka yang sama pada dokumen asal yang berbeda tidak berkaitan, dan tidak otomatis digabung sebagai Reference yang sama.
- Jika ada satu pun LOCAL yang tidak dapat diganti, penggabungan ditolak.

## Validitas {#유효성}

Encoding atau penetapan berikut ini invalid.

- Encoding non-minimal dengan WORD `0x0000` di depan (pengecualian: 1 WORD `0x0000` untuk nilai 0)
- Codec pada posisi deklarasi Edge Id bukan Identified (`0x005L`), atau ID-nya `0`
- Satu ID ditetapkan tumpang tindih pada target yang berbeda dalam satu dokumen
- Edge Id yang sama dideklarasikan dua kali atau lebih dalam satu dokumen

## Contoh {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000050/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

Di atas adalah dokumen codec `LOCAL-IDENTIFIED` (`0x005L`). Dokumen codec anggota lain (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
