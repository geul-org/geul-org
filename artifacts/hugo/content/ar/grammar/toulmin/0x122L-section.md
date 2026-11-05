---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION سجل النص الأصلي والتقسيم في مستند TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION سجل النص الأصلي والتقسيم في مستند TOULMIN. المعنى: بداية قسم.

| البند | القيمة |
|---|---|
| الاسم | `SECTION` (مستند المواصفة BIND `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| مستند المواصفة | `0x00000000/codecs/0x00001220/` (هدف DECLARE هو `1220`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 2 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: ID ورمز القسم في 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | بداية قسم |
| جهة Hugo | `edge/toulmin/source.md` |

## التخطيط {#레이아웃}

هذه بداية قسم. ورمز القسم هو 1 WORD.

```
ID
رمز القسم       1 WORD
```

| الرمز | القسم | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | قاعدة بتعبير شرطي |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- لا يُستخدم `0`. وتُعلن الأقسام بترتيب هذه الرموز.
- عنوان القسم هو [PROSE](0x125L-prose.md) الذي يلي SECTION مباشرة.

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](_index.md#공통-필드)). يأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1220`). يُحدَّد إعلان الحقول مع مستند مواصفة Codec الخاص بـ TOULMIN ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [SOURCE والتقسيم](_index.md#source와-구획)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001220/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
