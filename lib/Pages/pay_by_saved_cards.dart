import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/Dialogs/payment_status_dialog.dart';
import 'package:hyperpay_flutter/Helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Modules/card_module.dart';

class PayBySavedCards extends StatefulWidget {
  const PayBySavedCards({Key? key}) : super(key: key);

  @override
  State<PayBySavedCards> createState() => _PayBySavedCardsState();
}

class _PayBySavedCardsState extends State<PayBySavedCards> {
  late SharedPreferences _prefs;
  List<CardModule> cards = [];
  String selectedCardId = "";
  String selectedCardMethod = "";

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? cardsStringList = _prefs.getStringList('cards');
    if (cardsStringList != null) {
      setState(() {
        cards = cardsStringList.map((cardString) {
          final Map<String, dynamic> cardMap =
              Map<String, dynamic>.from(jsonDecode(cardString));
          return CardModule.fromMap(cardMap);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Pay by Saved Cards',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              cards.isEmpty
                  ? const Expanded(
                      child: Center(
                          child: Text('You have no cards at this moment')))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCardId = cards[index].id;
                              selectedCardMethod = cards[index].paymentType;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 10),
                            decoration: BoxDecoration(
                                border: selectedCardId == cards[index].id
                                    ? Border.all(color: DefaultValues.mainColor)
                                    : Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/${cards[index].paymentType}.jpg',
                                      width: 55,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      cards[index].cardNumber,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                selectedCardId == cards[index].id
                                    ? const Icon(
                                        Icons.check_circle_outline,
                                        color: DefaultValues.mainColor,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedCardId == "") {
                      print('select card');
                    } else {
                      _pay();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: selectedCardId == ""
                        ? Colors.grey
                        : DefaultValues.mainColor, // Text color
                  ),
                  child: const Text(
                    'Pay Now 100.00 SAR',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pay() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${DefaultValues.API_URL}/one-click-payment'));
    request.body = json.encode({
      "paymentType": selectedCardMethod,
      "cardId": selectedCardId,
      "amount": "100.00"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if(jsonData['result']['code'] == "000.100.110"){
        print(jsonData['id']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PaymentDialog();
          },
        );
      }


      /// print(await response.stream.bytesToString());
      // ignore: use_build_context_synchronously
      /// showDialog(
      ///   context: context,
      ///   builder: (BuildContext context) {
      ///     return const PaymentDialog();
      ///   },
      /// );
    } else {
      print(response.reasonPhrase);
    }
  }
}
