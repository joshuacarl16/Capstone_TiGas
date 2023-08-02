// ignore_for_file: public_member_api_docs, sort_constructors_first
class Review {
  final int id;
  final String created;
  final String reviewerName;
  final int rating;
  final List<String> review;
  final String content;
  final int stationId;

  Review({
    required this.id,
    required this.created,
    required this.reviewerName,
    required this.rating,
    required this.review,
    required this.content,
    required this.stationId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      created: json['created'] ?? '',
      reviewerName: json['posted_by'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] != null
          ? List<String>.from(json['review'].map((x) => x.toString()))
          : [],
      content: json['comments'] ?? '',
      stationId: json['station'] ?? 0,
    );
  }
}
