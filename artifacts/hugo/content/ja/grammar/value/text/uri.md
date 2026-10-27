---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI は、RFC 3986 URI(scheme を含む絶対 URI)文法の ASCII バイト列を収める Value だ。偶数・奇数バイトのコードペア 0x44/0x45 を使う。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI は、RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 文法の ASCII バイト列を収める Value だ。scheme を含むので、解釈に base URI は要らない。

## レイアウト

- コード: Value 直接コード `0x44`(偶数バイト)・`0x45`(奇数バイト)。系列 TEXT。
- バイト数は、Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット` で、Byte Count は置かない([Value](/ja/grammar/value/))。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## 解釈と有効性

- バイト列は、RFC 3986 の `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 文法に合わなければならない。query と fragment を含められる。
- URI 文法の terminal は US-ASCII 文字だ。許される ASCII 文字はそのまま保存し、octet を percent-encoding するときは `pct-encoded = "%" HEXDIG HEXDIG` 形式を使う。非 ASCII 文字を literal byte として直接入れてはならない。
- `scheme` と `:` を必ず含む。相対参照は [URI-RELATIVE-REF](/ja/grammar/value/text/uri-relative-ref/)(IETF 形式番号 `0x8000`・`0x8001`)を使う。
- RFC 3986 の URI production は、空文字列を許さない。0 byte のレコードは有効ではない。
- WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` だ。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠

- `URI`、URI 文字と percent-encoding の文法は、[RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986) に従う。
- 偶奇コードのペア、zero padding、GEUL TAG/Length と 16ビット WORD の配置は、この形式の framing 規則だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。

## 例

- `https://example.com/` は ASCII 20 byte(偶数)なので `URI-EVEN`(`0x44`)だ。
- Payload は `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f` の 10 WORD だ。
- TAG 1 WORD と Payload 10 WORD を合わせて全体 11 WORD なので `LLLL=1010` だ。全体は `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f` だ。

## GEUL Archive URI

`archive.geul.org` は、GEUL で外部のバイナリ・ドキュメントのような大きなコンテンツを参照するための、不変のコンテンツストアだ。推奨するアドレス形式は `https://archive.geul.org/sha256/{digest}` だ。同じバイト列は同じ URI を持たなければならず、公開した後に同じ URI のバイトを変えてはならない。

URI Value は、外部コンテンツの位置やアドレスの文字列を表すだけで、対象自体の同一性や不変性は保証しない。インライン Value の最大範囲を超えるバイナリとテキストは、archive URI で参照できる。保存オブジェクトの metadata には、次の項目を記録しなければならない。

- 元の URI と収集時刻
- SHA-256 と Byte Length
- MIME type
- license identifier と version
- 著作者、出典と告知
- ライセンスの根拠 URI と、必要なら収集時点の根拠のコピー

収集できるかは、無料でアクセスできるかではなく、再配布の権限が明示的に確認できるかで判断する。表示、非営利、改変禁止、継承などの適用されるライセンス条件を守らなければならない。ドキュメントとコンテンツには Creative Commons のような明示的なライセンスを記録し、ソフトウェアには可能なら SPDX License ID を使う。

権利の問題や訂正で提供を中止しても、既存の URI に別のバイトを入れてはならない。その URI は、中止の事由と時刻を収めた tombstone を返し、元の digest と監査記録を保存しなければならない。ただし法的義務が監査記録の保存を禁じるなら、その義務を優先する。

archive URI は、アクセスの位置とコンテンツの digest を併せて提供する。この content-address と不変性の規則は GEUL Archive profile のポリシーであり、URI Value の一般文法は `archive.geul.org` に従属しない。
