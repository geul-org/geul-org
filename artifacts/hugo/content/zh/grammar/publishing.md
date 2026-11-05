---
title: "公布地址与版本列表"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL 不用字符串 URL，而是用 ID（Issuer、文档 ID、版本 ID）指向文档。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 不用字符串 URL，而是用 ID（Issuer、文档 ID、版本 ID）指向文档。地址由 ID 决定。本页规定编码器、解码器、解析器相互配合运作所需的公布规则。Issuer 等级和公开方式由 [Issuer 与公布](issuer.md)规定。

## ID 表示 {#id-표기}

地址中使用的 ID 以十六进制书写。

- 前缀是小写 `0x`。十六进制用 A-F 大写书写。解析器对用小写书写的地址也会转成大写后查找。
- 位数固定为宽度 × 4。不省略前导 0，位数就是宽度。
- 书写地址时，Issuer 按发放宽度的位数书写：2 WORD 8 位，4 WORD 16 位，16 WORD 64 位。
- 读取时，Issuer 的 8 位、16 位、64 位都接受。在较短的 Issuer ID 前补 0 的较长写法，按同一个 Issuer 查找（`0x00000001` 与 `0x0000000000000001` 是同一个 Issuer，[Issuer 与公布](issuer.md#issuer-등급)）。

| 对象 | 宽度 | 位数 | 例 |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 位 |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| 文档 ID | 4 WORD | 16 | `0x0000000000000000` |
| 版本 ID | 2 WORD | 8 | `0x00000003` |
| 内容哈希 | 16 WORD | 64 | `0x` + 64 位 |

- GEUL 直接码的 Codec ID 是将其 TAG WORD（L=0）写成 32 位的值（TRIPLE `0x0AAL` → `0x00000AA0`）。Kind 包含在 TAG 中，因此不会重叠。
- 其他 Issuer 的 ISSUER 格式 Codec，以记录的 Codec 编号放在该 Issuer 的 `codecs/` 之下。例：IETF CRC32C 为 `0x00000007/codecs/0x0000C000/`。
- Issuer Codec 的 Codec ID 是记录的 Codec 编号（2 WORD）。Issuer 与 Kind（Reference、Value、Edge）无关，在自己的 `<Issuer>/codecs/` 内分配不重复的 Codec 编号。地址不按 Kind 划分（没有 `references/`、`values/`、`edges/` 这样的文件夹）。
- 记录的 Kind 与其 Codec 文档 [DECLARE](edge/0x0BBL-declare.md) 目标的 Kind 不同时，解析器视为错误。
- 公布时拒绝在同一个 Codec ID 上放入不同的 Codec。
- 版本 ID 的规则（从 1 开始，`0` 为最新，由公布方分配，用尽后用新文档 ID）由[文档](document.md#버전)规定。

## 公布地址 {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Issuer 列表 最新
/.well-known/geul/issuers/<版本 ID>.geul                           Issuer 列表 指定版本
/.well-known/geul/issuers/versions.geul                            Issuer 列表 版本列表
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec 最新
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<版本 ID>.geul        Codec 指定版本
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Codec 版本列表
/.well-known/geul/<Issuer>/docs/<文档 ID>/latest.geul              文档 最新
/.well-known/geul/<Issuer>/docs/<文档 ID>/<版本 ID>.geul           文档 指定版本
/.well-known/geul/<Issuer>/docs/<文档 ID>/versions.geul            文档 版本列表
/.well-known/geul/<Issuer>/hashes/<内容哈希>.geul                   按内容哈希查询
```

例：`/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- 路径遵循 RFC 8615 的 `.well-known`。geul.org 和私有公布使用相同的路径，只是域名不同。要注册的后缀只有 `geul` 一个。
- Issuer 列表是 `issuers/`。Codec、一般文档、哈希在 Issuer 文件夹之下分为 `codecs/<Codec ID>/`、`docs/<文档 ID>/`、`hashes/`。Issuer 列表也从版本 1 开始，并设有 `versions.geul`（[列表文档](#목록-문서)）。
- `latest.geul` 是保留字，也是别名。不单独存储。在同一位置的 `versions.geul` 中找到最近的版本，原样提供该版本的字节。不做重定向。Issuer 列表、Codec、文档的所有 `latest.geul` 都一样。
- 一个版本的正本地址是 `/<Issuer>/docs/<文档 ID>/<版本 ID>.geul`。Codec 为 `/<Issuer>/codecs/<Codec ID>/<版本 ID>.geul`。提供相同内容的其他地址，用 `Link: rel=canonical` 指向正本地址。
- 指定版本的地址和内容哈希地址是不可变的。不可变地址可以放入永久缓存和 CDN。接收方用版本列表（或锁定记录）的内容哈希验证。
- 要按内容哈希查找，必须知道 Issuer。没有仅凭哈希的全局查询。
- Codec 文档没有文档 ID。用 [CODEC-POINTER](reference/0x042L-codec-pointer.md)（Issuer、Codec ID、版本 ID）指向自己和版本。
- ID 总是以 `0x` 开头。因此保留名称（`issuers`、`codecs`、`docs`、`hashes`、`latest.geul`、`versions.geul`）或人为命名的名称，即使是 `add`、`cafe` 这样只由十六进制字符构成的单词，也不会与 ID 重叠。
- 位置（从哪个服务器获取）不放入文档内容。放入的话，地址改变时内容哈希会改变。位置由接收文档一方的设置决定。

### 公布形态与查询 {#공표-형태와-조회}

- 地址是逻辑地址。公布方可以用单个文件或 pack 提供，若为 pack 则不能直接用地址 URL 获取，而用 GEUL 解析器读取。
- 无论以单个文件、pack、zstd pack 哪种形态存储，都用同一地址查找。上述 10 种格式之外的地址和不存在的地址为 404（不存在）。

命令行工具 `geul`（[gogeul](https://github.com/geul-org/gogeul)）：

```
geul get <地址>     将纯 GEUL 文档二进制输出到标准输出
geul show <地址>    以文本显示文档
```

- `geul get` 接受 `file://`、`https://` 地址。10 种格式之外的地址和不存在的地址以 404（不存在）结束。

Go 库 gogeul 的 `pkg/resolve` 为每种地址设置查询函数。它们都返回纯 GEUL 二进制（`[]byte`）。版本 ID 从 1 开始，所以 `Latest`（0）是最新。不存在的地址是不存在错误（`ErrNotFound`）。

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // 10 种之外的格式为 404(不存在)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → 标准输出
```

### 格式指定 {#형식-지정}

- 公布地址以 `.geul` 结尾，是二进制（`application/vnd.geul`）。
- 文档以二进制为正本。内容哈希和签名只按二进制计算。

### 列表文档 {#목록-문서}

列表文档只有 Issuer 列表 `issuers/` 一个。它将 Issuer 与域名绑定（[Issuer 列表](#issuer-목록)）。从版本 1 开始，并设有 `versions.geul`。列表的文档 ID 是保留文档 ID `0xFFFFFFFFFFFFFFFF`（Issuer geul.org `0x00000000`）。每个 Issuer 都保留文档 ID `0x0000000000000000` 和 `0xFFFFFFFFFFFFFFFF`（[Issuer 与公布](issuer.md#용어-정의-문서)）。

- `latest.geul` 是不存储的别名。在 `versions.geul` 中找到最近的版本并提供其字节。
- `issuers/versions.geul` 的 PUBLICATION·DEPRECATION·TOMBSTONE 用 DOC-POINTER（`0x00000000`、`0xFFFFFFFFFFFFFFFF`、版本 ID）指向列表版本。因此即使通过 `hashes/` 获取，也能知道它是什么的列表（[PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)）。
- 文档 ID `0xFFFFFFFFFFFFFFFF` 在任何 Issuer 中都不通过 `<Issuer>/docs/<文档 ID>/` 地址提供（404）。另一个保留文档 ID `0x0000000000000000` 是该 Issuer 的术语定义索引文档，放在 `docs/` 之下（[Issuer 与公布](issuer.md#용어-정의-문서)）。
- 列表文档中不设 `DOC-ID`。它是什么的列表，由记录的 DOC-POINTER 表明（[DOC-ID](meta/0x1C7L-doc-id.md)）。
- 文档和 Codec 无需列表，直接用记录计算出的 ID 查找（[文档名称](#문서-이름)）。

### 域名 {#도메인-이름}

域名不是公布 URL 地址。在 `<Issuer>` 位置写域名，或在 ID 位置写名称的地址，属于上述 10 种格式之外，为 404（不存在）。也没有从名称到 ID 地址的重定向。

- 域名是解析器和 CLI 的输入。解析器通过 Issuer 列表 `issuers/` 的 BIND 将域名转换为 Issuer ID。转换后的 ID 留在锁定记录中。没有文档名称地址（[文档名称](#문서-이름)）。
- 正本地址、缓存键、签名对象是 ID 地址。
- 域名用小写书写，国际化域名用 IDNA（punycode）形式书写。末尾不加 `.`。
- 没有注册处的 16 WORD Issuer，以及无法连接 geul.org 的隔离网络环境，不能使用域名。使用 ID。

### Issuer 列表 {#issuer-목록}

Issuer 列表是 `/.well-known/geul/issuers/` 之下的文档（最新为 `issuers/latest.geul`）。它将 Issuer 与其名称（域名）绑定。

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   名称 = "geul.org"
  …
```

- Subject 是 [ISSUER-POINTER](reference/0x040L-issuer-pointer.md)（Issuer 自身），名称用 [BIND](edge/0x0A3L-bind.md) 绑定。
- 名称是经过域名所有权证明的域名。为小写，国际化域名用 IDNA（punycode）书写。一个名称只绑定一个 Issuer。
- 供人阅读的 Issuer 显示名称（按语言）作为陈述 [LABEL](edge/0x0A4L-label.md) 附在同一个 Subject 上。
- 由 geul.org（GEUL Issuer）签名，变更时追加而不修改（与版本列表相同的链规则）。

### 文档名称 {#문서-이름}

**没有文档名称地址。** 文档和 Codec 用 ID 查找。

- 不设将文档名称·Codec 名称转换为 ID 的索引。版本列表中也不放文档名称 [BIND](edge/0x0A3L-bind.md)（[PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)）。
- 供人浏览的索引由工具（查看器）根据 pack 清单生成。
- 正本地址、缓存键、签名对象是 ID 地址。IMPORT 和文档内的引用只用 ID。
- 供人阅读的标题（按语言）作为陈述 [LABEL](edge/0x0A4L-label.md) 附上。

### 已删除的文档 {#삭제된-문서}

- 因法定删除·依职权删除而作废的版本（TOMBSTONE）的地址，也和其他不存在的地址一样为 404（不存在）。
- 被建议弃用的版本（DEPRECATION）不是 404。该版本地址继续提供。
- 删除以 [TOMBSTONE](edge/0x0BAL-tombstone.md) 记录（该版本的 DOC-POINTER、原因类别）留在版本列表中。

## 层 {#층}

GEUL 连出处·元信息·列表都用 GEUL 文档表示。读取它们所需的最小部分内置于解码器，以切断循环。每一层只依赖下一层。

| 层 | 内容 | 依赖 |
|---|---|---|
| 第 0 层 | 解码器内置规则：帧划分、内容哈希、签名验证、版本列表记录 Codec（`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`）、Codec 规格词汇（`DECLARE`·`FIELD`·`ENUM`·`CODEC`）、[占位标记](slot-marker.md)（`0x0000`、`0x0010`、`0x0020`）、从文档之外获得的信任密钥 | 无。不做查询 |
| 第 1 层 | 版本列表文档 | 第 0 层 |
| 第 2 层 | 一般文档、codebook、Codec 规格文档、Issuer 验证密钥文档 | 用第 1 层查找，用第 0 层验证 |

- 任何一层都不依赖本层或更高层。
- 区分“可以用 GEUL 表示”和“必须用 GEUL 解释才能读取”。第 0 层虽然可以用 GEUL 表示，但解释时不需要查询。
- 像判定的含义这样无法转换为 TOULMIN 文档的固定核心也放在这一层（[TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)）。

## 版本列表 {#버전-목록}

公布方为每个文档续写一个版本列表文档（`/<Issuer>/docs/<文档 ID>/versions.geul`，Codec 为 `/<Issuer>/codecs/<Codec ID>/versions.geul`，Issuer 列表为 `issuers/versions.geul`）。记录格式和文档结构由 [PUBLICATION](edge/0x0B8L-publication.md) 规定。

```
DOC-*
  SPEC-VERSION
  PARENT          上一版本列表的内容哈希
  RECORDED-AT     发布该列表的时间
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
| DEPRECATION | 在已公布的版本上标示弃用建议。仍会被解释 |
| TOMBSTONE | 删除已公布的版本（法定·依职权删除）。写明原因类别 |

- 记录只追加。不修改、不删除、不改变顺序。弃用·删除也是追加记录。新列表原样保留上一列表的 BODY 放在前面并追加记录，列表之间通过 `PARENT` 哈希链相连。
- 这是指不修改公布记录，与文档内容的修订（[文档](document.md#개정)）不同。版本的当前状态通过依次应用记录计算得出。
- 版本 ID 从 1 开始，不缺号，递增。不重复公布相同内容。
- 最新版本是既未被建议弃用也未被删除的最高版本。
- 记录中不放时间。该记录首次载入的列表的 `RECORDED-AT` 就是公布时间。
- 版本列表中不设 `DOC-ID`。记录的 DOC-POINTER（文档 ID，Issuer 列表为保留文档 ID）表明它是什么的列表。
- 版本列表不设 IMPORT，只使用第 0 层 Codec。BODY 中只放 PUBLICATION·DEPRECATION·TOMBSTONE。
- 以前的版本列表只通过内容哈希（`<Issuer>/hashes/<内容哈希>.geul`）指向，历史通过 `PARENT` 链连接。
- 可变的地址是 `latest.geul` 和 `versions.geul`。可变指针无法做成文档，所以用所获得列表的签名·`RECORDED-AT`·`PARENT` 来验证。

### 签名主体 {#서명-주체}

| 签名 | 主体 | 对象 |
|---|---|---|
| 文档签名 | 该文档的 Issuer | 文档的内容哈希（[Issuer 与公布](issuer.md#서명)） |
| 列表签名 | 分配版本 ID 的公布方 | 版本列表的内容哈希 |

- geul.org 公布由 geul.org（GEUL Issuer）、私有公布由该 Issuer 分配版本 ID 并对列表签名。
- 作者对内容负责，公布方对编号和顺序负责。

### 验证 {#검증}

- 签名不计入内容哈希，所以删除签名后哈希不变。因此验证的不是“有签名就确认”，而是“必须有指定密钥的签名”。要求哪些密钥，由解析器的信任设置和锁定记录决定。
- 解析器将最后看到的列表的内容哈希留在锁定记录中。新获得列表的 `PARENT` 链中没有该哈希则拒绝（防止回滚·分叉）。
- 镜像和隔离网络环境一并复制版本列表链。只要有公钥，就能离线验证。
- 所收到的文档无论来自哪个出处，都用内容哈希验证。无需信任出处。

## 依赖解析 {#의존성-해석}

- 文档在 HEAD 的 [IMPORT-DOC](meta/0x1E4L-import-doc.md) 中写明所依赖的文档。
- 新版本不承诺与之前版本兼容。因此在整个图中不把一个文档的版本合并为一个（不使用最小版本选择）。
- 每个 `IMPORT-DOC` 绑定到自己固定的版本。同一文档的多个版本可以同时存在于一个图中（引用旧法的判决和引用现行法的判决）。引用按（文档、版本、LOCAL ID）解析。
- 导入最新（版本 `0`）绑定到解释时点的最新版本。指定时点解释，则绑定到该时点施行的版本（[文档](document.md#개정)）。
- 以版本 ID 固定的导入可以复现（版本 ID 的内容不可变，并用锁定记录验证）。

## 媒体类型 {#미디어-타입}

- GEUL 文档的媒体类型是 `application/vnd.geul`。扩展名是 `.geul`。
- 即使迁移到标准树 `application/geul`，也继续接受 `application/vnd.geul`。

## 未决问题 {#열린-문제}

- 在私有公布·16 WORD Issuer·隔离网络环境中版本 ID 出现分歧（相同的版本 ID，不同的内容）时的处理。
- Issuer 列表 `issuers/` 的 HEAD 构成以及签名·链格式。没有域名的 Issuer（4 WORD）的名称规则、名称争议处理和长度上限。
- 列表变大时，不用整条链而改用 Merkle 日志（包含·一致性证明）的时机和格式。
- 在 HEAD 中记录提供位置的 Issuer 的 Meta。
