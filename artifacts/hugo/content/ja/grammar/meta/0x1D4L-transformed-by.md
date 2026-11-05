---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "別の表現からこのドキュメントへ変換した方法を記す(例: Wikidata 変換器、自然言語エンコーダ)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `TRANSFORMED-BY` (規格ドキュメント BIND `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| 規格ドキュメント | `0x00000000/codecs/0x00001D40/` (DECLARE 対象 `1D40`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 20 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 変換方法。ツール・ルール・バージョン |
| Hugo 側 | `meta/lineage/transformed-by.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `version` | #3 | レコード | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

別の表現からこのドキュメントへ変換した方法を記す(例: Wikidata 変換器、自然言語エンコーダ)。Tool は何で変換したか、Version はそのツールのどのソースで変換したかである。両方そろって初めて、同じ入力から同じドキュメントを再び作れる。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length 拡張 TAG]
Tool              Reference レコード 1 つ (変換ツール・ルール)
Version           Value レコード 1 つ (SHA-256-DIGEST または SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`、系譜クラス
- Payload: 埋め込み Reference(ツール)+ 埋め込み Value(ソースバージョンのダイジェスト)
- 個数: 複数可(ツールごとに 1 つ)

## 解釈と有効性 {#해석과-유효성}

- Tool はちょうど 1 つの完全な Reference レコードである。ツールを指す Reference であれば何でも使える。
  - geul.org ツールドキュメントのツール: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)(`0x00000000`、ドキュメント ID `0x0001xxxx xxxxxxxx`、その LOCAL)。ツール 1 つにドキュメント 1 つである([Issuer](../issuer.md) 用語定義ドキュメント)。
  - Codec が GEUL ドキュメントであれば、その Codec ドキュメントを [CODEC-POINTER](../reference/0x042L-codec-pointer.md) で指す。
- Version はちょうど 1 つの完全な Value レコードであり、Tool のソースのバージョン管理オブジェクト ID である。git ならコミットオブジェクト ID の全体である。
  - git リポジトリのオブジェクト形式が SHA-256 なら [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)(`0x07CL`、16 WORD)、SHA-1 なら [SHA1-DIGEST](../value/0x07DL-sha1-digest.md)(`0x07DL`、10 WORD)である。リポジトリの形式は `git rev-parse --show-object-format` で確認する。
  - 短縮 ID(`2bd496f` など)は使わない。ダイジェスト Value は切り詰めた値を許さない。
  - hex テキスト(UTF8-TEXT)で書かない。同じ値が SHA-1 では 22 WORD(バイナリ 11)、SHA-256 では 34 WORD(バイナリ 18)になる。
- Version は必須である。ソースバージョンが分からないツールの記録は、再現の根拠にならない。バージョン管理の外のツールであれば、配布物の SHA-256(SHA-256-DIGEST)を使う。
- Version はコミット済みのソースを指す。コミットされていない変更のある作業ツリーで作ったドキュメントには、そのコミット ID を使わない(ツールが実行を拒否することを勧める)。
- ツールがリポジトリ外のコードに依存する場合(例: Go `replace` で指したローカルライブラリ)、そのコードも TRANSFORMED-BY で別途記す。ツールのコミット ID だけではそのコードが定まらない。
- 原典を無損失で移し替えるだけのツール(例: ダンプを原文のまま DB に取り込むツール)は、ドキュメントの内容を決めないので記さない。無損失でない取り込みはドキュメントを変えるので、ツールとして記す。
- geul.org 規格ドキュメント(`0x1D40`)は、Tool(幅 0、任意の Reference なので CODEC なし)と Version(幅 0、[CODEC](../edge/0x0BEL-codec.md) `07C0`・`07D0`)の 2 つのレコードフィールドで記す。

## 長さ {#길이}

```
全体 = 1 + N_len + N_tool + N_version WORD
```

- 最後のレコードをすべて読み終えたカーソルは、Meta の末尾とちょうど一致しなければならない。
- Tool が EXTERNAL-ISSUER-2WORD(8 WORD)で Version が SHA1-DIGEST(11 WORD)なら、全体は 1 + 1 + 8 + 11 = 21 WORD となり、拡張長を使う。SHA-256-DIGEST(18 WORD)なら 28 WORD である。

## 例 {#예시}

非規範の例である。ツールは geul.org ツールドキュメント `0x0001000000000001` の LOCAL 2(`02F7 0000 0000 0001 0000 0000 0001 0002`)、ソースはコミット `ddc0719974a32aaa7b422ee84221a9721085ce4c`(SHA-1)である。

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 未解決の問題 {#열린-문제}

- [GENERATED-BY](0x1D3L-generated-by.md) のバージョンも同じ方式(必須のダイジェスト、または別の形式)に変えるか。モデルのバージョンはコミット ID ではない。

## 関連ページ {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001D40/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
