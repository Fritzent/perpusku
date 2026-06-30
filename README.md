# PerpusKu

A modern book management application built with Flutter, featuring offline support and seamless synchronization with Supabase backend.

## Features

- **Onboarding Flow** - Interactive onboarding pages to introduce users to the app
- **Authentication** - Secure login with Supabase authentication
- **Book Management** - Add, edit, and delete books with cover images
- **Search & Filter** - Search books by title/author, filter by year and category
- **Offline Support** - Works offline with automatic sync when connection is restored
- **Multi-language** - Supports English and Indonesian languages
- **Image Upload** - Upload book cover images to Supabase Storage
- **Pagination** - Navigate through books with paginated results

## Tech Stack

- **Flutter** - UI framework
- **Supabase** - Backend-as-a-Service (Authentication, Database, Storage)
- **Flutter BLoC** - State management
- **GoRouter** - Navigation
- **GetIt** - Dependency injection
- **Cached Network Image** - Image caching
- **Connectivity Plus** - Network status monitoring

## Project Structure

```
lib/
├── core/
│   ├── constant/        # App constants
│   ├── domain/
│   │   ├── entities/    # Business entities
│   │   ├── repositories/ # Repository interfaces
│   │   └── usecases/    # Use cases
│   ├── errors/          # Failure classes
│   ├── network/         # Connectivity service
│   ├── router/          # GoRouter configuration
│   ├── theme/           # App colors, text styles
│   ├── utils/           # Service locator
│   └── validator/       # Form validators
├── data/
│   ├── datasources/
│   │   ├── local/       # Local data sources
│   │   └── remote/      # Supabase queries
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── l10n/                # Localization files
├── presentation/
│   ├── blocs/           # BLoC state management
│   ├── pages/           # UI pages
│   ├── splash/          # Splash screen
│   └── widgets/         # Reusable widgets
├── app.dart             # App widget
└── main.dart            # Entry point
```

## Prerequisites

- Flutter SDK (3.12.0 or higher)
- Dart SDK (3.12.0 or higher)
- Android Studio / VS Code
- Supabase account (for backend services)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd perpusku
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (if needed)

```bash
dart run build_runner build
```

### 4. Configure Supabase

Update the Supabase credentials in `lib/core/constant/app_constant.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabasePublishedKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 5. Run the Application

```bash
# For development
flutter run

# For specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS
```

### 6. Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Database Setup

Create the following tables in your Supabase project:

### Books Table

```sql
CREATE TABLE books (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  year INTEGER NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  cover_url TEXT,
  rating DECIMAL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Storage Bucket

Create a storage bucket named `book-covers` for storing book cover images.

## Environment Variables

The app uses the following constants (found in `lib/core/constant/app_constant.dart`):

| Variable | Description |
|----------|-------------|
| `supabaseUrl` | Your Supabase project URL |
| `supabasePublishedKey` | Your Supabase anonymous key |
| `booksTable` | Database table name |
| `bookCoversStorage` | Storage bucket name |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
