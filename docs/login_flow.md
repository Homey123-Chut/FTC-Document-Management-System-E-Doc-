# Login Feature — Flow, Concept & Sequence Diagram

## MVC with GetX Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  ┌──────────────────┐   ┌─────────────────────┐   ┌───────────────────┐ │
│  │       VIEW       │   │     CONTROLLER       │   │       MODEL       │ │
│  │                  │   │                      │   │                   │ │
│  │  LoginScreen     │   │  LoginController     │   │  UserModel        │ │
│  │  ├─ LoginHeader  │   │  extends             │   │  UserRepository   │ │
│  │  ├─ LoginForm    │──►│  GetxController      │──►│  UserRepoImpl     │ │
│  │  └─ MethodTile   │   │                      │   │  UserService      │ │
│  │                  │   │  .obs state           │   │  user.json        │ │
│  │  Obx() widgets   │◄──│  validation           │   │                   │ │
│  │  auto-rebuild    │   │  handleLogin()        │   │                   │ │
│  └──────────────────┘   └─────────────────────┘   └───────────────────┘ │
│                                                                          │
│  DATA FLOW:                                                              │
│  User action → Controller method → .obs changes → Obx() rebuilds UI     │
│  Controller → Repository → Service → JSON file                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## File Structure

```
lib/
├── data/
│   ├── models/user/
│   │   └── user.dart                              # UserModel data class
│   ├── repositories/user/
│   │   ├── user_repository.dart                   # Abstract interface
│   │   └── user_repository_impl.dart              # Implementation
│   └── mock_data/
│       └── user.json                              # Mock user credentials
│
└── ui/features/auth/login/
    ├── controllers/
    │   └── login_controller.dart                  # GetxController
    ├── views/
    │   ├── login_screen.dart                      # Screen scaffold
    │   └── widgets/
    │       ├── login_header.dart                  # Logo + title
    │       ├── login_error_banner.dart            # Error message row
    │       └── login_form.dart                    # Form fields + button
    └── services/
        └── login_service.dart                     # JSON data loader
```

---

## Concept — How It Works

### MVC Layer Responsibilities

| Layer | Contains | Responsibility |
|-------|----------|----------------|
| **Model** | `UserModel`, `UserRepository` (abstract), `UserRepositoryImpl`, `UserService` | Data access, business rules, JSON loading |
| **View** | `LoginScreen`, `LoginHeader`, `LoginForm`, `LoginErrorBanner` | Render UI, react to state via `Obx()`, delegate actions to Controller |
| **Controller** | `LoginController extends GetxController` | Hold reactive state (`.obs`), validate input, orchestrate login flow |

### Reactive Data Binding

```
User taps button  →  Controller.method()  →  .obs value changes  →  Obx() rebuilds UI
```

The View **never** calls the Model directly. The Controller is the single bridge between View and Model.

### State Machine

```
AsyncValue<UserModel?>
  │
  ├─ init() ───────► No error, no spinner, button enabled
  │
  ├─ loading() ────► Button spinner + disabled, error hidden
  │                    │
  │                    ├─► success(user) ──► Navigate to MainScreen
  │                    │
  │                    └─► error(msg) ─────► Error banner shows, button restored
  │
  └─ error(msg) ───► Error visible, button enabled
       │
       └── (user taps login again) ──► loading() ──► ...
```

### Reactive Variables

| `.obs` Variable | Type | Bound `Obx()` | Changes When |
|-----------------|------|---------------|--------------|
| `loginState` | `AsyncValue<UserModel?>` | Error banner + Button | `handleLogin()` sets loading/success/error |
| `hidePassword` | `bool` | Password field suffix icon + obscureText | Eye icon tapped → `.toggle()` |
| `rememberMe` | `bool` | Checkbox | Checkbox changed |

---

## Login Flow — Step by Step

### Phase A: Screen Opens

1. **`WelcomeContent`** — User taps "ចូលប្រព័ន្ធដោយប្រើប្រាស់ពាក្យសម្ងាត់"
2. **Navigation** — `Get.to(() => const LoginScreen())` pushes LoginScreen
3. **`_LoginScreenState.initState()`** — `Get.put(LoginController())` registers controller in GetX DI
4. **Constructor** — `LoginController` creates default dependency: `UserRepositoryImpl(UserService())`
5. **Build** — `LoginScreen` renders: `LoginHeader` + `LoginForm` + divider + CamDigiKey tile

### Phase B: User Fills Form

| Widget | Binds to Controller via |
|--------|------------------------|
| Email `TextFieldWidget` | `controller.emailController` — stores text |
| Password `TextFieldWidget` | `controller.passwordController` — stores text |
| Eye icon `IconButton` | `controller.hidePassword.toggle` → `Obx()` rebuilds |
| Remember me `Checkbox` | `controller.rememberMe.value = value` → `Obx()` rebuilds |

### Phase C: User Taps "ចូលប្រើប្រាស់"

**Entry point:** `LoginForm._handleLogin()` → validates form → calls `controller.handleLogin()`

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1 — VALIDATION                                         │
│                                                             │
│   formKey.currentState!.validate()                          │
│     │                                                       │
│     ├─► controller.validateEmail(value)                     │
│     │     ├─ empty?      → "បំពេញអ៊ីមែលរបស់អ្នក"          │
│     │     └─ bad format? → "បញ្ចូលអ៊ីមែលដែលត្រឹមត្រូវ"    │
│     │                                                       │
│     └─► controller.validatePassword(value)                  │
│           ├─ empty?    → "បំពេញពាក្យសម្ងាត់របស់អ្នក"      │
│           └─ <6 chars? → "ពាក្យសម្ងាត់ត្រូវតែមាន"          │
│                                                             │
│   Any fail → red text under field. STOP.                    │
│   All pass → continue.                                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2 — SET LOADING STATE                                  │
│                                                             │
│   loginState.value = AsyncValue.loading()                   │
│     │                                                       │
│     └─► Obx() rebuilds:                                     │
│           • ButtonWidget → spinner + disabled               │
│           • Error banner → hidden                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3 — CALL MODEL LAYER                                   │
│                                                             │
│   repository.login(email, password)                         │
│     │                                                       │
│     └─► UserRepositoryImpl.login()                          │
│           │                                                 │
│           ├─► UserService.loadUsers()                       │
│           │     └─► rootBundle.loadString(user.json)        │
│           │           └─► jsonDecode → List<Map>            │
│           │                                                 │
│           └─► For each user in list:                        │
│                 ├─ UserModel.fromJson(userData)             │
│                 ├─ email.toLowerCase() == input?            │
│                 └─ Validators.verifyPassword()              │
│                                                             │
│                 Match? YES → return user.copyWith(pass:'')  │
│                 Match? NO  → continue loop                  │
│                                                             │
│           No match at all → return null                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 4 — HANDLE RESULT                                      │
│                                                             │
│   SUCCESS (user != null):                                   │
│     loginState.value = AsyncValue.success(user)             │
│     Get.offAll(() => const MainScreen())                    │
│       └─► Clears nav stack, shows home screen               │
│                                                             │
│   NOT FOUND (user == null):                                 │
│     await Future.delayed(500ms)          ← brief UX pause   │
│     loginState.value = AsyncValue.error(                    │
│       'អ្នកបានបញ្ចូលអ៊ីមែល ឬ ពាក្យសម្ងាត់មិនត្រឹមត្រូវទេ' │
│     )                                                       │
│       └─► Obx() → LoginErrorBanner appears                  │
│                                                             │
│   EXCEPTION (catch e):                                      │
│     loginState.value = AsyncValue.error(                    │
│       'មានបញ្ហាក្នុងការចូលគណនី: $e សូមព្យាយាមម្តងទៀត'  │
│     )                                                       │
│       └─► Obx() → LoginErrorBanner with exception message   │
└─────────────────────────────────────────────────────────────┘
```

### Phase D: Cleanup

When `LoginScreen` is removed from the widget tree:
- `LoginController.onClose()` fires
- Disposes `emailController` and `passwordController`

---

## Sequence Diagram

```
User        WelcomeContent   LoginScreen    LoginForm     LoginController     UserRepoImpl      UserService      user.json
  │              │               │              │               │                  │                 │                │
  │ tap password │               │              │               │                  │                 │                │
  │ login tile   │               │              │               │                  │                 │                │
  │─────────────>│               │              │               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │              │ Get.to(Login) │              │               │                  │                 │                │
  │              │──────────────>│              │               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │              │          initState()          │               │                  │                 │                │
  │              │          Get.put(LoginController())          │                  │                 │                │
  │              │               │─────────────>│               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │              │               │              │ new UserRepositoryImpl(UserService())               │                │
  │              │               │              │─────────────────────────────────────>│               │                │
  │              │               │              │               │                  │                 │                │
  │              │               │   build()    │               │                  │                 │                │
  │              │               │<─────────────│               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │  ◄─── LoginScreen renders ──│              │               │                  │                 │                │
  │  (LoginHeader + LoginForm +  │              │               │                  │                 │                │
  │   divider + CamDigiKey)      │              │               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │ type email & │               │              │               │                  │                 │                │
  │ password     │               │              │               │                  │                 │                │
  │──────────────│──────────────>│─────────────>│               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │ tap "ចូលប្រើប្រាស់"         │              │               │                  │                 │                │
  │──────────────│──────────────>│─────────────>│               │                  │                 │                │
  │              │               │              │               │                  │                 │                │
  │              │               │              │ _handleLogin()│                  │                 │                │
  │              │               │              │── validate() ──│                  │                 │                │
  │              │               │              │── validateEmail() ──────────────────────────────────────────────────
  │              │               │              │── validatePassword() ────────────────────────────────────────────────
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │  VALID  │                  │                 │                │
  │              │               │              │      │────────>│                  │                 │                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │   loginState = loading     │                 │                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │  Obx() rebuilds button    │                  │                 │                │
  │  ◄─── spinner shows ────────│<─────────────│<────────────│                  │                 │                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │   repository.login(email,pass)              │                │
  │              │               │              │      │         │─────────────────>│                 │                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │         │                  │  loadUsers()    │                │
  │              │               │              │      │         │                  │────────────────>│                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │         │                  │                 │ loadString()   │
  │              │               │              │      │         │                  │                 │───────────────>│
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │         │                  │                 │   JSON data    │
  │              │               │              │      │         │                  │                 │<───────────────│
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │         │                  │  List<Map>      │                │
  │              │               │              │      │         │                  │<────────────────│                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │         │                  │ ITERATE users:  │                │
  │              │               │              │      │         │                  │  for each user: │                │
  │              │               │              │      │         │                  │  .fromJson()    │                │
  │              │               │              │      │         │                  │  email.match()  │                │
  │              │               │              │      │         │                  │  password.verify│                │
  │              │               │              │      │         │                  │                 │                │
  │              │               │              │      │   UserModel | null        │                 │                │
  │              │               │              │      │<──────────────────────────│                 │                │
  │              │               │              │      │         │                  │                 │                │
  │              │       ┌───────┴───────┐      │      │         │                  │                 │                │
  │              │       │               │      │      │         │                  │                 │                │
  │              │       │  user != null │      │  user == null  │                  │                 │                │
  │              │       │  (SUCCESS)    │      │  (FAIL)        │                  │                 │                │
  │              │       │               │      │      │         │                  │                 │                │
  │              │       │ loginState =  │      │ delay 500ms     │                  │                 │                │
  │              │       │ .success(user)│      │ loginState =    │                  │                 │                │
  │              │       │               │      │ .error(msg)     │                  │                 │                │
  │              │       │ Get.offAll(   │      │      │         │                  │                 │                │
  │              │       │  MainScreen)  │      │      │         │                  │                 │                │
  │              │       │               │      │      │         │                  │                 │                │
  │              │       └───────┬───────┘      └──────┬──────────┘                  │                 │                │
  │              │               │                     │                             │                 │                │
  │              │               ▼                     ▼                             │                 │                │
  │              │     ┌──────────────────┐  ┌─────────────────────┐                 │                 │                │
  │              │     │ Navigate to      │  │ Obx() →             │                 │                 │                │
  │              │     │ MainScreen       │  │ LoginErrorBanner    │                 │                 │                │
  │              │     │ (home page)      │  │ shows error message │                 │                 │                │
  │              │     └──────────────────┘  └─────────────────────┘                 │                 │                │
  │              │                                                                   │                 │                │
  │  ◄── home ───│                  ◄── error banner in Khmer ───────────────────────│                 │                │
  │              │                                                                   │                 │                │
  ▼              ▼                                                                   ▼                 ▼                ▼
```

---

## Key Files & Their Roles

| File | Layer | Purpose |
|------|-------|---------|
| [login_screen.dart](../lib/ui/features/auth/login/views/login_screen.dart) | View | Scaffold — composes all widgets, registers Controller via `Get.put()` |
| [login_form.dart](../lib/ui/features/auth/login/views/widgets/login_form.dart) | View | Form with email, password, remember-me, error banner, login button |
| [login_header.dart](../lib/ui/features/auth/login/views/widgets/login_header.dart) | View | Logo + app title |
| [login_error_banner.dart](../lib/ui/features/auth/login/views/widgets/login_error_banner.dart) | View | Reusable red error message row |
| [login_controller.dart](../lib/ui/features/auth/login/controllers/login_controller.dart) | Controller | Reactive state (`.obs`), validation rules, `handleLogin()`, DI |
| [user_repository.dart](../lib/data/repositories/user/user_repository.dart) | Model | Abstract interface — `Future<UserModel?> login(email, password)` |
| [user_repository_impl.dart](../lib/data/repositories/user/user_repository_impl.dart) | Model | Matches email + password against JSON data |
| [login_service.dart](../lib/ui/features/auth/login/services/login_service.dart) | Model | Loads and parses `user.json` from app assets |
| [user.dart](../lib/data/models/user/user.dart) | Model | Data class — `UserModel` with `fromJson()`, `copyWith()` |

---

## Dependency Injection Chain

```
LoginController({UserRepository? repository})
  │
  └─► default: UserRepositoryImpl(UserService())
        │
        └─► UserService.loadUsers()
              │
              └─► rootBundle.loadString('lib/data/mock_data/user.json')
```

Constructor injection makes the Controller **testable** — a mock `UserRepository` can be passed via the optional parameter.
