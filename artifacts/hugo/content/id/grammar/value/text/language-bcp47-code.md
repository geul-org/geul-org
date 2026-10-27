---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE adalah Value yang memuat language tag BCP 47 lengkap sebagai deretan byte ASCII. Memakai pasangan kode byte genap·ganjil 0x46/0x47."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE adalah Value yang memuat language tag BCP 47 lengkap. Dipakai untuk menulis bahasa dengan tepat sampai script, region, dan variant.

## Layout

- Kode: kode langsung Value `0x46` (byte genap)·`0x47` (byte ganjil). Keluarga TEXT.
- Jumlah byte ditetapkan oleh bit paling tidak signifikan Codec dan jumlah WORD Payload. Yaitu `2 × jumlah WORD Payload − bit paling tidak signifikan`, dan Byte Count tidak ditaruh ([Value](/id/grammar/value/)).
- Payload bukan teks UTF-8 melainkan deretan byte ASCII tag BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretasi dan validitas

- Deretan byte harus language tag BCP 47 well-formed menurut RFC 5646. String kosong tidak diizinkan.
- Payload hanya memakai huruf ASCII, angka, dan hyphen-minus `-`. Pemisah harus ASCII `-`, dan `_`, spasi, serta karakter non-ASCII tidak diizinkan.
- Perbandingan tag BCP 47 tidak membedakan huruf besar-kecil. Profil kanonik GEUL menulis semua pemisah dengan `-`, dan menserialisasi subtag language/extlang/variant/extension/private-use dengan huruf kecil, script dengan Titlecase, dan region dengan huruf besar.
- Well-formed saja tidak cukup. Validitas subtag terdaftar dan tag grandfathered dinilai dengan acuan snapshot IANA Language Subtag Registry tertentu, dan tanggal snapshot atau versi registri itu harus dipertahankan bersamanya.
- Tag private-use dan subtag private-use diizinkan jika well-formed menurut tata bahasa RFC 5646. Namun maknanya bergantung pada kesepakatan pihak-pihak dan tidak didefinisikan registri IANA sehingga interoperabilitas umum tidak dijamin.
- Jika pada snapshot yang sama subtag deprecated atau tag grandfathered memiliki Preferred-Value, bentuk GEUL kanonik menulis nilai pengganti itu dengan canonical casing. Tag dengan notasi deprecated apa adanya dapat diinterpretasikan sebagai input tetapi bukan bentuk simpan kanonik.
- BCP 47 adalah profil ASCII sehingga tuntutan normalisasi Unicode seperti UTF-8 NFC tidak berlaku.
- Dalam WORD, byte atas datang lebih dulu. Jika jumlah byte ganjil (kode ganjil), byte bawah WORD terakhir yang tidak dipakai harus `00`.
- Jumlah WORD Payload adalah `ceil(jumlah byte/2)`. Jika kodenya ganjil tetapi byte bawah WORD terakhir bukan `00`, ditolak.

## Dasar standar

- Tata bahasa language tag, interpretasi tanpa membedakan huruf besar-kecil, dan konsep deprecated/Preferred-Value mengikuti [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Registri yang menilai validitas tag adalah [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Pasangan kode genap·ganjil, zero padding, kebijakan penyimpanan canonical casing, dan perhitungan Length adalah aturan framing GEUL.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Length](/id/grammar/record/)).

## Hubungan dengan LANGUAGE-SHORT-CODE

- Untuk memuat hanya primary language subtag secara ringkas, pakai [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/).
- Jika diperlukan script, region, variant, extension, atau private-use, pakai LANGUAGE-BCP47-CODE.
- Juga dipakai LANGUAGE-BCP47-CODE untuk bahasa yang belum dialokasikan pada registri LANGUAGE-SHORT-CODE, kasus yang memerlukan escape `0xffff`, dan kasus yang memerlukan pelestarian teks asli full tag.

## Contoh

- `ko-KR` adalah 5 byte ASCII (ganjil) sehingga `LANGUAGE-BCP47-CODE-ODD` (`0x47`), Payload adalah `6b6f 2d4b 5200`.
- TAG 1 WORD, Payload 3 WORD sehingga total 4 WORD dan `LLLL=0011`. Seluruhnya adalah `09C7 6b6f 2d4b 5200`.
