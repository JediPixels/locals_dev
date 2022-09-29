import 'dart:convert';

class LocalsFeed {
  LocalsFeed({
    required this.id,
    required this.authorId,
    required this.communityId,
    required this.text,
    required this.title,
    required this.likedByUs,
    required this.commentedByUs,
    required this.bookmarked,
    required this.timestamp,
    required this.totalPostViews,
    required this.isBlured,
    required this.authorName,
    required this.authorAvatarExtension,
    required this.authorAvatarUrl,
  });

  int id;
  int authorId;
  int communityId;
  String text;
  String title;
  bool likedByUs;
  bool commentedByUs;
  bool bookmarked;
  int timestamp;
  int totalPostViews;
  bool isBlured;
  String authorName;
  String authorAvatarExtension;
  String authorAvatarUrl;

  factory LocalsFeed.fromRawJson(String str) => LocalsFeed.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocalsFeed.fromJson(Map<String, dynamic> json) => LocalsFeed(
    id: json["id"],
    authorId: json["author_id"],
    communityId: json["community_id"],
    text: json["text"],
    title: json["title"],
    likedByUs: json["liked_by_us"],
    commentedByUs: json["commented_by_us"],
    bookmarked: json["bookmarked"],
    timestamp: json["timestamp"],
    totalPostViews: json["total_post_views"],
    isBlured: json["is_blured"],
    authorName: json["author_name"],
    authorAvatarExtension: json["author_avatar_extension"],
    authorAvatarUrl: json["author_avatar_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author_id": authorId,
    "community_id": communityId,
    "text": text,
    "title": title,
    "liked_by_us": likedByUs,
    "commented_by_us": commentedByUs,
    "bookmarked": bookmarked,
    "timestamp": timestamp,
    "total_post_views": totalPostViews,
    "is_blured": isBlured,
    "author_name": authorName,
    "author_avatar_extension": authorAvatarExtension,
    "author_avatar_url": authorAvatarUrl,
  };
}

// JSON
// {
//   "id": 44110,
//   "author_id": 11677,
//   "community_id": 992,
//   "text": "testesttkk",
//   "title": "test ets",
//   "liked_by_us": false,
//   "commented_by_us": false,
//   "bookmarked": false,
//   "timestamp": 1663793763,
//   "total_post_views": 4,
//   "is_blured": false,
//   "author_name": "Dave Rubin",
//   "author_avatar_extension": "png",
//   "author_avatar_url": "https://cdn.rr-qa.seasteaddigital.com/images/avatars/11677/11677_7t3pt14o7ori77f_thumb.png"
// }