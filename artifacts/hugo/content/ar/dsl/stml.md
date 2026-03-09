---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "لغة إعلان واجهة مستخدم مستقلة عن الإطار. تحدد ما تعرضه الصفحات وتفعله بسمات HTML5 data-*، وتتحقق رمزياً من OpenAPI، وتولّد كود React."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — إعلان واجهة مستخدم مستقل عن الإطار.

كود الواجهة الأمامية يخلط شيئين: **قراراتك** و**توصيلات الإطار**. أي API تستدعي، أي حقول تعرض، بأي ترتيب، تحت أي شروط — هذه القرارات تُدفن في React hooks أو Vue composables. عند تبديل الإطار أو إعادة الهيكلة، تُعاد تفسير القرارات أو تُفقد.

STML يفصل بينهما. القرارات تبقى في HTML قياسي مع سمات `data-*`. توصيلات الإطار تُولَّد أو تُفوَّض.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">مستودع GitHub</a>

## البنية

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  قراراتك. مستقل عن الإطار.
│  ما الذي تجلبه وتعرضه وترسله   │  ينجو من أي إعادة كتابة.
├─────────────────────────────────┤
│  توليد الكود / LLM              │  يولّد توصيلات الإطار.
│  React, Vue, Svelte, أي إطار   │  قابل للاستبدال.
├─────────────────────────────────┤
│  وقت التشغيل (artifacts/)       │  React TSX, Vue SFC, إلخ.
│  hooks، حالة، عرض              │  مُولَّد. لا تحرره.
└─────────────────────────────────┘
```

## ما يتم الحفاظ عليه

كل شيء في HTML الخاص بـ STML هو قرار المستخدم:

- **أي نقاط نهاية API** تستدعيها (`data-fetch`, `data-action`)
- **أي حقول** تعرضها أو تجمعها (`data-bind`, `data-field`)
- **بأي ترتيب** تظهر العناصر (بنية DOM)
- **كيف تبدو** (فئات Tailwind، وسوم HTML)
- **أي نص** يراه المستخدمون (عناوين، placeholders، تسميات الأزرار)
- **أي شروط** تتحكم في الرؤية (`data-state`)
- **أي مكونات** تعالج UX خاص (`data-component`)
- **سلوك القوائم** — ترقيم الصفحات، الترتيب، التصفية

ليس React. ليس Vue. إنه ما تفعله صفحتك، مُعلَن في HTML5 قياسي.

## مثال

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">حجوزاتي</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">لا توجد حجوزات</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="رقم الغرفة" />
    <button type="submit">حجز</button>
  </div>
</main>
```

نفس الملف يمكن أن ينتج أهدافاً مختلفة:

| الهدف | الطريقة |
|---|---|
| React TSX | `stml gen` (توليد كود حتمي مدمج) |
| Vue SFC | أعطِ STML + OpenAPI لـ LLM: "نفّذ بـ Vue" |
| Svelte | أعطِ STML + OpenAPI لـ LLM: "نفّذ بـ Svelte" |
| Flutter | أعطِ STML + OpenAPI لـ LLM: "نفّذ بـ Flutter" |

القرارات تُحفظ. فقط توصيلات الإطار تتغير.

## التحقق

المتحقق المدمج يفحص STML مقابل OpenAPI قبل توليد أي كود:

- هل operationId موجود؟ هل طريقة HTTP صحيحة؟
- هل تتطابق حقول الطلب والاستجابة والمعاملات مع المخطط؟
- هل أعمدة الترتيب/التصفية/التضمين ضمن القوائم المسموحة؟
- هل المكونات المُشار إليها موجودة؟

يكتشف عدم تطابق الواجهة-API في وقت CI، ليس في وقت التشغيل.

```bash
stml validate specs/my-project    # 12 فحصاً رمزياً مقابل OpenAPI
```

## سمات data-*

| السمة | ما تُعلنه |
|---|---|
| `data-fetch` | تحميل بيانات من نقطة نهاية GET |
| `data-action` | إرسال بيانات إلى نقطة نهاية POST/PUT/DELETE |
| `data-field` | جمع حقل من جسم الطلب |
| `data-bind` | عرض حقل من الاستجابة |
| `data-param-*` | العملية تحتاج معامل مسار/استعلام |
| `data-each` | التكرار على حقل مصفوفة |
| `data-state` | العرض المشروط |
| `data-component` | التفويض لمكون مخصص |
| `data-paginate` | قائمة مُرقَّمة الصفحات |
| `data-sort` | قائمة قابلة للترتيب (العمود والاتجاه الافتراضي) |
| `data-filter` | قائمة قابلة للتصفية (أي الأعمدة) |
| `data-include` | تضمين موارد مرتبطة |

## الترخيص

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
