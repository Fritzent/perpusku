abstract class AppConstants {
  static const String supabaseUrl = 'https://rhhnxluaoopjdyozrvgt.supabase.co';
  static const String supabasePublishedKey = 'sb_publishable_3R4e-Xsp7UKu-1aS6qMD9w_jx5Ph2kt';
  static const String booksTable = 'books';
  static const String bookCoversStorage = 'book-covers';
  static const int defaultPageSize = 10;
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyLocale = 'app_locale';
  static const List<String> supportedLocales = ['en', 'id'];
  static const String defaultLocale = 'en';
  static const int maxImageSizeBytes = 5 * 1024 * 1024;
  static const int minImageWidth = 800;
  static const int minImageHeight = 1200;
  static const Duration splashDuration = Duration(milliseconds: 2800);
  static const Duration animDefault = Duration(milliseconds: 300);
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animSlow = Duration(milliseconds: 500);
}
