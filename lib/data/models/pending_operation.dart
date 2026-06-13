import 'dart:convert';

import 'package:perpusku/core/domain/entities/book.dart';

enum PendingOperationType { create, update }

class PendingOperation {
  final String id;
  final PendingOperationType type;
  final Book book;
  final String? localCoverPath;
  final DateTime queuedAt;

  const PendingOperation({
    required this.id,
    required this.type,
    required this.book,
    this.localCoverPath,
    required this.queuedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'book': _bookToJson(book),
        'localCoverPath': localCoverPath,
        'queuedAt': queuedAt.toIso8601String(),
      };

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'] as String,
      type: PendingOperationType.values.byName(json['type'] as String),
      book: _bookFromJson(json['book'] as Map<String, dynamic>),
      localCoverPath: json['localCoverPath'] as String?,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory PendingOperation.fromJsonString(String s) =>
      PendingOperation.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

Map<String, dynamic> _bookToJson(Book b) => {
      'id': b.id,
      'title': b.title,
      'author': b.author,
      'year': b.year,
      'category': b.category,
      'description': b.description,
      'coverUrl': b.coverUrl,
      'rating': b.rating,
      'createdAt': b.createdAt.toIso8601String(),
      'updatedAt': b.updatedAt.toIso8601String(),
    };

Book _bookFromJson(Map<String, dynamic> j) => Book(
      id: j['id'] as String,
      title: j['title'] as String,
      author: j['author'] as String,
      year: j['year'] as int,
      category: j['category'] as String,
      description: j['description'] as String?,
      coverUrl: j['coverUrl'] as String?,
      rating: j['rating'] != null ? (j['rating'] as num).toDouble() : null,
      createdAt: DateTime.parse(j['createdAt'] as String),
      updatedAt: DateTime.parse(j['updatedAt'] as String),
    );
