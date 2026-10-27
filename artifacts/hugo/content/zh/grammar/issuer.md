---
title: "Issuer 与公布"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Issuer 是定义文档和格式的主体。按宽度（1·2·4·16 WORD）不同，签发方式也不同。本页规定 Issuer 等级与 1 WORD 分配表、文档公开方式、签名与验证密钥公开。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 不把标识体系集中在一处。各个 Issuer 定义目标和格式，其他文档引用已公布的定义。定义可以作为对外保密使用，也可以在 geul.org（CC0）或私有公布（Issuer 规定的许可证）下公布。信任并使用哪个定义，由用户决定。

公布地址、格式指定、名称索引、版本列表、信任层由[公布地址与版本列表](/zh/grammar/publishing/)规定。

## Issuer 定义的内容

| 对象 | 方法 |
|---|---|
| 目标（实体、概念、术语） | 以自己文档的 LOCAL 声明 |
| Value 格式 | 在 Issuer 码之下以格式编号定义 |
| Edge 格式 | 在 Issuer 码之下以格式编号定义 |

- Value·Edge 格式的定义也作为文档公布。

## 原则

- 所有 ID 的范围都是文档。LOCAL ID（包括 Edge Id、变量）和 IMPORT ID 只在该文档内有效。
- Issuer 定义的目标是该 Issuer 公布的文档的 LOCAL。其他文档用指示声明（`EXTERNAL-ISSUER-*`）直接引用，或用 `IMPORT-DOC` 导入后以 `EXTERNAL-POINTER-*` 指向。
- 对需要从文档外部指向的目标，签发公布文档的 LOCAL。该文档必须有 [DOC-ID](/zh/grammar/meta/declaration/doc-id/)。

## Issuer 等级

| 宽度 | 取值范围 | 签发 |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org 分配给标准制定组织和主要机构（[1 WORD 分配表](#1-word-分配表)） |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | 在 geul.org 注册。经过域名所有权证明 |
| 4 WORD | `2^32`~`2^64−1` | 在 geul.org 注册。没有所有权证明 |
| 16 WORD | `2^64` 以上 | 自行签发。由公钥计算得出 |

- **Issuer ID 是整数值。** 值相同即为同一个 Issuer（`0x0001` 与 `0x00000001` 是同一个值）。宽度不是标识符的一部分。
- **规范形式是最短宽度。** 用能容纳该值的最短宽度书写，拒绝更宽宽度的写法。因此各宽度的分配从紧邻下一级宽度范围结束之后的值开始（2 WORD 从 `0x00010000` 开始）。

## 1 WORD 分配表

1 WORD Issuer 由 geul.org 分配给标准制定组织和主要机构。GEUL 设计的专有格式放在 `GEUL` 之下，没有制定组织的事实标准或惯例格式放在 `ADHOC` 之下。

| Issuer | 名称 | 组织 | 代表格式 |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | GEUL 专有格式、codebook |
| `0x0001` | ADHOC | geul.org | 没有制定组织的惯例格式。BFLOAT16、BLAKE3、复数·分数·区间·四元数、向量·张量 |
| `0x0002`~`0x000F` | 保留 | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601、ISO 4217（货币）、ISO 3166（国家） |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000（单位写法） |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | ISO/IEC 信息技术标准 |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509、X.690（ASN.1 编码） |
| `0x0014`~`0x001F` | 保留 | 国际标准组织 | |
| `0x0020` | IETF | Internet Engineering Task Force | URI（RFC 3986）、UUID（RFC 9562）、CRC32C、IPv4·IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | 媒体类型、语言子标签注册表 |
| `0x0022` | W3C | World Wide Web Consortium | XML Schema 数据类型、RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL、HTML |
| `0x0024` | UNICODE | Unicode Consortium | 字符编码、规范化、CLDR |
| `0x0025` | ECMA | Ecma International | JSON（ECMA-404） |
| `0x0026`~`0x003F` | 保留 | 互联网·Web 标准组织 | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | IEEE 754 浮点·decimal、MAC 地址（802） |
| `0x0041` | KHRONOS | Khronos Group | 像素格式（RGBA8·BGRA8 UNORM）、glTF |
| `0x0042` | OGC | Open Geospatial Consortium | 坐标·边界框、GeoJSON 系列 |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Microscaling 格式（E8M0、FP4 E2M1） |
| `0x0045` | OASIS | OASIS Open | 文档·安全标准 |
| `0x0046`~`0x005F` | 保留 | 产业标准组织 | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | SI 单位、TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | 闰秒、UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2（FIPS 180-4）、SHA-3（FIPS 202） |
| `0x0063` | GPS | GPS 政府运营主体 | GPS 时间 |
| `0x0064`~`0x00FF` | 保留 | 计量·政府机构 | |
| `0x0100` | KATS | 韩国技术标准院 | KS 标准 |
| `0x0101`~`0x01FF` | 保留 | 国家标准机构 | |
| `0x0200`~`0xFFFF` | 保留 | 后续分配 | |

- 扩展格式放在制定该格式的组织的 Issuer 之下。Issuer 之下的格式编号由各 Issuer 定义。
- 格式编号的高位必须遵循对应 Kind 的系列规则。这样没有 codebook 也能知道系列。
- 如果标准组织不直接管理 GEUL 格式编号，则由 geul.org 代为把该组织的标准登记为编号。编号与标准文档标识符一起记录。
- 分配在组织划分的范围内从小编号开始。范围只是分类上的方便，解码器没有解读它的义务。

## 16 WORD Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 签名算法 ID(2 字节) ‖ 公钥)
```

- 把得到的 32 字节从高字节开始写入 16 WORD。
- 无需注册，任何人都可以创建。所有权由该私钥的签名来证明。
- 公钥和算法在文档 HEAD 中用 [ISSUER-KEY](/zh/grammar/meta/verification/issuer-key/) 声明。签名算法 `0x0001` 是 Ed25519，其他值保留。
- 前缀 `GEUL-ISSUER-v1` 使同一个密钥用于其他用途时不会得到相同的 ID（用途分离）。
- 即使签名算法改变（例：Ed25519 → ML-DSA），ID 宽度仍然是 16 WORD。
- 如果结果小于 `2^64`（概率实际上为 0），则不用该密钥创建 Issuer。因为它会与最短宽度规则冲突。

## 域名证明

- 2 WORD Issuer 的域名所有权证明只在注册时确认。之后的域名管理是 Issuer 的责任。
- 一个域名只对应一个 Issuer。一个 Issuer 可以有多个域名。对应关系用 Issuer 名称索引 `issuers.geul` 的 BIND 来写（[公布地址与版本列表](/zh/grammar/publishing/#issuer-名称)）。
- 即使域名过期或转手，对应关系仍保留在最初证明的 Issuer 上。新所有者不能把该域名用作 Issuer 名称。
- 域名用于地址输入和显示。GEUL 文档内只写 Issuer ID。

## 术语定义文档

- Issuer 定义的术语（工具、程序、角色、组织内的概念）采用**一个术语一个文档**。术语是该文档的 LOCAL，名称用 [BIND](/zh/grammar/edge/bind/) 连接，所指向的外部目标（URI 等）用 [REFERENCE-NODE](/zh/grammar/edge/reference-node/) 连接。
- 其他文档用 `EXTERNAL-ISSUER-*`（Issuer、文档 ID、LOCAL ID）指向术语。不在每个文档中重复同一个定义。例：[TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/) 的工具。
- 术语定义文档的文档 ID 区间由 Issuer 决定。geul.org（`0x0000`）使用 `0x0001xxxx xxxxxxxx`（[Codec 规格文档](/zh/grammar/codec-spec/#geul-issuer-的文档-id)）。
- 各 Issuer 的文档 ID `0x0000000000000000` 保留为该 Issuer 的**术语定义索引文档**：`<Issuer>/0x0000000000000000/`。是列出术语定义文档的位置。
- 索引文档**建议**所有 Issuer 设置，但不是必需的。没有索引时，术语定义文档通过名称索引 `documents.geul` 查找。
- 指向外部目标的顺序：(1) 如果有合适的 Reference Codec 就用它（WIKIDATA-QID 等），(2) 如果有定义该目标的 GEUL 文档就用它（DOC-POINTER·EXTERNAL-ISSUER），(3) 都没有就在自己的术语定义文档中以 LOCAL 定义并指向。

## 文档公开方式

| 方式 | 对象 | 许可证 | 版本管理 | 存续 |
|---|---|---|---|---|
| 对外保密 | 所有 Issuer | Issuer 内部 | Issuer | 取决于 Issuer |
| geul.org 公布 | 1·2 WORD Issuer | CC0 | geul.org | geul.org 保存 |
| 私有公布 | 所有 Issuer | 由 Issuer 规定 | Issuer | 取决于 Issuer |

### geul.org 公布

- 1·2 WORD Issuer 可以把文档注册到 geul.org 并公布。注册的文档是 CC0。
  - 1 WORD Issuer 经过 geul.org 的事先审查后公布。
  - 2 WORD Issuer 注册后立即公布，问题事后处理。
- 可以公布的定义是概念和 codec。**指向自然人的 Reference 不能在 geul.org 公布。** 以对外保密或私有公布的方式处理。
  - 例外：允许用 [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) 指向自然人。
- 注册的版本不修改也不删除，即使 Issuer 消失，文档也会保留（保留旧法）。例外是法定删除和依职权删除（[TOMBSTONE](/zh/grammar/edge/publication/)）。
- Issuer 只能在定义上标注停用建议（deprecated）。被建议停用的定义仍会继续被解读。
- 同一文档的新版本可以新增、修订、删除定义（[文档](/zh/grammar/document/#修订)）。**已删除的实体 ID 和格式编号不再用于其他目标。** 格式编号的 wire 布局不修订。

### 私有公布

- 想以非 CC0 许可证公布的 Issuer，在私有网络（自有域名等）上提供文档。许可证在文档 HEAD 中用 [LICENSE](/zh/grammar/meta/policy/license/) 声明。
- 私有公布也使用与 geul.org 相同的路径（[公布地址与版本列表](/zh/grammar/publishing/)）。
- 版本管理、可用性、域名维护、许可证条件由 Issuer 决定。geul.org 不参与也不担保私有公布。

### 对外保密

- 对外保密的文档不公布。设置访问控制，并用 [ACCESS](/zh/grammar/meta/policy/access/) 标注。
- 如果把使用了对外保密定义的文档发送到外部，接收方无法解读其中的 Reference·Value·Edge，只能跳过。要与外部交换的定义应当公布。

### 用户的选择

- 用户根据所声明的许可证和 Issuer 的存续可能性来选择使用的文档。
- 许可证过于苛刻或存续不稳的 Issuer 的定义不会被使用。
- 需要长期保存的引用，使用 geul.org 公布的文档。

## 签名

- 签名对公布文档是必需的。在 HEAD 中用 [SIGNATURE](/zh/grammar/meta/verification/signature/) 放置。没有签名的文档也是有效的 GEUL 文档，对外保密·内部文档也尽量签名。
- 签名对象是文档的**内容哈希**（[文档](/zh/grammar/document/#内容哈希)）。不只对 BODY 签名。
  - HEAD 中有解读规则。如果改变 `IMPORT-DOC` 的目标，同一个 BODY 就会指向不同的目标。
  - 如果不对 `LICENSE`·`PARENT` 签名，许可证和历史就可能被伪造。
- 一个文档可以有多个签名。都对同一个内容哈希签名，所以追加签名不会改变内容哈希。
- 签名密钥确认：
  - 1·2·4 WORD Issuer：在 geul.org 注册的密钥（见下面的验证密钥公开）。
  - 16 WORD Issuer：同一文档的 `ISSUER-KEY`。用该公钥算出的 Issuer ID 必须与签名者相同。
- 读取方在没有签名时降低可信度；有签名但验证失败，则是篡改·冒充的证据，要降低得更多。
- 文档签名由该文档的 Issuer 完成，版本列表签名由分配版本 ID 的公布方完成（[公布地址与版本列表](/zh/grammar/publishing/#签名主体)）。

## 验证密钥公开

- geul.org 公开注册 Issuer（1·2·4 WORD）的签名验证密钥。
- 密钥列表作为 GEUL Issuer（`0x0000`）的公布文档发布。是 CC0，并由 geul.org 签名。
  - 项目：Issuer、签名算法 ID、公钥、生效起始时点、废止时点与原因。
- 被废止的密钥也不删除。过去的签名用签名时点有效的密钥验证。
- 密钥更换时，用旧密钥对新密钥签名后注册。验证方即使不信任 geul.org，也能确认密钥的连续性。
- 密钥变更记录保存为只能追加的日志（与 Certificate Transparency、Go sumdb 相同的方式）。篡改历史就会暴露。
- 如果丢失密钥而无法用旧密钥签名，geul.org 重新确认身份后注册新密钥。2 WORD Issuer 要重新经过域名所有权证明。这种情况需要信任 geul.org，并把原因记入日志。
- 16 WORD Issuer 不适用。因为 Issuer ID 由公钥计算得出，只凭文档内的 `ISSUER-KEY` 即可验证。

## 导入

IMPORT 只导入文档。

```
IMPORT-DOC                      DOC-POINTER(Issuer + 文档 ID + 版本 ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + 文档 ID + LOCAL ID (无需 IMPORT)
ISSUER-POINTER                  Issuer (Issuer 自身)
DOC-POINTER                     Issuer + 文档 ID + 版本 ID (2 WORD, 0 为最新)
```

- 任何宽度的 Issuer 及其文档，都可以不经 IMPORT 用指示声明指向。Issuer 自身用 `ISSUER-POINTER`，文档自身用 `DOC-POINTER`，文档的 LOCAL 用 `EXTERNAL-ISSUER-*`。指示声明跟随最新版本，要固定版本则使用 `IMPORT-DOC`（版本 ID）和 `EXTERNAL-POINTER-*`。
- 正文 Reference 不写完整路径（Issuer + 文档 + 目标 ID），只用 IMPORT ID + 目标 ID。
- IMPORT ID 的宽度在 `IMPORT-DOC` 中由长度决定，在 `EXTERNAL-POINTER-*` 中由 Codec 决定。只在该文档内有效（[IMPORT-DOC](/zh/grammar/meta/import/import-doc/)）。
- 不带版本 ID 导入则跟随最新版本。写了版本 ID 则固定到该版本。公布文档要写版本 ID。

## 许可证

- geul.org 公布的文档和 GEUL Issuer（`0x0000`）的文档是 CC0。
- 私有公布文档的许可证由 Issuer 决定。GEUL 不强制。
- GEUL 核心产出物不复制非 CC0 的 Issuer 文档的内容。

## 未决问题

- 4 WORD·16 WORD Issuer 是否允许在 geul.org 公布。
- 域名所有权证明方式（DNS TXT `_geul.<域名>`、HTTP `.well-known`），以及是否把签名密钥指纹绑定到证明值上。
- 密钥丢失恢复时对域名劫持的应对。若仅凭域名重新证明就注册新密钥，劫持者就能夺走 Issuer。研究注册联系方式确认、宽限期与对旧密钥的异议、参照域名争议结果。
- 术语定义索引文档（文档 ID `0`）的记录格式（列出术语定义文档的 Edge）。
- 签名算法默认值（推荐 Ed25519）。
