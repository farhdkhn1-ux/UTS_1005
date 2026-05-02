import 'package:flutter/material.dart';
import 'package:uts_1005/services/api_service.dart';
import 'package:uts_1005/models/model_kategori.dart';
import 'page_list.dart';

class PageKategori extends StatefulWidget {
  const PageKategori({super.key});

  @override
  State<PageKategori> createState() => _PageKategoriState();
}

class _PageKategoriState extends State<PageKategori> {
  late Future<List<Category>> futureCategories;
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = ApiService().fetchCategories();
    futureCategories.then((data) {
      setState(() {
        _allCategories = data;
        _filteredCategories = data;
      });
    });
  }

  void _filterCategories(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories
            .where((cat) =>
            cat.strCategory.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Masakan")),
      backgroundColor: Colors.grey,
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Cari kategori...",

              ),
              onChanged: _filterCategories,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _allCategories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (_filteredCategories.isEmpty) {
                  return const Center(child: Text("Kategori tidak ditemukan"));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final cat = _filteredCategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PageList(category: cat.strCategory),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(cat.strCategoryThumb,
                                    fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(cat.strCategory,
                                    textAlign: TextAlign.center),
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
