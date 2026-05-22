import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'credit_state.dart';

class CreditCubit extends Cubit<CreditState> {
  CreditCubit() : super(CreditState());

  void updateCreditCard(CreditCardModel model) {
    emit(state.copyWith(
      cardNumber: model.cardNumber,
      expiryDate: model.expiryDate,
      cardHolderName: model.cardHolderName,
      cvvCode: model.cvvCode,
      isCvvFocused: model.isCvvFocused,
    ));
  }
}
