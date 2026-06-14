# Plan: Refactor Document Feature — One Reusable Screen Per Concern

## Context

The project has `type_document_screen/` full of **empty stub files** — 4 separate services, 4 repository impls, and 4 controllers, all empty. This is the anti-pattern. The goal: **one reusable widget per concern** (list, search), each accepting `DocumentType`. Follows existing Controller → Service → Repository → Mock JSON architecture.

## Target Folder Structure

```
lib/
├── data/
│   ├── models/
│   │   └── document/
│   │       ├── document.dart                   # [MODIFY] Add 'type' field
│   │       ├── document_type.dart              # [NEW] DocumentType enum + extensions
│   │       ├── type_document.dart              # [KEEP]
│   │       └── total_document.dart             # [KEEP]
│   ├── repositories/
│   │   └── document/
│   │       └── document_repository.dart        # [MODIFY] Add getDocumentsByType(), searchDocuments()
│   ├── mock/
│   │   └── document_mock_repository.dart       # [NEW] Mock implementation
│   └── mock_data/
│       └── documents.json                     # [MODIFY] Add "type" to each entry
│
├── ui/
│   └── screens/
│       └── document/
│           ├── controllers/
│           │   ├── document_list_controller.dart    # [NEW] List state & loading
│           │   └── document_search_controller.dart  # [NEW] Search state & logic
│           ├── services/
│           │   └── document_service.dart            # [NEW] Business logic layer
│           └── views/
│               ├── document_screen.dart             # [NEW] 4-card grid entry
│               ├── document_list_screen.dart        # [NEW] Reusable list by type
│               └── document_search_screen.dart      # [NEW] Search UI by type
```

**Key structural decisions:**
- Abstract repository lives in `data/repositories/` (centralized contract)
- Mock impl lives in `data/mock/` (centralized, reusable across features)
- No `repositories_impl/` inside feature folders — all data access is in `data/`
- Switching mock→remote = create `data/remote/document_remote_repository.dart`, change one binding

## Complete Navigation Flow

```
MainScreen Tab 2: DocumentScreen (4-card 2×2 grid)
  │
  ├─ Tap "ឯកសារផ្ទាល់ខ្លួន" → DocumentListScreen(type: DocumentType.personal)
  │    │
  │    ├─ Tap search icon → DocumentSearchScreen(type: DocumentType.personal)
  │    │    │  User enters document_number and/or title
  │    │    │  Taps Search → controller calls service.searchDocuments()
  │    │    └─ Results list → tap → (detail page, future)
  │    │
  │    └─ Tap list item → (detail page, future)
  │
  ├─ Tap "ឯកសារទូទៅ" → DocumentListScreen(type: DocumentType.general)
  │    └─ ... (same pattern)
  │
  ├─ Tap "ឯកសារចូល" → DocumentListScreen(type: DocumentType.incoming)
  │    └─ ... (same pattern)
  │
  └─ Tap "ឯកសារចេញ" → DocumentListScreen(type: DocumentType.outgoing)
       └─ ... (same pattern)
```

## MVC Data Flow

```
┌─ VIEW ────────────────────────────────────────────────┐
│  document_list_screen.dart / document_search_screen.dart │
│  - Observes controller via Obx                          │
│  - Sends user actions to controller                     │
└──────────────────┬────────────────────────────────────┘
                   │ Get.put / Get.find
                   ▼
┌─ CONTROLLER ──────────────────────────────────────────┐
│  document_list_controller.dart                         │
│    - documents: <DocumentModel>[].obs                   │
│    - isLoading: false.obs                               │
│    - error: ''.obs                                      │
│    - loadDocuments(type) → calls service                │
│    - refresh() → reload                                 │
│                                                        │
│  document_search_controller.dart                       │
│    - searchResults: <DocumentModel>[].obs               │
│    - isLoading: false.obs                               │
│    - error: ''.obs                                      │
│    - hasSearched: false.obs                             │
│    - documentNumberCtrl: TextEditingController          │
│    - titleCtrl: TextEditingController                   │
│    - performSearch(type) → calls service                │
│    - clearSearch() → resets fields & results            │
└──────────────────┬────────────────────────────────────┘
                   │ constructor injection
                   ▼
┌─ SERVICE ─────────────────────────────────────────────┐
│  document_service.dart (pure Dart, no GetX)             │
│    - getDocumentsByType(type) → repository              │
│    - searchDocuments({type, documentNumber, title})     │
│      → repository.searchDocuments(...)                  │
└──────────────────┬────────────────────────────────────┘
                   │ depends on abstract interface
                   ▼
┌─ ABSTRACT REPOSITORY ─────────────────────────────────┐
│  data/repositories/document/document_repository.dart    │
│    - Future<List<DocumentModel>> getDocumentsByType(t)  │
│    - Future<List<DocumentModel>> searchDocuments({...}) │
└──────────────────┬────────────────────────────────────┘
                   │ implements
                   ▼
┌─ MOCK REPOSITORY ─────────────────────────────────────┐
│  data/mock/document_mock_repository.dart                │
│    - Reads documents.json via rootBundle                │
│    - Caches in memory                                   │
│    - Filters by type, then by documentNumber + title    │
│    - 300ms delay for realism                            │
└───────────────────────────────────────────────────────┘
```

## Search Flow Detail

```
DocumentListScreen
  │  User taps search icon in TopNavBarWidget
  ▼
Get.to(() => DocumentSearchScreen(type: DocumentType.personal))
  │
  ▼
DocumentSearchScreen (View)
  │  initState → Get.put(DocumentSearchController(type: type))
  │  Shows two TextFieldWidget inputs:
  │    - document_number (លេខឯកសារ)
  │    - title (ចំណងជើង)
  │  Shows "ស្វែងរក" ButtonWidget
  │  Obx(() => results list or empty state)
  ▼
User fills fields, taps "ស្វែងរក"
  │
  ▼
DocumentSearchController.performSearch()
  │  Sets isLoading = true, hasSearched = true
  │  Calls: service.searchDocuments(
  │    type: this.type,
  │    documentNumber: documentNumberCtrl.text,
  │    title: titleCtrl.text,
  │  )
  ▼
DocumentService.searchDocuments()
  │  Calls: repository.searchDocuments(
  │    type: type.name,
  │    documentNumber: documentNumber,
  │    title: title,
  │  )
  ▼
DocumentMockRepository.searchDocuments()
  │  Filters cached list:
  │    1. Filter by type
  │    2. If documentNumber is not empty → filter by documentNumber.contains(q)
  │    3. If title is not empty → filter by titleKhmer.contains(q) OR titleLatin.contains(q)
  │  Returns filtered list
  ▼
Controller updates: searchResults.value = results
  │
  ▼
View rebuilds: shows ListView of results, or "រកមិនឃើញ" if hasSearched && empty
```

## Files — What Each One Does

### 1. `lib/data/models/document/document_type.dart` — NEW

```dart
enum DocumentType { personal, general, incoming, outgoing }
```
Extension with: `khmerTitle` (String), `icon` (IconData), `color` (Color).

### 2. `lib/data/models/document/document.dart` — MODIFY

Add `final String type;` field. Update `fromJson` / `toJson`.

### 3. `lib/data/mock_data/documents.json` — MODIFY

Add `"type": "personal"` (or general/incoming/outgoing) to all 20 entries. 5 docs per type.

### 4. `lib/data/repositories/document/document_repository.dart` — MODIFY

Add two methods:
```dart
Future<List<DocumentModel>> getDocumentsByType(String type);
Future<List<DocumentModel>> searchDocuments({
  required String type,
  String documentNumber,
  String title,
});
```

### 5. `lib/data/mock/document_mock_repository.dart` — NEW

- Implements `DocumentRepository`
- Loads `documents.json` via `rootBundle`, caches as `List<DocumentModel>`
- `getDocumentsByType(type)` → filter cached list by type, 300ms delay
- `searchDocuments({type, documentNumber, title})` → filter by type, then by documentNumber (contains match), then by title (contains match on titleKhmer OR titleLatin), 300ms delay
- If both documentNumber AND title are empty → returns empty list (no search criteria)

### 6. `lib/ui/screens/document/services/document_service.dart` — NEW

Pure Dart class (no GetX dependency):
```dart
class DocumentService {
  final DocumentRepository repository;
  DocumentService({required this.repository});

  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) =>
      repository.getDocumentsByType(type.name);

  Future<List<DocumentModel>> searchDocuments({
    required DocumentType type,
    String documentNumber = '',
    String title = '',
  }) => repository.searchDocuments(
    type: type.name,
    documentNumber: documentNumber,
    title: title,
  );
}
```
Business logic (sorting, validation) goes here later.

### 7. `lib/ui/screens/document/controllers/document_list_controller.dart` — NEW

```dart
class DocumentListController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  final documents = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  DocumentListController({required this.type, DocumentService? service})
      : service = service ?? DocumentService(
          repository: DocumentMockRepository(),
        );

  Future<void> loadDocuments() async { ... }
  Future<void> refresh() async => loadDocuments();

  @override
  void onInit() { loadDocuments(); super.onInit(); }
}
```

### 8. `lib/ui/screens/document/controllers/document_search_controller.dart` — NEW

```dart
class DocumentSearchController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  final searchResults = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final hasSearched = false.obs;

  final documentNumberCtrl = TextEditingController();
  final titleCtrl = TextEditingController();

  Future<void> performSearch() async { ... }
  void clearSearch() { ... }

  @override
  void onClose() {
    documentNumberCtrl.dispose();
    titleCtrl.dispose();
    super.onClose();
  }
}
```

### 9. `lib/ui/screens/document/views/document_screen.dart` — NEW

Entry screen — 4 cards in 2×2 grid.
- Uses `TopBarWidget` (existing from `lib/ui/widgets/display/edoc_top_bar.dart`)
- Background: `AppColors.background`
- 4 `EdocDocumentTypeCard` (existing widget from `lib/ui/widgets/display/edoc_document_type_card.dart`) — each with `onTap` → `Get.to(() => DocumentListScreen(type: type))`
- Maps: `'personal'` → `DocumentType.personal`, etc.

### 10. `lib/ui/screens/document/views/document_list_screen.dart` — NEW

`StatefulWidget` with `DocumentType type` parameter.
- `initState`: `Get.put(DocumentListController(type: type))`
- `dispose`: `Get.delete<DocumentListController>()`
- Uses `TopNavBarWidget` (existing) with:
  - `title` = `type.khmerTitle`
  - `onSearchTap` → `Get.to(() => DocumentSearchScreen(type: type))`
- Body: `Obx(() { ... })`
  - `isLoading` → `CircularProgressIndicator`
  - `error` → error text with retry button
  - `documents` → `ListView.builder` of document list item cards

### 11. `lib/ui/screens/document/views/document_search_screen.dart` — NEW

`StatefulWidget` with `DocumentType type` parameter.
- `initState`: `Get.put(DocumentSearchController(type: type))`
- `dispose`: `Get.delete<DocumentSearchController>()`
- Uses `TopNavBarWidget` with `title` = "ស្វែងរក ${type.khmerTitle}"
- Body layout:
  ```
  Padding(
    child: Column(
      children: [
        TextFieldWidget(label: 'លេខឯកសារ', controller: documentNumberCtrl),
        SizedBox(height: 12),
        TextFieldWidget(label: 'ចំណងជើង', controller: titleCtrl),
        SizedBox(height: 16),
        ButtonWidget(text: 'ស្វែងរក', onPressed: performSearch),
        SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            if (isLoading) → CircularProgressIndicator
            if (error.isNotEmpty) → error text
            if (!hasSearched) → "បញ្ចូលលេខឯកសារ ឬចំណងជើងដើម្បីស្វែងរក"
            if (searchResults.isEmpty) → "រកមិនឃើញឯកសារ"
            else → ListView.builder of results
          })
        ),
      ],
    ),
  )
  ```

### 12. Clean up empty stubs — DELETE

Delete empty files in `lib/ui/features/document/type_document_screen/`:
- `controllers/document_controller.dart`
- `controllers/folder_controller.dart`
- `controllers/search_controller.dart`
- `services/personal_document_service.dart`
- `services/general_document_service.dart`
- `services/incoming_document_service.dart`
- `services/outgoing_document_service.dart`
- `repositories_impl/personal_document_repository_impl.dart`
- `repositories_impl/general_document_repository_impl.dart`
- `repositories_impl/incoming_document_repository_impl.dart`
- `repositories_impl/outgoing_document_repository_impl.dart`
- `view/search_screen.dart`
- `view/widgets/search_content.dart`
- `type_document.dart`

Files with existing code in that directory (`document_screen.dart`, `folder_screen.dart`, `document_content.dart`, `folder_content.dart`, `folder_section.dart`) — keep as-is for now. They'll be superseded by the new `lib/ui/screens/document/` feature.

## Summary of Responsibilities

| Layer | Location | Responsibility |
|-------|----------|----------------|
| **Controller (list)** | `ui/screens/document/controllers/` | Holds documents list state, loading, error; calls service |
| **Controller (search)** | `ui/screens/document/controllers/` | Holds search form state, results, hasSearched flag; calls service |
| **Service** | `ui/screens/document/services/` | Pure Dart; contains business rules; calls abstract repository |
| **Abstract Repository** | `data/repositories/document/` | Defines data operation contracts |
| **Mock Repository** | `data/mock/` | Reads JSON, filters, simulates delay |
| **Remote Repository** | `data/remote/` (future) | Real API calls — change one line in controller to swap |

## Why This Design

| Principle | How |
|-----------|-----|
| **DRY** | 2 controllers + 3 views handle all 4 document types |
| **Single Responsibility** | List controller only manages list state; search controller only manages search state |
| **Open/Closed** | New type = add enum value + update JSON + add 1 card widget |
| **Dependency Inversion** | Controllers depend on abstract `DocumentRepository`; mock/remote swap is one line |
| **Centralized data** | All repos in `data/` — no `repositories_impl/` scattered in feature folders |
| **Pure service layer** | `DocumentService` has no GetX dependency — testable in isolation |
| **Separate search state** | `hasSearched` flag distinguishes "no input yet" from "no results found" |

## Verification

1. `flutter analyze` — no errors
2. Run app → Document tab → 4 cards in 2×2 grid
3. Tap each card → navigates to correct list with correct Khmer title
4. Each list shows only documents of that type (5 docs each)
5. Loading spinner appears briefly (300ms mock delay)
6. Tap search icon → search screen with correct type context
7. Search by document_number only → correct results
8. Search by title only (Khmer or Latin) → correct results
9. Search by both fields → correct intersection results
10. Search with empty fields → no results ("no criteria" state handled)
11. Search with no matches → "រកមិនឃើញឯកសារ" shown
12. Clear search → fields reset, results cleared, hasSearched = false
13. Back navigation works at every level
