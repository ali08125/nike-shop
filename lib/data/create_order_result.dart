class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult(this.orderId, this.bankGatewayUrl);
  CreateOrderResult.fromJson(dynamic json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}
