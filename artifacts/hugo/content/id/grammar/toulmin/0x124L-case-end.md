---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END adalah record teks sumber dan pembagian dokumen TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END adalah record teks sumber dan pembagian dokumen TOULMIN. Arti: akhir lingkup kasus.

| Butir | Nilai |
|---|---|
| Nama | `CASE-END` (BIND dokumen spesifikasi `CASE-END`) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001240/` (target DECLARE `1240`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 4 |
| Kind | Edge · keluarga: format TOULMIN, layout: ID, REF (kasus) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Akhir lingkup kasus |
| Sisi Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Akhir sebuah lingkup kasus.

```
ID
kasus            REF (NODE CASE-DECLARE)
```

- Lingkup sebuah kasus (NODE [CASE-DECLARE](0x100L-case-declare.md)) berada di antara [CASE-BEGIN](0x123L-case-begin.md) dan CASE-END yang menunjuk kasus yang sama.

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](_index.md#공통-필드)). Payload mengikuti TAG tanpa kolom Issuer dan nomor Codec.

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1240`). Deklarasi field ditetapkan bersama dokumen spesifikasi Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [SOURCE dan pembagian](_index.md#source와-구획), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001240/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
