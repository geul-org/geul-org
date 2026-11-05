---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER は、Issuer 自身を指す指示宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `ISSUER-POINTER` (規格ドキュメント BIND `ISSUER-POINTER`) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| 規格ドキュメント | `0x00000000/codecs/0x00000400/` (DECLARE 対象 `0400`) |
| セクション | 2 `0010` (Reference その他)、セクション内オフセット C = 0 |
| Kind | Reference · 分類: 指示宣言 |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 側 | `reference/issuer-pointer.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 残り全部の生値(`0xFFFF`) |  |  |

ISSUER-POINTER は、Issuer 自身を指す指示宣言 Reference だ。Issuer 名の `BIND`、`LABEL`、判定 Edge の対象になる。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length 拡張 TAG]
Issuer            2/4/16 WORD
```

- Issuer 幅は Payload 全体だ。Codec は幅を分けない。幅が 2、4、16 WORD でない、または Issuer の値がより狭い幅に収まるなら invalid だ(Issuer 正規形)。
- Issuer が 16 WORD なら全体で 17 WORD になるため、Length 拡張 1 WORD が付く。
- Codec `0x040L` 1 つだけだ。量化はない(Identified)。
- Issuer の値は [Issuer](../issuer.md) の割り当てに従う。
- 用途: Issuer 一覧 `issuers/` の BIND Subject([公表アドレスとバージョン一覧](../publishing.md#issuer-목록))、Issuer の表示名 LABEL、Issuer に対する判定、署名者など、Issuer 自身が対象となる位置。
- Issuer 自身を指す形式は ISSUER-POINTER 1 つだけだ。`EXTERNAL-ISSUER-*` でドキュメント ID `0`、対象 ID `0` を使って Issuer を指すのは invalid だ。

## 例 {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## 関連ページ {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000400/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
