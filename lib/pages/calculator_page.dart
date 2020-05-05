import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:juros_calculator/controllers/controller.dart';
import 'package:juros_calculator/helpers/constants.dart';
import 'package:juros_calculator/models/result_payment_slip.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _moneyFormat = NumberFormat('#,##0.00', 'pt_BR');

  Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildForm(),
    );
  }

  _buildAppBar(){
    return AppBar(
      title: Text('Calculadora de Juros'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: (){},
        ), 
        IconButton (
          icon: Icon(Icons.info),
          onPressed: (){},
        ),
      ],
    );
  }

  _buildTitle(String title, {double top = 16, double bottom = 8}){
    return Container(
      padding: EdgeInsets.fromLTRB(0, top, 0, bottom),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _buildMoneyInputField(String label, {MoneyMaskedTextController controller, Function(String) onSaved}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      height: 60.0,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  _buildRateRadioButton({Function(dynamic) onChanged}){
    return CustomRadioButton(
      enableShape: true,
      elevation: 0,
      buttonColor: Theme.of(context).canvasColor,
      selectedColor: Theme.of(context).primaryColor,
      buttonLables: Constants.rateLabel,
      buttonValues: Constants.rateLabel,
      radioButtonValue: onChanged,
    );
  }

  _buildPeriodRadioButton({Function(dynamic) onChanged}){
    return CustomRadioButton(
      enableShape: true,
      elevation: 0,
      buttonColor: Theme.of(context).canvasColor,
      selectedColor: Theme.of(context).primaryColor,
      buttonLables: Constants.periodLabel,
      buttonValues: Constants.periodLabel,
      radioButtonValue: onChanged,
    );
  }

  _buildDataInputField(String label, {Function(DateTime) onSaved}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      height: 60.0,
      child: DateTimeField(
        format: _dateFormat,
        initialValue: DateTime.now(),
        onSaved: onSaved,
        onShowPicker: (context, currentValue){
          return showDatePicker(
            context: context, 
            initialDate: currentValue ?? DateTime.now(), 
            firstDate: DateTime(1900), 
            lastDate: DateTime(2100),
          );
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  _buildRoundedButton(String label, {Function onTap, EdgeInsets padding}){
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ), 
      ),
    );
  }

  _buildResultDialogRow(String label, String value){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, textAlign: TextAlign.left),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  _showResultDialog(ResultPaymentSlip result){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Resultado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildResultDialogRow('Atraso', '${result.days}'),
              _buildResultDialogRow('Juros', 'R\$ ${_moneyFormat.format(result.interest)}'),
              _buildResultDialogRow('Multa', 'R\$ ${_moneyFormat.format(result.fee)}'),
              SizedBox(height: 16.0),
              Divider(height: 0.1),
              SizedBox(height: 16.0),
              _buildResultDialogRow('Total', 'R\$ ${_moneyFormat.format(result.value)}'),
            ],
          ),
        );
      }
    );
  }

  _buildForm(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle('Informações do boleto'),
            _buildMoneyInputField(
              'Valor do boleto',
              controller: _controller.moneyController,
              onSaved: (value){
                _controller.paymentSlip.money = _controller.moneyController.numberValue;
              },
            ),
            _buildDataInputField(
              'Data de vencimento',
              onSaved: (date) {
                _controller.paymentSlip.dueDate = date;
             },
            ),
            _buildDataInputField(
              'Data de pagamento',
              onSaved: (date) {
                _controller.paymentSlip.payDate = date;
             },
            ),
            _buildTitle('Multa'),
            _buildMoneyInputField(
              'Valor da multa',
              controller: _controller.feeController,
              onSaved: (value){
                _controller.paymentSlip.feeValue = _controller.feeController.numberValue;
             },
            ),
            _buildRateRadioButton(
              onChanged: (value) {
                _controller.paymentSlip.feeType = value;
              },
            ),
            _buildTitle('Juros'),
            _buildMoneyInputField(
              'Valor do juros',
              controller: _controller.interestController,
              onSaved: (value){
                  _controller.paymentSlip.interestValue = _controller.interestController.numberValue;
              },
            ),
            _buildRateRadioButton(
              onChanged: (value) {
                _controller.paymentSlip.interestType = value;
              },
            ),
            _buildPeriodRadioButton(
              onChanged: (value) {
                _controller.paymentSlip.interestPeriod = value;
              },
            ),
            _buildRoundedButton(
              'CALCULAR', 
              padding: EdgeInsets.only(top: 32.0),
              onTap: (){
                if (_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  var result = _controller.calculate();
                  _showResultDialog(result);
                }
              }
            ),
            _buildRoundedButton(
              'LIMPAR', 
              padding: EdgeInsets.symmetric(vertical: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}
