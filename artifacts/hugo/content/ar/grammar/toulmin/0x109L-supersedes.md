---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: علاقة إقصاء. إذا كان المهاجِم Active أُسقط الهدف من التجميع حتماً. تُكتب السلسلة (`A > B > C`) علاقةً واحدة لكل زوج.

| البند | القيمة |
|---|---|
| الاسم | `SUPERSEDES` (مستند المواصفة BIND `SUPERSEDES`) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| مستند المواصفة | `0x00000000/codecs/0x00001090/` (هدف DECLARE هو `1090`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 9 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: العلاقة، التخطيط: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | علاقة إقصاء. إذا كان المهاجِم Active أُسقط الهدف من التجميع حتماً. تُكتب السلسلة (`A > B > C`) علاقةً واحدة لكل زوج |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | قاعدة → قاعدة. إذا كان Active أُسقط الهدف من التجميع |

- تُكتب السلسلة `A > B > C` في SUPERSEDES علاقةَ SUPERSEDES واحدة لكل زوج. أما الاختصار [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) فليس له تخطيط بعد.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1090`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001090/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
