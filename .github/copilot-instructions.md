# Fuel Pro 360 - Copilot Instructions

## Architecture Overview

This Flutter app uses **Clean Architecture** with feature-based organization and Supabase as the backend. The codebase follows strict layering principles:

```
lib/
├── features/          # Feature modules (auth, home, customers, etc.)
│   └── [feature]/
│       ├── data/      # Models, data sources, repository implementations
│       ├── domain/    # Entities, repositories (interfaces), use cases
│       └── presentation/ # Pages, providers, widgets
├── core/              # App-wide configuration, API clients, routing
├── shared/            # Reusable widgets, models, providers, utilities
└── utils/             # Helper functions and utilities
```

## Key Technologies & Patterns

- **State Management**: Riverpod with code generation (`@riverpod`, `StateNotifier`)
- **Navigation**: GoRouter with type-safe routing via enums
- **Backend**: Supabase (auth, RPC calls, real-time features)
- **Code Generation**: Freezed for immutable classes, JSON serialization, Retrofit for API clients
- **Error Handling**: Either pattern with `dartz` for functional error handling

## Critical Development Workflows

### Code Generation
Always run after modifying `@freezed`, `@JsonSerializable`, or `@riverpod` annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Feature Development Pattern
When adding new features, follow this exact structure:

1. **Data Layer**: Create models with `@freezed` and `toEntity()` method
2. **Domain Layer**: Define entities (pure Dart), repository interfaces, use cases
3. **Presentation Layer**: Build providers with `StateNotifier`, then UI components

Example provider pattern:
```dart
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.success(List<Entity> data) = _Success;
  const factory FeatureState.error(Failure failure) = _Error;
}

final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>((ref) {
  final useCase = ref.watch(useCaseProvider);
  return FeatureNotifier(useCase);
});
```

### Supabase Integration
- Use RPC calls for complex queries: `Supabase.instance.client.rpc('function_name', params: {})`
- Always handle auth state: `Supabase.instance.client.auth.currentUser`
- Wrap Supabase calls in data sources, never directly in UI

### Error Handling
- Repository layer returns `Either<Failure, Data>`
- Use `ErrorHandler.handle(e).failure` for consistent error mapping
- Providers handle `Either` results with `.fold()` method

## Project-Specific Conventions

### File Naming
- Models: `*_model.dart` with `toEntity()` method
- Entities: `*_entity.dart` (pure domain objects)
- Providers: `*_provider.dart` with state classes
- Pages: `*_screen.dart` or `*_page.dart`

### Import Organization
- Core imports first, then features, then shared
- Use `import_sorter` package for consistency

### Code Generation Dependencies
Key files that trigger regeneration:
- Any file with `@freezed`, `@JsonSerializable`, `@riverpod`
- Files ending in `.g.dart` or `.freezed.dart` are generated

### Environment Configuration
- Environment variables in `lib/env.dart` as static constants
- Supabase credentials exposed (development project)

## Testing & Build Commands

```bash
# Run tests
flutter test

# Build for Android
flutter build apk

# Build for iOS  
flutter build ios

# Run code generation
dart run build_runner build

# Clean and rebuild
flutter clean && flutter pub get && dart run build_runner build
```

## Key Dependencies to Understand

- `flutter_riverpod`: State management with providers
- `supabase_flutter`: Backend integration and auth
- `freezed`: Immutable classes and unions
- `dartz`: Functional programming (Either type)
- `go_router`: Type-safe navigation
- `retrofit`: Type-safe HTTP client generation

When modifying this codebase, always maintain the clean architecture boundaries and use the established patterns for consistency.