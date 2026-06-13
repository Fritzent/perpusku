import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';
import 'package:perpusku/core/theme/app_colors.dart';
import 'package:perpusku/core/theme/app_theme.dart';
import 'package:perpusku/core/utils/service_locator.dart';
import 'package:perpusku/l10n/app_localizations.dart';
import 'package:perpusku/presentation/blocs/book/book_bloc.dart';
import 'package:perpusku/presentation/blocs/book/book_event.dart';
import 'package:perpusku/presentation/blocs/book/book_state.dart';
import 'package:perpusku/presentation/blocs/connectivity/connectivity_bloc.dart';
import 'package:perpusku/presentation/pages/book_form/book_form_page.dart';
import 'package:perpusku/presentation/widgets/book/book_card.dart';
import 'package:perpusku/presentation/widgets/common/common_widgets.dart';
import 'package:perpusku/presentation/widgets/common/sync_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BookBloc>()
            ..add(const LoadBooksEvent(filter: BookFilter())),
        ),
        BlocProvider(create: (_) => sl<ConnectivityBloc>()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<BookBloc>().add(SearchBooksEvent(q));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (prev, curr) =>
          prev.isConnected && !curr.isConnected,
      listener: (ctx, _) {
        ConnectionLostSheet.show(
          ctx,
          onRetry: () {
            Navigator.pop(ctx);
            ctx.read<ConnectivityBloc>().add(const ConnectivityRetry());
            ctx.read<BookBloc>().add(const RefreshBooksEvent());
          },
          onDismiss: () => Navigator.pop(ctx),
        );
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookBloc, BookState>(
            listenWhen: (prev, curr) =>
                prev.successMessage != curr.successMessage &&
                curr.successMessage != null,
            listener: (ctx, state) {
              showSuccessSnackBar(ctx, _resolveMessage(ctx, state.successMessage!));
            },
          ),
          BlocListener<BookBloc, BookState>(
            listenWhen: (prev, curr) =>
                prev.syncMessage != curr.syncMessage &&
                curr.syncMessage != null,
            listener: (ctx, state) {
              final msg = _resolveSyncMessage(ctx, state.syncMessage!);
              if (state.syncMessage == 'syncSuccess') {
                showSuccessSnackBar(ctx, msg);
              } else {
                showErrorSnackBar(ctx, msg);
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(l10n),
          body: Column(
            children: [
              _SearchBar(
                controller: _searchCtrl,
                onChanged: _onSearch,
                hint: l10n.searchPlaceholder,
              ),
              BlocBuilder<BookBloc, BookState>(
                buildWhen: (prev, curr) =>
                    prev.pendingCount != curr.pendingCount ||
                    prev.isSyncing != curr.isSyncing,
                builder: (ctx, state) => Visibility(
                  visible: state.pendingCount > 0,
                  child: SyncBanner(
                    pendingCount: state.pendingCount,
                    isSyncing: state.isSyncing,
                    onSync: () =>
                        ctx.read<BookBloc>().add(const SyncPendingBooksEvent()),
                  ),
                ),
              ),
              _FilterRow(l10n: l10n),
              Expanded(child: _BookGrid(l10n: l10n)),
            ],
          ),
          floatingActionButton: _AddFab(l10n: l10n),
        ),
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Icon(Icons.menu_rounded,
            color: AppColors.primaryText, size: 22),
      ),
      title: Text(
        l10n.appName,
      ),
    );
  }

  String _resolveMessage(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'bookRemovedSuccess':
        return l10n.bookRemovedSuccess;
      case 'bookSavedSuccess':
        return l10n.bookSavedSuccess;
      case 'savedOffline':
        return l10n.savedOffline;
      default:
        return key;
    }
  }
  String _resolveSyncMessage(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'syncSuccess':
        return l10n.syncSuccess;
      case 'syncFailed':
        return l10n.syncFailed;
      case 'syncFailedOffline':
        return l10n.syncFailedOffline;
      default:
        return key;
    }
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textHint, size: 18),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          border: OutlineInputBorder(
            borderRadius: AppRadius.fullAll,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.fullAll,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.fullAll,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final AppLocalizations l10n;
  const _FilterRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (ctx, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Row(
            children: [
              _FilterChip(
                icon: Icons.calendar_today_outlined,
                label: state.filter.year != null
                    ? '${state.filter.year}'
                    : l10n.filterByYear,
                isActive: state.filter.year != null,
                onTap: () => _showYearPicker(ctx, state),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                icon: Icons.tune_rounded,
                label: l10n.filter,
                isActive: state.filter.category != null,
                onTap: () => _showCategoryPicker(ctx, state),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showYearPicker(BuildContext ctx, BookState state) {
    if (state.availableYears.isEmpty) return;
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl))),
      builder: (context) => _YearPickerSheet(
        years: state.availableYears,
        selected: state.filter.year,
        onSelect: (y) {
          ctx.read<BookBloc>().add(FilterByYearEvent(y));
          Navigator.pop(context);
        },
        onClear: () {
          ctx.read<BookBloc>().add(const FilterByYearEvent(null));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCategoryPicker(BuildContext ctx, BookState state) {
    if (state.availableCategories.isEmpty) return;
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl))),
      builder: (context) => _CategoryPickerSheet(
        categories: state.availableCategories,
        selected: state.filter.category,
        onSelect: (c) {
          ctx.read<BookBloc>().add(FilterByCategoryEvent(c));
          Navigator.pop(context);
        },
        onClear: () {
          ctx.read<BookBloc>().add(const FilterByCategoryEvent(null));
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.fullAll,
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isActive ? Colors.white : AppColors.secondaryText),
            const SizedBox(width: 4),
            Text(
              label,
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 14, color: Colors.white),
            ] else
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
class _BookGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _BookGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (ctx, state) {
        if (state.isLoading) return const BookGridShimmer();

        if (state.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.textHint, size: 48),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? l10n.errorGeneral,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      ctx.read<BookBloc>().add(const RefreshBooksEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.isEmpty) {
          return EmptyStateWidget(
            onAddBook: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => BlocProvider.value(
                value: ctx.read<BookBloc>(),
                child: const BookFormPage(),
              )),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async =>
              ctx.read<BookBloc>().add(const RefreshBooksEvent()),
          child: ListView(
            children: [
              GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: state.books.length,
                itemBuilder: (_, i) {
                  final book = state.books[i];
                  return BookCard(
                    book: book,
                    onEdit: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => BlocProvider.value(
                        value: ctx.read<BookBloc>(),
                        child: BookFormPage(book: book),
                      )),
                    ),
                    onDelete: () => DeleteBookDialog.show(
                      context,
                      onConfirm: () => ctx
                          .read<BookBloc>()
                          .add(DeleteBookEvent(book.id)),
                    ),
                  );
                },
              ),
              PaginationRow(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                onPageChanged: (p) =>
                    ctx.read<BookBloc>().add(ChangePageEvent(p)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddFab extends StatelessWidget {
  final AppLocalizations l10n;
  const _AddFab({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BlocProvider.value(
          value: context.read<BookBloc>(),
          child: const BookFormPage(),
        )),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }
}

class _YearPickerSheet extends StatelessWidget {
  final List<int> years;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onClear;

  const _YearPickerSheet({
    required this.years,
    this.selected,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Year',
              ),
              if (selected != null)
                TextButton(
                    onPressed: onClear,
                    child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: years.length,
              itemBuilder: (_, i) {
                final y = years[i];
                final isSelected = y == selected;
                return GestureDetector(
                  onTap: () => onSelect(y),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      '$y',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPickerSheet extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  const _CategoryPickerSheet({
    required this.categories,
    this.selected,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
              ),
              if (selected != null)
                TextButton(onPressed: onClear, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((c) {
              final isSelected = c == selected;
              return GestureDetector(
                onTap: () => onSelect(c),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: AppRadius.fullAll,
                  ),
                  child: Text(
                    c,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
