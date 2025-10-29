import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:funquiz_apps/main.dart'; // Impor untuk mengakses warna
import 'package:funquiz_apps/widgets/category_card.dart';

// --- Model Sederhana untuk Kategori ---
class Category {
  final String name;
  final IconData icon;
  Category({required this.name, required this.icon});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: _getIconData(json['icon']),
    );
  }
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'history': return Icons.history;
      case 'brightness_2_outlined': return Icons.brightness_2_outlined;
      case 'public': return Icons.public;
      case 'movie_outlined': return Icons.movie_outlined;
      case 'music_note_outlined': return Icons.music_note_outlined;
      case 'sports_soccer_outlined': return Icons.sports_soccer_outlined;
      case 'science_outlined': return Icons.science_outlined;
      case 'computer': return Icons.computer;
      default: return Icons.help_outline;
    }
  }
}
// --- Akhir Model ---

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    final String jsonString = await rootBundle.loadString('assets/categories.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonItem) => Category.fromJson(jsonItem)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // AppBar kita sekarang menggunakan tema dari main.dart
        leading: IconButton(
          icon: Icon(Icons.help_outline_rounded, color: kPrimaryColor),
          onPressed: () {},
        ),
        title: Text('Fun Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: kPrimaryColor, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Banner Baru ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kPrimaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Test Your Knowledge',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Tombol Random Quiz ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/quiz', arguments: "Random");
                  },
                  child: const Text('Start a Random Quiz'),
                ),
              ),
              const SizedBox(height: 24),

              // --- Kategori Grid ---
              Text(
                'Quiz Categories',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada kategori.'));
                  }

                  final categories = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1, // Sesuaikan rasio
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        icon: category.icon,
                        name: category.name,
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            '/quiz', 
                            arguments: category.name
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
