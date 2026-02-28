# Daraz-Style Product Listing

A Flutter screen that mimics a Daraz-style product listing using Clean Architecture, GetX, and Fakestore API.  
**Author:** Zavi Soft - Jubayer Bin Montasir

---

## Requirements (Full)

### Layout
- A collapsible header (banner/search bar)
- A tab bar that becomes sticky when the header collapses
- 2–3 tabs, each showing a list of products (mock data is fine)

### Scrolling (Most Important)
- There must be exactly **ONE** vertical scrollable in the entire screen
- Pull-to-refresh must work from any tab
- Switching tabs must not reset or jump the vertical scroll position
- No scroll jitter, conflict, or duplicate scrolling
- The tab bar must remain visible once pinned

### Horizontal Navigation
- Tabs must be switchable by:
  - Tapping
  - Horizontal swipe
- Horizontal swipe must not introduce or control vertical scrolling
- Gesture handling must be intentional and predictable

### Architecture Expectations
- Sliver-based layout is expected
- Clear separation of:
  - UI
  - Scroll / gesture ownership
  - State
- Avoid fragile solutions (magic numbers, global hacks, etc.)

### Data Source
- Use Fakestore API: https://fakestoreapi.com/
- Login and show user profile
- Show products from API

### Mandatory Explanation
Include a short README or code comments explaining:
1. How horizontal swipe was implemented
2. Who owns the vertical scroll and why
3. Trade-offs or limitations of your approach

---

## Run Instructions

```bash
flutter pub get
flutter run
```

---

## Mandatory Explanations

### 1. How horizontal swipe was implemented

- **TabBarView** is used as the body of `NestedScrollView`. `TabBarView` internally uses a horizontal `PageView`.
- Horizontal swipes are captured by `TabBarView` to switch between category tabs (Electronics, Jewelery, Men's Clothing, Women's Clothing).
- Each tab shows a `ListView.separated` with product tiles. The `ListView` scrolls vertically as part of the single scroll context.
- **Gesture separation:** Horizontal drags are handled exclusively by `TabBarView`'s `PageView`. Vertical drags are handled by `NestedScrollView`. There is no cross-axis interference because each scrollable owns a different axis.

### 2. Who owns the vertical scroll and why

- **NestedScrollView** owns the only vertical scroll.
- The structure: `RefreshIndicator` → `NestedScrollView` → `headerSliverBuilder` (SliverAppBar + SliverPersistentHeader) + `body` (TabBarView with tab content).
- `NestedScrollView` coordinates the header slivers with the body scroll. The header (collapsible app bar + sticky tab bar) and the tab content share one scroll position.
- **Why:** A single scroll owner ensures:
  - No duplicate scrolling or jitter
  - Pull-to-refresh works consistently
  - Scroll position is preserved when switching tabs
  - The tab bar stays pinned when the header collapses

### 3. Trade-offs or limitations of this approach

| Trade-off | Description |
|-----------|-------------|
| **Single scroll owner** | All tab content participates in the same scroll. Switching tabs does not reset scroll position. |
| **NestedScrollView + TabBarView** | Simpler than custom sliver overlap coordination. Each tab uses `ListView`; no `SliverOverlapAbsorber`/`SliverOverlapInjector` in tab body. |
| **Memory** | All products are fetched once and filtered locally by category. Good for small datasets; may need pagination for very large lists. |
| **Header coordination** | SliverAppBar with `pinned: true` keeps the search bar visible when collapsed. Search bar is shown in the app bar title when collapsed. |

---

## Architecture

### Clean Architecture

```
lib/
├── core/
│   ├── network/          # Dio API client
│   └── error/            # Exceptions & failures
├── features/
│   └── home/
│       ├── data/         # Data sources, models, repository impl
│       ├── domain/       # Entities, repository contract, use cases
│       └── presentation/ # Controllers, bindings, views, widgets
└── main.dart
```

### Data Flow

- **Fakestore API:**
  - `POST /auth/login` — Login
  - `GET /users/1` — User profile (header)
  - `GET /products` — All products (filtered by category in app)

- **Stack:** Flutter, GetX, Dio

### Layer Separation

- **Presentation:** UI only; no direct API calls. Controller uses use cases.
- **Domain:** Entities, repository interface, use cases. No framework dependencies.
- **Data:** Dio-based remote data source, models, repository implementation.

---

## Evaluation Focus

- ✅ Single vertical scroll (NestedScrollView)
- ✅ No scroll/gesture conflicts (horizontal: TabBarView; vertical: NestedScrollView)
- ✅ Clean structure (Clean Architecture + GetX)
- ✅ Clear reasoning in README
