---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI は RFC 3986 URI(scheme を含む絶対 URI)の文法に従う ASCII バイト列を収める Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI は RFC 3986 URI(scheme を含む絶対 URI)の文法に従う ASCII バイト列を収める Value である。偶数·奇数バイトのコードの組 0x074L/0x075L を使う。

| 項目 | 値 |
|---|---|
| 名前 | `URI` (偶奇の組。コードごとの名前は下の構成員の表) |
| TAG ID | `0x074L`·`0x075L` |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 20~21 |
| Kind | Value · 系列: TEXT |
| 索引の説明 | RFC 3986 `URI` production の ASCII バイト列。偶数·奇数バイト |
| Hugo 側 | `value/text/uri.md` |

## 構成員 {#구성원}

このページは偶奇の組をなす二つのコードをまとめて扱う。偶数コードはバイト数が偶数、奇数コードは奇数の値である([レコードと TAG WORD](../record.md#가변-길이-바이트열))。Codec ドキュメントはコードごとに一つである。二つの Codec ドキュメントのフィールドは同じで、DECLARE の対象と名前(BIND)だけが異なる。

| TAG ID | 名前 | バイト数 | Codec ID | 規格ドキュメント | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | 偶数 | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | 奇数 | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 残り生値(`0xFFFF`) |  |  |

URI は RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` の文法に従う ASCII バイト列を収める Value である。scheme を含むので、解釈に base URI は要らない。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x074L`(偶数バイト)·`0x075L`(奇数バイト)。系列 TEXT。
- バイト数は Codec の最下位ビットと Payload WORD 数で決まる。`2 × Payload WORD 数 − 最下位ビット`であり、Byte Count は置かない([Value](_index.md))。

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## 解釈と有効性 {#해석과-유효성}

- バイト列は RFC 3986 の `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` の文法に合わなければならない。query と fragment を含んでよい。
- URI 文法の terminal は US-ASCII 文字である。許された ASCII 文字はそのまま保存し、octet を percent-encoding するときは `pct-encoded = "%" HEXDIG HEXDIG` の形式を使う。非 ASCII 文字を literal byte として直接入れてはならない。
- `scheme` と `:` を必ず含む。相対参照は [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md)(IETF Codec 番号 `0x00008000`·`0x00008001`)を使う。
- RFC 3986 の URI production は空文字列を許さない。0 byte のレコードは無効である。
- WORD の中では上位 byte が先に来る。バイト数が奇数(奇数コード)なら、最後の WORD の使わない下位 byte は `00` でなければならない。
- Payload WORD 数は `ceil(バイト数/2)` である。奇数コードなのに最後の WORD の下位 byte が `00` でなければ拒否する。

## 標準の根拠 {#표준-근거}

- `URI`、URI 文字と percent-encoding の文法は [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986) に従う。
- 偶奇のコードの組、zero padding、GEUL の TAG/Length と 16 ビット WORD の配置は、この形式の framing 規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`·`1111` の拡張長を使い、拡張 TAG も全体の数に含める([Length](../record.md))。

## 例 {#예시}

- `https://example.com/` は ASCII 20 byte(偶数)なので `URI-EVEN`(`0x074L`)である。
- Payload は `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F` の 10 WORD である。
- TAG 1 WORD と Payload 10 WORD を合わせて全体 11 WORD なので `LLLL=1010` である。全体は `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F` である。

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` は、GEUL から外部のバイナリ·ドキュメントのような大きなコンテンツを参照するための不変コンテンツストアとして構想したもので、まだ運用していない。推奨するアドレス形式は `https://archive.geul.org/sha256/{digest}` である。同じバイト列は同じ URI を持たなければならず、公開した後に同じ URI のバイトを変えてはならない。

URI Value は外部コンテンツの位置やアドレス文字列を表すだけで、対象自体の同一性や不変性は保証しない。インライン Value の最大範囲を超えるバイナリとテキストは archive URI で参照できる。保存オブジェクトのメタデータには次の項目を記録しなければならない。

- 原本 URI と収集時刻
- SHA-256 と Byte Length
- MIME type
- license identifier と version
- 著作者、出典と告知
- ライセンスの根拠 URI と、必要なら収集時点の根拠の写し

収集の可否は、無料でアクセスできるかではなく、再配布の権限が明示的に確認できるかで判断する。表示、非営利、改変禁止、継承など、適用されるライセンス条件を守らなければならない。ドキュメントとコンテンツには Creative Commons のような明示的なライセンスを記録し、ソフトウェアには可能なら SPDX License ID を使う。

権利の問題や訂正で提供を中止する場合でも、既存の URI に別のバイトを入れてはならない。その URI は中止の理由と時刻を載せた tombstone を返し、原本の digest と監査記録を保存しなければならない。ただし、法的義務が監査記録の保存を禁じる場合はその義務を優先する。

archive URI はアクセス位置とコンテンツ digest を併せて提供する。この content-address と不変性の規則は GEUL Archive profile のポリシーであり、URI Value の一般文法は `archive.geul.org` に依存しない。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000740/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

上は `URI-EVEN`(`0x074L`)の Codec ドキュメントである。他の構成員(`URI-ODD`)の Codec ドキュメントは、DOC-ID の Codec ID、DECLARE の対象、`#1` に結び付けた名前(BIND)だけが異なる。
