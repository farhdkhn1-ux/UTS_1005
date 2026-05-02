import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uts_1005/models/model_kategori.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories.php"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Category>.from(
        data["categories"].map((x) => Category.fromJson(x)),
      );
    } else {
      throw Exception("Gagal mengambil kategori");
    }
  }

  Future<List<Map<String, dynamic>>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse("$baseUrl/filter.php?c=$category"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data["meals"]);
    } else {
      throw Exception("Gagal mengambil masakan");
    }
  }

  Future<List<Map<String, dynamic>>> searchMeals(String keyword) async {
    final response = await http.get(Uri.parse("$baseUrl/search.php?s=$keyword"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["meals"] != null
          ? List<Map<String, dynamic>>.from(data["meals"])
          : [];
    } else {
      throw Exception("Gagal mencari masakan");
    }
  }
}
