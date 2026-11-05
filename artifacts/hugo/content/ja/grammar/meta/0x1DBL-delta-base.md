---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "このバージョンファイルがスナップショットではなく、同じドキュメントの基準バージョンに対する diff であることを示すマーカーである(git packfile の delta)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `DELTA-BASE` (規格ドキュメント BIND `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DB0/` (DECLARE 対象 `1DB0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 27 |
| Kind | Meta · クラス: 系譜 |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | このバージョンファイルは同じドキュメントの基準バージョン(2 WORD のバージョン ID)に対する diff である (git packfile delta) |
| Hugo 側 | `meta/lineage/delta-base.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 生値 2 WORD | `0620` UNSIGNED-INTEGER |  |

このバージョンファイルがスナップショットではなく、同じドキュメントの基準バージョンに対する **diff** であることを示すマーカーである(git packfile の delta)。バージョン自体は依然としてスナップショットとして定義される。コンテンツハッシュ、バージョン一覧、署名はすべて、diff を適用して復元したスナップショットが基準である([diff の保存](../document.md#diff-저장))。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
バージョン ID     2 WORD unsigned (同じドキュメントの基準バージョン)
```

- Codec: Meta `0x1DBL`、系譜クラス
- Payload: 2 WORD のバージョン ID(生値)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- [DOC-ID](0x1C7L-doc-id.md) のあるドキュメントにのみ使う。`DOC-ID` を置かないバージョン一覧 `versions.geul`、一覧ドキュメント(`issuers/` のバージョン)、名前のないドキュメントには diff を置かない。
- 基準バージョンは同じ `DOC-ID` の公表済みバージョンであり、このバージョンより前のものである。`0`(バージョンなし)は invalid である。
- 復元したスナップショットのコンテンツハッシュが、バージョン一覧([PUBLICATION](../edge/0x0B8L-publication.md))のこのバージョンのハッシュと同じでなければならない。異なる場合、この diff は invalid である。そのため diff の中に結果のハッシュを別途記さない。
- BODY のすべてのレコードが Edge(Edge Id を持つレコード)であるドキュメントだけが diff にできる。diff の単位が LOCAL ID(Edge Id)だからである。
- スナップショットの復元規則は [diff の保存](../document.md#diff-저장)に従う。削除は [DELTA-REMOVE](0x1DCL-delta-remove.md) が担う。
- 追加・改訂のマーカーは別に置かない。diff BODY の Edge Id が基準にあれば改訂、なければ追加である。追加はバージョン一覧の [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) から番号を受ける。削除した LOCAL ID を再び使うと invalid である([改訂](../document.md#개정))。

## 例 {#예시}

基準バージョン 3 に対する diff:

```
1DB2 0000 0003
```

- TAG `1DB2`(Meta `0x1DBL`、`LLLL=0010`、3 WORD)、バージョン ID `0000 0003`。

## 未解決の問題 {#열린-문제}

1. スナップショットの間隔: 何バージョンごとに完全なスナップショットを置くか(diff チェーンの長さと復元コスト)。
2. 基準バージョンを直前のバージョンに限定するか。
3. diff ファイルの保存場所: バージョンファイルの位置(`<バージョン ID>.geul`)に置くか、コンテンツハッシュアドレス `<Issuer>/hashes/` との関係(`hashes/` はスナップショットのコンテンツハッシュで探す)。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DB0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
