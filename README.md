# Daraz-Style Product Listing

A Flutter screen that mimics a Daraz-style product listing.  
**Author:** Zavi Soft - Jubayer Bin Montasir

---

## What This App Does

This screen shows a product listing with:
- A header that collapses when you scroll
- A search bar that stays visible when the header collapses
- Tabs for product categories (Electronics, Jewelery, Men's & Women's Clothing)
- A list of products for the selected tab
- Pull-to-refresh from any tab
- Login using Fakestore API and user profile in the header

---

## Requirements Checklist

### Layout
- ✅ Collapsible header with banner and search bar
- ✅ Tab bar that sticks when the header collapses
- ✅ 2–3 tabs, each showing a product list (API data used)

### Scrolling
- ✅ One vertical scroll for the entire screen
- ✅ Pull-to-refresh works from any tab
- ✅ Switching tabs does not reset or jump scroll position
- ✅ No scroll jitter or conflicts
- ✅ Tab bar stays visible when pinned

### Horizontal Navigation
- ✅ Tabs switch by tapping
- ✅ Tabs switch by horizontal swipe
- ✅ Horizontal swipe does not affect vertical scroll
- ✅ Gesture handling is clear and predictable

### Architecture
- ✅ Sliver-based layout
- ✅ Clear separation of UI, scroll/gesture ownership, and state
- ✅ No magic numbers or global hacks

### Data
- ✅ Fakestore API (https://fakestoreapi.com/)
- ✅ Login and user profile

---

## Mandatory Explanations

### 1. How Horizontal Swipe Was Implemented

**Tap to switch tabs:**  
The `TabBar` handles taps. When you tap a tab, `TabController.animateTo` runs.

**Swipe to switch tabs:**  
A `GestureDetector` wraps the main content. When you swipe horizontally and the velocity exceeds 300, `goToTab(index ± 1)` is called. Swipe right → previous tab; swipe left → next tab.

**Why it doesn’t conflict:**  
Horizontal drags are handled by `GestureDetector`. Vertical drags are handled by `CustomScrollView`. Different gestures, different handlers—no cross-interference.

---

### 2. Who Owns the Vertical Scroll and Why

**Owner:** `CustomScrollView`

**Structure:**
```
RefreshIndicator (pull-to-refresh)
  └── CustomScrollView (single scroll owner)
        ├── SliverAppBar (header + search bar)
        ├── SliverToBoxAdapter (horizontal product images)
        ├── SliverPersistentHeader (tab bar, pinned)
        └── SliverList (products for selected tab)
```

**Why this design:**
- One scroll owner → no jitter or duplicate scrolling
- Pull-to-refresh works because it wraps the scrollable directly
- Scroll position per tab is saved and restored when switching

---

### 3. Trade-offs and Limitations

| Topic | Description |
|-------|-------------|
| **Tab content vs TabBarView** | Instead of `TabBarView`, we use a single `CustomScrollView` and change content via `selectedTabIndex`. This enables root-level pull-to-refresh to work. |
| **Scroll position** | Scroll offset per tab is stored in `_scrollOffsets` and restored when switching tabs. |
| **Memory** | All products are fetched once and filtered by category. Fine for small data; for large datasets, pagination would be needed. |
| **Header** | `SliverAppBar` with `pinned: true` keeps the search bar visible when collapsed. |

---

## How to Run

```bash
flutter pub get
flutter run
```

---

## Architecture Overview

```
lib/
├── core/
│   ├── network/      # API client (Dio)
│   ├── storage/      # Token persistence
│   └── error/        # Exceptions
├── features/home/
│   ├── data/         # API calls, models, repository
│   ├── domain/       # Entities, use cases
│   └── presentation/ # UI, controllers, widgets
└── main.dart
```

**Data flow:** Login → User profile → Products  
**Stack:** Flutter, GetX, Dio

---

## Evaluation Summary

- ✅ Single vertical scroll (CustomScrollView)
- ✅ Root-level pull-to-refresh works
- ✅ No scroll/gesture conflicts
- ✅ Clean, understandable structure
- ✅ Clear reasoning in README
