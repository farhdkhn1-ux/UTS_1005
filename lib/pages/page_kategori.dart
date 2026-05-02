import 'package:flutter/material.dart';
import 'page_list.dart';

class PageKategori extends StatelessWidget {
  final List<String> categories = [
    "Beef",
    "Chicken",
    "Dessert",
    "Lamb",
    "Pasta",
    "Pork",
    "Seafood",
    "Vegetarian",
  ];

  PageKategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Masakan")),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageList(category: category),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  category,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
