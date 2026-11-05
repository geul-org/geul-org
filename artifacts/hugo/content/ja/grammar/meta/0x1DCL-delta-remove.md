---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "diff(DELTA-BASE)で、基準スナップショットの BODY から除くレコードの LOCAL ID(Edge Id)を記す(\"第X条削除\")。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DELTA-REMOVE` (規格ドキュメント BIND `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DC0/` (DECLARE 対象 `1DC0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 28 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | diff で基準 BODY から除く LOCAL ID(Edge Id)の一覧 |
| Hugo 側 | `meta/lineage/delta-remove.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | 残り生値(`0xFFFF`) |  |  |

diff([DELTA-BASE](0x1DBL-delta-base.md))で、基準スナップショットの BODY から除くレコードの LOCAL ID(Edge Id)を記す("第X条削除")。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length 拡張 TAG]
削除対象 LOCAL ID  LOCAL Reference レコード × 1 以上
```

- Codec: Meta `0x1DCL`、系譜クラス
- Payload: [LOCAL](../reference/0x005L-local.md) Reference レコード 1 つ以上
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- `DELTA-BASE` のあるドキュメントにのみ置く。
- 各 LOCAL ID は、基準スナップショットの BODY にある Edge Id でなければならない。なければ invalid である。同じ ID を 2 回置くと invalid である。
- 同じ diff の BODY に同じ Edge Id を再び置くと invalid である(削除と改訂を同時にはできない)。
- 削除した LOCAL ID は、以降のバージョンで別の対象に再び割り当てない([改訂](../document.md#개정))。
- diff BODY にレコードがないことは「変更なし」を意味する。そのため削除はこの Meta だけで表現する。
- HEAD Edge(ドキュメント全体の [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)とその QUALIFIER)は記さない。HEAD は diff の HEAD として丸ごと置き換わる([diff の保存](../document.md#diff-저장))。

## 例 {#예시}

LOCAL `#7` と `#12` を削除:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4`(Meta `0x1DCL`、`LLLL=0100`、5 WORD)、LOCAL Reference `0051 0007`、`0051 000C`。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DC0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
