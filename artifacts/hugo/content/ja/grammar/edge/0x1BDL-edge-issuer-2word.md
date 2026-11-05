---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD は、Issuer が定義した Edge 形式である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD は、Issuer が定義した Edge 形式である。Edge 区画の末尾 3 マスのうちの 1 つで、Issuer 幅が 2 WORD である。3 つの Kind の ISSUER レイアウトは同じである([レコードと TAG WORD](../record.md#issuer-형식-레코드))。

| 項目 | 値 |
|---|---|
| 名前 | `EDGE-ISSUER-2WORD` (規格ドキュメント BIND `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001BD0/` (DECLARE 対象 `1BD0`) |
| セクション | 13 `1101` (Edge (末尾 3 マス ISSUER)), セクション内オフセット C = 29 |
| Kind | Edge · 分類: Issuer 形式 |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | Issuer 2 WORD と Codec 番号 2 WORD。形式は Issuer の Codec ドキュメントが定める |
| Hugo 側 | `edge/_index.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[Length 拡張 TAG]
Issuer            2 WORD
Codec 番号         2 WORD。Issuer が定義する
Edge Id           LOCAL Reference レコード。Issuer・Codec 番号の後の最初の要素
残りの Payload     Issuer が発行した Codec ドキュメントが定める
```

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD として宣言しない。EDGE-ISSUER の Edge Id は Codec 番号の後、`payload` フィールドの前に来る([レイアウト](#레이아웃))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 生値 2 WORD |  |  |
| 2 | `codec` | #3 | 生値 2 WORD |  |  |
| 3 | `payload` | #4 | 残りの生値(`0xFFFF`) |  |  |

`payload` の構成は、その Issuer の Codec ドキュメントが定める。

## 解釈と有効性 {#해석과-유효성}

- GEUL は Length で Payload の境界だけを知る。形式を知らないデコーダは Kind、Length、Issuer、Codec 番号までを知り、Length で読み飛ばす。
- Payload は Edge Id(LOCAL Reference)で始まる([Edge](_index.md#레이아웃))。Edge Id の後の構成要素は Issuer の Codec ドキュメントが定める。
- Issuer は値が収まる最も短い幅で書く([Issuer と公表](../issuer.md#issuer-등급))。Issuer 2 WORD はすべての値を使える。
- Codec 番号は 2 WORD である。Issuer が Kind に関係なく、自分の `codecs/` 内で重複しないように割り当てる。番号が足りなければ Issuer をもう 1 つ発行してもらう。
- Codec ドキュメントは、その Issuer の `<Issuer>/codecs/<Codec 番号>/` の下に置く([公表アドレスとバージョン一覧](../publishing.md#id-표기))。
- Issuer 形式のライセンスは、その Issuer が定める([Issuer と公表](../issuer.md#라이선스))。

## 関連ページ {#관련-페이지}

- [Edge — Issuer 形式 Edge](_index.md#issuer-형식-edge), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [レコードと TAG WORD](../record.md#issuer-형식-레코드), [Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001BD0/latest.geul` を `geul show` で読んだ姿である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
