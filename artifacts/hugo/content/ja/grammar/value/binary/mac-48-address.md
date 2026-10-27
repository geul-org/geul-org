---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS は、48bit の IEEE 802 MAC アドレスを octet 順のまま収める、固定 6 WORD の IEEE Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS は、48-bit の IEEE 802 MAC アドレスの値を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0040` IEEE、形式番号 `0xC000`、系列 BINARY だ。Payload はちょうど 3 WORD(6 octet、48bit)だ。

## レイアウト

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  全体 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
形式番号          1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## 解釈と有効性

- 48-bit MAC アドレスの六つの octet を、表記文字列と LAN 伝送の octet 順のまま置く。octet 0–1、2–3、4–5 を、それぞれ WORD の上位 octet から下位 octet の順に束ねる。
- IEEE 802 媒体では各 octet の least-significant bit が先に伝送されるが、これを理由に octet 内の bit を反転しない。I/G と U/L は、octet 0 の least-significant bit とその次の bit にそのまま残る。
- I/G=0 は individual アドレスで、destination では unicast として、I/G=1 は group アドレスで、multicast や broadcast として使われる。U/L=0 は universally administered、U/L=1 は locally administered アドレスだ。
- I/G や U/L の値のために構造的に排除する pattern はない。universally/locally administered、individual/group のアドレスをすべて表現し、locally administered・randomized・spoofed・virtual MAC アドレスも 48bit の値として表現できる。
- この値は、観測または提示されたアドレスの 48bit だけを保存する。特定の機器の恒久アドレス、世界的な一意性、機器・ユーザーの認証、所有権、同じ機器との持続的な結合を保証しない。
- この形式は、ちょうど 48bit の IEEE 802 MAC アドレスだけを扱う。EUI-64 や他の 64-bit MAC アドレスは収めない。IEEE RA は歴史的な用語 `MAC-48` を obsolete と説明するが、すべての 48-bit MAC アドレスを EUI-48 と呼べるわけではないので、この形式を EUI-48 と自動的に同一視しない。
- Payload がちょうど 3 WORD でなければ拒否する。

## 標準の根拠

- IEEE Registration Authority の [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) は、48-bit LAN MAC アドレスを伝送順の六つの octet で表記し、各 octet が least-significant bit から伝送され、I/G と U/L が最初の octet の下位 2 bit であることを説明する。この形式は、octet と bit の位置をそのまま保存する。
- IEEE Registration Authority の [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) は、I/G=0/1 を individual/group、U/L=0/1 を universal/local administration と定義し、local アドレスが世界的に一意でないことを説明する。`MAC-48` と EUI-48 の歴史的な用語関係と違いも説明する。
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) は、EUI-48・EUI-64 が MAC アドレスなどとして使われうることを説明する。これは EUI-64 をこの 48-bit レコードに入れるという意味ではない。
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) と [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) は、実際のデバイスが locally administered MAC アドレスをランダムに作り、変更しうることを記録している。そのため MAC の値だけから恒久的な機器 identity を推論しない。
- GEUL TAG、Issuer 割り当て、直接 Length、16bit WORD framing は、IEEE 802 や上の資料の一部ではなく、この形式が加える規則だ。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 3 WORD を合わせたちょうど 6 WORD で、直接長さ `LLLL=0101` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 3 WORD でなければ拒否する。

## 例

locally administered individual(unicast)アドレス `02:00:5e:10:00:00`(最初の octet `0x02` の I/G=0、U/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
