---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID は、ドキュメント自身を指す DOC-POINTER(Issuer、ドキュメント ID、バージョン 0)でドキュメントの識別子を宣言する定義 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

このドキュメントの識別子を宣言する。他のドキュメントがこのドキュメントとその中の対象を指すために必要だ。

## レイアウト

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length 拡張 TAG]
ドキュメント      DOC-POINTER Reference レコード。(Issuer, ドキュメント ID, バージョン 0)
```

- Codec: Meta `0x12`、定義クラス(`001`)
- Payload: 組み込み Reference [DOC-POINTER](/ja/grammar/reference/doc-pointer/)(Issuer、ドキュメント ID、バージョン 0)一つ
- 個数: 多くて一つ。名前が `0x` で始まるドキュメントは必須

## 解釈と有効性

- Payload は、`DOC-POINTER`(Issuer、ドキュメント ID、バージョン `0`)Reference レコードがちょうど一つだ。バージョン ID は `0` だけを使う。バージョンはドキュメントではなく、バージョン一覧が割り当てる。Quantifier は `000` だ。
- そのため「このドキュメント」を指す表記が、DOC-ID、`documents.geul` の [BIND](/ja/grammar/edge/bind/) の Subject、他のドキュメントの引用で、すべて同じになる。
- バージョンに関係なく、同じドキュメントは同じ `DOC-ID` だ。バージョン ID とコンテンツハッシュはドキュメントに書かない([バージョン](/ja/grammar/document/#バージョン))。
- アドレス用の名前は、名前索引 `documents.geul` の記述 `BIND` が([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))、人が読むタイトルは記述 [LABEL](/ja/grammar/edge/label/) が担う。
- なければ名前のないドキュメントで、コンテンツハッシュでのみ指せる。他のドキュメントがこのドキュメントの LOCAL を指示 Reference で指すために必要だ。
- ドキュメントを取り込む側は、受け取ったドキュメントの `DOC-ID` が、要求した Issuer・ドキュメント ID と同じか検証する。
- ドキュメント ID `0x0000000000000000` は、Issuer の用語定義インデックスドキュメントだ([Issuer](/ja/grammar/issuer/))。このドキュメントも名前が `0x` で始まるので、DOC-ID(`DOC-POINTER`(Issuer、`0`、`0`))を置く。Issuer 自身は [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/) が代表する。
- `.well-known/geul/` 配下で名前が `0x` で始まるドキュメント(バージョンドキュメント `<バージョン ID>.geul`、規格ドキュメント)は、`DOC-ID` が必須だ。
- 名前が `0x` で始まらないドキュメントは、例外として `DOC-ID` を置かない: バージョン一覧 `versions.geul`([PUBLICATION](/ja/grammar/edge/publication/))、ドキュメント名前索引 `documents.geul`、Issuer 名前索引 `issuers.geul`([公表アドレスとバージョン一覧](/ja/grammar/publishing/))。コンテンツハッシュのストア `h/` は、上のドキュメントのコピーなので、元に従う。
- Codec 規格ドキュメントは、GEUL Issuer `0x0000` のドキュメントだ。ドキュメント ID は Kind・Codec TAG WORD を 4 WORD に伸ばした値だ(`0x1018` → `0x0000000000001018`)。Reference `0000` は予約なので、ドキュメント ID が `0` にはならない([規格ドキュメント](/ja/grammar/codec-spec/))。

## 例

- Issuer `0x0001`、ドキュメント `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 1 + ドキュメント ID 4 + バージョン 2 = 9 WORD)
