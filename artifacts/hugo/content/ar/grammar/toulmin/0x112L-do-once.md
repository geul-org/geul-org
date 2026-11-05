---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: إجراء يُنفَّذ مرة واحدة فقط حتى عند إعادة المحاولة.

| البند | القيمة |
|---|---|
| الاسم | `DO-ONCE` (مستند المواصفة BIND `DO-ONCE`) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| مستند المواصفة | `0x00000000/codecs/0x00001120/` (هدف DECLARE هو `1120`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 18 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: التنفيذ، التخطيط: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إجراء يُنفَّذ مرة واحدة فقط حتى عند إعادة المحاولة |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | قاعدة → FuncRef |

- dst هو FuncRef. يمثّل هذا Codec الصيغة `do … once`. لا يُستخدم F_ONCE في flags (يُرفض إن كان مفعّلًا).
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1120`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001120/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
