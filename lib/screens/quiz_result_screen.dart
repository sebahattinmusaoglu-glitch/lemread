import 'package:flutter/material.dart';
import 'package:lemread/models/category.dart';
import 'package:lemread/screens/category_detail_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final String articleTitle;
  final int? categoryId;
  final String? categoryName;

  const QuizResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.articleTitle,
    this.categoryId,
    this.categoryName,
  });

  String get _resultEmoji {
    final ratio = correct / total;
    if (ratio == 1.0) return '🏆';
    if (ratio >= 0.7) return '🎉';
    if (ratio >= 0.5) return '👍';
    return '📚';
  }

  String get _resultTitle {
    final ratio = correct / total;
    if (ratio == 1.0) return 'Mükemmel!';
    if (ratio >= 0.7) return 'Güçlü Başlangıç';
    if (ratio >= 0.5) return 'İyi İş!';
    return 'Tekrar Dene!';
  }

  String get _resultMessage {
    final ratio = correct / total;
    if (ratio == 1.0) return 'Bu konuyu tam anlamıyla kavradın!';
    if (ratio >= 0.7) return 'Çok iyi bir performans gösterdin.';
    if (ratio >= 0.5) return 'Biraz daha pratik yapmak ister misin?';
    return 'Makaleyi tekrar okumak faydalı olabilir.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F6FA),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 70,
                child: const Center(
                  child: Text(
                    'Testi Tamamladın',
                    style: TextStyle(
                      color: Color(0xFF1B1F3B),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    _resultEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _resultTitle,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1F3B),
                    ),
                  ),
                  const SizedBox(height: 12), 
                  Text(
                    _resultMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF787679),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16), 
                  // Skor kartı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$correct / $total',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Doğru Cevap',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: correct / total,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Testi tekrar çöz
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text(
                        'Makaleye Dön',
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
                  const SizedBox(height: 16),
                  // Kategoriye dön
                  if (categoryId != null && categoryName != null)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryDetailScreen(
                                category: Category(
                                  id: categoryId!,
                                  name: categoryName!,
                                ),
                              ),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6C63FF),
                          side: const BorderSide(color: Color(0xFF6C63FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          '$categoryName Kategorisine Dön',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Ana sayfaya dön
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Tüm Kategoriler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}