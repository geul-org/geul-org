---
title: "Format Aliran"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "Aliran GEUL adalah sekuens paket yang dimulai dan diakhiri dengan Meta Node. Mendefinisikan scoping TID, referensi maju, dan aturan urutan paket."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Aliran GEUL adalah **sekuens paket yang dimulai dan diakhiri dengan Meta Node**, merepresentasikan satu dokumen GEUL yang lengkap.

## Fitur Utama

- **Batas eksplisit:** STREAM_START / STREAM_END (Meta Node)
- **Scope TID:** Hanya berlaku dalam aliran
- **Referensi maju:** Hanya TID yang sudah dideklarasikan yang bisa dirujuk
- **Big Endian:** Network Byte Order

## Struktur Aliran

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← wajib (Meta Node)
│          (deklarasi lebar TID)       │     0xC000 (TID 16-bit)
├─────────────────────────────────────┤
│          Metadata (opsional)        │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Paket isi                   │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← opsional (direkomendasikan)
└─────────────────────────────────────┘
```

Aliran minimal: `STREAM_START`(1 word) + `STREAM_END`(1 word) = 2 word (4 byte); aliran kosong juga valid.

## Prinsip Penetapan TID

| Aturan | Deskripsi |
|--------|-----------|
| **Wajib** | Setiap Edge/Node dalam aliran memiliki TID |
| **Unik** | TID unik dalam aliran |
| **Scope** | TID hanya berlaku dalam aliran tersebut |
| **Referensi maju** | Hanya TID yang sudah dideklarasikan yang bisa dirujuk |

### Posisi TID

| Tipe | Posisi TID | Posisi referensi |
|------|------------|------------------|
| **Meta Node** | Tidak ada | Tidak ada |
| **Entity Node** | Word terakhir | Tidak ada |
| **Quantity Node** | Word terakhir | Tidak ada |
| **Tiny Verb Edge** | Tidak ada | Tidak ada (inline) |
| **Verb Edge** | Area header | Setelah payload |
| **Triple Edge** | Area header | Setelah payload |
| **Event6 Edge** | Area header | Setelah payload |
| **Clause Edge** | Area header | Setelah payload |
| **Context Edge** | Area header | Setelah payload |
| **Group Edge** | Word ke-2 | Word ke-3+ |

**Node** hanya mendefinisikan diri sendiri sehingga TID di akhir; **Edge** merujuk TID lain sehingga TID ditempatkan sebelum referensi.

### TID Cadangan

| TID | Kegunaan |
|-----|----------|
| 0x0000 | **Marker terminasi** ([Group Edge](../group-edge/) dll.) |
| 0xFFFF | Cadangan (standar 16-bit) |

## Aturan Urutan Paket

### Urutan Deklarasi-Referensi

```
Benar:
  [Entity: Budi, TID=0x0001]
  [Entity: Sari, TID=0x0002]
  [Verb Edge: bertemu, Subject=0x0001, Object=0x0002]

Salah:
  [Verb Edge: bertemu, Subject=0x0001, Object=0x0002]  ← 0x0001 belum dideklarasikan
  [Entity: Budi, TID=0x0001]
  [Entity: Sari, TID=0x0002]
```

### Urutan yang Direkomendasikan

```
1. STREAM_START
2. Metadata (VERSION, CREATED_AT, CREATOR)
3. Entity Node (deklarasi entitas)
4. Quantity Node (bilangan/literal)
5. Group Edge (definisi grup)
6. Tiny Verb Edge (predikat inline)
7. Verb Edge (predikat umum)
8. Triple Edge (properti/relasi)
9. Event6 Edge (peristiwa)
10. Clause Edge (relasi diskursif)
11. Context Edge (konteks)
12. Faber Edge (kode/AST)
13. STREAM_END
```

Ini urutan yang direkomendasikan; penempatan bebas selama aturan deklarasi-referensi dipenuhi.

### Larangan Referensi Siklis

Referensi siklis bentuk A → B → A tidak dimungkinkan. Jika relasi siklis diperlukan, gunakan Edge terpisah.

```
Diizinkan:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Contoh Aliran

### "Budi bertemu Sari"

```
1. STREAM_START (TID 16 bit)
   0xC0 0x00

2. Entity: Budi (TID=0x0001)
   [Entity paket...] 0x00 0x01

3. Entity: Sari (TID=0x0002)
   [Entity paket...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "Budi dan Sari bertemu di sekolah"

```
1. STREAM_START
   0xC0 0x00

2. Entity: Budi (TID=0x0001)
3. Entity: Sari (TID=0x0002)
4. Entity: sekolah (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Anggota: 0x0001, 0x0002, 0x0000 (terminasi)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (grup)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Validasi Aliran

### Validasi Wajib

| Item | Pemeriksaan |
|------|-------------|
| Awal | Dimulai dengan STREAM_START? |
| Keunikan TID | Tidak ada TID duplikat? |
| Validitas referensi | Semua TID yang dirujuk sudah dideklarasikan? |
| Referensi maju | Pada saat referensi, TID sudah dideklarasikan? |

### Kode Validasi

```python
def validate_stream(packets: list) -> dict:
    """Validasi aliran"""
    errors = []
    declared_tids = set()

    # Pemeriksaan awal
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Aliran tidak dimulai dengan STREAM_START")

    for packet in packets:
        # Pemeriksaan keunikan TID
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"TID duplikat: {packet.tid}")
            declared_tids.add(packet.tid)

        # Pemeriksaan validitas referensi
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Referensi ke TID belum dideklarasikan: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Aliran Multipel

Setiap aliran independen, dan scope TID dipisahkan per aliran. TID=0x0001 Aliran A dan TID=0x0001 Aliran B adalah entitas berbeda.

Referensi silang (Cross-reference) antar aliran saat ini belum didukung. Di masa depan, dapat diperluas melalui pengenalan Stream ID dan mekanisme Import/Export.
