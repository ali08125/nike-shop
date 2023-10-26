class CommentEntity {
  final int id;
  final String title;
  final String content;
  final String date;
  final String email;

  // CommentEntity(this.id, this.title, this.content, this.date, this.email);
  CommentEntity.fromJson(dynamic json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}
