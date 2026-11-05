---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX adalah Reference deklarasi yang menunjuk target dengan GEUL SIDX (Semantic-aligned Index)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `GEUL-SIDX` (kelompok 5Q. Nama per kode ada pada tabel anggota di bawah) |
| TAG ID | `0x00FL~0x013L` |
| Bagian | 0 `0000` (entitas Reference), offset C dalam bagian = 15~19 |
| Kind | Reference · klasifikasi: deklarasi |
| Sisi Hugo | `reference/geul-sidx.md` |

## Anggota {#구성원}

Halaman ini membahas satu set sistem 5Q, yaitu lima kode sekaligus. Kuantifikasi adalah offset dalam bagian `C % 5` ([Reference](_index.md#quantifier)). Dokumen codec ada satu per kode. Field kelima dokumen codec itu sama, hanya target DECLARE dan nama (BIND) yang berbeda.

| TAG ID | Nama | Kuantifikasi | Codec ID | Dokumen spesifikasi | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([Dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

GEUL-SIDX adalah Reference deklarasi yang menunjuk target dengan GEUL SIDX (Semantic-aligned Index). SIDX adalah pengenal yang memuat makna (jenis, properti) pada bit itu sendiri.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[TAG ekstensi Length]
SIDX              seluruh sisanya
```

- Quantifier sama dengan Codec deklarasi lainnya. Jika Variable, ia adalah variabel anonim dari jenis itu ([Reference](_index.md) Variable). Kuantifikasi hanya dilakukan dengan kode 5Q (`0x00FL~0x013L`, `C % 5`). Kuantifikasi tidak dimasukkan ke dalam nilai SIDX.
- Dokumen spesifikasi mendeklarasikan SIDX sebagai satu field nilai mentah selebar sisa. Akan diubah setelah aturan lebar ditetapkan.

## Contoh {#예시}

| SIDX | WORD sequence |
|---|---|
| (nonnormatif) 64 bit `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Kebijakan penetapan {#배정-방침}

- Perannya berbeda dari [GEUL](0x00AL-geul.md). GEUL adalah ID identitas yang pada umumnya ditetapkan berurutan (auto increment), sedangkan GEUL-SIDX adalah alamat makna yang memberi nilai berdekatan kepada target yang maknanya berdekatan.
- Tingkat kedekatan ditentukan lewat statistik dari data pemakaian yang terkumpul. Sebelum statistik terkumpul, gunakan GEUL ID; setelah SIDX ditetapkan, sambungkan GEUL dan GEUL-SIDX dari target yang sama dengan [SAME-NODE](../edge/0x0A1L-same-node.md).

## Masalah terbuka {#열린-문제}

- **Lebar.** Ditentukan setelah melihat statistik. 4 WORD (64 bit) dan 16 WORD sedang dikaji. SIDX memuat makna pada bit atas, sehingga aturan "lebar terpendek" (larangan `0x0000` di depan) pada Codec deklarasi lain tidak dapat dipakai begitu saja. Karena itu ia akan menjadi lebar tetap (atau lebar tetap per subformat). Sampai ditetapkan, dokumen spesifikasi mendeklarasikan SIDX sebagai nilai mentah selebar sisa.
- **Kestabilan penetapan.** Reference dengan nilai bilangan bulat yang sama adalah target yang sama, dan ID yang telah ditetapkan tidak dipakai ulang. Agar SIDX yang sudah ditetapkan tidak dipindahkan meskipun statistik berubah, diperlukan penetapan append-only (penetapan jarang yang menyisakan ruang di dekat makna yang berdekatan). Jika pemindahan sering terjadi, tentukan apakah SIDX didefinisikan bukan sebagai pengenal permanen melainkan indeks yang terikat pada edisi registri.
- **Keunikan.** Jika SIDX dibangkitkan dari makna bit sehingga dapat bertabrakan, hal itu tidak sesuai dengan premis "nilai bilangan bulat yang sama adalah target yang sama". Tabrakan diselesaikan saat penetapan untuk menjamin keunikan.
- Codebook dan format publikasi registri.

## Halaman terkait {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000000F0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

Di atas adalah dokumen codec `GEUL-SIDX-IDENTIFIED` (`0x00FL`). Dokumen codec anggota lain (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) hanya berbeda pada Codec ID di DOC-ID, target DECLARE, dan nama yang diikat (BIND) pada `#1`.
