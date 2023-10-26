import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

const defaultScroll = BouncingScrollPhysics();

extension PriceLabel on int {
  String withPriceLabel() =>
      this > 0 ? '${'$this'.toPersianDigit().seRagham()} تومان' : 'رایگان';
}
