---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge 是把 Reference·Value·其他 Edge 组合起来叙述的记录。第一个构成要素总是 Edge Id，Codec 高 2 位是系列（叙述、依据、执行、TOULMIN）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge 是把其他记录作为构成要素组合起来叙述的记录。"Q42 是人"、"Q42 的英文名是 Douglas Adams" 这样的叙述就是一个 Edge。

## 布局

```
TAG WORD          0001 0LLL LCCC CCCC
[Length 扩展 TAG]
[Codec 扩展 TAG]  Issuer 格式时
Edge Id           LOCAL Reference 记录
构成要素          Codec 规定的顺序
```

- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1。解码器即使不知道 Codec，也只凭 Length 就能跳到下一条记录。
- **第一个构成要素总是 Edge Id（LOCAL Reference）。** 因为是 LOCAL Reference（`0088` + ID，Quantifier `000`），所以不知道 codec 也能读出 Edge Id。
- 构成要素各自靠自己的 Length 找到边界。读完最后一个构成要素的位置必须与 Edge 的末尾恰好吻合。
- 构成要素的构成（Payload）由各 Edge Codec 文档规定。
- 有子格式的 Codec（WORLD、TIMELINE、SCENE）用 1 WORD 的 Codec 专属 TAG 指定子格式。
- Edge 记录之间的顺序没有意义（Codec 另有规定的除外。例：[TOULMIN](/zh/grammar/edge/toulmin/) 文档）。
- 其他 Edge 用 Edge Id 指向。本文档的 Edge 用 LOCAL 指向，其他文档的 Edge 用指示 Reference（`EXTERNAL-POINTER-*`、`EXTERNAL-ISSUER-*`）指向。

## 系列

| 高 2 位 | 系列 | 直接码 | 作用 |
|---|---|---|---|
| `00` | 叙述 | `0x00`~`0x1F` | 构成关于世界与事件的内容 |
| `01` | 依据 | `0x20`~`0x3F` | 记录和文档来自何处（[SOURCE](/zh/grammar/edge/source/)） |
| `10` | 执行 | `0x40`~`0x5F` | 可执行的程序结构（AST） |
| `11` | [TOULMIN](/zh/grammar/edge/toulmin/) | `0x60`~`0x7B` | 论证图：主张·反驳·例外、攻击关系、执行、判定结果 |

## 叙述 Edge

| Codec | 名称 | 构成要素 |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/zh/grammar/edge/reference-node/) | Subject（Reference）指示 Object 的有向绑定 |
| `0x01` | [SAME-NODE](/zh/grammar/edge/same-node/) | 两个 Reference 指示同一个对象 |
| `0x02` | [DIFFERENT-NODE](/zh/grammar/edge/different-node/) | 两个 Reference 指示不同的对象 |
| `0x03` | [BIND](/zh/grammar/edge/bind/) | 给 Subject 绑定机器用的名称（UTF8-TEXT） |
| `0x04` | [LABEL](/zh/grammar/edge/label/) | Subject 的各语言名称（UTF8-LANGUAGE-TEXT） |
| `0x05` | [ALIAS](/zh/grammar/edge/alias/) | Subject 的其他名称。布局与 LABEL 相同 |
| `0x06` | [DESCRIPTION](/zh/grammar/edge/description/) | Subject 的各语言说明。布局与 LABEL 相同 |
| `0x08`/`0x09` | VERB-SHORT / VERB | 动词叙述 |
| `0x0A` | [TRIPLE](/zh/grammar/edge/triple/) | 一个命题（Predicate、Subject、Object）与 rank |
| `0x0B` | [QUALIFIER](/zh/grammar/edge/qualifier/) | 限定另一个 Edge 命题的一个条件 |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | 世界观、事件顺序、场景结构 |
| `0x18`~`0x1A` | [PUBLICATION](/zh/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | 文档版本的公布·停用建议·删除（[公布地址与版本列表](/zh/grammar/publishing/#版本列表)） |
| `0x1B`~`0x1E` | [DECLARE](/zh/grammar/edge/declare/) / [FIELD](/zh/grammar/edge/field/) / [ENUM](/zh/grammar/edge/enum/) / [CODEC](/zh/grammar/edge/codec/) | 书写 Codec 规格的词汇（[Codec 规格文档](/zh/grammar/codec-spec/)） |

- `-SHORT` 与一般形式设为偶数·奇数对（VERB-SHORT `0x08`/VERB `0x09`）。LABEL 把语言放在 Object（UTF8-LANGUAGE-TEXT）内的语言记录中，所以只使用 `0x04` 一个。
- PUBLICATION·DEPRECATION·TOMBSTONE 由版本列表文档使用。因为必须不依赖 codebook 就能读取版本列表，所以内置于解码器（[公布地址与版本列表](/zh/grammar/publishing/#层)的 0 层）。
- DECLARE·FIELD·ENUM·CODEC 是书写 Codec 规格的词汇。因为必须不依赖 codebook 就能读取规格文档，所以把布局内置于解码器（0 层）。用该词汇写成的各个 Codec 规格文档是一般文档。

### TRIPLE

详见：[TRIPLE](/zh/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Predicate         Reference (Wikidata 属性等)
Subject           Reference
Object            Reference 或 Value
Rank              1 WORD
```

| Rank | 名称 | 含义 |
|---|---|---|
| `0` | normal | 默认 |
| `1` | preferred | 当前值，最权威的值 |
| `2` | deprecated | 被判定为错误或过时但作为记录保留的值 |

- Rank 与 Wikidata statement rank 相同。不单独标注 rank 的来源使用 `0`。
- **TRIPLE 的含义是指向该 Edge Id 的所有 QUALIFIER 的总和。** 读取方在解读 TRIPLE 之前先收集 QUALIFIER。

例：Q42 — P31(instance of) — Q5(人)，normal，Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

详见：[QUALIFIER](/zh/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (被限定的 Edge 的 Edge Id)
Value             Reference 或 Value
```

- QUALIFIER 是命题的一部分。它不是关于命题的单独主张，而是限定命题成立的条件（开始·结束时点、适用范围等）。
- 关于命题的单独主张（谁提出的等）用 TRIPLE 来写。
- Target 是同一文档的 Edge。同一 Target 的 QUALIFIER 顺序是文档内顺序。

例：Q42 — P69(educated at) — Q691283，开始(P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

详见：[LABEL](/zh/grammar/edge/label/)、[ALIAS](/zh/grammar/edge/alias/)、[DESCRIPTION](/zh/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- 名称和语言放在一个 Object（UTF8-LANGUAGE-TEXT）里。
- 同一 Subject·语言的 LABEL 至多一个。其他名称用 ALIAS 来写。
- 没有语言的机器用名称用 BIND 来写。LABEL 必须有语言。

### BIND

详见：[BIND](/zh/grammar/edge/bind/)

- 给 Subject 绑定机器匹配用的名称（UTF8-TEXT）。没有语言，也不做规范化。字节相同才是同一个名称。
- 名称的范围是包含该 BIND 的文档。同一文档中不把相同名称绑定到不同的 Subject。
- 其他记录不用名称而用 LOCAL ID 来指向。名称用来与外部（宿主函数、地址输入、人）对应。

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

详见：[SAME-NODE](/zh/grammar/edge/same-node/)、[DIFFERENT-NODE](/zh/grammar/edge/different-node/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)

- SAME-NODE 是两个 Reference 指向同一对象的同一性。具有自反性·对称性·传递性。
- DIFFERENT-NODE 是两个 Reference 是不同对象的非同一性。
- REFERENCE-NODE 是用 Object 来定义 Subject（Reference）是什么的有向绑定。不是同一性主张。例：定义 LOCAL 节点所指向的 URI。

## 依据 Edge

给 BODY 内的单条记录，或整个文档（HEAD）附上依据。依据系列的直接码只有 [SOURCE](/zh/grammar/edge/source/)（`0x20`）一个。

| Codec | 名称 | 构成要素 |
|---|---|---|
| `0x20` | [SOURCE](/zh/grammar/edge/source/) | Target（要附加依据的 BODY Edge 的 Edge Id，在 HEAD 中 `0` = 整个文档）、Origin（来源 Reference，ABSENT 或 UNKNOWN-VALUE） |
| `0x21`~`0x3F` | Reserved | |

- 来源本身的性质（URL、标题、作者、发行日 …）用以来源为 Subject 的 TRIPLE 来写，引用的性质（查阅日、来源内的位置 …）用以 SOURCE 的 Edge Id 为 Target 的 QUALIFIER 来写。
- 整个文档的来源在 HEAD 中用 Target 为 `0` 的 SOURCE 来写，以它为 Target 的 QUALIFIER 也放在 HEAD 中。HEAD 中出现的 Edge 只有这两种，Edge Id 在 HEAD 和 BODY 中共用一个编号空间（[整个文档的来源](/zh/grammar/edge/source/#整个文档的来源)）。
- 其他依据（原文范围、制作主体、可信度、各条文的施行期间、旧记录）用 QUALIFIER 来写，最初进入的版本由版本历史计算（[SOURCE](/zh/grammar/edge/source/#其他依据的表示)）。
- 记录级别的判定结果由 TOULMIN `VERDICT` 负责。

### SOURCE

详见：[SOURCE](/zh/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (要附加依据的 BODY Edge 的 Edge Id，在 HEAD 中 0 = 整个文档)
Origin            Reference 或占位标记 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

例：Q42 P19 TRIPLE `#178` 的出处是不列颠百科全书（Q5375741），其中的标识符 P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## 执行 Edge

是不依赖特定编程语言的程序结构。构成要素用本文档的 LOCAL ID 来指向。

| 分组 | Codec |
|---|---|
| 声明 | FUNCTION-DECLARE、TYPE-DECLARE |
| 表达式 | CONST、UNARY、BINARY、CALL、MEMBER、INDEX、CONSTRUCT、CONDITIONAL |
| 语句 | BLOCK、ASSIGN、IF、SWITCH、WHILE、FOREACH、JUMP、RETURN |
| 错误 | RAISE、TRY |

- 这不是原样容纳外部语言代码的格式。外部语言的代码作为 Issuer 格式放置。
- 构成要素用本文档的 LOCAL ID（REF）来指向。表达式位置放表达式 Edge 或符号。REF `0` 表示无。
- 表达式产生值，语句不产生值。表达式可以放在 BLOCK 的语句位置（值被丢弃）。
- C 风格的 `for` 写成 BLOCK（初始化、WHILE），`else if` 写成假位置上的 IF。
- 符号是 LOCAL ID，名称用 BIND 绑定。其他记录用 LOCAL ID 而非名称来指向符号。名称相同但 LOCAL ID 不同，就是不同的符号。
- 符号是什么（变量、参数、函数、类型），由指向该符号的记录决定。文档内没有定义的符号由外部（宿主）提供，如果是 CALL 的目标，则是宿主函数。

未决问题：运算符码、类型表示、各 Codec 的 Payload 布局。

## TOULMIN Edge

详见：[TOULMIN](/zh/grammar/edge/toulmin/)

用图尔敏论证模型书写判定·执行图。这是让 GEUL 用 GEUL 叙述自己的规则并自行修改的核心系列。

| 分组 | Codec |
|---|---|
| 声明 | CASE-DECLARE（案件）、[PREDICATE-DECLARE](/zh/grammar/edge/toulmin/expr/)（谓词）、SPEC-DECLARE（判断标准）、RULE-DECLARE（主张）、COUNTER-DECLARE（反驳）、EXCEPT-DECLARE（例外）— [NODE](/zh/grammar/edge/toulmin/node/) |
| 关系 | ATTACKS（攻击）、SUPERSEDES（排除）— [LINK](/zh/grammar/edge/toulmin/link/)，SUPERSEDE-CHAIN（优先级链，布局未定） |
| 执行 | RUN、DO、DO-ONCE、UNDO、CHECKING — [LINK](/zh/grammar/edge/toulmin/link/)，ENTRY、TRIGGER — [NODE](/zh/grammar/edge/toulmin/node/) |
| 结果 | VERDICT（判定结果：Pass·Review·Fail）、EVIDENCE（判定的证据）— 布局未定 |

- 原文·分区·辅助节点和关系是 GEUL Issuer 的 ISSUER 格式（`0xC000`~`0xC029`）（[SOURCE 与分区](/zh/grammar/edge/toulmin/source/)）。
- 判定结果放在与判定对象不同的文档中。结果文档导入对象文档并指向它。因此判定不会改变对象文档的内容哈希。

## Issuer 格式 Edge

Issuer 可以定义并使用自己的 Edge 格式（Codec `0x7C`~`0x7F`）。直接码 `0x7C`~`0x7F` 虽然在 TOULMIN 区间内，但是通用 ISSUER 码，系列由格式编号的高 2 位决定。

| Issuer | 格式编号 | 名称 | 系列 |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/zh/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/zh/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/zh/grammar/edge/toulmin/link/) | TOULMIN |
