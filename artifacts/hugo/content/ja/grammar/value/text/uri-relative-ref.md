---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF は、RFC 3986 relative-ref 文法の ASCII バイト列を収める Value だ。IETF Issuer の形式番号 0x8000/0x8001 を使う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF は、RFC 3986 `relative-ref` 文法の ASCII バイト列を収める Value だ。base URI と resolve した結果は Payload に入れない。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0020` IETF、形式番号 `0x8000`(偶数バイト)・`0x8001`(奇数バイト)。系列 TEXT。
- バイト数は、形式番号の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0020 (IETF)
形式番号          1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## 解釈と有効性

- バイト列は、RFC 3986 の `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` 文法に合わなければならない。
- URI 文法の terminal は US-ASCII 文字だ。許される ASCII 文字はそのまま保存し、octet を percent-encoding するときは `pct-encoded = "%" HEXDIG HEXDIG` 形式を使う。非 ASCII 文字を literal byte として直接入れてはならない。
- `relative-part` は `path-empty` でありうるので、空のバイト列も文法上は有効な `relative-ref` だ。
- base URI、resolution context と resolve の結果は、この形式の外側の文脈だ。
- WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` だ。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠

- `relative-ref`、URI 文字と percent-encoding の文法は、[RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986) に従う。
- 偶奇コードのペア、zero padding、GEUL TAG/Length と 16ビット WORD の配置は、この形式の framing 規則だ。base URI と参照解決の結果は RFC の文脈だが、Payload には入れない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。
- 0 byte は、空の `relative-ref` として意味上は許され、Payload WORD がない。その物理的な配置は、下の未解決の問題だ。

## 例

- `a/b?x=1` は 7 byte(奇数)なので形式番号 `0x8001`、Payload `612f 623f 783d 3100` だ。全体 7 WORD なので `LLLL=0110` だ。全体は `0B7C 0020 8001 612f 623f 783d 3100` だ。

## 未解決の問題

- 空の `relative-ref`(0 byte)の物理的な配置。Payload のないレコードが「最小 Payload 1 WORD」の規則と合わないため、まだ決めていない。
