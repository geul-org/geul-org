---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: relasi serangan. Penilaian penyerang mengurangi penilaian sasaran secara bertahap sebesar kekuatan serangan (0~1, bawaan 1).

| Butir | Nilai |
|---|---|
| Nama | `ATTACKS` (BIND dokumen spesifikasi `ATTACKS`) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001080/` (target DECLARE `1080`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 8 |
| Kind | Edge · keluarga: TOULMIN, kelompok: relasi, layout: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Relasi serangan. Penilaian penyerang mengurangi penilaian sasaran secara bertahap sebesar kekuatan serangan (0~1, bawaan 1) |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | aturan → aturan. Mengurangi penilaian secara bertahap sebesar kekuatan serangan |

- dst adalah REF sebuah node.
- F_FORCE (kekuatan serangan) hanya dipakai oleh Codec ini. Lihat [Kekuatan serangan](#공격-세기) di bawah.
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Kekuatan serangan {#공격-세기}

Kekuatan serangan (Force) menyatakan seberapa kuat satu Edge ATTACKS menyerang sasarannya. Rentangnya 0~1, dan jika F_FORCE tidak ada, nilainya 1.

- Dalam penilaian, kontribusi `(v+1)/2` dari nilai penilaian penyerang v dikalikan kekuatan F. Serangan sanggahan (COUNTER) masuk sebagai suku penyebut `F·(v+1)/2`, dan serangan pengecualian (EXCEPT) masuk sebagai gerbang `Π(1 − F·(v+1)/2)`. Jika F adalah 0, serangan tidak memengaruhi penilaian.
- Nilainya mengikuti aturan numerik [TOULMIN](_index.md#수치). Encoder menghapus nol di ujung koefisien (0.5 adalah `C=5, E=−1`, 1.0 adalah `C=1, E=0`). Decoder menerima hingga empat angka desimal.
- Bentuk permukaan yang tidak menulis kekuatan (`don't X when Y`, `` `Y` 면 `X` 는 무효다`` (jika Y, X tidak berlaku)) mematikan F_FORCE.
- Bentuk permukaan yang menulis kekuatan (`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (jika Y, X diserang dengan kekuatan 0.5)) menyalakan F_FORCE dan menyimpan nilainya. Menulis 1 seperti `1.0의 세기로` (dengan kekuatan 1.0) juga menyalakan F_FORCE dan menyimpan 1. Dengan demikian bentuk permukaan aslinya kembali apa adanya.
- Kekuatan serangan adalah sumbu yang berbeda dari kekokohan node (Strict, Defeasible, Defeater). Kekokohan melekat pada node, sedangkan kekuatan serangan melekat pada Edge ATTACKS.

### Contoh kekuatan serangan {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (jika Y, X diserang dengan kekuatan 0.5). Edge Id 5, penyerang Y adalah Edge Id 3, sasaran X adalah Edge Id 2, lebar SPAN 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), total 14 WORD
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, penyerang)
0051 0002             dst     LOCAL 2 (X, sasaran)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte awal 0x40, jumlah byte 0x1A
```

Edge yang sama tanpa penulisan kekuatan memiliki flags `0000` dan tidak memiliki field F_FORCE. TAG WORD-nya `1089` (total 10 WORD).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1080`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001080/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
