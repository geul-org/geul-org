---
title: "上下文边"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "表达'在哪个世界观/语境下此断言为真'的3字轻量Edge。通过来源、世界观、虚构、视角等64种类型编码真理的条件。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge 表达**"在哪个世界观/语境下此 Claim 为真"**。

对应模态逻辑的可能世界概念，同一 Subject 在不同世界观中可以存在不同的事实。

```
Context "现实":        (地球, 年龄, 46亿年)
Context "年轻地球论":   (地球, 年龄, 6000年)
Context "哈利波特":     (魔法, exists, true)
```

## 数据包结构（3字，48位）

```
1st WORD (16位):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10位          │     6位         │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16位)
3rd WORD: Target TID (16位)
```

| 字段 | 位 | 说明 |
|------|------|------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=未指定, 1~62=类型, 63=扩展（保留） |
| Context TID | 16 | 此 Context 的唯一标识符 |
| Target TID | 16 | 目标 Claim（[三元组](../triple-edge/)/[动词](../verb-edge/)/[事件6](../event6-edge/)/[子句](../clause-edge/) TID） |

## Context Type（6位 = 64种）

### 来源（Source）— Code 1~20

| Code | 类型 | 说明 | 示例 |
|------|------|------|------|
| 1 | SYSTEM | 系统自动生成 | 维基数据同步 |
| 2 | USER | 用户直接输入 | 手动编写 |
| 3 | DOCUMENT | 一般文档 | PDF, Word |
| 4 | NEWS | 新闻报道 | 路透社, AP |
| 5 | ACADEMIC | 学术论文 | arXiv, Nature |
| 6 | GOVERNMENT | 政府/公共机构 | SEC, 统计局 |
| 7 | WIKI | 维基百科/维基数据 | Q42, P31 |
| 8 | API | 外部 API | 金融, 天气 |
| 9 | ORG | 机构/组织发布 | 企业 IR |
| 10 | BOOK | 书籍 | 基于 ISBN |
| 11 | INTERVIEW | 采访/证词 | 直接引用 |
| 12 | DATASET | 数据集 | Kaggle |
| 13 | SOCIAL | 社交媒体 | Twitter |
| 14 | LEGAL | 法律/判例 | 法院判决 |
| 15 | ARCHIVE | 档案馆 | archive.org |
| 16 | MULTIMEDIA | 影音 | YouTube |
| 17 | DATABASE | 数据库 | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | 百科全书 | 大英百科 |
| 19 | MANUAL | 手册/指南 | 技术文档 |
| 20 | STANDARD | 标准文档 | ISO, RFC |

### 派生/推理（Derived）— Code 21~30

| Code | 类型 | 说明 | 示例 |
|------|------|------|------|
| 21 | MODEL | AI 模型生成 | GPT, Claude |
| 22 | INFERENCE | 逻辑推理 | 基于规则 |
| 23 | AGGREGATION | 汇总/整合 | 多源综合 |
| 24 | CALCULATION | 计算结果 | 公式应用 |
| 25 | TRANSLATION | 翻译 | 原文→译文 |
| 26 | EXTRACTION | 提取 | NER, RE |
| 27 | CORRECTION | 修正/更正 | 错误修正 |
| 28 | HEARSAY | 传闻/谣言 | 未确认 |
| 29 | ESTIMATION | 估算 | 近似值 |
| 30 | PREDICTION | 预测 | 未来展望 |

### 世界观/信念（Worldview）— Code 31~45

| Code | 类型 | 说明 | 示例 |
|------|------|------|------|
| 31 | RELIGION | 宗教世界观 | 基督教, 佛教 |
| 32 | PHILOSOPHY | 哲学观点 | 存在主义 |
| 33 | SCIENCE | 科学共识 | 现代物理学 |
| 34 | POLITICS | 政治观点 | 保守, 进步 |
| 35 | CULTURE | 文化观点 | 东方, 西方 |
| 36 | MYTHOLOGY | 神话体系 | 希腊神话 |
| 37 | FOLKLORE | 民间传说 | 地方传说 |
| 38 | IDEOLOGY | 意识形态 | 资本主义 |
| 39 | THEORY | 理论 | 相对论 |
| 40 | HYPOTHESIS | 假说 | 验证前 |
| 41 | TRADITION | 传统/习俗 | 儒家传统 |
| 42 | CONSENSUS | 共识/定论 | 学界定论 |
| 43 | MAINSTREAM | 主流观点 | 多数意见 |
| 44 | ALTERNATIVE | 另类观点 | 少数意见 |
| 45 | FRINGE | 非主流/异端 | 伪科学 |

### 虚构/创作（Fiction）— Code 46~55

| Code | 类型 | 说明 | 示例 |
|------|------|------|------|
| 46 | NOVEL | 小说世界观 | 指环王 |
| 47 | FILM | 电影世界观 | MCU |
| 48 | GAME | 游戏世界观 | 塞尔达 |
| 49 | COMICS | 漫画世界观 | DC 宇宙 |
| 50 | ANIMATION | 动画世界观 | 吉卜力 |
| 51 | DRAMA | 电视剧世界观 | 权力的游戏 |
| 52 | THEATER | 戏剧世界观 | 哈姆雷特 |
| 53 | FANFIC | 二次创作 | 同人小说 |
| 54 | LEGEND | 传说 | 亚瑟王 |
| 55 | FAIRYTALE | 童话 | 灰姑娘 |

### 视角/说话人（Perspective）— Code 56~62

| Code | 类型 | 说明 | 示例 |
|------|------|------|------|
| 56 | NARRATOR | 叙述者视角 | 全知叙述 |
| 57 | PROTAGONIST | 主角视角 | 英雄视角 |
| 58 | ANTAGONIST | 反派视角 | 反派视角 |
| 59 | AUTHOR | 作者意图 | 作家解说 |
| 60 | EXPERT | 专家见解 | 学者意见 |
| 61 | LAYMAN | 普通人认知 | 大众认知 |
| 62 | SATIRICAL | 讽刺/反讽 | 反语表达 |

Code 0 为 UNSPECIFIED（未指定），Code 63 为 EXTENDED（扩展，保留）。

## 元数据扩展

Context 自身的附加信息（来源、可信度、世界观名称）通过[三元组边](../triple-edge/)表达。

```
(Context TID, P:source_entity, Reuters_Entity)  - 来源机构
(Context TID, P:confidence, 0.95)               - 可信度
(Context TID, P:universe_name, "哈利波特")       - 世界观名称
(Context TID, P:perspective_holder, 反派_Entity)  - 视角主体
```

## 示例

### 来源："路透社报道"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

附加 Triple:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### 虚构："哈利波特世界观"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "霍格沃茨 is_a 学校"

附加 Triple:
  (0x0302, P:universe_name, "哈利波特")
  (0x0302, P:author, J.K.罗琳)
```

### AI 推理："Claude的推理"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

附加 Triple:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## 设计依据

- **Context Edge 独立类型**：世界观是与 Triple/Clause 不同的元层。对应 RDF Quad 的 G（Graph）。
- **6位 Context Type**：无需另建 Triple 即可立即分类。62种类型覆盖大部分情况。
- **3字轻量结构**：Context 关联大量产生，因此以最小尺寸确保存储效率。
