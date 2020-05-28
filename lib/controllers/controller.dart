import 'dart:math';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:juros_calculator/helpers/constants.dart';
import 'package:juros_calculator/models/payment_slip.dart';
import 'package:juros_calculator/models/result_payment_slip.dart';

class Controller {
  final moneyController = MoneyMaskedTextController();
  final feeController = MoneyMaskedTextController();
  final interestController = MoneyMaskedTextController();

  final paymentSlip = PaymentSlip(
    feeType: Constants.rateLabel[0],
    interestType: Constants.rateLabel[0],
    interestPeriod: Constants.periodLabel[0],
  );

  _calculateFeeValue(){
    var value = paymentSlip.feeValue;

    if (paymentSlip.feeType == Constants.rateLabel[1]){
      value = paymentSlip.feeValue / 100.0 * paymentSlip.money;
    }

    return value;
  }

  _calculateInterestValue(int days){
    var rate = paymentSlip.interestValue / 100.0;

    if (paymentSlip.interestType == Constants.rateLabel[0]){
      rate = paymentSlip.interestValue / paymentSlip.money;
    }

    var value = paymentSlip.money * pow(1 + rate, days);
    return value - paymentSlip.money;
  }

  ResultPaymentSlip calculate(){
    ResultPaymentSlip result = ResultPaymentSlip();
    result.value = paymentSlip.money;

    var payDate = DateTime(paymentSlip.payDate.year, paymentSlip.payDate.month, paymentSlip.payDate.day);
    var dueDate = DateTime(paymentSlip.dueDate.year, paymentSlip.dueDate.month, paymentSlip.dueDate.day);

    if (payDate.isAfter(dueDate)){
      
      // MULTA
      result.fee = _calculateFeeValue();
      result.value += result.fee;

      //JUROS
      result.days = paymentSlip.payDate.difference(paymentSlip.dueDate).inDays;
      if (paymentSlip.interestPeriod == Constants.periodLabel[1]){
        result.days = result.days ~/ 30;
      }

      result.interest = _calculateInterestValue(result.days);
      result.value += result.interest;
    }

    return result;
  }

  void clear(){
    moneyController.clear();
    feeController.clear();
    interestController.clear();
  }
}