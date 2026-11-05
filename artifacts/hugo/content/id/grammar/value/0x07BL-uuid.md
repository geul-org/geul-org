---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID adalah Value berlebar tetap yang memuat nilai 128 bit UUID RFC 9562."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `UUID` (dokumen spesifikasi BIND `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000007B0/` (sasaran DECLARE `07B0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 27 |
| Kind | Value · keluarga: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | UUID RFC 9562 128 bit dengan Payload tetap 8 WORD |
| Sisi Hugo | `value/binary/uuid.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | nilai mentah 8 WORD |  |  |

UUID adalah Value berlebar tetap yang memuat nilai 128 bit UUID RFC 9562. Kode langsung Value `0x07BL`, keluarga BINARY. Payload tepat 8 WORD (16 octet, 128 bit).

## Layout {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  total 9 WORD
Payload           8 WORD (128 bit)  UUID octet 0 → octet 15
```

## Interpretasi dan validitas {#해석과-유효성}

- Octet canonical UUID RFC 9562 dari octet 0 sampai octet 15 dikelompokkan berurutan dua octet demi dua octet. Octet yang datang lebih dulu adalah 8 bit atas WORD. Field, version bit, dan variant bit UUID tidak disusun ulang atau di-encode ulang.
- String hex-and-dash `8-4-4-4-12` hanyalah representasi masukan·keluaran. Huruf besar-kecil dan dash tidak masuk ke Payload, dan hanya 16 octet hasil parsing yang disimpan.
- Value UUID ini mempertahankan pola 128 bit tanpa kehilangan. Pada variant RFC 9562 `10xx`, version 1, 3, 4, 5, 6, 7 adalah layout standar dan version 8 adalah format UUID kustom. Version 2 dicadangkan untuk DCE Security sehingga RFC tidak menetapkan layout-nya, version 0 adalah unused, dan version 9–15 dicadangkan untuk definisi masa depan. Variant lain juga dicadangkan untuk kompatibilitas atau definisi masa depan.
- Nil UUID adalah nilai khusus 128 bit semuanya nol, dan Max UUID adalah 128 bit semuanya satu. Pola 128 bit yang memuat version/variant yang dicadangkan·unused juga tidak dikecualikan secara struktural, dan makna serta interoperabilitas pola itu dinilai dari standar yang berlaku dan konteks eksternal.
- Identitas UUID ditentukan dari apakah nilai 128 bit pada Payload sama. Fakta bahwa nilainya sama tidak menjamin autentikasi, kepemilikan, keberadaan saat ini, kemampuan resolusi, maupun hak akses objeknya.
- Saat menyimpan GUID COM Microsoft, representasi memori·serialisasi mixed-endian tidak disalin apa adanya. Ubah dulu menjadi 16 octet dengan urutan field/octet canonical RFC 9562.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Dasar standar {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) mendefinisikan UUID sebagai 16 octet (128 bit), dan meng-encode field most-significant-byte-first sehingga pada format biner field disambung dalam urutan big-endian. Variant ada pada bit atas octet 8 dan version pada 4 bit atas octet 6, dan format ini mempertahankan posisi itu apa adanya.
- RFC 9562 Sections 4.1–5.10 membedakan variant, version 1–8, Nil, Max, dan rentang yang dicadangkan. RFC 9562 menggantikan RFC 4122 sehingga norma yang berlaku untuk format ini adalah RFC 9562.
- ABNF hex-and-dash RFC 9562 adalah representasi teks, dan caveat little-endian GUID COM juga disebutkan terpisah. GEUL hanya memasukkan 16 octet canonical UUID RFC ke Payload.
- TAG GEUL, Length langsung, dan framing WORD 16 bit bukan bagian RFC 9562, melainkan aturan yang ditambahkan format ini.

## Panjang {#길이}

- Total adalah tepat 9 WORD, yaitu TAG 1 WORD ditambah Payload 8 WORD, dan memakai panjang langsung `LLLL=1000`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh {#예시}

Test vector UUIDv7 `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` dari RFC 9562 Appendix A.6:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000007B0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
