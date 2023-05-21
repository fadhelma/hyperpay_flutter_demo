import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hyperpay_flutter/Dialogs/payment_status_dialog.dart';
import 'package:hyperpay_flutter/Helper/constants.dart';

class DirectPayment extends StatefulWidget {
  const DirectPayment({Key? key}) : super(key: key);

  @override
  State<DirectPayment> createState() => _DirectPaymentState();
}

String _checkoutid = '';
String _resultText = '';
String _MadaRegexV =
    "4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)";
String _MadaRegexM =
    "5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))";

class _DirectPaymentState extends State<DirectPayment> {
  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');

  final _cardNumberText = TextEditingController();
  final _cardHolderText = TextEditingController();
  final _expiryMonthText = TextEditingController();
  final _expiryYearText = TextEditingController();
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
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Direct Payment',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
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
                        _pay();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _isButtonDisabled
                          ? Colors.grey
                          : DefaultValues.mainColor,
                    ),
                    child: const Text(
                      'Pay Now 100.00 SAR',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pay() async {
    if (_cardNumberText.text.isNotEmpty ||
        _cardHolderText.text.isNotEmpty ||
        _expiryMonthText.text.isNotEmpty ||
        _expiryYearText.text.isNotEmpty ||
        _CVVText.text.isNotEmpty) {
      _checkoutid = await _requestCheckoutId();

      String transactionStatus;
      try {
        final String result =
            await platform.invokeMethod('gethyperpayresponse', {
          "type": "CustomUI",
          "checkoutid": _checkoutid,
          "mode": "TEST",
          "brand": paymentMethod == "MADA" ? "mada" : paymentMethod,
          "card_number": _cardNumberText.text,
          "holder_name": _cardHolderText.text,
          "month": _expiryMonthText.text,
          "year": _expiryYearText.text,
          "cvv": _CVVText.text,
          "MadaRegexV": _MadaRegexV,
          "MadaRegexM": _MadaRegexM,
          "STCPAY": "disabled",
          "istoken": "false",
          "token": ""
        });
        transactionStatus = '$result';
      } on PlatformException catch (e) {
        transactionStatus = "${e.message}";
      }

      if (transactionStatus != null ||
          transactionStatus == "success" ||
          transactionStatus == "SYNC") {
        print('checkoutId_____');
        print(_checkoutid);
        getpaymentstatus(_checkoutid);
      } else {
        setState(() {
          _resultText = transactionStatus;
        });
      }
    } else {
      _showDialog();
    }
  }

  Future<void> getpaymentstatus(checkoutId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET',
        Uri.parse('${DefaultValues.API_URL}/payment-status/$checkoutId'));
    request.body = json.encode({"paymentType": paymentMethod});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if(jsonData['result']['code'] == "000.100.110"){
        print(jsonData['id']);
        print(jsonData['code']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PaymentDialog();
          },
        );
      }





      // ignore: use_build_context_synchronously
      // String responseData = await response.stream.bytesToString();
      // var jsonData = json.decode(responseData);
      /// print(await response.stream.bytesToString());

      // print(jsonData);

      // if(jsonData['result']['code'] == "000.100.110"){
      /// showDialog(
      ///   context: context,
      ///   builder: (BuildContext context) {
      ///     return const PaymentDialog();
      ///   },
      /// );
      // }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> _requestCheckoutId() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${DefaultValues.API_URL}/prepare-checkout'));
    request.body =
        json.encode({"paymentType": paymentMethod, "amount": "100.00"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("prepare-checkout");
    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      if (responseData.contains('error')) {
        return "null";
      } else {
        var jsonData = json.decode(responseData);
        print(jsonData);
        if(jsonData['result']['code'] == "000.200.100") {
          print(jsonData['id']);
          return jsonData['id'];
        }else{
          print('null');
          return "null";
        }
      }
    } else {
      print(response.reasonPhrase);
      return "null";
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Alert!"),
          content: const Text("Please fill all fields"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

