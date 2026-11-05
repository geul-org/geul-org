---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE سجل النص الأصلي والتقسيم في مستند TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE سجل النص الأصلي والتقسيم في مستند TOULMIN. المعنى: النص الأصلي المكتوب.

| البند | القيمة |
|---|---|
| الاسم | `SOURCE` (مستند المواصفة BIND `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| مستند المواصفة | `0x00000000/codecs/0x00001200/` (هدف DECLARE هو `1200`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 0 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: ID وWORD لعرض SPAN وقيمة UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | النص الأصلي المكتوب |
| جهة Hugo | `edge/toulmin/source.md` |

## التخطيط {#레이아웃}

هذا هو النص الأصلي المكتوب كاملاً. وكل SPAN هو نطاق بايتات داخل هذا النص.

```
ID
WORD عرض SPAN    أعلى 2 بت = العرض (00=1، 01=2، 10=4، 11=8 WORD)، والـ14 بت الباقية = 0
النص الأصلي      سجل UTF8-TEXT Value
```

- SOURCE هو أول سجل في BODY. وفي المستند سجل واحد منه.
- SPAN حقلان: بايت البداية وعدد البايتات. وكل حقل عدد صحيح unsigned بالعرض الذي يحدده WORD عرض SPAN (1/2/4/8 WORD).
- وهو Codec مختلف عن Edge الدليل [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](_index.md#공통-필드)). يأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1200`). يُحدَّد إعلان الحقول مع مستند مواصفة Codec الخاص بـ TOULMIN ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [SOURCE والتقسيم](_index.md#source와-구획)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001200/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
