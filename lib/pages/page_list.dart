import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'page_detail.dart';

class PageList extends StatefulWidget {
  final String category;
  const PageList({super.key, required this.category});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  late Future<List<Map<String, dynamic>>> futureMeals;
  List<Map<String, dynamic>> _results = [];
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    futureMeals = ApiService().fetchMealsByCategory(widget.category);
  }

  void _searchMeals(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _results = [];
        _error = "";
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = "";
    });

    try {
      final data = await ApiService().searchMeals(keyword);
      setState(() {
        _results = data;
        if (_results.isEmpty) {
          _error = "Maaf, masakan tidak ditemukan.";
        }
      });
    } catch (e) {
      setState(() {
        _error = "Terjadi error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Masakan: ${widget.category}")),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Cari masakan...",
              ),
              onChanged: (value) {
                _searchMeals(value);
              },
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          if (_error.isNotEmpty) Text(_error),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureMeals,
              builder: (context, snapshot) {
                final meals = _results.isNotEmpty
                    ? _results
                    : snapshot.data ?? [];

                if (snapshot.connectionState == ConnectionState.waiting &&
                    _results.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (meals.isEmpty) {
                  return const Center(child: Text("Tidak ada masakan ditemukan"));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PageDetail(meal: meal),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(meal["strMealThumb"], fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(meal["strMeal"], textAlign: TextAlign.center),
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
