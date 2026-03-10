---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "تعليق Go واحد يساوي تسلسلاً واحداً. 10 أنواع تسلسل ثابتة تغطي جميع التفرعات الثنائية في طبقة الخدمة، وتوليد الكود الرمزي ينتج معالجات gin."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — تعليق Go واحد يساوي تسلسلاً واحداً. أعلنه وسيُولَّد معالج gin.

منطق الخدمة هو سلسلة من القرارات: أي نموذج تستعلم، ماذا تحرس، متى ترفض، ماذا تُرجع. هذه القرارات تخص من يفهم العمل — لكنها تُدفن في الكود النمطي، وتتبعثر عبر الطبقات، وتُفقد في إعادة الكتابة.

SSaC يحفظ هذه القرارات كمواصفات تصريحية. أعلن **ماذا** يحدث و**بأي ترتيب**، سطراً بسطر، والأداة تولّد التنفيذ.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (تعليقات DSL)        (التحقق)          (توليد الكود)    (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">مستودع GitHub</a>

## الفكرة الأساسية

كل دالة خدمة هي تسلسل من الخطوات. كل خطوة تتبع عقداً ثنائياً: **نجاح → السطر التالي، فشل → إرجاع**. هذا ليس تجريداً اخترعناه — هذه هي الطريقة التي يعمل بها منطق الخدمة بالفعل. SSaC يجعله صريحاً.

10 أنواع تسلسل ثابتة تغطي جميع عمليات طبقة الخدمة التي تتبع هذا العقد. ما لا يناسب يُفوَّض إلى `@call`. المجموعة مغلقة بالتصميم.

لا LLM، لا استدلال — توليد كود رمزي صرف من القوالب. المواصفة هي مصدر الحقيقة الوحيد.

## الصياغة — سطر واحد لكل تسلسل

بدءاً من v2، كل تسلسل هو سطر تعليق واحد. `@response` فقط يستخدم كتلة متعددة الأسطر.

**CRUD — عمليات النموذج**

```go
// @get Type var = Model.Method(args...)        — استعلام (النتيجة مطلوبة)
// @post Type var = Model.Method(args...)       — إنشاء (النتيجة مطلوبة)
// @put Model.Method(args...)                   — تعديل (بدون نتيجة)
// @delete Model.Method(args...)                — حذف (بدون نتيجة)
```

صيغة المعاملات: `source.Field` أو `"حرفي"`

- `request.CourseID` — من طلب HTTP
- `course.InstructorID` — من متغير نتيجة سابق
- `currentUser.ID` — من سياق المصادقة
- `"cancelled"` — سلسلة نصية حرفية

**الحراسات**

```go
// @empty target "message"                      — فشل إذا كان nil/zero (404)
// @exists target "message"                     — فشل إذا لم يكن nil/zero (409)
```

الهدف: متغير (`course`) أو متغير.حقل (`course.InstructorID`)

**انتقالات الحالة**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**فحص الصلاحيات — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**الاستدعاءات الخارجية**

```go
// @call Type var = package.Func(args...)       — مع نتيجة
// @call package.Func(args...)                  — بدون نتيجة
```

**الاستجابة — كتلة تعيين الحقول**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## مثال

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "غير مصرح"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "لم يتم العثور على الحجز"
// @state reservation {status: reservation.Status} "cancel" "لا يمكن الإلغاء"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

إعلان من 10 أسطر. كل سطر هو تسلسل واحد، يُنفَّذ من الأعلى إلى الأسفل بالترتيب. صلاحيات → استعلام → حراسة → انتقال حالة → استدعاء خارجي → تعديل → إعادة استعلام → استجابة.

## أنواع التسلسل (10)

| النوع | الدور |
|---|---|
| `@auth` | فحص الصلاحيات (سياسة OPA) |
| `@get` | استعلام المورد |
| `@empty` | إنهاء إذا كان nil/zero (404) |
| `@exists` | إنهاء إذا لم يكن nil/zero (409) |
| `@post` | إنشاء المورد |
| `@put` | تعديل المورد |
| `@delete` | حذف المورد |
| `@state` | التحقق من انتقال الحالة |
| `@call` | استدعاء دالة حزمة خارجية |
| `@response` | إرجاع الاستجابة (تعيين الحقول) |

## التحقق

التحقق الداخلي (دائماً):
- نقص المعاملات المطلوبة حسب النوع
- صيغة `Model.Method`
- تدفق المتغيرات (المرجع قبل الإعلان)

التحقق المتبادل مع SSOT الخارجي (عند اكتشاف بنية المشروع):
- وجود النموذج/الطريقة (استعلامات sqlc، واجهات Go)
- وجود حقول الطلب/الاستجابة (OpenAPI)
- وجود الحزمة/الدالة (واجهات Go)
- تحذير البيانات القديمة: استجابة بعد put/delete بدون إعادة جلب (WARNING)
- وجود مخطط الحالة والتحقق من صحة الانتقال
- التحقق من وجود ملف سياسة OPA

## ميزات توليد الكود

عند توفر SSOT الخارجي (جداول الرموز)، يوفر `ssac gen` ميزات إضافية. الكود المولَّد يستخدم إطار عمل gin.

- **تحويل الأنواع**: أنواع أعمدة DDL → `strconv.ParseInt`، `time.Parse`، إرجاع مبكر 400 Bad Request
- **أنواع قيم الحراسة**: فحص صفري واعٍ بالنوع (`int` → `== 0`/`> 0`، مؤشر → `== nil`/`!= nil`)
- **اشتقاق واجهة النموذج**: تقاطع 3 مصادر SSOT → `<outDir>/model/models_gen.go`
- **توليد كود @state**: استدعاء `CanTransition` من حزمة مخطط الحالة
- **توليد كود @auth**: استدعاء `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **توليد كود @call**: نمط الحراسة (401) بدون نتيجة، نمط القيمة (500) مع نتيجة
- **بنية مجلدات النطاق**: `service/auth/login.go` → `outDir/auth/login.go`، `package auth`

## امتدادات OpenAPI x-

معاملات البنية التحتية (الترقيم، الفرز، التصفية، تضمين العلاقات) تُعلَن في امتدادات OpenAPI `x-`. في مواصفات SSaC تُعلَن معاملات العمل فقط. مولّد الكود يقرأ `x-` ويبني `QueryOpts` تلقائياً.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## الترخيص

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">مستودع GitHub</a>
