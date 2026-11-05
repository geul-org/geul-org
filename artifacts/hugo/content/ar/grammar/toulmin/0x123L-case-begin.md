---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN سجل النص الأصلي والتقسيم في مستند TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN سجل النص الأصلي والتقسيم في مستند TOULMIN. المعنى: بداية نطاق القضية.

| البند | القيمة |
|---|---|
| الاسم | `CASE-BEGIN` (مستند المواصفة BIND `CASE-BEGIN`) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| مستند المواصفة | `0x00000000/codecs/0x00001230/` (هدف DECLARE هو `1230`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 3 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: ID وREF (القضية) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | بداية نطاق القضية |
| جهة Hugo | `edge/toulmin/source.md` |

## التخطيط {#레이아웃}

هذه بداية نطاق القضية.

```
ID
القضية          REF (CASE-DECLARE NODE)
```

- تُعرَّف القضية بـ NODE من [CASE-DECLARE](0x100L-case-declare.md)، ويقع نطاقها بين CASE-BEGIN و[CASE-END](0x124L-case-end.md) اللذين يشيران إليها.

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](_index.md#공통-필드)). يأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1230`). يُحدَّد إعلان الحقول مع مستند مواصفة Codec الخاص بـ TOULMIN ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [SOURCE والتقسيم](_index.md#source와-구획)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001230/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
