import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/Helper/constants.dart';
import 'package:hyperpay_flutter/Pages/direct_payment.dart';
import 'package:hyperpay_flutter/Pages/pay_by_saved_cards.dart';
import 'package:hyperpay_flutter/Pages/saved_cards.dart';

import 'Widgets/CustomButton.dart';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: DefaultValues.primaryColor,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Rekab Payments',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedCards()),
                    );
                  },
                  title: 'Saved Cards'),

              const SizedBox(height: 20),

              CustomButton(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PayBySavedCards()),
                    );
                  },
                  title: 'Pay by Saved Cards'),

              const SizedBox(height: 20),

              CustomButton(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DirectPayment()),
                    );
                  },
                  title: 'Direct Payment'),


            ],
          ),
        ),
      ),
    );
  }
}
