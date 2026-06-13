import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'PerpusKu'**
  String get appName;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started →'**
  String get getStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PerpusKu'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize Your Collection with a premium digital sanctuary designed for focus.'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Seamless Synchronization'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your library anytime, anywhere. Your reading progress stays perfectly in sync across all your devices.'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Archive'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Build a lasting collection. Categorize, rate, and curate your books into a beautiful digital sanctuary that reflects your journey.'**
  String get onboarding3Subtitle;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Sanctuary is Quiet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start building your personal collection by adding your first book.'**
  String get emptyStateSubtitle;

  /// No description provided for @addFirstBook.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Book'**
  String get addFirstBook;

  /// No description provided for @connectionLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLostTitle;

  /// No description provided for @connectionLostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your library. Please check your internet connection and try again.'**
  String get connectionLostSubtitle;

  /// No description provided for @retryConnection.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search book title or author...'**
  String get searchPlaceholder;

  /// No description provided for @filterByYear.
  ///
  /// In en, this message translates to:
  /// **'Pick Year'**
  String get filterByYear;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @editBook.
  ///
  /// In en, this message translates to:
  /// **'Edit Book'**
  String get editBook;

  /// No description provided for @addBook.
  ///
  /// In en, this message translates to:
  /// **'Add Book'**
  String get addBook;

  /// No description provided for @updateBookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your collection details to keep your digital archive accurate.'**
  String get updateBookSubtitle;

  /// No description provided for @bookCover.
  ///
  /// In en, this message translates to:
  /// **'BOOK COVER'**
  String get bookCover;

  /// No description provided for @clickToUpload.
  ///
  /// In en, this message translates to:
  /// **'Click to Upload'**
  String get clickToUpload;

  /// No description provided for @mainVisual.
  ///
  /// In en, this message translates to:
  /// **'Main Visual'**
  String get mainVisual;

  /// No description provided for @mainVisualDescription.
  ///
  /// In en, this message translates to:
  /// **'Use JPG or PNG format with a minimum resolution of 800x1200 pixels for the best quality in your digital shelf.'**
  String get mainVisualDescription;

  /// No description provided for @highRes.
  ///
  /// In en, this message translates to:
  /// **'High Res'**
  String get highRes;

  /// No description provided for @maxSize.
  ///
  /// In en, this message translates to:
  /// **'Max 5MB'**
  String get maxSize;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'BOOK TITLE'**
  String get bookTitle;

  /// No description provided for @bookTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Filosofi Teras'**
  String get bookTitleHint;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'AUTHOR'**
  String get author;

  /// No description provided for @authorHint.
  ///
  /// In en, this message translates to:
  /// **'Henry Manampiring'**
  String get authorHint;

  /// No description provided for @publicationYear.
  ///
  /// In en, this message translates to:
  /// **'PUBLICATION YEAR'**
  String get publicationYear;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get category;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter book description...'**
  String get descriptionHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @archiveTip.
  ///
  /// In en, this message translates to:
  /// **'Archive Tip'**
  String get archiveTip;

  /// No description provided for @archiveTipDescription.
  ///
  /// In en, this message translates to:
  /// **'A detailed description helps the PerpusKu algorithm recommend the right book for your reading circle.'**
  String get archiveTipDescription;

  /// No description provided for @removeFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Remove from Library?'**
  String get removeFromLibrary;

  /// No description provided for @removeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this book from your collection? This action cannot be undone.'**
  String get removeConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @bookRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Book removed successfully'**
  String get bookRemovedSuccess;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myBooks.
  ///
  /// In en, this message translates to:
  /// **'My Books'**
  String get myBooks;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZING ARCHIVE'**
  String get initializing;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @philosophy.
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get philosophy;

  /// No description provided for @fiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get fiction;

  /// No description provided for @nonFiction.
  ///
  /// In en, this message translates to:
  /// **'Non-Fiction'**
  String get nonFiction;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @selfHelp.
  ///
  /// In en, this message translates to:
  /// **'Self Help'**
  String get selfHelp;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorRequired;

  /// No description provided for @errorInvalidYear.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year'**
  String get errorInvalidYear;

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneral;

  /// No description provided for @errorLoadBooks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load books'**
  String get errorLoadBooks;

  /// No description provided for @errorSaveBook.
  ///
  /// In en, this message translates to:
  /// **'Failed to save book'**
  String get errorSaveBook;

  /// No description provided for @errorDeleteBook.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete book'**
  String get errorDeleteBook;

  /// No description provided for @bookSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Book saved successfully'**
  String get bookSavedSuccess;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @ofText.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// No description provided for @savedOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Saved locally — will sync when online.'**
  String get savedOffline;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'pending book(s) waiting to sync'**
  String get syncBannerTitle;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'All books synced successfully!'**
  String get syncSuccess;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Please try again.'**
  String get syncFailed;

  /// No description provided for @syncFailedOffline.
  ///
  /// In en, this message translates to:
  /// **'Still offline. Please check your connection.'**
  String get syncFailedOffline;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
