import 'package:nike/data/common/http_client.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/create_order_result.dart';
import 'package:nike/data/payment_receipt.dart';
import 'package:nike/data/record.dart';
import 'package:nike/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) =>
      dataSource.getPaymentReceipt(orderId);

  @override
  Future<List<Record>> getRecords() => dataSource.getRecords();
}
