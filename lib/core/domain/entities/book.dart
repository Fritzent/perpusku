import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final int year;
  final String category;
  final String? description;
  final String? coverUrl;
  final double? rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    this.description,
    this.coverUrl,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? year,
    String? category,
    String? description,
    String? coverUrl,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      category: category ?? this.category,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        year,
        category,
        description,
        coverUrl,
        rating,
        createdAt,
        updatedAt,
      ];
}
