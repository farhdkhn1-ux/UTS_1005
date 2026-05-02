import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/daftar_kategori.dart';
import 'page_detail.dart';

class PageList extends StatefulWidget {
  final String category;
  const PageList({super.key, required this.category});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  late Future<DaftarCategory> futureMeals;

  @override
  void initState() {
    super.initState();
    futureMeals = ApiService().fetchMealsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meals - ${widget.category}")),
      body: FutureBuilder<DaftarCategory>(
        future: futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.meals.isEmpty) {
            return const Center(child: Text("Tidak ada meal ditemukan"));
          } else {
            final meals = snapshot.data!.meals;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // jumlah kolom
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 4, // rasio card
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PageDetail(idMeal: meal.idMeal),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            meal.strMealThumb,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            meal.strMeal,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
