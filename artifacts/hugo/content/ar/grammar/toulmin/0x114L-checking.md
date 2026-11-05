---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: ربط يُجري الحكم فقط دون أثر جانبي.

| البند | القيمة |
|---|---|
| الاسم | `CHECKING` (مستند المواصفة BIND `CHECKING`) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| مستند المواصفة | `0x00000000/codecs/0x00001140/` (هدف DECLARE هو `1140`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 20 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: التنفيذ، التخطيط: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ربط يُجري الحكم فقط دون أثر جانبي |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | `checking c` |
| src → dst | قاعدة → قضية. حكم دون أثر جانبي |

- dst هو REF للعقدة.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1140`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001140/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
