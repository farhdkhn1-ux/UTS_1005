import 'dart:convert';

DaftarCategory daftarCategoryFromJson(String str) => DaftarCategory.fromJson(json.decode(str));

String daftarCategoryToJson(DaftarCategory data) => json.encode(data.toJson());

class DaftarCategory {
  List<Meal> meals;

  DaftarCategory({
    required this.meals,
  });

  factory DaftarCategory.fromJson(Map<String, dynamic> json) => DaftarCategory(
    meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
  };
}

class Meal {
  String strMeal;
  String strMealThumb;
  String idMeal;
  String strArea;
  String strCountry;

  Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
    required this.strArea,
    required this.strCountry,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    strMeal: json["strMeal"],
    strMealThumb: json["strMealThumb"],
    idMeal: json["idMeal"],
    strArea: json["strArea"],
    strCountry: json["strCountry"],
  );

  Map<String, dynamic> toJson() => {
    "strMeal": strMeal,
    "strMealThumb": strMealThumb,
    "idMeal": idMeal,
    "strArea": strArea,
    "strCountry": strCountry,
  };
}