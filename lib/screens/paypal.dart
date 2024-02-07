import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:app_dimonis/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:provider/provider.dart';

class PayPal extends StatelessWidget {
  const PayPal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PaypalCheckout(
      sandboxMode: true,
      clientId:
          "AYT2USFxL71fN411wANicSiJfEfYgnH7lQJgYBVU64vv_s-xfqbToQY02cqhCAOYUDL24A6lzmptGgF3",
      secretKey:
          "EKD9lH8dIwfpA4TKwaauREXNGvGWoMqGX27igCDpC9oXXZhAywY0XRgJAH7ZxgduXwivzqPg2iCyy4ST",
      returnURL: "success.snippetcoder.com",
      cancelURL: "cancel.snippetcoder.com",
      transactions: const [
        {
          "amount": {
            "total": '70',
            "currency": "USD",
            "details": {
              "subtotal": '70',
              "shipping": '0',
              "shipping_discount": 0
            }
          },
          "description": "The payment transaction description.",
          "item_list": {
            "items": [
              {"name": "Apple", "quantity": 4, "price": '5', "currency": "USD"},
              {
                "name": "Pineapple",
                "quantity": 5,
                "price": '10',
                "currency": "USD"
              }
            ],
          }
        }
      ],
      note: "Contact us for any questions on your order.",
      onSuccess: (Map params) async {
        print('onSuccess: $params');
        final usersProvider =
            Provider.of<FireBaseProvider>(context, listen: false).usersProvider;
        print('update to prime');
        usersProvider.upgradeToPrime();
      },
      onError: (error) {
        print("onError: $error");
        Navigator.pop(context);
      },
      onCancel: () {
        print('cancelled:');
      },
    );
  }
}
