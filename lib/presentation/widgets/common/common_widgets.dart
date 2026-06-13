import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddBook;

  const EmptyStateWidget({super.key, this.onAddBook});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(painter: _BookReaderPainter()),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              l10n.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.emptyStateSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: onAddBook,
                child: Text(l10n.addFirstBook),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookReaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textHint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawCircle(Offset(cx, cy - 18), 10, paint);

    final bookPath = Path();
    bookPath.moveTo(cx, cy + 2);
    bookPath.quadraticBezierTo(cx - 25, cy - 4, cx - 28, cy + 20);
    bookPath.lineTo(cx, cy + 22);
    bookPath.moveTo(cx, cy + 2);
    bookPath.quadraticBezierTo(cx + 25, cy - 4, cx + 28, cy + 20);
    bookPath.lineTo(cx, cy + 22);
    canvas.drawPath(bookPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConnectionLostSheet extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ConnectionLostSheet({super.key, this.onRetry, this.onDismiss});

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConnectionLostSheet(
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxl),
          topRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.fullAll,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.connectionIconBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.connectionIcon,
                  size: 30,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                l10n.connectionLostTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.connectionLostSubtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.retryConnection),
              ),
              const SizedBox(height: AppSpacing.lg),

              TextButton(
                onPressed: onDismiss ?? () => Navigator.pop(context),
                child: Text(
                  l10n.dismiss,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteBookDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteBookDialog({super.key, required this.onConfirm});

  static Future<bool?> show(BuildContext context,
      {required VoidCallback onConfirm}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => DeleteBookDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.removeFromLibrary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.removeConfirmation,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.smAll,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  onConfirm();
                },
                child: Text(
                  l10n.delete,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                l10n.cancel.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookGridShimmer extends StatelessWidget {
  const BookGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: AppRadius.mdAll,
          ),
        ),
      ),
    );
  }
}

class PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final pages = _buildPageNumbers();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PageButton(
            label: '<',
            isEnabled: currentPage > 1,
            onTap: () => onPageChanged(currentPage - 1),
          ),
          const SizedBox(width: AppSpacing.sm),

          ...pages.map((p) => p == -1
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '...',
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _PageButton(
                    label: '$p',
                    isActive: p == currentPage,
                    isEnabled: true,
                    onTap: () => onPageChanged(p),
                  ),
                )),

          const SizedBox(width: AppSpacing.sm),
          _PageButton(
            label: '>',
            isEnabled: currentPage < totalPages,
            onTap: () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }

  List<int> _buildPageNumbers() {
    if (totalPages <= 5) return List.generate(totalPages, (i) => i + 1);
    if (currentPage <= 3) return [1, 2, 3, -1, totalPages];
    if (currentPage >= totalPages - 2) {
      return [1, -1, totalPages - 2, totalPages - 1, totalPages];
    }
    return [1, -1, currentPage, -1, totalPages];
  }
}

class _PageButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.label,
    this.isActive = false,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.smAll,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
        ),
      ),
    );
  }
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            Text(message,
                style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.white)),
          ],
        ),
        backgroundColor: AppColors.snackbarBackground,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        duration: const Duration(seconds: 3),
      ),
    );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontFamily: 'Inter', fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
    );
}
