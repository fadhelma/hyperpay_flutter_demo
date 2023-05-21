import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 28),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 130,
              ),
              SizedBox(
                height: 7,
              ),
              Text('Your payment was successful'),
            ],
          ),
        ),
      ),
    );
  }
}