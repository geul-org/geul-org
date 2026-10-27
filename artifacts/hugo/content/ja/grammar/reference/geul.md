---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL は、geul.org が CC0 で発行するエンティティ ID で対象を指す宣言 Reference だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL は、geul.org が CC0 で発行するエンティティを指す宣言 Reference だ。番号に意味を載せない連番 ID だ。ビットに意味を載せる識別子は、別の Codec [GEUL-SIDX](/ja/grammar/reference/geul-sidx/)(`0011`)が担う。

## レイアウト

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length 拡張 TAG]
GEUL ID           最短幅の unsigned big-endian
```

- 小さい番号を高頻度のエンティティに割り当てる。1 WORD に収まる ID は、全体で 2 WORD だ。
- ID の割り当てとレジストリは、geul.org が管理する。レジストリには CC0 の原典から出たものだけを入れる。
- Variable ならその種類の匿名変数だ([Reference](/ja/grammar/reference/) の Variable)。

## 例

| GEUL ID | WORD sequence |
|---|---|
| 1、Identified | `0090 0001` |
| 1、Variable | `0094 0001` |
| 70000、Generic | `0111 0001 1170` |

## 未解決の問題

- GEUL ID の割り当て規則とレジストリの公開形式。

## 関連ページ

- [Reference](/ja/grammar/reference/)、[GEUL-SIDX](/ja/grammar/reference/geul-sidx/)
