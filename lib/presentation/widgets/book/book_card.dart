import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.md),
                    topRight: Radius.circular(AppRadius.md),
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: book.coverUrl != null
                        ? CachedNetworkImage(
                            imageUrl: book.coverUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _ShimmerPlaceholder(),
                            errorWidget: (_, __, ___) => _PlaceholderCover(),
                          )
                        : _PlaceholderCover(),
                  ),
                ),

                Positioned(
                  top: 4,
                  right: 4,
                  child: _MoreMenu(onEdit: onEdit, onDelete: onDelete),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppTextStyles.bookTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author.toUpperCase(),
                    style: AppTextStyles.bookAuthor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${book.year}', style: AppTextStyles.bookYear),
                      if (book.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primary, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              book.rating!.toStringAsFixed(1),
                              style: AppTextStyles.bookRating,
                            ),
                          ],
                        ),
                    ],
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

class _MoreMenu extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MoreMenu({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        iconSize: 18,
        icon: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.more_vert_rounded,
              size: 16, color: AppColors.secondaryText),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        elevation: 4,
        offset: const Offset(0, 28),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 16, color: AppColors.secondaryText),
                SizedBox(width: 8),
                Text(
                  'Edit',
                ),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                SizedBox(width: 8),
                Text('Remove', style: TextStyle(
                  fontFamily: 'Inter', fontSize: 14,
                  color: AppColors.danger,
                )),
              ],
            ),
          ),
        ],
        onSelected: (v) {
          if (v == 'edit') onEdit?.call();
          if (v == 'delete') onDelete?.call();
        },
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8E4DC),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 32,
        ),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: AppColors.shimmerBase),
    );
  }
}
