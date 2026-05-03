import 'package:flutter/material.dart';
import 'package:lemread/models/question.dart';
import 'package:lemread/services/supabase_service.dart';
import 'package:lemread/screens/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
final int articleId;
final String articleTitle;
final String? articleImageUrl;
final int? categoryId;
final String? categoryName;
const QuizScreen({
  super.key,
  required this.articleId,
  required this.articleTitle,
  this.articleImageUrl,
  this.categoryId,
  this.categoryName,
});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final SupabaseService _service = SupabaseService();
  List<Question> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions =
          await _service.getQuestionsByArticle(widget.articleId);
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _selectAnswer(String answer) {
    if (_answered) return;
    final correct = _questions[_currentIndex].correct;
    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == correct) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
          correct: _correctCount,
          total: _questions.length,
          articleTitle: widget.articleTitle,
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
        ),
        ),
      );
    }
  }

  Color _getOptionColor(String option) {
    if (!_answered) return Colors.white;
    final correct = _questions[_currentIndex].correct;
    if (option == correct) return const Color(0xFF43C6AC);
    if (option == _selectedAnswer) return const Color(0xFFFF6584);
    return Colors.white;
  }

  Color _getOptionTextColor(String option) {
    if (!_answered) return const Color(0xFF1B1F3B);
    final correct = _questions[_currentIndex].correct;
    if (option == correct || option == _selectedAnswer) return Colors.white;
    return const Color(0xFF1B1F3B);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            )
          : _questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bu makale için soru bulunamadı.',
                        style:
                            TextStyle(color: Color(0xFF787679), fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Geri Dön'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Üst görsel alan
                    SizedBox(
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.articleImageUrl != null
                              ? Image.network(
                                  widget.articleImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFF6C63FF),
                                  ),
                                )
                              : Container(color: const Color(0xFF6C63FF)),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 0, 12, 16),
                                    child: Text(
                                      widget.articleTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // İçerik
                    Expanded(
                      child: Padding( 
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // İlerleme çubuğu
                            Row(
                              children: [
                                Text(
                                  '${_currentIndex + 1}/${_questions.length}',
                                  style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: (_currentIndex + 1) /
                                          _questions.length,
                                      backgroundColor: const Color(0xFF6C63FF)
                                          .withOpacity(0.15),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF6C63FF)),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12), 
                            // Soru 
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _questions[_currentIndex].question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Şıklar
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  _buildOption(
                                      'a', _questions[_currentIndex].optionA),
                                  _buildOption(
                                      'b', _questions[_currentIndex].optionB),
                                  _buildOption(
                                      'c', _questions[_currentIndex].optionC),
                                  _buildOption(
                                      'd', _questions[_currentIndex].optionD),
                                ],
                              ),
                            ),
                            // Devam butonu
                            if (_answered) const SizedBox(height:8),
                            if (_answered)
                              SizedBox(
                                width: double.infinity,
                                height: 56, // 
                                child: ElevatedButton(
                                  onPressed: _nextQuestion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C63FF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    _currentIndex < _questions.length - 1
                                        ? 'Sonraki Soru'
                                        : 'Sonucu Gör',
                                    style: const TextStyle(
                                      fontSize: 18,
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

  Widget _buildOption(String key, String text) {
    return GestureDetector(
      onTap: () => _selectAnswer(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getOptionColor(key),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _answered
                ? Colors.transparent
                : const Color(0xFF6C63FF).withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getOptionColor(key) == Colors.white
                    ? const Color(0xFF6C63FF).withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  key.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getOptionTextColor(key),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: _getOptionTextColor(key),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_answered)
              Icon(
                key == _questions[_currentIndex].correct
                    ? Icons.check_circle
                    : key == _selectedAnswer
                        ? Icons.cancel
                        : null,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}