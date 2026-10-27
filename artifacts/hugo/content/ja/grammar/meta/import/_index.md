---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Meta IMPORT クラス(上位3ビット `110`、`0x60`~`0x6F`)は、外部ドキュメントを IMPORT ID で取り込む。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta IMPORT クラス(上位3ビット `110`、Codec `0x60`~`0x6F`)は、外部ドキュメントを IMPORT ID で取り込む。Codec は `IMPORT-DOC`(`0x60`)一つだ。

- IMPORT はドキュメントだけを取り込む。取り込んだドキュメント内の対象は、BODY の Reference `EXTERNAL-POINTER-*`(IMPORT ID、LOCAL ID)で指す([Reference](/ja/grammar/reference/))。
- バージョン ID を書けばその版に、`0` なら解釈時点の最新の版に結びつく。公表ドキュメントはバージョンを書く。
- 取り込んだドキュメントの HEAD は取り込まない。Reference・Value レコードは取り込まずにコピーする。
