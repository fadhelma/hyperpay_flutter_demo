import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/Helper/constants.dart';
import 'package:hyperpay_flutter/Widgets/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Dialogs/add_card_dialog.dart';
import '../Modules/card_module.dart';

class SavedCards extends StatefulWidget {
  const SavedCards({Key? key}) : super(key: key);

  @override
  State<SavedCards> createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  late SharedPreferences _prefs;
  List<CardModule> cards = [];

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

  Future<void> saveCards() async {
    List<String> cardsStringList = cards.map((card) {
      final Map<String, dynamic> cardMap = card.toMap();
      return jsonEncode(cardMap);
    }).toList();
    await _prefs.setStringList('cards', cardsStringList);
  }

  void addCard(id, paymentType, cardNumber) {
    var newCard = CardModule(
      id: id,
      paymentType: paymentType,
      cardNumber: cardNumber,
    );
    setState(() {
      cards.add(newCard);
      saveCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Saved Cards',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            cards.isEmpty
                ? const Expanded(
                    child:
                        Center(child: Text('You have no cards at this moment')))
                : Expanded(
                    child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
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
                            GestureDetector(
                                onTap: () {
                                  removeCard(cards[index].id,
                                      cards[index].paymentType);
                                },
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      );
                    },
                  )),

            CustomButton(
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddCardDialog(callback: addCard);
                    },
                  );
                },
                title: 'Add a New Card'),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void removeCard(cardId, paymentType) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'DELETE', Uri.parse('${DefaultValues.API_URL}/delete-card/$cardId'));

    request.body = json.encode({"paymentType": paymentType});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if(jsonData['result']['code'] == "000.100.110"){
        print(jsonData['id']);
        setState(() {
          cards.removeWhere((card) => card.id == cardId);
          saveCards();
        });
      }


      // print(await response.stream.bytesToString());
      // setState(() {
      //   cards.removeWhere((card) => card.id == cardId);
      //   saveCards();
      // });
    } else {
      print(response.reasonPhrase);
    }
  }
}
