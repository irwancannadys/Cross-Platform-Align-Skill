---
name: cross-platform-align
description: >
  Use this skill whenever the user wants to align, compare, translate, or review features
  between iOS (Swift/SwiftUI) and Android (Kotlin/Jetpack Compose) projects.
  Trigger on phrases like: "samain fitur ini", "translate ke iOS", "compare Android vs iOS",
  "cek apakah behavior-nya sama", "port fitur dari Android", "align kedua platform",
  "implementasi yang sama di iOS dan Android", or any mention of making two mobile platforms
  consistent. Also trigger when the user provides paths to both an iOS and Android project
  and asks about a feature. Always use this skill before writing any cross-platform code.
---

# Cross-Platform Feature Alignment Skill

Skill ini membantu Claude **memahami kedua project secara mendalam** (iOS + Android),
menganalisis gap implementasi, lalu menghasilkan kode yang konsisten di kedua platform.

---

## Phase 1: Project Foundation Discovery

Sebelum nulis apapun, Claude **wajib** ngerti fondasi kedua project.

### 1a. Cek LSP availability dulu

```
Cek apakah swift-lsp dan kotlin-lsp aktif di session ini.
Kalau aktif → gunakan LSP untuk semua navigasi (lebih hemat token).
Kalau tidak aktif → fallback ke bash scan (lihat Phase 1 Fallback di bawah).
```

### 1b. Dengan LSP aktif — gunakan code navigation

**Jangan grep manual.** Gunakan LSP tools langsung:

- `document_symbols` pada entry point file → dapat overview struktur sekaligus
- `go_to_definition` untuk trace arsitektur dari ViewModel/View ke layer bawah
- `find_references` untuk cari semua usage dari class/interface utama
- `hover` untuk cek type dan dokumentasi tanpa buka file

Cukup baca **2-3 file entry point** per platform, lalu trace via LSP sesuai kebutuhan.
Tidak perlu scan seluruh project.

**iOS entry points** yang biasa dicek:
- File `*Assembly.swift` atau `*Module.swift` → DI structure
- File `*ViewModel.swift` dari fitur terdekat → state management pattern
- `Package.swift` → SPM module structure

**Android entry points** yang biasa dicek:
- File `*Module.kt` (Hilt) atau `*Component.kt` → DI structure  
- File `*ViewModel.kt` dari fitur terdekat → state management pattern
- `build.gradle.kts` root → module structure

### 1c. Fallback — tanpa LSP (bash scan minimal)

Kalau LSP tidak tersedia, gunakan scan terbatas:

```bash
# Cukup lihat top-level structure, jangan dump semua file
ls <ios_path>/
ls <android_path>/

# Cari entry point spesifik, bukan semua file
find <ios_path> -name "Package.swift" -maxdepth 3
find <android_path> -name "settings.gradle.kts" -maxdepth 2
```

Baca **maksimal 5 file** untuk Foundation Discovery, prioritas yang paling informatif.

### 1d. Buat "Foundation Summary" sebelum lanjut

```
[Android Foundation]
- Architecture: ...
- DI: ...
- State: ...
- Relevant modules: ...

[iOS Foundation]
- Architecture: ...
- DI: ...
- State: ...
- Relevant modules: ...

[LSP Status: aktif / tidak aktif]
```

---

## Phase 2: Feature Deep Dive

Setelah ngerti fondasi project, baru dive ke fitur spesifik yang diminta.

### 2a. Locate the feature

**Dengan LSP aktif:**
```
1. Tebak nama symbol yang mungkin (ViewModel, View, UseCase terkait fitur)
2. Gunakan go_to_definition dari file entry point terdekat
3. Trace ke bawah hanya layer yang relevan
```

**Fallback tanpa LSP:**
```bash
grep -r "<feature_keyword>" <android_path>/src --include="*.kt" -l
grep -r "<feature_keyword>" <ios_path> --include="*.swift" -l
```

### 2b. Baca implementasi secara menyeluruh

Untuk setiap platform, trace via LSP atau baca langsung:
- **ViewModel / business logic layer** — state & logic utama
- **UI layer** (Composable / SwiftUI View) — rendering & user interaction
- **Data/Repository layer** — hanya kalau ada perbedaan data flow
- **Model/Entity** — pastikan field & tipe data konsisten

Gunakan `find_references` via LSP untuk cek apakah ada shared logic yang terpakai di tempat lain sebelum diubah — hindari breaking change tak terduga.

### 2c. Identifikasi platform-specific constraints

Catat hal-hal yang **tidak bisa di-port 1:1**:
- Android: `Activity`, `Fragment`, lifecycle events, `Context`-dependent code
- iOS: UIKit interop, `@Environment`, specific SwiftUI rendering behavior
- Perbedaan threading model (Coroutines vs async/await)
- Perbedaan navigation paradigm

---

## Phase 3: Gap Analysis

Setelah baca kedua implementasi, buat **Gap Analysis Report** dulu sebelum nulis kode.

Format laporan:

```
## Gap Analysis: [Nama Fitur]

### ✅ Sudah Konsisten
- [behavior/logic yang udah sama di dua platform]

### ⚠️ Perbedaan Minor (mudah di-align)
- [deskripsi perbedaan]
  - Android: [implementasi saat ini]
  - iOS: [implementasi saat ini]
  - Rekomendasi: [apa yang perlu diubah]

### ❌ Perbedaan Major (perlu diskusi)
- [deskripsi perbedaan]
  - Android: [implementasi saat ini]
  - iOS: [implementasi saat ini]
  - Rekomendasi: [opsi A / opsi B + trade-off]

### 🚫 Tidak Bisa Di-port 1:1
- [hal yang platform-specific + alasannya]
  - Alternatif di platform lain: [...]
```

**Selalu tampilkan Gap Analysis ke user dan tunggu konfirmasi** sebelum lanjut ke Phase 4.

---

## Phase 4: Implementation

Setelah user approve gap analysis, baru tulis kode.

### Prinsip implementasi

1. **Ikuti pola arsitektur project masing-masing** — jangan inject pola baru
2. **Naming convention** — ikuti konvensi yang sudah ada di project (bukan konvensi generic)
3. **Minimal changes** — ubah hanya yang perlu, jangan refactor hal yang tidak diminta
4. **Kode lengkap** — jangan tulis `// ... existing code`, tulis file utuh kalau perlu edit
5. **Behavioral parity** — logic, edge case, dan error handling harus sama di kedua platform

### Output format

Untuk setiap perubahan, tampilkan:
```
### [Platform] — [File path]
[kode lengkap atau diff yang jelas]
```

Kalau ada perubahan di lebih dari 3 file, group by platform dan urutkan dari
layer paling dalam (data/domain) ke paling luar (UI).

---

## Phase 5: Verification Checklist

Setelah implementasi, buat checklist untuk user:

```
## Verification Checklist

### Behavior Parity
- [ ] Happy path flow sama di kedua platform
- [ ] Error states ditangani identik
- [ ] Loading states konsisten
- [ ] Edge cases (empty state, null/nil, dll) sama

### Platform-Specific
- [ ] Android: [hal spesifik yang perlu di-test]
- [ ] iOS: [hal spesifik yang perlu di-test]

### What Was NOT Changed
- [list hal yang sengaja tidak diubah + alasan]
```

---

## Tips & Gotchas

### Perbedaan umum yang sering bikin behavior beda

| Aspek | Android (Kotlin) | iOS (Swift) |
|---|---|---|
| Null safety | `null` + `?.` | `nil` + `Optional` |
| Async | `suspend` + Coroutines | `async/await` |
| State | `StateFlow` / `LiveData` | `@Published` / `@State` |
| Side effects | `LaunchedEffect` di Compose | `.onAppear` / `.task` |
| List | `LazyColumn` | `List` / `LazyVStack` |
| Back navigation | System back button / `BackHandler` | Swipe gesture / toolbar back |
| Lifecycle | `ON_RESUME`, `ON_PAUSE` | `scenePhase`, `onAppear/Disappear` |

### ⚠️ Library & Dependency Rules

- **NEVER** suggest atau assume library yang tidak ada di project
- Cek `build.gradle.kts` / `Package.swift` / `Podfile` dulu sebelum recommend dependency apapun
- Kalau fitur butuh library baru, **flag ke user secara eksplisit** dan tanya — jangan langsung pakai
- **Jangan assume** library equivalent ada di platform lain (misal: iOS pakai Alamofire ≠ Android pasti pakai Retrofit — bisa aja pakai Ktor)
- Kalau ragu apakah suatu library ada di project, **grep atau baca config file** — jangan mengarang

### Kapan perlu tanya ke user

- Kalau ada **business logic ambiguity** (behavior di dua platform berbeda dan tidak jelas mana yang "benar")
- Kalau ada **design system component** yang hanya ada di salah satu platform
- Kalau perubahan akan **affect lebih dari yang diminta** (misal: shared ViewModel, base class, dll)
- Kalau implementasi butuh **library/dependency baru** yang belum ada di project
