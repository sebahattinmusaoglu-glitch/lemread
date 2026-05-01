import 'package:flutter/material.dart';
import 'package:lemread/models/category.dart';
import 'package:lemread/services/supabase_service.dart';
import 'package:lemread/screens/category_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _service = SupabaseService();
  List<Category> _categories = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  final List<Color> _cardColors = [
    const Color(0xFF6C63FF),
    const Color(0xFFFF6584),
    const Color(0xFF43C6AC),
    const Color(0xFFFFB347),
    const Color(0xFF7EC8E3),
    const Color(0xFFB983FF),
  ];

  final List<String> _cardEmojis = [
    '🔬', '📜', '🎨', '🌍', '💡', '🎭',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _service.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          _buildComingSoon('Kaydedilenler'),
          _buildComingSoon('Profil'),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6C63FF),
          unselectedItemColor: const Color(0xFFB0B0B0),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Kaydedilenler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Lem',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                            TextSpan(
                              text: 'read',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bugün ne öğrenmek istersin?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Kategoriler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1F3B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = _categories[index];
                        final color =
                            _cardColors[index % _cardColors.length];
                        final emoji =

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryDetailScreen(
                                  category: category,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: category.iconUrl != null
            ? Image.network(
                category.iconUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            : Container(
                color: Colors.white.withOpacity(0.2),
                child: const Icon(
                  Icons.category_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        category.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
                          ),
                        );
                      },
                      childCount: _categories.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildComingSoon(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🚀', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Yakında',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1F3B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$title özelliği çok yakında geliyor!',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }
}