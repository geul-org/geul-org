---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE 是把一条记录或整个文档连接到其来源的依据 Edge（Codec 0x20）。来源的性质用以来源为 Subject 的 TRIPLE，引用的性质（查阅日、来源内的位置、原文哈希）用附在 SOURCE 上的 QUALIFIER。整个文档的 SOURCE 放在 HEAD 中。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE 是把一条记录（目标）或整个文档连接到其所出自的来源的依据 Edge。Codec `0x20`。它是依据系列（`01`）唯一的直接码。

Wikidata 的一个 reference（出处组）就是一个 SOURCE。一条记录有多个出处，SOURCE 也就有多个。

## 布局

```
TAG WORD          0001 0LLL L010 0000
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Target            LOCAL Reference 记录 (在 BODY 中是要附加依据的 Edge 的 Edge Id，在 HEAD 中 0 = 整个文档)
Origin            Reference 记录，或占位标记 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

- Origin 指向来源。有适合该来源的 Reference 就用它（WIKIDATA-QID、GEUL 文档的 DOC-POINTER·EXTERNAL-ISSUER 等），没有则用本文档的 LOCAL 节点。
- 如果出处没有描述来源（例：只有 Wikidata "imported from"（P143）·查阅日的出处），Origin 是 [ABSENT](/zh/grammar/reference/slot-marker/)（未写）。写的一方只是没有写来源，对来源并不断言任何事。出处的其余内容原样保留在 QUALIFIER 中。
- 只有写的一方断言"有来源但不知道是什么"时，才使用 [UNKNOWN-VALUE](/zh/grammar/reference/slot-marker/)（人写的记录等）。从来源资料转换的转换器不断言来源没有说的事，所以使用 ABSENT。
- 为 ABSENT·UNKNOWN-VALUE 的 Origin 每次出现都是独立的。不把两个 SOURCE 的来源读作相同。

## 两层

关于出处的信息分为两层。不要混淆。

| 层 | 内容 | 写法 | 例 |
|---|---|---|---|
| 来源 | 来源本身的性质。无论谁引用都相同 | 以来源为 Subject 的 [TRIPLE](/zh/grammar/edge/triple/)（rank normal） | URL（P854）、标题（P1476）、作者（P50·P2093）、发行日（P577）、刊载处（P1433）、发行方（P123）、语言（P407） |
| 引用 | 该记录引用来源这一行为的性质 | 以 SOURCE 的 Edge Id 为 Target 的 [QUALIFIER](/zh/grammar/edge/qualifier/) | 查阅日（P813）、来源内的位置（页 P304、节 P958、外部标识符 P227·P1417）、获取处（P143）、推理方法（P887）、原文哈希（P4092） |

- **SOURCE 的含义是指向其 Edge Id 的所有 QUALIFIER 的总和。** 在不同日期查阅同一来源的两个出处，来源相同而 QUALIFIER 不同。
- 来源 TRIPLE 是关于来源的断言。无法确定属于哪一层的性质，放在引用一侧（QUALIFIER）。不对来源作断言的一侧更安全。
- 文档内相同的来源只用一个 LOCAL 声明一次，由多个 SOURCE 共同指向。
- 只能用一个 URL 描述的来源，用 [REFERENCE-NODE](/zh/grammar/edge/reference-node/)（LOCAL → URI）定义。与 sitelink 文档页面的方式相同。

## 解读与有效性

- Target、Origin 各自恰好是一条完整的记录。读完 Origin 的游标必须与 Edge 末尾吻合。
- Target 是 LOCAL Reference。BODY 的 SOURCE 指向同一文档 BODY 的 Edge Id。`0`（整个文档）只用于 HEAD 的 SOURCE（[整个文档的来源](#整个文档的来源)）。BODY 中有 Target 为 `0` 的 SOURCE 则 invalid。其他文档的记录，在该文档内附加依据。
- Origin 是 Reference。占位标记只接受 `0x0000`（ABSENT）·`0x0001`（UNKNOWN-VALUE）。不接受 NO-VALUE（`0x0002`）·Value。
- geul.org 规格文档 `0x0000/0x0000000000001020`（名称 `source`）给 Target 放 [CODEC](/zh/grammar/edge/codec/) LOCAL（`0008`），给 Origin 放 CODEC `0780`（任意 Reference）·`0000`（ABSENT，可选）·`0001`（UNKNOWN-VALUE）。
- 同一 Target 的 SOURCE 之间的顺序没有意义。一个出处内部各项的顺序也没有意义（相同属性的值顺序按文档顺序保留）。
- SOURCE 不改变目标的真假。只是写明目标出自何处。判定结果由 [TOULMIN](/zh/grammar/edge/toulmin/) `VERDICT` 负责。

## 整个文档的来源

整个文档的来源（原始转储、版本、原文文件）用 **HEAD 中 Target 为 `0` 的 SOURCE** 来写。以该 SOURCE 为 Target 的 QUALIFIER（原文哈希 P4092、获取时刻 P813、原文范围等）也放在 HEAD 中（[文档](/zh/grammar/document/#head-与-body)）。

- HEAD 中可以放的 Edge 只有这两种。其他 Edge 放在 BODY 中。
- HEAD 的 QUALIFIER 放在它所指向的 HEAD SOURCE 之后。解码器从前往后读，划分 HEAD 和 BODY。
- 把以 HEAD SOURCE 为 Target 的 QUALIFIER 放在 BODY 中则 invalid。BODY 的 SOURCE·QUALIFIER 不指向 HEAD 的 Edge。
- **Edge Id 在 HEAD 和 BODY 中共用一个编号空间。** 在文档内唯一，与其他 Edge 一样从 [NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/) 获取，重新生成时内容相同则沿用相同编号。在去掉了 HEAD Edge 的版本中，该编号也不再使用。
- 如果 Origin 是 LOCAL，则其定义（REFERENCE-NODE、来源 TRIPLE）放在 BODY 中。LOCAL 的范围是整个文档。
- HEAD Edge 不是验证类 Meta，所以进入[内容哈希](/zh/grammar/document/#内容哈希)。在 diff 中随 HEAD 整体被替换（不写入 `DELTA-REMOVE`）。
- 没有专门用于整个文档来源的 Meta。以 Meta 写的原文范围·获取时刻，在来源有多个时无法确定属于哪个来源。附在 SOURCE 上的 QUALIFIER 通过 Target 来确定这一点。

例：从 Wikidata 转储转换的 Q42 文档的 HEAD（Edge Id 仅用于说明）。

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         实体版本（revision）
#1741 SOURCE     #0     #1740                                         转储文件
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            文件哈希
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    获取时刻
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      版本保存时刻
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  版本永久地址
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- 版本和转储是不同的来源，所以放两个 SOURCE。版本是内容的来源（通过永久地址可以再次获取相同内容），转储是获取该版本的文件。文件哈希和获取时刻是关于转储文件的引用一侧的性质，所以附在转储 SOURCE 上。

## 其他依据的表示

依据系列中只放 SOURCE。其他依据用 QUALIFIER 来写。

| 依据 | 写法 | Property |
|---|---|---|
| 原文内的范围 | 在 SOURCE 上放 QUALIFIER。一个范围一个 SOURCE | 页 P304、节 P958、引文 P1683。字符范围是 GEUL 术语（未定） |
| 获取来源资料的时刻 | 在 SOURCE 上放 QUALIFIER | 查阅日 P813 |
| 原文字节哈希（固定版本） | 在 SOURCE 上放 QUALIFIER | 校验和 P4092，值为 [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/) 等 |
| 制作主体（人、模型、规则引擎） | 在 SOURCE（制作引用的主体）或目标上放 QUALIFIER | GEUL 术语（未定） |
| 可信度 | 在目标上放 QUALIFIER | GEUL 术语（未定），值像 Meta [CONFIDENCE](/zh/grammar/meta/verification/confidence/) 一样为 0~1 |
| 各条文的施行期间 | 在目标上放 QUALIFIER | 开始 P580，结束 P582 |
| 移动·拆分·合并之前的旧记录 | 在目标上放 QUALIFIER，值为旧 Edge Id（LOCAL） | P1365（replaces） |
| 最初进入的版本 | 不存储。由版本历史计算（git blame） | |

## 示例（非规范）

Q42 P19（出生地）Q350，目标 TRIPLE `#178`。2026-10-19 Wikidata 转储的四个出处。

```
SOURCE     #1347  #178   Q5375741                     ① 不列颠百科全书：没有来源描述，只有一个 P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② 卫报文章 #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND：前面已声明的 LOCAL #1158（P248 Q36578、P407 Q188）
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① 没有来源描述，且 P248 只有一个，所以来源就是该条目。`#1347` 是 TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD，TAG `13A0`。

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- 只有一个 URL 的出处：`REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`，`SOURCE #1385 #180 #1384`。
- 只有"imported from"英文维基百科的出处：`SOURCE #n #t ABSENT`，`QUALIFIER P143 #n Q328`。Origin `0x0000` 1 WORD。

## 未决问题

- 表示字符范围、制作主体、可信度的 GEUL 术语（术语定义文档与 ID）。
- 来源描述无法识别来源时（只有语言的出处等），若用一个 LOCAL 共用同样的描述，就等于断言不同的来源相同。
- 用于 Wikidata 之外的出处（法令、网页引用）的来源·引用属性列表。
- 出处的出处（链）：是否在来源 LOCAL 上再附加 SOURCE。

## 相关页面

- [Edge](/zh/grammar/edge/)、[TRIPLE](/zh/grammar/edge/triple/)、[QUALIFIER](/zh/grammar/edge/qualifier/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)、[占位标记](/zh/grammar/reference/slot-marker/)
- [文档](/zh/grammar/document/)（HEAD 与 BODY）、[Meta — 出处](/zh/grammar/meta/provenance/)
