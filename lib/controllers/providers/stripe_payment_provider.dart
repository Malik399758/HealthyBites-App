import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentProvider extends ChangeNotifier {
  Map<String, dynamic>? paymentIntent;

  // make payment
  Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPayment('20', 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Yaseen Malik',
        ),
      );

      await displayPayment(context);
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  // display payment sheet
  Future<void> displayPayment(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      paymentIntent = null;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paid Successfully')),
      );
    } catch (e) {
      print('Display error ----->${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment cancelled or failed')),
      );
    }
  }

  // create payment
  createPayment(String amount, String currency) async {
    try {
      // body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount).toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      // response
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
            'Content-Type': 'application/x-www-form-urlencoded',
          });
      return jsonDecode(response.body.toString());
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  // calculate amount
  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price;
  }
}
