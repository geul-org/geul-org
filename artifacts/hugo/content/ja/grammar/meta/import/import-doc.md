---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC は、外部ドキュメントを DOC-POINTER で指して IMPORT ID を割り当てる IMPORT Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

外部ドキュメントを IMPORT ID で取り込む。取り込むドキュメントは [DOC-POINTER](/ja/grammar/reference/doc-pointer/) が指し、Issuer の幅も DOC-POINTER が持つ。

## レイアウト

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length 拡張 TAG]
ドキュメント      DOC-POINTER Reference レコード (Issuer, ドキュメント ID, バージョン ID。バージョン 0 なら最新)
IMPORT ID         残りすべて。最短幅の unsigned
```

- Codec: Meta `0x60`、IMPORT クラス(`110`)
- Payload: 組み込み Reference `DOC-POINTER`(Issuer、ドキュメント ID、バージョン ID)+ IMPORT ID 生値
- 個数: 複数可(IMPORT ID ごとに一つ)

## 解釈と有効性

- ドキュメントは、ちょうど一つの DOC-POINTER レコードだ。自分の Length で終わり、残りが IMPORT ID だ。
- IMPORT ID は 1 WORD 以上で、最短幅だ。IMPORT ID の幅は、ここではレコードの長さで、[EXTERNAL-POINTER-*](/ja/grammar/reference/external-pointer/) では Codec で決まる。IMPORT ID は、そのドキュメント内でのみ有効だ。
- 一つのドキュメントで同じ IMPORT ID を二度割り当てない。
- バージョン ID を書けばその版に、`0` なら解釈時点の最新(または指定した時点で施行中)の版にバインドされる([改訂](/ja/grammar/document/#改訂))。
- BODY の [EXTERNAL-POINTER-*](/ja/grammar/reference/external-pointer/) が、IMPORT ID で取り込んだドキュメントの LOCAL を指す。取り込んだドキュメント自身は DOC-POINTER で指す。
- 取り込んだドキュメントの HEAD は取り込まない。そのドキュメントの対象は、そのドキュメントの宣言どおりに解釈する。
- IMPORT ID では、ドキュメントをまたいで検索できない。複数のドキュメントを格納するストアは、IMPORT ID を完全なパス(Issuer、ドキュメント ID、バージョン ID、LOCAL ID)に展開して保存する。

## 例

- IMPORT ID 1、Issuer `0x0001`、ドキュメント `0x…0002`、最新: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
