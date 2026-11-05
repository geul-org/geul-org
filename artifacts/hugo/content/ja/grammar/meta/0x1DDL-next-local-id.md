---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "そのドキュメントの次のバージョンが新しい叙述に割り当てる LOCAL ID を記す(DBMS の auto increment、MySQL AUTO_INCREMENT)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `NEXT-LOCAL-ID` (規格ドキュメント BIND `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DD0/` (DECLARE 対象 `1DD0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 29 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 次に割り当てる LOCAL ID (auto increment)。バージョン一覧 `versions.geul` の HEAD に置く |
| Hugo 側 | `meta/lineage/next-local-id.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | 残り生値(`0xFFFF`) |  |  |

そのドキュメントの次のバージョンが新しい叙述に割り当てる LOCAL ID を記す(DBMS の auto increment、MySQL `AUTO_INCREMENT`)。ドキュメントのどのバージョンでも、割り当てた LOCAL ID はすべてこの値より小さい。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           次に割り当てる LOCAL ID、最も短い幅の unsigned 整数
```

- Codec: Meta `0x1DDL`、系譜クラス
- Payload: 生値(最も短い幅の unsigned 整数)
- 個数: 多くても 1 つ
- 置く場所: バージョン一覧ドキュメント `versions.geul` の HEAD([PUBLICATION](../edge/0x0B8L-publication.md))

## 解釈と有効性 {#해석과-유효성}

- LOCAL ID(Edge Id を含む)はバージョンをまたぐ同一性である([改訂](../document.md#개정))。新しい叙述はこの値を受け取り、値は 1 増える。削除した LOCAL ID は再び使わない。そのため、最大値を持つ叙述が削除されてもこの値は減らない。
- LOCAL ID `0` は割り当てないので、最初の値は `1` である。まだバージョンがなければこの Meta を置かず、次の番号は `1` である。
- 公表元がバージョンを公表するとき、新しい一覧ドキュメントに更新して記す。公表したバージョンで使われたどの LOCAL ID よりも大きくなければならない。小さいか等しければ invalid である。
- 値は増えるだけである。直前の一覧ドキュメント([PARENT](0x1D1L-parent.md))の値より小さければ invalid である。
- バージョン管理をしないドキュメント(`versions.geul` のないドキュメント、名前のないドキュメント)にはない。そのようなドキュメントには diff([DELTA-BASE](0x1DBL-delta-base.md))も置かない。
- ドキュメント本文(バージョンドキュメント)には置かない。番号の記憶はドキュメントの内容ではなく、ドキュメントを書き継ぐ公表元の状態である(git のコミットではなく refs 側)。

## 例 {#예시}

次の割り当て番号 524:

```
1DD1 020C
```

- TAG `1DD1`(Meta `0x1DDL`、`LLLL=0001`、2 WORD)、Payload `020C`。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DD0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
