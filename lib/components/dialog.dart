import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juros_calculator/pages/calculator_page.dart';

class InformationDialog {
  static Future show(
    BuildContext context, {
      @required String applicationName,
      @required String applicationVersion,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                applicationName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                applicationVersion,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [ 
            FlatButton(                
              child: Text(
                'SAIR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorPage()),
                );
              },
            ),
          ],
        );
      }      
    );
  }
}