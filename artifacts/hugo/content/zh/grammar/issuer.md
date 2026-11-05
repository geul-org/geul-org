---
title: "Issuer 与公布"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL 不把标识体系集中在一处。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 不把标识体系集中在一处。各 Issuer 定义对象和格式，其他文档引用已公布的定义。定义可以作为内部机密使用，也可以在 geul.org（CC0）或私有公布（Issuer 指定的许可证）中公布。信任哪个定义由用户决定。

公布地址、格式指定、Issuer 列表、版本列表、信任层由[公布地址与版本列表](publishing.md)规定。

## Issuer 定义的内容 {#issuer가-정의하는-것}

| 对象 | 方法 |
|---|---|
| 对象（实体、概念、术语） | 在自己文档中以 LOCAL 声明 |
| Reference 格式 | 在 Issuer 码之下以 2 WORD Codec 编号定义 |
| Value 格式 | 在 Issuer 码之下以 2 WORD Codec 编号定义 |
| Edge 格式 | 在 Issuer 码之下以 2 WORD Codec 编号定义 |

- Reference·Value·Edge 格式的定义也以文档公布。

## 原则 {#원칙}

- Issuer 定义的对象是该 Issuer 所公布文档的 LOCAL。其他文档用指示声明（`EXTERNAL-ISSUER-*`）直接引用，或用 `IMPORT-DOC` 导入后以 `EXTERNAL-POINTER-*` 指向。[REFERENCE-ISSUER](reference/_index.md#reference-issuer) 记录的含义由 Issuer 发行的 Codec 文档规定。
- 对于需要在文档之外指向的对象，发放已公布文档的 LOCAL。该文档必须有 [DOC-ID](meta/0x1C7L-doc-id.md)。

## Issuer 等级 {#issuer-등급}

| 宽度 | 取值范围 | 发放 |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | 在 geul.org 注册。经过域名所有权证明。geul.org 分配给标准制定机构和主要机构的编号也是这个宽度（[2 WORD 分配表](#2-word-배정표)） |
| 4 WORD | `2^32`~`2^64−1` | 在 geul.org 注册。没有所有权证明 |
| 16 WORD | `2^64` 以上 | 自行发放。由公钥计算 |

- **Issuer ID 是整数值。** 值相同即为同一个 Issuer。宽度不是标识符的一部分。
- **在较短的 Issuer ID 前补 0 的较长写法是同一个 Issuer**（2 → 4、2 → 16、4 → 16 WORD）。`0x00000001` 与 `0x0000000000000001` 是同一个 Issuer。因此不会分配 `0x00000000XXXXXXXX` 作为 4 WORD Issuer，也不会分配高 12 WORD 为 0 的值作为 16 WORD Issuer。
- **规范形式是最短宽度。** 记录中使用能容纳该值的最短宽度书写，拒绝更宽宽度的写法。因此各宽度的分配从紧邻的较窄宽度范围结束之后的值开始。2 WORD 是最短宽度。用于公布地址时，按发放宽度的位数（2 WORD 8 位、4 WORD 16 位、16 WORD 64 位）和十六进制大写书写（用小写书写的地址也会转成大写后查找），读取时将加宽的写法也视为同一个 Issuer（[公布地址与版本列表](publishing.md#id-표기)）。

## 2 WORD 分配表 {#2-word-배정표}

geul.org 将 2 WORD Issuer 编号从前往后依次分配给标准制定机构和主要机构。没有制定机构的事实标准或惯例格式，放在 `ADHOC`（`adhoc.geul.org`）之下。GEUL 设计的固有格式是直接码。标准制定机构的 Issuer 是 geul.org 子域名 Issuer。子域名是小写的机构名称（`<机构名>.geul.org`，例：`iso.geul.org`、`iec.geul.org`）。域名写在下表中。

| Issuer | 名称 | 域名 | 机构 | 代表格式 |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | 直接码规格文档（codebook） |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | 维基数据条目·属性文档 |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | 没有制定机构的惯例格式。BFLOAT16、BLAKE3、复数·分数·区间·四元数、向量·张量 |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601、ISO 4217（货币）、ISO 3166（国家） |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000（单位表示） |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | ISO/IEC 信息技术标准 |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509、X.690（ASN.1 编码） |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI（RFC 3986）、UUID（RFC 9562）、CRC32C、IPv4·IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | 媒体类型、语言子标签注册表 |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | XML Schema 数据类型、RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL、HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | 字符编码、规范化、CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON（ECMA-404） |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | IEEE 754 浮点·decimal、MAC 地址（802） |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | 像素格式（RGBA8·BGRA8 UNORM）、glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | 坐标·边界框、GeoJSON 系列 |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Microscaling 格式（E8M0、FP4 E2M1） |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | 文档·安全标准 |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | SI 单位、TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | 闰秒、UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2（FIPS 180-4）、SHA-3（FIPS 202） |
| `0x00000016` | GPS | `gps.geul.org` | GPS 政府运营主体 | GPS 时间 |
| `0x00000017` | KATS | `kats.geul.org` | 韩国国家技术标准院（국가기술표준원） | KS 标准 |

- 扩展格式放在制定该格式的机构的 Issuer 之下。Issuer 之下的 Codec 编号由各 Issuer 定义。
- Codec 编号由 Issuer 决定。GEUL 不规定含义。Codec 编号与 Kind 无关，在该 Issuer 内不重复（[公布地址与版本列表](publishing.md#id-표기)）。
- 标准机构若不直接管理 GEUL Codec 编号，则由 geul.org 代为将该机构的标准登记为编号。编号与标准文档标识符一并记录。
- 新的标准制定机构获得下一个空闲编号。
- **域名可能改变。** Issuer 与域名的绑定以后可能改变。Issuer ID 不会改变。机构直接管理后，替换为该机构的官方域名。
- **geul.org 子域名不是官方发布方。** 使用标准机构名称的 geul.org 子域名不是该机构的官方发布方。例如 `iso.geul.org` 不是 ISO 的官方发布方。

## 16 WORD Issuer {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 签名算法 ID(2字节) ‖ 公钥)
```

- 将结果 32 字节从高位字节起写入 16 WORD。
- 无需注册，任何人都可以创建。所有权由该私钥的签名证明。
- 公钥和算法由文档 HEAD 的 [ISSUER-KEY](meta/0x1E5L-issuer-key.md) 声明。签名算法 `0x0001` 是 Ed25519，其他值为 Reserved。
- 前缀 `GEUL-ISSUER-v1` 使同一密钥用于其他用途时不会得到相同的 ID（用途分离）。
- 即使签名算法改变（例：Ed25519 → ML-DSA），ID 宽度仍为 16 WORD。
- 结果小于 `2^64` 时（概率几乎为 0），不用该密钥创建 Issuer。因为这会与最短宽度规则冲突。

## 域名证明 {#도메인-증명}

- 2 WORD Issuer 的域名所有权证明只在注册时确认。此后域名管理是 Issuer 的责任。
- 一个域名只对应一个 Issuer。一个 Issuer 可以有多个域名。对应关系用 Issuer 列表 `issuers/` 的 BIND 记录（[公布地址与版本列表](publishing.md#issuer-목록)）。
- 域名到期或转让后，对应关系仍保留给最初证明的 Issuer。新的所有者不能将该域名用作 Issuer 名称。
- 域名用于解析器·CLI 的输入和显示。不是公布 URL 地址（[公布地址与版本列表](publishing.md#도메인-이름)）。GEUL 文档内只写 Issuer ID。

## 术语定义文档 {#용어-정의-문서}

- Issuer 定义的术语（工具、程序、角色、组织内的概念）**一个术语一个文档**。术语是该文档的 LOCAL，名称用 [BIND](edge/0x0A3L-bind.md)，所指的外部对象（URI 等）用 [REFERENCE-NODE](edge/0x0A0L-reference-node.md) 连接。
- 其他文档用 `EXTERNAL-ISSUER-*`（Issuer、文档 ID、LOCAL ID）指向术语。不在每个文档中重复相同的定义。例：[TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) 的工具。
- 术语定义文档的文档 ID 区间由 Issuer 决定。geul.org（`0x00000000`）使用 `0x0001xxxx xxxxxxxx`。
- 每个 Issuer 都保留文档 ID `0x0000000000000000` 和 `0xFFFFFFFFFFFFFFFF`。目前的用途有以下两种。
- 文档 ID `0x0000000000000000` 是该 Issuer 的**术语定义索引文档**的位置：`<Issuer>/docs/0x0000000000000000/`。是列出各术语定义文档的位置。
- 文档 ID `0xFFFFFFFFFFFFFFFF` 用于 Issuer geul.org（`0x00000000`）的 Issuer 列表 `issuers/`。其他 Issuer 不使用这个 ID。在任何 Issuer 中，这个 ID 都不通过 `<Issuer>/docs/<文档 ID>/` 地址提供（404）（[公布地址与版本列表](publishing.md#목록-문서)）。
- 对所有 Issuer **建议**设置索引文档。不是必需的。
- 指向外部对象的顺序：(1) 有合适的 Reference Codec 则用它（WIKIDATA-QID 等），(2) 有定义该对象的 GEUL 文档则用它（DOC-POINTER·EXTERNAL-ISSUER），(3) 都没有则在自己的术语定义文档中以 LOCAL 定义并指向。

## 文档公开方式 {#문서-공개-방식}

| 方式 | 对象 | 许可证 | 版本管理 | 存续 |
|---|---|---|---|---|
| 内部机密 | 所有 Issuer | Issuer 内部 | Issuer | 取决于 Issuer |
| geul.org 公布 | 2 WORD Issuer | CC0 | geul.org | geul.org 保存 |
| 私有公布 | 所有 Issuer | 由 Issuer 决定 | Issuer | 取决于 Issuer |

### geul.org 公布 {#geulorg-공표}

- 2 WORD Issuer 可以将文档注册到 geul.org 并公布。注册的文档为 CC0。注册后立即公布，问题事后处理。
- 可以公布的定义是概念和 Codec。**指向自然人的 Reference 不能在 geul.org 公布。** 以内部机密或私有公布处理。
  - 例外：允许用 [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) 指向自然人。
- 已注册的版本不修改也不删除，即使 Issuer 消失，文档也会保留（保存旧法）。例外是法定删除和依职权删除（[TOMBSTONE](edge/0x0BAL-tombstone.md)）。
- Issuer 只能在定义上标记弃用建议（deprecated）。被建议弃用的定义仍会被继续解释。
- 同一文档的新版本可以新设、修订、删除定义（[文档](document.md#개정)）。**已删除的实体 ID 和 Codec 编号不再用于其他对象。** Codec 编号的 wire 布局不做修订。

### 私有公布 {#사설-공표}

- 想以非 CC0 许可证公布的 Issuer，在私有网络（自有域名等）中提供文档。许可证由文档 HEAD 的 [LICENSE](meta/0x1DEL-license.md) 声明。
- 私有公布也使用与 geul.org 相同的路径（[公布地址与版本列表](publishing.md)）。
- 版本管理、可用性、域名维护、许可证条件由 Issuer 决定。geul.org 不参与也不担保私有公布。

### 内部机密 {#대외비}

- 内部机密文档不公布。设置访问控制并用 [ACCESS](meta/0x1DFL-access.md) 标示。
- 将使用了内部机密定义的文档发送到外部，接收方无法解释其中的 Reference·Value·Edge，会跳过它们。要与外部交换的定义应当公布。

### 用户的选择 {#사용자의-선택}

- 用户根据所声明的许可证和 Issuer 的存续可能性来选择要使用的文档。
- 限制过多的许可证或存续不稳的 Issuer 的定义不会被使用。
- 需要长期保存的引用，使用 geul.org 公布的文档。

## 签名 {#서명}

- 签名对公布文档是必需的。在 HEAD 中以 [SIGNATURE](meta/0x1E6L-signature.md) 放置。没有签名的文档也是有效的 GEUL 文档，内部机密·内部文档也尽可能签名。
- 签名对象是文档的**内容哈希**（[文档](document.md#내용-해시)）。不只对 BODY 签名。
  - HEAD 中有解释规则。更改 `IMPORT-DOC` 的目标，同一个 BODY 就会指向不同的对象。
  - 不对 `LICENSE`·`PARENT` 签名，许可证和历史就可能被伪造。
- 一个文档可以有多个签名。它们都对同一个内容哈希签名，所以增加签名不会改变内容哈希。
- 签名密钥确认：
  - 2·4 WORD Issuer：在 geul.org 注册的密钥（见下文验证密钥公开）。
  - 16 WORD Issuer：同一文档的 `ISSUER-KEY`。用其公钥计算出的 Issuer ID 必须与签名者相同。
- 读取方在没有签名时降低可信度；有签名但验证失败，是篡改·冒充的证据，因此降得更多。
- 文档签名由该文档的 Issuer 完成，版本列表签名由分配版本 ID 的公布方完成（[公布地址与版本列表](publishing.md#서명-주체)）。

## 验证密钥公开 {#검증키-공개}

- geul.org 公开注册 Issuer（2·4 WORD）的签名验证密钥。
- 密钥列表作为 GEUL Issuer（`0x00000000`）的公布文档发布。为 CC0，由 geul.org 签名。
  - 条目：Issuer、签名算法 ID、公钥、生效起始时间、作废时间与原因。
- 已作废的密钥也不删除。过去的签名用签名时有效的密钥验证。
- 更换密钥时，用旧密钥对新密钥签名后注册。验证方即使不信任 geul.org，也能确认密钥的连续性。
- 密钥变更记录保存在只能追加的日志中（与 Certificate Transparency、Go sumdb 相同的方式）。篡改历史就会暴露。
- 丢失密钥而无法用旧密钥签名时，由 geul.org 重新确认身份并注册新密钥。2 WORD Issuer 要重新经过域名所有权证明。这种情况需要信任 geul.org，并在日志中留下原因。
- 16 WORD Issuer 不适用。Issuer ID 由公钥计算得出，因此仅凭文档内的 `ISSUER-KEY` 即可验证。

## 导入 {#가져오기}

IMPORT 只导入文档。

```
IMPORT-DOC                      DOC-POINTER(Issuer + 文档 ID + 版本 ID) + IMPORT ID
                                Codec 文档为 CODEC-POINTER(Issuer + Codec ID + 版本 ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + 文档 ID + LOCAL ID (无需 IMPORT)
ISSUER-POINTER                  Issuer (Issuer 自身)
DOC-POINTER                     Issuer + 文档 ID + 版本 ID (2 WORD, 0 为最新)
CODEC-POINTER                   Issuer + Codec ID + 版本 ID (2 WORD, 0 为最新)
```

- 任何宽度的 Issuer 及其文档，都可以不经 IMPORT 用指示声明指向。Issuer 自身用 `ISSUER-POINTER`，文档自身用 `DOC-POINTER`，文档的 LOCAL 用 `EXTERNAL-ISSUER-*`。指示声明跟随最新版本，要固定版本则使用 `IMPORT-DOC`（版本 ID）和 `EXTERNAL-POINTER-*`。
- 指向外部文档对象的正文 Reference，不写完整路径（Issuer + 文档 + 对象 ID），只写 IMPORT ID + 对象 ID。[REFERENCE-ISSUER](reference/_index.md#reference-issuer) 写 Issuer 和 Codec 编号。
- IMPORT ID 的宽度在 `IMPORT-DOC` 中由长度决定，在 `EXTERNAL-POINTER-*` 中由 Codec 决定（[IMPORT-DOC](meta/0x1E4L-import-doc.md)）。
- 不带版本 ID 导入则跟随最新版本。写了版本 ID 则固定到该版本。公布文档要写版本 ID。

## 许可证 {#라이선스}

- geul.org 公布的文档和 GEUL Issuer（`0x00000000`）的文档为 CC0。
- 私有公布文档的许可证由 Issuer 决定。GEUL 不强制。
- **Issuer 格式的许可证。** 只有 geul.org 提供的直接码和公布物是 CC0。Issuer 格式的许可证由该 Issuer 决定。
- **Issuer 标示。** GEUL 的 Resolve 依赖于 Issuer 标示。使用其他 Issuer 的 Codec 的文档，始终会标示该 Issuer。
- GEUL 核心产出物不复制非 CC0 的 Issuer 文档的内容。

## 未决问题 {#열린-문제}

- 域名所有权证明方式（DNS TXT `_geul.<域名>`、HTTP `.well-known`），以及是否将签名密钥指纹绑定到证明值。
- 密钥丢失恢复时对域名劫持的应对。只靠域名重新证明就注册新密钥，劫持者可能夺走 Issuer。研究确认注册联系人、宽限期与旧密钥异议、参照域名争议结果。
- 术语定义索引文档（文档 ID `0`）的记录格式（列出术语定义文档的 Edge）。
- 签名算法默认值（推荐 Ed25519）。
