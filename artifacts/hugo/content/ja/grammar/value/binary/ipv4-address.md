---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS は、IPv4 アドレス 32bit を network byte order のまま収める、固定 5 WORD の IETF Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS は、IPv4 アドレスの 32bit 値を収める固定幅の Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0020` IETF、形式番号 `0xC001`、系列 BINARY だ。Payload はちょうど 2 WORD(32bit)だ。

## レイアウト

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  全体 5 WORD
Issuer            1 WORD  0x0020 (IETF)
形式番号          1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## 解釈と有効性

- アドレスの octet を network byte order のまま置く。各 WORD で先に来る octet が上位 8bit、次の octet が下位 8bit だ。
- Payload はアドレス一つの 32bit だけを収める。CIDR prefix length、port、transport protocol は収めない。
- すべての 32bit pattern を表現できる。unspecified・特殊・予約・マルチキャストのような pattern の運用上の意味と使用可否は、外部の文脈で判断し、構造的な有効性を制限しない。
- IPV4-ADDRESS と IPV6-ADDRESS は別個の形式だ。IPv4-mapped IPv6 アドレスを、この形式に自動変換したり、同じ値に正規化したりしない。
- この Value を Reference の識別子構成要素として使えるが、その参照ポリシーと寿命は、アドレスの bit pattern には含まれない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 標準の根拠

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) は、IPv4 アドレスを 4 octet(32bit)の固定長として定義し、Source Address と Destination Address をそれぞれ 32bit field として定義する。Appendix B の octet 伝送順と、各 octet の most-significant-bit-first 規則を Payload に保存する。
- GEUL TAG、Issuer 割り当て、16bit WORD の束ね、Length は、RFC 791 の一部ではなく、この形式が加える framing 規則だ。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 2 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。

## 例

IPv4 アドレス `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
