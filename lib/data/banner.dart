class BannerEntity {
  final int id;
  final String imageUrl;

  BannerEntity(this.id, this.imageUrl);

  BannerEntity.fromJson(dynamic json)
      : id = json['id'],
        imageUrl = json['image'];
}
