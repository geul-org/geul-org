---
title: "Meta — 定義"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Meta 定義クラス(上位3ビット `001`、`0x10`~`0x1F`)は解釈の宣言だ。仕様の版、プロファイル、ドキュメント ID、施行期間、既定の言語を定める。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 定義クラス(上位3ビット `001`、Codec `0x10`~`0x1F`)は、解釈の宣言だ。宣言は解釈規則を変えるので、すべてのデコーダが処理しなければならない。宣言の範囲は、そのドキュメントだ。

- `SPEC-VERSION` は、残りのレコードをどう読むかを決めるので、組み込み Value なしで整数だけを置く。GEUL v1 は `0x0001`(レコード `1890 0001`)だ。
- `DOC-ID` は、そのドキュメント自身を指す `DOC-POINTER`(Issuer、ドキュメント ID、バージョン `0`)だ。なければ名前のないドキュメントで、コンテンツハッシュでのみ指せる。
- ドキュメントのアドレス用の名前は Meta に置かない。Issuer の名前索引 `documents.geul` が記述 `BIND` で付け、人が読むタイトルは `LABEL` で付ける([公表アドレスとバージョン一覧](/ja/grammar/publishing/#ドキュメント名))。
