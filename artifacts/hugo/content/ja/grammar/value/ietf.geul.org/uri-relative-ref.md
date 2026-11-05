---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REFは、RFC 3986 の relative-ref 文法に従う ASCII バイト列を収める Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REFは、RFC 3986 の `relative-ref` 文法に従う ASCII バイト列を収める Value である。base URI と resolve された結果は Payload に入れない。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000007` IETF、Codec 番号 `0x00008000`(偶数バイト)・`0x00008001`(奇数バイト)。系列 TEXT。
- バイト数は、Codec 番号の最下位ビットと Payload の WORD 数で定める。`2 × Payload WORD 数 − 最下位ビット` であり、Byte Count は置かない([Value](../_index.md))。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000007 (IETF)
Codec 番号        2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は、RFC 3986 の `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` 文法に合っていなければならない。
- URI 文法の terminal は US-ASCII 文字である。許される ASCII 文字はそのまま格納し、octet を percent-encoding するときは `pct-encoded = "%" HEXDIG HEXDIG` の形式を用いる。非 ASCII 文字を literal byte として直接入れてはならない。
- `relative-part` は `path-empty` でありうるので、空のバイト列も文法上有効な `relative-ref` である。
- base URI、resolution context および resolve の結果は、この形式の外側の文脈である。
- WORD 内では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload の WORD 数は `ceil(バイト数/2)` である。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準上の根拠 {#표준-근거}

- `relative-ref`、URI の文字および percent-encoding の文法は、[RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986) に従う。
- 偶奇のコードの組、zero padding、GEUL の TAG/Length と16ビット WORD の配置は、この形式の framing の規則である。base URI と参照解決の結果は RFC の文脈であるが、Payload には入れない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に含める([Length](../../record.md))。
- 0 byte は空の `relative-ref` として意味上は許されるが、Payload WORD がない。その物理配置は下の未解決の問題である。

## 例 {#예시}

- `a/b?x=1` は7 byte(奇数)なので Codec 番号 `0x00008001`、Payload `612F 623F 783D 3100` である。全体9 WORD なので `LLLL=1000` である。全体は `09D8 0000 0007 0000 8001 612F 623F 783D 3100` である。

## 未解決の問題 {#열린-문제}

- 空の `relative-ref`(0 byte)の物理配置。Payload のないレコードが「最小 Payload 1 WORD」の規則と合わないため、まだ定めていない。
