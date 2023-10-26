import 'package:dio/dio.dart';
import 'package:nike/data/create_order_result.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/payment_receipt.dart';
import 'package:nike/data/record.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
  Future<List<Record>> getRecords();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.name,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.phoneNumber,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.cashOnDelivery
          ? 'cash_on_delivery'
          : 'online'
    });
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<Record>> getRecords() async {
    final response = await httpClient.get('order/list');
    final List<Record> records = [];
    for (var element in (response.data as List)) {
      records.add(Record.fromJson(element));
    }
    return records;
  }
}
