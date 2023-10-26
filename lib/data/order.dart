class CreateOrderParams {
  final String name;
  final String lastName;
  final String postalCode;
  final String phoneNumber;
  final String address;
  PaymentMethod paymentMethod;

  CreateOrderParams(this.name, this.lastName, this.postalCode, this.phoneNumber,
      this.address, this.paymentMethod);
}

enum PaymentMethod { directCash, cashOnDelivery }

