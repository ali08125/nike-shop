class AddToCartResponse {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartResponse(this.cartItemId, this.productId, this.count);

  AddToCartResponse.fromJson(dynamic json)
      : cartItemId = json['id'],
        productId = json['product_id'],
        count = json['count'];
}
