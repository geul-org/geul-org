---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE adalah layout yang menulis node graf TOULMIN (kasus, aturan, definisi, titik masuk, trigger, fungsi, field, alias, kelompok). Flag pada header 1 WORD menetapkan field bersyarat yang mengikutinya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE adalah layout yang menulis node graf putusan·eksekusi TOULMIN. Jenis node ditetapkan oleh Codec (atau nomor format ISSUER GEUL), dan header 1 WORD menetapkan peran·Level·bentuk Claim serta field bersyarat.

## Codec

| Codec | Nama | TANGEUL | Node |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | Kasus |
| `0x62` | SPEC-DECLARE | Butir Definitions (`means`, `has`) | Kriteria penilaian (Backing). role adalah jenis definisi |
| `0x63` | RULE-DECLARE | general rule | Klaim (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | Sanggahan (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | Pengecualian (Defeater) |
| `0x75` | ENTRY | `provides x` | Titik masuk eksternal |
| `0x76` | TRIGGER | `on`, `every`, `until` | Titik masuk peristiwa·periodik |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | Namespace dokumen |
| ISSUER `0x0000`/`0xC011` | FUNC | referensi fungsi | Fungsi luar (contoh: `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | Field wajib |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | Alias paket yang diimpor |
| ISSUER `0x0000`/`0xC014` | GROUP | daftar berurutan `1.` | Kelompok eksekusi berurutan |

Format ISSUER menaruh Issuer `0x0000` dan nomor format pada Codec extension TAG setelah `ISSUER-1WORD` (`0x7C`) ([TOULMIN](/id/grammar/edge/toulmin/)).

## Layout

```
ID               record LOCAL Reference (Edge Id)
Header 1 WORD    role 2b | cadangan 2b | F_GROUNDS 1b | level 2b | jenis object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 jika tidak ada) + VerbCode 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF(kasus)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Nilai awal putusan
[F_WITH]         jumlah (Value UNSIGNED-INTEGER) + REF(TEXT) × jumlah
[F_GROUNDS]      jumlah (Value UNSIGNED-INTEGER) + REF(TEXT) × jumlah
SPAN             lebar yang ditetapkan SOURCE × 2 (byte awal, jumlah byte)
```

### WORD header

| Bit | Field | Nilai |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | cadangan | 0 |
| 11 | F_GROUNDS | Ada daftar dasar |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 cadangan) |
| 8–7 | jenis object | Bentuk object Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | Tabel di bawah |

| Bit | flag | Arti |
|---|---|---|
| b0 | F_FUNC | Ada field FuncRef |
| b1 | F_QUAL | Ada field Qualifier |
| b2 | F_CHECK | Ada field kasus target `checking` |
| b3 | F_CLAIM | Ada field Claim |
| b4 | F_VERDICT | Ada field nilai awal putusan |
| b5 | F_STRIKE | Deklarasi yang dicoret. Tidak ada field |
| b6 | F_WITH | Ada field daftar kriteria |

- Field bersyarat ditaruh menurut urutan flag (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Field yang flag-nya mati tidak menempati ruang.
- Jika flag menyala tetapi field tidak ada, ditolak. Posisi setelah membaca field secara berurutan harus tepat sama dengan akhir record setelah SPAN.

## Field

| Field | Penjelasan |
|---|---|
| FuncRef | Posisi fungsi. REF adalah record ALIAS yang mengimpor fungsi itu, dan `0` jika fungsi dokumen ini. VerbCode adalah kode 1 WORD dan belum dialokasikan (`0x0000` diizinkan). Penulisan asli fungsi ditulis terpisah dengan TEXT + [LABEL](/id/grammar/edge/toulmin/link/) |
| Qualifier | Tingkat keyakinan node (0~1) |
| Kasus | F_CHECK: kasus yang hanya diputuskan node ini (`checking c`) |
| Claim | Proposisi yang dimuat node. REF subject, predicate 1 WORD, object, mode 1 WORD. Bentuk object ditetapkan oleh jenis object pada header |
| Nilai putusan | Nilai awal putusan (−1~1) |
| F_WITH | Kriteria penilaian pada saat deklarasi (`기준으로 하는`, "basis"). Daftar REF record TEXT |
| F_GROUNDS | Nama fakta eksternal yang diinterpretasikan pada saat evaluasi (`근거로 하는`, "berdasarkan"). Daftar REF record TEXT |
| SPAN | Rentang teks asli tempat deklarasi ini muncul |

- Penulisan nilai putusan·Qualifier mengikuti aturan numerik [TOULMIN](/id/grammar/edge/toulmin/#numerik).
- Jumlah pada daftar adalah record Value [UNSIGNED-INTEGER](/id/grammar/value/numeric/unsigned-integer/) tersemat.
- Bentuk dasar Claim pernyataan adalah subject·predicate `0` dan object SPAN (jenis object 2). Dikunci pada penulisan teks asli.

## Interpretasi dan validitas

- role pada RULE·COUNTER·EXCEPT-DECLARE harus sama dengan Codec (0 general, 1 counter, 2 except). Pada SPEC-DECLARE, itu adalah jenis definisi. Pada Codec lain adalah 0.
- Jika level 0 (Unset), dipakai nilai default mesin: COUNTER-DECLARE adalah Fail, EXCEPT-DECLARE adalah Review.
- Aturan fungsi host `tangl:규칙` ("aturan") TANGEUL (`쓰는 규칙이다`, "aturan yang dipakai") ditulis sebagai NODE RULE-DECLARE di luar kasus. Fungsi adalah F_FUNC, kriteria adalah F_WITH, dan dasar adalah F_GROUNDS. Hanya aturan ekspresi kondisi yang menaruh [PREDICATE-DECLARE](/id/grammar/edge/toulmin/expr/) di depannya.
- Bit cadangan (13–12) harus 0. Jika bit cadangan menyala atau role tidak sesuai dengan Codec, ditolak.

## Halaman terkait

- [TOULMIN](/id/grammar/edge/toulmin/), [LINK](/id/grammar/edge/toulmin/link/), [EXPR](/id/grammar/edge/toulmin/expr/), [SOURCE dan bagian](/id/grammar/edge/toulmin/source/)
- [LOCAL](/id/grammar/reference/local/), [SIGNED-DECIMAL](/id/grammar/value/decimal/signed-decimal/)
