import 'package:flutter/material.dart';
import 'package:lemread/models/article.dart';
import 'package:lemread/screens/quiz_screen.dart';
import 'package:lemread/services/supabase_service.dart';
import 'package:lemread/models/category.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;
  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showQuizButton = false;
  String _categoryName = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    try {
      final service = SupabaseService();
      final categories = await service.getCategories();
      final category = categories.firstWhere(
        (c) => c.id == widget.article.categoryId,
        orElse: () => Category(id: 0, name: ''),
      );
      setState(() => _categoryName = category.name.toUpperCase());
    } catch (e) {
      setState(() => _categoryName = '');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent * 0.5) {
      if (!_showQuizButton) setState(() => _showQuizButton = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
  expandedHeight: 300,
  pinned: false,
  floating: false,
  backgroundColor: Colors.transparent,
  leading: GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.arrow_back_ios,
          color: Colors.white, size: 18),
    ),
  ),
  flexibleSpace: FlexibleSpaceBar(
    background: widget.article.imageUrl != null
        ? Image.network(
            widget.article.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _buildHeaderPlaceholder(),
          )
        : _buildHeaderPlaceholder(),
  ),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(32),
    child: Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
    ),
  ),
),
SliverToBoxAdapter(
  child: Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori etiketi
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _categoryName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.article.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1F3B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 20),
          Text(
            widget.article.body,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A4A4A),
              height: 1.8,
            ),
          ),
          const SizedBox(height: 40),
          AnimatedOpacity(
            opacity: _showQuizButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _showQuizButton
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              articleId: widget.article.id,
                              articleTitle: widget.article.title,
                              articleImageUrl: widget.article.imageUrl,
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.quiz_outlined),
                label: const Text(
                  'Testi Çöz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    ),
  ),
),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPlaceholder() {
    return Container(
      color: const Color(0xFF6C63FF),
      child: const Center(
        child: Icon(Icons.auto_stories, size: 80, color: Colors.white),
      ),
    );
  }
}