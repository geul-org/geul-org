---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE は、ドキュメントに適用したプロファイルを名前とバージョンのテキストで宣言する定義 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントに適用したプロファイルを宣言する。同じレコードを、プロファイルが定めた Codec ドキュメントで解釈する(例: `tangeul-1.0` なら [TOULMIN](/ja/grammar/edge/toulmin/))。

## レイアウト

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length 拡張 TAG]
Payload           UTF8-TEXT Value "<名前>-<major>.<minor>"
```

- Codec: Meta `0x11`、定義クラス(`001`)
- Payload: 組み込み Value([UTF8-TEXT](/ja/grammar/value/text/utf8-text/))
- 個数: 多くて一つ

## 解釈と有効性

- major が異なるプロファイルは拒否する。minor の違いは許容する(追加の変更のみ)。
- プロファイルがなければ、GEUL の基本文法と直接コード規格だけで読む。

## 例

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## 未解決の問題

- プロファイル名レジストリ(geul.org)と名前の規則。
- プロファイルをドキュメント ID で指すか(IMPORT)、テキストで置くか。
