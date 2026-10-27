---
title: "文档"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "GEUL 数据的单位是文档。文档指定长度开启，以 END 关闭，分为 HEAD（Meta 与整个文档的来源）和 BODY（Reference·Value·Edge）。每个版本都用内容哈希固定。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 数据的单位是一个文档（DOC）。一个文件（`.geul`，媒体类型 `application/vnd.geul`）就是一个文档。

## 结构

```
DOC-*            ← 开启文档（总长度）
  Meta …         ← HEAD：关于文档的记录
  SOURCE …       ←   （整个文档的来源及其 QUALIFIER）
BODY             ← 结束 HEAD，开启 BODY
  Reference, Value, Edge …
END              ← 关闭文档
```

| 记录 | TAG | 含义 |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | 以 1 WORD 指定总长度来开启文档 |
| DOC-2WORD | `1901` + 2 WORD | 以 2 WORD 指定总长度 |
| DOC-4WORD | `1A02` + 4 WORD | 以 4 WORD 指定总长度 |
| BODY | `180E` | 1 WORD。结束 HEAD，开始 BODY |
| END | `180F` | 1 WORD。关闭文档 |

- DOC-* 的值是从开启记录的起点到 END 的终点的总 WORD 数。使用能容纳该值的最窄宽度。
- END 是必需的。END 的位置与 DOC-* 的长度不符则拒绝。没有 END 输入就结束，说明文档被截断。
- 解码器可以凭 DOC-* 的长度一次跳过整个文档。
- 不存在在不知道长度的情况下开启的方法。无法预先知道结尾的实时数据，要切成已知长度的单位，作为多个文档发送。
- HEAD 为空时省略 BODY。没有 BODY 记录的文档整体都是 BODY。BODY 只放一次。HEAD 中只要有一条记录（Meta 或 HEAD Edge），就要放 BODY。
- 文档不嵌套。其他文档用 [IMPORT](/zh/grammar/meta/) 或指示 Reference 指向。

## HEAD 与 BODY

- HEAD 中只放 Meta 和 **HEAD Edge** 两种。二者都是关于容纳它们的**文档**的叙述。
  - Meta：文档的结构·定义·出处·谱系·验证·策略·IMPORT。
  - HEAD Edge：记录整个文档来源的依据 Edge [SOURCE](/zh/grammar/edge/source/#整个文档的来源)（Target `0`），以及以该 SOURCE 为 Target 的 [QUALIFIER](/zh/grammar/edge/qualifier/)（原文哈希、获取时刻、原文范围等）。QUALIFIER 放在该 SOURCE 之后。
- BODY 中只放 Reference、Value、Edge。单条记录的出处用 BODY 内的依据 Edge [SOURCE](/zh/grammar/edge/source/) 来写，可信度等其他依据用附在该记录上的 QUALIFIER 来写。Target 为 `0` 的 SOURCE，以及以 HEAD SOURCE 为 Target 的 QUALIFIER，不能放在 BODY 中。
- 解码器从前往后读取 HEAD 并加以划分。Meta 属于 HEAD。Target 为 `0` 的 SOURCE 属于 HEAD，并记住其 Edge Id。以所记住的 SOURCE 为 Target 的 QUALIFIER 属于 HEAD。遇到其他记录时，如果 HEAD 为空，说明省略了 BODY（从该记录起为 BODY），否则因缺少 BODY 而 invalid。
- **Edge Id 在 HEAD 和 BODY 中共用一个编号空间。** 在文档内唯一，与 BODY 的 Edge 一样，从 [NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/) 获取。如果 HEAD Edge 的 Origin 是 LOCAL，则其定义放在 BODY 中（LOCAL 的范围是整个文档）。
- Meta 可以在 Payload 内包含 Value 记录。被包含的 Value 不是独立记录，而是该 Meta 的一部分。
- 声明（Meta 定义类）的范围是该文档。

## 基本声明

两个声明都至多一个。哪些文档必须有，由下面的条件决定。

| Meta | 含义 | 必须有的文档 |
|---|---|---|
| [SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/) | 所遵循的规范版次。决定如何读取其余记录。不认识的版次则拒绝或警告。v1 文档的值是 `0x0001` | 公布的文档。没有则按解码器已知的版次读取 |
| [DOC-ID](/zh/grammar/meta/declaration/doc-id/) | 文档自身的标识符。要从文档外部指向本文档及其中的目标，就必须有 | `.well-known/geul/` 下名称以 `0x` 开头的文档（版本文档、规格文档）。版本列表·名称索引中不放 |

- `SPEC-VERSION` 只放一个整数，使任何版次的解码器都能读取（v1 是 `1890 0001`）。不依赖 Value 码。
- `DOC-ID` 是指向自身的 DOC-POINTER（Issuer、文档 ID、版本 `0`）。文档 ID 是 4 WORD。
- 没有 `DOC-ID` 的文档是无名文档。只能通过内容哈希指向。

## 内容哈希

一份文档用**内容哈希**来指向（与 git 的提交 ID 作用相同）。

- 是从开启记录（DOC-*）到 END 之前的 SHA-256。16 WORD。
- 验证类 Meta（签名等）不参与计算。因此把签名放进文档也不会产生循环。
- 计算时，DOC-* 的长度要换成去掉验证记录后的长度，宽度也换成适合该长度的最窄宽度。因此加签名前后内容哈希相同。
- 内容哈希不记录在文档中，而是计算得出。只有指向其他版本时才作为值写出（`PARENT` 等）。
- 文档内的 `PARENT` 也参与计算，所以内容哈希构成贯穿全部历史的哈希链。
- 在文档外事后附加的 Meta（独立仓库中的注释等）不会改变内容哈希（与 git notes 相同）。
- 文档以二进制为正本。内容哈希和签名只对二进制计算。

## 版本

有名文档（有 `DOC-ID` 的文档）具有版本。

- **版本 ID** 是在一个文档内按公布顺序从 1 开始编号的 2 WORD 整数。`0` 表示"未写版本"，按最新版本处理。
- 版本 ID 由公布方在公布时分配。版本 ID 与内容哈希的对应放在公布方签名的版本列表中（[公布地址与版本列表](/zh/grammar/publishing/#版本列表)）。
- 不重复公布相同内容。如果内容哈希已存在，则返回该版本 ID。
- 2 WORD 用完后，以新的文档 ID 发布。
- v2 及之后的版本在 HEAD 中写 `PARENT`（上一版本的内容哈希）。它进入内容哈希，因此各版本以哈希链相连。最初版本不放。

## 修订

GEUL 文档像法令一样被修订。

- **版本不可变。** 已公布的版本不修改也不删除。例外只有法定删除和依职权删除（[TOMBSTONE](/zh/grammar/edge/publication/)）。
- 不删除历史。修改的内容以新版本发布，不覆盖原版本（保留旧法）。改写的版本用 [REPLACES](/zh/grammar/meta/lineage/replaces/) 连接原版本。
- branch、HEAD、reflog 这类会变化的指针不放在文档中。在文档之外（仓库·索引）管理。
- 新版本可以新增、修订、删除定义。不承诺与前一版本兼容。同一术语的定义发生变化也是修订（例：民法"成年"20 岁 → 19 岁，刑法强奸罪对象"妇女" → "人"）。
- **LOCAL ID 是跨版本的身份**（如同条文编号）。相同的 LOCAL ID 即使版本不同也指向同一目标。
  - 新增：获得新的 LOCAL ID。ID 没有顺序含义，所以不需要"第 X 条之二"这样的插入。新编号从版本列表的 `NEXT-LOCAL-ID` 获取（auto increment）。
  - 修订：修改同一 LOCAL ID 的内容。
  - 删除：在新版本中去掉该 LOCAL ID。**已删除的 ID 不再使用。**
  - 移动·拆分·合并：获得新的 LOCAL ID，并在新记录上附加 QUALIFIER P1365（replaces，值为旧 LOCAL ID）来连接旧 ID。旧 ID 不再使用，所以指向前一版本中的那条记录。
- 从来源资料重新生成文档的工具也要遵守此规则。与上一版本相同的叙述沿用相同的 LOCAL ID，只给变化或新增的叙述分配新编号。不得每次都从 1 重新编号。
- 引用要确定版本。固定了版本的引用绑定到该版本，最新（版本 `0`）的引用绑定到解读时刻的现行版本。涉及过去事件的文档，要固定引用当时施行的版本。
- 公布与施行不同。公布时刻由版本列表记录，施行期间由文档记录。
  - [EFFECTIVE-FROM](/zh/grammar/meta/declaration/effective-from/)·[EFFECTIVE-UNTIL](/zh/grammar/meta/declaration/effective-until/)：整个版本的施行期间
  - 条文 Edge 的 QUALIFIER P580（开始）·P582（结束）：各条文施行日不同时
- **时点 T 施行的版本，是施行日不晚于 T 的最高版本。** 如果有各条文的 P580·P582 QUALIFIER，则以其为准。已过有效期（`EFFECTIVE-UNTIL`）的版本不是施行中。
- 过渡规定（"依原规定"）、行为时法与对被告有利的新法之间的选择等，决定适用哪个版本的规则，由判定（[TOULMIN](/zh/grammar/edge/toulmin/)）负责。施行信息是其素材。
- 解释例·判例收窄或放宽术语的解释，不是文档修订，而是判定规则。以立法方式确定解释的情形（例：劳动基准法新增"1 周"的定义）是修订。
- Codec 和格式编号的二进制（wire）布局不修订。因为以格式编号编码的记录，读取时不固定 codebook 版本。要改变布局就分配新编号。已删除的格式编号不再用于其他格式。

## diff 存储

版本始终以整个文档（快照）来定义。diff 只是少存储·少传输该快照的格式。

- 只有有 `DOC-ID` 且 BODY 全是 Edge 的文档才能做成 diff。不做版本管理的 `versions.geul`·`documents.geul`·`issuers.geul` 以及无名文档不使用 diff。
- diff 文档是普通的 GEUL 文档，在 HEAD 中放 [DELTA-BASE](/zh/grammar/meta/lineage/delta-base/)（基准版本 ID）。
- 删除用 [DELTA-REMOVE](/zh/grammar/meta/lineage/delta-remove/)（要去除的 LOCAL ID 列表）来写，新增和修订用 BODY 的 Edge 来写。没有单独的新增·修订标记。Edge Id 在基准中存在则为修订，不存在则为新增。
- 快照复原必须是确定性的（这样哈希才能吻合）。
  1. 复原基准版本的快照。如果基准也是 diff，则递归复原。
  2. HEAD 整体替换为 diff 的 HEAD 去掉 `DELTA-BASE`·`DELTA-REMOVE` 之后的内容。HEAD Edge 也一并替换（不写入 `DELTA-REMOVE`）。
  3. BODY 保持基准顺序。去掉 `DELTA-REMOVE` 中的 ID，diff BODY 的 Edge Id 在基准中存在时，就地替换。
  4. 基准中没有的 Edge Id，按它在 diff 中出现的顺序追加到末尾。
  5. 结果的内容哈希必须与版本列表中该版本的哈希相同。不同则 invalid。
- 在 diff 中再次使用已删除的 LOCAL ID 则 invalid。被去掉的 HEAD Edge 的 Edge Id 也不再使用。
- 内容哈希、版本列表、签名都以复原后的快照为准。
