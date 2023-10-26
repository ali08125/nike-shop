part of 'shipping_bloc.dart';

abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class ShippingSubmit extends ShippingEvent {
  final CreateOrderParams params;

  const ShippingSubmit(this.params);
  @override
  List<Object> get props => [params];
}
