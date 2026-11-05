---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESSは、IPv4 アドレスの32bit の値を収める固定幅の Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESSは、IPv4 アドレスの32bit の値を収める固定幅の Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000007` IETF、Codec 番号 `0x0000C001`、系列 BINARY である。Payload は正確に2 WORD(32bit)である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  全体 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec 番号        2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## 解釈と有効性 {#해석과-유효성}

- アドレスの octet を network byte order のまま置く。各 WORD で先に来る octet が上位8bit、次の octet が下位8bit である。
- Payload はアドレス1つの32bit だけを収める。CIDR prefix length、port、transport protocol は含めない。
- すべての32bit pattern を表現できる。unspecified・特殊・予約・マルチキャストなどの pattern の運用上の意味と使用可否は外部の文脈で判断し、構造上の有効性を制限しない。
- IPV4-ADDRESS と IPV6-ADDRESS は別個の形式である。IPv4-mapped IPv6 アドレスをこの形式へ自動変換したり、同じ値に正規化したりしない。
- この Value を Reference の識別子の構成要素として用いることはできるが、その参照ポリシーと寿命はアドレスの bit pattern には含まれない。
- Payload が正確に2 WORD でなければ拒否する。

## 標準上の根拠 {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) は、IPv4 アドレスを4 octet(32bit)の固定長と定義し、Source Address と Destination Address をそれぞれ32bit の field と定義する。Appendix B の octet の伝送順と、各 octet の most-significant-bit-first の規則を Payload に保存する。
- GEUL の TAG、Issuer の割り当て、16bit WORD への組分け、Length は、RFC 791 の一部ではなく、この形式が加える framing の規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 2 WORD を合わせた正確に7 WORD であり、直接長 `LLLL=0110` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に2 WORD でなければ拒否する。

## 例 {#예시}

IPv4 アドレス `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
