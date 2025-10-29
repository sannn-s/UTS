class QuizItem {
  final String question;
  final String answer;

  QuizItem({required this.question, required this.answer});

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      question: json['question'],
      answer: json['answer'],
    );
  }
}