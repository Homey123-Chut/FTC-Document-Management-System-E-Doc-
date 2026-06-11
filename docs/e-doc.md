# Plan: Welcome, Login, Home, and User Screens

## Architecture Layers (per user clarification)

```
┌─────────────────────────────────────────────────────┐
│ VIEW (StatelessWidget)                              │
│ - No business logic                                 │
│ - Only renders UI, observes reactive state via Obx  │
├─────────────────────────────────────────────────────┤
│ CONTROLLER (GetX) — lib/ui/controllers/ or feature/ │
│ - UI state ONLY: isLoading, items[], errorMessage   │
│ - TextEditingControllers for form inputs            │
│ - Calls Service, maps result to reactive Rx vars    │
│ - NEVER calls repository directly                   │
├─────────────────────────────────────────────────────┤
│ SERVICE (Pure Dart) — lib/ui/features/*/services/   │
│ - Business logic & use cases                        │
│ - NO GetX dependencies                              │
│ - NO Flutter imports                                │
│ - Calls abstract Repository, returns domain objects │
├─────────────────────────────────────────────────────┤
│ ABSTRACT REPOSITORY — lib/data/repositories/        │
│ - Interface only: method signatures                 │
│ - NO implementation, NO data storage                │
├─────────────────────────────────────────────────────┤
│ REPOSITORY IMPL — lib/data/mock/ or lib/data/remote/│
│ - Concrete data access (JSON file, HTTP, DB)        │
│ - Implements abstract repository                    │
│ - Converts raw data ↔ model objects                 │
└─────────────────────────────────────────────────────┘
```

## Existing Code Issues to Fix

1. **Repo impl in wrong location**: `lib/ui/features/auth/login/repositories_impl/user_repository_impl.dart` should be `lib/data/mock/mock_user_repository.dart`
2. **LoginService renamed to UserService and does data access**: `lib/ui/features/auth/login/services/login_service.dart` loads JSON via rootBundle — this is repo impl behavior, not service logic
3. **LoginController never populates AuthService**: After successful login, `AuthService.setUser()` is never called — the global user session is null forever
4. **User Screen is a placeholder**: Only shows "User Screen" text

---

## Step 1: Create `lib/data/mock/` — Repository Implementations

### CREATE: `lib/data/mock/mock_user_repository.dart`

Implements `UserRepository` (abstract). Reads `user.json` via `rootBundle`.

```
MockUserRepository implements UserRepository
├── login(email, password)      — loads users, matches email+password
├── getUserById(id)              — finds user by ID
├── updateUser(user)             — updates in-memory + returns updated UserModel
├── changePassword(id, old, new) — verifies old, updates in-memory, returns bool
```

- Reads JSON once, caches list in private `_cachedUsers`
- Contains NO business logic — just data lookup/update
- When switching to backend → create `lib/data/remote/dio_user_repository.dart` with same interface

### DELETE: `lib/ui/features/auth/login/repositories_impl/user_repository_impl.dart`

(This file's logic moves into `MockUserRepository`)

---

## Step 2: Rewrite Login Service as Pure Business Logic

### MODIFY: `lib/ui/features/auth/login/services/login_service.dart`

Current problem: The class is named `UserService`, it lives in a file named `login_service.dart`, and it does raw JSON loading via `rootBundle`. This mixes repository implementation with service layer.

Clean version:
```
AuthService (pure Dart — NO GetX, NO Flutter imports)
├── final UserRepository _repository
├── Future<UserModel?> authenticate(email, password)
│   — calls _repository.login(email, password)
│   — returns user or null
│   — no GetX, no Flutter, no async state management
```

Wait — there's already an `AuthService` at `lib/ui/features/auth/login/services/auth_service.dart` which is a **GetX Service** holding `Rx<UserModel?>`. This is actually a session manager, not a business-logic service.

Let me clarify the naming:
- **`AuthService` (GetX Service)** — session manager: holds currentUser Rx, isAdmin, isLoggedIn, setUser(), logout(). This is correct as a GetX Service. Keep it.
- **`LoginService` (Pure Dart)** — business logic: validates credentials against repository. Rename the current `UserService` class to this.

### MODIFY: `lib/ui/features/auth/login/services/login_service.dart`

```
class LoginService {
  final UserRepository _repository;
  LoginService(this._repository);
  
  Future<UserModel?> authenticate(String email, String password) async {
    return _repository.login(email, password);
  }
}
```

Simple, pure Dart — just delegates to the abstract repository. When business rules grow (rate limiting, lockout after N attempts), they go here.

---

## Step 3: Fix Login Controller

### MODIFY: `lib/ui/features/auth/login/controllers/login_controller.dart`

Changes:
1. Use `LoginService` instead of `UserRepository` directly
2. After successful login, call `Get.find<AuthService>().setUser(user)` to populate global session
3. Constructor accepts `LoginService` with default mock injection

```
LoginController extends GetxController
├── UI state:
│   ├── loginState (AsyncValue<UserModel?>).obs
│   ├── hidePassword.obs
│   ├── rememberMe.obs
├── Form controllers:
│   ├── emailController (TextEditingController)
│   ├── passwordController (TextEditingController)
├── Validators:
│   ├── validateEmail() → String?
│   └── validatePassword() → String?
└── Actions:
    └── handleLogin() → sets loading → calls service → sets user in AuthService
```

---

## Step 4: Expand Abstract UserRepository

### MODIFY: `lib/data/repositories/user/user_repository.dart`

Current: only `login()` method.
Add:
```dart
Future<UserModel?> getUserById(String id);
Future<UserModel?> updateUser(UserModel user);
Future<bool> changePassword(String userId, String oldPassword, String newPassword);
```

---

## Step 5: Create User Service (Pure Dart)

### CREATE: `lib/ui/features/user/service/user_profile_service.dart`

Pure Dart — NO GetX, NO Flutter imports.

```
class UserProfileService {
  final UserRepository _repository;
  UserProfileService(this._repository);
  
  Future<UserModel?> getProfile(String userId) => _repository.getUserById(userId);
  Future<UserModel?> updateProfile(UserModel user) => _repository.updateUser(user);
  Future<bool> changePassword(String userId, String oldPwd, String newPwd) 
    => _repository.changePassword(userId, oldPwd, newPwd);
}
```

---

## Step 6: Create Global User Controller

### CREATE: `lib/ui/controllers/user_controller.dart`

UI state ONLY. No business logic. Calls `UserProfileService`.

```
UserController extends GetxController
├── UI state:
│   ├── profileState (AsyncValue<UserModel?>).obs
│   ├── saveState (AsyncValue<void>).obs
│   ├── passwordState (AsyncValue<bool>).obs
│   ├── isEditing.obs
├── Form controllers (created when editing):
│   ├── usernameController
│   ├── emailController
│   ├── phoneController
│   ├── genderController
│   └── departmentController
├── Actions:
│   ├── fetchProfile(String userId) — onInit or after login
│   ├── toggleEdit() — switches mode, populates form if entering edit
│   ├── saveProfile() — validates, calls service, updates Rx
│   └── changePassword(old, new) — calls service
```

Default injection: `UserProfileService(MockUserRepository())`

---

## Step 7: Implement User Screen UI

### CREATE: `lib/ui/features/user/view/widgets/user_profile_header.dart`
- Circle avatar (first letter fallback)
- Username, email, role badge (green for admin, blue for staff)
- Department

### CREATE: `lib/ui/features/user/view/widgets/user_info_section.dart`
- Readonly tiles: Phone, Gender, Department, Role
- Edit button → calls controller.toggleEdit()

### CREATE: `lib/ui/features/user/view/widgets/user_edit_form.dart`
- Form with TextFieldWidget for username, email, phone, department
- Gender as DropdownField
- Save (calls controller.saveProfile) + Cancel (controller.toggleEdit) buttons
- Uses Obx to show loading spinner on save button

### CREATE: `lib/ui/features/user/view/widgets/admin_actions_section.dart`
- Only rendered when `Get.find<AuthService>().isAdmin` is true
- Cards/tiles: Create Entity, Create User, System Settings

### MODIFY: `lib/ui/features/user/view/user_screen.dart`

Replace placeholder. Structure:
```
Scaffold
├── AppBar: "គណនី"
├── Body (SingleChildScrollView):
│   ├── UserProfileHeader
│   ├── Obx: isEditing ? UserEditForm : UserInfoSection
│   ├── SizedBox(height)
│   ├── Obx: if admin → AdminActionsSection
│   ├── Divider
│   ├── Change Password section (expandable)
│   └── Logout button (red)
```

---

## Step 8: Wire Everything in main.dart

### MODIFY: `lib/main.dart`

```dart
initialBinding: BindingsBuilder(() {
  Get.put(AuthService());           // session manager (existing)
  Get.put(UserController());        // global user profile (new)
});
```

---

## Step 9: Login Flow — Connect AuthService

### MODIFY: `lib/ui/features/auth/login/controllers/login_controller.dart`

After `loginState.value = AsyncValue.success(user)`:
```dart
Get.find<AuthService>().setUser(user);
// Then trigger UserController to fetch full profile
Get.find<UserController>().fetchProfile(user.id);
```

---

## Summary: All Files

### CREATE (7 files):
| File | Purpose |
|------|---------|
| `lib/data/mock/mock_user_repository.dart` | Concrete mock data access (reads user.json) |
| `lib/ui/features/user/service/user_profile_service.dart` | Pure Dart business logic for user profile |
| `lib/ui/controllers/user_controller.dart` | Global GetX controller for user profile UI state |
| `lib/ui/features/user/view/widgets/user_profile_header.dart` | Avatar + name + role badge |
| `lib/ui/features/user/view/widgets/user_info_section.dart` | Readonly profile fields + edit button |
| `lib/ui/features/user/view/widgets/user_edit_form.dart` | Editable profile form |
| `lib/ui/features/user/view/widgets/admin_actions_section.dart` | Admin-only action tiles |

### MODIFY (5 files):
| File | Change |
|------|--------|
| `lib/data/repositories/user/user_repository.dart` | Add `getUserById`, `updateUser`, `changePassword` |
| `lib/ui/features/auth/login/controllers/login_controller.dart` | Use LoginService (not repo directly), call AuthService.setUser() |
| `lib/ui/features/auth/login/services/login_service.dart` | Rename to proper LoginService, pure delegation to repo |
| `lib/ui/features/user/view/user_screen.dart` | Full implementation replacing placeholder |
| `lib/main.dart` | Initialize UserController in initialBinding |

### DELETE (1 file):
| File | Reason |
|------|--------|
| `lib/ui/features/auth/login/repositories_impl/user_repository_impl.dart` | Moved to `lib/data/mock/mock_user_repository.dart` |

---

## Backend-Ready: What Changes When Moving to API

When the backend is ready, ONLY create one file and change one line:

1. **CREATE** `lib/data/remote/dio_user_repository.dart` — implements `UserRepository` with Dio/HTTP
2. **CHANGE** in `UserController` and `LoginController` constructors: swap `MockUserRepository()` → `DioUserRepository()`

**Nothing else changes.** Views, Controllers, and Services all depend only on the abstract `UserRepository` interface.

---

## Verification

1. Launch app → Welcome Screen with logo + 2 login methods
2. Tap email login → Login Screen with email/password form
3. Enter `homey@gmail.com` / `Hello@123` → Home Screen with stats + quick actions
4. Tap "គណនី" in bottom nav → User profile: "Homey Chut", admin badge, **admin actions visible**
5. Tap Edit → edit form pre-filled → change phone → Save → updated info shown
6. Logout → Welcome Screen
7. Login as `holy@gmail.com` / `Hello@123` (staff) → User Screen: **NO admin actions**
