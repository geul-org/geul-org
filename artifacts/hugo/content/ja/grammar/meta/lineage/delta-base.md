---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE は、このバージョンのファイルが同じドキュメントの基準バージョンに対する diff であることを示す系譜 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このバージョンのファイルが、スナップショットではなく同じドキュメントの基準バージョンに対する **diff** だという標識だ(git packfile の delta)。バージョン自体は引き続きスナップショットで定義される。コンテンツハッシュ、バージョン一覧、署名は、すべて diff を適用して復元したスナップショットが基準だ([diff 保存](/ja/grammar/document/#diff-保存))。

## レイアウト

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
バージョン ID     2 WORD unsigned (同じドキュメントの基準バージョン)
```

- Codec: Meta `0x3A`、系譜クラス(`011`)
- Payload: 2 WORD のバージョン ID(生値)
- 個数: 多くて一つ

## 解釈と有効性

- [DOC-ID](/ja/grammar/meta/declaration/doc-id/) のあるドキュメント(バージョン一覧でバージョンを管理するドキュメント)にだけ使う。バージョン管理をしない `versions.geul`・`documents.geul`・`issuers.geul` と、名前のないドキュメントは diff にしない。
- 基準バージョンは、同じ `DOC-ID` の公表されたバージョンで、このバージョンより前だ。`0`(バージョンなし)は invalid だ。
- 復元したスナップショットのコンテンツハッシュが、バージョン一覧([PUBLICATION](/ja/grammar/edge/publication/))のこのバージョンのハッシュと同じでなければならない。異なればこの diff は invalid だ。そのため diff の中に結果のハッシュを別に書かない。
- BODY のすべてのレコードが Edge(Edge Id のあるレコード)であるドキュメントだけが diff にできる。diff の単位が LOCAL ID(Edge Id)だからだ。
- スナップショットの復元規則は、[diff 保存](/ja/grammar/document/#diff-保存)に従う。削除は [DELTA-REMOVE](/ja/grammar/meta/lineage/delta-remove/) が担う。
- 追加・改訂の標識は別に置かない。diff BODY の Edge Id が基準にあれば改訂、なければ追加だ。追加は、バージョン一覧の [NEXT-LOCAL-ID](/ja/grammar/meta/lineage/next-local-id/) から番号を受け取る。削除した LOCAL ID を再利用すれば invalid だ([改訂](/ja/grammar/document/#改訂))。

## 例

基準バージョン 3 に対する diff:

```
193A 0000 0003
```

- TAG `193A`(Meta `0x3A`、`LLLL=0010`、3 WORD)、バージョン ID `0000 0003`。

## 未解決の問題

1. スナップショットの間隔: 何バージョンごとに全体のスナップショットを置くか(diff チェーンの長さと復元コスト)。
2. 基準バージョンを直前のバージョンに限定するか。
3. diff ファイルの保存位置: バージョンファイルの位置(`<バージョン ID>.geul`)に置くか、コンテンツアドレスストア `h/` との関係(`h/` はスナップショットのコンテンツハッシュで探す)。
