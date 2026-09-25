import 'package:equatable/equatable.dart';

/// Core domain entity representing a culinary recipe in the application.
/// Independent of any external data sources, serialization formats, or UI layouts.
class Recipe extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int cookTimeMinutes;
  final String difficulty;
  final String cuisine;
  final int calories;
  final String category;
  final bool isFavorite;
  final List<String> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.cuisine,
    required this.calories,
    required this.category,
    this.isFavorite = false,
    this.ingredients = const [],
    this.instructions = const [],
  });

  Recipe copyWith({
    int? id,
    String? name,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? cookTimeMinutes,
    String? difficulty,
    String? cuisine,
    int? calories,
    String? category,
    bool? isFavorite,
    List<String>? ingredients,
    List<String>? instructions,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      cuisine: cuisine ?? this.cuisine,
      calories: calories ?? this.calories,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rating,
        reviewCount,
        cookTimeMinutes,
        difficulty,
        cuisine,
        calories,
        category,
        isFavorite,
        ingredients,
        instructions,
      ];
}
