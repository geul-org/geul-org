---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "يُعلن منطق الخدمة في تعليقات Go ويولّد كود التنفيذ. 10 أنواع تسلسل ثابتة تغطي جميع عمليات العقد الثنائي في طبقة الخدمة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — يولّد كود الخدمة من DSL تعليقات Go.

منطق الخدمة هو سلسلة من القرارات: أي نموذج تستعلم، ماذا تحرس، متى ترفض، ماذا ترجع. هذه القرارات تخص من يفهم العمل — لكنها تُدفن في الكود النمطي، تتبعثر عبر الطبقات، وتُفقد في إعادة الكتابة.

SSaC يحفظ هذه القرارات كمواصفات تصريحية. تُعلن **ماذا** يحدث و**بأي ترتيب**. الأداة تولّد التنفيذ.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## الفكرة الأساسية

كل دالة خدمة هي تسلسل من الخطوات. كل خطوة تتبع عقداً ثنائياً: **نجاح → السطر التالي، فشل → إرجاع**. هذا ليس تجريداً اخترعناه — هذه هي الطريقة التي يعمل بها منطق الخدمة بالفعل. SSaC يجعله صريحاً.

10 أنواع تسلسل ثابتة تغطي جميع عمليات طبقة الخدمة التي تتبع هذا العقد. ما لا يناسب يُفوَّض إلى `call`. المجموعة مغلقة بالتصميم.

لا LLM، لا استدلال — توليد كود رمزي صرف من القوالب. المواصفة هي مصدر الحقيقة.

## مثال

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

هذا الإعلان من 10 أسطر يولّد الكود التالي:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## أنواع التسلسل (10)

| النوع | الدور |
|---|---|
| `authorize` | فحص الصلاحيات (OPA، إلخ) |
| `get` | البحث عن موارد |
| `guard nil` | الخروج إذا كان null |
| `guard exists` | الخروج إذا كان موجوداً |
| `post` | إنشاء موارد |
| `put` | تحديث موارد |
| `delete` | حذف موارد |
| `password` | مقارنة كلمات المرور |
| `call` | استدعاء خارجي (@component / @func) |
| `response` | إرجاع الاستجابة (json) |

## ميزات توليد الكود

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
      allowed: [room, user]
```

## الترخيص

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
