class CardDataModel {
  String accNumber;

  String cardProvider;
  int cardNumber;
  String balance;

  String validThru;

  CardDataModel(
    this.accNumber,
    this.validThru,
    this.cardProvider,
    this.cardNumber,
    this.balance,
  );
}
