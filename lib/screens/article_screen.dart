import 'package:flutter/material.dart';
import 'package:lemread/models/article.dart';
import 'package:lemread/screens/quiz_screen.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;
  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showQuizButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
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
                      errorBuilder: (_, __, ___) => _buildHeaderPlaceholder(),
                    )
                  : _buildHeaderPlaceholder(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.article.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1F3B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 3,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
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
    );
  }

  Widget _buildHeaderPlaceholder() {
    return Container(
      color: const Color(0xFF6C63FF),
      child: const Center(
        child: Icon(
          Icons.auto_stories,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }
}