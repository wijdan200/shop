class CreditState {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isCvvFocused;

  CreditState({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
    this.isCvvFocused = false,
  });

  CreditState copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    bool? isCvvFocused,
  }) {
    return CreditState(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      isCvvFocused: isCvvFocused ?? this.isCvvFocused,
    );
  }
}
