---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen yang dipublikasikan Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DOC-POINTER` (BIND `DOC-POINTER` pada dokumen spesifikasi) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000410/` (target DECLARE `0410`) |
| Bagian | 2 `0010` (Reference lainnya), offset C dalam bagian = 1 |
| Kind | Reference · klasifikasi: penunjuk-deklarasi |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Sisi Hugo | `reference/doc-pointer.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | nilai mentah 4 WORD |  |  |
| 3 | `version` | #4 | nilai mentah 2 WORD |  |  |

DOC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen yang dipublikasikan Issuer. Ia menjadi target publikasi·deprecate·penghapusan dokumen, edisi yang dikutip, dan pernyataan tentang dokumen.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[TAG ekstensi Length]
Issuer            2/4/16 WORD
ID dokumen        4 WORD
ID versi          2 WORD
```

## Interpretasi dan validitas {#해석과-유효성}

- Lebar Issuer adalah sisa Payload setelah dikurangi 6 WORD untuk ID dokumen dan ID versi. Codec tidak membagi lebar. Jika lebar bukan 2, 4, 16 WORD, atau nilai Issuer muat dalam lebar yang lebih sempit, itu invalid (bentuk kanonik Issuer).
- ID versi tidak dihilangkan. Jika penghilangan diizinkan, lebar Issuer tidak dapat ditentukan hanya dari panjang Payload (Issuer 4 WORD tanpa versi dan Issuer 2 WORD dengan versi sama-sama 8 WORD).
- ID versi `0` adalah versi terbaru. Ia terikat pada versi berlaku saat diinterpretasikan. Nilai lainnya terkunci pada versi itu ([PUBLICATION](../edge/0x0B8L-publication.md)).
- ID dokumen `0` adalah dokumen indeks definisi istilah Issuer. Issuer itu sendiri ditunjuk dengan [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Setiap Issuer mencadangkan ID dokumen `0x0000000000000000` dan `0xFFFFFFFFFFFFFFFF` ([Issuer dan publikasi](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` dipakai untuk daftar Issuer `issuers/` milik Issuer `0x00000000`, dan Issuer lain tidak memakainya. PUBLICATION·DEPRECATION·TOMBSTONE pada `issuers/versions.geul` menunjuk versi daftar dengan nilai ini ([alamat publikasi dan daftar versi](../publishing.md#목록-문서)).
- Satu slot Codec `0x041L`. Tidak ada kuantifikasi (Identified).
- Bentuk untuk menunjuk dokumen Issuer hanya satu, yaitu DOC-POINTER. Menunjuk dokumen dengan `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, ID target `0`) atau `EXTERNAL-POINTER-*` (IMPORT ID, ID target `0`) adalah invalid.
- Tempat pemakaian: Meta [DOC-ID](../meta/0x1C7L-doc-id.md)·[IMPORT-DOC](../meta/0x1E4L-import-doc.md), PUBLICATION·DEPRECATION·TOMBSTONE pada daftar versi.
- Dokumen codec tidak memiliki ID dokumen. Dokumen codec dan versinya ditunjuk dengan [CODEC-POINTER](0x042L-codec-pointer.md).

## Contoh {#예시}

Dokumen `0xFFFF000000000001` milik Issuer GEUL `0x00000000`.

| Versi | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| Terbaru (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID dokumen 4 + ID versi 2 = 9 WORD, `LLLL=1000`. TAG adalah `0000 0100 0001 1000` = `0418`.

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer dan publikasi](../issuer.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000410/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
