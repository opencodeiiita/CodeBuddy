// problem.dart

class Problem {
  final String title;
  final double acRate;
  final String difficulty;
  final List<String> topicTags;
  final String questionFrontendId;

  Problem({
    required this.title,
    required this.acRate,
    required this.difficulty,
    required this.topicTags,
    required this.questionFrontendId,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      title: json['title'],
      acRate: json['acRate'],
      difficulty: json['difficulty'],
      topicTags: (json['topicTags'] as List<dynamic>)
          .map((tag) => tag['name'] as String)
          .toList(),
      questionFrontendId: json['questionFrontendId'],
    );
  }
}
