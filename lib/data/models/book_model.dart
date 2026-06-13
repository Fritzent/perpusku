import 'package:perpusku/core/domain/entities/book.dart';


class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.year,
    required super.category,
    super.description,
    super.coverUrl,
    super.rating,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      year: json['year'] as int,
      category: json['category'] as String,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'category': category,
      'description': description,
      'cover_url': coverUrl,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'category': category,
      'description': description,
      'cover_url': coverUrl,
      'rating': rating,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'category': category,
      'description': description,
      'cover_url': coverUrl,
      'rating': rating,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      year: book.year,
      category: book.category,
      description: book.description,
      coverUrl: book.coverUrl,
      rating: book.rating,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
  }
}
