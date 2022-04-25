import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/src/models/stripe_transaction_response.dart';
import 'package:flutter_delivery_app/src/utils/my_snackbar.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeProvider {

  String secret = 'sk_test_51KS0oTE7JTHiUvJxbvcsLXd9anj0IMeFAUEL2uqoLt1BH3aZRQQByPThaRwz5oOGMQhE84p3FtfSq4eaNLjgxk6F00GGrzxa0g';
  Map<String, String> headers ={
    'Authorization': 'Bearer sk_test_51KS0oTE7JTHiUvJxbvcsLXd9anj0IMeFAUEL2uqoLt1BH3aZRQQByPThaRwz5oOGMQhE84p3FtfSq4eaNLjgxk6F00GGrzxa0g',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  BuildContext context;

  void init (BuildContext context){
    this.context = context;
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_51KS0oTE7JTHiUvJxBSbTKspBVbI9lOwGWVyDAxACnvbx15FEaYYnwpusFJPG5vFc5ORXNvgfNbQi4nDae18n02lh0075DmrG3M',
      merchantId: 'test',
      androidPayMode: 'test'
    ));
  }

  Future<StripeTransactionResponse> payWithCard(String amount, String currency) async{
    try{
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var paymentIntent = await createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
      ));

      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
          message: 'Transaccion exitosa',
          success: true,
          paymentMethod: paymentMethod
        );
      }
      else{
        return new StripeTransactionResponse(
            message: 'Transaccion fallida',
            success: false
        );
      }
    } catch(e) {
      print('Error al realizar la transaccion $e');
      MySnackbar.show(context, 'Error al realizar la transaccion $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency)async{

    try{
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      
      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');
      var response = await http.post(uri, body: body, headers: headers);
      return jsonDecode(response.body);
    }
    catch (e){
      print('Error al crear un intent de pagos $e');
      return null;
    }
  }
}