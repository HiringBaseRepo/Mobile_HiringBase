---
applyTo: "lib/app/data/models/**/*.dart"
---

# Models Layer Instructions

> **Scope**: All files under `lib/app/data/models/**/*.dart`
> **Role**: Immutable, strongly-typed data contracts. The single source of truth for data shapes passed between layers.

---

## Allowed

- Immutable field declarations (`final`)
- `const` constructors
- `factory Model.fromJson(Map<String, dynamic> json)` — JSON deserialization
- `Map<String, dynamic> toJson()` — JSON serialization
- `Model copyWith({...})` — safe immutable update
- Default values in constructor parameters
- Null-safe fallback in `fromJson`: `json['field'] ?? defaultValue`

---

## Forbidden

- ❌ Business logic of any kind
- ❌ API calls or HTTP requests
- ❌ `Rx` variables or GetX imports
- ❌ Mutable state (no `var` fields)
- ❌ Navigation calls
- ❌ Direct color or UI references

---

## Standard Model Template

```dart
class EntityName {
  final String id;
  final String name;
  final String status; // 'draft' | 'published' | 'closed'

  const EntityName({
    required this.id,
    required this.name,
    this.status = 'draft',
  });

  factory EntityName.fromJson(Map<String, dynamic> json) => EntityName(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        status: json['status'] ?? 'draft',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
      };

  EntityName copyWith({
    String? id,
    String? name,
    String? status,
  }) =>
      EntityName(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
      );
}
```

---

## Existing Models

| Model | File | Key Fields |
|---|---|---|
| `User` | `user_model.dart` | `id`, `name`, `email`, `role` |
| `Vacancy` | `vacancy_model.dart` | `id`, `title`, `department`, `location`, `type`, `salary`, `status`, `applicantCount`, `postedAt` |
| `Candidate` | `candidate_model.dart` | `id`, `name`, `role`, `status`, `score`, `matchText`, `appliedAt`, `imageUrl`, `statusColor`, `isManualOverride` |
| `Notification` | `notification_model.dart` | See file |

---

## Rules for Status Fields

All `status` fields must use string literals matching the defined flow:

- **Vacancy**: `'draft'` | `'published'` | `'closed'`
- **Candidate**: `'Applied'` | `'Reviewed'` | `'Interview'` | `'Accepted'` | `'Rejected'`

Do **not** use integers or enums unless explicitly refactoring to enums (requires updating all serialization).

---

## Adding a New Model

1. Create `lib/app/data/models/<entity>_model.dart`
2. Implement: `const` constructor, `fromJson`, `toJson`, `copyWith`
3. Add a doc comment at the top of the class
4. Register in this instructions file's "Existing Models" table
5. Never import from `modules/` or `services/` — models have no upstream dependencies
