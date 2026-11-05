---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER は、Issuer が公表した Codec ドキュメントの 1 つのバージョンを指す指示宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER は、Issuer が公表した Codec ドキュメントの 1 つのバージョンを指す指示宣言 Reference だ。Codec ドキュメントにはドキュメント ID がなく、CODEC-POINTER で自分とそのバージョンを指す。

| 項目 | 値 |
|---|---|
| 名前 | `CODEC-POINTER` (規格ドキュメント BIND `CODEC-POINTER`) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| 規格ドキュメント | `0x00000000/codecs/0x00000420/` (DECLARE 対象 `0420`) |
| セクション | 2 `0010` (Reference その他)、セクション内オフセット C = 2 |
| Kind | Reference · 分類: 指示宣言 |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Issuer Codec の 1 つのバージョン。Issuer + Codec ID 2 WORD + バージョン ID 2 WORD、対象 ID はない |
| Hugo 側 | `reference/codec-pointer.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 残り全部の生値(`0xFFFF`) |  |  |
| 2 | `codec` | #3 | 生値 2 WORD |  |  |
| 3 | `version` | #4 | 生値 2 WORD |  |  |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length 拡張 TAG]
Issuer            2/4/16 WORD
Codec ID          2 WORD
バージョン ID     2 WORD
```

## 解釈と有効性 {#해석과-유효성}

- Issuer 幅は、Payload から Codec ID とバージョン ID の 4 WORD を除いた残りだ。Payload は 6、8、20 WORD のいずれかで、それ以外の長さは invalid だ。Issuer の値がより狭い幅に収まるなら invalid だ(Issuer 正規形)。
- Issuer が 16 WORD なら全体で 21 WORD になるため、Length 拡張 1 WORD が付く。
- Codec ID は 32 ビットだ。GEUL 直接コードの Codec ID は、その TAG WORD(L=0)を 32 ビットで書いた値だ(TRIPLE `0x0AAL` → `0x00000AA0`)。Issuer Codec の Codec ID はレコードの Codec 番号で、Issuer が Kind と無関係に自分の `codecs/` の中で重ならないように定める([公表アドレスとバージョン一覧](../publishing.md#id-표기))。
- バージョン ID `0` は最新バージョンだ。それ以外の値はそのバージョンに固定される。
- Codec `0x042L` 1 つだけだ。量化はない(Identified)。セクション 2 なので、量化・体系としては読まない。
- 使われる場所: Codec ドキュメントの Meta [DOC-ID](../meta/0x1C7L-doc-id.md)、Codec バージョン一覧の [PUBLICATION](../edge/0x0B8L-publication.md)・DEPRECATION・TOMBSTONE、Codec ドキュメントを取り込む [IMPORT-DOC](../meta/0x1E4L-import-doc.md)。これらの位置で DOC-POINTER の代わりをする。
- 公表アドレスは `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<バージョン ID>.geul` だ([公表アドレスとバージョン一覧](../publishing.md#공표-주소))。

## 例 {#예시}

GEUL Issuer `0x00000000` の TRIPLE Codec(Codec ID `0x00000AA0`)。

| バージョン | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| 最新 (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + バージョン ID 2 = 7 WORD、`LLLL=0110` だ。TAG は `0000 0100 0010 0110` = `0426` だ。

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[Codec 規格ドキュメント](../codec-spec.md)
- [公表アドレスとバージョン一覧](../publishing.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000420/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
