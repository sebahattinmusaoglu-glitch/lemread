class Question {
  final int id;
  final int articleId;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correct;

  Question({
    required this.id,
    required this.articleId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      articleId: json['article_id'],
      question: json['question'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correct: json['correct'],
    );
  }
}