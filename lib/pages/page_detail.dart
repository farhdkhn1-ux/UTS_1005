import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PageDetail extends StatefulWidget {
  final String idMeal;
  const PageDetail({super.key, required this.idMeal});

  @override
  State<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  late Future<Map<String, dynamic>> futureMeal;

  @override
  void initState() {
    super.initState();
    futureMeal = ApiService().fetchMealDetailRaw(widget.idMeal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Masakan")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          } else {
            final meal = snapshot.data!;
            final ingredients = <String>[];
            for (int i = 1; i <= 20; i++) {
              final ing = meal["strIngredient$i"];
              final measure = meal["strMeasure$i"];
              if (ing != null && ing.toString().isNotEmpty) {
                ingredients.add("$ing - ${measure ?? ""}");
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal["strMealThumb"]),
                  const SizedBox(height: 12),
                  Text(meal["strMeal"],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("${meal["strCategory"] ?? "-"} - ${meal["strArea"] ?? "-"}"),
                  const SizedBox(height: 16),
                  const Text("Instruksi:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(meal["strInstructions"] ?? "-"),
                  const SizedBox(height: 16),
                  const Text("Bahan & Takaran:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  ...ingredients.map((ing) => Text("• $ing")),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
