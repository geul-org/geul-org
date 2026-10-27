---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY は、他の表現からこのドキュメントに変換したツールとそのソースバージョン(コミットダイジェスト)を書く系譜 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

他の表現からこのドキュメントに変換した方法を書く(例: Wikidata 変換器、自然言語エンコーダ)。Tool は何で変換したか、Version はそのツールのどのソースで変換したかだ。この二つがあれば、同じ入力から同じドキュメントを再生成できる。

## レイアウト

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length 拡張 TAG]
Tool              Reference レコード 1個 (変換ツール・規則)
Version           Value レコード 1個 (SHA-256-DIGEST または SHA1-DIGEST)
```

- Codec: Meta `0x33`、系譜クラス(`011`)
- Payload: 組み込み Reference(ツール)+ 組み込み Value(ソースバージョンのダイジェスト)
- 個数: 複数可(ツールごとに一つ)

## 解釈と有効性

- Tool は、ちょうど一つの完全な Reference レコードだ。ツールを指す任意の Reference が使える。
  - geul.org ツールドキュメントのツール: [EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)(`0x0000`、ドキュメント ID `0x0001xxxx xxxxxxxx`、その LOCAL)。ツール一つにドキュメント一つだ([Issuer](/ja/grammar/issuer/) の用語定義ドキュメント)。
  - コーデックが GEUL ドキュメントなら、そのドキュメントを [DOC-POINTER](/ja/grammar/reference/doc-pointer/) で指す。
- Version は、ちょうど一つの完全な Value レコードで、Tool のソースのバージョン管理オブジェクト ID だ。git ならコミットオブジェクト ID の全体だ。
  - git リポジトリのオブジェクト形式が SHA-256 なら [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/)(`0x61`、16 WORD)、SHA-1 なら [SHA1-DIGEST](/ja/grammar/value/binary/sha1-digest/)(`0x62`、10 WORD)だ。リポジトリの形式は `git rev-parse --show-object-format` で確認する。
  - 省略 ID(`2bd496f` など)は使わない。ダイジェスト Value は切り詰めた値を許さない。
  - hex テキスト(UTF8-TEXT)では書かない。同じ値が SHA-1 で 22 WORD(バイナリ 11)、SHA-256 で 34 WORD(バイナリ 18)になる。
- Version は必須だ。ソースバージョンの分からないツールの記録は、再現の根拠にならない。バージョン管理の外にあるツールなら、配布物の SHA-256(SHA-256-DIGEST)を使う。
- Version は、コミットされたソースを指す。コミットされていない変更のある作業ツリーで作ったドキュメントには、そのコミット ID を使わない(ツールが実行を拒否することを勧める)。
- ツールがリポジトリの外のコードに依拠するなら(例: Go `replace` で指したローカルライブラリ)、そのコードも TRANSFORMED-BY として別に書く。ツールのコミット ID だけでは、そのコードが決まらない。
- 原典を無損失で移し入れるだけのツール(例: ダンプを原文のまま DB に格納するツール)は、ドキュメントの内容を決めないので書かない。無損失でない格納はドキュメントを変えるので、ツールとして書く。
- geul.org 規格ドキュメント(`0x1833`)は、Tool(幅 0、任意の Reference なので CODEC なし)と Version(幅 0、[CODEC](/ja/grammar/edge/codec/) `0861`・`0862`)の二つのレコードフィールドで書く。

## 長さ

```
全体 = 1 + N_len + N_tool + N_version WORD
```

- 最後のレコードを読み終えたカーソルは、Meta の終わりとちょうど一致しなければならない。
- Tool が EXTERNAL-ISSUER-1WORD(7 WORD)で Version が SHA1-DIGEST(11 WORD)なら、全体 1 + 1 + 7 + 11 = 20 WORD で、拡張長さを使う。SHA-256-DIGEST(18 WORD)なら 27 WORD だ。

## 例

非規範の例だ。ツールは geul.org ツールドキュメント `0x0001000000000001` の LOCAL 2(`0360 0000 0001 0000 0000 0001 0002`)、ソースはコミット `ddc0719974a32aaa7b422ee84221a9721085ce4c`(SHA-1)だ。

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 未解決の問題

- [GENERATED-BY](/ja/grammar/meta/lineage/generated-by/) のバージョンも同じ方式(必須のダイジェストまたは他の形式)に変えるか。モデルのバージョンはコミット ID ではない。

## 関連ページ

- [Meta](/ja/grammar/meta/)、[GENERATED-BY](/ja/grammar/meta/lineage/generated-by/)、[DERIVED-FROM](/ja/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/)、[DOC-POINTER](/ja/grammar/reference/doc-pointer/)、[SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/)、[SHA1-DIGEST](/ja/grammar/value/binary/sha1-digest/)、[CODEC](/ja/grammar/edge/codec/)
