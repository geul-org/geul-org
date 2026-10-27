---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE は、diff で基準スナップショットの BODY から除く LOCAL ID(Edge Id)の一覧を書く系譜 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

diff([DELTA-BASE](/ja/grammar/meta/lineage/delta-base/))で、基準スナップショットの BODY から除くレコードの LOCAL ID(Edge Id)を書く(「第X条削除」)。

## レイアウト

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length 拡張 TAG]
削除する LOCAL ID  LOCAL Reference レコード × 1 以上
```

- Codec: Meta `0x3B`、系譜クラス(`011`)
- Payload: [LOCAL](/ja/grammar/reference/local/) Reference レコード一つ以上
- 個数: 多くて一つ

## 解釈と有効性

- `DELTA-BASE` のあるドキュメントにだけ置く。
- 各 LOCAL ID は、基準スナップショットの BODY にある Edge Id でなければならない。なければ invalid だ。同じ ID を二度置けば invalid だ。
- 同じ diff の BODY に同じ Edge Id を再び置けば invalid だ(削除と改訂を一緒に行えない)。
- 削除した LOCAL ID は、以後のバージョンで他の対象に再び割り当てない([改訂](/ja/grammar/document/#改訂))。
- diff BODY にレコードがないことは「変わらない」だ。そのため削除は、この Meta でのみ表現する。
- HEAD Edge(ドキュメント全体の [SOURCE](/ja/grammar/edge/source/#ドキュメント全体の出典)とその QUALIFIER)は書かない。HEAD は diff の HEAD でまるごと置き換わる([diff 保存](/ja/grammar/document/#diff-保存))。

## 例

LOCAL `#7` と `#12` を削除:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B`(Meta `0x3B`、`LLLL=0100`、5 WORD)、LOCAL Reference `0088 0007`、`0088 000C`。
