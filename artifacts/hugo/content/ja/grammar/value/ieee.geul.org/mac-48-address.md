---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESSは、48-bit の IEEE 802 MAC アドレスの値を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESSは、48-bit の IEEE 802 MAC アドレスの値を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x0000000D` IEEE、Codec 番号 `0x0000C000`、系列 BINARY である。Payload は正確に3 WORD(6 octet、48bit)である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  全体 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 番号        2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## 解釈と有効性 {#해석과-유효성}

- 48-bit MAC アドレスの6つの octet を、表記文字列および LAN 伝送での octet 順のまま置く。octet 0–1、2–3、4–5 を、それぞれ WORD の上位 octet から下位 octet の順に組にする。
- IEEE 802 媒体では各 octet の least-significant bit が先に伝送されるが、これを理由に octet 内の bit を反転しない。I/G と U/L は octet 0 の least-significant bit とその次の bit にそのまま残る。
- I/G=0 は individual アドレスで、destination では unicast として、I/G=1 は group アドレスで、multicast や broadcast として用いられる。U/L=0 は universally administered、U/L=1 は locally administered アドレスである。
- I/G や U/L の値を理由に構造上排除する pattern はない。universally/locally administered、individual/group のアドレスをすべて表現でき、locally administered・randomized・spoofed・virtual な MAC アドレスも48bit の値として表現できる。
- この値は、観測または提示されたアドレスの48bit だけを保存する。特定の機器の恒久アドレス、世界的な一意性、機器・利用者の認証、所有権、同じ機器との継続的な結び付きは保証しない。
- この形式は、正確に48bit の IEEE 802 MAC アドレスだけを扱う。EUI-64 やその他の64-bit MAC アドレスは収めない。IEEE RA は歴史的な用語 `MAC-48` を obsolete と説明しているが、すべての48-bit MAC アドレスを EUI-48 と呼べるわけではないので、この形式を EUI-48 と自動的に同一視しない。
- Payload が正確に3 WORD でなければ拒否する。

## 標準上の根拠 {#표준-근거}

- IEEE Registration Authority の [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) は、48-bit の LAN MAC アドレスを伝送順の6つの octet として表記し、各 octet が least-significant bit から伝送されること、および I/G と U/L が最初の octet の下位2 bit であることを説明する。この形式は octet と bit の位置をそのまま保存する。
- IEEE Registration Authority の [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) は、I/G=0/1 を individual/group、U/L=0/1 を universal/local administration と定義し、local アドレスが世界で一意でないことを説明する。`MAC-48` と EUI-48 の歴史的な用語の関係と違いも説明する。
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) は、EUI-48・EUI-64 が MAC アドレスなどとして使われうることを説明する。これは EUI-64 をこの48-bit レコードに入れるという意味ではない。
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) と [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) は、実際の機器が locally administered MAC アドレスをランダムに生成し、変更しうることを記録している。そのため、MAC の値だけから恒久的な機器 identity を推論しない。
- GEUL の TAG、Issuer の割り当て、直接 Length、16bit WORD framing は、IEEE 802 や上の資料の一部ではなく、この形式が加える規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 3 WORD を合わせた正確に8 WORD であり、直接長 `LLLL=0111` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に3 WORD でなければ拒否する。

## 例 {#예시}

locally administered な individual(unicast)アドレス `02:00:5e:10:00:00`(最初の octet `0x02` の I/G=0、U/L=1):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
