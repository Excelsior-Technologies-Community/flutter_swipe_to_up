class StoryModel {
  final String title;
  final String content;
  final String? imageUrl;
  final String? category;
  final DateTime? publishedAt;

  StoryModel({
    required this.title,
    required this.content,
    this.imageUrl,
    this.category,
    this.publishedAt,
  });

  // Convert from JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      category: json['category'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'category': category,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}