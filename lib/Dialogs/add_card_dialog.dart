import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hyperpay_flutter/Helper/constants.dart';

class AddCardDialog extends StatefulWidget {
  final Function callback;

  const AddCardDialog({super.key, required this.callback});

  @override
  // ignore: library_private_types_in_public_api
  _AddCardDialogState createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _cardNumberText = TextEditingController();
  final _cardHolderText = TextEditingController();
  final _expiryMonthText = TextEditingController();
  final _expiryYearText = TextEditingController();

  // ignore: non_constant_identifier_names
  final _CVVText = TextEditingController();

  String paymentMethod = "MADA";

  bool _isButtonDisabled = true;

  bool inputsAreEmpty() {
    return _cardNumberText.text.isEmpty ||
        _cardHolderText.text.isEmpty ||
        _expiryMonthText.text.isEmpty ||
        _expiryYearText.text.isEmpty ||
        _CVVText.text.isEmpty;
  }

  void updateButtonState() {
    setState(() {
      _isButtonDisabled = inputsAreEmpty();
    });
  }

  @override
  void initState() {
    super.initState();
    _cardNumberText.addListener(updateButtonState);
    _cardHolderText.addListener(updateButtonState);
    _expiryMonthText.addListener(updateButtonState);
    _expiryYearText.addListener(updateButtonState);
    _CVVText.addListener(updateButtonState);
  }

  @override
  void dispose() async {
    _cardNumberText.dispose();
    _cardHolderText.dispose();
    _expiryMonthText.dispose();
    _expiryYearText.dispose();
    _CVVText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Select Your Payment Method'),
              const SizedBox(
                height: 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentMethod = "MADA";
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        decoration: BoxDecoration(
                            border: paymentMethod == "MADA"
                                ? Border.all(color: DefaultValues.mainColor)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          'images/MADA.jpg',
                          width: 60,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentMethod = "VISA";
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        decoration: BoxDecoration(
                            border: paymentMethod == "VISA"
                                ? Border.all(color: DefaultValues.mainColor)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          'images/VISA.jpg',
                          width: 60,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentMethod = "MASTER";
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        decoration: BoxDecoration(
                            border: paymentMethod == "MASTER"
                                ? Border.all(color: DefaultValues.mainColor)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          'images/MASTER.jpg',
                          width: 60,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Number',
                    counter: Offstage(),
                  ),
                  controller: _cardNumberText,
                  maxLength: 16,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Holder Name',
                  counter: Offstage(),
                ),
                controller: _cardHolderText,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expiry Month',
                        counter: Offstage(),
                      ),
                      controller: _expiryMonthText,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expiry Year',
                        hintText: "ex : 2027",
                        counter: Offstage(),
                      ),
                      controller: _expiryYearText,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  counter: Offstage(),
                ),
                controller: _CVVText,
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              Container(
                width: double.infinity, // Set width to full width
                height: 55,
                margin: const EdgeInsets.only(top: 10), // Optional margin
                child: ElevatedButton(
                  // onPressed: _pay,
                  onPressed: () {
                    if (_isButtonDisabled) {
                      print('complete the data');
                    } else {
                      cardRegistration();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _isButtonDisabled
                        ? Colors.grey
                        : DefaultValues.mainColor,
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cardRegistration() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${DefaultValues.API_URL}/register-card'));
    request.body = json.encode({
      "paymentType": paymentMethod,
      "holderName": _cardHolderText.text,
      "cardNumber": _cardNumberText.text,
      "month": _expiryMonthText.text,
      "year": _expiryYearText.text,
      "cvc": _CVVText.text
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if(jsonData['result']['code'] == "000.100.110"){
        print(jsonData['id']);
        widget.callback(jsonData['id'], paymentMethod,
            "**** **** **** ${jsonData['card']['last4Digits']}");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
