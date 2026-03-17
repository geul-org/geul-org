---
title: "المستودعات"
date: 2026-02-28T12:00:00+09:00
summary: "مستودعات GitHub التي يتكون منها مشروع GEUL. مواصفات اللغة، دفاتر شفرات القواعد، البحث، والموقع الإلكتروني."
image: "/images/og-default.webp"
---

جميع المستودعات موجودة في منظمة [geul-org](https://github.com/geul-org) على GitHub.

---

## اللغة

### geul

لغة اصطناعية محاذاة دلالياً وتنسيق تدفق ثنائي للذكاء الاصطناعي.

نظام لغوي من 2 بايت (65,536 رمزاً) مصمم للتواصل الواضح بين البشر والذكاء الاصطناعي. كل عبارة تحمل مصدرها وطابعها الزمني ومستوى ثقتها. كل كيان له معرّف فريد. يعمل تنسيق التدفق بوحدات 16 بت، ويحدد 10 أنواع من الحزم (Verb Edge وEntity Node وTriple Edge وغيرها) تحت نظام بادئة من 10 بتات.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| اللغة | Go, Python |
| الرخصة | MIT |

---

## القواعد

### geul-verb

دفتر شفرات الأفعال SIDX بـ 16 بت (مبني على WordNet).

يربط مجموعات مترادفات أفعال WordNet بأكواد 16 بت للاستخدام في حزم GEUL Verb Edge. يوفر مفردات الأفعال التي يستهلكها تنسيق التدفق.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| اللغة | Python |
| الرخصة | MIT |

### geul-entity

دفتر شفرات الكيانات SIDX بـ 48 بت (مبني على Wikidata).

يرمّز كيانات Wikidata إلى معرّفات مهيكلة من 48 بت. يحدد أنواع الكيانات، ويصمم مخططات سمات لكل نوع، ويبني دفاتر الشفرات التي يستهلكها SILK.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| اللغة | Python |
| الرخصة | MIT |

### geul-quantities

دفتر شفرات عقد الكميات.

يحدد مخطط ترميز قيم الكميات — أرقام بوحدات ونطاقات ودقة — المستخدمة في حزم GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| اللغة | Python |
| الرخصة | MIT |

### geul-ast

دفتر شفرات حواف AST.

يحدد مخطط ترميز حواف شجرة البنية التجريدية، مما يتيح تمثيل الشفرة المهيكلة داخل تنسيق تدفق GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| اللغة | Python |
| الرخصة | MIT |

---

## البحث

### silk

SILK (Symbolic Index for LLM Knowledge) — بنية بحث عصبية-رمزية.

يبحث باستخدام أعداد صحيحة من 64 بت. لا حاجة لقاعدة بيانات متجهية، ولا رسم بياني ANN، ولا نموذج تضمين. عملية AND بتية واحدة بـ NumPy تبحث في 100 مليون سجل، والادعاء الأساسي هو أن Python وحدها تتفوق على البحث المتجهي المحسّن بـ C++/Rust. يوفر خط أنابيب استعلامات هجيناً يجمع بين البحث في دفاتر الشفرات ومساعدة نماذج اللغة الكبيرة.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| اللغة | Python |
| الرخصة | MIT |

---

## الموقع

### geul-org

الكود المصدري لهذا الموقع.

مولّد مواقع ثابتة Hugo يدعم 12 لغة. يُنشر عبر S3 + CloudFront، مع CloudFront Function للكشف عن اللغة وعناوين URL النظيفة.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| اللغة | Hugo (Go Templates), CSS |
| الرخصة | MIT |
