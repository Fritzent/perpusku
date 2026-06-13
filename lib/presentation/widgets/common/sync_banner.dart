import 'package:flutter/material.dart';
import 'package:perpusku/core/theme/app_colors.dart';
import 'package:perpusku/core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

class SyncBanner extends StatelessWidget {
  final int pendingCount;
  final bool isSyncing;
  final VoidCallback onSync;

  const SyncBanner({
    super.key,
    required this.pendingCount,
    required this.isSyncing,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: pendingCount > 0 ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: pendingCount > 0 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EC),
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: const Color(0xFFFFD580), width: 1),
            boxShadow: AppShadows.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withAlpha(38),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 16,
                  color: Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: isSyncing
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Syncing...',
                          ),
                        ],
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$pendingCount ',
                              style: AppTextStyles.bookAuthor,
                            ),
                            TextSpan(
                              text: 'book${pendingCount > 1 ? 's' : ''} '
                                  'waiting to sync',
                              style: AppTextStyles.bookAuthor,
                            ),
                          ],
                        ),
                      ),
              ),

              if (!isSyncing)
                GestureDetector(
                  onTap: onSync,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.fullAll,
                    ),
                    child: Text(
                      'Sync Now',
                      style: AppTextStyles.splashInitializing,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
