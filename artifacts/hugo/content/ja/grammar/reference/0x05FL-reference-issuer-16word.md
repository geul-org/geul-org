---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD は、Issuer が定義する Reference 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD は、Issuer が定義する Reference 形式だ。Reference 区画の末尾 3 つの枠の 1 つで、Issuer 幅が 16 WORD だ。3 つの Kind の ISSUER レイアウトは同じだ([レコードと TAG WORD](../record.md#issuer-형식-레코드))。

| 項目 | 値 |
|---|---|
| 名前 | `REFERENCE-ISSUER-16WORD` (規格ドキュメント BIND `REFERENCE-ISSUER-16WORD`) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| 規格ドキュメント | `0x00000000/codecs/0x000005F0/` (DECLARE 対象 `05F0`) |
| セクション | 2 `0010` (Reference その他)、セクション内オフセット C = 31 |
| Kind | Reference · 分類: Issuer 形式 |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Issuer 16 WORD と Codec 番号 2 WORD。形式は Issuer の Codec ドキュメントが定める |
| Hugo 側 | `reference/reference-issuer.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[Length 拡張 TAG]
Issuer            16 WORD
Codec 番号        2 WORD。Issuer が定義する
Payload           Issuer が発行した Codec ドキュメントが定める
```

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順だ([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 生値 16 WORD |  |  |
| 2 | `codec` | #3 | 生値 2 WORD |  |  |
| 3 | `payload` | #4 | 残り全部の生値(`0xFFFF`) |  |  |

`payload` の構成は、その Issuer の Codec ドキュメントが定める。

## 解釈と有効性 {#해석과-유효성}

- GEUL は Length で Payload の境界だけを知る。形式を知らないデコーダは、Kind、Length、Issuer、Codec 番号までを知り、Length で読み飛ばす。
- Codec 番号の意味、量化、何を指すかは、Issuer が発行した Codec ドキュメントが定める。対象 ID の最短幅、量化の読みといった Reference 共通規則は適用されない([REFERENCE-ISSUER](_index.md#해석과-유효성))。
- Issuer は値が収まる最短幅で書く([Issuer と公表](../issuer.md#issuer-등급))。Issuer 値の上位 12 WORD が 0 なら invalid だ。その値はより狭い幅のコードで書く。
- Codec 番号は 2 WORD だ。Issuer が Kind と無関係に自分の `codecs/` の中で重ならないように割り当てる。番号が足りなければ Issuer をもう 1 つ発行してもらう。
- Codec ドキュメントは、その Issuer の `<Issuer>/codecs/<Codec 番号>/` の下に置く([公表アドレスとバージョン一覧](../publishing.md#id-표기))。
- Issuer 形式のライセンスは、その Issuer が定める([Issuer と公表](../issuer.md#라이선스))。

## 関連ページ {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer)、[REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)、[REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [レコードと TAG WORD](../record.md#issuer-형식-레코드)、[Issuer と公表](../issuer.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000005F0/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
