class CardModule {
  final String id;
  final String paymentType;
  final String cardNumber;

  CardModule(
      {required this.id, required this.paymentType, required this.cardNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentType': paymentType,
      'cardNumber': cardNumber,
    };
  }

  factory CardModule.fromMap(Map<String, dynamic> map) {
    return CardModule(
      id: map['id'],
      paymentType: map['paymentType'],
      cardNumber: map['cardNumber'],
    );
  }
}
