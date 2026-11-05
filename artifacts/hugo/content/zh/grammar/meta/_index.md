---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta 不是关于世界的内容，而是关于文档的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 不是关于世界的内容，而是关于文档的记录。除文档结构记录（DOC、BODY、END）外，其余全部放在文档的 HEAD 中。HEAD 中除了 Meta，还有针对整个文档的依据 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)及其 QUALIFIER。

## 布局 {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      章节 14·15 (0x1C0L~0x1FFL)
[Length 扩展 TAG]
Payload           原始值，或内置 Value·Reference 记录
```

- Meta 没有 Issuer 形式。Meta 是所有 Issuer 都遵循的通用规格，只由 GEUL 定义。
- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1。表中没有的 Codec 为 Reserved。

## Payload 形式 {#payload-형식}

| 形式 | 何时 | 例 |
|---|---|---|
| 原始值 | 形式唯一确定时。不依赖其他记录 Codec | `DOC-*` 长度、`SPEC-VERSION`、`ISSUER-KEY` |
| 内置 Value | 要在多种形式中选择时。Value TAG 说明形式 | `PROFILE`、`EFFECTIVE-*`、时刻、内容哈希 |
| 内置 Reference | 指向人、组织、工具、文档等对象时 | `DOC-ID`、`AUTHOR`、`CO-AUTHOR`、`RECORDED-BY`、`SIGNED-OFF`、`SIGNATURE` 的签名者 |
| 无 | 1 WORD 标记 | `BODY`、`END` |

- 内置记录不是独立记录，而是属于其 Meta。各自靠 Length 找到边界，读完最后一个记录的位置必须与 Meta 的末尾恰好吻合。
- 一个文档中只能放一个的 Meta 与可以放多个的 Meta，由各 Codec 文档的“数量”决定。

## 类 {#클래스}

Meta 编号从 `0x1C0L` 起不留 Reserved 地连续排列。编号的位不表示类。类通过下面的区间表得知。

| 类 | 直接码 | 涵盖内容 |
|---|---|---|
| 结构 | `0x1C0L~0x1C4L` | 文档的边界与长度 |
| 定义 | `0x1C5L~0x1CAL` | 解释声明 |
| 出处 | `0x1CBL~0x1D0L` | 谁、何时、在哪里 |
| 谱系 | `0x1D1L~0x1DDL` | 从什么、如何而来 |
| 策略 | `0x1DEL~0x1E3L` | 如何处理 |
| IMPORT | `0x1E4L` | 引入外部文档 |
| 验证 | `0x1E5L~0x1E9L` | 是否可信 |
| Reserved（验证专用） | `0x1EAL~0x1FFL` | |

- 验证类是章节 15 中 `C >= 5`，即 `w >= 0x1E50` 的记录。无需 Codec 手册，凭此即可识别验证类并将其从内容哈希中去掉。
- 后面的 Reserved `0x1EAL~0x1FFL` 是验证专用。验证之外的新 Meta 不能放在验证之前，放在后面的 Reserved 中则会从内容哈希中去掉。
- 结构、定义、IMPORT 类不按位来读。解码器通过内置编号表得知。
- **解释所需的 Meta**：结构、定义、IMPORT。删除后记录将无法读取，或解释会改变。所有解码器都必须处理。这些 Codec 属于 **GEUL 核心 Codec 手册**。
- **不改变解释的 Meta**：出处、谱系、验证、策略。删除后陈述内容依旧。消失的只是信任判断与处理的素材。
- 依据不用 Meta，而用依据 Edge [SOURCE](../edge/0x0C0L-source.md) 与 QUALIFIER 来写。各个记录的依据放在 BODY 中，整个文档的来源以 Target 为 `0` 的 SOURCE 放在 HEAD 中（[文档](../document.md#head와-body)）。

## 结构 {#구조}

Meta 结构类（Codec `0x1C0L~0x1C4L`）规定文档的边界与长度。GEUL 数据的单位是一个文档。

```
DOC-*                  ← HEAD 开始
  定义·出处·谱系·验证·策略·IMPORT Meta
  针对整个文档的 SOURCE 及其 QUALIFIER
BODY                   ← BODY 开始
  Reference, Value, Edge
END                    ← 关闭文档
```

- 所有文档都通过 `DOC-1WORD/2WORD/4WORD` 指定总长度来开启。解码器凭此长度可以一次跳过整个文档。
- `BODY` 与 `END` 是没有 Payload 的 1 WORD 记录。`END` 是必需的。
- 文档不嵌套。其他文档通过 IMPORT 指向。
- HEAD（Meta、针对整个文档的 SOURCE 及其 QUALIFIER）为空时省略 `BODY`。每个文档只能放一次 `BODY`。

文档结构的全貌见[文档](../document.md)。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | 指定总长度来开启文档 |
| `0x1C3L` | [BODY](0x1C3L-body.md) | 结束 HEAD 并开启 BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | 关闭文档 |

详细规则见[文档](../document.md)。

## 定义 {#정의}

Meta 定义类（Codec `0x1C5L~0x1CAL`）是解释声明。声明会改变解释规则，因此所有解码器都必须处理。声明的范围是该文档。

- `SPEC-VERSION` 决定其余记录如何读取，因此不用内置 Value，只放整数。GEUL v1 为 `0x0001`（记录 `1C51 0001`）。
- `DOC-ID` 是指向文档自身的 `DOC-POINTER`（Issuer、文档 ID、版本 `0`）。Codec 文档则是 `CODEC-POINTER`（Issuer、Codec ID、版本 `0`）。若没有，则是无名文档，只能通过内容哈希指向。
- 不存在文档名称地址。供人阅读的标题用陈述 `LABEL` 附加（[公布地址与版本列表](../publishing.md#문서-이름)）。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | 所遵循的规范版本。一个整数 |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | 所应用的 profile |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | 本文档的标识符。指向自身的 DOC-POINTER（版本 0）。Codec 文档为 CODEC-POINTER（版本 0） |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | 本版本的施行日。没有则为公布时刻 |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | 本版本有效期的终点（限时法）。没有则持续到下一版本施行为止 |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | 默认语言 |

- 不存在文档名称地址（[公布地址与版本列表](../publishing.md#문서-이름)）。供人阅读的标题用 BODY 的 LABEL 附加。

## 出处 {#출처}

Meta 出处类（Codec `0x1CBL~0x1D0L`）记录文档由谁、何时创建和记录。

- 作者、记录者及其时刻遵循 git 的 author、committer 模型（`AUTHOR`·`CREATED-AT`，`RECORDED-BY`·`RECORDED-AT`）。
- 删除出处，陈述内容也不会改变。消失的只是信任判断的素材。
- 来源资料不在此类中。整个文档的来源放在 HEAD，各个记录的来源以依据 Edge [SOURCE](../edge/0x0C0L-source.md) 写在 BODY 中。原文内的对应范围、获取时刻、原文哈希是附加在该 SOURCE 上的 QUALIFIER（页 P304·节 P958，查阅日 P813，校验和 P4092）。
- 若把来源附带的性质（原文范围、获取时刻）设为 Meta，当来源有多个时就无法确定是哪个来源的。因此用以 SOURCE 为 Target 的 QUALIFIER 来写。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | 作者（Reference） |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | 共同作者 |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | 撰写时刻 |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | 修改时刻 |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | 记录者 |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | 记录时刻 |

- 来源资料不用 Meta，而用 HEAD 的依据 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)（Target `0`）来写，原文范围、获取时刻、原文哈希则用附加在该 SOURCE 上的 QUALIFIER 来写。

## 谱系 {#계보}

Meta 谱系类（Codec `0x1D1L~0x1DDL`）记录文档从什么、如何而来。谱系遵循 git 的提交模型，对应提交的单位是文档。

- **内容哈希**指向一份文档的全部内容（git commit id）。它是从开启记录（`DOC-*`）到 `END` 之前的 SHA-256，验证类（章节 15 的 `C >= 5`，`w >= 0x1E50`）记录不参与计算。
- **版本 ID** 是在有名文档内按公布顺序从 1 开始编号的 2 WORD 整数。`0` 表示未写版本。
- 谱系 Meta 通过内容哈希指向版本。文档内的 `PARENT` 也计入哈希，因此内容哈希成为连接整个历史的哈希链。
- 历史不删除。修改的内容作为新版本发布。像 branch 那样会变动的指针不放在文档中。
- `DELTA-BASE`·`DELTA-REMOVE` 是把版本存为相对于基准版本的 diff 的格式。版本始终定义为快照。

修订规则见[文档](../document.md)。

谱系遵循 git 的提交模型。对应提交的单位是文档。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | 上一版本的内容哈希。有多个则是合并 |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | 派生自其他谱系的资料 |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | 生成主体（人、模型、规则引擎） |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | 转换工具及其源码版本（提交摘要） |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | 所引入更改的原版本 |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | 被撤销的目标版本 |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | 被改写的目标版本。不删除原版本 |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | 被合并为一个的原版本们 |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | 更改理由。每种语言一个 |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | 附加在版本上的不可变名称 |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | 该文件是相对于基准版本的 diff |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | diff 中要去掉的 LOCAL ID 列表 |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | 下一个要分配的 LOCAL ID。放在版本列表文档中 |

- 历史不删除。修改的内容作为新版本发布。
- 像 branch 那样会变动的指针不放在文档中。由存储库和索引管理。

## 验证 {#검증}

Meta 验证类（Codec `0x1E5L~0x1E9L`）记录判断文档是否可信的素材：自行签发 Issuer 的公钥、签名、贡献权利确认、可信度、整个文档的判定结果。

- 验证类不参与内容哈希的计算。因此即使把签名放在文档内、再添加多个签名，内容哈希也不会改变（与 git `gpgsig` 相同的方式）。
- 验证类是章节 15 中 `C >= 5`，即 `w >= 0x1E50` 的记录，因此无需 Codec 手册即可计算哈希。后面的 Reserved `0x1EAL~0x1FFL` 也是验证专用，同样从哈希中去掉。
- 节点、记录级的判定由 [TOULMIN](../toulmin/_index.md) Edge `VERDICT`（`0x118L`）负责。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | 自行签发 Issuer 的签名算法与公钥 |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | 对内容哈希的签名。算法、签名者、签名 |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | 贡献权利确认 |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | 可信度 |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | 整个文档的判定结果（Pass、Review、Fail） |

- 验证类不参与内容哈希的计算。因此即使把签名放在文档内、再添加多个签名，内容哈希也不会改变。

## 策略 {#정책}

Meta 策略类（Codec `0x1DEL~0x1E3L`）规定如何处理文档：许可证、公开范围、个人信息等级、保存期限、同意、使用限制。

- 策略不改变解释，只规定处理方式。
- 字节序列内作品的原有许可证用 `LICENSE` 记录。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | 许可证 |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | 公开范围 |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | 个人信息等级 |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | 保存期限 |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | 同意的范围与依据 |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | 使用限制 |

- 策略不改变解释，只规定处理方式。

## IMPORT {#import}

Meta IMPORT 类（Codec `0x1E4L`）以 IMPORT ID 引入外部文档。Codec 只有 `IMPORT-DOC`（`0x1E4L`）一个。

- IMPORT 只引入文档。被引入文档内的对象，用 BODY 的 Reference `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID）指向（[Reference](../reference/_index.md)）。
- 写了版本 ID 则绑定到该版本；为 `0` 则绑定到解释时点的最新版本。公布的文档要写明版本。
- 不引入被引入文档的 HEAD。Reference·Value 记录不是引入，而是复制。

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[Length 扩展 TAG]
文档              DOC-POINTER 记录 (Issuer, 文档 ID, 版本 ID)。Codec 文档为 CODEC-POINTER
IMPORT ID         其余。最短宽度的整数
```

- 只使用 [IMPORT-DOC](0x1E4L-import-doc.md)（`0x1E4L`）一个。IMPORT 只引入文档。被引入文档内的对象，用 BODY 的 `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID）指向。
- 写了版本 ID 则绑定到该版本；为 `0` 则绑定到解释时点的最新版本。公布的文档要写明版本。
- 同一文档中不会两次分配相同的 IMPORT ID。
- 不引入被引入文档的 HEAD。该文档的对象按该文档自身的声明来解释。

例：以 IMPORT ID 1 引入 Issuer `0x00000002` 的文档 `0x0000000000000002` 的最新版本。

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
