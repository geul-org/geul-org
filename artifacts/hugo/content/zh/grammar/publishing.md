---
title: "公布地址与版本列表"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "已公布的 GEUL 文档通过由 ID（Issuer、文档 ID、版本 ID）确定的固定地址提供，并由公布方签名的版本列表来验证。本页规定 ID 写法、地址、格式指定、名称索引、版本列表、信任层。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 不用字符串 URL，而用 ID（Issuer、文档 ID、版本 ID）来指向文档。地址由 ID 确定。本页规定编码器·解码器·解析器相互配合运行所需的公布规则。Issuer 等级和公开方式由 [Issuer 与公布](/zh/grammar/issuer/)规定。

## ID 写法

地址中使用的 ID 用 hex 书写。

- 前缀为小写 `0x`，hex 数字也是小写。
- 位数固定为宽度 × 4。不省略前导 0，位数就是宽度。
- Issuer ID 用能容纳该值的最短宽度书写。没有 `0x00000005` 这样的加宽写法（应为 `0x0005`）。

| 对象 | 宽度 | 位数 | 例 |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 位 |
| 文档 ID | 4 WORD | 16 | `0x0000000000000000` |
| 版本 ID | 2 WORD | 8 | `0x00000003` |
| 内容哈希 | 16 WORD | 64 | `0x` + 64 位 |

- 不是规范形式的请求（`0X`、大写、省略 0）以 `301` 重定向到规范形式的地址。缓存键和签名对象因此唯一确定。
- 版本 ID 的规则（从 1 开始、`0` 为最新、由公布方分配、用完则使用新的文档 ID）由[文档](/zh/grammar/document/#版本)规定。

## 公布地址

```
/.well-known/geul/<Issuer>/<文档 ID>.geul              最新版本。以 302 转到正本地址 (可变)
/.well-known/geul/<Issuer>/<文档 ID>/<版本 ID>.geul    一份文档 (不可变，正本地址)
/.well-known/geul/<Issuer>/<文档 ID>/versions.geul     版本列表文档 (可变，签名)
/.well-known/geul/h/<内容哈希>.geul                    按内容哈希查询 (不可变)
```

例：`/.well-known/geul/0x0001/0x0000000000000000.geul`

- 路径遵循 RFC 8615 的 `.well-known`。geul.org 与私有公布使用相同路径，只是域名不同。要注册的后缀只有 `geul` 一个。
- 文档内容只从不可变地址提供。最新版本地址不给出内容，而以 `302` 转到该版本的正本地址。
- 一个版本的正本地址是 `/<Issuer>/<文档 ID>/<版本 ID>.geul`。提供相同内容的其他地址，用 `Link: rel=canonical` 指向正本地址。
- 不可变地址可以放入永久缓存和 CDN。接收方用版本列表（或锁定记录）中的内容哈希验证。
- ID 总是以 `0x` 开头。因此保留名称（`h`、`keys`、`issuers.geul`、`documents.geul`、`versions.geul`）或人为取的名称，即使是 `add`、`cafe` 这样仅由 hex 构成的单词，也不会与 ID 重叠。
- 位置（从哪个服务器获取）不写入文档内容。写入的话，地址变化时内容哈希就会变化。位置由接收文档一方的设置决定。

### 格式指定

- 有扩展名就是指定了格式。`.geul` 是二进制（`application/vnd.geul`）。
- 没有扩展名则遵循 `Accept` 头。对浏览器提供 HTML 视图，对工具提供二进制。例：`/<Issuer>/<文档 ID>/<版本 ID>`
- 文档以二进制为正本。内容哈希和签名只对二进制计算。

### 域名

经过域名所有权证明的 Issuer，可以在地址的 `<Issuer>` 位置用该域名代替 ID。

```
/.well-known/geul/<域名>/<文档 ID>.geul              → 302 → /<Issuer>/<文档 ID>.geul
/.well-known/geul/<域名>/<文档 ID>/<版本 ID>.geul    → 302 → /<Issuer>/<文档 ID>/<版本 ID>.geul
/.well-known/geul/<域名>/<文档 ID>/                  → 302 → /<Issuer>/<文档 ID>/
```

例：`/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- 域名地址不给出内容，而以 `302` 转到 ID 地址。正本地址、缓存键、签名对象是 ID 地址。因为对应关系可能变化，所以不使用永久重定向。
- 域名用小写书写，国际化域名用 IDNA（punycode）形式书写。末尾不加 `.`。不是规范形式则以 `301` 重定向到规范形式。
- 域名中含有 `.`，因此不会与以 `0x` 开头的 ID 或保留名称重叠。
- 解析器收到域名地址时，通过 Issuer 名称索引确认对应关系，换成 ID 后记入锁定记录。
- 没有登记处的 16 WORD Issuer，以及无法访问 geul.org 的隔离网环境，不能使用域名。使用 ID 地址。

### Issuer 名称

Issuer 名称索引是 `/.well-known/geul/issuers.geul` 这一个文档。

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   名称 = "geul.org"
  …
```

- Subject 是 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)（Issuer 自身），名称用 [BIND](/zh/grammar/edge/bind/) 绑定。
- 名称是经过域名所有权证明的域名。为小写，国际化域名用 IDNA（punycode）书写。一个名称只绑定到一个 Issuer。
- 人可读的 Issuer 显示名称（按语言）作为叙述 [LABEL](/zh/grammar/edge/label/) 附加在同一个 Subject 上。
- 由 geul.org（GEUL Issuer）签名，变化时追加而不修改（与版本列表相同的链规则）。
- 保留名称 `issuers.geul` 因含有 `.` 而像域名。即使出现同名域名，该路径仍然是 Issuer 名称索引。

### 文档名称

也可以用文档名称代替文档 ID 作为地址。`<Issuer>` 位置使用 ID 或域名。

```
/.well-known/geul/<Issuer|域名>/<文档名称>.geul              → 302 → /<Issuer>/<文档 ID>.geul
/.well-known/geul/<Issuer|域名>/<文档名称>/<版本 ID>.geul    → 302 → /<Issuer>/<文档 ID>/<版本 ID>.geul
/.well-known/geul/<Issuer|域名>/<文档名称>/                  → 302 → /<Issuer>/<文档 ID>/
```

例：`/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**文档名称由 Issuer 的名称索引 `/<Issuer>/documents.geul` 用 BIND 绑定。** 解析器通过这个索引把名称对应到文档 ID。

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, 文档 ID, 版本 0)   名称 = "publication"
  …
```

- Subject 是 [DOC-POINTER](/zh/grammar/reference/doc-pointer/)（Issuer、文档 ID、版本 `0`）。名称绑定到文档而不是版本。
- Subject 的 Issuer 必须与放置该索引的 Issuer 相同。忽略其他 Issuer 的文档。
- 名称只绑定到已公布的文档。
- 文档名称是小写 ASCII slug：`a-z`、`0-9`、`-`。首尾不是 `-`，且不以 `0x` 开头。因此不会与文档 ID（`0x…`）或保留名称（`h`、`versions.geul` 等）重叠（[BIND](/zh/grammar/edge/bind/)）。
- 在一个 Issuer 内，一个名称只绑定到一个文档，已绑定的名称不再用于其他文档。更改名称时追加新的 BIND。旧名称继续转到同一个文档。同一名称出现多次时，最后一个 BIND 为代表。
- 文档内不写自己的名称。正本地址、缓存键、签名对象是 ID 地址。IMPORT 和文档内的引用只用 ID。
- 人可读的标题（按语言）不是名称。作为叙述 `LABEL` 附加。
- 版本列表文档中也可以放置同样的文档名称 BIND（[PUBLICATION](/zh/grammar/edge/publication/#文档名称)）。放置时必须与名称索引一致。解析器只读名称索引。

### 已删除的文档

- 被法定删除·依职权删除的版本的地址，返回 `410 Gone` 和墓碑（版本 ID、内容哈希、删除日期、原因类别）。
- 在版本列表中以 [TOMBSTONE](/zh/grammar/edge/publication/) 记录保留。

## 层

GEUL 连出处·元数据·列表也用 GEUL 文档表达。读取它们所需的最小部分内置于解码器中，以切断循环。每一层只依赖下面的层。

| 层 | 内容 | 依赖 |
|---|---|---|
| 0 层 | 解码器内置规则：分帧、内容哈希、签名验证、版本列表记录 Codec（`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`）、Codec 规格词汇（`DECLARE`·`FIELD`·`ENUM`·`CODEC`）、[占位标记](/zh/grammar/reference/slot-marker/)（`0x0000`~`0x0002`）、从文档外部获取的信任密钥 | 无。不查询 |
| 1 层 | 版本列表文档 | 0 层 |
| 2 层 | 一般文档、codebook、Codec 规格文档、Issuer 验证密钥文档 | 用 1 层查找，用 0 层验证 |

- 任何一层都不依赖本层或更上层。
- 区分用 GEUL 表达的内容与必须用 GEUL 解释才能读取的内容。0 层虽然可以用 GEUL 表达，但解释它不需要查询。
- 像判定的含义这样无法改写为 TOULMIN 文档的固定核心，也放在这个位置（[TOULMIN](/zh/grammar/edge/toulmin/#元认知与自我修订)）。

## 版本列表

公布方为每个文档续写一个版本列表文档（`/<Issuer>/<文档 ID>/versions.geul`）。记录格式和文档结构由 [PUBLICATION](/zh/grammar/edge/publication/) 规定。

```
DOC-*
  SPEC-VERSION
  PARENT          上一个列表文档的内容哈希
  RECORDED-AT     发布本列表的时刻
  NEXT-LOCAL-ID   下一个要分配的 LOCAL ID
  SIGNATURE       公布方的签名
BODY
  PUBLICATION     #1  文档@1  内容哈希
  PUBLICATION     #2  文档@2  内容哈希
  DEPRECATION     #3  文档@1
  …
END
```

| Edge | 含义 |
|---|---|
| PUBLICATION | 公布文档的一个版本及其内容哈希 |
| DEPRECATION | 对已公布的版本标注停用建议。继续被解读 |
| TOMBSTONE | 删除已公布的版本（法定·依职权删除）。写明原因类别 |

- 记录只追加。不修改、不删除、不改顺序。deprecate·删除也是追加记录。新列表原样保留上一个列表的 BODY 放在前面，再追加记录，列表之间以 `PARENT` 哈希链相连。
- 这意味着不修改公布记录，与文档内容的修订（[文档](/zh/grammar/document/#修订)）不同。版本的当前状态通过依次应用记录计算得出。
- 版本 ID 从 1 起无遗漏地升序。不重复公布相同内容。
- 最新版本是既未被建议废止也未被删除的最高版本。
- 记录中不放时刻。该记录首次出现的那个列表的 `RECORDED-AT` 就是公布时刻。
- 列表文档不放 `DOC-ID`。记录中的文档 ID 说明这是什么的列表。
- 列表文档不放 IMPORT，只使用 0 层 Codec。
- 列表文档不放入其他列表（没有列表的列表）。过去的列表只通过内容哈希（`h/<内容哈希>.geul`）指向，历史由 `PARENT` 链连接。
- 可变的地址只有最新列表地址（`/<Issuer>/<文档 ID>/versions.geul`）这一个。可变指针无法做成文档，所以用收到的列表的签名·`RECORDED-AT`·`PARENT` 来验证。

### 签名主体

| 签名 | 主体 | 对象 |
|---|---|---|
| 文档签名 | 该文档的 Issuer | 文档的内容哈希（[Issuer 与公布](/zh/grammar/issuer/#签名)） |
| 列表签名 | 分配版本 ID 的公布方 | 列表文档的内容哈希 |

- geul.org 公布由 geul.org（GEUL Issuer）、私有公布由该 Issuer 分配版本 ID 并对列表签名。
- 作者对内容负责，公布方对编号和顺序负责。

### 验证

- 签名不参与内容哈希，所以删除后哈希不变。因此不是"有签名就确认"，而是按"必须有指定密钥的签名"来验证。要求哪个密钥，由解析器的信任设置和锁定记录决定。
- 解析器把最后看到的列表的内容哈希记入锁定记录。如果新收到的列表的 `PARENT` 链中没有该哈希，则拒绝（防止回滚·分叉）。
- 镜像和隔离网环境一并复制列表文档链。只要有公钥，就可以离线验证。
- 收到的文档无论来自哪个来源，都用内容哈希验证。无需信任来源。

## 依赖解析

- 文档在 HEAD 中用 [IMPORT-DOC](/zh/grammar/meta/import/import-doc/) 写明依赖文档。
- 新版本不承诺与前一版本兼容。因此不在整个图中把一个文档的版本统一为一个（不使用最小版本选择）。
- 每个 `IMPORT-DOC` 绑定到它所固定的版本。同一文档的多个版本可以同时存在于一个图中（引用旧法的判决与引用现行法的判决）。引用按（文档、版本、LOCAL ID）解析。
- 最新（版本 `0`）导入绑定到解读时刻的最新版本。如果指定时点来解读，则绑定到该时点施行的版本（[文档](/zh/grammar/document/#修订)）。
- 用版本 ID 固定的导入可以复现（版本 ID 的内容不可变，并用锁定记录验证）。

## 媒体类型

- GEUL 文档的媒体类型是 `application/vnd.geul`。扩展名是 `.geul`。
- 即使迁移到标准树 `application/geul`，也继续接受 `application/vnd.geul`。

## 未决问题

- 1·2·4·16 WORD Issuer 文档中，geul.org 直接提供服务到哪里、从哪里起转到登记处的地址。此时的状态码（正本 308，最新 302·307）。
- 私有公布·16 WORD Issuer·隔离网环境中版本 ID 出现分歧（相同版本 ID，不同内容）时的处理。
- 文本表示的定义与内容协商（按 `Accept` 提供二进制、文本、HTML 视图）。
- 文档名称索引 `documents.geul` 与版本列表 BIND 的关系（是否合并为一个）、索引的签名。
- `issuers.geul` 的 HEAD 构成与签名·链格式。没有域名的 Issuer（1·4 WORD）的名称规则、名称争议处理与长度上限。
- 是否让 1 WORD Issuer 也可选择性地经过域名证明而使用域名。
- 列表变大时，从完整链迁移到 Merkle 日志（包含·一致性证明）的时点与格式。
- 在 HEAD 中写明提供位置的 Issuer 的 Meta。
