import 'package:flutter/material.dart';

class PageDetail extends StatelessWidget {
  final Map<String, dynamic> meal;
  const PageDetail({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    // Dummy detail manual
    final ingredients = [
      {"ingredient": "Ikan", "measure": "200 gram"},
      {"ingredient": "Bawang Putih", "measure": "2 siung"},
      {"ingredient": "Garam", "measure": "secukupnya"},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(meal["strMeal"])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal["strMealThumb"]),
            const SizedBox(height: 16),
            Text("Kategori: ${meal["strCategory"] ?? "Seafood"}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Asal: ${meal["strArea"] ?? "Indonesia"}"),
            const SizedBox(height: 16),
            const Text("Instruksi Memasak:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Masak bahan-bahan hingga matang, lalu sajikan dengan nasi hangat."),
            const SizedBox(height: 16),
            const Text("Bahan-bahan:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients.map((item) {
                return Text("- ${item['ingredient']} : ${item['measure']}");
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
