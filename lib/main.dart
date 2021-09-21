import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'listamonedas.dart';

void main() => runApp(new MaterialApp(
      title: "Currency Converter",
      home: CurrencyConverter(),
    ));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String> currencies;

  String fromCurrency = "mxn";
  String toCurrency = "usd";
  String fromCurrencyDesc = "";
  String toCurrencyDesc = "";
  String result = "0.00";

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _getCurrenciesDesc(String curr) async {
    String desc = "";
    String uri =
        "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json";
    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    Map curMap = responseBody;
    desc = curMap[curr];
    // currenciesdesc = curMap.values.toList();
    setState(() {});
    return desc;
  }

  Future<String> _loadCurrencies() async {
    String uri =
        "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json";
    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    Map curMap = responseBody;
    currencies = curMap.keys.toList();
    // currenciesdesc = curMap.values.toList();
    fromCurrencyDesc = await _getCurrenciesDesc(fromCurrency);
    toCurrencyDesc = await _getCurrenciesDesc(toCurrency);
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri =
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api/latest/currencies/' +
            fromCurrency +
            '/' +
            toCurrency +
            '.json';

    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    setState(() {
      result =
          (double.parse(fromTextController.text) * (responseBody[toCurrency]))
              .toStringAsFixed(2);
    });
    print(result);
    return "Success";
  }

  _onFromChanged(String value) async {
    String temp = await _getCurrenciesDesc(value);
    setState(() {
      fromCurrency = value;
      fromCurrencyDesc = temp;
    });
  }

  _onToChanged(String value) async {
    String temp = await _getCurrenciesDesc(value);
    setState(() {
      toCurrency = value;
      toCurrencyDesc = temp;
    });
  }

  _intercambiaCurrency() {
    setState(() {
      String w = "";
      w = toCurrency;
      toCurrency = fromCurrency;
      fromCurrency = w;
      w = toCurrencyDesc;
      toCurrencyDesc = fromCurrencyDesc;
      fromCurrencyDesc = w;
    });
  }

  _reinicia() {
    setState(() {
      fromTextController.text = "";
      fromCurrency = "mxn";
      toCurrency = "usd";
      result = "0.00";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(fromCurrencyDesc, style: TextStyle(fontSize: 25)),
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.calculate),
                              onPressed: _doConversion,
                            ),
                            IconButton(
                              icon: Icon(Icons.sync),
                              onPressed: _intercambiaCurrency,
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _reinicia,
                            )
                          ]),
                      Text(toCurrencyDesc, style: TextStyle(fontSize: 25)),
                      ListTile(
                        title: Chip(
                          label: result != null
                              ? Text(
                                  result,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              : Text(""),
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                      //listamonedas()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }
}
