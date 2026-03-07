---
title: "حافة السياق"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "حافة خفيفة بـ 3 كلمات تعبّر عن 'في أي رؤية/سياق يكون هذا الادعاء صحيحاً'. تُشفّر شروط الحقيقة عبر 64 نوعاً تشمل المصادر، الرؤى، الخيال، والمنظور."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge تعبّر عن **"في أي رؤية/سياق يكون هذا الادعاء صحيحاً"**.

تقابل مفهوم العوالم الممكنة في المنطق الموجه (Modal Logic)، حيث يمكن لنفس الموضوع أن تتعدد حقائقه حسب الرؤية.

```
Context "الواقع":        (الأرض، العمر، 4.6 مليار سنة)
Context "الأرض الفتية":  (الأرض، العمر، 6000 سنة)
Context "هاري بوتر":     (السحر، exists, true)
```

## بنية الحزمة (3 كلمات، 48 بت)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10bit         │     6bit        │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| الحقل | البتات | الوصف |
|-------|--------|-------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=غير محدد، 1~62=نوع، 63=موسع(محجوز) |
| Context TID | 16 | معرّف فريد لهذا Context |
| Target TID | 16 | TID الادعاء المستهدف ([ثلاثية](../triple-edge/)/[فعل](../verb-edge/)/[حدث6](../event6-edge/)/[جملة](../clause-edge/) TID) |

## Context Type (6 بت = 64 نوعاً)

### المصدر (Source) — Code 1~20

| Code | النوع | الوصف | مثال |
|------|-------|-------|------|
| 1 | SYSTEM | إنشاء آلي | مزامنة ويكي بيانات |
| 2 | USER | إدخال مباشر | كتابة يدوية |
| 3 | DOCUMENT | مستند عام | PDF, Word |
| 4 | NEWS | أخبار | رويترز، AP |
| 5 | ACADEMIC | ورقة أكاديمية | arXiv, Nature |
| 6 | GOVERNMENT | جهة حكومية/عامة | SEC، مكتب الإحصاء |
| 7 | WIKI | ويكيبيديا/ويكي بيانات | Q42, P31 |
| 8 | API | API خارجي | مالي، طقس |
| 9 | ORG | إعلان مؤسسة/منظمة | علاقات المستثمرين |
| 10 | BOOK | كتاب | مبني على ISBN |
| 11 | INTERVIEW | مقابلة/شهادة | اقتباس مباشر |
| 12 | DATASET | مجموعة بيانات | Kaggle |
| 13 | SOCIAL | وسائل تواصل | Twitter |
| 14 | LEGAL | قانون/سوابق | حكم قضائي |
| 15 | ARCHIVE | أرشيف | archive.org |
| 16 | MULTIMEDIA | فيديو/صوت | YouTube |
| 17 | DATABASE | قاعدة بيانات | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | موسوعة | بريتانيكا |
| 19 | MANUAL | دليل | وثائق فنية |
| 20 | STANDARD | معيار | ISO, RFC |

### المشتق/الاستنتاج (Derived) — Code 21~30

| Code | النوع | الوصف | مثال |
|------|-------|-------|------|
| 21 | MODEL | إنتاج نموذج AI | GPT, Claude |
| 22 | INFERENCE | استنتاج منطقي | قائم على قواعد |
| 23 | AGGREGATION | تجميع/دمج | تجميع مصادر متعددة |
| 24 | CALCULATION | نتيجة حسابية | تطبيق صيغة |
| 25 | TRANSLATION | ترجمة | أصل→ترجمة |
| 26 | EXTRACTION | استخراج | NER, RE |
| 27 | CORRECTION | تصحيح | إصلاح خطأ |
| 28 | HEARSAY | رواية/إشاعة | غير مؤكد |
| 29 | ESTIMATION | تقدير | قيمة تقريبية |
| 30 | PREDICTION | توقع | تنبؤ مستقبلي |

### الرؤية/المعتقد (Worldview) — Code 31~45

| Code | النوع | الوصف | مثال |
|------|-------|-------|------|
| 31 | RELIGION | رؤية دينية | إسلام، مسيحية |
| 32 | PHILOSOPHY | منظور فلسفي | وجودية |
| 33 | SCIENCE | إجماع علمي | فيزياء حديثة |
| 34 | POLITICS | منظور سياسي | محافظ، تقدمي |
| 35 | CULTURE | منظور ثقافي | شرقي، غربي |
| 36 | MYTHOLOGY | نظام أساطير | أساطير يونانية |
| 37 | FOLKLORE | حكايات شعبية | قصص محلية |
| 38 | IDEOLOGY | نظام أيديولوجي | رأسمالية |
| 39 | THEORY | نظرية | نسبية |
| 40 | HYPOTHESIS | فرضية | قبل التحقق |
| 41 | TRADITION | تقليد/عُرف | تقاليد عربية |
| 42 | CONSENSUS | إجماع/تقليد سائد | رأي أكاديمي |
| 43 | MAINSTREAM | رأي سائد | رأي الأغلبية |
| 44 | ALTERNATIVE | رأي بديل | رأي الأقلية |
| 45 | FRINGE | هامشي/بدعة | زائف |

### الخيال/الإبداع (Fiction) — Code 46~55

| Code | النوع | الوصف | مثال |
|------|-------|-------|------|
| 46 | NOVEL | عالم رواية | سيد الخواتم |
| 47 | FILM | عالم فيلم | MCU |
| 48 | GAME | عالم لعبة | زيلدا |
| 49 | COMICS | عالم كوميكس | عالم DC |
| 50 | ANIMATION | عالم رسوم متحركة | جيبلي |
| 51 | DRAMA | عالم مسلسل | صراع العروش |
| 52 | THEATER | عالم مسرح | هاملت |
| 53 | FANFIC | إبداع ثانوي | فان فيكشن |
| 54 | LEGEND | أسطورة | الملك آرثر |
| 55 | FAIRYTALE | حكاية خرافية | سندريلا |

### المنظور/الراوي (Perspective) — Code 56~62

| Code | النوع | الوصف | مثال |
|------|-------|-------|------|
| 56 | NARRATOR | منظور الراوي | راوٍ كلي المعرفة |
| 57 | PROTAGONIST | منظور البطل | وجهة نظر البطل |
| 58 | ANTAGONIST | منظور الخصم | وجهة نظر الشرير |
| 59 | AUTHOR | قصد المؤلف | تفسير المؤلف |
| 60 | EXPERT | رأي خبير | رأي عالم |
| 61 | LAYMAN | تصور العامة | تصور شعبي |
| 62 | SATIRICAL | سخرية/تهكم | تعبير ساخر |

Code 0 هو UNSPECIFIED (غير محدد)، Code 63 هو EXTENDED (موسع، محجوز).

## توسيع البيانات الوصفية

المعلومات الإضافية عن Context ذاته (المصدر، الموثوقية، اسم الرؤية) تُعبَّر عبر [حافة الثلاثية](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)   - جهة المصدر
(Context TID, P:confidence, 0.95)                 - الموثوقية
(Context TID, P:universe_name, "هاري بوتر")        - اسم العالم
(Context TID, P:perspective_holder, Villain_Entity) - صاحب المنظور
```

## أمثلة

### مصدر: "تقرير رويترز"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

Additional Triples:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### خيال: "عالم هاري بوتر"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts is_a school"

Additional Triples:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### استنتاج AI: "استنتاج Claude"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

Additional Triples:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## مبررات التصميم

- **Context Edge كنوع مستقل**: الرؤية طبقة ميتا مختلفة عن Triple/Clause. تقابل G (Graph) في RDF Quad.
- **6 بت Context Type**: تصنيف فوري بدون Triple إضافي. 62 نوعاً تغطي معظم الحالات.
- **بنية خفيفة 3 كلمات**: ربط Context يحدث بكثرة، لذا الحجم الأدنى يضمن كفاءة التخزين.
