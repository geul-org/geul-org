---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESSは、IPv6 アドレスの128bit の値を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESSは、IPv6 アドレスの128bit の値を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000007` IETF、Codec 番号 `0x0000C002`、系列 BINARY である。Payload は正確に8 WORD(128bit)である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  全体 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 番号        2 WORD  0x0000C002
Payload           8 WORD (128ビット)  IPv6 address, high-order bit → low-order bit
```

## 解釈と有効性 {#해석과-유효성}

- 8つの Payload WORD を上位 WORD から連結し、IPv6 アドレス field の128bit を順序どおりに読む。各 WORD で先に来る octet が上位8bit である。
- Payload はアドレス1つの128bit だけを収める。CIDR prefix length、port、transport protocol は含めない。
- zone identifier はアドレスの128bit に含まれないので、Payload には入れない。zone が必要な scoped address は、interface や Edge・Reference・Profile などの外部の文脈で与える。
- すべての128bit pattern を表現できる。unspecified・loopback・multicast・特殊・予約の pattern の運用上の意味と使用可否は外部の文脈で判断し、構造上の有効性を制限しない。
- IPV4-ADDRESS と IPV6-ADDRESS は別個の形式である。IPv4-mapped IPv6 アドレスも128bit の IPv6 値として保存し、IPV4-ADDRESS と自動的に同一視したり、相互に正規化したりしない。
- この Value を Reference の識別子の構成要素として用いることはできるが、scope と参照ポリシーはアドレスの bit pattern には含まれない。

## 標準上の根拠 {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) は、IPv6 アドレスを128bit の identifier と定義し、unicast・anycast・multicast、および IPv4-mapped IPv6 を含むアドレスの bit format を定める。この形式はその128bit を再解釈せずに保存する。
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) は、IPv6 packet の Source Address と Destination Address をそれぞれ128bit の field と定義する。Payload WORD は、そのアドレス field の high-order bit から low-order bit までの順序を保存する。
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) は、non-global address の zone がアドレス自体に encode されず、context によって定まると述べる。そのため zone identifier は Payload の外に置く。
- RFC 4291 の文字列表記は、説明と入出力にのみ用いることができる。[RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) は内部の格納形式を定めないので、その文字列の canonicalization をこの binary レコードの canonicalization として用いない。
- GEUL の TAG、Issuer の割り当て、直接 Length、16bit WORD framing は、これらの RFC の一部ではなく、この形式が加える規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。

## 例 {#예시}

IPv6 アドレス `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- 文字列の省略表記は Payload に影響しない。
