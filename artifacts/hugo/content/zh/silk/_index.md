---
title: "SILK — LLM知识的符号索引"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "用64位整数检索的神经符号搜索架构。无需向量数据库、ANN图或嵌入模型，亚秒级检索维基数据1亿实体。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — 神经符号搜索架构。

用64位整数检索。不需要向量数据库、ANN图、嵌入模型。

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub 仓库</a>

## 核心命题

搜索从来不是难题，而是**无结构数据的症状**。
在写入时赋予64位结构，症状就消失了。

```python
results = index[(index & mask) == pattern]
```

在1.3GB内存中亚秒级检索维基数据1亿实体。
仅用Python（NumPy）就胜过优化的C++/Rust向量数据库——架构的胜利。

## 为什么不用向量嵌入

向量嵌入会碾碎结构。

```
"诸葛亮是三国时期蜀汉的丞相"
 → 人类立刻把握：中国人、军事家/政治家、3世纪

嵌入模型：
 [0.234, -0.891, 0.445, ..., 0.112] (384维 float)
 → 结构消失。无法判断是人物还是地点。

为了恢复被碾碎的结构：
 ANN图 (HNSW, IVF-PQ)、交叉编码器、重排器、元数据过滤器……
```

SILK保留结构。

```
SIDX: [Human / military / east_asia / ancient]
 → 结构保留在比特中。可读。
 → 无需恢复。因为从未碾碎过。
```

关键在于顺序的反转。

```
传统方式：先写入 → 后结构化（索引）
SILK：    写入时结构化 → 检索免费
```

## SIDX 比特布局

SIDX遵循[GEUL语法](/zh/grammar/) Entity Node规范。

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| 字段 | 比特 | 宽度 | 说明 |
|------|------|------|------|
| prefix | 63-57 | 7 | GEUL协议头（`0001001`固定，检索时忽略） |
| mode | 56-54 | 3 | 量化/数模式（注册实体=0，定冠、普遍、存在等8种） |
| entity_type | 53-48 | 6 | 64个顶级类型（Human=0 ~ Election=62，未分类=63） |
| attrs | 47-0 | 48 | 按类型的属性编码（由码本定义） |

检索目标：entity_type 6位 + attrs 48位 = **54位**。
QID不包含在SIDX中，存储在单独的数组中。

### attrs 48位 — 按类型模式

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

目前5个类型已定义属性比特布局。其余仅编码entity_type。

## 架构

SILK有两条流水线：**编码**（写入时）和**检索**（查询时）。
两者遵循同一原理：符号掌控结构，LLM处理语义。

```
编码流水线（写入时）
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  LLM 标注    │──►│  VALID 验证  │──►│  码本编码    │
│  文档 → JSON │   │  码本有效值  │   │ JSON → SIDX  │
│  （语义分类）│   │  一致性检查  │   │（比特组装）  │
│              │   │  幻觉 → 丢弃│   │              │
└──────────────┘   └──────────────┘   └──────────────┘
   LLM标注          代码验证          基于码本编码
```

```
检索流水线（查询时）
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  查询解析    │──►│比特 AND 过滤 │──►│  LLM 判定    │
│  码本查找    │   │  NumPy SIMD  │   │ 少量候选     │
│  + LLM辅助   │   │1亿条 → 数十条│   │数十条 → 答案 │
└──────────────┘   └──────────────┘   └──────────────┘
   语义提取          广泛过滤          精准判定
```

核心策略：**SIDX比特AND不遗漏地广泛过滤**，然后**LLM只判定少量候选**。

```
各司其职：
 人类：结构设计（码本）
 LLM： 语义分类（标注）+ 语义判定（检索）
 代码：规则验证（VALID）+ 比特组装
 CPU： 大量比较（NumPy SIMD）
```

### 编码：LLM标注 → VALID验证

LLM读取文档并标注为JSON。VALID按码本执行机械检查。
不在码本中的值、类型间一致性违反、约束违反**在物理上无法进入索引**。

```
LLM标注：{"type": "Human", "occupation": "military", "country": "korea"}
VALID：  occupation="military" ∈ 码本? ✓  country="korea" ∈ 码本? ✓
         Human却有constellation字段? ✗ 丢弃
编码：   从码本查找 "military"→6位, "korea"→8位 → 比特组装 → SIDX uint64
```

LLM可能产生幻觉。但VALID充当守门人，索引污染概率为零。
只有通过VALID的JSON才会经码本编码为SIDX 64位整数。

### 检索：广泛过滤，LLM精准判定

```
1. 查询语义提取     码本查找 80% / LLM辅助 20%
2. 位掩码组装       确定性 — 算法
3. NumPy比特AND    确定性 — 1亿条全量扫描 20ms
4. LLM最终判定     仅少量候选 — 语义精准判定
```

### 80%的检索是结构化查询

```
"诸葛亮"         → Q181871 精确匹配。比特AND。完成。
"华为新闻"       → org/company + doc_meta/news。比特AND。完成。
"拜登-习近平会晤" → Q6279 ∩ Q15031 ∩ meeting。交集。完成。
```

```
结构化查询（80%）：SILK比特AND完结。无需LLM。
语义查询 （15%）：SILK缩小候选 → LLM判定5-10条。
生成查询 （5%）： SILK定位文档 → LLM生成。
```

## Multi-SIDX

一个文档/事件可以携带多个SIDX。

```
新闻报道"华为·英伟达·比亚迪高管会面"：

SIDX[0]: [Human / business / east_asia ]  任正非
SIDX[1]: [Org   / company / east_asia ]  华为
SIDX[2]: [Human / business / n_america]  黄仁勋
SIDX[3]: [Org   / company / n_america]  英伟达
SIDX[4]: [Human / business / east_asia ]  王传福
SIDX[5]: [Org   / company / east_asia ]  比亚迪
SIDX[6]: [Event / meeting / east_asia ]  会面
```

全部是相同的64位SIDX。相同的索引。相同的比特AND检索。
entity_type字段区分实体（Human, Org）和事件（Event）。

## 索引结构

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# 总计 ~1.3GB 内存
```

```
索引构建：
 Elasticsearch：分词 → 分析 → 倒排索引 → 段合并
 Pinecone：     嵌入 → HNSW图 → 聚类
 SILK：         sort
```

无需数据结构。只有一个排序数组。

## 向量数据库对比

|  | SILK | 向量数据库 |
|------|------|-----------|
| 索引大小（1万亿条） | 12TB | 1.5PB（125倍） |
| 索引构建 | sort | HNSW 数天 |
| 冷启动 | 打开文件即可 | 构建图 数小时 |
| 分区扫描 | 可以（结果相同） | 不可能（图断裂） |
| 复合条件 | 交集（精确） | 压缩为1个向量（近似） |
| 结果 | 精确（集合运算） | 近似（相似度排名） |
| 可审计性 | JSON（白盒） | 不可能（黑盒） |

```
比特AND与顺序无关、无状态、可合并。
向量数据库：整个图必须在内存中。分区 = 破坏。
SILK：     任意切割仍可工作。分区 = 变慢而已。结果相同。
```

## 审计流水线

向量嵌入是黑盒，无法审计。SIDX是JSON，完全可审计。

```
第1阶段 — 小型LLM标注    Llama 8B / GPT-4o-mini。准确率85-90%。
第2阶段 — VALID机械检查   有效值、一致性、约束。成本 $0。
第3阶段 — 大型LLM审计     仅confidence=low。准确率99%+。

VALID是守门人：码本有效值之外的幻觉在物理上无法进入索引。
```

## 许可证

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub</a>
