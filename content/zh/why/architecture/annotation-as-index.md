---
title: "为什么注释应该成为索引"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["索引", "注释", "代码", "AST", "设计模式"]
summary: "注释是为人写的。但当函数多达10,000个时，机器也必须能读。将注释从叙述变为索引，全量扫描就变成了即时检索。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

注释是为人写的。

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

这段注释对人阅读有帮助。但机器读了什么也不知道。不知道"retrieves"是Read还是Search。不知道"user"是哪个实体。不知道这个函数是Service模式还是Repository模式。

因为注释是叙述。

---

## 当函数有10,000个时

函数只有10个时无所谓。人可以全部读完。

函数有10,000个时就不一样了。当你说"把所有跟支付相关的函数都找出来"，人找不到，机器也找不到。只能找到名字里带"payment"的。名字里没有的就漏掉了。

AI代理修改代码时也一样。让Claude Code"修改PaymentFailed的错误处理"，代理会重新阅读全部代码。每次都是。10,000个函数每次从头理解。昨天读过的代码今天又读一遍。即使有注释也一样。因为注释是人类的叙述。机器要从叙述中提取语义就需要推理。很贵。

---

## 如果注释是索引

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

这段注释人能读，机器也能读。

"所有Service模式的函数" → 搜索Pattern字段。即时。
"与Order实体相关的所有函数" → 搜索Entity字段。即时。
"会抛出PaymentFailed的函数" → 搜索errs字段。即时。

全量扫描变成了索引检索。O(n)变成了O(1)。

---

## 不需要人来写

这个索引不需要人来编写。

代码被修改时自动检测。文件监听。
将修改的函数通过AST分离。机械操作。
将函数体交给小型LLM。"判断这个函数的模式、实体和动作。"
将判断结果按固定格式插入。机械操作。

人什么都不用做。只需要写代码。索引会自动附加。

在整个流水线中，LLM介入的节点只有一个——判断函数的语义。其余全部是确定性代码。

---

## 从推理到规则

这里还可以再进一步。

当小型LLM对相同模式反复附加相同索引时——检测这种重复。如果"Service后缀的receiver方法就标注Pattern:Service"重复了100次，就固化为规则。之后不再调用LLM。由规则处理。

LLM调用逐渐减少。规则逐渐增多。成本趋近于零。

注释从叙述变为索引，
索引从手动变为自动，
自动从推理变为规则。

---

## 为什么可行：设计模式就是码本

这之所以可行是有原因的。

编程中已经有了标准化的语义词汇。那就是设计模式。

Singleton、Factory、Observer、MVC、Service。自从GoF在1994年整理了23个模式以来，软件行业用了30年来扩展和标准化这套词汇。

GoF 23模式。Enterprise Application Patterns。Cloud Design Patterns。Go Concurrency Patterns。全都已经整理好了。

这些词汇没有歧义。Singleton就是Singleton。开发者不会各有不同的解读。定义是共识的，实现条件是明确的，违反了会在代码审查中被发现。

这套词汇体系就成了索引的码本。不需要新建。已经存在了。

自然语言没有这个。"伟大"在字典里有定义，但每个人用法不同。在代码中，Service不会被每个人用得不一样。

---

## 为什么代码是最简单的领域

GEUL的上下文流水线——[明确化](/zh/why/clarification/)、[索引](/zh/why/semantically-aligned-index/)、[验证](/zh/why/mechanical-verification/)、[过滤](/zh/why/filter/)、[一致性](/zh/why/consistency-check/)、[探索](/zh/why/exploration/)——应用于自然语言很难。应用于代码很容易。

明确化：自然语言是模糊的。代码只要通过了编译器，语义就是确定的。
索引：自然语言的实体要看上下文才知道。代码的实体AST已经解析好了。
验证：自然语言的有效性无法定义。代码的有效性由编译器判定。
过滤：自然语言的相关性需要LLM判断。代码的相关性可以通过调用图机械地判断。
一致性：自然语言的矛盾需要推理才能发现。代码的矛盾由类型系统和测试捕获。
探索：自然语言知识是扁平的。代码已经有包→文件→类型→方法的层级结构。

同一条流水线，在代码领域以更低的成本运行。先在最容易的地方证明，再向困难的地方扩展。这就是工程。

---

## 总结

注释本来是为人而写的。
现在它也必须为机器而写。
人能阅读，同时机器能检索的注释。
是叙述，同时是索引的注释。

代码已经有了语义，已经有了结构，已经有了词汇。
缺的只是索引。
让注释成为那个索引就好。
