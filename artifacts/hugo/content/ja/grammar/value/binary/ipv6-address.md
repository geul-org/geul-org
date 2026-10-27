---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS は、IPv6 アドレス 128bit を順序どおりに収める、固定 11 WORD の IETF Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS は、IPv6 アドレスの 128bit 値を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0020` IETF、形式番号 `0xC002`、系列 BINARY だ。Payload はちょうど 8 WORD(128bit)だ。

## レイアウト

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0020 (IETF)
形式番号          1 WORD  0xC002
Payload           8 WORD (128ビット)  IPv6 address, high-order bit → low-order bit
```

## 解釈と有効性

- 八つの Payload WORD を上位 WORD から連ねて、IPv6 アドレス field の 128bit を順序どおりに読む。各 WORD で先に来る octet が上位 8bit だ。
- Payload はアドレス一つの 128bit だけを収める。CIDR prefix length、port、transport protocol は収めない。
- zone identifier はアドレスの 128bit に含まれないので、Payload に入れない。zone が必要な scoped address は、interface や Edge・Reference・Profile のような外部の文脈で与える。
- すべての 128bit pattern を表現できる。unspecified・loopback・multicast・特殊・予約 pattern の運用上の意味と使用可否は、外部の文脈で判断し、構造的な有効性を制限しない。
- IPV4-ADDRESS と IPV6-ADDRESS は別個の形式だ。IPv4-mapped IPv6 アドレスも 128bit の IPv6 値として保存し、IPV4-ADDRESS と自動的に同一視したり、互いに正規化したりしない。
- この Value を Reference の識別子構成要素として使えるが、scope と参照ポリシーは、アドレスの bit pattern には含まれない。

## 標準の根拠

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) は、IPv6 アドレスを 128bit の identifier として定義し、unicast・anycast・multicast、IPv4-mapped IPv6 を含むアドレスの bit format を定める。この形式は、その 128bit を再解釈せずに保存する。
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) は、IPv6 packet の Source Address と Destination Address をそれぞれ 128bit field として定義する。Payload WORD は、そのアドレス field の high-order bit から low-order bit までの順序を保存する。
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) は、non-global address の zone がアドレス自体にエンコードされず、context で決まると述べる。そのため zone identifier は Payload の外に置く。
- RFC 4291 の文字列表記は、説明と入出力にだけ使える。[RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) は内部の保存形式を定めないので、その文字列 canonicalization をこの binary レコードの canonicalization として使わない。
- GEUL TAG、Issuer 割り当て、直接 Length、16bit WORD framing は、これらの RFC の一部ではなく、この形式が加える規則だ。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

IPv6 アドレス `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- 文字列の省略表記は、Payload に影響しない。
