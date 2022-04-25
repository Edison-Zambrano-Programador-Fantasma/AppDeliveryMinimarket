import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse{
  String message;
  bool success;
  PaymentMethod paymentMethod;

  StripeTransactionResponse({this.message, this.success, this.paymentMethod});
}