---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER は、Issuer が公表したドキュメントの 1 つのバージョンを指す指示宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DOC-POINTER` (規格ドキュメント BIND `DOC-POINTER`) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| 規格ドキュメント | `0x00000000/codecs/0x00000410/` (DECLARE 対象 `0410`) |
| セクション | 2 `0010` (Reference その他)、セクション内オフセット C = 1 |
| Kind | Reference · 分類: 指示宣言 |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 側 | `reference/doc-pointer.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 残り全部の生値(`0xFFFF`) |  |  |
| 2 | `doc` | #3 | 生値 4 WORD |  |  |
| 3 | `version` | #4 | 生値 2 WORD |  |  |

DOC-POINTER は、Issuer が公表したドキュメントの 1 つのバージョンを指す指示宣言 Reference だ。ドキュメントの公表・deprecate・削除、引用版、ドキュメントについての叙述の対象になる。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length 拡張 TAG]
Issuer            2/4/16 WORD
ドキュメント ID   4 WORD
バージョン ID     2 WORD
```

## 解釈と有効性 {#해석과-유효성}

- Issuer 幅は、Payload からドキュメント ID とバージョン ID の 6 WORD を除いた残りだ。Codec は幅を分けない。幅が 2、4、16 WORD でない、または Issuer の値がより狭い幅に収まるなら invalid だ(Issuer 正規形)。
- バージョン ID は省略しない。省略を許すと Payload の長さだけでは Issuer 幅を決められない(Issuer 4 WORD・バージョンなしと Issuer 2 WORD・バージョンありが同じ 8 WORD になる)。
- バージョン ID `0` は最新バージョンだ。解釈する時点の現行バージョンに結びつく。それ以外の値はそのバージョンに固定される([PUBLICATION](../edge/0x0B8L-publication.md))。
- ドキュメント ID `0` は Issuer の用語定義索引ドキュメントだ。Issuer 自身は [ISSUER-POINTER](0x040L-issuer-pointer.md) で指す。
- すべての Issuer は、ドキュメント ID `0x0000000000000000` と `0xFFFFFFFFFFFFFFFF` を予約する([Issuer と公表](../issuer.md#용어-정의-문서))。`0xFFFFFFFFFFFFFFFF` は Issuer `0x00000000` の Issuer 一覧 `issuers/` に使い、ほかの Issuer は使わない。`issuers/versions.geul` の PUBLICATION・DEPRECATION・TOMBSTONE がこの値で一覧のバージョンを指す([公表アドレスとバージョン一覧](../publishing.md#목록-문서))。
- Codec `0x041L` 1 つだけだ。量化はない(Identified)。
- Issuer のドキュメントを指す形式は DOC-POINTER 1 つだけだ。`EXTERNAL-ISSUER-*`(Issuer、ドキュメント ID、対象 ID `0`)や `EXTERNAL-POINTER-*`(IMPORT ID、対象 ID `0`)でドキュメントを指すのは invalid だ。
- 使われる場所: Meta [DOC-ID](../meta/0x1C7L-doc-id.md)・[IMPORT-DOC](../meta/0x1E4L-import-doc.md)、バージョン一覧の PUBLICATION・DEPRECATION・TOMBSTONE。
- Codec ドキュメントにはドキュメント ID がない。Codec ドキュメントとそのバージョンは [CODEC-POINTER](0x042L-codec-pointer.md) で指す。

## 例 {#예시}

GEUL Issuer `0x00000000` のドキュメント `0xFFFF000000000001`。

| バージョン | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| 最新 (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ドキュメント ID 4 + バージョン ID 2 = 9 WORD、`LLLL=1000` だ。TAG は `0000 0100 0001 1000` = `0418` だ。

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000410/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
