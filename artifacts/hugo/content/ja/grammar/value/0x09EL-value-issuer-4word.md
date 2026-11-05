---
title: "VALUE-ISSUER-4WORD (0x09EL)"
weight: 158
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-4WORD は Issuer が定義する Value 形式である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-4WORD は Issuer が定義する Value 形式である。Value 区画の末尾三つの枠の一つで、Issuer 幅が 4 WORD である。三つの Kind の ISSUER レイアウトは同じである([レコードと TAG WORD](../record.md#issuer-형식-레코드))。

| 項目 | 値 |
|---|---|
| 名前 | `VALUE-ISSUER-4WORD` (規格ドキュメント BIND `VALUE-ISSUER-4WORD`) |
| TAG ID | `0x09EL` |
| Codec ID | `0x000009E0` |
| 規格ドキュメント | `0x00000000/codecs/0x000009E0/` (DECLARE の対象 `09E0`) |
| セクション | 4 `0100` (Value)、セクション内オフセット C = 30 |
| Kind | Value · 分類: Issuer 形式 |
| TAG WORD | `0000 1001 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Issuer 4 WORD と Codec 番号 2 WORD。形式は Issuer の Codec ドキュメントが定める |
| Hugo 側 | `value/_index.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 1001 1110 LLLL      Codec 0x09EL
[Length 拡張 TAG]
Issuer            4 WORD
Codec 番号        2 WORD. Issuer が定義する
Payload           Issuer が発行した Codec ドキュメントが定める
```

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 生値 4 WORD |  |  |
| 2 | `codec` | #3 | 生値 2 WORD |  |  |
| 3 | `payload` | #4 | 残り生値(`0xFFFF`) |  |  |

`payload` の構成はその Issuer の Codec ドキュメントが定める。

## 解釈と有効性 {#해석과-유효성}

- GEUL は Length で Payload の境界だけを知る。形式を知らないデコーダは、Kind、Length、Issuer、Codec 番号までを知り、Length で読み飛ばす。
- Payload の解釈は Issuer の Codec ドキュメントが定める。現在登載している Issuer 形式の Value は [Codec 索引](../codec-index.md#value-issuer-형식)にある。
- Issuer は値が入る最も短い幅で書く([Issuer と公表](../issuer.md#issuer-등급))。Issuer 値の上位 2 WORD が 0 なら invalid である。その値は 2 WORD コード([VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md))で書く。
- Codec 番号は 2 WORD である。Issuer が Kind と関係なく自分の `codecs/` の中で重ならないように割り当てる。番号が足りなければ Issuer をもう一つ発行してもらう。
- Codec ドキュメントはその Issuer の `<Issuer>/codecs/<Codec 番号>/` の下に置く([公表アドレスとバージョン一覧](../publishing.md#id-표기))。
- Issuer 形式のライセンスはその Issuer が定める([Issuer と公表](../issuer.md#라이선스))。

## 関連ページ {#관련-페이지}

- [Value — Issuer 形式](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [レコードと TAG WORD](../record.md#issuer-형식-레코드), [Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000009E0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009E000000000
BODY
#1 DECLARE 0x09E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
