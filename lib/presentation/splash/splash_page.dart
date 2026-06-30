import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/domain/usecases/check_login_status_usecase.dart';
import 'package:perpusku/core/router/app_router.dart';
import 'package:perpusku/core/theme/app_text_styles.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_local_datasource.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_remote_datasource.dart';
import 'package:perpusku/data/repositories/auth_repository_impl.dart';
import 'package:perpusku/l10n/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _dotsOpacity;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.splashDuration,
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _dotsOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeat();

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(
      AppConstants.splashDuration + const Duration(milliseconds: 200),
    );
    if (!mounted) return;

    final onboardingDone = await isOnboardingComplete();
    if (!mounted) return;

    if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
      return;
    }

    final checkLoginStatus = CheckLoginStatusUseCase(
      AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSourceImpl(),
        localDataSource: AuthLocalDataSourceImpl(),
      ),
    );
    final isLoggedIn = await checkLoginStatus();
    if (!mounted) return;

    context.go(isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  double _scaleForDot(int index) {
    final value = _controller.value;

    final delay = index * 0.2;
    final animationValue = (value - delay).clamp(0.0, 1.0);

    return 1.0 +
        0.6 *
            (1 - ((animationValue * 2 - 1).abs())).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _fadeIn,
            child: Image.asset(
              'assets/images/onboarding/splash.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2C1810), Color(0xFF0D0A06)],
                  ),
                ),
              ),
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x88000000),
                  Color(0xCC000000),
                ],
                stops: [0.4, 0.7, 1.0],
              ),
            ),
          ),

          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _dotsOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _dotsController,
                    builder: (_, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final scale = _scaleForDot(i);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  scale > 1.2 ? 255 : 120,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.initializing,
                    style: AppTextStyles.splashInitializing,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}