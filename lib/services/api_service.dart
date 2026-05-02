import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daftar_kategori.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<DaftarCategory> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse("$baseUrl/filter.php?c=$category"));
    if (response.statusCode == 200) {
      return daftarCategoryFromJson(response.body);
    } else {
      throw Exception("Failed to load meals");
    }
  }

  Future<Map<String, dynamic>> fetchMealDetailRaw(String idMeal) async {
    final response = await http.get(Uri.parse("$baseUrl/lookup.php?i=$idMeal"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["meals"][0];
    } else {
      throw Exception("Failed to load meal detail");
    }
  }
}
