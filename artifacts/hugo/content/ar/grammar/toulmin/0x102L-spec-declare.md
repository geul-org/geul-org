---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN. المعنى: إعلان معيار الحكم (Backing). تحدد بتات role نوع التعريف.

| البند | القيمة |
|---|---|
| الاسم | `SPEC-DECLARE` (مستند المواصفة BIND `SPEC-DECLARE`) |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| مستند المواصفة | `0x00000000/codecs/0x00001020/` (هدف DECLARE هو `1020`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 2 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: الإعلان، التخطيط: NODE |
| TAG WORD | `0001 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إعلان معيار الحكم (Backing). تحدد بتات role نوع التعريف |
| جهة Hugo | `edge/toulmin/node.md` |

## التخطيط {#레이아웃}

التخطيط هو [NODE](_index.md#node). تحدد ترويسة من 1 WORD قيمة role وlevel وشكل Claim والحقول الشرطية.

| البند | القيمة |
|---|---|
| TANGEUL | بند في Definitions (`means` و`has`) |
| العقدة | معيار الحكم (Backing). يحدد role نوع التعريف |

- role هو نوع التعريف.
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1020`). لا يمكن إعلان الحقول الشرطية في تخطيط NODE وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [NODE](_index.md#node)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001020/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
