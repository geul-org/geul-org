---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن معرّف هذا المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DOC-ID` (BIND مستند المواصفة `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| مستند المواصفة | `0x00000000/codecs/0x00001C70/` (هدف DECLARE `1C70`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 7 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | معرّف هذا المستند. Reference مضمّن `DOC-POINTER` (Issuer، معرّف المستند، الإصدار 0). ومستند Codec يستخدم `CODEC-POINTER` (Issuer، Codec ID، الإصدار 0) |
| جهة Hugo | `meta/declaration/doc-id.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | سجل | `0410` DOC-POINTER، `0420` CODEC-POINTER |  |

يعلن معرّف هذا المستند. وهو لازم لكي تشير مستندات أخرى إلى هذا المستند وإلى الأهداف داخله.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length TAG ممتد]
المستند           سجل Reference من DOC-POINTER. (Issuer، معرّف المستند، الإصدار 0). ومستند Codec يستخدم CODEC-POINTER
```

- Codec: Meta `0x1C7L`، فئة التعريف
- Payload: Reference مضمّن واحد [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer، معرّف المستند، الإصدار 0)
- العدد: واحد على الأكثر. وهو إلزامي في مستندات الإصدار تحت `docs/<معرّف المستند>/` و`codecs/<Codec ID>/`

## التفسير والصلاحية {#해석과-유효성}

- Payload هو سجل Reference واحد بالضبط من `DOC-POINTER` (Issuer، معرّف المستند، الإصدار `0`). ولا يُستخدم لمعرّف الإصدار إلا `0`. فالإصدار لا يعيّنه المستند بل تعيّنه قائمة الإصدارات. ومستند Codec يستخدم `CODEC-POINTER` (Issuer، Codec ID، الإصدار `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- لذلك فإن صيغة الإشارة إلى «هذا المستند» واحدة في DOC-ID وفي سجل PUBLICATION في قائمة الإصدارات وفي اقتباسات المستندات الأخرى.
- المستند نفسه بصرف النظر عن الإصدار له `DOC-ID` نفسه. ولا يُكتب معرّف الإصدار ولا تجزئة المحتوى في المستند ([الإصدار](../document.md#버전)).
- لا يوجد عنوان باسم المستند ([عناوين النشر وقوائم الإصدارات](../publishing.md#문서-이름)). والعنوان الذي يقرأه الإنسان يتولاه [LABEL](../edge/0x0A4L-label.md) من نوع العبارة.
- إذا غاب فالمستند بلا اسم ولا يمكن الإشارة إليه إلا بتجزئة المحتوى. وهو لازم لكي يشير مستند آخر إلى LOCAL في هذا المستند بـ Reference إشاري.
- الجهة التي تجلب المستند تتحقق من أن `DOC-ID` في المستند المستلَم يساوي Issuer ومعرّف المستند المطلوبين.
- معرّف المستند `0x0000000000000000` هو مستند فهرس تعريف المصطلحات لدى Issuer ([Issuer](../issuer.md)). وهذا المستند أيضاً مستند إصدار تحت `docs/<معرّف المستند>/` فيوضع له DOC-ID (`DOC-POINTER` (Issuer، `0`، `0`)). أما Issuer نفسه فيمثّله [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- مستندات الإصدار `<معرّف الإصدار>.geul` (ومنها مستندات المواصفة) تحت `<Issuer>/docs/<معرّف المستند>/` و`<Issuer>/codecs/<Codec ID>/` في `.well-known/geul/` يلزمها `DOC-ID`.
- مستندات القوائم استثناء ولا يوضع فيها `DOC-ID`: قائمة الإصدارات `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) وإصدار `<معرّف الإصدار>.geul` من قائمة Issuer في `issuers/` ([عناوين النشر وقوائم الإصدارات](../publishing.md#목록-문서)). وما تسرده القائمة يحدده DOC-POINTER في السجل. وإصدار مستند القائمة تشير إليه PUBLICATION في `versions.geul` الخاص بها بـ DOC-POINTER (`0x00000000`، معرّف مستند محجوز، معرّف الإصدار). أما عنوان تجزئة المحتوى `<Issuer>/hashes/` فهو نسخة من المستندات أعلاه فيتبع الأصل.
- معرّف المستند `0xFFFFFFFFFFFFFFFF` محجوز في كل Issuer (و`0x0000000000000000` كذلك)، ويُستخدم في قائمة Issuer لدى Issuer `0x00000000`. ولا يستخدمه Issuer آخر. ولأن مستند القائمة بلا `DOC-ID` فلا تظهر هذه القيمة إلا في DOC-POINTER داخل سجل `issuers/versions.geul`.
- مستند مواصفة Codec هو مستند Codec لدى GEUL Issuer `0x00000000`. وليس له معرّف مستند، ويضع في `DOC-ID` قيمة CODEC-POINTER (`0x00000000`، Codec ID، `0`). وCodec ID هو قيمة Kind وCodec في TAG WORD مكتوبة في 32 بت (`0x0B80` ← `0x00000B80`) ([مستند المواصفة](../codec-spec.md)).

## مثال {#예시}

- Issuer `0x00000002`، المستند `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG لـ Meta 1 + TAG لـ Reference 1 + Issuer 2 + معرّف المستند 4 + الإصدار 2 = 10 WORD)

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C70/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
