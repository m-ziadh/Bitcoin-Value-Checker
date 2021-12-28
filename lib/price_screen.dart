import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show HttpHeaders, Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = 'USD';
  var rate = '0.0';

  Future<void> OnlineData() async {
    var response = await http.get(
      Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/USD'),
      headers: {
        HttpHeaders.authorizationHeader: '0B71E2AC-BD80-4C64-B27B-A9959AD7A2DC',
      },
    );
    final responseJson = jsonDecode(response.body);
    rate =  responseJson['rate'].toStringAsFixed(2);
  }

  CupertinoPicker IOSPicker() {
    List <Text> pickerData = [];
    for (String curr in currenciesList) {
      pickerData.add(Text(curr));
    }
    return CupertinoPicker(
        itemExtent: 35.0,
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (count){},
        children: pickerData,
    );
  }

  DropdownButton<String> AndriodPicker() {
    List<DropdownMenuItem<String>> pickerData = [];
    for (String curr in currenciesList) {
      var ddl = DropdownMenuItem(
        child: Text(curr),
        value: curr,
      );
      pickerData.add(ddl);
    }
    return DropdownButton<String>(
      value: currency,
      items: pickerData,
      onChanged: (value) {
        setState(() async{
          currency = value;
          OnlineData();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rate USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? IOSPicker() : AndriodPicker(),
          ),
        ],
      ),
    );
  }
}
