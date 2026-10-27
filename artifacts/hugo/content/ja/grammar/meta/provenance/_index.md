---
title: "Meta — 出典"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Meta 出典クラス(上位3ビット `010`、`0x20`~`0x2F`)は、ドキュメントを誰がいつ作り記録したかを書く。原典資料は根拠 Edge SOURCE で書く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 出典クラス(上位3ビット `010`、Codec `0x20`~`0x2F`)は、ドキュメントを誰がいつ作り、記録したかを書く。

- 作成者・記録者とその時刻は、git の author・committer モデルに従う(`AUTHOR`・`CREATED-AT`、`RECORDED-BY`・`RECORDED-AT`)。
- 出典は、消しても記述の内容が変わらない。信頼判断の材料だけが失われる。
- 原典資料はこのクラスにない。ドキュメント全体の原典は HEAD に、個々のレコードの原典は BODY に、根拠 Edge [SOURCE](/ja/grammar/edge/source/) として書く。原文内の対応範囲、入手時刻、原文ハッシュは、その SOURCE に付く QUALIFIER だ(ページ P304・節 P958、参照日 P813、チェックサム P4092)。
- 原典に付随する性質(原文範囲、入手時刻)を Meta に置くと、原典が複数あるとき、どの原典のものか決められない。そのため SOURCE を Target とする QUALIFIER で書く。Codec `0x26`~`0x2F` は予約だ。
