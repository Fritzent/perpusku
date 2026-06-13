import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/service_locator.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/book/book_bloc.dart';
import '../../blocs/book/book_event.dart';
import '../../blocs/book/book_state.dart';
import '../../widgets/common/common_widgets.dart';

class BookFormPage extends StatelessWidget {
  final Book? book;

  const BookFormPage({super.key, this.book});

  @override
  Widget build(BuildContext context) {
    final existingBloc = context.read<BookBloc?>();
    if (existingBloc != null) {
      return BlocProvider.value(
        value: existingBloc,
        child: _BookFormView(book: book),
      );
    }
    return BlocProvider(
      create: (_) => sl<BookBloc>()..add(const LoadBooksEvent(filter: BookFilter())),
      child: _BookFormView(book: book),
    );
  }
}

class _BookFormView extends StatefulWidget {
  final Book? book;
  const _BookFormView({this.book});

  @override
  State<_BookFormView> createState() => _BookFormViewState();
}

class _BookFormViewState extends State<_BookFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _selectedCategory;
  File? _pickedImage;
  String? _existingCoverUrl;
  bool get _isEditing => widget.book != null;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final b = widget.book!;
      _titleCtrl.text = b.title;
      _authorCtrl.text = b.author;
      _yearCtrl.text = '${b.year}';
      _descCtrl.text = b.description ?? '';
      _selectedCategory = b.category;
      _existingCoverUrl = b.coverUrl;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _yearCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (file != null) {
      setState(() {
        _pickedImage = File(file.path);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final book = Book(
      id: _isEditing ? widget.book!.id : const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      year: int.parse(_yearCtrl.text.trim()),
      category: _selectedCategory ?? '',
      description:
          _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      coverUrl: _existingCoverUrl,
      rating: _isEditing ? widget.book!.rating : null,
      createdAt: _isEditing ? widget.book!.createdAt : now,
      updatedAt: now,
    );

    setState(() => _isSubmitting = true);

    if (_isEditing) {
      context.read<BookBloc>().add(
            UpdateBookEvent(book: book, coverImage: _pickedImage),
          );
    } else {
      context.read<BookBloc>().add(
            CreateBookEvent(book: book, coverImage: _pickedImage),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<BookBloc, BookState>(
      listenWhen: (prev, curr) => _isSubmitting && prev.isMutating && !curr.isMutating,
      listener: (ctx, state) {
        _isSubmitting = false;
        if (state.successMessage != null) {
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          showErrorSnackBar(ctx, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _isEditing ? l10n.editBook : l10n.addBook,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.updateBookSubtitle,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildCoverSection(l10n),
                const SizedBox(height: AppSpacing.xxl),
                _buildVisualTip(l10n),
                const SizedBox(height: AppSpacing.xxl),
                _buildFieldLabel(l10n.bookTitle),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _titleCtrl,
                  hint: l10n.bookTitleHint,
                  prefixIcon: Icons.menu_book_outlined,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? l10n.errorRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFieldLabel(l10n.author),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _authorCtrl,
                  hint: l10n.authorHint,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? l10n.errorRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFieldLabel(l10n.publicationYear),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _yearCtrl,
                  hint: '2024',
                  prefixIcon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                    final y = int.tryParse(v.trim());
                    if (y == null || y < 1000 || y > DateTime.now().year + 1) {
                      return l10n.errorInvalidYear;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFieldLabel(l10n.category),
                const SizedBox(height: AppSpacing.sm),
                _buildCategoryDropdown(l10n),
                const SizedBox(height: AppSpacing.lg),
                _buildFieldLabel(l10n.description),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _descCtrl,
                  hint: l10n.descriptionHint,
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.xxl),
                BlocBuilder<BookBloc, BookState>(
                  builder: (_, state) => ElevatedButton.icon(
                    onPressed: state.isMutating ? null : _submit,
                    icon: state.isMutating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                color: AppColors.primary, strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(l10n.saveChanges),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(height: AppSpacing.xxl),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookCover, 
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            clipBehavior: Clip.hardEdge,
            child: _pickedImage != null
                ? Image.file(_pickedImage!, fit: BoxFit.cover)
                : _existingCoverUrl != null
                    ? CachedNetworkImage(
                        imageUrl: _existingCoverUrl!,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined,
                              color: AppColors.textHint, size: 36),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.clickToUpload,
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualTip(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mainVisual, 
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.mainVisualDescription,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _TagBadge(l10n.highRes,
                textColor: AppColors.tagHighResText,
                bgColor: AppColors.tagHighRes),
            const SizedBox(width: AppSpacing.sm),
            _TagBadge(l10n.maxSize,
                textColor: AppColors.tagMaxSizeText,
                bgColor: AppColors.tagMaxSize),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppColors.textHint)
            : null,
      ),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    final categories = [
      l10n.philosophy,
      l10n.fiction,
      l10n.nonFiction,
      l10n.science,
      l10n.history,
      l10n.biography,
      l10n.selfHelp,
      l10n.technology,
      l10n.other,
    ];

    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      hint: Text(
        l10n.selectCategory,
      ),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.category_outlined,
            size: 18, color: AppColors.textHint),
      ),
      validator: (v) => v == null ? l10n.errorRequired : null,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textHint),
      dropdownColor: AppColors.surface,
      borderRadius: AppRadius.mdAll,
      items: categories
          .map((c) => DropdownMenuItem(
                value: c,
                child: Text(
                  c,
                ),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedCategory = v),
    );
  }

}

class _TagBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;

  const _TagBadge(this.label,
      {required this.textColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        label,
      ),
    );
  }
}
