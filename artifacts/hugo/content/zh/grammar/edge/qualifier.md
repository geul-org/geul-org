---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER 是为另一个 Edge（主要是 TRIPLE）的命题附加一个限定条件的叙述 Edge（Codec 0x0B）。Value 可以用未知（UNKNOWN-VALUE）或无（NO-VALUE）代替值。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER 是为另一个 Edge（主要是 [TRIPLE](/zh/grammar/edge/triple/)）所含的命题附加一个限定条件的叙述 Edge。Codec `0x0B`。

与 Wikidata 的一个 qualifier（snak）相同：一个属性和一个值。

## 布局

```
TAG WORD          0001 0LLL L000 1011
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Property          Reference 记录 (WIKIDATA-PID 等)
Target            LOCAL Reference 记录 (被限定的 Edge 的 Edge Id)
Value             Reference 或 Value 记录，或占位标记 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
```

- 构成要素的顺序与 TRIPLE 相同（Property ↔ Predicate，Target ↔ Subject，Value ↔ Object）。解码器走相同的路径读取。角色由 Codec 决定。

## 解读与有效性

- Property、Target 恰好是一个完整的 Reference 记录，Target 是 LOCAL Reference。geul.org 规格文档给 Target 放 [CODEC](/zh/grammar/edge/codec/) LOCAL（`0008`）。Value 恰好是一个完整的 Reference 或 Value 记录，或[占位标记](/zh/grammar/reference/slot-marker/) `0x0001`（UNKNOWN-VALUE）·`0x0002`（NO-VALUE）1 WORD。规格文档给 Value 放 CODEC `0780`、`0F80`、`0001`、`0002`。不接受 ABSENT（`0x0000`）。Property·Target 不接受占位标记。读完 Value 的游标必须与 Edge 末尾吻合。
- Target 是同一文档内的 Edge Id。QUALIFIER 与被限定的 Edge 放在同一文档中。
- 如果 Target 是 HEAD 的 [SOURCE](/zh/grammar/edge/source/#整个文档的来源)（整个文档的来源），则 QUALIFIER 也放在 HEAD 中，并放在该 SOURCE 之后。其他 QUALIFIER 放在 BODY 中。以 HEAD SOURCE 为 Target 的 QUALIFIER 出现在 BODY 中则 invalid。
- Target 除 TRIPLE 外也可以是其他 Edge。附在 [SOURCE](/zh/grammar/edge/source/) 上的 QUALIFIER 限定引用行为（查阅日、来源内的位置等）。SOURCE 的含义也是指向它的所有 QUALIFIER 的总和。
- **QUALIFIER 是命题的一部分。** 它不是关于命题的单独主张，而是限定命题成立的条件。目标 TRIPLE 的含义是指向它的所有 QUALIFIER 的总和。
  - 命题的出处用 [SOURCE](/zh/grammar/edge/source/) 来写。来源节点的属性（标题、作者等）用以来源为 Subject 的 TRIPLE 来写。
- 同一 Target 上可以有多个相同 Property 的 QUALIFIER。同一 Target 的 QUALIFIER 顺序是文档内顺序（Edge 顺序有意义的例外）。

## 未知与无

QUALIFIER 的 Value 是占位标记时，该限定的含义会改变。以终止时点（P582）为例。

| 附在目标 TRIPLE 上的内容 | 含义 | 是否仍是现在有效的命题 |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | 1974 年结束 | 否 |
| `QUALIFIER P582 #n UNKNOWN` | 已结束。不知道何时（Wikidata `somevalue`） | 否 |
| `QUALIFIER P582 #n NONE` | 断言未结束（Wikidata `novalue`） | 是 |
| 没有 P582 QUALIFIER | 不知道是否已结束（开放世界） | 不知道 |

- 如果丢弃 Wikidata qualifier 的 `somevalue`·`novalue`，命题就会变宽。丢弃了终止时点 somevalue 的边界 TRIPLE，会被读成"现在仍有效的边界"。因此转换时要用标记来转换。
- UNKNOWN-VALUE 之间不视为相同的值。比较结果未定。

## 示例（非规范）

Q42 P69(educated at) Q691283(St John's College)，1971~1974。

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`：TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD。Value 是 [EDTF](/zh/grammar/value/time/edtf/) `"1971"`。

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Q30（美国）–Q34266（俄罗斯帝国）边界（P47），终止时点未知。Edge Id `2060`·`3160`。

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`：Edge，8 WORD，Codec `0x0B`。TAG 1 + Edge Id 2 + Property P582（`00A8 0246`）2 + Target #2060（`0088 080C`）2 + 标记 1。

给 Q30 中央银行（P1304）NO-VALUE TRIPLE `#3161` 附上期间。只在 1811~1816 年没有。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[TRIPLE](/zh/grammar/edge/triple/)、[SOURCE](/zh/grammar/edge/source/)、[WIKIDATA-PID](/zh/grammar/reference/wikidata-pid/)、[EDTF](/zh/grammar/value/time/edtf/)、[占位标记](/zh/grammar/reference/slot-marker/)
