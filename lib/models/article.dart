class Article {
  final int id;
  final int categoryId;
  final String title;
  final String body;
  final String? imageUrl;

  Article({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['image_url'],
    );
  }
}