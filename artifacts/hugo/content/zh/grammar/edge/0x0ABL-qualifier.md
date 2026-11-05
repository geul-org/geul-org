---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER 是附加一个条件来限定其他 Edge（主要是 TRIPLE）所承载命题的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `QUALIFIER`（规格文档 BIND `QUALIFIER`） |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| 规格文档 | `0x00000000/codecs/0x00000AB0/`（DECLARE 目标 `0AB0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 11 |
| Kind | Edge · 系列：陈述，分组：命题 |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 限定其他 Edge 命题的一个条件。Property、Target（Edge Id）、Value（值或 UNKNOWN-VALUE·NO-VALUE 标记）。是命题的一部分 |
| Hugo 侧 | `edge/qualifier.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `target` | #3 | 记录 | `0050` LOCAL |  |
| 3 | `value` | #4 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`060F` 章节 3 全部（通配符，Value），`080F` 章节 4 全部（通配符，Value），`0010` UNKNOWN-VALUE，`0020` NO-VALUE |  |

QUALIFIER 是附加一个条件来限定其他 Edge（主要是 [TRIPLE](0x0AAL-triple.md)）所承载命题的陈述 Edge。Codec `0x0ABL`。

等同于一个维基数据 qualifier（snak）：一个属性和一个值。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Property          Reference 记录 (WIKIDATA-PID 等)
Target            LOCAL Reference 记录 (被限定 Edge 的 Edge Id)
Value             Reference 或 Value 记录，或占位标记 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- 组成部分的顺序与 TRIPLE 相同（Property ↔ Predicate，Target ↔ Subject，Value ↔ Object）。解码器走同一条路径读取。角色由 Codec 规定。

## 解释与有效性 {#해석과-유효성}

- Property、Target 是恰好一条完整的 Reference 记录，Target 是 LOCAL Reference。geul.org 规格文档给 Target 放 [CODEC](0x0BEL-codec.md) LOCAL（`0050`）。Value 是恰好一条完整的 Reference 或 Value 记录，或 1 WORD 的[占位标记](../slot-marker.md) `0x0010`（UNKNOWN-VALUE）·`0x0020`（NO-VALUE）。规格文档给 Value 放 CODEC `000F`、`020F`、`040F`（任意 Reference），`060F`、`080F`（任意 Value），`0010`，`0020`。不接受 ABSENT（`0x0000`）。Property、Target 不接受占位标记。读完 Value 的游标必须与 Edge 末尾吻合。
- Target 是同一文档内的 Edge Id。QUALIFIER 与被限定的 Edge 放在同一文档中。
- 若 Target 是 HEAD 的 [SOURCE](0x0C0L-source.md#문서-전체의-출처)（整个文档的来源），则 QUALIFIER 也放在 HEAD 中，位于该 SOURCE 之后。其他 QUALIFIER 放在 BODY 中。以 HEAD SOURCE 为 Target 的 QUALIFIER 出现在 BODY 中则为 invalid。
- Target 可以是 TRIPLE 之外的其他 Edge。附加在 [SOURCE](0x0C0L-source.md) 上的 QUALIFIER 限定引用行为（查阅日期、来源内的位置等）。SOURCE 的含义同样是指向它的所有 QUALIFIER 汇集在一起的结果。
- **QUALIFIER 是命题的一部分。** 它不是关于命题的单独主张，而是限定命题成立的条件。目标 TRIPLE 的含义是指向它的所有 QUALIFIER 汇集在一起的结果。
  - 命题的出处用 [SOURCE](0x0C0L-source.md) 书写。来源节点的属性（标题、作者等）用以来源为 Subject 的 TRIPLE 书写。
- 同一 Target 上可以有多个相同 Property 的 QUALIFIER。同一 Target 的 QUALIFIER 顺序就是文档内的顺序（赋予 Edge 顺序以含义的例外）。

## 未知与无 {#알-수-없음과-없음}

QUALIFIER 的 Value 若是占位标记，该限定的含义就会改变。以终止时点（P582）为例。

| 附加在目标 TRIPLE 上的内容 | 含义 | 是否仍是有效命题 |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | 1974 年结束 | 否 |
| `QUALIFIER P582 #n UNKNOWN` | 已结束。不知道何时（维基数据 `somevalue`） | 否 |
| `QUALIFIER P582 #n NONE` | 断言尚未结束（维基数据 `novalue`） | 是 |
| 没有 P582 QUALIFIER | 不知道是否已结束（开放世界） | 不知道 |

- 舍弃维基数据 qualifier 的 `somevalue`·`novalue` 会使命题范围变宽。舍弃了终止时点 somevalue 的边界 TRIPLE 会被读成"至今仍有效的边界"。因此转换时以标记转换。
- UNKNOWN-VALUE 之间不视为同一个值。比较结果未定。

## 示例（非规范） {#예시-비규범}

Q42 P69（educated at）Q691283（St John's College），1971~1974。

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`：TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD。Value 是 [EDTF](../value/0x06EL-edtf.md) `"1971"`。

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Q30（美国）–Q34266（俄罗斯帝国）边界（P47），终止时点未知。Edge Id `2060`·`3160`。

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111`（章节 5）：Edge，Codec `0x0ABL`，8 WORD。TAG 1 + Edge Id 2 + Property P582（`0191 0246`）2 + Target #2060（`0051 080C`）2 + 标记 1。

给 Q30 中央银行（P1304）NO-VALUE TRIPLE `#3161` 附加期间。仅在 1811~1816 年没有。

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[TRIPLE](0x0AAL-triple.md)、[SOURCE](0x0C0L-source.md)、[WIKIDATA-PID](../reference/0x019L-wikidata-pid.md)、[EDTF](../value/0x06EL-edtf.md)、[占位标记](../slot-marker.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000AB0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
