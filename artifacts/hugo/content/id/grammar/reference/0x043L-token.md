---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN adalah Reference 2 WORD yang menunjuk satu entri kosakata token GEUL. Jika byte dari rekaman TOKEN yang berurutan disambung, hasilnya adalah teks aslinya."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Nama | `TOKEN-0` (BIND `TOKEN-0` pada dokumen spesifikasi) | `TOKEN-1` (BIND `TOKEN-1` pada dokumen spesifikasi) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000430/` (target DECLARE `0430`) | `0x00000000/codecs/0x00000440/` (target DECLARE `0440`) |
| Bagian | 2 `0010` (Reference lainnya), offset C dalam bagian = 3 | 2 `0010`, C = 4 |
| Kind | Reference · klasifikasi: deklarasi | Reference · klasifikasi: deklarasi |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| ID token | `0`~`65.535` | `65.536`~`131.071` |
| Sisi Hugo | `reference/token.md` | `reference/token.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | nilai mentah 1 WORD |  | Satu per token. Diisi saat kosakata edisi 1 dipublikasikan |

TOKEN adalah Reference yang menunjuk satu entri kosakata token GEUL. Kosakata ini adalah kosakata BPE (Byte Pair Encoding) yang dilatih dengan bahasa Korea dan Inggris, dan satu entri adalah satu deret byte. Jika deret byte dari rekaman TOKEN yang berurutan disambung menurut urutan, hasilnya adalah byte teks aslinya.

- Jika kosakata tidak lebih dari 65.536 entri, hanya TOKEN-0 yang dipakai. Jika lebih besar, entri yang melimpah ditaruh di TOKEN-1. Meskipun TOKEN-1 tidak dipakai, nama Codec pertama tetap TOKEN-0.
- Satu token ditulis sebagai satu rekaman. Karena ukurannya tetap 2 WORD, rekaman ke-k dari deret token berada 4k byte dari awal.

## Layout {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, total 2 WORD
Payload WORD 1st (16 bit)           ID token (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, total 2 WORD
Payload WORD 1st (16 bit)           ID token − 65.536 (uint16)
```

- Kode: kode langsung Reference `0x043L`·`0x044L` (bagian 2).
- Payload adalah ID target. Sesuai [layout umum Reference](_index.md), ini adalah bilangan bulat tak bertanda big-endian yang ditulis dengan lebar terpendek; karena ID target selalu `0`~`65.535`, Payload selalu 1 WORD (`0` adalah `0x0000`).
- Tidak ada kuantifikasi (kuantifikasi hanya dibaca dalam sistem 5Q).

## Interpretasi dan validitas {#해석과-유효성}

- ID target setiap Codec adalah nilai Payload. ID token dalam seluruh kosakata adalah ID target untuk TOKEN-0, dan 65.536 + ID target untuk TOKEN-1.
- Representasi resmi token adalah dokumen spesifikasi Codec-nya. Untuk setiap ID token ada satu [ENUM](../edge/0x0BDL-enum.md) pada FIELD `code`, dan nama yang diikat dengan [BIND](../edge/0x0A3L-bind.md) ke Edge Id ENUM itu adalah deret byte token. Nilai kode ENUM TOKEN-1 adalah nilai Payload (ID token − 65.536).
- Kosakata adalah daftar tertutup. ID token yang tidak punya ENUM di dokumen spesifikasi adalah invalid. Aturan Codec ini diutamakan di atas aturan umum ENUM (“kode yang tidak dideklarasikan bukan kesalahan”).
- **Token byte:** ID token `0`~`255` adalah satu byte. ID token adalah nilai byte itu sendiri. Untuk huruf yang tidak ada dalam kosakata, seperti aksara di luar bahasa Korea dan Inggris, byte UTF-8-nya ditulis sebagai token byte. Nama BIND token byte adalah nama mesin `<0x00>`~`<0xFF>`, dan maknanya ditetapkan oleh aturan ini.
- **Token lainnya:** Deret byte-nya adalah UTF-8 yang benar, dan nama BIND adalah deret byte itu apa adanya.
- **Dekode:** Baca deret rekaman TOKEN dari awal dan sambung deret byte setiap token. Huruf UTF-8 yang dibentuk oleh token byte yang berurutan juga dipulihkan oleh penyambungan ini. Hasilnya sama dengan teks sebelum dienkode sampai ke tingkat byte.
- **Enkode:** Cara membagi teks menjadi deret token (aturan pembagian dan urutan penggabungan) bergantung pada edisi kosakata. Teks yang sama dapat menghasilkan deret token yang berbeda bila edisi kosakatanya berbeda. Hasil dekode sama terlepas dari edisinya.
- **Edisi:** Edisi kosakata adalah versi dokumen spesifikasi. Setiap edisi mencatat hash berkas kosakata dan catatan pelatihan sebagai [SOURCE](../edge/0x0C0L-source.md) pada HEAD dokumen spesifikasi. Bila edisi yang membuat deret token perlu disebutkan, sertakan versinya ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, ID versi `n`)).
- **Hanya menambah:** Edisi baru hanya menambahkan ENUM dan BIND di belakang. Deret byte dari ID token yang sudah diberikan tidak diubah, tidak dihapus, dan tidak ditulis ulang. Karena itu setiap edisi adalah superset dari edisi sebelumnya, dan deret token yang dibuat dengan edisi lama didekode sama persis dengan edisi yang lebih baru. Jika kosakata dilatih ulang dari awal sehingga maknanya berubah, Codec ini tidak dipakai, melainkan diberikan nomor Codec baru.
- Karena token adalah Reference, ia dapat menjadi subjek [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md), dan [TRIPLE](../edge/0x0AAL-triple.md) (misalnya frekuensi kemunculan token, bahasa).

## Panjang {#길이}

- Totalnya tepat 2 WORD, yaitu TAG 1 WORD ditambah Payload 1 WORD, dan memakai panjang langsung `LLLL=0001`. Tidak ada Length extension TAG, Codec extension TAG, maupun TAG khusus Codec.
- Jika Payload tidak tepat 1 WORD, rekaman ditolak.

## Contoh {#예시}

Sebelum kosakata edisi 1 dipublikasikan, token umum belum memiliki nomor. Token byte nomornya sudah ditetapkan oleh aturan.

| Token | ID token | WORD lengkap |
|---|---|---|
| byte `0xE3` | `227` | `0431 00E3` |
| byte `0x80` | `128` | `0431 0080` |

## Masalah terbuka {#열린-문제}

- Publikasi kosakata edisi 1. Setelah pelatihan dan verifikasi selesai, ENUM dan BIND diisikan ke dokumen spesifikasi.
- Format untuk memuat deret token dalam dokumen. Belum ditentukan Edge atau field Value mana yang menerima deret rekaman TOKEN.
- Bentuk kanonik enkode. Bagaimana menulis aturan pembagian dan urutan penggabungan di dokumen spesifikasi, dan apakah deret token untuk teks yang sama ditetapkan menjadi satu.
- Interpretasi antar-edisi. Bila pembaca menemukan ID token yang lebih baru daripada edisi yang dimilikinya, apakah dibuang sebagai invalid, atau nilai aslinya disimpan dan diperlakukan sebagai “token tak dikenal”.

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Dokumen spesifikasi Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- Registry dengan bentuk yang sama: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Dokumen spesifikasi `0x00000000/codecs/0x00000430/` dipublikasikan bersama kosakata edisi 1. Belum dipublikasikan. Bentuknya sebagai berikut (untuk penjelasan).

```
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "code"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
…
```
