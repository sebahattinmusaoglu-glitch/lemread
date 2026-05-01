import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final String articleTitle;

  const QuizResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.articleTitle,
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
    if (ratio >= 0.7) return 'Harika!';
    if (ratio >= 0.5) return 'İyi İş!';
    return 'Tekrar Dene!';
  }

  String get _resultMessage {
    final ratio = correct / total;
    if (ratio == 1.0) return 'Tüm soruları doğru yanıtladın!';
    if (ratio >= 0.7) return 'Çok iyi bir performans gösterdin.';
    if (ratio >= 0.5) return 'Biraz daha pratik yapabilirsin.';
    return 'Makaleyi tekrar okumak faydalı olabilir.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Emoji
              Text(
                _resultEmoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              // Başlık
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
                  color: Color(0xFF8A8A8A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Skor kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
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
                    // İlerleme çubuğu
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
              const Spacer(),
              // Makalelere dön butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst || 
                          route.settings.name == '/home',
                    );
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Makalelere Dön',
                    style: TextStyle(
                      fontSize: 18,
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
                    'Ana Sayfaya Dön',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}