---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID は、ドキュメントの次のバージョンが新しい記述に割り当てる LOCAL ID を、バージョン一覧に書く系譜 Meta だ(auto increment)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

そのドキュメントの次のバージョンが、新しい記述に割り当てる LOCAL ID を書く(DBMS の auto increment、MySQL `AUTO_INCREMENT`)。ドキュメントのどのバージョンでも、割り当てた LOCAL ID はすべてこの値より小さい。

## レイアウト

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           次に割り当てる LOCAL ID、最短幅の unsigned 整数
```

- Codec: Meta `0x3C`、系譜クラス(`011`)
- Payload: 生値(最短幅の unsigned 整数)
- 個数: 多くて一つ
- 置く場所: バージョン一覧ドキュメント `versions.geul` の HEAD([PUBLICATION](/ja/grammar/edge/publication/))

## 解釈と有効性

- LOCAL ID(Edge Id を含む)は、バージョンを越える同一性だ([改訂](/ja/grammar/document/#改訂))。新しい記述はこの値を受け取り、値は 1 増える。削除した LOCAL ID は再利用しない。そのため最大値を持つ記述が削除されても、この値は減らない。
- LOCAL ID `0` は割り当てないので、最初の値は `1` だ。まだバージョンがなければ、この Meta を置かず、次の番号は `1` だ。
- 公表元がバージョンを公表するとき、新しい一覧ドキュメントに更新して書く。公表したバージョンで使われたどの LOCAL ID よりも大きくなければならない。小さいか等しければ invalid だ。
- 値は増えるだけだ。直前の一覧ドキュメント([PARENT](/ja/grammar/meta/lineage/parent/))の値より小さければ invalid だ。
- バージョン管理をしないドキュメント(`versions.geul` のないドキュメント、名前のないドキュメント)にはない。そのようなドキュメントは diff([DELTA-BASE](/ja/grammar/meta/lineage/delta-base/))も置かない。
- ドキュメント本文(バージョンドキュメント)には置かない。番号の記憶は、ドキュメントの内容ではなく、ドキュメントを書き継ぐ公表元の状態だ(git のコミットではなく refs の側)。

## 例

次に割り当てる番号 524:

```
18BC 020C
```

- TAG `18BC`(Meta `0x3C`、`LLLL=0001`、2 WORD)、Payload `020C`。
