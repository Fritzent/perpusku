import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/router/app_router.dart';
import 'package:perpusku/core/theme/app_colors.dart';
import 'package:perpusku/core/theme/app_text_styles.dart';
import 'package:perpusku/core/theme/app_theme.dart';
import 'package:perpusku/l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    if (_currentPage < _totalPages - 1) {
      await _pageController.nextPage(
        duration: AppConstants.animDefault,
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    await completeOnboarding();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2ED),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (_currentPage == 2) ...[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadius.smAll,
                          ),
                          child: const Icon(Icons.menu_book_rounded,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        l10n.appName,
                        style: AppTextStyles.appHeaderTitle,
                      ),
                    ],
                  ),
                  if (_currentPage < _totalPages - 1)
                    GestureDetector(
                      onTap: _finish,
                      child: Text(
                        l10n.skip,
                        style: AppTextStyles.appHeaderSkipText,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingSlide(index: i),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxxl),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.dotColor,
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 3,
                      spacing: 4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  ElevatedButton(
                    onPressed: _onNext,
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(
                        double.infinity,
                        AppSpacing.lg,
                      )),
                      backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.lg,
                      )),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: AppRadius.fullAll,
                      )),
                    ),
                    child: Text(
                      _currentPage == _totalPages - 1
                          ? l10n.getStarted
                          : l10n.next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final int index;
  const _OnboardingSlide({required this.index});

  static const _images = [
    'assets/images/onboarding/onboarding_one.png',
    'assets/images/onboarding/onboarding_two.jpg',
    'assets/images/onboarding/onboarding_three.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final titles = [
      l10n.onboarding1Title,
      l10n.onboarding2Title,
      l10n.onboarding3Title,
    ];
    final subtitles = [
      l10n.onboarding1Subtitle,
      l10n.onboarding2Subtitle,
      l10n.onboarding3Subtitle,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: AppRadius.lgAll,
              child: Image.asset(
                _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E2D),
                    borderRadius: AppRadius.lgAll,
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book_rounded,
                        color: Colors.white54, size: 48),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  titles[index],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onBoardingTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  subtitles[index],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onBoardingSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}