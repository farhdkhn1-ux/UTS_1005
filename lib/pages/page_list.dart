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
  List<Meal> _allMeals = [];
  List<Meal> _filteredMeals = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureMeals = ApiService().fetchMealsByCategory(widget.category);
    futureMeals.then((data) {
      setState(() {
        _allMeals = data.meals;
        _filteredMeals = data.meals;
      });
    });
  }

  void _filterMeals(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredMeals = _allMeals;
      } else {
        _filteredMeals = _allMeals
            .where((meal) =>
            meal.strMeal.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Cari meal...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterMeals,
            ),
          ),
          Expanded(
            child: FutureBuilder<DaftarCategory>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _allMeals.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (_filteredMeals.isEmpty) {
                  return const Center(child: Text("Meal tidak ditemukan"));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _filteredMeals[index];
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
          ),
        ],
      ),
    );
  }
}
