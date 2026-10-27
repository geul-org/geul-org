---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID は、RFC 9562 UUID の 128bit 値を canonical 16 octet のまま収める固定 9 WORD の Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID は、RFC 9562 UUID の 128bit 値を収める固定幅の Value だ。Value 直接コード `0x60`、系列 BINARY だ。Payload はちょうど 8 WORD(16 octet、128bit)だ。

## レイアウト

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  全体 9 WORD
Payload           8 WORD (128ビット)  UUID octet 0 → octet 15
```

## 解釈と有効性

- RFC 9562 の canonical UUID の octet 0 から octet 15 までを順に二つの octet ずつ束ねる。先に来る octet が WORD の上位 8bit だ。UUID の field、version bit、variant bit を並べ替えたり、再エンコードしたりしない。
- `8-4-4-4-12` の hex-and-dash 文字列は、入出力の表現にすぎない。大文字小文字や dash は Payload に入らず、パース結果の 16 octet だけを保存する。
- この UUID Value は、128bit pattern を無損失で保存する。RFC 9562 variant `10xx` で、version 1、3、4、5、6、7 は標準 layout で、version 8 は custom UUID format だ。version 2 は DCE Security 用に予約されていて RFC が layout を定めておらず、version 0 は unused、version 9–15 は future definition 用の予約だ。他の variant も、互換または将来の定義のために予約されている。
- Nil UUID は 128bit all-zero、Max UUID は 128bit all-one の特殊値だ。予約・unused の version/variant を含む 128bit pattern も構造的に排除せず、その pattern の意味と相互運用性は、適用する標準と外部の文脈で判断する。
- UUID の同一性は、Payload の 128bit 値が同じかで判断する。同じ値だという事実は、対象の認証、所有権、現在の存在、解決可能性、アクセス権限を保証しない。
- Microsoft COM GUID を保存するとき、mixed-endian のメモリ・シリアライズ表現をそのままコピーしない。まず RFC 9562 の canonical な field/octet 順の 16 octet に変える。
- Payload がちょうど 8 WORD でなければ拒否する。

## 標準の根拠

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) は、UUID を 16 octet(128bit)と定義し、field を most-significant-byte-first でエンコードして、binary format で big-endian の field 順につなぐ。variant は octet 8 の上位 bit、version は octet 6 の上位 4bit にあり、この形式はその位置をそのまま保存する。
- RFC 9562 Sections 4.1–5.10 は、variant と version 1–8、Nil、Max、予約範囲を区別する。RFC 9562 は RFC 4122 を置き換えるので、この形式の現行の規範は RFC 9562 だ。
- RFC 9562 の hex-and-dash ABNF は text 表現で、COM GUID の little-endian caveat も別に示している。GEUL は、RFC UUID の canonical 16 octet だけを Payload に入れる。
- GEUL TAG、直接 Length、16bit WORD framing は、RFC 9562 の一部ではなく、この形式が加える規則だ。

## 長さ

- 全体は、TAG 1 WORD と Payload 8 WORD を合わせたちょうど 9 WORD で、直接長さ `LLLL=1000` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

RFC 9562 Appendix A.6 の UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`、Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`。
