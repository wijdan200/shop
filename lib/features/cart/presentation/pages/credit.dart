import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttershop/features/cart/presentation/cubit/credit/credit_cubit.dart';
import 'package:fluttershop/features/cart/presentation/cubit/credit/credit_state.dart';

class credit extends StatefulWidget {
  const credit({super.key});

  @override
  State<credit> createState() => _creditState();
}

class _creditState extends State<credit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreditCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Credit Card'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<CreditCubit, CreditState>(
                builder: (context, state) {
                  return CreditCardWidget(
                    cardNumber: state.cardNumber,
                    expiryDate: state.expiryDate,
                    cardHolderName: state.cardHolderName,
                    cvvCode: state.cvvCode,
                    showBackView: state.isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: const Color.fromARGB(221, 40, 39, 39),
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange: (CreditCardBrand brand) {},
                    customCardTypeIcons: [],
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<CreditCubit, CreditState>(
                        builder: (context, state) {
                          return CreditCardForm(
                            formKey: formKey,
                            obscureCvv: true,
                            obscureNumber: true,
                            cardNumber: state.cardNumber,
                            cvvCode: state.cvvCode,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                            cardHolderName: state.cardHolderName,
                            expiryDate: state.expiryDate,
                            onCreditCardModelChange: (model) {
                              context.read<CreditCubit>().updateCreditCard(
                                model!,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: const Color(0xff1b447b),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print('valid!');
                          } else {
                            print('invalid!');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
