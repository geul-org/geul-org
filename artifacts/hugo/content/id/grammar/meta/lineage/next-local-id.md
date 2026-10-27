---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID adalah Meta silsilah yang mencatat pada daftar versi LOCAL ID yang akan dialokasikan versi berikutnya dokumen kepada pernyataan baru (auto increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat LOCAL ID yang akan dialokasikan versi berikutnya dari dokumen itu kepada pernyataan baru (auto increment pada DBMS, `AUTO_INCREMENT` MySQL). Semua LOCAL ID yang pernah dialokasikan pada versi mana pun dari dokumen lebih kecil daripada nilai ini.

## Layout

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           LOCAL ID yang dialokasikan berikutnya, bilangan unsigned dengan lebar terpendek
```

- Codec: Meta `0x3C`, kelas silsilah (`011`)
- Payload: nilai mentah (bilangan unsigned dengan lebar terpendek)
- Jumlah: paling banyak satu
- Lokasi: HEAD dokumen daftar versi `versions.geul` ([PUBLICATION](/id/grammar/edge/publication/))

## Interpretasi dan validitas

- LOCAL ID (termasuk Edge Id) adalah identitas yang melampaui versi ([revisi](/id/grammar/document/#revisi)). Pernyataan baru menerima nilai ini, lalu nilai bertambah 1. LOCAL ID yang sudah dihapus tidak dipakai ulang. Karena itu, nilai ini tidak berkurang walaupun pernyataan yang memegang nilai maksimum dihapus.
- LOCAL ID `0` tidak dialokasikan, sehingga nilai awalnya `1`. Jika belum ada versi, Meta ini tidak ditaruh dan nomor berikutnya adalah `1`.
- Saat pihak penerbit menerbitkan versi, nilai ini diperbarui pada dokumen daftar yang baru. Nilainya harus lebih besar daripada LOCAL ID mana pun yang dipakai pada versi terbit. Jika lebih kecil atau sama, invalid.
- Nilai hanya bertambah. Jika lebih kecil daripada nilai pada dokumen daftar sebelumnya ([PARENT](/id/grammar/meta/lineage/parent/)), invalid.
- Tidak ada pada dokumen yang tidak mengelola versi (dokumen tanpa `versions.geul`, dokumen tanpa nama). Dokumen seperti itu juga tidak memakai diff ([DELTA-BASE](/id/grammar/meta/lineage/delta-base/)).
- Tidak ditaruh pada isi dokumen (dokumen versi). Mengingat nomor bukan isi dokumen, melainkan keadaan pihak penerbit yang melanjutkan dokumen (bukan commit git, melainkan sisi refs).

## Contoh

Nomor alokasi berikutnya 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
