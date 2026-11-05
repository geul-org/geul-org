---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE 是依据 Edge，把单条记录（对象）或整个文档连接到它所出自的来源。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SOURCE`（规格文档 BIND `SOURCE`） |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| 规格文档 | `0x00000000/codecs/0x00000C00/`（DECLARE 目标 `0C00`） |
| 章节 | 6 `0110`（Edge 依据），章节内偏移 C = 0 |
| Kind | Edge · 系列：依据 |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 把单条记录或整个文档连接到其来源。Target（BODY 的 Edge Id，HEAD 中 `0` = 整个文档），Origin（Reference，ABSENT 或 UNKNOWN-VALUE）。来源的性质用以来源为 Subject 的 TRIPLE 表示，引用的性质（查阅日期、位置、原文哈希）用附在 SOURCE 上的 QUALIFIER 表示。整个文档的 SOURCE 及其 QUALIFIER 放在 HEAD |
| Hugo 侧 | `edge/source.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | 记录 | `0050` LOCAL |  |
| 2 | `origin` | #3 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`0010` UNKNOWN-VALUE，`0000` ABSENT（可选字段） |  |

SOURCE 是依据 Edge，把单条记录（对象）或整个文档连接到它所出自的来源。Codec 为 `0x0C0L`。它是依据系列（`01`）唯一的直接码。

一个维基数据 reference（出处集合）对应一个 SOURCE。一条记录有多个出处时，SOURCE 也有多个。

## 布局 {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Target            LOCAL Reference 记录 (BODY 中是附加依据的 Edge 的 Edge Id，HEAD 中是 0 = 整个文档)
Origin            Reference 记录，或占位标记 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin 指向来源。有适合该来源的 Reference 就用它（WIKIDATA-QID、GEUL 文档的 DOC-POINTER·EXTERNAL-ISSUER 等），没有则用本文档的 LOCAL 节点。
- 出处不描述其来源时（例如只有维基数据“imported from”(P143)·查阅日期的出处），Origin 为 [ABSENT](../slot-marker.md)（未记录）。写入方只是没有记录来源，并未就来源断言任何事。出处的其余部分原样保留在 QUALIFIER 中。
- 只有写入方断言“来源存在但不知道是什么”时才使用 [UNKNOWN-VALUE](../slot-marker.md)（人工撰写的记录等）。从原始资料转换的转换器不断言原始资料没有说过的内容，所以使用 ABSENT。
- 值为 ABSENT·UNKNOWN-VALUE 的 Origin 每次出现都相互独立。不要把两个 SOURCE 的来源读作相同。

## 两层 {#두-층}

关于出处的信息分为两层。不要混用。

| 层 | 内容 | 写法 | 示例 |
|---|---|---|---|
| 来源 | 来源自身的性质。无论谁引用都相同 | 以来源为 Subject 的 [TRIPLE](0x0AAL-triple.md)（rank normal） | URL(P854)、标题(P1476)、作者(P50·P2093)、发行日(P577)、刊载处(P1433)、出版方(P123)、语言(P407) |
| 引用 | 这条记录引用该来源这一行为的性质 | 以 SOURCE 的 Edge Id 为 Target 的 [QUALIFIER](0x0ABL-qualifier.md) | 查阅日期(P813)、来源内的位置（页 P304、节 P958、外部标识符 P227·P1417）、获取处(P143)、推断方法(P887)、原文哈希(P4092) |

- **SOURCE 的含义是指向其 Edge Id 的所有 QUALIFIER 的总和。** 在不同日期查阅同一来源的两个出处，来源相同而 QUALIFIER 不同。
- 来源 TRIPLE 是关于来源的断言。无法确定属于哪一层的性质放在引用一侧（QUALIFIER）。不对来源做断言更安全。
- 文档内同一来源只用一个 LOCAL 声明一次，由多个 SOURCE 共同指向。
- 仅由一个 URL 描述的来源用 [REFERENCE-NODE](0x0A0L-reference-node.md)（LOCAL → URI）定义。与 sitelink 文档页面的方式相同。

## 解释与有效性 {#해석과-유효성}

- Target、Origin 各自恰好是一条完整的记录。读完 Origin 后的游标必须与 Edge 末尾对齐。
- Target 是 LOCAL Reference。BODY 的 SOURCE 指向同一文档 BODY 中的 Edge Id。`0`（整个文档）只用于 HEAD 的 SOURCE（[整个文档的出处](#문서-전체의-출처)）。BODY 中出现 Target 为 `0` 的 SOURCE 则为 invalid。对其他文档的记录，要在该文档内部附加依据。
- Origin 是 Reference。占位标记只接受 `0x0000`（ABSENT）·`0x0010`（UNKNOWN-VALUE）。不接受 NO-VALUE（`0x0020`）·Value。
- geul.org 规格文档 `0x00000000/codecs/0x00000C00`（名称 `source`）在 Target 上放 [CODEC](0x0BEL-codec.md) LOCAL（`0050`），在 Origin 上放 CODEC `000F`·`020F`·`040F`（任意 Reference）·`0000`（ABSENT，可选）·`0010`（UNKNOWN-VALUE）。
- 同一 Target 的 SOURCE 之间的顺序没有意义。单个出处内部的项目顺序也没有意义（同一属性的值顺序保留为文档顺序）。
- SOURCE 不改变对象的真假。它只记录对象来自哪里。判定结果由 [TOULMIN](../toulmin/_index.md) `VERDICT` 负责。

## 整个文档的出处 {#문서-전체의-출처}

整个文档的来源（原始转储、版本、原文文件）用 **HEAD 中 Target 为 `0` 的 SOURCE** 表示。以该 SOURCE 为 Target 的 QUALIFIER（原文哈希 P4092、接收时刻 P813、原文范围等）也放在 HEAD（[文档](../document.md#head와-body)）。

- HEAD 中只能放这两种 Edge。其他 Edge 放在 BODY。
- HEAD 的 QUALIFIER 放在它所指向的 HEAD SOURCE 之后。解码器从头开始读取，区分 HEAD 与 BODY。
- 把以 HEAD SOURCE 为 Target 的 QUALIFIER 放在 BODY 中则为 invalid。BODY 的 SOURCE·QUALIFIER 不指向 HEAD 的 Edge。
- **Edge Id 在 HEAD 与 BODY 中共用一个编号空间。** 在文档内唯一，与其他 Edge 一样从 [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) 获取，重新生成时内容相同则沿用相同编号。即使在缺少 HEAD Edge 的版本中，该编号也不再复用。
- Origin 为 LOCAL 时，其定义（REFERENCE-NODE、来源 TRIPLE）放在 BODY。LOCAL 的范围是整个文档。
- HEAD Edge 不是验证类 Meta，因此计入[内容哈希](../document.md#내용-해시)。在 diff 中与 HEAD 一起整体变化（不记入 `DELTA-REMOVE`）。
- 没有专门用于整个文档出处的 Meta。用 Meta 记录的原文范围·获取时刻，在来源有多个时无法确定它说的是哪个来源。附在 SOURCE 上的 QUALIFIER 用 Target 来确定这一点。

例：从维基数据转储转换的 Q42 文档的 HEAD（Edge Id 仅作说明）。

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         实体版本(revision)
#1741 SOURCE     #0     #1740                                         转储文件
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            文件哈希
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    接收时刻
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      版本保存时刻
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  版本永久地址
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- 版本与转储是不同的来源，所以设两个 SOURCE。版本是内容的来源（通过永久地址可以重新获取相同内容），转储是接收该版本的文件。文件哈希和接收时刻是关于转储文件的引用一侧的性质，所以附在转储 SOURCE 上。

## 其他依据的表示 {#다른-근거의-표현}

依据系列中只设 SOURCE。其他依据用 QUALIFIER 书写。

| 依据 | 写法 | Property |
|---|---|---|
| 原文内的范围 | 在 SOURCE 上加 QUALIFIER。一个范围对应一个 SOURCE | 页 P304、节 P958、引文 P1683。字符范围为 GEUL 术语（未定） |
| 接收原始资料的时刻 | 在 SOURCE 上加 QUALIFIER | 查阅日期 P813 |
| 原文字节哈希（固定版本） | 在 SOURCE 上加 QUALIFIER | 校验和 P4092，值为 [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) 等 |
| 创建主体（人、模型、规则引擎） | 在 SOURCE（创建引用的主体）或对象上加 QUALIFIER | GEUL 术语（未定） |
| 可信度 | 在对象上加 QUALIFIER | GEUL 术语（未定），值像 Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) 一样取 0~1 |
| 按条文的施行期间 | 在对象上加 QUALIFIER | 开始 P580、结束 P582 |
| 移动·拆分·合并之前的旧记录 | 在对象上加 QUALIFIER，值为旧 Edge Id（LOCAL） | P1365(replaces) |
| 最初进入的版本 | 不存储。从版本历史中计算（git blame） | |

## 示例（非规范） {#예시-비규범}

Q42 P19（出生地）Q350，对象 TRIPLE `#178`。在 2026-10-19 维基数据转储中，该命题的出处有五个，这里展示其中三个。③ 电讯报文章（`#1358`~`#1367`）与②形式相同，⑤ Store norske leksikon(Q746368) 与①形式相同，故省略。

```
SOURCE     #1347  #178   Q5375741                     ① 不列颠百科全书: 无来源描述，仅一个 P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② 卫报文章 #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: 之前声明的 LOCAL #1158（P248 Q36578, P407 Q188）
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① 没有来源描述，且 P248 只有一个，所以来源就是该条目。`#1347` 为 TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD，TAG `0C07`。

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- 仅有一个 URL 的出处：`REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`，`SOURCE #1385 #180 #1384`。
- 只有“imported from”英文维基百科的出处：`SOURCE #n #t ABSENT`，`QUALIFIER P143 #n Q328`。Origin `0x0000` 为 1 WORD。

## 未决问题 {#열린-문제}

- 表示字符范围、创建主体、可信度的 GEUL 术语（术语定义文档与 ID）。
- 来源描述无法识别来源时（只有语言的出处等），若用一个 LOCAL 共享相同的描述，就会断言不同的来源相同。
- 面向维基数据以外出处（法令、网页引用）的来源·引用属性列表。
- 出处的出处（链）：是否要在来源 LOCAL 上再附加 SOURCE。

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[TRIPLE](0x0AAL-triple.md)、[QUALIFIER](0x0ABL-qualifier.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)、[占位标记](../slot-marker.md)
- [文档](../document.md)（HEAD 与 BODY）、[Meta — 出处](../meta/_index.md#출처)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000C00/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
