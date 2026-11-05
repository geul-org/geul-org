---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Mendeklarasikan pengenal dokumen ini."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DOC-ID` (BIND `DOC-ID` pada dokumen spesifikasi) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001C70/` (target DECLARE `1C70`) |
| Bagian | 14 `1110` (Meta), offset C dalam bagian = 7 |
| Kind | Meta · kelas: definisi |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pengenal dokumen ini. Reference bawaan `DOC-POINTER` (Issuer, ID dokumen, versi 0). Dokumen Codec memakai `CODEC-POINTER` (Issuer, Codec ID, versi 0) |
| Sisi Hugo | `meta/declaration/doc-id.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Bidang (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Mendeklarasikan pengenal dokumen ini. Diperlukan agar dokumen lain dapat menunjuk dokumen ini dan sasaran di dalamnya.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[TAG ekstensi Length]
dokumen           record Reference DOC-POINTER. (Issuer, ID dokumen, versi 0). Dokumen Codec: CODEC-POINTER
```

- Codec: Meta `0x1C7L`, kelas definisi
- Payload: satu Reference bawaan [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, ID dokumen, versi 0)
- Jumlah: paling banyak satu. Dokumen versi di bawah `docs/<ID dokumen>/` dan `codecs/<Codec ID>/` wajib memilikinya

## Interpretasi dan validitas {#해석과-유효성}

- Payload adalah tepat satu record Reference `DOC-POINTER` (Issuer, ID dokumen, versi `0`). ID versi hanya memakai `0`. Versi ditetapkan oleh daftar versi, bukan oleh dokumen. Dokumen Codec memakai `CODEC-POINTER` (Issuer, Codec ID, versi `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- Dengan demikian notasi yang menunjuk "dokumen ini" sama di DOC-ID, record PUBLICATION pada daftar versi, dan kutipan dari dokumen lain.
- Dokumen yang sama selalu memiliki `DOC-ID` yang sama, apa pun versinya. ID versi dan hash isi tidak dicatat dalam dokumen ([versi](../document.md#버전)).
- Tidak ada alamat nama dokumen ([alamat publikasi dan daftar versi](../publishing.md#문서-이름)). Judul yang dapat dibaca manusia menjadi tugas [LABEL](../edge/0x0A4L-label.md) pernyataan.
- Jika tidak ada, dokumen itu tidak bernama dan hanya dapat ditunjuk dengan hash isi. Diperlukan agar dokumen lain dapat menunjuk LOCAL dokumen ini dengan Reference deiktik.
- Pihak yang mengambil dokumen memverifikasi bahwa `DOC-ID` dokumen yang diterima sama dengan Issuer dan ID dokumen yang diminta.
- ID dokumen `0x0000000000000000` adalah dokumen indeks definisi istilah milik Issuer ([Issuer](../issuer.md)). Dokumen ini pun merupakan dokumen versi di bawah `docs/<ID dokumen>/`, sehingga memiliki DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). Issuer sendiri diwakili oleh [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Dokumen versi `<ID versi>.geul` (termasuk dokumen spesifikasi) di `<Issuer>/docs/<ID dokumen>/` dan `<Issuer>/codecs/<Codec ID>/` di bawah `.well-known/geul/` wajib memiliki `DOC-ID`.
- Dokumen daftar adalah pengecualian dan tidak memiliki `DOC-ID`: daftar versi `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) dan versi `<ID versi>.geul` dari daftar Issuer `issuers/` ([alamat publikasi dan daftar versi](../publishing.md#목록-문서)). DOC-POINTER pada record menyatakan daftar apa itu. Versi dokumen daftar ditunjuk oleh PUBLICATION pada `versions.geul`-nya dengan DOC-POINTER (`0x00000000`, ID dokumen yang dicadangkan, ID versi). Alamat hash isi `<Issuer>/hashes/` adalah salinan dokumen-dokumen di atas, sehingga mengikuti aslinya.
- ID dokumen `0xFFFFFFFFFFFFFFFF` dicadangkan di semua Issuer (`0x0000000000000000` juga sama) dan dipakai untuk daftar Issuer pada Issuer `0x00000000`. Issuer lain tidak memakainya. Karena dokumen daftar tidak memiliki `DOC-ID`, nilai ini hanya muncul pada DOC-POINTER di record `issuers/versions.geul`.
- Dokumen spesifikasi Codec adalah dokumen Codec milik Issuer GEUL `0x00000000`. Tidak memiliki ID dokumen, dan `DOC-ID`-nya memuat CODEC-POINTER (`0x00000000`, Codec ID, `0`). Codec ID adalah TAG WORD Kind·Codec yang ditulis dalam 32 bit (`0x0B80` menjadi `0x00000B80`) ([dokumen spesifikasi](../codec-spec.md)).

## Contoh {#예시}

- Issuer `0x00000002`, dokumen `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG Meta 1 + TAG Reference 1 + Issuer 2 + ID dokumen 4 + versi 2 = 10 WORD)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001C70/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
